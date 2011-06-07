Return-path: <mchehab@pedra>
Received: from mxh1.seznam.cz ([77.75.72.26]:57655 "EHLO mxh1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1FGG7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 02:59:20 -0400
In-Reply-To: <4DED1EE2.30103@redhat.com>
Date: Tue, 07 Jun 2011 08:45:40 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Radim <radim100@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20Re=3A=20Last=20key=20repeated=20after=20every=20keypress=20on=20remote=20control=20=28saa7134=20lirc=20devinput=20driver=29?=
Mime-Version: 1.0
Message-Id: <22615.4194.11299-2628-1588834168-1307429140@seznam.cz>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;	charset="iso-8859-2";	format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> ------------ Pôvodná správa ------------
> Od: Jarod Wilson <jarod@redhat.com>
> Predmet: Re: Last key repeated after every keypress on remote control (saa7134
> lirc devinput driver)
> Dátum: 06.6.2011 20:39:50
> ----------------------------------------
> Devin Heitmueller wrote:
> > On Mon, Jun 6, 2011 at 2:13 PM, Radim<radim100@seznam.cz>  wrote:
> >> Hello to everybody,
> >> I was redirected here from lirc mailinglist (reason is at the end).
> >>
> >> I'm asking for any help because I wasn't able to solve
> >> this problem by my self (and google of course).
> >>
> >> When I'm testing lirc configuration using irw, last pressed key is repeated
> >> just befor the new one:
> >>
> >> after pressing key 1:
> >> 0000000080010002 00 KEY_1 devinput
> >>
> >> after pressing key 2:
> >> 0000000080010002 00 KEY_1 devinput
> >> 0000000080010003 00 KEY_2 devinput
> >>
> >> after pressing key 3:
> >> 0000000080010003 00 KEY_2 devinput
> >> 0000000080010004 00 KEY_3 devinput
> >>
> >> after pressing key 4:
> >> 0000000080010004 00 KEY_3 devinput
> >> 0000000080010005 00 KEY_4 devinput
> >>
> >> after pressing key 5:
> >> 0000000080010005 00 KEY_4 devinput
> >> 0000000080010006 00 KEY_5 devinput
> >>
> >>
> >> My configuration:
> >> Archlinux (allways up-to-date)
> >> Asus MyCinema P7131 with remote control PC-39
> >> lircd 0.9.0, driver devinput, default config file lirc.conf.devinput
> >> kernel 2.6.38
> >>
> >> # ir-keytable
> >> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
> >>        Driver saa7134, table rc-asus-pc39
> >>        Supported protocols: NEC RC-5 RC-6 JVC SONY LIRC
> >>        Enabled protocols: RC-5
> >>        Repeat delay = 500 ms, repeat period = 33 ms
> >>
> >> Answare from lirc-mainlinglist (Jarod Wilson):
> >> Looks like a bug in saa7134-input.c, which doesn't originate in lirc land,
> >> its from the kernel itself. The more apropos location to tackle this issue
> >> is linux-media@vger.kernel.org.
> >>
> >> I can provide any other listings, just ask for them.
> >>
> >> Thank you for any help,
> >> Radim
> >
> > I actually sent Jarod a board specifically to investigate this issue
> > (the same issue occurs on the saa7134 based HVR-1150).  I believe it's
> > on his TODO list.
> 
> Yep, he chopped out the part of my reply where I said as much. :)
> 
> Just waiting on the IR receiver cable to arrive, could well be here in 
> today's mail...
> 
> -- 
> Jarod Wilson
> jarod@redhat.com
> 
> 

Oh, I misunderstood Jarod answer - he pointed me to this list as a right place for posting this possible bug in saa7134 driver, so I sent it also here. I was thinking that this is not a job for member of lirc developers, so I was trying luck here..

Thanks for now, I'll be waiting for any results from Jarod, if I can help just tell me how..

Radim
