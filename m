Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K9QSV-0004gN-J4
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 22:10:19 +0200
Message-ID: <485ABD03.7070602@schoeller-soft.net>
Date: Thu, 19 Jun 2008 22:09:39 +0200
From: =?ISO-8859-1?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: anton repko <trcheton@gmail.com>
References: <f3acf9620806130531j18a64bbcw92256044a491a26f@mail.gmail.com>	<200806131654.11715.dkuhlen@gmx.net>
	<f3acf9620806181146q7a61b792hbcc10c4513845173@mail.gmail.com>
In-Reply-To: <f3acf9620806181146q7a61b792hbcc10c4513845173@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Firmware extraction script for Pinnacle PCTV Sat
 Pro USB
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0748699562=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0748699562==
Content-Type: multipart/alternative;
 boundary="------------070007060407060801020108"

This is a multi-part message in MIME format.
--------------070007060407060801020108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Well I relay brought up my problem with my 452e...
I just want to ask since 400e and 450e needs firmware...maybe 452e needs 
firmware too (for whatever reason maybe only on ppc architecture) and 
thats my problem? Could that be possible? If yes how to I get firmware 
for 452e and look if that solves my problem?
Well if I look at dmesg after plug in my 452e the last line was:

usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw

looks like some firmware is loading maybe thats a wrong one, since I buyed my 452e last month there could be an little change to the hardware so that dvb-usb-tt-connect-s2-3600-01.fw is not workin anymore.
However I have no clue how to extract the firmware the right way so if that could do someone for me I would be very thankful

Michael


anton repko schrieb:
> Hi,
> 2008/6/13 Dominik Kuhlen <dkuhlen@gmx.net <mailto:dkuhlen@gmx.net>>:
>
>     Are you sure that the 450e does need a firmware?
>     I know that the 452e does not.
>
> Yes, the 450e uses firmware of the 400e (the hardware seems to be 
> identical).
>
> As the 400e firmware is rather hard to find, I send complete 
> extraction script for driver found on the Pinnacle site (new version; 
> firmware is the same):
>
> #!/bin/bash
> wget 
> "http://cdn.pinnaclesys.com/SupportFiles/PCTV%20Drivers/PCTV%20400e,%20450e,%20452e/XP32.ZIP"
> cat >XP32.md5 <<!hash!
> ba0bc4d0f84bb9f419e9fbf90ef1ed9f  XP32.ZIP
> !hash!
> md5sum -c XP32.md5
> if [ $? -ne 0 ]; then exit 1; fi
> unzip -j XP32.ZIP XP/pctv4XXe.sys
> # dd if=pctv4XXe.sys of=dvb-ttusb2-a.raw bs=8 skip=22703 count=1392
> # dd if=pctv4XXe.sys of=dvb-ttusb2-b.raw bs=8 skip=24098 count=1408
> dd if=pctv4XXe.sys of=dvb-usb-pctv-400e-01.raw bs=8 skip=25509 count=1315
> # dd if=pctv4XXe.sys of=dvb-ttusb2-c.raw bs=8 skip=26827 count=1232
> # dd if=pctv4XXe.sys of=dvb-ttusb2-d.raw bs=8 skip=28062 count=1326
> # dd if=pctv4XXe.sys of=dvb-ttusb2-e.raw bs=8 skip=29391 count=1378
> dd if=pctv4XXe.sys of=dvb-usb-pctv-450e-01.raw bs=8 skip=30772 count=1323
> # dd if=pctv4XXe.sys of=dvb-usb-pctv-452e-01.raw bs=8 skip=32098 
> count=1375
> cat >convert.c <<!conv!
> #include <stdio.h>
> int main (int argc, char *argv[])
> {
>     FILE *raw, *fw;
>     unsigned char buf[22];
>     int n;
>     raw = fopen (argv[1], "r");
>     fw = fopen (argv[2], "w");
>     while (fread (buf, 1, 22, raw) == 22) {
>         fwrite (buf, 1, 1, fw);
>         n = buf[0];
>         buf[n+5] = 0xff;
>         fwrite (&buf[2], 1, n+4, fw);
>     }
>     fclose (raw);
>     fclose (fw);
>     return 0;
> }
> !conv!
> gcc convert.c -o convert
> for i in *.raw; do
>     j=$(echo $i | sed s/raw/fw/)
>     ./convert $i $j
>     rm $i
> done
> cp dvb-usb-pctv-400e-01.fw /lib/firmware/
> #   uncomment next line to use the 450e firmware
> # cp dvb-usb-pctv-450e-01.fw /lib/firmware/dvb-usb-pctv-400e-01.fw
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--------------070007060407060801020108
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Well I relay brought up my problem with my 452e...<br>
I just want to ask since 400e and 450e needs firmware...maybe 452e
needs firmware too (for whatever reason maybe only on ppc architecture)
and thats my problem? Could that be possible? If yes how to I get
firmware for 452e and look if that solves my problem?<br>
Well if I look at dmesg after plug in my 452e the last line was: <br>
<pre wrap="">usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw

