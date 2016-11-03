Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56584 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757882AbcKCPMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 11:12:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] media: omap3isp: Use dma_request_chan() to requesting DMA channel
Date: Thu, 03 Nov 2016 17:12:09 +0200
Message-ID: <5665893.fe4E5jvxvE@avalon>
In-Reply-To: <6d504f4d-44b0-467d-de21-6fd12771dfc5@ti.com>
References: <20161102123959.6098-1-peter.ujfalusi@ti.com> <9b482d6b-5750-9c9d-e9a8-b113788fbb67@ti.com> <6d504f4d-44b0-467d-de21-6fd12771dfc5@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Thursday 03 Nov 2016 15:14:19 Peter Ujfalusi wrote:
> On 11/03/2016 11:23 AM, Peter Ujfalusi wrote:
> > On 11/02/2016 11:19 PM, Laurent Pinchart wrote:
> >>> On Wednesday 02 Nov 2016 14:39:59 Peter Ujfalusi wrote:
> >>>>> With the new dma_request_chan() the client driver does not need to
> >>>>> look for the DMA resource and it does not need to pass filter_fn
> >>>>> anymore. By switching to the new API the driver can now support
> >>>>> deferred probing against DMA.
> >>> 
> >>> I believe this breaks the OMAP3 ISP driver.
> >>> dma_request_slave_channel_compat() is a superset of dma_request_chan()
> >>> that will, when called with
> >>> omap_dma_filter_fn, return as a fallback any free channel handled by
> >>> the OMAP DMA engine driver. This feature is actively used by this
> >>> driver and must be preserved.
> > 
> > The fallback to use the filter_fn is used only when booted in legacy
> > mode or when requesting a channel for non slave DMA operation.
> > Based on the code in the driver it is handling slave transfers, so it
> > must have DMA request line coming from somewhere. If that is missing the
> > driver should not be able to work as it will not start the transfer.
> > 
> > dma_request_chan() is to be used when you want to have slave channel
> > with DMA request.
> > 
> > If legacy mode needs to be supported then adding the hist DMA request
> > number to the omap3xxx_sdma_map in arch/arm/mach-omap2/dma.c should be
> > done. The reason the omap3isp is not in the table is that I could not
> > find any place where the DMA resource was set (nor the DMA is specified
> > in DT).
> > 
> > I'm unsure how this driver could work w/o DMA request line over a random
> > (and SW triggered) DMA channel with slave operation. For the slave DMA
> > you need to have DMA request line.
> 
> I see now.
> The omap3isp never supposed to get valid DMA request line via
> platform_get_resource_byname(), it should never find the "hist" DMA in
> the DT data. If it does, the driver would stop working as there is no
> DMA request associated with the histogram data reading.

That's correct.

> It is a bit misleading that it used dma_request_slave_channel_compat()
> for getting the channel.
> 
> I think what would be correct is:
> dma_cap_mask_t mask;
> 
> dma_cap_zero(mask);
> dma_cap_set(DMA_SLAVE, mask);
> hist->dma_ch = dma_request_chan_by_mask(&mask);
> 
> We will get any DMA channel capable of slave configuration, but we will
> configure no DMA request number for the channel.

I believe that should work. It could in theory result in a different behaviour 
as it could return a DMA channel not handled by the OMAP SDMA engine, but I 
don't think that would be an issue.

> and document this in the driver...

-- 
Regards,

Laurent Pinchart

