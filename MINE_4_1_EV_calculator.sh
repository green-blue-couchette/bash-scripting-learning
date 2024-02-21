#!/bin/bash

# Author: O.A.
# Usage: $./MINE_4_1_EV_calculator.sh

# ABOUT: CALCULATE THE EXPOSURE VALUE (EV) FOR YOUR CAMERA SETTINGS. (Film roll's reciprocity behavior for long exposures also available.)

# FORMULAS:
# * EV = Log_base2(100 * Aperture² / ISO * Shutter Speed )
#   (EV formula taken from this web page: https://www.omnicalculator.com/other/exposure)
# * Shutter Speed (s) = 100 * Aperture² / ISO * 2^EV

# Changelog:
# (2024-02-16): First idea and minimal version implemented.
# (2024-02-20): Added option to 1) Calculate ISO, Aperture, Shutter time --> EV; 2) Calculate EV, ISO, Aperture --> Shutter time; 3) Display EV table.
# (2024-02-21): Fixed calculation formulas and implementations for ISO, Aperture, Shutter time --> EV;
# 		Fixed calculation formulas and implementations for EV, ISO, Aperture --> Shutter time;
#		Implemented displaying EV table;
#		General fixes in comments and code.
#		Added option 4) Display common ISO and Aperture (F-stop) values.

# Outline...
# Ask user what they want to calculate...
# 1. ISO, Aperture, Shutter time --> EV
# 2. EV, ISO, Aperture --> Shutter time
# 3. Show EV table and quit

# TODO (could): x. Option to show different combinations of aperture/shutter time to get the same EV value?

# TODO: For 1, fetch explanation of calculated reciprocity value from a lookup table (case statements?)
# TODO: For 1, ask if user wants RECIPROCITY FOR THE SHUTTER TIME. (Recommended over 1s exposure.)
# TODO: For 2, ask if user wants RECIPROCITY for the shutter time.
# 	Fetch reciprocity from a lookup table of film rolls (Gold 200, UltraMax 400, Fomapan 400, ILFORD HP5+, Velvia 100) (case statements). Default to grainydays' formula if reciprocity data is unavailable for a film roll.
#
# TODO: Before reciprocity calculation is done...
# Echo FORMULA
# Echo which values have been plugged into the formula
# Echo result to the user.
#
# TODO: Polish "read" statements to accept input on same line as the output text.

# Rounding and ceil/floor sources:
#https://duckduckgo.com/?q=bash+ceiling+function&t=brave&atb=v378-1&ia=web
#https://codechacha.com/en/shell-script-ceiling-halfup-floor/
#https://duckduckgo.com/?q=round+off+decimal+in+bash&t=brave&atb=v378-1&ia=web
#https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash


# Function definitions START
function EV_table(){ # A lookup table. Echoes out the explanation of a given EV value (integers only)
# expects $1 (an integer [-7, 20] or a string["title", "source", "table_header"])

case $1 in
"title")
	echo "===== EV TABLE ====="
	;;
"source")
	echo "Source: https://www.omnicalculator.com/other/exposure"
	echo ""
	;;
"table_header")
	echo "EV	Lighting condition"
	echo "--------------------------"
	;;
-7)
	echo "-7	Deep star field or the Milky Way."
	;;
-6)
	echo "-6	Night under starlight only or the Aurora Borealis."
	;;
-5)
	echo "-5	Night under crescent moon or the Aurora Borealis."
	;;
-4)
	echo "-4	Night under half moon, or a meteor shower (with long exposure duration)."
	;;
-3)
	echo "-3	Night under full moon and away from city lights."
	;;
-2)
	echo "-2	Night snowscape under full moon and away from city lights."
	;;
-1)
	echo "-1	Start (sunrise) or end (sunset) of the "blue hour" (outdoors) or dim ambient lighting (indoors)."
	;;
0)
	echo "0	Dim ambient artificial lighting."
	;;
1)
	echo "1	Distant view of a lit skyline."
	;;
2)
	echo "2	Under lightning (with time exposure) or a total lunar eclipse."
	;;
3)
	echo "3	Fireworks (with time exposure)."
	;;
4)
	echo "4	Candle-lit close-ups, Christmas lights, floodlight buildings, fountains, or bright street lamps."
	;;
5)
	echo "5	Home interiors at night, fairs and amusement parks."
	;;
6)
	echo "6	Brightly lit home interiors at night, fairs and amusement parks."
	;;
7)
	echo "7	Bottom of a rainforest canopy, or along brightly-lit night-time streets."
	echo "	Floodlit indoor sports areas or stadiums, and stage shows, including circuses."
	;;
8)
	echo "8	Store windows, campfires, bonfires, ice shows,"
	echo "	Floodlit indoor sports areas or stadiums, and interiors with bright fluorescent."
	;;
9)
	echo "9	Landscapes, city skylines 10 minutes after sunset, neon lights."
	;;
10)
	echo "10	Landscapes and skylines immediately after sunset, capturing a crescent moon using a long lens."
	;;
11)
	echo "11	Sunsets. Subject to deep shade."
	;;
12)
	echo "12	Open shade or heavy overcast, capturing half moon using long lens."
	;;
