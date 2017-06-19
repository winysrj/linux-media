Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39861 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdFSGQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 02:16:50 -0400
Subject: Re: [PATCH 5/9] [media] s5p-jpeg: Add IOMMU support
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <a18e66c0-e0cb-157e-aa38-0433b18ca125@samsung.com>
Date: Mon, 19 Jun 2017 08:16:44 +0200
MIME-version: 1.0
In-reply-to: <22caa512-6feb-449c-e6c4-8d647b2d2e8d@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-6-git-send-email-thierry.escande@collabora.com>
 <CGME20170602214418epcas5p3687b21e80e33083e3e1bdbc9716fe868@epcas5p3.samsung.com>
 <22caa512-6feb-449c-e6c4-8d647b2d2e8d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm sorry for the late reply, I just got back from holidays.

On 2017-06-02 23:43, Jacek Anaszewski wrote:
> Cc Marek Szyprowski.
>
> Marek, could you share your opinion about this patch?
>
> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>> From: Tony K Nadackal <tony.kn@samsung.com>
>>
>> This patch adds support for IOMMU s5p-jpeg driver if the Exynos IOMMU
>> and ARM DMA IOMMU configurations are supported. The address space is
>> created with size limited to 256M and base address set to 0x20000000.

Could you clarify WHY this patch is needed? IOMMU core configures per-device
IO address space by default and AFAIR JPEG module doesn't have any specific
requirements for the IO address space layout (base or size), so it should
work fine (and works in my tests!) without this patch.

Please drop this patch for now.

>> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>> ---
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 77 +++++++++++++++++++++++++++++
>>   1 file changed, 77 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> index 770a709..5569b99 100644
>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> @@ -28,6 +28,14 @@
>>   #include <media/v4l2-ioctl.h>
>>   #include <media/videobuf2-v4l2.h>
>>   #include <media/videobuf2-dma-contig.h>
>> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
>> +#include <asm/dma-iommu.h>
>> +#include <linux/dma-iommu.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/iommu.h>
>> +#include <linux/kref.h>
>> +#include <linux/of_platform.h>
>> +#endif
>>   
>>   #include "jpeg-core.h"
>>   #include "jpeg-hw-s5p.h"
>> @@ -35,6 +43,10 @@
>>   #include "jpeg-hw-exynos3250.h"
>>   #include "jpeg-regs.h"
>>   
>> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
>> +static struct dma_iommu_mapping *mapping;
>> +#endif
>> +
>>   static struct s5p_jpeg_fmt sjpeg_formats[] = {
>>   	{
>>   		.name		= "JPEG JFIF",
>> @@ -956,6 +968,60 @@ static void exynos4_jpeg_parse_q_tbl(struct s5p_jpeg_ctx *ctx)
>>   	}
>>   }
>>   
>> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
>> +static int jpeg_iommu_init(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	int err;
>> +
>> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
>> +					   SZ_512M);
>> +	if (IS_ERR(mapping)) {
>> +		dev_err(dev, "IOMMU mapping failed\n");
>> +		return PTR_ERR(mapping);
>> +	}
>> +
>> +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms), GFP_KERNEL);
>> +	if (!dev->dma_parms) {
>> +		err = -ENOMEM;
>> +		goto error_alloc;
>> +	}
>> +
>> +	err = dma_set_max_seg_size(dev, 0xffffffffu);
>> +	if (err)
>> +		goto error;
>> +
>> +	err = arm_iommu_attach_device(dev, mapping);
>> +	if (err)
>> +		goto error;
>> +
>> +	return 0;
>> +
>> +error:
>> +	devm_kfree(dev, dev->dma_parms);
>> +	dev->dma_parms = NULL;
>> +
>> +error_alloc:
>> +	arm_iommu_release_mapping(mapping);
>> +	mapping = NULL;
>> +
>> +	return err;
>> +}
>> +
>> +static void jpeg_iommu_deinit(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +
>> +	if (mapping) {
>> +		arm_iommu_detach_device(dev);
>> +		devm_kfree(dev, dev->dma_parms);
>> +		dev->dma_parms = NULL;
>> +		arm_iommu_release_mapping(mapping);
>> +		mapping = NULL;
>> +	}
>> +}
>> +#endif
>> +
>>   /*
>>    * ============================================================================
>>    * Device file operations
>> @@ -2816,6 +2882,13 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
>>   	spin_lock_init(&jpeg->slock);
>>   	jpeg->dev = &pdev->dev;
>>   
>> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
>> +	ret = jpeg_iommu_init(pdev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "IOMMU Initialization failed\n");
>> +		return ret;
>> +	}
>> +#endif
>>   	/* memory-mapped registers */
>>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>   
>> @@ -2962,6 +3035,10 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
>>   			clk_disable_unprepare(jpeg->clocks[i]);
>>   	}
>>   
>> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
>> +	jpeg_iommu_deinit(pdev);
>> +#endif
>> +
>>   	return 0;
>>   }
>>   
>>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
