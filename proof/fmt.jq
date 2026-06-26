# Pretty-prints claude -p --output-format stream-json events into a readable trace.
# Genuine surfacing of real events — no fabrication.
if .type == "system" and .subtype == "init" then
  "── blind agent session start (model: \(.model)) ──"
elif .type == "assistant" then
  ( .message.content[]? |
    if .type == "text" and (.text|gsub("\\s";"")|length) > 0 then
      "🧠 " + (.text | gsub("\n"; "\n   "))
    elif .type == "tool_use" then
      "🔧 " + .name + "  " +
      ( .input.file_path // .input.command // .input.path //
        (.input | tojson | .[0:140]) )
    else empty end )
elif .type == "user" then
  ( .message.content[]? |
    if .type == "tool_result" then
      "   ↳ " + ( (.content // "") | if type=="array" then (.[0].text // "") else . end | gsub("\n";" ") | .[0:160] )
    else empty end )
elif .type == "result" then
  "── session end: \(.subtype) (\(.num_turns) turns, \(.duration_ms/1000|floor)s) ──"
else empty end
