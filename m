Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0G1Gxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 02:53:46 -0400
Date: Wed, 28 Jul 2010 08:53:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/4] mx2_camera: return IRQ_NONE when doing nothing
Message-ID: <20100728065337.GC14113@pengutronix.de>
References: <cover.1280229966.git.baruch@tkos.co.il> <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 03:06:08PM +0300, Baruch Siach wrote:
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/media/video/mx2_camera.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 1536bd4..b42ad8d 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -420,15 +420,17 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
>  	struct mx2_camera_dev *pcdev = data;
>  	u32 status = readl(pcdev->base_csi + CSISR);
>  
> -	if (status & CSISR_DMA_TSF_FB1_INT)
> +	writel(status, pcdev->base_csi + CSISR);
> +
> +	if (!(status & (CSISR_DMA_TSF_FB1_INT | CSISR_DMA_TSF_FB2_INT)))
> +		return IRQ_NONE;

I'm not sure this is correct. When we get here, the interrupt definitely
is from the camera, it's not a shared interrupt. So this only provokes a
'nobody cared' message from the kernel (if it's still present, I don't
know).

Sascha


> +	else if (status & CSISR_DMA_TSF_FB1_INT)
>  		mx25_camera_frame_done(pcdev, 1, VIDEOBUF_DONE);
>  	else if (status & CSISR_DMA_TSF_FB2_INT)
>  		mx25_camera_frame_done(pcdev, 2, VIDEOBUF_DONE);
>  
>  	/* FIXME: handle CSISR_RFF_OR_INT */
>  
> -	writel(status, pcdev->base_csi + CSISR);
> -
>  	return IRQ_HANDLED;
>  }
>  
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
