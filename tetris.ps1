$DEF = 
@{
  ESC = [char]'x'; 
  WAIT = 250; 
  MAXW = [Console]::WindowWidth; 
  MAXH = [Console]::WindowHeight; 
  STEP = 5;
  FALL = 2;
}

$B =
@{
  I = "[ ]`n[ ]`n[ ]`n[ ]", "[ ][ ][ ][ ]", "[ ]`n[ ]`n[ ]`n[ ]", "[ ][ ][ ][ ]", "[ ]`n[ ]`n[ ]`n[ ]"
  T = "[ ][ ][ ]`n   [ ]", "   [ ]`n[ ][ ]`n   [ ]", "   [ ]`n[ ][ ][ ]", "[ ]`n[ ][ ]`n[ ]"
  Z = "[ ][ ]`n   [ ][ ]", "   [ ]`n[ ][ ]`n[ ]", "   [ ][ ]`n[ ][ ]", "[ ]`n[ ][ ]`n   [ ]"
  Q = "[ ][ ]`n[ ][ ]", "[ ][ ]`n[ ][ ]", "[ ][ ]`n[ ][ ]", "[ ][ ]`n[ ][ ]"
  L = "[ ]`n[ ]`n[ ][ ]", "[ ][ ][ ]`n[ ]", "[ ][ ]`n   [ ]`n   [ ]", "      [ ]`n[ ][ ][ ]", "   [ ]`n   [ ]`n[ ][ ]"
}

$R =
@{
  D = 0;
  CW = 1;
  DCW = 2;
  TCW = 3;
  M = 4;
}

[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::CursorVisible = $false

$i = $j = $q = $p = $lim = 0
$rot = $R.D
$currblock = $B.Q

do
{
  Clear-Host
  
  $char = [char]::MinValue
  if ([Console]::KeyAvailable)
  {
    $char = [Console]::ReadKey($true).KeyChar
  }

  switch -Regex ("$char")
  {
    "^(A|a)$"
    {
      if ($i -ge $DEF.STEP) {$i -= $DEF.STEP}
    }

    "^(D|d)$"
    {
      if ($i -lt $DEF.MAXW - $DEF.STEP) {$i += $DEF.STEP}
    }

    "^(S|s)$"
    {
      if ($j -lt $DEF.MAXH - $DEF.FALL) {$j += $DEF.FALL}
    }

    "^(Q|q)$"
    {
      if (++$q -ge $B.Count) {$q = 0}
      $currblock = @($B.Values)[$q]
    }

    "^(W|w)$"
    {
      if (++$p -ge $R.Count - 1) {$p = 0}
      $rot = $p
    }

    "^(E|e)$"
    {
      $rot = ($rot -eq $R.M)?$($R.D):$($R.M)
    }
  }

  [Console]::SetCursorPosition($i, $j++)

  $k = 0
  foreach ($l in $currblock[$rot] -split "`n")
  {
    [Console]::SetCursorPosition($i, $j + $k)
    if (($j + $k) -eq $DEF.MAXH - 1) 
    {
      $j = 0
    }
    
    [Console]::Write("$(" " * $i)$l")
    $k++
  }

  Start-Sleep -Milliseconds $DEF.WAIT
} while ($char -ne $DEF.ESC)
