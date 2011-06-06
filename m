Return-path: <mchehab@pedra>
Received: from mxh2.seznam.cz ([77.75.76.26]:48321 "EHLO mxh2.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1FFS0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 14:26:22 -0400
To: linux-media@vger.kernel.org
Date: Mon, 06 Jun 2011 20:13:29 +0200 (CEST)
From: Radim <radim100@seznam.cz>
Subject: =?us-ascii?Q?Last=20key=20repeated=20after=20every=20keypress=20on=20remote=20control=20=28saa7134=20lirc=20devinput=20driver=29?=
Mime-Version: 1.0
Message-Id: <22534.4159.11253-14366-1925523856-1307384009@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;	charset="us-ascii"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello to everybody,
I was redirected here from lirc mailinglist (reason is at the end).

I'm asking for any help because I wasn't able to solve
this problem by my self (and google of course).
 
When I'm testing lirc configuration using irw, last pressed key is repeated
just befor the new one:
 
after pressing key 1:
0000000080010002 00 KEY_1 devinput

after pressing key 2:
0000000080010002 00 KEY_1 devinput
0000000080010003 00 KEY_2 devinput

after pressing key 3:
0000000080010003 00 KEY_2 devinput
0000000080010004 00 KEY_3 devinput

after pressing key 4:
0000000080010004 00 KEY_3 devinput
0000000080010005 00 KEY_4 devinput

after pressing key 5:
0000000080010005 00 KEY_4 devinput
0000000080010006 00 KEY_5 devinput


My configuration:
Archlinux (allways up-to-date)
Asus MyCinema P7131 with remote control PC-39
lircd 0.9.0, driver devinput, default config file lirc.conf.devinput
kernel 2.6.38

# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
       Driver saa7134, table rc-asus-pc39
       Supported protocols: NEC RC-5 RC-6 JVC SONY LIRC
       Enabled protocols: RC-5
       Repeat delay = 500 ms, repeat period = 33 ms

Answare from lirc-mainlinglist (Jarod Wilson):
Looks like a bug in saa7134-input.c, which doesn't originate in lirc land,
its from the kernel itself. The more apropos location to tackle this issue
is linux-media@vger.kernel.org.

I can provide any other listings, just ask for them.

Thank you for any help,
Radim
