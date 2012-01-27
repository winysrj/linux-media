Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2A0PZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 10:25:34 -0500
Date: Fri, 27 Jan 2012 16:25:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, baruch@tkos.co.il
Subject: Re: [PATCH v2 1/4] media i.MX27 camera: migrate driver to videobuf2
In-Reply-To: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1201270952250.32661@axis700.grange>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A general question for mx2-camera: does it now after removal of legacy 
i.MX27 support only support i.MX25 (state: unknown) and i.MX27 in eMMA 
mode?

On Thu, 26 Jan 2012, Javier Martin wrote:

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Changes since v1:
>  - mx27 code doesn't use states.
>  - number of states reduced to the ones used by mx25.
>  - Fix incorrect if which broke mx25 support.
>  - Minor fixes.
> 
> ---
>  drivers/media/video/mx2_camera.c |  298 ++++++++++++++++----------------------
>  1 files changed, 127 insertions(+), 171 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ca76dd2..898f98f 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c

[snip]

> @@ -467,59 +474,50 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
>  /*
>   *  Videobuf operations
>   */
> -static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
> -			      unsigned int *size)
> +static int mx2_videobuf_setup(struct vb2_queue *vq,
> +			const struct v4l2_format *fmt,
> +			unsigned int *count, unsigned int *num_planes,
> +			unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	struct soc_camera_device *icd = vq->priv_data;
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct mx2_camera_dev *pcdev = ici->priv;
>  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>  			icd->current_fmt->host_fmt);
>  
> -	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
> +	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, sizes[0]);
> +
> +	/* TODO: support for VIDIOC_CREATE_BUFS not ready */
> +	if (fmt != NULL)
> +		return -EINVAL;

Maybe -ENOTTY? It seems to be preferred over ENOIOCTLCMD and ENOSYS these 
days. See, e.g.

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/34754/focus=1160430

and the whole that thread, if you feel bored;-)

>  
>  	if (bytes_per_line < 0)
>  		return bytes_per_line;
>  
> -	*size = bytes_per_line * icd->user_height;
> +	alloc_ctxs[0] = pcdev->alloc_ctx;
> +
> +	sizes[0] = bytes_per_line * icd->user_height;
>  
>  	if (0 == *count)
>  		*count = 32;
> -	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
> -		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
> -
> -	return 0;
> -}
> -
> -static void free_buffer(struct videobuf_queue *vq, struct mx2_buffer *buf)
> -{
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct videobuf_buffer *vb = &buf->vb;
> -
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	/*
> -	 * This waits until this buffer is out of danger, i.e., until it is no
> -	 * longer in state VIDEOBUF_QUEUED or VIDEOBUF_ACTIVE
> -	 */
> -	videobuf_waiton(vq, vb, 0, 0);
> +	if (!*num_planes &&
> +	    sizes[0] * *count > MAX_VIDEO_MEM * 1024 * 1024)
> +		*count = (MAX_VIDEO_MEM * 1024 * 1024) / sizes[0];
>  
> -	videobuf_dma_contig_free(vq, vb);
> -	dev_dbg(icd->parent, "%s freed\n", __func__);
> +	*num_planes = 1;
>  
> -	vb->state = VIDEOBUF_NEEDS_INIT;
> +	return 0;
>  }
>  
> -static int mx2_videobuf_prepare(struct videobuf_queue *vq,
> -		struct videobuf_buffer *vb, enum v4l2_field field)
> +static int mx2_videobuf_prepare(struct vb2_buffer *vb)
>  {
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>  			icd->current_fmt->host_fmt);
>  	int ret = 0;
>  
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> +	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> +		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>  
>  	if (bytes_per_line < 0)
>  		return bytes_per_line;
> @@ -529,59 +527,39 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
>  	 * This can be useful if you want to see if we actually fill
>  	 * the buffer with something
>  	 */
> -	memset((void *)vb->baddr, 0xaa, vb->bsize);
> +	memset((void *)vb2_plane_vaddr(vb, 0),
> +	       0xaa, vb2_get_plane_payload(vb, 0));
>  #endif
>  
> -	if (buf->code	!= icd->current_fmt->code ||
> -	    vb->width	!= icd->user_width ||
> -	    vb->height	!= icd->user_height ||
> -	    vb->field	!= field) {
> -		buf->code	= icd->current_fmt->code;
> -		vb->width	= icd->user_width;
> -		vb->height	= icd->user_height;
> -		vb->field	= field;
> -		vb->state	= VIDEOBUF_NEEDS_INIT;
> -	}
> -
> -	vb->size = bytes_per_line * vb->height;
> -	if (vb->baddr && vb->bsize < vb->size) {
> +	vb2_set_plane_payload(vb, 0, bytes_per_line * icd->user_height);
> +	if (vb2_plane_vaddr(vb, 0) &&
> +	    vb2_get_plane_payload(vb, 0) < vb2_plane_size(vb, 0)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}

Sorry, this didn't occur to me, when reviewing v1: is this really what you 
intend to test for? You're testing, that payload (i.e., the amount of 
data) is smaller than the plane size, in which case you return an error. 
Shouldn't the test be reverted to verify sufficient buffer size?

