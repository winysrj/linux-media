Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57124 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3FRPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 11:18:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media ML <linux-media@vger.kernel.org>
Subject: Re: double-buffering with the omap3 parallel interface
Date: Tue, 18 Jun 2013 17:18:34 +0200
Message-ID: <2509851.dYUFSdVPB5@avalon>
In-Reply-To: <20130616234449.GB2064@valkosipuli.retiisi.org.uk>
References: <51B89EDA.90107@matrix-vision.de> <20130616234449.GB2064@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Monday 17 June 2013 02:44:50 Sakari Ailus wrote:
> On Wed, Jun 12, 2013 at 06:16:26PM +0200, Michael Jones wrote:
> > Hi Laurent & co.,
> > 
> > I'd like to look at what the maximum possible frame rates are for a sensor
> > connected to the OMAP3 ISP CCDC via the parallel interface, writing frames
> > directly to memory. I understand that there is some minimum amount of time
> > required between frames to pass on the finished frame and set up the
> > address to be written to for the next frame. From the manual it looks like
> > a double buffering scheme would've been available on a different sensor
> > interface, but isn't on the parallel one.
> > 
> > Do I see that right? Is it impossible to use double buffering of any sort
> > while using the parallel interface to memory?

That's correct. The CCDC has a single destination memory address register, so 
you can only queue a single buffer to the hardware.

> > I'm still using an older version of the driver, but I've browsed the
> > current state of the code, too. What behavior do you expect if the time
> > between frames is too short for the buffer management? Can it be recovered
> > from?

The CCDC is stopped after each frame, reconfigured, and then restarted. If a 
new frame arrives before the CCDC is restarted the frame will be dropped, but 
the CCDC might lose synchronization as well (this would need to be verified, 
the OMAP3 ISP hardware is pretty sensitive to such issues, but I don't 
remember from the top of my head the details of what synchronization problems 
affect each block).

> > Has this behavior changed in recent versions?

The overall behaviour shouldn't have changed, no.

> > I see from the ISP block diagram that the "circular buffer" is between the
> > SBL and the MMU. Could this maybe be used to help the situation? It seems
> > to currently not be used at all along this path.

Not that I know of. The circular buffer allows allocating less physical memory 
than what would be required to store a full frame, if the consumer can process 
image data as it gets written to memory. The memory buffer then essentially 
acts as a FIFO.

> The way the hardware is controlled has stayed the same for a very long time.
> My recollection matches with your findings --- even if double buffering of
> the buffer pointers would be available in some situations, it isn't used by
> the driver. You might ask why, and the reason for that is that there are
> tonds of other things that typically need to be configured (as a result of
> the configuration given by the user using the private IOCTLs) at that very
> time. If a block becomes busy while you're configuring it you can say good
> bye to your frame in any case; whether yousd set up writing it to system
> memory using DMA or not...

Several CCDC registers are latched by the VS sync pulse. It might thus be 
possible to reconfigure the CCDC right after frame start instead of right 
after frame end.

> What comes to the minimum time per frames, I could give you a guesstimate of
> 1 ms. It depends a lot on how well other drivers in the system behave, but
> in general that should be enough. Something must be very wrong if you need
> significantly more than that.

-- 
Regards,

Laurent Pinchart

