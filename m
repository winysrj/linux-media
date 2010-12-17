Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38489 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab0LQNMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 08:12:14 -0500
Subject: Re: TeVii S470 dvb-s2 issues - 2nd try ,)
From: Andy Walls <awalls@md.metrocast.net>
To: me@boris64.net
Cc: linux-media@vger.kernel.org
In-Reply-To: <201012171219.29473.me@boris64.net>
References: <201012161429.32658.me@boris64.net>
	 <AANLkTi=X-xn+iSmp5OLGP-FK8dqvyRgEcX-HjTQF5dHn@mail.gmail.com>
	 <201012171219.29473.me@boris64.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 08:12:56 -0500
Message-ID: <1292591576.2077.19.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 2010-12-17 at 12:19 +0100, Boris Cuber wrote:
> Hello linux-media people!
> 
> I have to problems with my dvb card ("TeVii S470"). I already
> filed 2 bug reports some time ago, but no one seems to have
> noticed/read them, so i'm trying it here now.
> If you need a "full" dmesg, then please take a look at
> https://bugzilla.kernel.org/attachment.cgi?id=40552
> 
> 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after
> pm-suspend/resume" https://bugzilla.kernel.org/show_bug.cgi?id=16467

The cx23885 driver does not implement power management.  It would likely
take many, many hours of coding and testing to implement it properly.

If you need resume/suspend, use the power management scripts on your
machine to kill all the applications using the TeVii S470, and then
unload the cx23885 module just before suspend.

On resume, have the power management scripts reload the cx23885 module.



> 2) "cx23885: ds3000_writereg: writereg error on =kernel-2.6.36-rc with
> TeVii" S470 dvb-s2 card
> -> https://bugzilla.kernel.org/show_bug.cgi?id=18832
> 
> These error messages show up in dmesg while switching channels in 
> mplayer/kaffeine.
> [dmesg output]
> [  919.789976] ds3000_writereg: writereg error(err == -6, reg == 0x03,
> value == 0x11)

They look like I2C bus errors; error -6 is ENXIO, which is probably
coming from cx23885-i2c.c.

The device handled by the ds3000 driver is not responding properly to
the CX23885.  It could be that some other device on that I2C bus is hung
up or the ds3000 device itself.  Maybe some GPIO settings are set wrong?

The cx23885 module supports an i2c_probe and i2c_debug module option
that will turn on some messages related to i2c.


I really have no other advice, except that if you do a git bisect
process, you may find the commit(s) that caused the problem.

Regards,
Andy

> Are these issues known? If so, are there any fixes yet? When will these
> get into mainline? Could somebody point me into the right direction.
> Can i help somehow to debug these problems?
> 
> Thank you in advance.
> 
> Regards,
> 	Boris Cuber
> 
> PS: Thank Emanuel for helping me out with this mail ,)


