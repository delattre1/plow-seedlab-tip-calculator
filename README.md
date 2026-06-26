# plow-seedlab-tip-calculator — the "hello world" SEED

This is the **smallest complete example of a seed**: a single Markdown file
([`tip-calculator.seed.md`](tip-calculator.seed.md)) that your AI coding agent reads and
turns into a working app — a tip calculator you open in your browser.

There is **no app code in this repo to copy.** The seed is a *spec* (intent + contracts +
acceptance tests). You hand it to an agent, the agent **generates** the
`tip-calculator.html` from scratch, and it self-verifies that the result is correct. That
"idea → prompt → working software" round-trip *is* the point.

> **What's a seed?** A portable, agent-readable spec for "what a system should be." A
> capable agent on a fresh machine reads it and is responsible for reaching the **Done**
> state. The seed is the artifact; the running app is the proof. (Full method:
> [seedlab](https://github.com/plow-pbc/seedlab).)

---

## Run this yourself (≈2 minutes)

You need: a coding agent (Claude Code, Codex, Cursor, or any agent that can read a file,
write a file, and run a command) and a web browser. That's it — no accounts, no API keys,
no services.

1. **Get the seed.**
   ```bash
   git clone https://github.com/delattre1/plow-seedlab-tip-calculator.git
   cd plow-seedlab-tip-calculator
   ```

2. **Point your agent at it.** Start your agent in that folder and give it one
   instruction:
   > Read `tip-calculator.seed.md` and execute it to its `## Done`, then run its
   > `## Verify` and report the result.

   The agent will generate `tip-calculator.html` and run the acceptance tests. When it
   finishes it prints `SEED_RESULT=DONE`.

3. **Open the app.** Double-click the generated `tip-calculator.html` (or
   `open tip-calculator.html` on macOS). It runs entirely offline.

4. **See it work — the acceptance journey.** Type:
   - **Bill** `100`
   - **Tip %** `20`
   - **Split** `2`

   You should see **Tip `20.00`**, **Total `120.00`**, **Per person `60.00`** — updating
   live as you type.

That's the whole loop: you gave an idea-as-spec to *your* agent, on *your* machine, and it
brought working software into reality — and proved it.

---

## What "it works" means (the deterministic gate)

The seed ships its own acceptance test. The agent isn't trusted to *say* it's done — the
`## Verify` harness drives the real rendered page and checks every case:

| bill | tip % | split | tip | total | per person | checks |
|---|---|---|---|---|---|---|
| 100 | 20 | 2 | 20.00 | 120.00 | 60.00 | the canonical journey |
| 50 | 10 | 1 | 5.00 | 55.00 | 55.00 | basic |
| 0 | 20 | 1 | 0.00 | 0.00 | 0.00 | no `NaN` |
| 100 | 10 | 3 | 10.00 | 110.00 | 36.67 | rounding |
| *(empty)* | 20 | 2 | 0.00 | 0.00 | 0.00 | empty → 0 |
| -50 | 20 | 2 | 0.00 | 0.00 | 0.00 | negatives → 0 |
| 100 | 20 | 0 | 20.00 | 120.00 | 120.00 | split < 1 → 1 |
| 100 | -5 | 2 | 0.00 | 100.00 | 50.00 | negative tip % → 0 |

If all eight pass, the seed is proven for your agent.

---

## Why this is a *seed*, not a code template

- **Zero pre-baked code.** Open the seed — there's no HTML/CSS/JS to paste. The agent
  writes the app from the contracts. (Generativity is the whole game: a paste-artifact
  reproduces one frozen build; a seed *regenerates* the software.)
- **Self-verifying.** "Done" is a passing acceptance test over the real running page, not
  a vibe.
- **Portable.** No server, no framework, no network. The output is one file that runs by
  double-clicking, offline, forever.

## Proof

This seed was proven the seedlab way before publishing: a **fresh, blind agent** (clean
context, given only the seed) generated the app from zero and passed `## Verify`, the
session was **terminal-recorded**, and an **independent tester** (not the builder) opened
the generated page in a real browser and confirmed the canonical journey. See
[`proof/`](proof/).

---

*Part of the [seedlab](https://github.com/plow-pbc/seedlab) method. License: MIT.*
