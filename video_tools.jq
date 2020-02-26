def minuteLength: 60;
def hourLength: 60*minuteLength;
def daylength: 24*hourLength;

def zeroPad($len):
    ($len-(.|length)) as $len
  | $len*"0"+.;


def removePeriod($count; $period):
  . - ($period * $count);
def removePeriod($period):
  . - $period;
def printSeconds($prefix):
    (.|floor) as $whole
  | if .|floor|tostring|length == 1 then
      $prefix + (tostring|zeroPad(.|tostring|length + 1))
    else
      $prefix + (.|tostring)
    end;

def printMinutes($prefix):
    (. / minuteLength | floor) as $min
  |removePeriod($min;minuteLength)
  | printSeconds(prefix + ($min|tostring|zeroPad(2))+":");

def printHours($prefix):
    (. / hourLength | floor) as $hrs
  | removePeriod($hrs;hourLength)
  | printMinutes(prefix + ($hrs|tostring)+":");

def printDays($days):
  removePeriod($days; daylength)
  | printHours(($days|tostring)+" days, ");

def formatDuration:
    (./daylength|floor) as $days
  | if $days > 0 then
      printDays($days)
    else
        (./hourLength|floor) as $hrs
      | if $hrs > 0 then
          printHours("")
        else
            (./60|floor) as $min
          | if $min > 0 then
              printMinutes("")
            else
              printSeconds("")
            end
        end
    end;

def getDuration:
  [
    .[].media
    | (
        [
          .track[].Duration|tonumber
        ]
        | max
      )
  ]
  | add;