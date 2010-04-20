Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753555Ab0DTHGg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 03:06:36 -0400
Date: Tue, 20 Apr 2010 09:06:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	jic23@cam.ac.uk, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH] pxa_camera: move fifo reset direct before dma start
In-Reply-To: <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.1004200905250.5292@axis700.grange>
References: <> <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert, what do you think? Are you still working with PXA camera?

Thanks
Guennadi

On Tue, 20 Apr 2010, Stefan Herbrechtsmeier wrote:

> Move the fifo reset from pxa_camera_start_capture to pxa_camera_irq direct
> before the dma start after an end of frame interrupt to prevent images from
> shifting because of old data at the begin of the frame.
> 
> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
> ---
>  drivers/media/video/pxa_camera.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 5ecc30d..04bf5c1 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -609,12 +609,9 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
>   */
>  static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
>  {
> -	unsigned long cicr0, cifr;
> +	unsigned long cicr0;
>  
>  	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
> -	/* Reset the FIFOs */
> -	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> -	__raw_writel(cifr, pcdev->base + CIFR);
>  	/* Enable End-Of-Frame Interrupt */
>  	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
>  	cicr0 &= ~CICR0_EOFM;
> @@ -935,7 +932,7 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
>  static irqreturn_t pxa_camera_irq(int irq, void *data)
>  {
>  	struct pxa_camera_dev *pcdev = data;
> -	unsigned long status, cicr0;
> +	unsigned long status, cifr, cicr0;
>  	struct pxa_buffer *buf;
>  	struct videobuf_buffer *vb;
>  
> @@ -949,6 +946,10 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
>  	__raw_writel(status, pcdev->base + CISR);
>  
>  	if (status & CISR_EOF) {
> +		/* Reset the FIFOs */
> +		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> +		__raw_writel(cifr, pcdev->base + CIFR);
> +
>  		pcdev->active = list_first_entry(&pcdev->capture,
>  					   struct pxa_buffer, vb.queue);
>  		vb = &pcdev->active->vb;
> -- 
> 1.5.4.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
