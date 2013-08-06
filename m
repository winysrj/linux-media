Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47664 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3HFKWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:37 -0400
From: Kamil Debski <k.debski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Grant Likely' <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Sachin Kamat' <sachin.kamat@linaro.org>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Rob Herring' <robherring2@gmail.com>,
	'Olof Johansson' <olof@lixom.net>,
	'Pawel Moll' <pawel.moll@arm.com>,
	'Mark Rutland' <mark.rutland@arm.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Ian Campbell' <ian.campbell@citrix.com>
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com>
 <1375705610-12724-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1375705610-12724-3-git-send-email-m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/2] media: s5p-mfc: remove DT hacks and simplify
 initialization code
Date: Tue, 06 Aug 2013 12:22:33 +0200
Message-id: <030d01ce928e$de27e190$9a77a4b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kukjin,

This patch looks good.

Best wishes,
Kamil Debski

> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> Sent: Monday, August 05, 2013 2:27 PM
> 
> This patch removes custom initialization of reserved memory regions
> from s5p-mfc driver. Memory initialization can be now handled by
> generic code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   75 ++++++----------------
> --------
>  1 file changed, 15 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index a130dcd..696e0e0 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1011,51 +1011,11 @@ static int match_child(struct device *dev, void
> *data)  {
>  	if (!dev_name(dev))
>  		return 0;
> -	return !strcmp(dev_name(dev), (char *)data);
> +	return !!strstr(dev_name(dev), (char *)data);
>  }
> 
>  static void *mfc_get_drv_data(struct platform_device *pdev);
> 
> -static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev) -{
> -	unsigned int mem_info[2] = { };
> -
> -	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
> -			sizeof(struct device), GFP_KERNEL);
> -	if (!dev->mem_dev_l) {
> -		mfc_err("Not enough memory\n");
> -		return -ENOMEM;
> -	}
> -	device_initialize(dev->mem_dev_l);
> -	of_property_read_u32_array(dev->plat_dev->dev.of_node,
> -			"samsung,mfc-l", mem_info, 2);
> -	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
> -				mem_info[0], mem_info[1],
> -				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0)
{
> -		mfc_err("Failed to declare coherent memory for\n"
> -		"MFC device\n");
> -		return -ENOMEM;
> -	}
> -
> -	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
> -			sizeof(struct device), GFP_KERNEL);
> -	if (!dev->mem_dev_r) {
> -		mfc_err("Not enough memory\n");
> -		return -ENOMEM;
> -	}
> -	device_initialize(dev->mem_dev_r);
> -	of_property_read_u32_array(dev->plat_dev->dev.of_node,
> -			"samsung,mfc-r", mem_info, 2);
> -	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
> -				mem_info[0], mem_info[1],
> -				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0)
{
> -		pr_err("Failed to declare coherent memory for\n"
> -		"MFC device\n");
> -		return -ENOMEM;
> -	}
> -	return 0;
> -}
> -
>  /* MFC probe function */
>  static int s5p_mfc_probe(struct platform_device *pdev)  { @@ -1107,25
> +1067,20 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  		goto err_res;
>  	}
> 
> -	if (pdev->dev.of_node) {
> -		ret = s5p_mfc_alloc_memdevs(dev);
> -		if (ret < 0)
> -			goto err_res;
> -	} else {
> -		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
> -				"s5p-mfc-l", match_child);
> -		if (!dev->mem_dev_l) {
> -			mfc_err("Mem child (L) device get failed\n");
> -			ret = -ENODEV;
> -			goto err_res;
> -		}
> -		dev->mem_dev_r = device_find_child(&dev->plat_dev->dev,
> -				"s5p-mfc-r", match_child);
> -		if (!dev->mem_dev_r) {
> -			mfc_err("Mem child (R) device get failed\n");
> -			ret = -ENODEV;
> -			goto err_res;
> -		}
> +	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "-l",
> +					   match_child);
> +	if (!dev->mem_dev_l) {
> +		mfc_err("Mem child (L) device get failed\n");
> +		ret = -ENODEV;
> +		goto err_res;
> +	}
> +
> +	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "-r",
> +					   match_child);
> +	if (!dev->mem_dev_r) {
> +		mfc_err("Mem child (R) device get failed\n");
> +		ret = -ENODEV;
> +		goto err_res;
>  	}
> 
>  	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
> --
> 1.7.9.5

