Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2BTMRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 07:17:32 -0500
Date: Mon, 20 Feb 2012 13:17:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v3 4/4] media i.MX27 camera: handle overflows properly.
In-Reply-To: <1327925653-13310-4-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1202201310030.2836@axis700.grange>
References: <1327925653-13310-1-git-send-email-javier.martin@vista-silicon.com>
 <1327925653-13310-4-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

Sorry again for a delayed reaction... I'm currently trying to prepare a 
push for 3.4 and I stumbled over this your patch:

On Mon, 30 Jan 2012, Javier Martin wrote:

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Changes since v2:
>  - Use true and false for bool variables.
> 
> ---
>  drivers/media/video/mx2_camera.c |   38 ++++++++++++++++----------------------
>  1 files changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index e7ccd97..09bcfe0 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1210,7 +1210,7 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
>  };
>  
>  static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
> -		int bufnum)
> +		int bufnum, bool err)
>  {
>  	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>  	struct mx2_buffer *buf;
> @@ -1258,7 +1258,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		list_del_init(&buf->queue);
>  		do_gettimeofday(&vb->v4l2_buf.timestamp);
>  		vb->v4l2_buf.sequence = pcdev->frame_count;
> -		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		if (err)
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +		else
> +			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>  	}
>  
>  	pcdev->frame_count++;
> @@ -1302,21 +1305,12 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>  			__func__);
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
> -	}
> -	if (((status & (3 << 5)) == (3 << 5)) ||
> +		buf = list_entry(pcdev->active_bufs.next,
> +			struct mx2_buffer, queue);
> +		mx27_camera_frame_done_emma(pcdev,
> +					buf->bufnum, true);
> +		status &= ~(1 << 7);
> +	} else if (((status & (3 << 5)) == (3 << 5)) ||

This means, in case of an overflow you don't reset the channels any more? 
Is there a reason for that?

Thanks
Guennadi

>  		((status & (3 << 3)) == (3 << 3))) {
>  		/*
>  		 * Both buffers have triggered, process the one we're expecting

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
