Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60052 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbFCLGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 07:06:32 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPD00DL686UB790@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Jun 2015 12:06:30 +0100 (BST)
Message-id: <556EDFB5.2050903@samsung.com>
Date: Wed, 03 Jun 2015 13:06:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2-dc: set properly dma_max_segment_size
References: <1433160857-11124-1-git-send-email-m.szyprowski@samsung.com>
 <6344262.Bi3ADFT2cX@avalon>
In-reply-to: <6344262.Bi3ADFT2cX@avalon>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-06-03 03:22, Laurent Pinchart wrote:
> On Monday 01 June 2015 14:14:17 Marek Szyprowski wrote:
>> If device has no DMA max_seg_size set, we assume that there is no limit
>> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
>> let DMA-mapping API always create contiguous mappings in DMA address
>> space. This is essential for all devices, which use dma-contig
>> videobuf2 memory allocator.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index
>> 644dec73d220..9d7c1814b0f3 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -862,6 +862,23 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
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
> I was checking how dma_parms was usually allocated and freed, and was shocked
> to find that the memory is never freed. OK, actually not shocked, I had a bad
> feeling about it already, but it's still not good :-/
>
> This goes beyond the scope of this patch, but I think we need to clean up
> dma_parms. The structure is 8 bytes long on 32-bit systems and 16 bytes long
> on 64-bit systems. I wonder if it's really worth it to allocate it separately
> from struct device. It might if we moved more DMA-related fields to struct
> device_dma_parameters but that hasn't happened since 2008 when the structure
> was introduced (yes that's more than 7 years ago).
>
> If we consider it's worth it (and I believe Josh Triplett might, in the
> context of the Linux kernel tinification project), we should at least handle
> allocation and free of the field coherently across drivers.

Right, the whole dma_params approach looks like some unfinished thing. 
Maybe it
would be better to remove it completely instead of having separate structure
just for 2 values? This will solve the allocation/freeing issue as well.

>
>> +		if (!dev->dma_parms)
>> +			return ERR_PTR(-ENOMEM);
>> +	}
>> +	if (dma_get_max_seg_size(dev) < DMA_BIT_MASK(32)) {
>> +		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> What if the device has set a maximum segment size smaller than 4GB because of
> hardware limitations ?

Then it looks that it will make more sense to set max_seg_size only when dma
params structure has been allocated and keep the old value otherwise.

> I also wonder whether this is the correct place to solve the issue.

Frankly I don't see any good place for this code, especially if you consider
the default 64kB value and the fact that some code relies on it, so you 
cannot
change it easily in generic code.

> Why is the
> default value returned by dma_get_max_seg_size() set to 64kB ?

I really have no idea why the default value is 64kB, but it looks that 
there are
drivers that rely on this value:
https://www.marc.info/?l=linux-arm-kernel&m=141692087708203&w=2

>
>> +		if (err)
>> +			return ERR_PTR(err);
>> +	}
>>
>>   	conf = kzalloc(sizeof *conf, GFP_KERNEL);
>>   	if (!conf)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

