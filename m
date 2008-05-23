Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1JzccM-0005m8-2q
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 21:07:55 +0200
Received: by ti-out-0910.google.com with SMTP id w7so827627tib.13
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 12:07:47 -0700 (PDT)
Message-ID: <412bdbff0805231207g38c3cfeet7e20edda43561160@mail.gmail.com>
Date: Fri, 23 May 2008 15:07:45 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Warning regarding Ubuntu 8.04, mplayer,
	and some dvb drivers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Just an FYI in case people run into mplayer problems with Ubuntu 8.04
(I don't know what other drivers this affects, but I would assume just
about all of them)

I upgraded to Ubuntu 8.04 this week to test the V4L HVR-950 driver and
ran into a problem where mplayer would work the first time but then
subsequent attempts to connect to /dev/dvb/adapter0/dvr0 would always
be return EBUSY.  After spending the morning littering the driver with
debug code trying to locate what I thought was a bug in the
referencing counting, it occurred to me to just run fuser against the
device file.

root@devin-desktop:~# fuser -v /dev/dvb/adapter0/dvr0
                    USER        PID ACCESS COMMAND
/dev/dvb/adapter0/dvr0:
                    root       6455 f.... mplayer
                    root       6459 f.... dbus-launch
                    root       6460 f.... dbus-daemon

Looks like they integrated mplayer with dbus, but they don't close the
file handles on fork() so dbus inherits the file indefinitely (since
it doesn't close when mplayer closes).

I then put "ubuntu dbus" into my search and it turns up I'm about a
week behind Markus Rechberger because he appears to have already found
the issue:

http://www.mail-archive.com/em28xx@mcentral.de/msg01097.html

And he has already submitted a fix to Ubuntu:

https://bugs.launchpad.net/ubuntu/+source/dbus/+bug/230877

Just a heads up in case anybody runs into the same problem with other devices...

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
