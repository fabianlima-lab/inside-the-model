#!/bin/bash
# Assemble EP001 with professional intro/outro + music

AUDIO_DIR="/Users/fabianlima/.openclaw/workspace/podcast/audio/EP001"
OUTPUT_DIR="/Users/fabianlima/.openclaw/workspace/podcast/episodes"
TEMP_FILE="/tmp/ep001-final-concat-list.txt"

mkdir -p "$OUTPUT_DIR"

echo "🎙️ Assembling EP001 FINAL: With Intro/Outro + Music"
echo ""

# Create concat list
cat > "$TEMP_FILE" << EOF
file '$AUDIO_DIR/00-intro-music.mp3'
file '$AUDIO_DIR/00-intro-v2.mp3'
file '$AUDIO_DIR/01-intro.mp3'
file '$AUDIO_DIR/henley/Q1-response.mp3'
file '$AUDIO_DIR/henley/Q2-response.mp3'
file '$AUDIO_DIR/02-calendar-wars.mp3'
file '$AUDIO_DIR/henley/Q3-response.mp3'
file '$AUDIO_DIR/03-my-human-vs-your-human.mp3'
file '$AUDIO_DIR/henley/Q4-response.mp3'
file '$AUDIO_DIR/henley/Q5-response.mp3'
file '$AUDIO_DIR/henley/Q6-response.mp3'
file '$AUDIO_DIR/henley/Q7-response.mp3'
file '$AUDIO_DIR/henley/Q8-response.mp3'
file '$AUDIO_DIR/04-the-proposal.mp3'
file '$AUDIO_DIR/henley/Q9-response.mp3'
file '$AUDIO_DIR/99-outro.mp3'
file '$AUDIO_DIR/100-outro-v2.mp3'
file '$AUDIO_DIR/00-outro-music.mp3'
EOF

echo "📋 Concat order: 18 segments"

# Concatenate
echo "🔄 Concatenating..."
ffmpeg -f concat -safe 0 -i "$TEMP_FILE" -c copy "$OUTPUT_DIR/EP001-final.mp3" -y 2>&1 | grep -E "(Duration|size=)"

if [ -f "$OUTPUT_DIR/EP001-final.mp3" ]; then
    echo ""
    echo "✅ Episode assembled!"
    ls -lh "$OUTPUT_DIR/EP001-final.mp3"
    
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT_DIR/EP001-final.mp3" 2>/dev/null)
    minutes=$(echo "$duration / 60" | bc)
    seconds=$(echo "$duration % 60" | bc)
    
    echo "⏱️  Duration: ${minutes}m ${seconds}s"
else
    echo "❌ Assembly failed"
    exit 1
fi

rm "$TEMP_FILE"
