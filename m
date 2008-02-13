Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JPHAa-0003r7-2c
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 13:57:00 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2473wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 04:56:58 -0800 (PST)
Message-ID: <950c7d180802130456tc35518ev7d40c8c620b812c1@mail.gmail.com>
Date: Wed, 13 Feb 2008 21:56:57 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Compro Videomate U500 Remote
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0926149544=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0926149544==
Content-Type: multipart/alternative;
	boundary="----=_Part_462_10429603.1202907417410"

------=_Part_462_10429603.1202907417410
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I've still been trying to get the inluded remote with my USB DVB-T Tuner
working. It's a Compro Videomate U500 - it useses the dibcom 7000 chipset.
After upgrading to Ubuntu 8.04 (hardy) I can now see the remote when I do a
"cat /proc/bus/input/devices":

I: Bus=0003 Vendor=185b Product=1e78 Version=0100
N: Name="IR-receiver inside an USB DVB receiver"
P: Phys=usb-0000:00:02.1-4/ir0
S: Sysfs=/devices/pci0000:00/0000:00:02.1/usb1/1-4/input/input7
U: Uniq=
H: Handlers=kbd event7
B: EV=3
B: KEY=10afc332 2842845 0 0 0 4 80018000 2180 40000801 9e96c0 0 800200 ffc

However, I get now output running irrecord:

matthew@matthew-desktop:~$ sudo irrecord -H dev/input -d /dev/input/event7
lircd.conf

irrecord -  application for recording IR-codes for usage with lirc

Copyright (C) 1998,1999 Christoph Bartelmus(lirc@bartelmus.de)

irrecord: initializing '/dev/input/event7'
This program will record the signals from your remote control
and create a config file for lircd.


[SNIP]

Press RETURN to continue.


Hold down an arbitrary button.
irrecord: gap not found, can't continue
irrecord: closing '/dev/input/event7'

Likewise, if I start lirc with the following: "sudo /usr/sbin/lircd -H
dev/input -d /dev/input/event7 -n" and then run irw, it will run fine but
there will be no output at all.

Just looking through /var/log/syslog and noticed that it is filled with
messages such as this:
Feb 10 14:00:17 matthew-desktop kernel: [ 6549.313822] dib0700: Unknown
remote controller key : 1E 42
Feb 10 14:00:18 matthew-desktop kernel: [ 6549.389724] dib0700: Unknown
remote controller key : 1E 42
Feb 10 14:00:18 matthew-desktop kernel: [ 6549.465623] dib0700: Unknown
remote controller key : 1E 42
Feb 10 14:00:18 matthew-desktop kernel: [ 6549.542087] dib0700: Unknown
remote controller key : 1E 42
Feb 10 14:00:18 matthew-desktop kernel: [ 6549.617927] dib0700: Unknown
remote controller key : 1E 42

There seems to be about 5 such messages every second, and the controller key
listed at the end (1E 42 in this case) changes depending on the last button
pressed on the remote. The same messages appear on dmesg. Obviously, as the
code changes, the remote is being picked up by the kernel, but not being
acted upon correctly. Is this normal, and does this mean something is
working/not working? As stated above, I am still unable to get irrecord to
show anything etc... I can't get it to work with or without lirc...

Any ideas?

Cheers,

Matt
-- 
Matthew Vermeulen
http://www.matthewv.id.au/
MatthewV @ irc.freenode.net

------=_Part_462_10429603.1202907417410
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>I&#39;ve still been trying to get the inluded remote with my
USB DVB-T Tuner working. It&#39;s a Compro Videomate U500 - it useses the dibcom 7000 chipset. After upgrading to Ubuntu 8.04 (hardy) I can
now see the remote when I do a &quot;cat /proc/bus/input/devices&quot;:<br><br>
I: Bus=0003 Vendor=185b Product=1e78 Version=0100<br>N: Name=&quot;IR-receiver inside an USB DVB receiver&quot;<br>P: Phys=usb-0000:00:02.1-4/ir0<br>S: Sysfs=/devices/pci0000:00/0000<div id="1fmb" class="ArwC7c ckChnd">:00:02.1/usb1/1-4/input/input7<br>
U: Uniq=<br>
H: Handlers=kbd event7 <br>B: EV=3<br>B: KEY=10afc332 2842845 0 0 0 4 80018000 2180 40000801 9e96c0 0 800200 ffc<br><br>However, I get now output running irrecord:<br><br clear="all">matthew@matthew-desktop:~$ sudo irrecord -H dev/input -d /dev/input/event7 lircd.conf<br>

<br>irrecord -&nbsp; application for recording IR-codes for usage with lirc<br><br>Copyright (C) 1998,1999 Christoph Bartelmus(<a href="mailto:lirc@bartelmus.de" target="_blank">lirc@bartelmus.de</a>)<br><br>irrecord: initializing &#39;/dev/input/event7&#39;<br>

This program will record the signals from your remote control<br>and create a config file for lircd.<br><br><br>[SNIP]<br><br>Press RETURN to continue.<br><br><br>Hold down an arbitrary button.<br>irrecord: gap not found, can&#39;t continue<br>

irrecord: closing &#39;/dev/input/event7&#39;<br><br>Likewise,
if I start lirc with the following: &quot;sudo /usr/sbin/lircd -H dev/input
-d /dev/input/event7 -n&quot; and then run irw, it will run fine but there
will be no output at all.<br>
</div><br>Just looking through /var/log/syslog and noticed that it is filled with messages such as this:<br>

Feb 10 14:00:17 matthew-desktop kernel: [ 6549.313822] dib0700: Unknown remote controller key : 1E 42<br>Feb 10 14:00:18 matthew-desktop kernel: [ 6549.389724] dib0700: Unknown remote controller key : 1E 42<br>Feb 10 14:00:18 matthew-desktop kernel: [ 6549.465623] dib0700: Unknown remote controller key : 1E 42<br>


Feb 10 14:00:18 matthew-desktop kernel: [ 6549.542087] dib0700: Unknown remote controller key : 1E 42<br>Feb 10 14:00:18 matthew-desktop kernel: [ 6549.617927] dib0700: Unknown remote controller key : 1E 42<br><br>There
seems to be about 5 such messages every second, and the controller key
listed at the end (1E 42 in this case) changes depending on the last
button pressed on the remote. The same messages appear on dmesg. Obviously, as the code changes, the remote is being picked up by the kernel, but not being acted upon correctly. Is this normal, and does this mean
something is working/not working? As stated above, I am still unable to
get irrecord to show anything etc... I can&#39;t get it to work with or without lirc...<br><br>Any ideas?<br><br>Cheers,<br><br>Matt<br>-- <br>Matthew Vermeulen<br><a href="http://www.matthewv.id.au/">http://www.matthewv.id.au/</a><br>
MatthewV @ <a href="http://irc.freenode.net">irc.freenode.net</a>

------=_Part_462_10429603.1202907417410--


--===============0926149544==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0926149544==--
