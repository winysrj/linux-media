Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab2AJLAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 06:00:13 -0500
Date: Tue, 10 Jan 2012 12:00:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Subject: Re: [PATCH] media i.MX27 camera: properly detect frame loss.
In-Reply-To: <1325494293-3968-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1201101138230.530@axis700.grange>
References: <1325494293-3968-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 2 Jan 2012, Javier Martin wrote:

> As V4L2 specification states, frame_count must also
> regard lost frames so that the user can handle that
> case properly.
> 
> This patch adds a mechanism to increment the frame
> counter even when a video buffer is not available
> and a discard buffer is used.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |   54 ++++++++++++++++++++++++--------------
>  1 files changed, 34 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ca76dd2..b244714 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -256,6 +256,7 @@ struct mx2_camera_dev {
>  	size_t			discard_size;
>  	struct mx2_fmt_cfg	*emma_prp;
>  	u32			frame_count;
> +	unsigned int		firstirq;

_if_ we indeed end up using this field, it seems it can be just a bool.

>  };
>  
>  /* buffer for one video frame */
> @@ -370,6 +371,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  
>  	pcdev->icd = icd;
>  	pcdev->frame_count = 0;
> +	pcdev->firstirq = 1;
>  
>  	dev_info(icd->parent, "Camera driver attached to camera %d\n",
>  		 icd->devnum);
> @@ -572,6 +574,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
>  	struct soc_camera_host *ici =
>  		to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
> +	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
>  	unsigned long flags;
>  
> @@ -584,6 +587,26 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
>  	list_add_tail(&vb->queue, &pcdev->capture);
>  
>  	if (mx27_camera_emma(pcdev)) {
> +		if (prp->cfg.channel == 1) {
> +			writel(PRP_CNTL_CH1EN |
> +				PRP_CNTL_CSIEN |
> +				prp->cfg.in_fmt |
> +				prp->cfg.out_fmt |
> +				PRP_CNTL_CH1_LEN |
> +				PRP_CNTL_CH1BYP |
> +				PRP_CNTL_CH1_TSKIP(0) |
> +				PRP_CNTL_IN_TSKIP(0),
> +				pcdev->base_emma + PRP_CNTL);
> +		} else {
> +			writel(PRP_CNTL_CH2EN |
> +				PRP_CNTL_CSIEN |
> +				prp->cfg.in_fmt |
> +				prp->cfg.out_fmt |
> +				PRP_CNTL_CH2_LEN |
> +				PRP_CNTL_CH2_TSKIP(0) |
> +				PRP_CNTL_IN_TSKIP(0),
> +				pcdev->base_emma + PRP_CNTL);
> +		}

Is this related and why is this needed?

>  		goto out;
>  	} else { /* cpu_is_mx25() */
>  		u32 csicr3, dma_inten = 0;
> @@ -747,16 +770,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
>  		writel(pcdev->discard_buffer_dma,
>  				pcdev->base_emma + PRP_DEST_RGB2_PTR);
>  
> -		writel(PRP_CNTL_CH1EN |
> -				PRP_CNTL_CSIEN |
> -				prp->cfg.in_fmt |
> -				prp->cfg.out_fmt |
> -				PRP_CNTL_CH1_LEN |
> -				PRP_CNTL_CH1BYP |
> -				PRP_CNTL_CH1_TSKIP(0) |
> -				PRP_CNTL_IN_TSKIP(0),
> -				pcdev->base_emma + PRP_CNTL);
> -
>  		writel((icd->user_width << 16) | icd->user_height,
>  			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>  		writel((icd->user_width << 16) | icd->user_height,
> @@ -784,15 +797,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
>  				pcdev->base_emma + PRP_SOURCE_CR_PTR);
>  		}
>  
> -		writel(PRP_CNTL_CH2EN |
> -			PRP_CNTL_CSIEN |
> -			prp->cfg.in_fmt |
> -			prp->cfg.out_fmt |
> -			PRP_CNTL_CH2_LEN |
> -			PRP_CNTL_CH2_TSKIP(0) |
> -			PRP_CNTL_IN_TSKIP(0),
> -			pcdev->base_emma + PRP_CNTL);
> -
>  		writel((icd->user_width << 16) | icd->user_height,
>  			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>  
> @@ -1214,7 +1218,6 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		vb->state = state;
>  		do_gettimeofday(&vb->ts);
>  		vb->field_count = pcdev->frame_count * 2;
> -		pcdev->frame_count++;
>  
>  		wake_up(&vb->done);
>  	}

Wouldn't you achieve the same by simply initialising frame_count to -1 and 
incrementing it unconditionally just below this if?

> @@ -1239,6 +1242,17 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		return;
>  	}
>  
> +	/*
> +	 * According to V4L2 specification, first valid sequence number must
> +	 * be 0. However, by design the first received frame is written to the
> +	 * discard buffer even when a video buffer is available. For that reason
> +	 * we don't increment frame_count the first time.
> +	 */
> +	if (pcdev->firstirq)
> +		pcdev->firstirq = 0;
> +	else
> +		pcdev->frame_count++;
> +
>  	buf = list_entry(pcdev->capture.next,
>  			struct mx2_buffer, vb.queue);

Aren't you losing frames, that you receive, while the capture queue is 
empty? Whereas the above proposed approach should catch them all, I think.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
