Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46119 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab0LROWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 09:22:22 -0500
Subject: Re: TeVii S470 dvb-s2 issues - 2nd try ,)
From: Andy Walls <awalls@md.metrocast.net>
To: me@boris64.net
Cc: linux-media@vger.kernel.org
In-Reply-To: <201012181440.56078.me@boris64.net>
References: <201012161429.32658.me@boris64.net>
	 <201012171219.29473.me@boris64.net>
	 <1292591576.2077.19.camel@morgan.silverblock.net>
	 <201012181440.56078.me@boris64.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 09:23:05 -0500
Message-ID: <1292682185.2397.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 2010-12-18 at 14:40 +0100, Boris Cuber wrote:
> Am Friday 17 December 2010 schrieben Sie:
> > On Fri, 2010-12-17 at 12:19 +0100, Boris Cuber wrote:
> > > Hello linux-media people!
> > > 
> > > I have to problems with my dvb card ("TeVii S470"). I already
> > > filed 2 bug reports some time ago, but no one seems to have
> > > noticed/read them, so i'm trying it here now.
> > > If you need a "full" dmesg, then please take a look at
> > > https://bugzilla.kernel.org/attachment.cgi?id=40552
> > > 
> > > 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after
> > > pm-suspend/resume" https://bugzilla.kernel.org/show_bug.cgi?id=16467
> > 
> > The cx23885 driver does not implement power management.  It would likely
> > take many, many hours of coding and testing to implement it properly.
> > 
> > If you need resume/suspend, use the power management scripts on your
> > machine to kill all the applications using the TeVii S470, and then
> > unload the cx23885 module just before suspend.
> > 
> > On resume, have the power management scripts reload the cx23885 module.
> >
> Well, this doesn't work. If i did tune a channel before or used the dvb card
> somehow for watching tv, unloading and reloading the cx23885
> module also makes the card unuseable.
> In dmesg there's lots of "do_IRQ: 1.161 No irq handler for vector (irq -1)"
> messages then. This can only be fixed by rebooting the computer.

That is s a known issue with the CX2388[578] chip and PCIe MSI.

The CX2388[578] will not accept a different value for its "MSI Data"
field in its PCI config space, when MSI has been enabled on the hardware
once.

The kernel will always try to give a different value for the "MSI Data"
field to the CX2388[578] chip, on cx23885 module unload and reload.

So suspend and then resume didn't reset the chip hardware?

You can set "pci=nomsi" on your kernel command line to prevent the
cx23885 driver, and your whole system unfortunately, from using MSI.
 
Regards,
Andy

