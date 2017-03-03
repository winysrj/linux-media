Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42030 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdCCPD5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 10:03:57 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OM801AWQRP9RGB0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Mar 2017 22:48:45 +0900 (KST)
Subject: Re: [v2, 02/15] media: s5p-mfc: Use generic of_device_get_match_data
 helper
From: Smitha T Murthy <smitha.t@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
In-reply-to: <1487597944-2000-3-git-send-email-m.szyprowski@samsung.com>
Date: Fri, 03 Mar 2017 19:21:46 +0530
Message-id: <1488549106.3182.17.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1487597944-2000-3-git-send-email-m.szyprowski@samsung.com>
 <CGME20170303134843epcas5p1c1c714d0b1c240ffdc4ec38173296bbf@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-02-20 at 14:38 +0100, Marek Szyprowski wrote: 
> Replace custom code with generic helper to retrieve driver data.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Reviewed-by: Smitha T Murthy <smitha.t@samsung.com>

Regards,
Smitha T Murthy

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        | 17 ++---------------
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  4 ++--
>  2 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 3e1f22eb4339..ad3d7377f40d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -22,6 +22,7 @@
>  #include <media/v4l2-event.h>
>  #include <linux/workqueue.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/of_reserved_mem.h>
>  #include <media/videobuf2-v4l2.h>
>  #include "s5p_mfc_common.h"
> @@ -1157,8 +1158,6 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  	device_unregister(mfc_dev->mem_dev_r);
>  }
>  
> -static void *mfc_get_drv_data(struct platform_device *pdev);
> -
>  /* MFC probe function */
>  static int s5p_mfc_probe(struct platform_device *pdev)
>  {
> @@ -1182,7 +1181,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	dev->variant = mfc_get_drv_data(pdev);
> +	dev->variant = of_device_get_match_data(&pdev->dev);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
> @@ -1541,18 +1540,6 @@ static int s5p_mfc_resume(struct device *dev)
>  };
>  MODULE_DEVICE_TABLE(of, exynos_mfc_match);
>  
> -static void *mfc_get_drv_data(struct platform_device *pdev)
> -{
> -	struct s5p_mfc_variant *driver_data = NULL;
> -	const struct of_device_id *match;
> -
> -	match = of_match_node(exynos_mfc_match, pdev->dev.of_node);
> -	if (match)
> -		driver_data = (struct s5p_mfc_variant *)match->data;
> -
> -	return driver_data;
> -}
> -
>  static struct platform_driver s5p_mfc_driver = {
>  	.probe		= s5p_mfc_probe,
>  	.remove		= s5p_mfc_remove,
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 3e0e8eaf8bfe..2f1387a4c386 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -192,7 +192,7 @@ struct s5p_mfc_buf {
>   */
>  struct s5p_mfc_pm {
>  	struct clk	*clock_gate;
> -	const char	**clk_names;
> +	const char * const *clk_names;
>  	struct clk	*clocks[MFC_MAX_CLOCKS];
>  	int		num_clocks;
>  	bool		use_clock_gating;
> @@ -304,7 +304,7 @@ struct s5p_mfc_dev {
>  	struct v4l2_ctrl_handler dec_ctrl_handler;
>  	struct v4l2_ctrl_handler enc_ctrl_handler;
>  	struct s5p_mfc_pm	pm;
> -	struct s5p_mfc_variant	*variant;
> +	const struct s5p_mfc_variant	*variant;
>  	int num_inst;
>  	spinlock_t irqlock;	/* lock when operating on context */
>  	spinlock_t condlock;	/* lock when changing/checking if a context is
