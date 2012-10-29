Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55424 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136Ab2J2Nfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 09:35:43 -0400
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
From: Andy Walls <awalls@md.metrocast.net>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Date: Mon, 29 Oct 2012 09:32:27 -0400
In-Reply-To: <2183412.VijGEEfCXd@f17simon>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
	 <3124636.sEoNQbeq5Q@f17simon> <20121029095817.0bad37b3@infradead.org>
	 <2183412.VijGEEfCXd@f17simon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1351517548.2503.18.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-10-29 at 13:02 +0000, Simon Farnsworth wrote:
> On Monday 29 October 2012 09:58:17 Mauro Carvalho Chehab wrote:
> > I prefer if you don't c/c me on that ;) Patchwork is the main source that I use
> > on my patch reviews.
> > 
> Noted.
> 
> > Btw, I saw your patch yesterday (and skipped it, for now), as I never played
> > with those pm QoS stuff before, nor I ever noticed anything like what you
> > reported on saa7134 (but I can't even remember the last time I tested something
> > on a saa7134 board ;) - so, it can be some new bug).
> > 
> > So, I'll postpone its review to when I have some time to actually test it
> > especially as the same issue might also be happening on other drivers.
> > 
> It will affect other drivers as well; the basic cause is that modern chips
> can enter a package deep sleep state that affects both CPU speed and latency
> to start of DMA. On older systems, this couldn't happen - the Northbridge
> kept running at all times, and DMA latencies were low.
> 
> However, on the Intel Sandybridge system I'm testing with, the maximum wake
> latency from deep sleep is 109 microseconds; the SAA7134's internal FIFO can't
> hold onto data for that long, and overflows, resulting in the corruption I'm
> seeing. The pm QoS request fixes this for me, by telling the PM subsystem
> that the SAA7134 cannot cope with a long latency on the first write of a DMA
> transfer.
> 
> Now, some media bridges (like the ones driven by the cx18 driver) can cope
> with very high latency before the beginning of a DMA burst. Andy Walls has
> worked on the cx18 driver to cope in this situation, so it doesn't fail even
> with the 109 microsecond DMA latency we have on Sandybridge.

Well if brdige wake-up DMA latency is the problem, it is alos the case
that the CX23418 has a *lot* of on board memory with which to collect
video and compress it.  (And lets face it, the CX23418 is an SoC with
two ARM cores and a lot of dedicated external memory, as opposed to the
SAA7134 with 1 kB of FIFO.)   That hardware helps quite a bit, if the
PCI bus is slow to wake up.

I found a SAA7134 sheet for you:

http://www.nxp.com/documents/data_sheet/SAA7134HL.pdf

Section 6.4.3 has a short description of the behaviour when the FIFO
overflows.

But this sheet (close enough):

http://www.nxp.com/documents/data_sheet/SAA7133HL.pdf

Has much nicer examples of the programmed levels of the FIFO in section
6.4.3.  That 1 kB is for everything: raw VBI, Y, U, V, MPEG, and Audio.
So you're lucky if one full line of video fits in the FIFO.

> Others, like the SAA7134, just don't have that much buffering, and we need
> to ask the pm core to cope with it. I suspect that most old drivers will need
> updating if anyone wants to use them with modern systems; either they'll have
> an architecture like the cx18 series, and the type of work Andy has done will
> fix the problem, or they'll behave like the saa7134, and need a pm_qos request
> to ensure that the CPU package (and thus memory controller) stay awake.

Unless the chip has a lot of internal memory and processing resources, I
suspect a pm_qos solution is needed to ensure the PCI bus responds in
time.

This is a system level issue though.  Having the drivers decide what QoS
they need in the absences of total system requirements, is the right
thing for the home user.  It might not be very friendly for a
professional solution where someone is trying to tune the use of the
system IO bandwidth and CPU resources.

The ivtv driver and cx18 driver unconditionally bumping up their PCI
latency timer to 64 cycles minimum always bugged me: drivers shouldn't
be deciding QoS in a vaccuum.  But, then again, user complaints went
away and the 64 PCI cycles seemed to be a minimum QoS that everyone
needed.  Also both drivers have a ivtv/cx18_pci_latency module option to
override the behaviour anyway.


-Andy