13)
	echo "13	Cloudy-bright light (no shadows), capturing gibbous moon using long lens."
	;;
14)
	echo "14	Weak hazy sun, rainbows (soft shadows), capturing the full moon using long lens."
	;;
15)
	echo "15	Bright or hazy sun, clear sky (distinct shadows)."
	;;
16)
	echo "16	Bright daylight on sand or snow (distinct shadows)."
	;;
17)
	echo "17	Very bright artificial lighting."
	;;
18)
	echo "18	Very bright artificial lighting."
	;;
19)
	echo "19	Very bright artificial lighting."
	;;
20)
	echo "20+	Extremely bright artificial lighting, telescopic view of the sun."
	;;
esac
}
# Function definitions END

echo "===== Simple EV calculator ====="
echo "I want to calculate..."
echo "1. ISO, Aperture, Shutter Speed --> EV"
echo "2. EV, ISO, Aperture --> Shutter speed (exposure time) [This option is good for long exposure situations.]"
echo "3. Display EV table"
echo "4. Display common ISO and Aperture (F-Stop) values"

read menu_choice
echo ""

if [[ $menu_choice == 1 ]]; then
	# Ask for inputs
	# Do calculations
	# Print results

	echo "Formula: EV = Log_base2( 100 * aperture² / ISO * shutter speed )"
	echo ""

	echo "Enter film's ISO:"
	read ISO

	echo "Enter Aperture (F-Stop):"
	read aperture

	echo "Enter Shutter Speed (s):"
	read shutter_speed

	# dummy values (debug and demoing)
	# ISO=400
	# aperture=11
	# shutter_speed=0,01
	# Gives EV = 11.56, aka EV is 11 or 12

	aperture_squared=$( bc -l <<< "$aperture^2" )
	aperture_over_exposure_time=$( bc -l <<< "scale=4; ((100 * $aperture_squared)/($ISO * $shutter_speed))" ) # the division we will take the logarithm of
	EV=$(bc -l <<< "l($aperture_over_exposure_time)/l(2)") # calculates the base-2 logarithm
	echo ""
	echo "EV = $EV"

	# Round value and display an explanation of calculated EV value.
	EV_rounded=$(/usr/bin/printf "%.0f" $EV)
	# python3 -c "print(round(3.4))" # Alternative solution for rounding
	echo "Suitable for this lighting situation..."
	EV_table $EV_rounded

elif [[ $menu_choice == 2 ]]; then
	# Ask for inputs
	# Do calculations
	# Print results

	echo "Formula: Shutter speed (s) = 100 * Aperture² / ISO * 2^EV"
	echo ""

	echo "Enter EV:"
	read EV

	echo "Enter film's ISO:"
	read ISO

	echo "Enter Aperture (F-Stop):"
	read aperture

	aperture_squared=$( bc -l <<< "$aperture^2" )
	two_to_power_of_EV=$( bc -l <<< "2^$EV ")
	exposure_time=$( bc -l <<< "scale=4; ((100 * $aperture_squared)/($ISO * $two_to_power_of_EV))" )
	echo ""
	echo "Exposure time = $exposure_time seconds"

	# TODO:
	# If exposure time is above 1s, ask if user wants to correct for reciprocity (Y/n). Pre-selected reciprocity calculation formula is for Ilford HP5+. Or the fallback-formula?
	# TA = TM^p (fallback formula)
	# echo "Calculate time adjusted for reciprocity? (Y/n)"

elif [[ $menu_choice == 3 ]]; then
	# Display EV table and quit

	for EV_value in "title" "source" "table_header" {-7..20};
	do
		EV_table $EV_value
	done

elif [[ $menu_choice == 4 ]]; then
	# Display common ISO and Aperture (F-Stop) values and quit

	echo "* Common ISO (film speed) values..."
	echo ""

	printf "Slow speeds: \nISO 50 \nISO 100-125 \nISO 200"
	echo ""
	echo ""

	printf "Medium speed: \nISO 400"
	echo ""
	echo ""

	printf "Fast speeds: \nISO 800 \nISO 1600\nISO 3200"
	echo ""
	echo ""

	echo "Sources - \"Film ISO - A beginners guide by ILFORD Photo\""
	echo "          https://www.youtube.com/watch?v=AQ9rwLC8yqs"
	echo "        - \"When to Use Different ISO Film Speeds\", Guide to Film Photography"
	echo "          https://www.guidetofilmphotography.com/film-speed-uses.html"
	echo ""

	echo "* Common Aperture (F-stop) values..."
	echo ""

	echo "f/1"
	echo "f/1.4"
	echo "f/2"
	echo "f/2.8"
	echo "f/4"
	echo "f/5.6"
	echo "f/8"
	echo "f/11"
	echo "f/16"
	echo "f/22"
	echo "f/32"

	echo ""
	echo "Source - \"F Stop Chart: Lens Apertures for Full Stops, 1/2 Stops & 1/3 Stops\", Have Camera, Will Travel"
	echo "         https://havecamerawilltravel.com/f-stop-chart-lens-apertures/"
	echo ""
else
	echo "Bad input."
fi

echo ""
