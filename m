Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2AYK0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 05:26:49 -0500
Date: Wed, 25 Jan 2012 11:26:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Subject: Re: [PATCH 2/4] media i.MX27 camera: add start_stream and stop_stream
 callbacks.
In-Reply-To: <1327059392-29240-3-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1201251123290.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
 <1327059392-29240-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed before, please, merge this patch with

"media i.MX27 camera: properly detect frame loss."

One more cosmetic note:

On Fri, 20 Jan 2012, Javier Martin wrote:

> Add "start_stream" and "stop_stream" callback in order to enable
> and disable the eMMa-PrP properly and save CPU usage avoiding
> IRQs when the device is not streaming.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |  107 +++++++++++++++++++++++++++-----------
>  1 files changed, 77 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 290ac9d..4816da6 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -560,7 +560,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>  	struct soc_camera_host *ici =
>  		to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
> -	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
>  	unsigned long flags;
>  
> @@ -572,29 +571,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>  	buf->state = MX2_STATE_QUEUED;
>  	list_add_tail(&buf->queue, &pcdev->capture);
>  
> -	if (mx27_camera_emma(pcdev)) {
> -		if (prp->cfg.channel == 1) {
> -			writel(PRP_CNTL_CH1EN |
> -				PRP_CNTL_CSIEN |
> -				prp->cfg.in_fmt |
> -				prp->cfg.out_fmt |
> -				PRP_CNTL_CH1_LEN |
> -				PRP_CNTL_CH1BYP |
> -				PRP_CNTL_CH1_TSKIP(0) |
> -				PRP_CNTL_IN_TSKIP(0),
> -				pcdev->base_emma + PRP_CNTL);
> -		} else {
> -			writel(PRP_CNTL_CH2EN |
> -				PRP_CNTL_CSIEN |
> -				prp->cfg.in_fmt |
> -				prp->cfg.out_fmt |
> -				PRP_CNTL_CH2_LEN |
> -				PRP_CNTL_CH2_TSKIP(0) |
> -				PRP_CNTL_IN_TSKIP(0),
> -				pcdev->base_emma + PRP_CNTL);
> -		}
> -		goto out;
> -	} else { /* cpu_is_mx25() */
> +	if (!mx27_camera_emma(pcdev)) { /* cpu_is_mx25() */
>  		u32 csicr3, dma_inten = 0;
>  
>  		if (pcdev->fb1_active == NULL) {
> @@ -629,8 +606,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>  			writel(csicr3, pcdev->base_csi + CSICR3);
>  		}
>  	}
> -
> -out:

To my taste you're a bit too aggressive on blank lines;-) This also holds 
for the previous patch. Unless you absolutely have to edit your sources in 
a 24-line terminal, keeping those empty lines would be appreciated:-)

Thanks
Guennadi

>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  }
>  
> @@ -692,11 +667,83 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  }
>  
> +static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
> +	struct soc_camera_host *ici =
> +		to_soc_camera_host(icd->parent);
> +	struct mx2_camera_dev *pcdev = ici->priv;
> +	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&pcdev->lock, flags);
> +	if (mx27_camera_emma(pcdev)) {
> +		if (count < 2) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
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
> +	}
> +err:
> +	spin_unlock_irqrestore(&pcdev->lock, flags);
> +
> +	return ret;
> +}
> +
> +static int mx2_stop_streaming(struct vb2_queue *q)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
> +	struct soc_camera_host *ici =
> +		to_soc_camera_host(icd->parent);
> +	struct mx2_camera_dev *pcdev = ici->priv;
> +	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
> +	unsigned long flags;
> +	u32 cntl;
> +
> +	spin_lock_irqsave(&pcdev->lock, flags);
> +	if (mx27_camera_emma(pcdev)) {
> +		cntl = readl(pcdev->base_emma + PRP_CNTL);
> +		if (prp->cfg.channel == 1) {
> +			writel(cntl & ~PRP_CNTL_CH1EN,
> +			       pcdev->base_emma + PRP_CNTL);
> +		} else {
> +			writel(cntl & ~PRP_CNTL_CH2EN,
> +			       pcdev->base_emma + PRP_CNTL);
> +		}
> +	}
> +	spin_unlock_irqrestore(&pcdev->lock, flags);
> +
> +	return 0;
> +}
> +
>  static struct vb2_ops mx2_videobuf_ops = {
> -	.queue_setup	= mx2_videobuf_setup,
> -	.buf_prepare	= mx2_videobuf_prepare,
> -	.buf_queue	= mx2_videobuf_queue,
> -	.buf_cleanup	= mx2_videobuf_release,
> +	.queue_setup	 = mx2_videobuf_setup,
> +	.buf_prepare	 = mx2_videobuf_prepare,
> +	.buf_queue	 = mx2_videobuf_queue,
> +	.buf_cleanup	 = mx2_videobuf_release,
> +	.start_streaming = mx2_start_streaming,
> +	.stop_streaming  = mx2_stop_streaming,
>  };
>  
>  static int mx2_camera_init_videobuf(struct vb2_queue *q,
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
