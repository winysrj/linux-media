Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:39250 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbcEXN6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:58:53 -0400
Subject: Re: [PATCH 1/2] drm/exynos: g2d: Add support for old S5Pv210 type
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
References: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Message-ID: <57445BE5.7060702@math.uni-bielefeld.de>
Date: Tue, 24 May 2016 15:49:25 +0200
MIME-Version: 1.0
In-Reply-To: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Krzysztof,

are you sure that these are the only differences. Because AFAIK there
are quite a few more:
- DMA submission of commands
- blend mode / rounding
- solid fill
- YCrCb support
- and probably more

One would need to add least split the command list parser into a v3 and
v41 version to accomodate for the differences. In fact userspace/libdrm
would need to know which hw type it currently uses, but you currently
always return 4.1 in the corresponding ioctl.


Krzysztof Kozlowski wrote:
> The non-DRM s5p-g2d driver supports two versions of G2D: v3.0 on
> S5Pv210 and v4.x on Exynos 4x12 (or newer). The driver for 3.0 device
> version is doing two things differently:
> 1. Before starting the render process, it invalidates caches (pattern,
>    source buffer and mask buffer). Cache control is not present on v4.x
>    device.
> 2. Scalling is done through StretchEn command (in BITBLT_COMMAND_REG
>    register) instead of SRC_SCALE_CTRL_REG as in v4.x. However the
>    exynos_drm_g2d driver does not implement the scalling so this
>    difference can be eliminated.
Huh? Where did you get this from? Scaling works with the DRM driver.


With best wishes,
Tobias


> After adding support for v3.0 to exynos_drm_g2d driver, the old driver
> can be removed.
> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c | 37 +++++++++++++++++++++++++++++++--
>  drivers/gpu/drm/exynos/exynos_drm_g2d.h |  7 +++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> index 493552368295..44d8b28e9d98 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -19,6 +19,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/dma-attrs.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #include <drm/drmP.h>
>  #include <drm/exynos_drm.h>
> @@ -38,6 +39,7 @@
>  #define G2D_SOFT_RESET			0x0000
>  #define G2D_INTEN			0x0004
>  #define G2D_INTC_PEND			0x000C
> +#define G2D_CACHECTL			0x0018 /* S5PV210 specific */
>  #define G2D_DMA_SFR_BASE_ADDR		0x0080
>  #define G2D_DMA_COMMAND			0x0084
>  #define G2D_DMA_STATUS			0x008C
> @@ -78,6 +80,11 @@
>  #define G2D_INTP_GCMD_FIN		(1 << 1)
>  #define G2D_INTP_SCMD_FIN		(1 << 0)
>  
> +/* G2D_CACHECTL, S5PV210 specific */
> +#define G2D_CACHECTL_PATCACHE		(BIT(2))
> +#define G2D_CACHECTL_SRCBUFFER		(BIT(1))
> +#define G2D_CACHECTL_MASKBUFFER		(BIT(0))
> +
>  /* G2D_DMA_COMMAND */
>  #define G2D_DMA_HALT			(1 << 2)
>  #define G2D_DMA_CONTINUE		(1 << 1)
> @@ -245,6 +252,7 @@ struct g2d_data {
>  
>  	unsigned long			current_pool;
>  	unsigned long			max_pool;
> +	enum exynos_drm_g2d_type	type;
>  };
>  
>  static int g2d_init_cmdlist(struct g2d_data *g2d)
> @@ -1125,6 +1133,13 @@ int exynos_g2d_set_cmdlist_ioctl(struct drm_device *drm_dev, void *data,
>  	cmdlist->data[cmdlist->last++] = G2D_SRC_BASE_ADDR;
>  	cmdlist->data[cmdlist->last++] = 0;
>  
> +	if (g2d->type == EXYNOS_DRM_G2D_TYPE_3X) {
> +		cmdlist->data[cmdlist->last++] = G2D_CACHECTL;
> +		cmdlist->data[cmdlist->last++] = G2D_CACHECTL_PATCACHE |
> +						 G2D_CACHECTL_SRCBUFFER |
> +						 G2D_CACHECTL_MASKBUFFER;
> +	}
> +
>  	/*
>  	 * 'LIST_HOLD' command should be set to the DMA_HOLD_CMD_REG
>  	 * and GCF bit should be set to INTEN register if user wants
> @@ -1369,10 +1384,20 @@ static int g2d_probe(struct platform_device *pdev)
>  	struct exynos_drm_subdrv *subdrv;
>  	int ret;
>  
> +	/* Sanity check, we can be instatiated only from DT */
> +	if (!dev->of_node)
> +		return -EINVAL;
> +
>  	g2d = devm_kzalloc(dev, sizeof(*g2d), GFP_KERNEL);
>  	if (!g2d)
>  		return -ENOMEM;
>  
> +	g2d->type = (enum exynos_drm_g2d_type)of_device_get_match_data(dev);
> +	if (g2d->type == EXYNOS_DRM_G2D_TYPE_UNKNOWN) {
> +		dev_err(dev, "failed to get type of device\n");
> +		return -EINVAL;
> +	}
> +
>  	g2d->runqueue_slab = kmem_cache_create("g2d_runqueue_slab",
>  			sizeof(struct g2d_runqueue_node), 0, 0, NULL);
>  	if (!g2d->runqueue_slab)
> @@ -1535,8 +1560,16 @@ static const struct dev_pm_ops g2d_pm_ops = {
>  };
>  
>  static const struct of_device_id exynos_g2d_match[] = {
> -	{ .compatible = "samsung,exynos5250-g2d" },
> -	{ .compatible = "samsung,exynos4212-g2d" },
> +	{
> +		.compatible = "samsung,exynos5250-g2d",
> +		.data = (void *)EXYNOS_DRM_G2D_TYPE_4X,
> +	}, {
> +		.compatible = "samsung,exynos4212-g2d",
> +		.data = (void *)EXYNOS_DRM_G2D_TYPE_4X,
> +	}, {
> +		.compatible = "samsung,s5pv210-g2d",
> +		.data = (void *)EXYNOS_DRM_G2D_TYPE_3X,
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_g2d_match);
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.h b/drivers/gpu/drm/exynos/exynos_drm_g2d.h
> index 1a9c7ca8c15b..84ec8aff6f0a 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.h
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.h
> @@ -7,6 +7,13 @@
>   * published by the Free Software Foundationr
>   */
>  
> +enum exynos_drm_g2d_type {
> +	EXYNOS_DRM_G2D_TYPE_UNKNOWN,
> +
> +	EXYNOS_DRM_G2D_TYPE_3X,
> +	EXYNOS_DRM_G2D_TYPE_4X,
> +};
> +
>  #ifdef CONFIG_DRM_EXYNOS_G2D
>  extern int exynos_g2d_get_ver_ioctl(struct drm_device *dev, void *data,
>  				    struct drm_file *file_priv);
> 

