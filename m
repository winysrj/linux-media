Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60434 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221Ab2J2O3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 10:29:06 -0400
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
From: Andy Walls <awalls@md.metrocast.net>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Date: Mon, 29 Oct 2012 10:27:42 -0400
In-Reply-To: <2183412.VijGEEfCXd@f17simon>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
	 <3124636.sEoNQbeq5Q@f17simon> <20121029095817.0bad37b3@infradead.org>
	 <2183412.VijGEEfCXd@f17simon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1351520868.2503.37.camel@palomino.walls.org>
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
> hold onto data for that long, and overflows,

BTW

For Y:U:Y:V or raw VBI with a PAL line rate
109 usecs * 15,625 lines/sec ~= 1.7 lines

1.7 lines * 1440 samples/line ~= 2452 samples

2452 samples / 1024 samples/FIFO ~= 2.4 FIFOs

So 109 usecs fully overruns the FIFO by about 1.4 FIFO depths.


>  resulting in the corruption I'm
> seeing. The pm QoS request fixes this for me, by telling the PM subsystem
> that the SAA7134 cannot cope with a long latency on the first write of a DMA
> transfer.

Regards,
Andy

