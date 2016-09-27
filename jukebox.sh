# Reference: http://sox.sourceforge.net/sox.html

if [ $# -lt 2 ]; then
  echo "Usage: $0 [songname] [tempo in bpm]";
  exit 1;
fi

# Get arguments
S="$1" # Song name
T=$(($2)) # Tempo: 77bpm approx 1.54 note duration

# Chord Library
F="pl F2 pl C2 pl F3 pl A3 pl C4 pl F4"
Am="pl E2 pl A2 pl E3 pl A3 pl C4 pl E4"
G="pl G2 pl B2 pl D2 pl G3 pl B4 pl G4"
C="pl G2 pl C2 pl E3 pl G3 pl C4 pl E4"
D="pl D2 pl D2 pl A3 pl A3 pl D4 pl F#4"
Em="pl E2 pl B2 pl E3 pl G3 pl B4 pl E4"

# Calculate Internal Vars
ND=$(echo "100/$T" | bc -l) # Note Delay
SD="+0.04" # String Delay

# Initialize the song, length, and chord "cursor"
song=""
length=0
pos=0


# Function for appending chords to the song
append()
{	
	for chord in "$@"
	do
	  start=$(echo "$pos" | bc -l)
	  end=$(echo "$start + 1.5*$ND" | bc -l)
	  song="$song\"|sox -n -p synth $chord delay $start $SD $SD $SD $SD $SD remix - fade 0 $end 0.5\" "
	  pos=$(echo "$pos + $ND" | bc -l)
	done
	length=$pos
}


# Building the actual song
case "$S" in
	emily)
		# Verse
		append "$C" "$G" "$Am" "$G"
		append "$F" "$F" "$C" "$G"
		append "$C" "$G" "$Am" "$G"
		append "$F" "$F" "$C" "$G"

		# PreChorus
		append "$G" "$G" "$G"

		# Chorus
		append "$Am" "$Am" "$F" "$F"
		append "$C" "$C" "$G" "$G"
		append "$Am" "$Am" "$F" "$F"
		append "$G" "$G" "$G" "$G"

		# Verse
		append "$C" "$G" "$Am" "$G"
		append "$F" "$F" "$C" "$G"
		append "$C" "$G" "$Am" "$G"
		append "$F" "$F" "$C" "$G"

		# Outro
		append "$C" "$C" "$C" "$C"
		;;
	freebird)
		# Verse
		append "$G" "$D" "$Em" "$Em"
		append "$F" "$C" "$D" "$D"
		append "$G" "$D" "$Em" "$Em"
		append "$F" "$C" "$D" "$D"
		;;
esac

# Play It!
eval "/usr/local/bin/play $song --combine merge fade 0 $length 0 norm 5"