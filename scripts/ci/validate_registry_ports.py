#!/usr/bin/env python3
"""Static validation for carbon-vcpkg-registry ports (no vcpkg binary required)."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PORTS = ROOT / "ports"
FOUNDATION = ("carbon-core", "carbon-math", "carbon-scheduler")


def main() -> int:
    errors: list[str] = []
    if not PORTS.is_dir():
        print("ports/ missing", file=sys.stderr)
        return 1

    for port_dir in sorted(p for p in PORTS.iterdir() if p.is_dir()):
        manifest = port_dir / "vcpkg.json"
        if not manifest.is_file():
            errors.append(f"{port_dir.name}: missing vcpkg.json")
            continue
        try:
            data = json.loads(manifest.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            errors.append(f"{manifest}: JSON error: {exc}")
            continue
        name = data.get("name")
        if name != port_dir.name:
            errors.append(f"{manifest}: name {name!r} != directory {port_dir.name}")
        if not any(k in data for k in ("version", "version-semver", "version-date", "version-string")):
            errors.append(f"{manifest}: missing version field")

    for name in FOUNDATION:
        if not (PORTS / name / "vcpkg.json").is_file():
            errors.append(f"missing foundation port {name}")

    baseline = ROOT / "versions" / "baseline.json"
    if not baseline.is_file():
        errors.append("missing versions/baseline.json")
    else:
        try:
            json.loads(baseline.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            errors.append(f"baseline.json: {exc}")

    scheduler = PORTS / "carbon-scheduler" / "vcpkg.json"
    if scheduler.is_file():
        sched = json.loads(scheduler.read_text(encoding="utf-8"))
        supports = sched.get("supports", "")
        if "linux" not in supports:
            errors.append(
                "carbon-scheduler supports missing linux "
                "(standalone fork documents linux-capable port)"
            )

    for err in errors:
        print(err, file=sys.stderr)
    if errors:
        return 1
    print(f"registry ports OK ({len(list(PORTS.iterdir()))} port directories)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
