Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:51471 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AQD5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 22:57:04 -0500
Received: from opus ([unknown] [71.170.160.242]) by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0LXX00AWO9IFMF61@vms173019.mailsrvcs.net> for
 linux-media@vger.kernel.org; Mon, 16 Jan 2012 20:56:43 -0600 (CST)
Date: Mon, 16 Jan 2012 20:56:39 -0600
From: David Engel <david@istwok.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Strange problem, help needed
Message-id: <20120117025638.GA2688@opus.istwok.net>
References: <20120116175556.GB29539@opus.istwok.net>
 <1326739528.2500.13.camel@palomino.walls.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1326739528.2500.13.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 16, 2012 at 01:45:24PM -0500, Andy Walls wrote:
> On Mon, 2012-01-16 at 11:55 -0600, David Engel wrote:
> > Hi,
> > 
> > I have a MythTV backend with a Hauppauge HVR-2250 (dual tuner,
> > ATSC?QAM, PCIe) and a Ceton InfiniTV4 (quad tuner, QAM/cable card,
> > PCIe).  Over the weekend, I started intermittently seeing corrupt
> > recordings that were painful to watch.
> > 
> > I eventually narrowed the problem down to when both tuners on the 2250
> > are active at the same time.  In this case, both recordings have
> > corruption (CRC errors, etc.).  The InfiniTV4 does not appear to be
> > affected by anything going on on the 2250.  Likewise, the 2250 does
> > not appear to be affected by anything going on on the InfiniTV4.
> > 
> > I noticed something strange while diagnosinig the problem.  When the
> > 2250 is busy recording, top reports the CPU as being in wait for an
> > abnormally high amount of time (~30% for one tuner busy and ~50% for
> > both tuners busy).  I don't recall seeing that before.  I quickly
> > tried a KWorld ATSC 110 on a different system and it showed no, or
> > negligible wait time.
> > 
> > Thinking that the 2250 was going bad, I replaced it with two KWorld
> > ATSC 110s (single tuner, ATSC/QAM, PCI).  The two 110s had the same
> > problem as the 2250 -- corruption when both tuners are busy and
> > unusually high wait time when either is busy.
> > 
> > At this point, I'm suspecting a motherboard, memory or grounding
> > issue, but would like some feedback in case there's anything I'm
> > missing.  The high wait time seems extremely odd to me.  Perhaps it
> > means something to those of you who are much more familiar with the
> > cards and drivers.
> 
> A long time in IO Wait and (presumably) dropped video data buffers for a
> TV card driver usually means:
> 
> a. The devices are not producing interrupts
> b. Your system is dropping interrupts from the devices
> c. Something in your system keeps interrupt processing disabled for a
> long time.

I tried the crude test of monitoring /proc/interrupts while recording.
Using a third KWorld ATSC 110 on my development system, which isn't
showing any problems, the driver serviced ~1200 interrupts per minute.
I saw the same amount per card using two other 110s on my MythTV system, which
is exhibiting the problem.

> Of the above c. is unlikely.
> 
> The root causes of a. and b. are many and varied.  However most of those
> root causes are under control of kernel software: core IRQ handling,
> core PCI/e bus setup, or tv card driver modules and their supporting
> modules.
> 
> Hardware related root causes would be buggy PCI chipsets, poor RF
> signal, a motherboard problem, or a power problem.
> 
> I tend to blame the software before the hardware.
> 
> 
> Sometimes, dust in the shared, conventional PCI bus can cause problems.
> If you have conventional PCI slots in the system - whether you use them
> or not -  unplug the conventional PCI cards, blow the dust out of all
> the slots, and reseat the cards.  You should not need to do this for any
> PCIe card slots, but it doesn't hurt.

I also tried the HVR-2250 in my development system this evening.  It
worked fine.  It's definitely something specific to my MythTV system.
I can't do any further testing until Wednesday.  Thoroughly blowing
out the case might have to wait until the weekend.

Thanks for you help.

David

> Regards,
> Andy 
> 
> > Oh, the problem appear shortly after switching to the 3.1.9 kernel.  I
> > also tried the 3.1.8 and 3.0.14 kernels to rule out software and there
> > was no effect on the problem.
> 
> > David
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
David Engel
david@istwok.net