looks like some firmware is loading maybe thats a wrong one, since I buyed my 452e last month there could be an little change to the hardware so that dvb-usb-tt-connect-s2-3600-01.fw is not workin anymore.
However I have no clue how to extract the firmware the right way so if that could do someone for me I would be very thankful

Michael
</pre>
<br>
anton repko schrieb:
<blockquote
 cite="mid:f3acf9620806181146q7a61b792hbcc10c4513845173@mail.gmail.com"
 type="cite">Hi,<br>
  <div class="gmail_quote">2008/6/13 Dominik Kuhlen &lt;<a
 moz-do-not-send="true" href="mailto:dkuhlen@gmx.net">dkuhlen@gmx.net</a>&gt;:<br>
  <blockquote class="gmail_quote"
 style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Are
you sure that the 450e does need a firmware?<br>
I know that the 452e does not.<br>
  </blockquote>
  </div>
Yes, the 450e uses firmware of the 400e (the hardware seems to be
identical).<br>
  <br>
As the 400e firmware is rather hard to find, I send complete extraction
script for driver found on the Pinnacle site (new version; firmware is
the same):<br>
  <br>
  <span class="HcCDpe"></span>#!/bin/bash<br>
wget "<a moz-do-not-send="true"
 href="http://cdn.pinnaclesys.com/SupportFiles/PCTV%20Drivers/PCTV%20400e,%20450e,%20452e/XP32.ZIP">http://cdn.pinnaclesys.com/SupportFiles/PCTV%20Drivers/PCTV%20400e,%20450e,%20452e/XP32.ZIP</a>"<br>
cat &gt;XP32.md5 &lt;&lt;!hash!<br>
ba0bc4d0f84bb9f419e9fbf90ef1ed9f&nbsp; XP32.ZIP<br>
!hash!<br>
md5sum -c XP32.md5<br>
if [ $? -ne 0 ]; then exit 1; fi<br>
unzip -j XP32.ZIP XP/pctv4XXe.sys<br>
# dd if=pctv4XXe.sys of=dvb-ttusb2-a.raw bs=8 skip=22703 count=1392<br>
# dd if=pctv4XXe.sys of=dvb-ttusb2-b.raw bs=8 skip=24098 count=1408<br>
dd if=pctv4XXe.sys of=dvb-usb-pctv-400e-01.raw bs=8 skip=25509
count=1315<br>
# dd if=pctv4XXe.sys of=dvb-ttusb2-c.raw bs=8 skip=26827 count=1232<br>
# dd if=pctv4XXe.sys of=dvb-ttusb2-d.raw bs=8 skip=28062 count=1326<br>
# dd if=pctv4XXe.sys of=dvb-ttusb2-e.raw bs=8 skip=29391 count=1378<br>
dd if=pctv4XXe.sys of=dvb-usb-pctv-450e-01.raw bs=8 skip=30772
count=1323<br>
# dd if=pctv4XXe.sys of=dvb-usb-pctv-452e-01.raw bs=8 skip=32098
count=1375<br>
cat &gt;convert.c &lt;&lt;!conv!<br>
#include &lt;stdio.h&gt;<br>
int main (int argc, char *argv[])<br>
{<br>
&nbsp;&nbsp;&nbsp; FILE *raw, *fw;<br>
&nbsp;&nbsp;&nbsp; unsigned char buf[22];<br>
&nbsp;&nbsp;&nbsp; int n;<br>
&nbsp;&nbsp;&nbsp; raw = fopen (argv[1], "r");<br>
&nbsp;&nbsp;&nbsp; fw = fopen (argv[2], "w");<br>
&nbsp;&nbsp;&nbsp; while (fread (buf, 1, 22, raw) == 22) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fwrite (buf, 1, 1, fw);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; n = buf[0];<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; buf[n+5] = 0xff;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fwrite (&amp;buf[2], 1, n+4, fw);<br>
&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; fclose (raw);<br>
&nbsp;&nbsp;&nbsp; fclose (fw);<br>
&nbsp;&nbsp;&nbsp; return 0;<br>
}<br>
!conv!<br>
gcc convert.c -o convert<br>
for i in *.raw; do<br>
&nbsp;&nbsp;&nbsp; j=$(echo $i | sed s/raw/fw/)<br>
&nbsp;&nbsp;&nbsp; ./convert $i $j<br>
&nbsp;&nbsp;&nbsp; rm $i<br>
done<br>
cp dvb-usb-pctv-400e-01.fw /lib/firmware/<br>
#&nbsp;&nbsp; uncomment next line to use the 450e firmware<br>
# cp dvb-usb-pctv-450e-01.fw /lib/firmware/dvb-usb-pctv-400e-01.fw<br>
  <br>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>

--------------070007060407060801020108--


--===============0748699562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0748699562==--
