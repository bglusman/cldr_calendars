defmodule Cldr.Calendar.Compiler.Week do
  @moduledoc false

  defmacro __before_compile__(env) do
    config =
      Module.get_attribute(env.module, :options)
      |> Keyword.put(:calendar, env.module)
      |> validate_config
      |> Cldr.Calendar.extract_options()

    Module.put_attribute(env.module, :calendar_config, config)

    quote location: :keep do
      @behaviour Calendar
      @behaviour Cldr.Calendar

      alias Cldr.Calendar.Base.Week

      def __config__ do
        @calendar_config
      end

      def valid_date?(year, week, day) do
        Week.valid_date?(year, week, day, @calendar_config)
      end

      def quarter_of_year(year, week, day) do
        Week.quarter_of_year(year, week, day, @calendar_config)
      end

      def month_of_year(year, week, day) do
        Week.month_of_year(year, week, day, @calendar_config)
      end

      def week_of_year(year, week, day) do
        Week.week_of_year(year, week, day, @calendar_config)
      end

      def iso_week_of_year(year, week, day) do
        Week.iso_week_of_year(year, week, day, @calendar_config)
      end

      def day_of_era(year, week, day) do
        Week.day_of_era(year, week, day, @calendar_config)
      end

      def day_of_year(year, week, day) do
        Week.day_of_year(year, week, day, @calendar_config)
      end

      def day_of_week(year, week, day) do
        Week.day_of_week(year, week, day, @calendar_config)
      end

      def days_in_month(year, month) do
        Week.days_in_month(year, month, @calendar_config)
      end

      def leap_year?(year) do
        Week.long_year?(year, @calendar_config)
      end

      def first_day_of_year(year) do
        Week.first_day_of_year(year, @calendar_config)
      end

      def last_day_of_year(year) do
        Week.last_day_of_year(year, @calendar_config)
      end

      defimpl String.Chars do
        def to_string(%{calendar: calendar, year: year, month: month, day: day}) do
          calendar.date_to_string(year, month, day)
        end
      end

      def naive_datetime_to_iso_days(year, week, day, hour, minute, second, microsecond) do
        Week.naive_datetime_to_iso_days(
          year,
          week,
          day,
          hour,
          minute,
          second,
          microsecond,
          @calendar_config
        )
      end

      def naive_datetime_from_iso_days({days, day_fraction}) do
        Week.naive_datetime_from_iso_days({days, day_fraction}, @calendar_config)
      end

      defdelegate date_to_string(year, week, day), to: Week

      defdelegate datetime_to_string(
                    year,
                    month,
                    day,
                    hour,
                    minute,
                    second,
                    microsecond,
                    time_zone,
                    zone_abbr,
                    utc_offset,
                    std_offset
                  ),
                  to: Week

      defdelegate day_rollover_relative_to_midnight_utc, to: Calendar.ISO
      defdelegate months_in_year(year), to: Calendar.ISO

      defdelegate naive_datetime_to_string(year, month, day, hour, minute, second, microsecond),
        to: Calendar.ISO

      defdelegate time_from_day_fraction(day_fraction), to: Calendar.ISO
      defdelegate time_to_day_fraction(hour, minute, second, microsecond), to: Calendar.ISO
      defdelegate time_to_string(hour, minute, second, microsecond), to: Calendar.ISO
      defdelegate valid_time?(hour, minute, second, microsecond), to: Calendar.ISO
      defdelegate year_of_era(year), to: Calendar.ISO
    end
  end

  def validate_config(config) do
    config
  end
end
