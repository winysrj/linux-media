Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9175 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab1FVN70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 09:59:26 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LN700L8H2ULRZ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 14:59:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN700CUS2UK6J@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 14:59:09 +0100 (BST)
Date: Wed, 22 Jun 2011 15:59:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/5] marvell-cam: convert to videobuf2
In-reply-to: <1308597280-138673-2-git-send-email-corbet@lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, 'Kassey Lee' <ygli@marvell.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <003e01cc30e4$8c36f370$a4a4da50$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
 <1308597280-138673-2-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Jonathan,

On Monday, June 20, 2011 9:15 PM Jonathan Corbet wrote:

> This is a basic, naive conversion to the videobuf2 infrastructure, removing
> a lot of code in the process.  For now, we're using vmalloc, which is
> suboptimal, but it does match what the cafe driver did before.

Could you elaborate a bit why vmalloc is suboptimal for your case?

> In the cafe
> case, it may have to stay that way just because memory is too tight to do
> direct streaming; mmp-camera will be able to do better.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/marvell-ccic/Kconfig     |    2 +
>  drivers/media/video/marvell-ccic/mcam-core.c |  579 ++++++++--------------
> ----
>  drivers/media/video/marvell-ccic/mcam-core.h |   26 +-
>  3 files changed, 196 insertions(+), 411 deletions(-)
> 
> diff --git a/drivers/media/video/marvell-ccic/Kconfig
> b/drivers/media/video/marvell-ccic/Kconfig
> index b4f7260..eb535b1 100644
> --- a/drivers/media/video/marvell-ccic/Kconfig
> +++ b/drivers/media/video/marvell-ccic/Kconfig
> @@ -2,6 +2,7 @@ config VIDEO_CAFE_CCIC
>  	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>  	depends on PCI && I2C && VIDEO_V4L2
>  	select VIDEO_OV7670
> +	select VIDEOBUF2_VMALLOC
>  	---help---
>  	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
>  	  CMOS camera controller.  This is the controller found on first-
> @@ -12,6 +13,7 @@ config VIDEO_MMP_CAMERA
>  	depends on ARCH_MMP && I2C && VIDEO_V4L2
>  	select VIDEO_OV7670
>  	select I2C_GPIO
> +	select VIDEOBUF2_VMALLOC
>  	---help---
>  	  This is a Video4Linux2 driver for the integrated camera
>  	  controller found on Marvell Armada 610 application
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c
> b/drivers/media/video/marvell-ccic/mcam-core.c
> index 3e6a5e8..055d843 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -17,6 +17,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/ov7670.h>
> +#include <media/videobuf2-vmalloc.h>
>  #include <linux/device.h>
>  #include <linux/wait.h>
>  #include <linux/list.h>
> @@ -149,7 +150,6 @@ static void mcam_reset_buffers(struct mcam_camera *cam)
>  	cam->next_buf = -1;
>  	for (i = 0; i < cam->nbufs; i++)
>  		clear_bit(i, &cam->flags);
> -	cam->specframes = 0;
>  }
> 
>  static inline int mcam_needs_config(struct mcam_camera *cam)
> @@ -165,6 +165,21 @@ static void mcam_set_config_needed(struct mcam_camera
> *cam, int needed)
>  		clear_bit(CF_CONFIG_NEEDED, &cam->flags);
>  }
> 
> +/*
> + * Our buffer type for working with videobuf2.  Note that the vb2
> + * developers have decreed that struct vb2_buffer must be at the
> + * beginning of this structure.
> + */
> +struct mcam_vb_buffer {
> +	struct vb2_buffer vb_buf;
> +	struct list_head queue;
> +};
> +
> +static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
> +{
> +	return container_of(vb, struct mcam_vb_buffer, vb_buf);
> +}
> +
> 
>  /*
>   * Debugging and related.
> @@ -339,9 +354,7 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
>  	spin_lock_irqsave(&cam->dev_lock, flags);
>  	mcam_ctlr_stop(cam);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
> -	mdelay(1);
> -	wait_event_timeout(cam->iowait,
> -			!test_bit(CF_DMA_ACTIVE, &cam->flags), HZ);
> +	msleep(10);
>  	if (test_bit(CF_DMA_ACTIVE, &cam->flags))
>  		cam_err(cam, "Timeout waiting for DMA to end\n");
>  		/* This would be bad news - what now? */
> @@ -524,44 +537,11 @@ static void mcam_free_dma_bufs(struct mcam_camera
> *cam)
> 
> 
> 
> -
> -
>  /* -----------------------------------------------------------------------
> */
>  /*
>   * Here starts the V4L2 interface code.
>   */
> 
> -/*
> - * Read an image from the device.
> - */
> -static ssize_t mcam_deliver_buffer(struct mcam_camera *cam,
> -		char __user *buffer, size_t len, loff_t *pos)
> -{
> -	int bufno;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&cam->dev_lock, flags);
> -	if (cam->next_buf < 0) {
> -		cam_err(cam, "deliver_buffer: No next buffer\n");
> -		spin_unlock_irqrestore(&cam->dev_lock, flags);
> -		return -EIO;
> -	}
> -	bufno = cam->next_buf;
> -	clear_bit(bufno, &cam->flags);
> -	if (++(cam->next_buf) >= cam->nbufs)
> -		cam->next_buf = 0;
> -	if (!test_bit(cam->next_buf, &cam->flags))
> -		cam->next_buf = -1;
> -	cam->specframes = 0;
> -	spin_unlock_irqrestore(&cam->dev_lock, flags);
> -
> -	if (len > cam->pix_format.sizeimage)
> -		len = cam->pix_format.sizeimage;
> -	if (copy_to_user(buffer, cam->dma_bufs[bufno], len))
> -		return -EFAULT;
> -	(*pos) += len;
> -	return len;
> -}
> 
>  /*
>   * Get everything ready, and start grabbing frames.
> @@ -598,75 +578,138 @@ static int mcam_read_setup(struct mcam_camera *cam,
> enum mcam_state state)
>  	return 0;
>  }
> 
> +/* -----------------------------------------------------------------------
> */
> +/*
> + * Videobuf2 interface code.
> + */
> 
> -static ssize_t mcam_v4l_read(struct file *filp,
> -		char __user *buffer, size_t len, loff_t *pos)
> +static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
> +		unsigned int *num_planes, unsigned long sizes[],
> +		void *alloc_ctxs[])
>  {
> -	struct mcam_camera *cam = filp->private_data;
> -	int ret = 0;
> +	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> +
> +	sizes[0] = cam->pix_format.sizeimage;
> +	*num_planes = 1; /* Someday we have to support planar formats... */
> +	if (*nbufs < 2 || *nbufs > 32)
> +		*nbufs = 6;  /* semi-arbitrary numbers */
> +	return 0;
> +}
> +
> +static int mcam_vb_buf_init(struct vb2_buffer *vb)
> +{
> +	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
> +
> +	INIT_LIST_HEAD(&mvb->queue);

This operation is not needed. mvb->queue is used only by list_add() which
overwrites the values set here.

> +	return 0;
> +}

