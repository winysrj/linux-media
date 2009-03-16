Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754071AbZCPLZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:25:22 -0400
Date: Mon, 16 Mar 2009 12:25:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pxa_camera: Fix overrun condition on last buffer
In-Reply-To: <1236986240-24115-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0903161225020.4409@axis700.grange>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009, Robert Jarzmik wrote:

> The last buffer queued will often overrun, as the DMA chain
> is finished, and the time the dma irq handler is activated,
> the QIF fifos are filled by the sensor.
> 
> The fix is to ignore the overrun condition on the last
> queued buffer, and restart the capture only on intermediate
> buffers of the chain.
> 
> Moreover, a fix was added to the very unlikely condition
> where in YUV422P mode, one channel overruns while another
> completes at the very same time. The capture is restarted
> after the overrun as before, but the other channel
> completion is now ignored.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index a0ca982..35e54fc 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -623,6 +623,7 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
>  	cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
>  	__raw_writel(cicr0, pcdev->base + CICR0);
>  
> +	pcdev->active = NULL;
>  	dev_dbg(pcdev->dev, "%s\n", __func__);
>  }
>  
> @@ -696,7 +697,6 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>  
>  	if (list_empty(&pcdev->capture)) {
>  		pxa_camera_stop_capture(pcdev);
> -		pcdev->active = NULL;
>  		for (i = 0; i < pcdev->channels; i++)
>  			pcdev->sg_tail[i] = NULL;
>  		return;
> @@ -764,10 +764,20 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  		goto out;
>  	}
>  
> -	if (!pcdev->active) {
> -		dev_err(pcdev->dev, "DMA End IRQ with no active buffer!\n");
> +	/*
> +	 * pcdev->active should not be NULL in DMA irq handler.
> +	 *
> +	 * But there is one corner case : if capture was stopped due to an
> +	 * overrun of channel 1, and at that same channel 2 was completed.
> +	 *
> +	 * When handling the overrun in DMA irq for channel 1, we'll stop the
> +	 * capture and restart it (and thus set pcdev->active to NULL). But the
> +	 * DMA irq handler will already be pending for channel 2. So on entering
> +	 * the DMA irq handler for channel 2 there will be no active buffer, yet
> +	 * that is normal.
> +	 */
> +	if (!pcdev->active)
>  		goto out;
> -	}
>  
>  	vb = &pcdev->active->vb;
>  	buf = container_of(vb, struct pxa_buffer, vb);
> @@ -778,7 +788,12 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
>  
>  	if (status & DCSR_ENDINTR) {
> -		if (camera_status & overrun) {
> +		/*
> +		 * It's normal if the last frame creates an overrun, as there
> +		 * are no more DMA descriptors to fetch from QIF fifos
> +		 */
> +		if (camera_status & overrun
> +		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
>  			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",

Please, put "&&" on the first line:-)

>  				camera_status);
>  			pxa_camera_stop_capture(pcdev);
> -- 
> 1.5.6.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
