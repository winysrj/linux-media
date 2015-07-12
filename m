Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57554 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbbGLOGn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 10:06:43 -0400
Date: Sun, 12 Jul 2015 16:06:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v2 3/4] media: pxa_camera: trivial move of dma irq
 functions
In-Reply-To: <1436120872-24484-4-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1507121605040.32193@axis700.grange>
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
 <1436120872-24484-4-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Jul 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>
> 
> This moves the dma irq handling functions up in the source file, so that
> they are available before DMA preparation functions. It prepares the
> conversion to DMA engine, where the descriptors are populated with these
> functions as callbacks.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@intel.com>
> ---
> Since v1: fixed prototypes change
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 40 ++++++++++++++------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index c0c0f0f..1ab4f9d 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -311,6 +311,28 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>  
>  	BUG_ON(size != 0);
>  	return i + 1;
> +static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
> +			       enum pxa_camera_active_dma act_dma);

Yes, functions look ok now as the sense - they are just moved up with no 
modifications, but the patch itself looks as broken to me as it originally 
was... Please, look 2 lines up - where you add your lines.

Thanks
Guennadi

> +
> +static void pxa_camera_dma_irq_y(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(pcdev, DMA_Y);
> +}
> +
> +static void pxa_camera_dma_irq_u(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(pcdev, DMA_U);
> +}
> +
> +static void pxa_camera_dma_irq_v(int channel, void *data)
> +{
> +	struct pxa_camera_dev *pcdev = data;
> +
> +	pxa_camera_dma_irq(pcdev, DMA_V);
>  }
>  
>  /**
> @@ -810,24 +832,6 @@ out:
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
