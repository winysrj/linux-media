Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36468 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbeINRdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 13:33:49 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20180914121933euoutp01d0bde9ff77ab3ce7fe37846743975e40~UQ3wcYbjn1169811698euoutp012
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 12:19:33 +0000 (GMT)
Subject: Re: [PATCH] media: s5p-mfc: Fix memdev DMA configuration
To: Robin Murphy <robin.murphy@arm.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com
Cc: linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        Smitha T Murthy <smitha.t@samsung.com>,
        Rob Herring <robh@kernel.org>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Date: Fri, 14 Sep 2018 14:19:29 +0200
MIME-Version: 1.0
In-Reply-To: <d485dc3698304403620d5ed92d066942a6b68cfd.1536770587.git.robin.murphy@arm.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <20180914121931eucas1p14292ee983fd9b4bb21968dffa303dde8~UQ3utL6mj2689726897eucas1p15@eucas1p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20180912164604epcas3p1ac72c0861ec182f50485959ac998ed52@epcas3p1.samsung.com>
        <d485dc3698304403620d5ed92d066942a6b68cfd.1536770587.git.robin.murphy@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robin,

On 2018-09-12 18:45, Robin Murphy wrote:
> Having of_reserved_mem_device_init() forcibly reconfigure DMA for all
> callers, potentially overriding the work done by a bus-specific
> .dma_configure method earlier, is at best a bad idea and at worst
> actively harmful. If drivers really need virtual devices to own
> dma-coherent memory, they should explicitly configure those devices
> based on the appropriate firmware node as they create them.
>
> It looks like the only driver not passing in a proper OF platform device
> is s5p-mfc, so move the rogue of_dma_configure() call into that driver
> where it logically belongs.
>
> CC: Smitha T Murthy <smitha.t@samsung.com>
> CC: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Rob Herring <robh@kernel.org>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Right, after recent cleanup dma ops initialization, MFC driver is
a better place for calling of_dma_configure() on virtual devices.

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 +++++++
>   drivers/of/of_reserved_mem.c             | 4 ----
>   2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 927a1235408d..77eb4a4511c1 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1094,6 +1094,13 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
>   	child->dma_mask = dev->dma_mask;
>   	child->release = s5p_mfc_memdev_release;
>   
> +	/*
> +	 * The memdevs are not proper OF platform devices, so in order for them
> +	 * to be treated as valid DMA masters we need a bit of a hack to force
> +	 * them to inherit the MFC node's DMA configuration.
> +	 */
> +	of_dma_configure(child, dev->of_node, true);
> +
>   	if (device_add(child) == 0) {
>   		ret = of_reserved_mem_device_init_by_idx(child, dev->of_node,
>   							 idx);
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 895c83e0c7b6..4ef6f4485335 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -350,10 +350,6 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
>   		mutex_lock(&of_rmem_assigned_device_mutex);
>   		list_add(&rd->list, &of_rmem_assigned_device_list);
>   		mutex_unlock(&of_rmem_assigned_device_mutex);
> -		/* ensure that dma_ops is set for virtual devices
> -		 * using reserved memory
> -		 */
> -		of_dma_configure(dev, np, true);
>   
>   		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
>   	} else {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