>  
> -	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> -		ret = videobuf_iolock(vq, vb, NULL);
> -		if (ret)
> -			goto fail;
> -
> -		vb->state = VIDEOBUF_PREPARED;
> -	}
> -
>  	return 0;
>  
> -fail:
> -	free_buffer(vq, buf);
>  out:
>  	return ret;
>  }
>  
> -static void mx2_videobuf_queue(struct videobuf_queue *vq,
> -			       struct videobuf_buffer *vb)
> +static void mx2_videobuf_queue(struct vb2_buffer *vb)
>  {
> -	struct soc_camera_device *icd = vq->priv_data;
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>  	struct soc_camera_host *ici =
>  		to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
>  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
>  	unsigned long flags;
>  
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> +	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> +		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>  
>  	spin_lock_irqsave(&pcdev->lock, flags);
>  
> -	vb->state = VIDEOBUF_QUEUED;
> -	list_add_tail(&vb->queue, &pcdev->capture);
> +	buf->state = MX2_STATE_QUEUED;
> +	list_add_tail(&buf->queue, &pcdev->capture);
>  
>  	if (mx27_camera_emma(pcdev)) {
>  		goto out;

[snip]

> @@ -625,50 +603,36 @@ out:
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  }
>  
> -static void mx2_videobuf_release(struct videobuf_queue *vq,
> -				 struct videobuf_buffer *vb)
> +static void mx2_videobuf_release(struct vb2_buffer *vb)
>  {
> -	struct soc_camera_device *icd = vq->priv_data;
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
>  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
>  	unsigned long flags;
>  
>  #ifdef DEBUG
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> +	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> +		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>  
> -	switch (vb->state) {
> -	case VIDEOBUF_ACTIVE:
> +	switch (buf->state) {
> +	case MX2_STATE_ACTIVE:
>  		dev_info(icd->parent, "%s (active)\n", __func__);
>  		break;
> -	case VIDEOBUF_QUEUED:
> +	case MX2_STATE_QUEUED:
>  		dev_info(icd->parent, "%s (queued)\n", __func__);
>  		break;
> -	case VIDEOBUF_PREPARED:
> -		dev_info(icd->parent, "%s (prepared)\n", __func__);
> -		break;
>  	default:
>  		dev_info(icd->parent, "%s (unknown) %d\n", __func__,
> -				vb->state);
> +				buf->state);
>  		break;
>  	}
>  #endif
>  
> -	/*
> -	 * Terminate only queued but inactive buffers. Active buffers are
> -	 * released when they become inactive after videobuf_waiton().
> -	 *
> -	 * FIXME: implement forced termination of active buffers for mx27 and
> -	 * mx27 eMMA, so that the user won't get stuck in an uninterruptible
> -	 * state. This requires a specific handling for each of the these DMA
> -	 * types.
> -	 */

Does this mean, that this is fixed now and also active buffers get 
terminated properly on the hardware? I don't see any code for that...

>  	spin_lock_irqsave(&pcdev->lock, flags);
> -	if (vb->state == VIDEOBUF_QUEUED) {
> -		list_del(&vb->queue);
> -		vb->state = VIDEOBUF_ERROR;
> -	} else if (cpu_is_mx25() && vb->state == VIDEOBUF_ACTIVE) {
> +	if (mx27_camera_emma(pcdev)) {
> +		list_del_init(&buf->queue);

Don't mx25 buffers in the QUEUED state have to be removed from the list?

> +	} else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
>  		if (pcdev->fb1_active == buf) {
>  			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
>  			writel(0, pcdev->base_csi + CSIDMASA_FB1);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
