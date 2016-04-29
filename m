Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59198 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcD2Ljr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 07:39:47 -0400
Subject: Re: [PATCH v2] media: vb2-dma-contig: configure DMA max segment size
 properly
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <57220299.3000807@xs4all.nl>
 <1461849603-6313-1-git-send-email-m.szyprowski@samsung.com>
 <20160429112110.GI32125@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <2318434a-176b-82c6-c55a-115778354201@samsung.com>
Date: Fri, 29 Apr 2016 13:39:43 +0200
MIME-version: 1.0
In-reply-to: <20160429112110.GI32125@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2016-04-29 13:21, Sakari Ailus wrote:
> Hi Marek,
>
> Thanks for the patch!
>
> On Thu, Apr 28, 2016 at 03:20:03PM +0200, Marek Szyprowski wrote:
>> This patch lets vb2-dma-contig memory allocator to configure DMA max
>> segment size properly for the client device. Setting it is needed to let
>> DMA-mapping subsystem to create a single, contiguous mapping in DMA
>> address space. This is essential for all devices, which use dma-contig
>> videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
>> of operations).
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> Hello,
>>
>> This patch is a follow-up of my previous attempts to let Exynos
>> multimedia devices to work properly with shared buffers when IOMMU is
>> enabled:
>> 1. https://www.mail-archive.com/linux-media@vger.kernel.org/msg96946.html
>> 2. http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
>> 3. https://patchwork.linuxtv.org/patch/30870/
>>
>> As sugested by Hans, configuring DMA max segment size should be done by
>> videobuf2-dma-contig module instead of requiring all device drivers to
>> do it on their own.
>>
>> Here is some backgroud why this is done in videobuf2-dc not in the
>> respective generic bus code:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html
>>
>> Best regards,
>> Marek Szyprowski
>>
>> changelog:
>> v2:
>> - fixes typos and other language issues in the comments
>>
>> v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690
>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 39 ++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 461ae55eaa98..d0382d62954d 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -443,6 +443,36 @@ static void vb2_dc_put_userptr(void *buf_priv)
>>   }
>>   
>>   /*
>> + * To allow mapping the scatter-list into a single chunk in the DMA
>> + * address space, the device is required to have the DMA max segment
>> + * size parameter set to a value larger than the buffer size. Otherwise,
>> + * the DMA-mapping subsystem will split the mapping into max segment
>> + * size chunks. This function increases the DMA max segment size
>> + * parameter to let DMA-mapping map a buffer as a single chunk in DMA
>> + * address space.
>> + * This code assumes that the DMA-mapping subsystem will merge all
>> + * scatter-list segments if this is really possible (for example when
>> + * an IOMMU is available and enabled).
>> + * Ideally, this parameter should be set by the generic bus code, but it
>> + * is left with the default 64KiB value due to historical litmiations in
>> + * other subsystems (like limited USB host drivers) and there no good
>> + * place to set it to the proper value. It is done here to avoid fixing
>> + * all the vb2-dc client drivers.
>> + */
>> +static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
>> +{
>> +	if (!dev->dma_parms) {
>> +		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
> Doesn't this create a memory leak? Do consider that devices may be also
> removed from the system at runtime.
>
> Looks very nice otherwise.

Yes it does, but there is completely no way to determine when to do that
(dma_params might have been already allocated by the bus code). The whole
dma_params idea and its handling is a bit messy. IMHO we can leave this
for now until dma_params gets cleaned up (I remember someone said that he
has this on his todo list, but I don't remember now who it was...).

>
>> +		if (!dev->dma_parms)
>> +			return -ENOMEM;
>> +	}
>> +	if (dma_get_max_seg_size(dev) < size)
>> +		return dma_set_max_seg_size(dev, size);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * For some kind of reserved memory there might be no struct page available,
>>    * so all that can be done to support such 'pages' is to try to convert
>>    * pfn to dma address or at the last resort just assume that
>> @@ -499,6 +529,10 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>>   		return ERR_PTR(-EINVAL);
>>   	}
>>   
>> +	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size + PAGE_SIZE));
>> +	if (!ret)
>> +		return ERR_PTR(ret);
>> +
>>   	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>   	if (!buf)
>>   		return ERR_PTR(-ENOMEM);
>> @@ -675,10 +709,15 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
>>   {
>>   	struct vb2_dc_buf *buf;
>>   	struct dma_buf_attachment *dba;
>> +	int ret;
>>   
>>   	if (dbuf->size < size)
>>   		return ERR_PTR(-EFAULT);
>>   
>> +	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size));
>> +	if (!ret)
>> +		return ERR_PTR(ret);
>> +
>>   	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>>   	if (!buf)
>>   		return ERR_PTR(-ENOMEM);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

