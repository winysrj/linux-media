Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55366 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751665Ab0G1LZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 07:25:17 -0400
Date: Wed, 28 Jul 2010 13:25:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/4] mx2_camera: return IRQ_NONE when doing nothing
In-Reply-To: <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
Message-ID: <Pine.LNX.4.64.1007281317400.23907@axis700.grange>
References: <cover.1280229966.git.baruch@tkos.co.il>
 <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A general comment to your patches: the actual driver is going to be merged 
via the ARM tree, all other your incremental patches should rather go via 
the v4l tree. So, we'll have to synchronise with ARM, let's hope ARM 
patches go in early enough.

On Tue, 27 Jul 2010, Baruch Siach wrote:

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

I don't think this is correct. You should return IRQ_NONE if this is not 
an interrupt from your device at all. In this case you don't have to ack 
your interrupts, which, I presume, is what the write to CSISR is doing. 
OTOH, if this is an interrupt from your device, but you're just not 
interested in it, you should ack it and return IRQ_HANDLED. So, the 
original behaviour was more correct, than what this your patch is doing. 
The only improvement I can think of is, that you can return IRQ_NONE if 
status is 0, but then you don't have to ack it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
