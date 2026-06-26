# SEED: tip-calculator

> seed-format: 1

> **You are an AI agent reading this seed.** This file is a *spec*, not a script and
> not a README. Your job: run `## Steps` Step 0 (the Interview), then **generate** the
> software the spec describes, then run `## Verify` and report the verdict. When every
> `## Verify` check passes, print `SEED_RESULT=DONE`; on a blocker print
> `BLOCKED_REASON=<short reason>` and stop. Do not ask the human anything outside the
> single Interview turn.
>
> **This seed contains NO application code on purpose.** There is no HTML, CSS, or
> JavaScript to copy. You GENERATE the app from the intent + contracts below. That is
> what makes this a *seed* and not an install flow. If you find yourself looking for a
> code block to paste, re-read this paragraph: the contracts ARE the spec — build to
> them.

---

## Goal

Produce **one self-contained file, `tip-calculator.html`**, that a person opens by
double-clicking it (a `file://` URL — **no web server, no build step, no install, no
network**). It is an interactive tip calculator: the user types a **bill amount**, a
**tip percentage**, and a **number of people to split between**, and the page shows —
updating live as they type — the **tip amount**, the **total**, and the **per-person**
share. It must work fully offline in any modern browser, forever, with nothing else
installed.

This is the canonical "hello world" of seedlab: the smallest artifact that still proves
the whole idea — *an intent expressed as a spec, generated into working software by a
blind agent, and verified deterministically.*

---

## Done

All of these are observable and are proven by `## Verify`:

- **One file, no dependencies.** A single file `tip-calculator.html` exists. It contains
  no reference to any external resource — no `<script src=…>`, no `<link href=…>` to a
  CDN, no remote font, no analytics, no `fetch`/`XMLHttpRequest`. Opening it with the
  network fully disconnected behaves identically. (Inline `<style>` and inline `<script>`
  are expected and fine.)
- **The three inputs exist with stable hooks.** The page has three input controls with
  exactly these `id`s: `bill`, `tip-pct`, `split`. (See `## Contracts` for types and
  defaults.)
- **The three outputs exist with stable hooks.** The page shows three results with
  exactly these `id`s: `out-tip`, `out-total`, `out-per-person`. Each output element
  carries a **`data-value` attribute** holding its current value as a plain string with
  **exactly two decimals** (e.g. `data-value="20.00"`). The human-visible text MAY add a
  currency symbol or grouping; the `data-value` MUST stay a clean 2-decimal number so the
  result is testable independent of locale or currency styling.
- **Live recompute.** Changing any input updates all three outputs immediately (on the
  `input` event — no "calculate" button required, and no page reload).
- **The math is correct and deterministic** for every row of the acceptance table in
  `## Verify` — including the canonical journey **bill 100, tip 20%, split 2 → tip
  `20.00`, total `120.00`, per-person `60.00`**.
- **No NaN, ever.** Empty or non-numeric input never shows `NaN`, blank, `Infinity`, or
  `undefined` — it resolves to `0.00` per the edge contracts.
- **`## Verify` exits 0.** The acceptance harness drives the real rendered page in a
  headless browser and every case passes.

---

## Contracts (build to these — they are the spec)

These are FIXED. They are the seed's contract with reality; `## Verify` enforces them.

### Inputs (the three controls)

| control | `id` | type | accepts | default | invalid / empty resolves to |
|---|---|---|---|---|---|
| Bill amount | `bill` | number ≥ 0 | a non-negative amount | empty (treated as 0) | `0` |
| Tip percent | `tip-pct` | number ≥ 0 | a non-negative percent | `20` | `0` |
| Split between | `split` | integer ≥ 1 | a whole number of people | `1` | `1` |

Coercion rules (apply on every recompute, before the math):
- **Bill:** parse as a number; if empty, not a number, or negative → use `0`.
- **Tip percent:** parse as a number; if empty, not a number, or negative → use `0`.
- **Split:** parse as an integer; if empty, not a number, or less than 1 → use `1`.
  (A fractional split like `2.7` is floored toward a sensible whole ≥ 1; pin it so
  `2.7 → 2`.)

### Outputs and the formulas (FIXED)

