Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41490 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752694AbcKCJX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 05:23:56 -0400
Subject: Re: [PATCH RESEND] media: omap3isp: Use dma_request_chan() to
 requesting DMA channel
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20161102123959.6098-1-peter.ujfalusi@ti.com>
 <1758201.F0bdTd4b9u@avalon>
CC: <mchehab@osg.samsung.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <9b482d6b-5750-9c9d-e9a8-b113788fbb67@ti.com>
Date: Thu, 3 Nov 2016 11:23:50 +0200
MIME-Version: 1.0
In-Reply-To: <1758201.F0bdTd4b9u@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/02/2016 11:19 PM, Laurent Pinchart wrote:
> Hi Peter,
> 
> Thank you for the patch.
> 
> On Wednesday 02 Nov 2016 14:39:59 Peter Ujfalusi wrote:
>> With the new dma_request_chan() the client driver does not need to look for
>> the DMA resource and it does not need to pass filter_fn anymore.
>> By switching to the new API the driver can now support deferred probing
>> against DMA.
> 
> I believe this breaks the OMAP3 ISP driver. dma_request_slave_channel_compat() 
> is a superset of dma_request_chan() that will, when called with 
> omap_dma_filter_fn, return as a fallback any free channel handled by the OMAP 
> DMA engine driver. This feature is actively used by this driver and must be 
> preserved.

The fallback to use the filter_fn is used only when booted in legacy
mode or when requesting a channel for non slave DMA operation.
Based on the code in the driver it is handling slave transfers, so it
must have DMA request line coming from somewhere. If that is missing the
driver should not be able to work as it will not start the transfer.

dma_request_chan() is to be used when you want to have slave channel
with DMA request.

If legacy mode needs to be supported then adding the hist DMA request
number to the omap3xxx_sdma_map in arch/arm/mach-omap2/dma.c should be done.
The reason the omap3isp is not in the table is that I could not find any
place where the DMA resource was set (nor the DMA is specified in DT).

I'm unsure how this driver could work w/o DMA request line over a random
(and SW triggered) DMA channel with slave operation. For the slave DMA
you need to have DMA request line.

-- 
Péter

>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> ---
>> Hi,
>>
>> the original patch was sent 29.04.2016:
>> https://patchwork.kernel.org/patch/8981811/
>>
>> I have rebased it on top of linux-next.
>>
>> Regards,
>> Peter
>>
>>  drivers/media/platform/omap3isp/isphist.c | 27 +++++++++------------------
>>  1 file changed, 9 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isphist.c
>> b/drivers/media/platform/omap3isp/isphist.c index
>> 7138b043a4aa..e163e3d92517 100644
>> --- a/drivers/media/platform/omap3isp/isphist.c
>> +++ b/drivers/media/platform/omap3isp/isphist.c
>> @@ -18,7 +18,6 @@
>>  #include <linux/delay.h>
>>  #include <linux/device.h>
>>  #include <linux/dmaengine.h>
>> -#include <linux/omap-dmaengine.h>
>>  #include <linux/slab.h>
>>  #include <linux/uaccess.h>
>>
>> @@ -486,27 +485,19 @@ int omap3isp_hist_init(struct isp_device *isp)
>>  	hist->isp = isp;
>>
>>  	if (HIST_CONFIG_DMA) {
>> -		struct platform_device *pdev = to_platform_device(isp->dev);
>> -		struct resource *res;
>> -		unsigned int sig = 0;
>> -		dma_cap_mask_t mask;
>> -
>> -		dma_cap_zero(mask);
>> -		dma_cap_set(DMA_SLAVE, mask);
>> -
>> -		res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
>> -						   "hist");
>> -		if (res)
>> -			sig = res->start;
>> -
>> -		hist->dma_ch = dma_request_slave_channel_compat(mask,
>> -				omap_dma_filter_fn, &sig, isp->dev, "hist");
>> -		if (!hist->dma_ch)
>> +		hist->dma_ch = dma_request_chan(isp->dev, "hist");
>> +		if (IS_ERR(hist->dma_ch)) {
>> +			ret = PTR_ERR(hist->dma_ch);
>> +			if (ret == -EPROBE_DEFER)
>> +				return ret;
>> +
>> +			hist->dma_ch = NULL;
>>  			dev_warn(isp->dev,
>>  				 "hist: DMA channel request failed, using 
> PIO\n");
>> -		else
>> +		} else {
>>  			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
>>  				dma_chan_name(hist->dma_ch));
>> +		}
>>  	}
>>
>>  	hist->ops = &hist_ops;
> 
