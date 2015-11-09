Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([207.82.80.143]:40162 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbbKIP1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 10:27:08 -0500
Subject: Re: [RFC/PATCH] media: omap3isp: Set maximum DMA segment size
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1444742316-27986-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1560214.1Y1q0qLZA4@avalon>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux-foundation.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>, sakari.ailus@iki.fi,
	Shuah Khan <shuahkhan@gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <5640BB48.60706@arm.com>
Date: Mon, 9 Nov 2015 15:27:04 +0000
MIME-Version: 1.0
In-Reply-To: <1560214.1Y1q0qLZA4@avalon>
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/11/15 14:18, Laurent Pinchart wrote:
> Hello everybody,
>
> Ping ?

Apologies, I did start writing a response a while ago, but it ended up 
getting subsumed into the bigger DMA API discussion thread.

> On Tuesday 13 October 2015 16:18:36 Laurent Pinchart wrote:
>> The maximum DMA segment size controls the IOMMU mapping granularity. Its
>> default value is 64kB, resulting in potentially non-contiguous IOMMU
>> mappings. Configure it to 4GB to ensure that buffers get mapped
>> contiguously.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>   drivers/media/platform/omap3isp/isp.c | 4 ++++
>>   drivers/media/platform/omap3isp/isp.h | 1 +
>>   2 files changed, 5 insertions(+)
>>
>> I'm posting this as an RFC because I'm not happy with the patch, even if it
>> gets the job done.
>>
>> On ARM the maximum DMA segment size is used when creating IOMMU mappings. As
>> a large number of devices require contiguous memory buffers (this is a very
>> common requirement for video-related embedded devices) the default 64kB
>> value doesn't work.

Per the initial patch (6b7b65105522), dma_parms was intended to expose 
hardware limitations of scatter-gather-capable devices, to prevent DMA 
API implementations from merging segments beyond a device's limits. Thus 
the way 32-bit ARM (and seemingly noone else) is taking it as something 
to apply to non-scatter-gather-capable devices in order to force the DMA 
API implementation to merge segments seems very questionable.

There's nothing in the streaming DMA API which gives any guarantee of a 
contiguous mapping, so it's the incorrect assumption that it does which 
needs fixing. Whether we rework the callers or the API itself is the 
open question there, I think.

>> I haven't investigated the history behind this API in details but I have a
>> feeling something is not quite right. We force most drivers to explicitly
>> set the maximum segment size from a default that seems valid for specific
>> use cases only. Furthermore, as the DMA parameters are not stored directly
>> in struct device this require allocation of external memory for which we
>> have no proper management rule, making automatic handling of the DMA
>> parameters in frameworks or helper functions cumbersome (for a discussion
>> on this topic see http://www.spinics.net/lists/linux-media/msg92467.html
>> and http://lists.infradead.org/pipermail/linux-arm-kernel/2014-> November/305913.html).
>>
>> Is it time to fix this mess ?

I agree that it would certainly be preferable to tackle the underlying 
issue instead of adding more point hacks to further entrench 
non-portable code into the kernel. In terms of modifying the API, the 
most reasonable idea which comes to mind would be a DMA attribute, and 
on closer inspection, I see that DMA_ATTR_FORCE_CONTIGUOUS is already a 
thing - perhaps we should weigh up whether coherent and streaming DMA 
could overload the same attribute with subtly different meanings, or 
whether we'd want e.g. DMA_ATTR_FORCE_PHYS_CONTIGUOUS and 
DMA_ATTR_FORCE_DMA_CONTIGUOUS to coexist.

Robin.

>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index 17430a6ed85a..ebf7dc76e94d
>> 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -2444,6 +2444,10 @@ static int isp_probe(struct platform_device *pdev)
>>   	if (ret)
>>   		goto error;
>>
>> +	isp->dev->dma_parms = &isp->dma_parms;
>> +	dma_set_max_seg_size(isp->dev, DMA_BIT_MASK(32));
>> +	dma_set_seg_boundary(isp->dev, 0xffffffff);

Whatever happens, 002edb6f6f2a should now make this line redundant :D

>> +
>>   	platform_set_drvdata(pdev, isp);
>>
>>   	/* Regulators */
>> diff --git a/drivers/media/platform/omap3isp/isp.h
>> b/drivers/media/platform/omap3isp/isp.h index e579943175c4..4b2231cf01be
>> 100644
>> --- a/drivers/media/platform/omap3isp/isp.h
>> +++ b/drivers/media/platform/omap3isp/isp.h
>> @@ -193,6 +193,7 @@ struct isp_device {
>>   	u32 syscon_offset;
>>   	u32 phy_type;
>>
>> +	struct device_dma_parameters dma_parms;
>>   	struct dma_iommu_mapping *mapping;
>>
>>   	/* ISP Obj */
>

