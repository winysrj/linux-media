Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46879 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1ABTDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 14:03:18 -0500
Received: by eye27 with SMTP id 27so5723756eye.19
        for <linux-media@vger.kernel.org>; Sun, 02 Jan 2011 11:03:17 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: TeVii S470 dvb-s2 issues - 2nd try ,)
Date: Sun, 2 Jan 2011 21:01:45 +0200
Cc: me@boris64.net, linux-media@vger.kernel.org
References: <201012161429.32658.me@boris64.net> <201012181440.56078.me@boris64.net> <1292682185.2397.16.camel@morgan.silverblock.net>
In-Reply-To: <1292682185.2397.16.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101022101.45350.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

В сообщении от 18 декабря 2010 16:23:05 автор Andy Walls написал:
> On Sat, 2010-12-18 at 14:40 +0100, Boris Cuber wrote:
> > Am Friday 17 December 2010 schrieben Sie:
> > > On Fri, 2010-12-17 at 12:19 +0100, Boris Cuber wrote:
> > > > Hello linux-media people!
> > > > 
> > > > I have to problems with my dvb card ("TeVii S470"). I already
> > > > filed 2 bug reports some time ago, but no one seems to have
> > > > noticed/read them, so i'm trying it here now.
> > > > If you need a "full" dmesg, then please take a look at
> > > > https://bugzilla.kernel.org/attachment.cgi?id=40552
> > > > 
> > > > 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after
> > > > pm-suspend/resume" https://bugzilla.kernel.org/show_bug.cgi?id=16467
> > > 
> > > The cx23885 driver does not implement power management.  It would
> > > likely take many, many hours of coding and testing to implement it
> > > properly.
> > > 
> > > If you need resume/suspend, use the power management scripts on your
> > > machine to kill all the applications using the TeVii S470, and then
> > > unload the cx23885 module just before suspend.
> > > 
> > > On resume, have the power management scripts reload the cx23885 module.
> > 
> > Well, this doesn't work. If i did tune a channel before or used the dvb
> > card somehow for watching tv, unloading and reloading the cx23885
> > module also makes the card unuseable.
> > In dmesg there's lots of "do_IRQ: 1.161 No irq handler for vector (irq
> > -1)" messages then. This can only be fixed by rebooting the computer.
> 
> That is s a known issue with the CX2388[578] chip and PCIe MSI.
> 
> The CX2388[578] will not accept a different value for its "MSI Data"
> field in its PCI config space, when MSI has been enabled on the hardware
> once.
> 
> The kernel will always try to give a different value for the "MSI Data"
> field to the CX2388[578] chip, on cx23885 module unload and reload.
> 
> So suspend and then resume didn't reset the chip hardware?
> 
> You can set "pci=nomsi" on your kernel command line to prevent the
> cx23885 driver, and your whole system unfortunately, from using MSI.
> 
Clearing bit 8 in RDR_RDRCTL1 register disables MSI for cx23885 chip effectively.
It is usefull workaround for now.
I submitted appropriate patch for NetUP cards already.

> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
