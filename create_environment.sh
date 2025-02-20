#!/bin/bash

# ask for user's name
read -p "Enter a name you prefer: " userName

# Define main dir
DEDE="submission_reminder_${userName}"

# Create directory one by one
mkdir -p "$DEDE/config"
mkdir -p "$DEDE/modules"
mkdir -p "$DEDE/app"
mkdir -p "$DEDE/assets"

# Create needed files
touch "$DEDE/config/config.env"
touch "$DEDE/assets/submissions.txt"
touch "$DEDE/app/reminder.sh"
touch "$DEDE/modules/functions.sh"
touch "$DEDE/startup.sh"


# config.env
cat << EOF > "$DEDE/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# submissions.txt with some student records
cat << EOF > "$DEDE/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Chris, Shell Navigation, not submitted
Mulima, Shell Basics, submitted
Beste, Shell Navigation, not submitted
Faith, Shell Navigation, not submitted
Mutunzi, Shell Navigation, not submitted
Denyse, Shell Navigation, submitted
EOF

# functions.sh
cat << 'EOF' > "$DEDE/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
 
 function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# reminder.sh
cat << 'EOF' > "$DEDE/app/reminder.sh"
#!/bin/bash
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# startup.sh
cat << 'EOF' > "$DEDE/startup.sh"
#!/bin/bash
echo "Starting Submission Reminder App..."
./app/reminder.sh
EOF

# PERMISSIONS
chmod +x "$DEDE/modules/functions.sh"
chmod +x "$DEDE/startup.sh"
chmod +x "$DEDE/app/reminder.sh"
