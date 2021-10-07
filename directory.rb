@students = []
@cohorts = %w[
  january
  february
  march
  april
  may
  june
  july
  august
  september
  october
  november
  december
]

def load_students(filename = 'students.csv')
  file = File.open(filename, 'r')
  file.readlines.each do |line|
    name, cohort, country = line.chomp.split(',')
    students_update(name, cohort, country)
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts '1. Input the students'
  puts '2. Show the students'
  puts '3. Save the list to students.csv'
  puts '4. Load the list from students.csv'
  puts '9. Exit'
end

def show_students
  print_header
  print_students_list
  print_footer
end

def process(selection)
  case selection
  when '1'
    input_students
  when '2'
    show_students
  when '3'
    save_students
  when '4'
    load_students
  when '9'
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again"
  end
end

def save_students
  file = File.open('students.csv', 'w')
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:country]]
    csv_line = student_data.join(',')
    file.puts csv_line
  end
  file.close
end

def input_students
  puts 'Please enter the names of the students'
  puts 'To finish, just hit return twice'
  name = STDIN.gets.chomp
  puts "Please enter the student's cohort"
  cohort = check_cohort(STDIN.gets.chomp)
  puts "Please enter the student's country of origin"
  country = STDIN.gets.chomp

  while !name.empty? && !cohort.empty? && !country.empty?
    students_update(name, cohort, country)
    if @students.count == 1
      puts "Now we have #{@students.count} student"
    else
      puts "Now we have #{@students.count} students"
    end
    puts 'Please enter the names of the students'
    name = STDIN.gets.chomp
    puts "Please enter the student's cohort"
    cohort = STDIN.gets.chomp
    puts "Please enter the student's country of origin"
    country = STDIN.gets.chomp
  end
  @students
end

def check_cohort(input)
  if @cohorts.include?(input)
    return input
  else
    while true
      puts 'try again this is not a valid cohort'
      input = STDIN.gets.chomp
      return input if @cohorts.include?(input)
    end
  end
end

def students_update(name, cohort, country)
  @students << { name: name, cohort: cohort.to_sym, country: country }
end

def print_header
  puts 'The students of Villains Academy'.center(50)
  puts '-------------'.center(50)
end

def print_students_list
  count = 0
  if @students.length == 0
    puts 'There are no students'.center(50)
    exit
  else
    while count < @cohorts.length
      puts "Students in #{@cohorts[count]} cohort".center(50)
      @students.map do |student|
        if student[:cohort] == @cohorts[count].to_sym
          puts "#{student[:name]} (#{student[:cohort]} cohort) from #{student[:country]}"
                 .center(50)
        end
      end
      count += 1
    end
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students".center(50)
end

try_load_students
interactive_menu
