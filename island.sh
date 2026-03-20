#!/usr/bin/env python3
"""
Island Packers Round-Trip Availability Checker

Monitors round-trip availability for day trips to Prisoners Harbor and
Scorpion Anchorage on March 28-29 for 2 people, targeting ~5 hours on island.

Usage:
    python3 island_packers_checker.py              # Check once
    python3 island_packers_checker.py --watch      # Poll every 2 minutes
    python3 island_packers_checker.py --watch -i 60  # Poll every 60 seconds
"""

import argparse
import json
import subprocess
import sys
import time
import urllib.request
from datetime import datetime

GRAPHQL_URL = "https://my.hornblower.com/graphql"
NTFY_TOPIC = "island-packers-test-2026"

TARGET_DATES = ["2026-03-28", "2026-03-29"]
MIN_SPOTS = 2
IDEAL_ISLAND_HOURS = 5
MIN_ISLAND_HOURS = 3

TARGET_TOURS = {
    1114190: {
        "name": "Prisoners Harbor Day Trip",
        "url": "https://www.islandpackers.com/book/prisoners-harbor-day-trip/",
        "crossing_hours": 1.5,
    },
    1114085: {
        "name": "Day Trip at Scorpion Anchorage",
        "url": "https://www.islandpackers.com/book/day-trip-at-scorpion-anchorage/",
        "crossing_hours": 1.0,
    },
}

GRAPHQL_QUERY = """
query {
  searchTours(
    propertyId: "island"
    startDate: "%s"
    endDate: "%s"
    includeAvailability: true
    includeOnlyAvailable: false
  ) {
    tourId
    bookingTypeId
    tourName
    permalink
    localizedInfo { locale values { id value } }
    availability {
      StartDate StartTime EndTime
      vacancy SeatsAvailable Capacity
      TimedTicketTypeId fromStopId toStopId
    }
    stops { id name }
  }
}
"""


