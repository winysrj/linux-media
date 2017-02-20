Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22450 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbdBTNXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:23:37 -0500
Subject: Re: [PATCH 14/15] media: s5p-mfc: Use preallocated block allocator
 always for MFC v6+
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <e0e5f3c2-19a4-e53e-1a4b-54e908b766b5@samsung.com>
Date: Mon, 20 Feb 2017 14:23:31 +0100
MIME-version: 1.0
In-reply-to: <99bd8023-2d89-c1f5-5554-ad3de82f1372@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p1c0acfa79289ebff6306c01e47c3e83a7@eucas1p1.samsung.com>
 <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
 <99bd8023-2d89-c1f5-5554-ad3de82f1372@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 2017-02-17 22:13, Javier Martinez Canillas wrote:
> On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
>> It turned out that all versions of MFC v6+ hardware doesn't have a strict
>> requirement for ALL buffers to be allocated on higher addresses than the
>> firmware base like it was documented for MFC v5. This requirement is true
>> only for the device and per-context buffers. All video data buffers can be
>> allocated anywhere for all MFC v6+ versions. Basing on this fact, the
>> special DMA configuration based on two reserved memory regions is not
>> really needed for MFC v6+ devices, because the memory requirements for the
>> firmware, device and per-context buffers can be fulfilled by the simple
>> probe-time pre-allocated block allocator instroduced in previous patch.
> s/instroduced/introduced
>
>> This patch enables support for such pre-allocated block based allocator
>> always for MFC v6+ devices. Due to the limitations of the memory management
>> subsystem the largest supported size of the pre-allocated buffer when no
>> CMA (Contiguous Memory Allocator) is enabled is 4MiB.
>>
>> This patch also removes the requirement to provide two reserved memory
>> regions for MFC v6+ devices in device tree. Now the driver is fully
>> functional without them.
>>
> Great!
>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
> The patch looks good to me though and it works on my tests,
> I've just one comment below.
>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
>>   Documentation/devicetree/bindings/media/s5p-mfc.txt | 2 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc.c            | 9 ++++++---
>>   2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
>> index 2c901286d818..d3404b5d4d17 100644
>> --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
>> +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
>> @@ -28,7 +28,7 @@ Optional properties:
>>     - memory-region : from reserved memory binding: phandles to two reserved
>>   	memory regions, first is for "left" mfc memory bus interfaces,
>>   	second if for the "right" mfc memory bus, used when no SYSMMU
>> -	support is available
>> +	support is available; used only by MFC v5 present in Exynos4 SoCs
>>   
>>   Obsolete properties:
>>     - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 8fc6fe4ba087..36f0aec2a1b3 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -1178,9 +1178,12 @@ static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
>>   static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
>>   {
>>   	struct device *dev = &mfc_dev->plat_dev->dev;
>> -	unsigned long mem_size = SZ_8M;
>> +	unsigned long mem_size = SZ_4M;
>>   	unsigned int bitmap_size;
>>   
>> +	if (IS_ENABLED(CONFIG_DMA_CMA) || exynos_is_iommu_available(dev))
>> +		mem_size = SZ_8M;
>> +
>>   	if (mfc_mem_size)
>>   		mem_size = memparse(mfc_mem_size, NULL);
>>
> The driver allows the user to set mem_size > SZ_4M using the s5p_mfc.mem
> parameter even when CMA ins't enabled and IOMMU isn't available. Maybe it
> should fail early instead and notify the user what's missing?

It will notify user that driver failed to preallocate memory. 4M is the 
upper
limit for standard kernel configuration, but afair there were some kconfig
knobs to force kernel to use larger buckets for buddy allocator (what 
changes
the limit). Frankly I would leave it as is.

If user wants to specify s5p-mfc.mem, he already has some knowledge how to
configure the kernel. I don't think that driver should check all possible
scenarios of failing and give detailed explanation what was configured
wrong. You can also enable CMA and configure the 8MiB of the default global
area. In such configuration preallocation of mfc firmware buffer will also
fail. Should the driver care about it? IMO it is enough to tell user that
preallocating of given megabytes failed.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