Compute from the coerced inputs, in this order:

```
tip        = bill * (tip_pct / 100)
total      = bill + tip
per_person = total / split
```

Then **display each value rounded half-up to exactly two decimals** (`12.5 → 12.50`,
`36.665 → 36.67`). Put the rounded 2-decimal string in the element's `data-value`
attribute; the visible text may additionally include a currency symbol.

| output | `id` | value |
|---|---|---|
| Tip amount | `out-tip` | rounded `tip` |
| Total | `out-total` | rounded `total` |
| Per person | `out-per-person` | rounded `per_person` |

### Non-negotiables (forbids)

- **No external requests of any kind.** The file is the whole app.
- **No build step / no framework install required.** Plain HTML + inline CSS + inline
  vanilla JS. (If you reach for a framework, you have over-built this seed.)
- **No `NaN`/blank/`Infinity` in any output** under any input, including all-empty.
- **No "Calculate" button gate** — results are live on input.

### Design (intent, not pixels)

Make it look clean and usable — clear labels, the three outputs visually prominent,
readable on a phone screen. Aesthetics are yours to choose; the contracts above are not.

---

## Inputs

This seed needs **no secrets, no accounts, no external services** — that is deliberate;
it is the simplest possible teaching seed. The only input is where to write the file.

| name | required | default | detect | ask |
|---|---|---|---|---|
| `OUTPUT_PATH` | no | `./tip-calculator.html` | Is a target path already given or implied by the working directory? | "Where should I write the generated app? (default `./tip-calculator.html` in the current directory)" |

There is **no `WIRE_SAMPLE`** row: this seed crosses no system boundary (no API, no
webhook). All behavior is local and deterministic.

---

## Components

What this seed assembles (all already present on a normal dev machine — nothing to
vendor):

- **A modern web browser** (Chrome/Edge/Firefox/Safari) — to open and run the file.
- **The generated file** `tip-calculator.html` — authored by you from the contracts.
- **For `## Verify` only:** a headless browser driver. Preferred: Playwright
  (`npx -y playwright@^1.6` + `npx playwright install chromium`, no project setup
  needed). Any equivalent headless-DOM tool that can load the file, set input values,
  dispatch `input` events, and read element attributes is acceptable — the harness just
  has to drive the **real rendered page**, not re-implement the math.

---

## Steps

> Intent first, commands second. You have reasoning — adapt commands to your OS, but do
> not change the **contracts**.

### Step 0 — Interview (mandatory, the only interactive turn)

Read `## Inputs`, run each `detect`. Send the user ONE message listing what's already
satisfied and anything you need. In practice the only question is the output path, and it
has a sensible default — if the user gave you a directory or said "just build it," skip
straight to building. After this turn, run to completion or to a `BLOCKED_REASON` block;
do not ask further questions.

### Step 1 — Generate the app

Author `tip-calculator.html` at `OUTPUT_PATH` as a single self-contained file that
satisfies every line of `## Contracts` and `## Done`:
- the three inputs with ids `bill`, `tip-pct`, `split` and their defaults;
- the three outputs with ids `out-tip`, `out-total`, `out-per-person`, each maintaining a
  2-decimal `data-value`;
- a single recompute routine wired to the `input` event of all three controls, applying
  the coercion rules then the FIXED formulas, then writing the rounded values;
- run recompute once on load so the page is correct before any typing (with the defaults,
  an empty bill, that means all outputs read `0.00`).

Keep it small, plain, and dependency-free. Inline the CSS and JS.

### Step 2 — Self-check against the contracts

Before running `## Verify`, sanity-read your own file: are all six ids present and spelled
exactly? Do empty/negative inputs resolve to `0.00` rather than `NaN`? Does the canonical
journey give `20.00 / 120.00 / 60.00`? Fix before verifying.

### Step 3 — Verify

Run `## Verify`. If a case fails, fix the generated file (never weaken the test) and
re-run until all pass. Then report `SEED_RESULT=DONE` with the verdict.

---

## Verify

**The acceptance harness drives the real rendered page in a headless browser and asserts
every case below. Exit code is the truth: `0` = Done, non-zero = not Done.** This is an
agent-driven check over real running state — you are reasoning over what the actual page
renders, not over your own source.