def fetch_tours() -> list:
    query = GRAPHQL_QUERY % (TARGET_DATES[0], TARGET_DATES[-1])
    payload = json.dumps({"query": query}).encode("utf-8")
    req = urllib.request.Request(
        GRAPHQL_URL,
        data=payload,
        headers={
            "Content-Type": "application/json",
            "Origin": "https://www.islandpackers.com",
            "Referer": "https://www.islandpackers.com/",
        },
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    if "errors" in data and data["errors"]:
        raise RuntimeError(f"GraphQL errors: {data['errors']}")
    return data.get("data", {}).get("searchTours", [])


def time_to_hours(t: str) -> float:
    parts = t.split(":")
    return int(parts[0]) + int(parts[1]) / 60


def fmt12(t: str) -> str:
    parts = t.split(":")
    h = int(parts[0])
    m = parts[1]
    ampm = "AM" if h < 12 else "PM"
    if h == 0:
        h = 12
    elif h > 12:
        h -= 12
    return f"{h}:{m} {ampm}"


def pad(t: str) -> str:
    return ":".join(p.zfill(2) for p in t.split(":"))


VENTURA_STOP = 1494


def analyze_tour(tour: dict) -> dict:
    """Parse a tour into outbound/return slots by date."""
    stops = {s["id"]: s["name"] for s in (tour.get("stops") or [])}
    info = TARGET_TOURS.get(tour["bookingTypeId"], {})

    result = {"name": info.get("name", tour.get("tourName", "?")),
              "url": info.get("url", tour.get("permalink", "")),
              "crossing_hours": info.get("crossing_hours", 1.0),
              "dates": {}}

    for a in tour.get("availability", []):
        date = a["StartDate"][:10]
        from_id = a.get("fromStopId", 0) or 0
        to_id = a.get("toStopId", 0) or 0
        vacancy = a.get("vacancy", 0) or 0

        slot = {
            "time": a["StartTime"],
            "time_padded": pad(a["StartTime"]),
            "time_12h": fmt12(a["StartTime"]),
            "vacancy": vacancy,
            "capacity": a.get("Capacity", 0),
            "ttid": a.get("TimedTicketTypeId"),
            "from_stop": stops.get(from_id, f"stop-{from_id}"),
            "to_stop": stops.get(to_id, f"stop-{to_id}"),
        }

        if date not in result["dates"]:
            result["dates"][date] = {"outbound": [], "return": []}

        if from_id == VENTURA_STOP:
            result["dates"][date]["outbound"].append(slot)
        else:
            result["dates"][date]["return"].append(slot)

    for d in result["dates"].values():
        d["outbound"].sort(key=lambda x: x["time_padded"])
        d["return"].sort(key=lambda x: x["time_padded"])

    return result


def find_roundtrips(tour_data: dict) -> list:
    """Find viable round-trip combos for MIN_SPOTS people with ~5h on island."""
    combos = []
    crossing = tour_data["crossing_hours"]

    for date, legs in tour_data["dates"].items():
        for out in legs["outbound"]:
            if out["vacancy"] < MIN_SPOTS:
                continue
            arrive_hour = time_to_hours(out["time"]) + crossing

            for ret in legs["return"]:
                if ret["vacancy"] < MIN_SPOTS:
                    continue
                depart_hour = time_to_hours(ret["time"])
                island_time = depart_hour - arrive_hour

                if island_time < MIN_ISLAND_HOURS:
                    continue

                combos.append({
                    "date": date,
                    "depart_mainland": out,
                    "return_mainland": ret,
                    "island_hours": round(island_time, 1),
                    "near_ideal": abs(island_time - IDEAL_ISLAND_HOURS) <= 1.5,
                })

    combos.sort(key=lambda c: (c["date"], abs(c["island_hours"] - IDEAL_ISLAND_HOURS)))
    return combos


def print_report(all_tours: list):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"\n{'=' * 72}")
    print(f"  Island Packers Round-Trip Checker — {now}")
    print(f"  Looking for: {MIN_SPOTS} spots, ~{IDEAL_ISLAND_HOURS}h on island")
    print(f"  Dates: {', '.join(TARGET_DATES)}")
    print(f"{'=' * 72}")

    any_viable = False

    for tour_raw in all_tours:
        if tour_raw["bookingTypeId"] not in TARGET_TOURS:
            continue

        tour = analyze_tour(tour_raw)
        print(f"\n  {'─' * 68}")
        print(f"  {tour['name']}")
        print(f"  {tour['url']}")
        print(f"  Crossing time: ~{tour['crossing_hours']}h each way")
        print(f"  {'─' * 68}")

        for date in sorted(tour["dates"]):
            legs = tour["dates"][date]
            weekday = datetime.strptime(date, "%Y-%m-%d").strftime("%A")
            print(f"\n  {date} ({weekday}):")

            print(f"    OUTBOUND (Ventura → Island):")
            for s in legs["outbound"]:
                ok = s["vacancy"] >= MIN_SPOTS
                marker = " ✓" if ok else " ✗"
                status = f"{s['vacancy']} spots" if ok else "SOLD OUT" if s["vacancy"] <= 0 else f"only {s['vacancy']} spot"
                print(f"     {marker} {s['time_12h']:>10}  — {status}")

            print(f"    RETURN (Island → Ventura):")
            for s in legs["return"]:
                ok = s["vacancy"] >= MIN_SPOTS
                marker = " ✓" if ok else " ✗"
                status = f"{s['vacancy']} spots" if ok else "SOLD OUT" if s["vacancy"] <= 0 else f"only {s['vacancy']} spot"
                print(f"     {marker} {s['time_12h']:>10}  — {status}")

        combos = find_roundtrips(tour)
        if combos:
            any_viable = True
            print(f"\n    VIABLE ROUND-TRIP OPTIONS ({MIN_SPOTS}+ spots each leg):")
            for c in combos:
                star = " ★" if c["near_ideal"] else "  "
                weekday = datetime.strptime(c["date"], "%Y-%m-%d").strftime("%a")
                print(
                    f"    {star} {c['date']} ({weekday}): "
                    f"Depart {c['depart_mainland']['time_12h']} → "
                    f"Return {c['return_mainland']['time_12h']}  "
                    f"({c['island_hours']}h on island, "
                    f"{c['depart_mainland']['vacancy']}/{c['return_mainland']['vacancy']} spots)"
                )
        else:
            print(f"\n    ⚠ NO viable round-trips for {MIN_SPOTS} people on these dates.")

    if any_viable:
        print(f"\n  {'*' * 60}")
        print(f"  ★ = within {IDEAL_ISLAND_HOURS}h ± 1.5h ideal island time")
        print(f"  {'*' * 60}")
    else:
        print(f"\n  {'!' * 60}")
        print(f"  ALL MORNING OUTBOUND DEPARTURES ARE SOLD OUT.")
        print(f"  The script will keep watching for cancellations.")
        print(f"  {'!' * 60}")
    print()

    return any_viable


