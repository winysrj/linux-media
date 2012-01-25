Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2AYMR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 07:17:26 -0500
Date: Wed, 25 Jan 2012 13:17:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Subject: Re: [PATCH 4/4] media i.MX27 camera: handle overflows properly.
In-Reply-To: <1327059392-29240-5-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1201251314230.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
 <1327059392-29240-5-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Jan 2012, Javier Martin wrote:

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |   23 +++++++++--------------
>  1 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index e0c5dd4..cdc614f 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1274,7 +1274,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		buf->state = state;
>  		do_gettimeofday(&vb->v4l2_buf.timestamp);
>  		vb->v4l2_buf.sequence = pcdev->frame_count;
> -		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		if (state == MX2_STATE_ERROR)
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +		else
> +			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>  	}
>  
>  	pcdev->frame_count++;
> @@ -1309,19 +1312,11 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>  	struct mx2_buffer *buf;
>  
>  	if (status & (1 << 7)) { /* overflow */
> -		u32 cntl;
> -		/*
> -		 * We only disable channel 1 here since this is the only
> -		 * enabled channel
> -		 *
> -		 * FIXME: the correct DMA overflow handling should be resetting
> -		 * the buffer, returning an error frame, and continuing with
> -		 * the next one.
> -		 */
> -		cntl = readl(pcdev->base_emma + PRP_CNTL);
> -		writel(cntl & ~(PRP_CNTL_CH1EN | PRP_CNTL_CH2EN),
> -		       pcdev->base_emma + PRP_CNTL);
> -		writel(cntl, pcdev->base_emma + PRP_CNTL);
> +		buf = list_entry(pcdev->active_bufs.next,
> +			struct mx2_buffer, queue);
> +		mx27_camera_frame_done_emma(pcdev,
> +					buf->bufnum, MX2_STATE_ERROR);
> +		status &= ~(1 << 7);
>  	}
>  	if ((((status & (3 << 5)) == (3 << 5)) ||

Does it make sense continuing processing here, if an error occurred? To me 
all the four "if" statements in this function seem mutually-exclusive and 
should be handled by a

	if () {
	} else if () {
	...
chain.

>  		((status & (3 << 3)) == (3 << 3)))
> -- 
> 1.7.0.4
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
