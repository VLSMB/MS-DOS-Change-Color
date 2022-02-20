# MS-DOS-Change-Color
a 16-bit DOS program can change the color of screen and words

练习8086汇编时写的小程序，没什么实际用处，仅能更改DOS系统的背景色和字体颜色。

运行环境；MS-DOS到Windows 2000 Professional，更高的操作系统就不能用了。

本程序主要运用了int 16h中断读取键盘输入（ah=0），以及call语令和其他跳转语句。文本输出则用的是int 21h中断（ah=09）