def notify(title: str, message: str):
    try:
        subprocess.run(["notify-send", "-u", "critical", title, message], check=False, timeout=5)
    except FileNotFoundError:
        pass

    try:
        payload = message.encode("utf-8")
        req = urllib.request.Request(
            f"https://ntfy.sh/{NTFY_TOPIC}",
            data=payload,
            headers={
                "Title": title,
                "Priority": "urgent",
                "Tags": "boat,warning",
            },
        )
        with urllib.request.urlopen(req, timeout=10) as resp:
            resp.read()
        print(f"  [ntfy] Push notification sent to topic '{NTFY_TOPIC}'")
    except Exception as e:
        print(f"  [ntfy] Failed to send: {e}", file=sys.stderr)


def get_combo_keys(all_tours: list) -> set:
    keys = set()
    for tour_raw in all_tours:
        if tour_raw["bookingTypeId"] not in TARGET_TOURS:
            continue
        tour = analyze_tour(tour_raw)
        for c in find_roundtrips(tour):
            keys.add(f"{tour['name']}|{c['date']}|{c['depart_mainland']['time']}|{c['return_mainland']['time']}")
    return keys


def main():
    parser = argparse.ArgumentParser(description="Island Packers round-trip checker")
    parser.add_argument("--watch", action="store_true", help="Continuously poll")
    parser.add_argument("-i", "--interval", type=int, default=120, help="Poll interval in seconds (default: 120)")
    args = parser.parse_args()

    if not args.watch:
        tours = fetch_tours()
        has_viable = print_report(tours)
        if has_viable:
            notify("Island Packers", "Round-trip spots available! Check terminal.")
        return

    print(f"Watching every {args.interval}s for round-trip availability ({MIN_SPOTS} people)... Ctrl+C to stop")
    prev_keys = set()

    while True:
        try:
            tours = fetch_tours()
            has_viable = print_report(tours)
            current_keys = get_combo_keys(tours)
            new_keys = current_keys - prev_keys

            if new_keys:
                lines = []
                for tour_raw in tours:
                    if tour_raw["bookingTypeId"] not in TARGET_TOURS:
                        continue
                    tour = analyze_tour(tour_raw)
                    for c in find_roundtrips(tour):
                        key = f"{tour['name']}|{c['date']}|{c['depart_mainland']['time']}|{c['return_mainland']['time']}"
                        if key in new_keys:
                            wd = datetime.strptime(c["date"], "%Y-%m-%d").strftime("%a")
                            lines.append(
                                f"{tour['name']}\n"
                                f"{c['date']} ({wd}): {c['depart_mainland']['time_12h']} → {c['return_mainland']['time_12h']} "
                                f"({c['island_hours']}h on island)\n"
                                f"Spots: {c['depart_mainland']['vacancy']} out / {c['return_mainland']['vacancy']} return\n"
                                f"Book: {tour['url']}"
                            )
                notify(
                    "Island Packers — Spots Available!",
                    "\n\n".join(lines) if lines else f"{len(new_keys)} new option(s)!",
                )
            prev_keys = current_keys

        except Exception as e:
            print(f"[{datetime.now().strftime('%H:%M:%S')}] Error: {e}", file=sys.stderr)

        time.sleep(args.interval)


if __name__ == "__main__":
    main()
