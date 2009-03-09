Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750865AbZCILjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 07:39:36 -0400
Date: Mon, 9 Mar 2009 12:39:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] pxa_camera: Fix overrun condition on last buffer
In-Reply-To: <1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0903091236540.3992@axis700.grange>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Robert Jarzmik wrote:

> The last buffer queued will often overrun, as the DMA chain
> is finished, and the time the dma irq handler is activated,

s/and the time/and during the time/ ?

> the QIF fifos are filled by the sensor.
> 
> The fix is to ignore the overrun condition on the last
> queued buffer, and restart the capture only on intermediate
> buffers of the chain.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 16bf0a3..dd56c35 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -734,14 +734,18 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
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
>  				camera_status);
>  			pxa_camera_stop_capture(pcdev);
>  			pxa_camera_start_capture(pcdev);
>  			goto out;
>  		}
> -
>  		buf->active_dma &= ~act_dma;

This empty like removal doesn't belong to the fix, I'll remove it when 
committing, and amend the commit message as above. Please, comment if you 
disagree.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
