Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21366 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbcEDI2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 04:28:05 -0400
Subject: Re: [PATCH v3] media: vb2-dma-contig: configure DMA max segment size
 properly
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
References: <57271235.9030004@xs4all.nl>
 <1462186753-4177-1-git-send-email-m.szyprowski@samsung.com>
 <5729B145.8030208@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <b2c9a419-8011-8631-51cd-ed1f7473ce08@samsung.com>
Date: Wed, 04 May 2016 10:28:01 +0200
MIME-version: 1.0
In-reply-to: <5729B145.8030208@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 2016-05-04 10:22, Hans Verkuil wrote:
> Hi Marek,
>
> On 05/02/2016 12:59 PM, Marek Szyprowski wrote:
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
>> v3:
>> - added FIXME note about possible memory leak
>>
>> v2:
>> - fixes typos and other language issues in the comments
>>
>> v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690
>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 45 ++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 461ae55eaa98..2ca7e798f394 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -443,6 +443,42 @@ static void vb2_dc_put_userptr(void *buf_priv)
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
>> + * scatterlist segments if this is really possible (for example when
>> + * an IOMMU is available and enabled).
>> + * Ideally, this parameter should be set by the generic bus code, but it
>> + * is left with the default 64KiB value due to historical litmiations in
>> + * other subsystems (like limited USB host drivers) and there no good
>> + * place to set it to the proper value. It is done here to avoid fixing
>> + * all the vb2-dc client drivers.
>> + *
>> + * FIXME: the allocated dma_params structure is leaked because there
>> + * is completely no way to determine when to free it (dma_params might have
>> + * been also already allocated by the bus code). However in typical
>> + * use cases this function will be called for platform devices, which are
>> + * not how-plugged and exist all the time in the target system.
>> + */
>> +static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
>> +{
>> +	if (!dev->dma_parms) {
>> +		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
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
>> @@ -499,6 +535,10 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>>   		return ERR_PTR(-EINVAL);
>>   	}
>>   
>> +	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size + PAGE_SIZE));
> Huh? Against which kernel do you compile? The get_userptr prototype is different
> from the latest mainline kernel. Specifically, dev is now conf->dev.

I prepared it on top of your 'context3' branch, as you requested not to 
use the
allocator context related functions, which best suit for this purpose.

>> +	if (!ret)
>> +		return ERR_PTR(ret);
>> +
>>   	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>   	if (!buf)
>>   		return ERR_PTR(-ENOMEM);
> I'd move the vb2_dc_set_max_seg_size call to after the buf is allocated. Since this call
> has side-effects I would only call it when it is really needed.

OKay.

>
>> @@ -675,10 +715,15 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
>>   {
>>   	struct vb2_dc_buf *buf;
>>   	struct dma_buf_attachment *dba;
>> +	int ret;
>>   
>>   	if (dbuf->size < size)
>>   		return ERR_PTR(-EFAULT);
>>   
>> +	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size));
> Ditto for argument and moving to after the buf is allocated.
>
>> +	if (!ret)
>> +		return ERR_PTR(ret);
>> +
>>   	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>>   	if (!buf)
>>   		return ERR_PTR(-ENOMEM);
>>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

