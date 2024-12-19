#!/bin/bash

# Define file categories and their extensions
declare -A categories
categories=(
    ["Images"]="jpg jpeg png gif bmp tiff"
    ["Videos"]="mp4 mkv avi mov flv wmv"
    ["Text"]="txt md csv log json xml"
)

# Function to calculate the total count and size of files for a given category
calculate_category() {
    local category=$1
    local extensions=($2)
    local total_count=0
    local total_size=0

    for ext in "${extensions[@]}"; do
        # Find files with the given extension and sum up the count and size
        count=$(find / -type f -iname "*.$ext" 2>/dev/null | wc -l)
        size=$(find / -type f -iname "*.$ext" -exec du -b {} + 2>/dev/null | awk '{sum += $1} END {print sum}')
        
        # Add to total count and size
        total_count=$((total_count + count))
        total_size=$((total_size + size))
    done

    echo "$category:"
    echo "  Total Files: $total_count"
    echo "  Total Size: $((total_size / 1024 / 1024)) MB"
}

# Main script execution
echo "File Report by Category"
echo "========================="

for category in "${!categories[@]}"; do
    calculate_category "$category" "${categories[$category]}"
done
