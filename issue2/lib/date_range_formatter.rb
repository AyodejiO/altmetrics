require 'date'
require 'integer'

class DateRangeFormatter
  def initialize(start_date, end_date, start_time = nil, end_time = nil)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    full_start_date = @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
    full_end_date = @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")

    # Checks if the start and end dates are the same
    if @start_date == @end_date
      if @start_time && @end_time
        return "#{full_start_date} at #{@start_time} to #{@end_time}"
      elsif @start_time
        return "#{full_start_date} at #{@start_time}"
      elsif @end_time
        return "#{full_start_date} until #{@end_time}"
      else
        return full_start_date
      end
    end

    #  Checks if start or end times are set
    if @start_time && @end_time
      return "#{full_start_date} at #{@start_time} - #{full_end_date} at #{@end_time}"
    elsif @start_time
      return "#{full_start_date} at #{@start_time} - #{full_end_date}"
    elsif @end_time
      return "#{full_start_date} - #{full_end_date} at #{@end_time}"
    end

    # Checks if the start and end months are the same
    if @start_date.month == @end_date.month
      if @start_date.year == @end_date.year
        return @start_date.strftime("#{@start_date.day.ordinalize} - #{@end_date.day.ordinalize} %B %Y")
      end

      return @start_date.strftime("#{@start_date.day.ordinalize} %B %Y") + " - " + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
    end

    # Checks if the start and end years are the same
    if @start_date.year == @end_date.year
      return @start_date.strftime("#{@start_date.day.ordinalize} %B") + " - " + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
    end 

    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y") + " - " + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end
