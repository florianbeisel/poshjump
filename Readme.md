# Jump for Windows (PowerShell Edition)
Easily jump around the file system by manually adding marks.

It's like the [Oh My Zsh jump plugin](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/jump/jump.plugin.zsh), but for Windows.

It is based on [jump for Windows by Frederic Seiler](https://github.com/fredericseiler/jump) and is fully compatible with it. Both versions can run in tandem in there respective CLI.

## Installation

To be the most useful the script should be sourced when powershell is started. I personally use the following method but if you already use a powershell profile your requirements might differ (though most people with a powershell profile will know a way to source this script themselfes)

In Powershell get the Path to your $profile

    PS C:\> $profile
    C:\Users\beisel\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    
We need to edit or create this file to load the powershell Scripts we want to automatically load. My File looks like this: 

    $scriptPath = "C:\Scripts\Powershell\autoload"
    Get-ChildItem "${scriptPath}\*.ps1" | %{.$_}
    
This loads all Scripts placed in the autoload folder everytime a powershell is started. 

Now place `poshjump.ps1` in the autoload folder. In my case this would be `C:\Scripts\Powershell\autoload` and restart your powershell.

## Usage

### Mark the current path for recurrent use
```
mark foo
```
Example :
```
C:\Program Files>mark prog
C:\Program Files>_
```

### Jump to a marked path
```
jump foo
```
Example :
```
C:\Program Files>cd ..
C:\>jump prog
C:\Program Files>_
```

### List all created marks
```
marks
```
Example :
```
C:\Program Files>marks
prog -> C:\Program Files

C:\Program Files>_
```

### Remove a mark
```
unmark foo
```
Example :
```
C:\Program Files>unmark prog
C:\Program Files>_
```

### Keep a path for later user
```
keep
```
Example :
```
C:\Users\Username>keep
```

### Jump back to the keeped path
```
back
```
Example :
```
C:\Users\Username>cd \
C:\>back
C:\Users\Username>_
```

## Notes
If you `mark` a path without giving a name, the mark name with be the folder name :
```
C:\bar>mark
C:\bar>cd ..
C:\>jump bar
C:\bar>_
```
When a path is no more available, `marks` will tell you :
```
C:\bar>mark foo
C:\bar>cd ..
C:\>rmdir C:\bar
C:\>marks
bar -> ?

C:\>_
```
`mark` will ask for a confirmation if you're trying to override any existing mark name :
```
C:\>marks
home -> C:\Users\Username

C:\>mark home
Mark C:\ as home? (y/n) _
```
Marks are stored in the directory `%MARKPATH%`, which defaults to `%HOME%\.marks`. If `%HOME%` is not [set](http://www.computerhope.com/issues/ch000549.htm), it defaults to [`%USERPROFILE%\.marks`](https://en.wikipedia.org/wiki/Home_directory#Default_home_directory_per_operating_system).