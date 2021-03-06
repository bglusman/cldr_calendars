defmodule Cldr.Calendar.Compiler.Month do
  @moduledoc false

  defmacro __before_compile__(env) do
    config =
      Module.get_attribute(env.module, :options)
      |> Keyword.put(:calendar, env.module)
      |> Cldr.Calendar.extract_options()
      |> Cldr.Calendar.validate_config!(:month)

    Module.put_attribute(env.module, :calendar_config, config)

    quote location: :keep do
      @moduledoc false

      @behaviour Calendar
      @behaviour Cldr.Calendar

      @type year :: -9999..9999
      @type month :: 1..12
      @type day :: 1..31

      alias Cldr.Calendar.Base.Month

      @doc false
      def __config__ do
        @calendar_config
      end

      @doc """
      Defines the CLDR calendar type for this calendar.

      This type is used in support of `Cldr.Calendar.localize/3`.
      Currently only `:gregorian` is supported.

      """
      @impl true

      def cldr_calendar_type do
        :gregorian
      end

      @doc """
      Determines if the date given is valid according to this calendar.

      """
      @impl true

      def valid_date?(year, month, day) do
        Month.valid_date?(year, month, day, __config__())
      end

      @doc """
      Calculates the year and era from the given `year`.
      The ISO calendar has two eras: the current era which
      starts in year 1 and is defined as era "1". And a
      second era for those years less than 1 defined as
      era "0".

      """
      @spec year_of_era(year) :: {year, era :: 0..1}
      @impl true

      def year_of_era(year) do
        Month.year_of_era(year, __config__())
      end

      @doc """
      Calculates the quarter of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 4.

      """
      @spec quarter_of_year(year, month, day) :: 1..4
      @impl true

      def quarter_of_year(year, month, day) do
        Month.quarter_of_year(year, month, day, __config__())
      end

      @doc """
      Calculates the month of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 12.

      """
      @spec month_of_year(year, month, day) :: month
      @impl true

      def month_of_year(year, month, day) do
        Month.month_of_year(year, month, day, __config__())
      end

      @doc """
      Calculates the week of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 53.

      """
      @spec week_of_year(year, month, day) :: {year, Cldr.Calendar.week}
      @impl true

      def week_of_year(year, month, day) do
        Month.week_of_year(year, month, day, __config__())
      end

      @doc """
      Calculates the ISO week of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 53.

      """
      @spec iso_week_of_year(year, month, day) :: {year, Cldr.Calendar.week}
      @impl true

      def iso_week_of_year(year, month, day) do
        Month.iso_week_of_year(year, month, day)
      end

      @doc """
      Calculates the day and era from the given `year`, `month`, and `day`.

      """
      @spec day_of_era(year, month, day) :: {day :: pos_integer(), era :: 0..1}
      @impl true

      def day_of_era(year, month, day) do
        Month.day_of_era(year, month, day, __config__())
      end

      @doc """
      Calculates the day of the year from the given `year`, `month`, and `day`.

      """
      @spec day_of_year(year, month, day) :: 1..366
      @impl true

      def day_of_year(year, month, day) do
        Month.day_of_year(year, month, day, __config__())
      end

      @doc """
      Calculates the day of the week from the given `year`, `month`, and `day`.
      It is an integer from 1 to 7, where 1 is Monday and 7 is Sunday.

      """
      @spec day_of_week(year, month, day) :: 1..7
      @impl true

      def day_of_week(year, month, day) do
        Month.day_of_week(year, month, day, __config__())
      end

      @doc """
      Calculates the number of period in a given `year`. A period
      corresponds to a month in month-based calendars and
      a week in week-based calendars..

      """
      def periods_in_year(year) do
        months_in_year(year)
      end

      @doc """
      Returns the number days in a given year.

      """
      @impl true

      def days_in_year(year) do
        Month.days_in_year(year, __config__())
      end

      @doc """
      Returns how many days there are in the given year-month.

      """
      @spec days_in_month(year, month) :: 28..31
      @impl true

      def days_in_month(year, month) do
        Month.days_in_month(year, month, __config__())
      end

      @doc """
      Returns the number days in a a week.

      """
      def days_in_week do
        Month.days_in_week()
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given year.

      """
      @impl true

      def year(year) do
        Month.year(year, __config__())
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given quarter of a year.

      """
      @impl true

      def quarter(year, quarter) do
        Month.quarter(year, quarter, __config__())
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given month of a year.

      """
      @impl true

      def month(year, month) do
        Month.month(year, month, __config__())
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given week of a year.

      """
      @impl true

      def week(year, week) do
        Month.week(year, week, __config__())
      end

      @doc """
      Adds an `increment` number of `date_part`s
      to a `year-month-day`.

      `date_part` can be `:quarters`
       or`:months`.

      """
      @impl true

      def plus(year, month, day, date_part, increment, options \\ [])

      def plus(year, month, day, :quarters, months, options) do
        Month.plus(year, month, day, __config__(), :quarters, months, options)
      end

      def plus(year, month, day, :months, months, options) do
        Month.plus(year, month, day, __config__(), :months, months, options)
      end

      @doc """
      Returns if the given year is a leap year.

      """
      @spec leap_year?(year) :: boolean()
      @impl true

      def leap_year?(year) do
        Month.leap_year?(year, __config__())
      end

      @doc """
      Returns the number of days since the calendar
      epoch for a given `year-month-day`

      """
      def date_to_iso_days(year, month, day) do
        Month.date_to_iso_days(year, month, day, __config__())
      end

      @doc """
      Returns `{year, month, day}` calculated from
      the number of `iso_days`.

      """
      def date_from_iso_days(iso_days) do
        Month.date_from_iso_days(iso_days, __config__())
      end

      @doc """
      Returns the number of `iso_days` that is
      the first day of the given
      year for this calendar.

      """
      def first_gregorian_day_of_year(year) do
        Month.first_gregorian_day_of_year(year, __config__())
      end

      @doc """
      Returns the number of `iso_days` that is
      the last day of the given
      year for this calendar.

      """
      def last_gregorian_day_of_year(year) do
        Month.last_gregorian_day_of_year(year, __config__())
      end

      @doc """
      Returns the `t:Calendar.iso_days/0` format of the specified date.

      """
      @impl true
      @spec naive_datetime_to_iso_days(
              Calendar.year(),
              Calendar.month(),
              Calendar.day(),
              Calendar.hour(),
              Calendar.minute(),
              Calendar.second(),
              Calendar.microsecond()
            ) :: Calendar.iso_days()

      def naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond) do
        Month.naive_datetime_to_iso_days(
          year,
          month,
          day,
          hour,
          minute,
          second,
          microsecond,
          __config__()
        )
      end

      @doc """
      Converts the `t:Calendar.iso_days/0` format to the datetime format specified by this calendar.

      """
      @spec naive_datetime_from_iso_days(Calendar.iso_days()) :: {
              Calendar.year(),
              Calendar.month(),
              Calendar.day(),
              Calendar.hour(),
              Calendar.minute(),
              Calendar.second(),
              Calendar.microsecond()
            }
      @impl true

      def naive_datetime_from_iso_days({days, day_fraction}) do
        Month.naive_datetime_from_iso_days({days, day_fraction}, __config__())
      end

      @doc false
      defdelegate date_to_string(year, month, day), to: Calendar.ISO

      @doc false
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
                  to: Calendar.ISO

      @doc false
      defdelegate naive_datetime_to_string(year, month, day, hour, minute, second, microsecond),
        to: Calendar.ISO

      @doc false
      defdelegate day_rollover_relative_to_midnight_utc, to: Calendar.ISO

      @doc false
      defdelegate months_in_year(year), to: Calendar.ISO

      @doc false
      defdelegate time_from_day_fraction(day_fraction), to: Calendar.ISO

      @doc false
      defdelegate time_to_day_fraction(hour, minute, second, microsecond), to: Calendar.ISO

      @doc false
      defdelegate time_to_string(hour, minute, second, microsecond), to: Calendar.ISO

      @doc false
      defdelegate valid_time?(hour, minute, second, microsecond), to: Calendar.ISO
    end
  end
end
