Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56573 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbcKCPJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 11:09:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] media: omap3isp: Use dma_request_chan() to requesting DMA channel
Date: Thu, 03 Nov 2016 17:09:55 +0200
Message-ID: <7701230.8T98ZHD6cs@avalon>
In-Reply-To: <9b482d6b-5750-9c9d-e9a8-b113788fbb67@ti.com>
References: <20161102123959.6098-1-peter.ujfalusi@ti.com> <1758201.F0bdTd4b9u@avalon> <9b482d6b-5750-9c9d-e9a8-b113788fbb67@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Thursday 03 Nov 2016 11:23:50 Peter Ujfalusi wrote:
> On 11/02/2016 11:19 PM, Laurent Pinchart wrote:
> > On Wednesday 02 Nov 2016 14:39:59 Peter Ujfalusi wrote:
> >> With the new dma_request_chan() the client driver does not need to look
> >> for the DMA resource and it does not need to pass filter_fn anymore.
> >> By switching to the new API the driver can now support deferred probing
> >> against DMA.
> > 
> > I believe this breaks the OMAP3 ISP driver.
> > dma_request_slave_channel_compat() is a superset of dma_request_chan()
> > that will, when called with omap_dma_filter_fn, return as a fallback any
> > free channel handled by the OMAP DMA engine driver. This feature is
> > actively used by this driver and must be preserved.
> 
> The fallback to use the filter_fn is used only when booted in legacy
> mode or when requesting a channel for non slave DMA operation.
> Based on the code in the driver it is handling slave transfers, so it
> must have DMA request line coming from somewhere. If that is missing the
> driver should not be able to work as it will not start the transfer.

If I remember correctly, the OMAP3 ISP has no dedicated DMA channel is it 
doesn't issue any hardware trigger. It can use any DMA channel, and performs a 
memcpy-like operation from a FIFO exposed through a single register to a 
system memory location.

> dma_request_chan() is to be used when you want to have slave channel
> with DMA request.
> 
> If legacy mode needs to be supported then adding the hist DMA request
> number to the omap3xxx_sdma_map in arch/arm/mach-omap2/dma.c should be done.
> The reason the omap3isp is not in the table is that I could not find any
> place where the DMA resource was set (nor the DMA is specified in DT).

That's because there's no DMA request number for the OMAP3 ISP :-)

> I'm unsure how this driver could work w/o DMA request line over a random
> (and SW triggered) DMA channel with slave operation. For the slave DMA
> you need to have DMA request line.

As far as I understand, the DMA channel is software triggered, and the DMA 
engine will just perform the programmed number of transfers, without waiting 
for a hardware trigger.

-- 
Regards,

Laurent Pinchart

