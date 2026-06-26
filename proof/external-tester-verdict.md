# External tester verdict — Tip Calculator

**Tester:** an independent agent (validator ≠ builder) — did NOT build the app, did NOT see the seed.
**Method:** opened the generated `tip-calculator.html` in a real Chrome browser (chrome-devtools),
and acting as a real user typed into the on-screen fields: Bill = 100, Tip % = 20, Split = 2.

**Observed (live, no reload):**

| Field | Value shown |
|---|---|
| Tip | **$20.00** |
| Total | **$120.00** |
| Per person | **$60.00** |

Expected vs actual: Tip 20.00 ✓ · Total 120.00 ✓ · Per-person 60.00 ✓ — all three match exactly.

## Verdict: ✅ PASS

Screenshot: `external-tester-screenshot.png` (full page, real browser).

Signed,
**external-tester**
