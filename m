Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2A0PxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 10:53:25 -0500
Date: Fri, 27 Jan 2012 16:53:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Subject: Re: [PATCH v2 2/4] media i.MX27 camera: add start_stream and
 stop_stream callbacks.
In-Reply-To: <1327579472-31597-2-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1201271643040.32661@axis700.grange>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
 <1327579472-31597-2-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Jan 2012, Javier Martin wrote:

> Add "start_stream" and "stop_stream" callback in order to enable
> and disable the eMMa-PrP properly and save CPU usage avoiding
> IRQs when the device is not streaming. This also makes the driver
> return 0 as the sequence number of the first frame.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Merge "media i.MX27 camera: properly detect frame loss"
> 
> ---
>  drivers/media/video/mx2_camera.c |  104 +++++++++++++++++++++++++++++---------
>  1 files changed, 79 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 898f98f..045c018 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -377,7 +377,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
>  
>  	pcdev->icd = icd;
> -	pcdev->frame_count = 0;
> +	pcdev->frame_count = -1;
>  
>  	dev_info(icd->parent, "Camera driver attached to camera %d\n",
>  		 icd->devnum);
> @@ -647,11 +647,83 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
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

How about:

	if (mx27_camera_emma(pcdev)) {
		unsigned long flags;
		if (count < 2)
			return -EINVAL;

		spin_lock_irqsave(&pcdev->lock, flags);
		...
		spin_unlock_irqrestore(&pcdev->lock, flags);
	}

	return 0;

Another point: in v1 of this patch you also removed "goto out" from 
mx2_videobuf_queue(). I understand this is probably unrelated to this 
patch now. Anyway, if you don't find a patch out of your 4 now, where it 
logically would fit, you could either make an additional patch, or I could 
do it myself, if I don't forget:-)

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
> +	.stop_streaming	 = mx2_stop_streaming,
>  };
>  
>  static int mx2_camera_init_videobuf(struct vb2_queue *q,

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