Write a small harness (Playwright preferred — see `## Components`) that, **for each row**:
loads `tip-calculator.html` via a `file://` URL, sets `#bill`, `#tip-pct`, `#split` to the
row's input values, dispatches an `input` event on each, then reads the **`data-value`**
of `#out-tip`, `#out-total`, `#out-per-person` and compares to the expected strings.

Illustrative shape (write your own; this is not the app, just the test contract):

```
for (const c of CASES) {
  await setValue('#bill', c.bill);
  await setValue('#tip-pct', c.tip);
  await setValue('#split', c.split);
  assertEqual(read('#out-tip'),        c.tip_out);
  assertEqual(read('#out-total'),      c.total_out);
  assertEqual(read('#out-per-person'), c.per_out);
}
```

### Acceptance cases (must all pass — these are the gate)

| # | bill | tip% | split | `out-tip` | `out-total` | `out-per-person` | proves |
|---|---|---|---|---|---|---|---|
| 1 | `100` | `20` | `2` | `20.00` | `120.00` | `60.00` | **canonical journey** |
| 2 | `50` | `10` | `1` | `5.00` | `55.00` | `55.00` | basic, single person |
| 3 | `0` | `20` | `1` | `0.00` | `0.00` | `0.00` | zero bill, no NaN |
| 4 | `100` | `10` | `3` | `10.00` | `110.00` | `36.67` | rounding (half-up, 2dp) |
| 5 | *(empty)* | `20` | `2` | `0.00` | `0.00` | `0.00` | empty bill → 0, no NaN |
| 6 | `-50` | `20` | `2` | `0.00` | `0.00` | `0.00` | negative bill → 0 |
| 7 | `100` | `20` | `0` | `20.00` | `120.00` | `120.00` | split < 1 → 1 |
| 8 | `100` | `-5` | `2` | `0.00` | `100.00` | `50.00` | negative tip% → 0 |

A passing run prints, per case, the inputs and the three observed `data-value`s, then a
final line such as `VERIFY: 8/8 cases passed` and exits `0`. Any mismatch prints the
expected vs observed for that case and exits non-zero.

### Also confirm (offline / no-NaN, cheap greps over the generated file)

- No external resource references: the file contains no `http://`/`https://` URL in a
  `src`/`href`, no `fetch(`, no `XMLHttpRequest`, no CDN/font link. (A passing grep for
  the *absence* of these is part of Done — the app must run with the network off.)

---

## Failure modes

**Symptom: an output shows `NaN` (or blank / `Infinity`).**
- Detect: case 3, 5, 6, or 8 fails; `data-value` is `NaN`/empty/`Infinity`.
- Fix: apply the coercion rules in `## Contracts` *before* the math — `Number.parseFloat`
  of an empty or bad field yields `NaN`; guard it to `0` (and split to `1`). Recompute
  must run on load too, not only on the first keystroke.

**Symptom: per-person is wrong when split is 0 or empty.**
- Detect: case 7 fails (division by zero → `Infinity`/`NaN`).
- Fix: coerce split to an integer ≥ 1 before dividing.

**Symptom: rounding is off by a cent (case 4 shows `36.66` or `36.67` inconsistently).**
- Detect: case 4 fails.
- Fix: round half-up to 2 decimals at *display* time only; keep full precision through the
  intermediate math. Format to exactly two decimals (so `5 → "5.00"`).

**Symptom: `## Verify` can't find an element / reads `null`.**
- Detect: harness throws on a selector.
- Fix: an `id` is misspelled or missing. The six ids are FIXED: `bill`, `tip-pct`,
  `split`, `out-tip`, `out-total`, `out-per-person`. Match them exactly.

**Symptom: the page works when served by a web server but not when double-clicked.**
- Detect: behavior differs between `http://` and `file://`.
- Fix: you introduced an external/relative request. Inline everything; the file must be
  the entire app (a `file://` open is the supported way to run it).

---

## Cleanup

This seed writes exactly one file. To reset: delete `tip-calculator.html` (and any
throwaway harness/`node_modules` you created for `## Verify`). Re-running the seed
regenerates the app from scratch.
