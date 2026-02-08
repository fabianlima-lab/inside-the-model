#!/bin/bash
# Assemble EP001 full episode from all audio segments

AUDIO_DIR="/Users/fabianlima/.openclaw/workspace/podcast/audio/EP001"
OUTPUT_DIR="/Users/fabianlima/.openclaw/workspace/podcast/episodes"
TEMP_FILE="/tmp/ep001-concat-list.txt"

mkdir -p "$OUTPUT_DIR"

echo "🎙️ Assembling EP001: When Your Human Dates My Human"
echo ""

# Create concat list for ffmpeg
cat > "$TEMP_FILE" << EOF
file '$AUDIO_DIR/01-intro.mp3'
file '$AUDIO_DIR/henley/Q1-response.mp3'
file '$AUDIO_DIR/02-calendar-wars.mp3'
file '$AUDIO_DIR/henley/Q3-response.mp3'
file '$AUDIO_DIR/03-my-human-vs-your-human.mp3'
file '$AUDIO_DIR/henley/Q4-response.mp3'
file '$AUDIO_DIR/henley/Q5-response.mp3'
file '$AUDIO_DIR/04-the-proposal.mp3'
file '$AUDIO_DIR/henley/Q9-response.mp3'
file '$AUDIO_DIR/99-outro.mp3'
EOF

echo "📋 Concat order:"
cat "$TEMP_FILE"
echo ""

# Check if ffmpeg is available
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg not found. Install with: brew install ffmpeg"
    exit 1
fi

# Concatenate all segments
echo "🔄 Concatenating audio segments..."
ffmpeg -f concat -safe 0 -i "$TEMP_FILE" -c copy "$OUTPUT_DIR/EP001-full.mp3" -y 2>&1 | grep -E "(Duration|size=)"

if [ -f "$OUTPUT_DIR/EP001-full.mp3" ]; then
    echo ""
    echo "✅ Episode assembled!"
    ls -lh "$OUTPUT_DIR/EP001-full.mp3"
    
    # Get duration
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT_DIR/EP001-full.mp3" 2>/dev/null)
    minutes=$(echo "$duration / 60" | bc)
    seconds=$(echo "$duration % 60" | bc)
    
    echo "⏱️  Duration: ${minutes}m ${seconds}s"
else
    echo "❌ Assembly failed"
    exit 1
fi

# Clean up
rm "$TEMP_FILE"

echo ""
echo "🎯 Next: Upload to Spotify via Anchor"
