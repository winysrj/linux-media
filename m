Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57781 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbcBUTVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 14:21:32 -0500
Date: Sun, 21 Feb 2016 13:58:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] media: pxa_camera: trivial move of dma irq
 functions
In-Reply-To: <1441539733-19201-3-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1602211356070.5959@axis700.grange>
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
 <1441539733-19201-3-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 6 Sep 2015, Robert Jarzmik wrote:

> This moves the dma irq handling functions up in the source file, so that
> they are available before DMA preparation functions. It prepares the
> conversion to DMA engine, where the descriptors are populated with these
> functions as callbacks.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> Since v1: fixed prototypes change
> Since v4: refixed prototypes change
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 42 +++++++++++++++-----------
>  1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index db041a5ed444..bb7054221a86 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -311,6 +311,30 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>  	return i + 1;
>  }
>  
> +static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
> +			       enum pxa_camera_active_dma act_dma);

This is v5. You fixed prototypes in v1 and v4. Let's see:

> +
> +static void pxa_camera_dma_irq_y(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(channel, pcdev, DMA_Y);

This doesn't seem fixed to me.

Thanks
Guennadi

> +}
> +
> +static void pxa_camera_dma_irq_u(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(channel, pcdev, DMA_U);
> +}
> +
> +static void pxa_camera_dma_irq_v(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(channel, pcdev, DMA_V);
> +}
> +
>  /**
>   * pxa_init_dma_channel - init dma descriptors
>   * @pcdev: pxa camera device
> @@ -802,24 +826,6 @@ out:
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  }
>  
> -static void pxa_camera_dma_irq_y(int channel, void *data)
> -{
> -	struct pxa_camera_dev *pcdev = data;
> -	pxa_camera_dma_irq(channel, pcdev, DMA_Y);
> -}
> -
> -static void pxa_camera_dma_irq_u(int channel, void *data)
> -{
> -	struct pxa_camera_dev *pcdev = data;
> -	pxa_camera_dma_irq(channel, pcdev, DMA_U);
> -}
> -
> -static void pxa_camera_dma_irq_v(int channel, void *data)
> -{
> -	struct pxa_camera_dev *pcdev = data;
> -	pxa_camera_dma_irq(channel, pcdev, DMA_V);
> -}
> -
>  static struct videobuf_queue_ops pxa_videobuf_ops = {
>  	.buf_setup      = pxa_videobuf_setup,
>  	.buf_prepare    = pxa_videobuf_prepare,
> -- 
> 2.1.4
> 
