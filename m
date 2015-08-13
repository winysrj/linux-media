Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40867 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbHMNtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 09:49:51 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NT000ES6X2ZBZ40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Aug 2015 14:49:47 +0100 (BST)
Subject: Re: [PATCH v2] media: videobuf2-dc: set properly dma_max_segment_size
To: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org
References: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com>
 <55CC904E.4040907@metafoo.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <55CCA07A.2090904@samsung.com>
Date: Thu, 13 Aug 2015 15:49:46 +0200
MIME-version: 1.0
In-reply-to: <55CC904E.4040907@metafoo.de>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-08-13 14:40, Lars-Peter Clausen wrote:
> On 08/12/2015 11:58 AM, Marek Szyprowski wrote:
>> If device has no DMA max_seg_size set, we assume that there is no limit
>> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
>> let DMA-mapping API always create contiguous mappings in DMA address
>> space. This is essential for all devices, which use dma-contig
>> videobuf2 memory allocator.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> Changelog:
>> v2:
>> - set max segment size only if a new dma params structure has been
>>    allocated, as suggested by Laurent Pinchart
>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 94c1e64..455e925 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -862,6 +862,21 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>>   void *vb2_dma_contig_init_ctx(struct device *dev)
>>   {
>>   	struct vb2_dc_conf *conf;
>> +	int err;
>> +
>> +	/*
>> +	 * if device has no max_seg_size set, we assume that there is no limit
>> +	 * and force it to DMA_BIT_MASK(32) to always use contiguous mappings
>> +	 * in DMA address space
>> +	 */
>> +	if (!dev->dma_parms) {
>> +		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
>> +		if (!dev->dma_parms)
>> +			return ERR_PTR(-ENOMEM);
>> +		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
>> +		if (err)
>> +			return ERR_PTR(err);
>> +	}
> I'm not sure if this is such a good idea. The DMA provider is responsible
> for setting this up. We shouldn't be overwriting this here on the DMA
> consumer side. This will just mask the bug that the provider didn't setup
> this correctly and might cause bugs on its own if it is not correct. It will
> lead to conflicts with DMA providers that have multiple consumers (e.g.
> shared DMA core). And also the current assumption is that if a driver
> doesn't set this up explicitly the maximum segement size is 65536.

The problem is that there is no good place for changing this extremely 
low default
value. V4L2 media devices, which use videobuf2-dc expects to get buffers 
mapped
contiguous in the DMA/IO address space. Initially I wanted to have a 
code for
setting dma max segment size directly in the dma-mapping subsystem. This 
however
causeed problems in the other places, as mentioned in the following mail:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html

It looks that there are drivers or subsystems which rely on this strange 
64k value,
rending the whole concept rather useless.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

