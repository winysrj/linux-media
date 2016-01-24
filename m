Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61104 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcAXSJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 13:09:46 -0500
Date: Sun, 24 Jan 2016 19:09:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Subject: Re: [PATCH 07/13] atmel-isi: move hw code into isi_hw_initialize()
In-Reply-To: <1453121545-27528-2-git-send-email-rainyfeeling@gmail.com>
Message-ID: <Pine.LNX.4.64.1601241906070.16570@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-2-git-send-email-rainyfeeling@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2016, Josh Wu wrote:

> That make hw operation code separate with general code.
> 
> Also since reset action can be failed, so add a return value for
> isi_hw_initialze().
> 
> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 34 +++++++++++++++++----------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 4ddc309..ed4d04b 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -203,10 +203,27 @@ static int isi_hw_wait_status(struct atmel_isi *isi, int status_flag,
>  	return 0;
>  }
>  
> -static void isi_hw_initialize(struct atmel_isi *isi)
> +static int isi_hw_initialize(struct atmel_isi *isi)
>  {
>  	u32 common_flags = isi->bus_param;
>  	u32 cfg1 = 0;
> +	int ret;
> +
> +	/* Reset ISI */
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> +
> +	/* Check Reset status */
> +	ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);

You could also remove the superfluous space while at it.

Thanks
Guennadi

> +	if (ret) {
> +		dev_err(isi->soc_host.icd->parent, "Reset ISI timed out\n");
> +		return ret;
> +	}
> +
> +	/* Disable all interrupts */
> +	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
> +
> +	/* Clear any pending interrupt */
> +	isi_readl(isi, ISI_STATUS);
>  
>  	/* set bus param for ISI */
>  	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> @@ -229,6 +246,8 @@ static void isi_hw_initialize(struct atmel_isi *isi)
>  
>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>  	isi_writel(isi, ISI_CFG1, cfg1);
> +
> +	return 0;
>  }
>  
>  static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
> @@ -453,27 +472,16 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  
>  	pm_runtime_get_sync(ici->v4l2_dev.dev);
>  
> -	/* Reset ISI */
> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> -
> -	/* Check Reset status */
> -	ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);
> +	ret = isi_hw_initialize(isi);
>  	if (ret) {
> -		dev_err(icd->parent, "Reset ISI timed out\n");
>  		pm_runtime_put(ici->v4l2_dev.dev);
>  		return ret;
>  	}
> -	/* Disable all interrupts */
> -	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
> -
> -	isi_hw_initialize(isi);
>  
>  	configure_geometry(isi, icd->user_width, icd->user_height,
>  				icd->current_fmt);
>  
>  	spin_lock_irq(&isi->lock);
> -	/* Clear any pending interrupt */
> -	isi_readl(isi, ISI_STATUS);
>  
>  	if (count)
>  		start_dma(isi, isi->active);
> -- 
> 1.9.1
> 
