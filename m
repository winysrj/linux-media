Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39841 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752502AbcKDIFb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 04:05:31 -0400
Subject: Re: [PATCH RESEND] media: omap3isp: Use dma_request_chan() to
 requesting DMA channel
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20161102123959.6098-1-peter.ujfalusi@ti.com>
 <9b482d6b-5750-9c9d-e9a8-b113788fbb67@ti.com>
 <6d504f4d-44b0-467d-de21-6fd12771dfc5@ti.com> <5665893.fe4E5jvxvE@avalon>
CC: <mchehab@osg.samsung.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <8af57c52-5fc9-bad8-1a9e-905e457831e2@ti.com>
Date: Fri, 4 Nov 2016 10:05:27 +0200
MIME-Version: 1.0
In-Reply-To: <5665893.fe4E5jvxvE@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/03/2016 05:12 PM, Laurent Pinchart wrote:
>> It is a bit misleading that it used dma_request_slave_channel_compat()
>> for getting the channel.
>>
>> I think what would be correct is:
>> dma_cap_mask_t mask;
>>
>> dma_cap_zero(mask);
>> dma_cap_set(DMA_SLAVE, mask);
>> hist->dma_ch = dma_request_chan_by_mask(&mask);
>>
>> We will get any DMA channel capable of slave configuration, but we will
>> configure no DMA request number for the channel.
> 
> I believe that should work. It could in theory result in a different behaviour 
> as it could return a DMA channel not handled by the OMAP SDMA engine, but I 
> don't think that would be an issue.

Yes, that could be the case if we would have more than one DMAs in SoCs
where the omap3isp is used, but we only have sDMA.

The reason why I would like to move the driver to use the generic API is
that my plan is to remove the legacy sDMA support in the future so the
filter_fn is not going to be available outside of the DMAengine driver.

I do believe that this is safe to do in this way and if the IP shows up
somewhere else where we have more than one DMAs - which is unlikely -
I'm sure it can be fixed up, but w/o device it is hard to guess what
needs to be done.
FWIW: if omap3isp shows up where we have sDMA and eDMA we can set the
mask as DMA_SLAVE | DMA_MEMCPY as eDMA does not set both for a channel -
it is either slave or memcpy.

>> and document this in the driver...
> 

-- 
Péter
