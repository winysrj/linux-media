Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbKJH4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 02:56:33 -0500
Subject: Re: [PATCH 12/13] [media] omap3isp: Support for deferred probing when
 requesting DMA channel
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-13-git-send-email-peter.ujfalusi@ti.com>
 <11319647.puY9n5DpsR@avalon>
CC: <vinod.koul@intel.com>, <tony@atomide.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <5641A321.2070209@ti.com>
Date: Tue, 10 Nov 2015 09:56:17 +0200
MIME-Version: 1.0
In-Reply-To: <11319647.puY9n5DpsR@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/09/2015 09:50 PM, Laurent Pinchart wrote:
> Hi Peter,
> 
> Thank you for the patch.
> 
> What happened to this patch series ? It looks like 
> dma_request_slave_channel_compat_reason() isn't in mainline, so I can't apply 
> this patch.
> 
> I'll mark this patch as deferred in patchwork, please resubmit it if you 
> resubmit the series

The original series - containing this patch - generated a bit of discussion
and it seams that I will need to do bigger change in the dmaengine API
compared to this.
I think this patch can be dropped as the dmaengine changes will not go in as
they were.

(and by the look of it the issue you're trying to fix
> still exists, so it would be nice if you could get it eventually fixed).

Yes, the issue still valid for the OMAP/DaVinci driver the series was touching.

I will try to send a new series in the coming weeks.

Thanks,
Péter
> 
> On Tuesday 26 May 2015 16:26:07 Peter Ujfalusi wrote:
>> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
>> channel. Only fall back to pio mode if the error code returned is not
>> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> ---
>>  drivers/media/platform/omap3isp/isphist.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isphist.c
>> b/drivers/media/platform/omap3isp/isphist.c index
>> 7138b043a4aa..e690ca13af0e 100644
>> --- a/drivers/media/platform/omap3isp/isphist.c
>> +++ b/drivers/media/platform/omap3isp/isphist.c
>> @@ -499,14 +499,20 @@ int omap3isp_hist_init(struct isp_device *isp)
>>  		if (res)
>>  			sig = res->start;
>>
>> -		hist->dma_ch = dma_request_slave_channel_compat(mask,
>> +		hist->dma_ch = dma_request_slave_channel_compat_reason(mask,
>>  				omap_dma_filter_fn, &sig, isp->dev, "hist");
>> -		if (!hist->dma_ch)
>> +		if (IS_ERR(hist->dma_ch)) {
>> +			ret = PTR_ERR(hist->dma_ch);
>> +			if (ret == -EPROBE_DEFER)
>> +				return ret;
>> +
>> +			hist->dma_ch = NULL;
>>  			dev_warn(isp->dev,
>>  				 "hist: DMA channel request failed, using PIO\n");
>> -		else
>> +		} else {
>>  			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
>>  				dma_chan_name(hist->dma_ch));
>> +		}
>>  	}
>>
>>  	hist->ops = &hist_ops;
> 

