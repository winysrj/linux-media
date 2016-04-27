Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36888 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbcD0M66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 08:58:58 -0400
Subject: Re: [PATCH RESEND 1/2] media: vb2-dma-contig: add helper for setting
 dma max seg size
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1461758429-12913-1-git-send-email-m.szyprowski@samsung.com>
 <5720AC3C.8090101@xs4all.nl>
 <5900d3fc-b17a-875b-e016-ae53442641b0@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5720B78B.2080806@xs4all.nl>
Date: Wed, 27 Apr 2016 14:58:51 +0200
MIME-Version: 1.0
In-Reply-To: <5900d3fc-b17a-875b-e016-ae53442641b0@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/27/2016 02:23 PM, Marek Szyprowski wrote:
> Hello,
> 
> 
> On 2016-04-27 14:10, Hans Verkuil wrote:
>> On 04/27/2016 02:00 PM, Marek Szyprowski wrote:
>>> Add a helper function for device drivers to set DMA's max_seg_size.
>>> Setting it to largest possible value lets DMA-mapping API always create
>>> contiguous mappings in DMA address space. This is essential for all
>>> devices, which use dma-contig videobuf2 memory allocator and shared
>>> buffers.
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> ---
>>> This patch was posted earlier as a part of
>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
>>> thread, but applying it is really needed to get all Exynos multimedia
>>> drivers working with IOMMU enabled.
>>>
>>> Best regards,
>>> Marek Szyprowski
>>> ---
>>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
>>>   include/media/videobuf2-dma-contig.h           |  1 +
>>>   2 files changed, 16 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> index 5361197..f611456 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> @@ -753,6 +753,21 @@ void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
>>>   }
>>>   EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
>>>   +int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
>>> +{
>>> +    if (!dev->dma_parms) {
>>> +        dev->dma_parms = devm_kzalloc(dev, sizeof(dev->dma_parms),
>>> +                          GFP_KERNEL);
>> The v3 patch from December uses kzalloc here. Is this perhaps on old version?
> 
> Right, my fault. I will do another resend (and fix the typo in the second patch).
> 
>>> +        if (!dev->dma_parms)
>>> +            return -ENOMEM;
>>> +    }
>>> +    if (dma_get_max_seg_size(dev) < size)
>>> +        return dma_set_max_seg_size(dev, size);
>>> +
>>> +    return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
>> Admittedly I haven't looked closely at this, but is this something that you
>> want for all dma-contig devices? Or to rephrase this question: what type of
>> devices will need this?
> 
> This is needed for all devices using vb2-dc, iommu and user-ptr mode, however
> in the previous discussions (see https://patchwork.linuxtv.org/patch/30870/
> ) it has been suggested to make it via common helper instead of forcing it
> in vb2-dc.

This certainly will need to be carefully documented in videobuf2-dma-contig.h.

What happens if it is called when you don't have an iommu? Does something break?

Regards,

	Hans
