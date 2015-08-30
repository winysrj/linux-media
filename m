Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49212 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbbH3MzN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 08:55:13 -0400
Date: Sun, 30 Aug 2015 14:55:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] media: pxa_camera: conversion to dmaengine
In-Reply-To: <1438198744-6150-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1508301440460.29683@axis700.grange>
References: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
 <1438198744-6150-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

I assume, the next iteration of your patches won't contain a local copy of 
the SG splitting code.

On Wed, 29 Jul 2015, Robert Jarzmik wrote:

> Convert pxa_camera to dmaengine. This removes all DMA registers
> manipulation in favor of the more generic dmaengine API.
> 
> The functional level should be the same as before. The biggest change is
> in the videobuf_sg_splice() function, which splits a videobuf-dma into
> several scatterlists for 3 planes captures (Y, U, V).
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> Since v1: Guennadi's fixes
>           dma tasklet functions prototypes change (trivial move)
> Since v2: sglist cut revamped with Guennadi's comments
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 492 ++++++++++++++-----------
>  1 file changed, 267 insertions(+), 225 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index cdfb93aaee43..030ed7413bba 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c

[snip]

> @@ -806,28 +824,41 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  	buf = container_of(vb, struct pxa_buffer, vb);
>  	WARN_ON(buf->inwork || list_empty(&vb->queue));
>  
> -	dev_dbg(dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
> -		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
> -		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
> -
> -	if (status & DCSR_ENDINTR) {
> -		/*
> -		 * It's normal if the last frame creates an overrun, as there
> -		 * are no more DMA descriptors to fetch from QCI fifos
> -		 */
> -		if (camera_status & overrun &&
> -		    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
> -			dev_dbg(dev, "FIFO overrun! CISR: %x\n",
> -				camera_status);
> -			pxa_camera_stop_capture(pcdev);
> -			pxa_camera_start_capture(pcdev);
> -			goto out;
> -		}
> -		buf->active_dma &= ~act_dma;
> -		if (!buf->active_dma) {
> -			pxa_camera_wakeup(pcdev, vb, buf);
> -			pxa_camera_check_link_miss(pcdev);
> -		}
> +	/*
> +	 * It's normal if the last frame creates an overrun, as there
> +	 * are no more DMA descriptors to fetch from QCI fifos
> +	 */
> +	switch (act_dma) {
> +	case DMA_U:
> +		chan = 1;
> +		break;
> +	case DMA_V:
> +		chan = 2;
> +		break;
> +	default:
> +		chan = 0;
> +		break;
> +	}
> +	last_buf = list_entry(pcdev->capture.prev,
> +			      struct pxa_buffer, vb.queue);

You can use list_last_entry()

> +	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
> +					       last_buf->cookie[chan],
> +					       NULL, &last_issued);
> +	if (camera_status & overrun &&
> +	    last_status != DMA_COMPLETE) {
> +		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
> +			camera_status);
> +		pxa_camera_stop_capture(pcdev);
> +		list_for_each_entry(buf, &pcdev->capture, vb.queue)
> +			pxa_dma_add_tail_buf(pcdev, buf);

Why have you added this loop? Is it a bug in the current implementation or 
is it only needed with the switch to dmaengine?

> +		pxa_camera_start_capture(pcdev);
> +		goto out;
> +	}
> +	buf->active_dma &= ~act_dma;
> +	if (!buf->active_dma) {
> +		pxa_camera_wakeup(pcdev, vb, buf);
> +		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
> +					   last_issued);
>  	}
>  
>  out:
> @@ -1014,10 +1045,7 @@ static void pxa_camera_clock_stop(struct soc_camera_host *ici)
>  	__raw_writel(0x3ff, pcdev->base + CICR0);
>  
>  	/* Stop DMA engine */
> -	DCSR(pcdev->dma_chans[0]) = 0;
> -	DCSR(pcdev->dma_chans[1]) = 0;
> -	DCSR(pcdev->dma_chans[2]) = 0;
> -
> +	pxa_dma_stop_channels(pcdev);
>  	pxa_camera_deactivate(pcdev);
>  }
>  
> 

Thanks
Guennadi
