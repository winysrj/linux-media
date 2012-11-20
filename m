Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46496 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2KTSAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 13:00:49 -0500
Received: from eusync3.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDS001O7SQ5UT30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 18:01:17 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MDS00AVPSP73030@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 18:00:47 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, jtp.park@samsung.com,
	sw0312.kim@samsung.com, joshi@samsung.com
References: <1351944121-4756-1-git-send-email-arun.kk@samsung.com>
 <1351944121-4756-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1351944121-4756-2-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v1] s5p-mfc: Add device tree support
Date: Tue, 20 Nov 2012 19:00:42 +0100
Message-id: <006801cdc748$f59444c0$e0bcce40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Thank you for your patch.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Saturday, November 03, 2012 1:02 PM
> Subject: [PATCH v1] s5p-mfc: Add device tree support
> 
> This patch will add the device tree support for MFC driver.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |  114
> +++++++++++++++++++++++++-----
>  1 files changed, 97 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 130f4ac..0ca8dbb 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -21,6 +21,7 @@
>  #include <linux/videodev2.h>
>  #include <media/v4l2-event.h>
>  #include <linux/workqueue.h>
> +#include <linux/of.h>
>  #include <media/videobuf2-core.h>
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_ctrl.h"
> @@ -1030,6 +1031,48 @@ static int match_child(struct device *dev, void
> *data)
>  	return !strcmp(dev_name(dev), (char *)data);  }
> 
> +static void *mfc_get_drv_data(struct platform_device *pdev);
> +
> +static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev) {
> +	unsigned int mem_info[2];
> +
> +	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
> +			sizeof(struct device), GFP_KERNEL);
> +	if (!dev->mem_dev_l) {
> +		mfc_err("Not enough memory\n");
> +		return -ENOMEM;
> +	}
> +	device_initialize(dev->mem_dev_l);
> +	of_property_read_u32_array(dev->plat_dev->dev.of_node,
> "samsung,mfc-l",
> +			mem_info, 2);
> +	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
> +			mem_info[0], mem_info[1],
> +			DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
> +		mfc_err("Failed to declare coherent memory for\n"
> +				"MFC device\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
> +			sizeof(struct device), GFP_KERNEL);
> +	if (!dev->mem_dev_r) {
> +		mfc_err("Not enough memory\n");
> +		return -ENOMEM;
> +	}
> +	device_initialize(dev->mem_dev_r);
> +	of_property_read_u32_array(dev->plat_dev->dev.of_node,
> "samsung,mfc-r",
> +			mem_info, 2);
> +	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
> +			mem_info[0], mem_info[1],
> +			DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
> +		pr_err("Failed to declare coherent memory for\n"
> +				"MFC device\n");
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  /* MFC probe function */
>  static int s5p_mfc_probe(struct platform_device *pdev)  { @@ -1053,8
> +1096,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
> 
> -	dev->variant = (struct s5p_mfc_variant *)
> -		platform_get_device_id(pdev)->driver_data;
> +	dev->variant = mfc_get_drv_data(pdev);
> 
>  	ret = s5p_mfc_init_pm(dev);
>  	if (ret < 0) {
> @@ -1084,20 +1126,24 @@ static int s5p_mfc_probe(struct platform_device
> *pdev)
>  		goto err_res;
>  	}
> 
> -	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-
> l",
> -					   match_child);
> -	if (!dev->mem_dev_l) {
> -		mfc_err("Mem child (L) device get failed\n");
> -		ret = -ENODEV;
> -		goto err_res;
> -	}
> -
> -	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-
> r",
> -					   match_child);
> -	if (!dev->mem_dev_r) {
> -		mfc_err("Mem child (R) device get failed\n");
> -		ret = -ENODEV;
> -		goto err_res;
> +	if (pdev->dev.of_node) {
> +		if (s5p_mfc_alloc_memdevs(dev) < 0)
> +			goto err_res;
> +	} else {
> +		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
> +				"s5p-mfc-l", match_child);
> +		if (!dev->mem_dev_l) {
> +			mfc_err("Mem child (L) device get failed\n");
> +			ret = -ENODEV;
> +			goto err_res;
> +		}
> +		dev->mem_dev_r = device_find_child(&dev->plat_dev->dev,
> +				"s5p-mfc-r", match_child);
> +		if (!dev->mem_dev_r) {
> +			mfc_err("Mem child (R) device get failed\n");
> +			ret = -ENODEV;
> +			goto err_res;
> +		}
>  	}
> 
>  	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
> @@ -1221,6 +1267,10 @@ static int __devexit s5p_mfc_remove(struct
> platform_device *pdev)
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
> +	if (pdev->dev.of_node) {
> +		put_device(dev->mem_dev_l);
> +		put_device(dev->mem_dev_r);
> +	}
> 
>  	s5p_mfc_final_pm(dev);
>  	return 0;
> @@ -1369,6 +1419,35 @@ static struct platform_device_id
> mfc_driver_ids[] = {  };  MODULE_DEVICE_TABLE(platform,
> mfc_driver_ids);
> 
> +static const struct of_device_id exynos_mfc_match[] = {
> +	{
> +		.compatible = "samsung,mfc-v5",
> +		.data = &mfc_drvdata_v5,
> +	}, {
> +		.compatible = "samsung,mfc-v6",
> +		.data = &mfc_drvdata_v6,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_mfc_match);
> +
> +static void *mfc_get_drv_data(struct platform_device *pdev) {
> +	struct s5p_mfc_variant *driver_data = NULL;
> +
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(of_match_ptr(exynos_mfc_match),
> +				pdev->dev.of_node);
> +		if (match)
> +			driver_data = (struct s5p_mfc_variant *)match->data;
> +	} else {
> +		driver_data = (struct s5p_mfc_variant *)
> +			platform_get_device_id(pdev)->driver_data;
> +	}
> +	return driver_data;
> +}
> +
>  static struct platform_driver s5p_mfc_driver = {
>  	.probe		= s5p_mfc_probe,
>  	.remove		= __devexit_p(s5p_mfc_remove),
> @@ -1376,7 +1455,8 @@ static struct platform_driver s5p_mfc_driver = {
>  	.driver	= {
>  		.name	= S5P_MFC_NAME,
>  		.owner	= THIS_MODULE,
> -		.pm	= &s5p_mfc_pm_ops
> +		.pm	= &s5p_mfc_pm_ops,
> +		.of_match_table = exynos_mfc_match,
>  	},
>  };
> 
> --
> 1.7.0.4


