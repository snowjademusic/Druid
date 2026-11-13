# Progress docs for presentation :)

Original print logic printed every line and every move of the cursor by one ("ESC[C") was one print

this made my programm for just the title screen go from this:

```bash
strace -c ./druid_old_print
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 97.37    0.001743           3       495           write
  2.63    0.000047          47         1         1 read
  0.00    0.000000           0         1           ioctl
  0.00    0.000000           0         1           execve
------ ----------- ----------- --------- --------- ----------------
100.00    0.001790           3       498         1 total
```

-> to this:

```bash
◄ 1s ◎ strace -c ./druid
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 64.34    0.000240         240         1           execve
 14.75    0.000055          27         2           write
 11.80    0.000044          11         4           ioctl
  9.12    0.000034          34         1           read
------ ----------- ----------- --------- --------- ----------------
100.00    0.000373          46         8           total

```
