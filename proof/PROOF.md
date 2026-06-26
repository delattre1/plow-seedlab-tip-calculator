# Proof — this seed is generative and it works

This folder is the evidence that `tip-calculator.seed.md` is a **true generative seed**:
a blind agent turns the spec into working software, and an independent tester confirms it.

## 1. Generativity — a blind agent generated the app from zero

A fresh `claude` agent with **clean context** was dropped in an empty directory containing
**only the seed** (verified: `app-code lines found in seed: 0`). It was given one
instruction — "read the seed and execute it." With no pasted code to copy, it:

- read `tip-calculator.seed.md`,
- **generated** `tip-calculator.html` (a single self-contained file, ~180 lines), and
- ran the seed's `## Verify` over the **real rendered page** in a headless browser.

Result: **`VERIFY: 8/8 cases passed`** → `SEED_RESULT=DONE`, including the canonical journey
**bill 100 + tip 20% + split 2 → tip 20.00 / total 120.00 / per-person 60.00** and every edge
case (empty→0, negatives→0, split<1→1, rounding).

- Terminal recording: [`blind-hydrate.cast`](blind-hydrate.cast) (asciicast — replay with
  `asciinema play blind-hydrate.cast`)
- Readable transcript: [`blind-hydrate.transcript.txt`](blind-hydrate.transcript.txt)
- The exact file the agent generated: [`tip-calculator.generated.html`](tip-calculator.generated.html)

## 2. External validation — an independent tester confirmed it in a real browser

A **separate** agent (validator ≠ builder — it did not build the app or see the seed) opened
the generated file in a **real Chrome browser**, typed `100 / 20% / 2` into the on-screen
fields like a user, and read the live results: **Tip $20.00 · Total $120.00 · Per person
$60.00**. Signed verdict: **✅ PASS**.

- Screenshot of the actual running app: [`external-tester-screenshot.png`](external-tester-screenshot.png)
- Signed verdict: [`external-tester-verdict.md`](external-tester-verdict.md)
- Terminal recording: [`external-tester.cast`](external-tester.cast) ·
  [`external-tester.transcript.txt`](external-tester.transcript.txt)

## How to reproduce

Everything here is reproducible on your own machine with your own agent — see the
[top-level README](../README.md). The `.cast` files are genuine asciinema recordings of the
real sessions (not rendered images); `fmt.jq` is the formatter that turned the agent's raw
event stream into the readable trace you see in the transcripts.
