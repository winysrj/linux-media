Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32103.mail.mud.yahoo.com ([68.142.207.117]:35347 "HELO
	web32103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752962AbZEGPsj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 11:48:39 -0400
Message-ID: <155119.7889.qm@web32103.mail.mud.yahoo.com>
Date: Thu, 7 May 2009 08:41:57 -0700 (PDT)
From: Agustin Ferrin Pozuelo <agustin.ferrin@yahoo.com>
Subject: Solved? - Re: soc-camera: timing out during capture - Re: Testing latest mx3_camera.c
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Holy cow...


On Tue, 5 May 2009, Agustin wrote:
> On Tue, 5 May 2009, Guennadi Liakhovetski wrote:
> > On Tue, 5 May 2009, Agustin wrote:
> > 
> > > No, as there is no driver_match_device() in 2.6.29 nor in my patched 
> > > version. How important is that?
> > 
> > No, sorry, forget it, that's not your problem.
> > 
> > > Meanwhile I noticed that IRQ 176 is being triggered, then discarded as 
> > > "unhandled" by ipu_idmac, who gives the message "IRQ on active buffer on 
> > > channel 7, active 0, ready 0, 0, current 0!" below...
> > 
> > Yes, and this is not good. If you look in drivers/dma/ipu/ipu_idmac.c 
> > idmac_interrupt() you'll see, that this message is printed when IDMAC 
> > produces an interrupt for a DMA buffer, but at the same time it says, that 
> > the buffer, that should have completed is still in use... I've seen a few 
> > of such inconsistencies, and up to now always managed to get rid of them 
> > in one or another way. But that should not be related to the conversion. 
> > Maybe your formats on the sensor and on the SoC do not match, verify that.
> 
> Thanks for the tip but I am still out of luck. I enabled DEBUG in ipu_idmac.c 
> just to see that frame start and end are happening more or less when they 
> should:
> 
>    [...]
>    camera 0-0: mx3_camera: Submitted cookie 2 DMA 0x86400000
>    Got SOF IRQ 177 on Channel 7
>    Got EOF IRQ 178 on Channel 7
>    dma dma0chan7: ipu_idmac: IDMAC irq 176, buf 0
>    dma dma0chan7: ipu_idmac: IRQ on active buffer on channel 7, active 0, ready 
> 0, 0, current 0!
>    Select timeout.
>    [...]
> 
> I also configured everything to the simplest mode I can have: 8-bit bus, sample 
> falling.
> 
> So I am now looking at IDMAC, trying to guess what could be wrong... [snip]

After checking out every single bit in CSI and IDMAC to be correct according to reference and the same I had in the previous/working version...

I thought about the fact that I was only queuing one buffer, and that this might be a corner case as sample code uses a lot of them. And that in the older code that funny things could happen in the handler if we ran out of buffers, though they didn't happen.

So I have queued an extra buffer and voila, got it working.

So thanks again!

However, this could be a bug in ipu_idmac (or some other point), as using a single buffer is very plausible, specially when grabbing huge stills.

--Agustín.

[snip!]