Taking the above, the whole mcam_bv_buf_init() callback is not needed.

> +
> +static void mcam_vb_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
> +	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cam->dev_lock, flags);
> +	list_add(&cam->buffers, &mvb->queue);
> +	spin_unlock_irqrestore(&cam->dev_lock, flags);
> +}
> +
> +/*
> + * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
> + * not actually sure we need to do this (I'm not sure that vb2_dqbuf()
> needs
> + * to be called with the mutex held), but better safe than sorry.
> + */
> +static void mcam_vb_wait_prepare(struct vb2_queue *vq)
> +{
> +	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> +
> +	mutex_unlock(&cam->s_mutex);
> +}
> +
> +static void mcam_vb_wait_finish(struct vb2_queue *vq)
> +{
> +	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> 
> -	/*
> -	 * Perhaps we're in speculative read mode and already
> -	 * have data?
> -	 */
>  	mutex_lock(&cam->s_mutex);
> -	if (cam->state == S_SPECREAD) {
> -		if (cam->next_buf >= 0) {
> -			ret = mcam_deliver_buffer(cam, buffer, len, pos);
> -			if (ret != 0)
> -				goto out_unlock;
> -		}
> -	} else if (cam->state == S_FLAKED || cam->state == S_NOTREADY) {
> -		ret = -EIO;
> -		goto out_unlock;
> -	} else if (cam->state != S_IDLE) {
> -		ret = -EBUSY;
> -		goto out_unlock;
> -	}
> +}
> 
> -	/*
> -	 * v4l2: multiple processes can open the device, but only
> -	 * one gets to grab data from it.
> -	 */
> -	if (cam->owner && cam->owner != filp) {
> -		ret = -EBUSY;
> -		goto out_unlock;
> -	}
> -	cam->owner = filp;
> +/*
> + * These need to be called with the mutex held from vb2
> + */
> +static int mcam_vb_start_streaming(struct vb2_queue *vq)
> +{
> +	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> +	int ret = -EINVAL;
> 
> -	/*
> -	 * Do setup if need be.
> -	 */
> -	if (cam->state != S_SPECREAD) {
> -		ret = mcam_read_setup(cam, S_SINGLEREAD);
> -		if (ret)
> -			goto out_unlock;
> -	}
> -	/*
> -	 * Wait for something to happen.  This should probably
> -	 * be interruptible (FIXME).
> -	 */
> -	wait_event_timeout(cam->iowait, cam->next_buf >= 0, HZ);
> -	if (cam->next_buf < 0) {
> -		cam_err(cam, "read() operation timed out\n");
> -		mcam_ctlr_stop_dma(cam);
> -		ret = -EIO;
> -		goto out_unlock;
> +	if (cam->state == S_IDLE) {
> +		cam->sequence = 0;
> +		ret = mcam_read_setup(cam, S_STREAMING);
>  	}
> +	return ret;
> +}
> +
> +static int mcam_vb_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> +	unsigned long flags;
> +
> +	if (cam->state != S_STREAMING)
> +		return -EINVAL;
> +	mcam_ctlr_stop_dma(cam);
>  	/*
> -	 * Give them their data and we should be done.
> +	 * VB2 reclaims the buffers, so we need to forget
> +	 * about them.
>  	 */
> -	ret = mcam_deliver_buffer(cam, buffer, len, pos);
> -
> -out_unlock:
> -	mutex_unlock(&cam->s_mutex);
> -	return ret;
> +	spin_lock_irqsave(&cam->dev_lock, flags);
> +	INIT_LIST_HEAD(&cam->buffers);
> +	spin_unlock_irqrestore(&cam->dev_lock, flags);
> +	return 0;
>  }
> 
> 
> +static const struct vb2_ops mcam_vb2_ops = {
> +	.queue_setup		= mcam_vb_queue_setup,
> +	.buf_init		= mcam_vb_buf_init,
> +	.buf_queue		= mcam_vb_buf_queue,
> +	.start_streaming	= mcam_vb_start_streaming,
> +	.stop_streaming		= mcam_vb_stop_streaming,
> +	.wait_prepare		= mcam_vb_wait_prepare,
> +	.wait_finish		= mcam_vb_wait_finish,
> +};
> 
> +static int mcam_setup_vb2(struct mcam_camera *cam)
> +{
> +	struct vb2_queue *vq = &cam->vb_queue;
> 
> +	memset(vq, 0, sizeof(*vq));
> +	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vq->io_modes = VB2_MMAP;  /* Add userptr */
> +	vq->drv_priv = cam;
> +	vq->ops = &mcam_vb2_ops;
> +	vq->mem_ops = &vb2_vmalloc_memops;
> +	vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
> 
> +	return vb2_queue_init(vq);
> +}
> +
> +static void mcam_cleanup_vb2(struct mcam_camera *cam)
> +{
> +	vb2_queue_release(&cam->vb_queue);
> +}
> +
> +static ssize_t mcam_v4l_read(struct file *filp,
> +		char __user *buffer, size_t len, loff_t *pos)
> +{
> +	struct mcam_camera *cam = filp->private_data;
> +	int ret;
> +
> +	mutex_lock(&cam->s_mutex);
> +	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
> +			filp->f_flags & O_NONBLOCK);
> +	mutex_unlock(&cam->s_mutex);
> +	return ret;
> +}
> 
> 
> 
> @@ -674,26 +717,15 @@ out_unlock:
>   * Streaming I/O support.
>   */
> 
> -
> -
>  static int mcam_vidioc_streamon(struct file *filp, void *priv,
>  		enum v4l2_buf_type type)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	int ret = -EINVAL;
> +	int ret;
> 
> -	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		goto out;
>  	mutex_lock(&cam->s_mutex);
> -	if (cam->state != S_IDLE || cam->n_sbufs == 0)
> -		goto out_unlock;
> -
> -	cam->sequence = 0;
> -	ret = mcam_read_setup(cam, S_STREAMING);
> -
> -out_unlock:
> +	ret = vb2_streamon(&cam->vb_queue, type);
>  	mutex_unlock(&cam->s_mutex);
> -out:
>  	return ret;
>  }
> 
> @@ -702,137 +734,23 @@ static int mcam_vidioc_streamoff(struct file *filp,
> void *priv,
>  		enum v4l2_buf_type type)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	int ret = -EINVAL;
> +	int ret;
> 
> -	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		goto out;
>  	mutex_lock(&cam->s_mutex);
> -	if (cam->state != S_STREAMING)
> -		goto out_unlock;
> -
> -	mcam_ctlr_stop_dma(cam);
> -	ret = 0;
> -
> -out_unlock:
> +	ret = vb2_streamoff(&cam->vb_queue, type);
>  	mutex_unlock(&cam->s_mutex);
> -out:
>  	return ret;
>  }
> 
> 
> -
> -static int mcam_setup_siobuf(struct mcam_camera *cam, int index)
> -{
> -	struct mcam_sio_buffer *buf = cam->sb_bufs + index;
> -
> -	INIT_LIST_HEAD(&buf->list);
> -	buf->v4lbuf.length = PAGE_ALIGN(cam->pix_format.sizeimage);
> -	buf->buffer = vmalloc_user(buf->v4lbuf.length);
> -	if (buf->buffer == NULL)
> -		return -ENOMEM;
> -	buf->mapcount = 0;
> -	buf->cam = cam;
> -
> -	buf->v4lbuf.index = index;
> -	buf->v4lbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	buf->v4lbuf.field = V4L2_FIELD_NONE;
> -	buf->v4lbuf.memory = V4L2_MEMORY_MMAP;
> -	/*
> -	 * Offset: must be 32-bit even on a 64-bit system.  videobuf-dma-sg
> -	 * just uses the length times the index, but the spec warns
> -	 * against doing just that - vma merging problems.  So we
> -	 * leave a gap between each pair of buffers.
> -	 */
> -	buf->v4lbuf.m.offset = 2*index*buf->v4lbuf.length;
> -	return 0;
> -}
> -
> -static int mcam_free_sio_buffers(struct mcam_camera *cam)
> -{
> -	int i;
> -
> -	/*
> -	 * If any buffers are mapped, we cannot free them at all.
> -	 */
> -	for (i = 0; i < cam->n_sbufs; i++)
> -		if (cam->sb_bufs[i].mapcount > 0)
> -			return -EBUSY;
> -	/*
> -	 * OK, let's do it.
> -	 */
> -	for (i = 0; i < cam->n_sbufs; i++)
> -		vfree(cam->sb_bufs[i].buffer);
> -	cam->n_sbufs = 0;
> -	kfree(cam->sb_bufs);
> -	cam->sb_bufs = NULL;
> -	INIT_LIST_HEAD(&cam->sb_avail);
> -	INIT_LIST_HEAD(&cam->sb_full);
> -	return 0;
> -}
> -
> -
> -
>  static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
>  		struct v4l2_requestbuffers *req)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	int ret = 0;  /* Silence warning */
> +	int ret;
> 
> -	/*
> -	 * Make sure it's something we can do.  User pointers could be
> -	 * implemented without great pain, but that's not been done yet.
> -	 */
> -	if (req->memory != V4L2_MEMORY_MMAP)
> -		return -EINVAL;
> -	/*
> -	 * If they ask for zero buffers, they really want us to stop
> streaming
> -	 * (if it's happening) and free everything.  Should we check owner?
> -	 */
>  	mutex_lock(&cam->s_mutex);
> -	if (req->count == 0) {
> -		if (cam->state == S_STREAMING)
> -			mcam_ctlr_stop_dma(cam);
> -		ret = mcam_free_sio_buffers(cam);
> -		goto out;
> -	}
> -	/*
> -	 * Device needs to be idle and working.  We *could* try to do the
> -	 * right thing in S_SPECREAD by shutting things down, but it
> -	 * probably doesn't matter.
> -	 */
> -	if (cam->state != S_IDLE || (cam->owner && cam->owner != filp)) {
> -		ret = -EBUSY;
> -		goto out;
> -	}
> -	cam->owner = filp;
> -
> -	if (req->count < min_buffers)
> -		req->count = min_buffers;
> -	else if (req->count > max_buffers)
> -		req->count = max_buffers;
> -	if (cam->n_sbufs > 0) {
> -		ret = mcam_free_sio_buffers(cam);
> -		if (ret)
> -			goto out;
> -	}
> -
> -	cam->sb_bufs = kzalloc(req->count*sizeof(struct mcam_sio_buffer),
> -			GFP_KERNEL);
> -	if (cam->sb_bufs == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	for (cam->n_sbufs = 0; cam->n_sbufs < req->count; (cam->n_sbufs++)) {
> -		ret = mcam_setup_siobuf(cam, cam->n_sbufs);
> -		if (ret)
> -			break;
> -	}
> -
> -	if (cam->n_sbufs == 0)  /* no luck at all - ret already set */
> -		kfree(cam->sb_bufs);
> -	req->count = cam->n_sbufs;  /* In case of partial success */
> -
> -out:
> +	ret = vb2_reqbufs(&cam->vb_queue, req);
>  	mutex_unlock(&cam->s_mutex);
>  	return ret;
>  }
> @@ -842,14 +760,10 @@ static int mcam_vidioc_querybuf(struct file *filp,
> void *priv,
>  		struct v4l2_buffer *buf)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	int ret = -EINVAL;
> +	int ret;
> 
>  	mutex_lock(&cam->s_mutex);
> -	if (buf->index >= cam->n_sbufs)
> -		goto out;
> -	*buf = cam->sb_bufs[buf->index].v4lbuf;
> -	ret = 0;
> -out:
> +	ret = vb2_querybuf(&cam->vb_queue, buf);
>  	mutex_unlock(&cam->s_mutex);
>  	return ret;
>  }
> @@ -858,29 +772,10 @@ static int mcam_vidioc_qbuf(struct file *filp, void
> *priv,
>  		struct v4l2_buffer *buf)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	struct mcam_sio_buffer *sbuf;
> -	int ret = -EINVAL;
> -	unsigned long flags;
> +	int ret;
> 
>  	mutex_lock(&cam->s_mutex);
> -	if (buf->index >= cam->n_sbufs)
> -		goto out;
> -	sbuf = cam->sb_bufs + buf->index;
> -	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_QUEUED) {
> -		ret = 0; /* Already queued?? */
> -		goto out;
> -	}
> -	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_DONE) {
> -		/* Spec doesn't say anything, seems appropriate tho */
> -		ret = -EBUSY;
> -		goto out;
> -	}
> -	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_QUEUED;
> -	spin_lock_irqsave(&cam->dev_lock, flags);
> -	list_add(&sbuf->list, &cam->sb_avail);
> -	spin_unlock_irqrestore(&cam->dev_lock, flags);
> -	ret = 0;
> -out:
> +	ret = vb2_qbuf(&cam->vb_queue, buf);
>  	mutex_unlock(&cam->s_mutex);
>  	return ret;
>  }
> @@ -889,111 +784,22 @@ static int mcam_vidioc_dqbuf(struct file *filp, void
> *priv,
>  		struct v4l2_buffer *buf)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	struct mcam_sio_buffer *sbuf;
> -	int ret = -EINVAL;
> -	unsigned long flags;
> +	int ret;
> 
>  	mutex_lock(&cam->s_mutex);
> -	if (cam->state != S_STREAMING)
> -		goto out_unlock;
> -	if (list_empty(&cam->sb_full) && filp->f_flags & O_NONBLOCK) {
> -		ret = -EAGAIN;
> -		goto out_unlock;
> -	}
> -
> -	while (list_empty(&cam->sb_full) && cam->state == S_STREAMING) {
> -		mutex_unlock(&cam->s_mutex);
> -		if (wait_event_interruptible(cam->iowait,
> -						!list_empty(&cam->sb_full))) {
> -			ret = -ERESTARTSYS;
> -			goto out;
> -		}
> -		mutex_lock(&cam->s_mutex);
> -	}
> -
> -	if (cam->state != S_STREAMING)
> -		ret = -EINTR;
> -	else {
> -		spin_lock_irqsave(&cam->dev_lock, flags);
> -		/* Should probably recheck !list_empty() here */
> -		sbuf = list_entry(cam->sb_full.next,
> -				struct mcam_sio_buffer, list);
> -		list_del_init(&sbuf->list);
> -		spin_unlock_irqrestore(&cam->dev_lock, flags);
> -		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_DONE;
> -		*buf = sbuf->v4lbuf;
> -		ret = 0;
> -	}
> -
> -out_unlock:
> +	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
>  	mutex_unlock(&cam->s_mutex);
> -out:
>  	return ret;
>  }
> 
> 
> -
> -static void mcam_v4l_vm_open(struct vm_area_struct *vma)
> -{
> -	struct mcam_sio_buffer *sbuf = vma->vm_private_data;
> -	/*
> -	 * Locking: done under mmap_sem, so we don't need to
> -	 * go back to the camera lock here.
> -	 */
> -	sbuf->mapcount++;
> -}
> -
> -
> -static void mcam_v4l_vm_close(struct vm_area_struct *vma)
> -{
> -	struct mcam_sio_buffer *sbuf = vma->vm_private_data;
> -
> -	mutex_lock(&sbuf->cam->s_mutex);
> -	sbuf->mapcount--;
> -	/* Docs say we should stop I/O too... */
> -	if (sbuf->mapcount == 0)
> -		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_MAPPED;
> -	mutex_unlock(&sbuf->cam->s_mutex);
> -}
> -
> -static const struct vm_operations_struct mcam_v4l_vm_ops = {
> -	.open = mcam_v4l_vm_open,
> -	.close = mcam_v4l_vm_close
> -};
> -
> -
>  static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> -	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> -	int ret = -EINVAL;
> -	int i;
> -	struct mcam_sio_buffer *sbuf = NULL;
> +	int ret;
> 
> -	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
> -		return -EINVAL;
> -	/*
> -	 * Find the buffer they are looking for.
> -	 */
>  	mutex_lock(&cam->s_mutex);
> -	for (i = 0; i < cam->n_sbufs; i++)
> -		if (cam->sb_bufs[i].v4lbuf.m.offset == offset) {
> -			sbuf = cam->sb_bufs + i;
> -			break;
> -		}
> -	if (sbuf == NULL)
> -		goto out;
> -
> -	ret = remap_vmalloc_range(vma, sbuf->buffer, 0);
> -	if (ret)
> -		goto out;
> -	vma->vm_flags |= VM_DONTEXPAND;
> -	vma->vm_private_data = sbuf;
> -	vma->vm_ops = &mcam_v4l_vm_ops;
> -	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_MAPPED;
> -	mcam_v4l_vm_open(vma);
> -	ret = 0;
> -out:
> +	ret = vb2_mmap(&cam->vb_queue, vma);
>  	mutex_unlock(&cam->s_mutex);
>  	return ret;
>  }
> @@ -1003,19 +809,23 @@ out:
>  static int mcam_v4l_open(struct file *filp)
>  {
>  	struct mcam_camera *cam = video_drvdata(filp);
> +	int ret = 0;
> 
>  	filp->private_data = cam;
> 
>  	mutex_lock(&cam->s_mutex);
>  	if (cam->users == 0) {
> +		ret = mcam_setup_vb2(cam);
> +		if (ret)
> +			goto out;
>  		mcam_ctlr_power_up(cam);
>  		__mcam_cam_reset(cam);
>  		mcam_set_config_needed(cam, 1);
> -	/* FIXME make sure this is complete */
>  	}
>  	(cam->users)++;
> +out:
>  	mutex_unlock(&cam->s_mutex);
> -	return 0;
> +	return ret;
>  }
> 
> 
> @@ -1027,10 +837,10 @@ static int mcam_v4l_release(struct file *filp)
>  	(cam->users)--;
>  	if (filp == cam->owner) {
>  		mcam_ctlr_stop_dma(cam);
> -		mcam_free_sio_buffers(cam);
>  		cam->owner = NULL;
>  	}
>  	if (cam->users == 0) {
> +		mcam_cleanup_vb2(cam);
>  		mcam_ctlr_power_down(cam);
>  		if (alloc_bufs_at_read)
>  			mcam_free_dma_bufs(cam);
> @@ -1045,11 +855,12 @@ static unsigned int mcam_v4l_poll(struct file *filp,
>  		struct poll_table_struct *pt)
>  {
>  	struct mcam_camera *cam = filp->private_data;
> +	int ret;
> 
> -	poll_wait(filp, &cam->iowait, pt);
> -	if (cam->next_buf >= 0)
> -		return POLLIN | POLLRDNORM;
> -	return 0;
> +	mutex_lock(&cam->s_mutex);
> +	ret = vb2_poll(&cam->vb_queue, filp, pt);
> +	mutex_unlock(&cam->s_mutex);
> +	return ret;
>  }
> 
> 
> @@ -1093,9 +904,6 @@ static int mcam_vidioc_s_ctrl(struct file *filp, void
> *priv,
>  }
> 
> 
> -
> -
> -
>  static int mcam_vidioc_querycap(struct file *file, void *priv,
>  		struct v4l2_capability *cap)
>  {
> @@ -1166,7 +974,7 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp,
> void *priv,
>  	 * Can't do anything if the device is not idle
>  	 * Also can't if there are streaming buffers in place.
>  	 */
> -	if (cam->state != S_IDLE || cam->n_sbufs > 0)
> +	if (cam->state != S_IDLE || cam->vb_queue.num_buffers > 0)
>  		return -EBUSY;
> 
>  	f = mcam_find_format(fmt->fmt.pix.pixelformat);
> @@ -1416,39 +1224,39 @@ static void mcam_frame_tasklet(unsigned long data)
>  	struct mcam_camera *cam = (struct mcam_camera *) data;
>  	int i;
>  	unsigned long flags;
> -	struct mcam_sio_buffer *sbuf;
> +	struct mcam_vb_buffer *buf;
> 
>  	spin_lock_irqsave(&cam->dev_lock, flags);
>  	for (i = 0; i < cam->nbufs; i++) {
>  		int bufno = cam->next_buf;
> -		if (bufno < 0) {  /* "will never happen" */
> -			cam_err(cam, "No valid bufs in tasklet!\n");
> -			break;
> -		}
> +
> +		if (cam->state != S_STREAMING || bufno < 0)
> +			break;  /* I/O got stopped */
>  		if (++(cam->next_buf) >= cam->nbufs)
>  			cam->next_buf = 0;
>  		if (!test_bit(bufno, &cam->flags))
>  			continue;
> -		if (list_empty(&cam->sb_avail))
> +		if (list_empty(&cam->buffers))
>  			break;  /* Leave it valid, hope for better later */
>  		clear_bit(bufno, &cam->flags);
> -		sbuf = list_entry(cam->sb_avail.next,
> -				struct mcam_sio_buffer, list);
> +		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
> +				queue);
> +		list_del_init(&buf->queue);
>  		/*
>  		 * Drop the lock during the big copy.  This *should* be safe...
>  		 */
>  		spin_unlock_irqrestore(&cam->dev_lock, flags);
> -		memcpy(sbuf->buffer, cam->dma_bufs[bufno],
> +		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
>  				cam->pix_format.sizeimage);
> -		sbuf->v4lbuf.bytesused = cam->pix_format.sizeimage;
> -		sbuf->v4lbuf.sequence = cam->buf_seq[bufno];
> -		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_QUEUED;
> -		sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_DONE;
> +		buf->vb_buf.v4l2_buf.bytesused = cam->pix_format.sizeimage;
> +		buf->vb_buf.v4l2_buf.sequence = cam->buf_seq[bufno];

> +		buf->vb_buf.v4l2_buf.flags &= ~V4L2_BUF_FLAG_QUEUED;
> +		buf->vb_buf.v4l2_buf.flags |= V4L2_BUF_FLAG_DONE;

These 2 lines should be dropped. vb2 takes care about V4L2 status flags
internally.

> +		vb2_set_plane_payload(&buf->vb_buf, 0,
> +				cam->pix_format.sizeimage);
> +		vb2_buffer_done(&buf->vb_buf, VB2_BUF_STATE_DONE);
>  		spin_lock_irqsave(&cam->dev_lock, flags);
> -		list_move_tail(&sbuf->list, &cam->sb_full);
>  	}
> -	if (!list_empty(&cam->sb_full))
> -		wake_up(&cam->iowait);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
>  }
> 
> @@ -1469,27 +1277,6 @@ static void mcam_frame_complete(struct mcam_camera
> *cam, int frame)
> 
>  	switch (cam->state) {
>  	/*
> -	 * If in single read mode, try going speculative.
> -	 */
> -	case S_SINGLEREAD:
> -		cam->state = S_SPECREAD;
> -		cam->specframes = 0;
> -		wake_up(&cam->iowait);
> -		break;
> -
> -	/*
> -	 * If we are already doing speculative reads, and nobody is
> -	 * reading them, just stop.
> -	 */
> -	case S_SPECREAD:
> -		if (++(cam->specframes) >= cam->nbufs) {
> -			mcam_ctlr_stop(cam);
> -			mcam_ctlr_irq_disable(cam);
> -			cam->state = S_IDLE;
> -		}
> -		wake_up(&cam->iowait);
> -		break;
> -	/*
>  	 * For the streaming case, we defer the real work to the
>  	 * camera tasklet.
>  	 *
> @@ -1570,12 +1357,10 @@ int mccic_register(struct mcam_camera *cam)
>  	mutex_init(&cam->s_mutex);
>  	cam->state = S_NOTREADY;
>  	mcam_set_config_needed(cam, 1);
> -	init_waitqueue_head(&cam->iowait);
>  	cam->pix_format = mcam_def_pix_format;
>  	cam->mbus_code = mcam_def_mbus_code;
>  	INIT_LIST_HEAD(&cam->dev_list);
> -	INIT_LIST_HEAD(&cam->sb_avail);
> -	INIT_LIST_HEAD(&cam->sb_full);
> +	INIT_LIST_HEAD(&cam->buffers);
>  	tasklet_init(&cam->s_tasklet, mcam_frame_tasklet, (unsigned long)
> cam);
> 
>  	mcam_ctlr_init(cam);
> @@ -1638,10 +1423,8 @@ void mccic_shutdown(struct mcam_camera *cam)
>  		cam_warn(cam, "Removing a device with users!\n");
>  		mcam_ctlr_power_down(cam);
>  	}
> +	vb2_queue_release(&cam->vb_queue);
>  	mcam_free_dma_bufs(cam);
> -	if (cam->n_sbufs > 0)
> -		/* What if they are still mapped?  Shouldn't be, but... */
> -		mcam_free_sio_buffers(cam);
>  	video_unregister_device(&cam->vdev);
>  	v4l2_device_unregister(&cam->v4l2_dev);
>  }
> @@ -1674,9 +1457,7 @@ int mccic_resume(struct mcam_camera *cam)
>  	mutex_unlock(&cam->s_mutex);
> 
>  	set_bit(CF_CONFIG_NEEDED, &cam->flags);
> -	if (cam->state == S_SPECREAD)
> -		cam->state = S_IDLE;  /* Don't bother restarting */
> -	else if (cam->state == S_SINGLEREAD || cam->state == S_STREAMING)
> +	if (cam->state == S_STREAMING)
>  		ret = mcam_read_setup(cam, cam->state);
>  	return ret;
>  }
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.h
> b/drivers/media/video/marvell-ccic/mcam-core.h
> index 5effa82..f40450c 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.h
> +++ b/drivers/media/video/marvell-ccic/mcam-core.h
> @@ -3,6 +3,13 @@
>   *
>   * Copyright 2011 Jonathan Corbet corbet@lwn.net
>   */
> +#ifndef _MCAM_CORE_H
> +#define _MCAM_CORE_H
> +
> +#include <linux/list.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-core.h>
> 
>  /*
>   * Tracking of streaming I/O buffers.
> @@ -20,8 +27,6 @@ enum mcam_state {
>  	S_NOTREADY,	/* Not yet initialized */
>  	S_IDLE,		/* Just hanging around */
>  	S_FLAKED,	/* Some sort of problem */
> -	S_SINGLEREAD,	/* In read() */
> -	S_SPECREAD,	/* Speculative read (for future read()) */
>  	S_STREAMING	/* Streaming data */
>  };
>  #define MAX_DMA_BUFS 3
> @@ -70,21 +75,19 @@ struct mcam_camera {
> 
>  	struct list_head dev_list;	/* link to other devices */
> 
> +	/* Videobuf2 stuff */
> +	struct vb2_queue vb_queue;
> +	struct list_head buffers;	/* Available frames */
> +
>  	/* DMA buffers */
>  	unsigned int nbufs;		/* How many are alloc'd */
>  	int next_buf;			/* Next to consume (dev_lock) */
>  	unsigned int dma_buf_size;	/* allocated size */
>  	void *dma_bufs[MAX_DMA_BUFS];	/* Internal buffer addresses */
>  	dma_addr_t dma_handles[MAX_DMA_BUFS]; /* Buffer bus addresses */
> -	unsigned int specframes;	/* Unconsumed spec frames (dev_lock) */
>  	unsigned int sequence;		/* Frame sequence number */
> -	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual
> buffers */
> +	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual bufs
> */
> 
> -	/* Streaming buffers */
> -	unsigned int n_sbufs;		/* How many we have */
> -	struct mcam_sio_buffer *sb_bufs; /* The array of housekeeping structs
> */
> -	struct list_head sb_avail;	/* Available for data (we own)
> (dev_lock) */
> -	struct list_head sb_full;	/* With data (user space owns)
> (dev_lock) */
>  	struct tasklet_struct s_tasklet;
> 
>  	/* Current operating parameters */
> @@ -94,9 +97,6 @@ struct mcam_camera {
> 
>  	/* Locks */
>  	struct mutex s_mutex; /* Access to this structure */
> -
> -	/* Misc */
> -	wait_queue_head_t iowait;	/* Waiting on frame data */
>  };
> 
> 
> @@ -257,3 +257,5 @@ int mccic_resume(struct mcam_camera *cam);
>   */
>  #define VGA_WIDTH	640
>  #define VGA_HEIGHT	480
> +
> +#endif /* _MCAM_CORE_H */
> --

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



