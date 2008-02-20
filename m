Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JRjY2-00038s-Jg
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 08:39:23 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2044258wxc.17
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 23:39:18 -0800 (PST)
Message-ID: <950c7d180802192339s5fa402fan6a9ac8674e128689@mail.gmail.com>
Date: Wed, 20 Feb 2008 16:39:18 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1203458966.28796.13.camel@youkaida>
MIME-Version: 1.0
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
	<1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203458966.28796.13.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1289589328=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1289589328==
Content-Type: multipart/alternative;
	boundary="----=_Part_8563_21788077.1203493158475"

------=_Part_8563_21788077.1203493158475
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 20, 2008 7:09 AM, Nicolas Will <nico@youplala.net> wrote:

>
> On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:
> > Hi all... I'm seeing exactly the same problems everyone else is (log
> > flooding etc) except that I can't seem to get any keys picked by lirc
> > or /dev/input/event7 at all...
> >
> > Would this patch help in this case?
>
> It would help with the flooding, most probably, though there was a patch
> for that available before.
>
> As for LIRC not picking up the event, I would be tempted to say no, it
> won't help.
>
> Are you certain that your LIRC is configured properly? Are you certain
> that your event number is the right one?
>
> Nico
>

I believe so... in so far as I can tell... I sent an email to this list
about a week ago describing my problems, but there was no response.
(subject: Compro Videomate U500). I've copied it below:

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

------=_Part_8563_21788077.1203493158475
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 20, 2008 7:09 AM, Nicolas Will &lt;<a href="mailto:nico@youplala.net" target="_blank">nico@youplala.net</a>&gt; wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div><div></div><div><br>On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:<br>&gt; Hi all... I&#39;m seeing exactly the same problems everyone else is (log<br>&gt; flooding etc) except that I can&#39;t seem to get any keys picked by lirc<br>

&gt; or /dev/input/event7 at all...<br>&gt;<br>&gt; Would this patch help in this case?<br><br></div></div>It would help with the flooding, most probably, though there was a patch<br>for that available before.<br><br>As for LIRC not picking up the event, I would be tempted to say no, it<br>

won&#39;t help.<br><br>Are you certain that your LIRC is configured properly? Are you certain<br>that your event number is the right one?<br><div><div></div><div><br>Nico</div></div></blockquote><div><br>I believe so... in so far as I can tell... I sent an email to this list about a week ago describing my problems, but there was no response. (subject: Compro Videomate U500). I&#39;ve copied it below:<br>

<br><div style="margin-left: 40px;">Hi all,<br><br>I&#39;ve still been trying to get the inluded remote with my
USB DVB-T Tuner working. It&#39;s a Compro Videomate U500 - it useses the
dibcom 7000 chipset. After upgrading to Ubuntu 8.04 (hardy) I can
now see the remote when I do a &quot;cat /proc/bus/input/devices&quot;:<br><br>
I: Bus=0003 Vendor=185b Product=1e78 Version=0100<br>N: Name=&quot;IR-receiver inside an USB DVB receiver&quot;<br>P: Phys=usb-0000:00:02.1-4/ir0<br>S: Sysfs=/devices/pci0000:00/0000<div>:00:02.1/usb1/1-4/input/input7<br>

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
seems
to be about 5 such messages every second, and the controller key
listed at the end (1E 42 in this case) changes depending on the last
button pressed on the remote. The same messages appear on dmesg.
Obviously, as the code changes, the remote is being picked up by the
kernel, but not being acted upon correctly. Is this normal, and does
this mean
something is working/not working? As stated above, I am still unable to
get irrecord to show anything etc... I can&#39;t get it to work with or
without lirc...<br><br>Any ideas?<br></div><br>Cheers,<br><br>Matt <br></div></div><br>-- <br>Matthew Vermeulen<br><a href="http://www.matthewv.id.au/" target="_blank">http://www.matthewv.id.au/</a><br>MatthewV @ <a href="http://irc.freenode.net" target="_blank">irc.freenode.net</a>

------=_Part_8563_21788077.1203493158475--


--===============1289589328==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1289589328==--
