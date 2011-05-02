Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3648 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1EBTLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 15:11:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Mon, 2 May 2011 21:11:40 +0200
Cc: linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
In-Reply-To: <E1QGwlS-0006ys-15@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022111.40604.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

NACK.

For two reasons: first of all it is not signed off by Andy Walls, the cx18
maintainer. I know he has had other things on his plate recently which is
probably why he hasn't had the chance to review this.

Secondly, while doing a quick scan myself I noticed that this code does a
conversion from UYVY format to YUYV *in the driver*. Format conversion is
not allowed in the kernel, we have libv4lconvert for that. So at the minimum
this conversion code must be removed first.

Regards,

	Hans

On Monday, May 02, 2011 19:17:57 Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] cx18: mmap() support for raw YUV video capture
> Author:  Steven Toth <stoth@kernellabs.com>
> Date:    Wed Apr 6 08:32:56 2011 -0300
> 
> Add support for mmap method streaming of raw YUV video on cx18-based
> hardware, in addition to the existing support for read() streaming of
> raw YUV and MPEG-2 encoded video.
> 
> [simon.farnsworth@onelan.co.uk: I forward-ported this from Steven's original work,
>  done under contract to ONELAN. The original code is at
>  http://www.kernellabs.com/hg/~stoth/cx18-videobuf]
> 
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/cx18/Kconfig        |    2 +
>  drivers/media/video/cx18/cx18-driver.h  |   25 ++++
>  drivers/media/video/cx18/cx18-fileops.c |  214 +++++++++++++++++++++++++++++++
>  drivers/media/video/cx18/cx18-fileops.h |    2 +
>  drivers/media/video/cx18/cx18-ioctl.c   |  136 ++++++++++++++++++--
>  drivers/media/video/cx18/cx18-mailbox.c |   70 ++++++++++
>  drivers/media/video/cx18/cx18-streams.c |   23 ++++
>  drivers/media/video/cx18/cx23418.h      |    6 +
>  8 files changed, 466 insertions(+), 12 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=fa8f1381764d83222333cb67b8d93b9cb1605bf3
> 
> diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
> index d788ad6..9c23202 100644
> --- a/drivers/media/video/cx18/Kconfig
> +++ b/drivers/media/video/cx18/Kconfig
> @@ -2,6 +2,8 @@ config VIDEO_CX18
>  	tristate "Conexant cx23418 MPEG encoder support"
>  	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
>  	select I2C_ALGOBIT
> +	select VIDEOBUF_DVB
> +	select VIDEOBUF_VMALLOC
>  	depends on RC_CORE
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
> diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
> index b86a740..70e1e04 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -65,6 +65,10 @@
>  #include "dvb_net.h"
>  #include "dvbdev.h"
>  
> +/* Videobuf / YUV support */
> +#include <media/videobuf-core.h>
> +#include <media/videobuf-vmalloc.h>
> +
>  #ifndef CONFIG_PCI
>  #  error "This driver requires kernel PCI support."
>  #endif
> @@ -403,6 +407,23 @@ struct cx18_stream {
>  	struct cx18_queue q_idle;	/* idle - not in rotation */
>  
>  	struct work_struct out_work_order;
> +
> +	/* Videobuf for YUV video */
> +	u32 pixelformat;
> +	struct list_head vb_capture;    /* video capture queue */
> +	spinlock_t vb_lock;
> +	struct v4l2_framebuffer fbuf;
> +	v4l2_std_id tvnorm; /* selected tv norm */
> +	struct timer_list vb_timeout;
> +	int vbwidth;
> +	int vbheight;
> +};
> +
> +struct cx18_videobuf_buffer {
> +	/* Common video buffer sub-system struct */
> +	struct videobuf_buffer vb;
> +	v4l2_std_id tvnorm; /* selected tv norm */
> +	u32 bytes_used;
>  };
>  
>  struct cx18_open_id {
> @@ -410,6 +431,10 @@ struct cx18_open_id {
>  	u32 open_id;
>  	int type;
>  	struct cx18 *cx;
> +
> +	struct videobuf_queue vbuf_q;
> +	spinlock_t s_lock; /* Protect vbuf_q */
> +	enum v4l2_buf_type vb_type;
>  };
>  
>  static inline struct cx18_open_id *fh2id(struct v4l2_fh *fh)
> diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
> index e9802d9..c74eafd 100644
> --- a/drivers/media/video/cx18/cx18-fileops.c
> +++ b/drivers/media/video/cx18/cx18-fileops.c
> @@ -597,6 +597,13 @@ ssize_t cx18_v4l2_read(struct file *filp, char __user *buf, size_t count,
>  	mutex_unlock(&cx->serialize_lock);
>  	if (rc)
>  		return rc;
> +
> +	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
> +		return videobuf_read_stream(&id->vbuf_q, buf, count, pos, 0,
> +			filp->f_flags & O_NONBLOCK);
> +	}
> +
>  	return cx18_read_pos(s, buf, count, pos, filp->f_flags & O_NONBLOCK);
>  }
>  
> @@ -622,6 +629,11 @@ unsigned int cx18_v4l2_enc_poll(struct file *filp, poll_table *wait)
>  		CX18_DEBUG_FILE("Encoder poll started capture\n");
>  	}
>  
> +	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
> +		return videobuf_poll_stream(filp, &id->vbuf_q, wait);
> +	}
> +
>  	/* add stream's waitq to the poll list */
>  	CX18_DEBUG_HI_FILE("Encoder poll\n");
>  	poll_wait(filp, &s->waitq, wait);
> @@ -633,6 +645,58 @@ unsigned int cx18_v4l2_enc_poll(struct file *filp, poll_table *wait)
>  	return 0;
>  }
>  
> +int cx18_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +	int eof = test_bit(CX18_F_S_STREAMOFF, &s->s_flags);
> +
> +	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
> +
> +		/* Start a capture if there is none */
> +		if (!eof && !test_bit(CX18_F_S_STREAMING, &s->s_flags)) {
> +			int rc;
> +
> +			mutex_lock(&cx->serialize_lock);
> +			rc = cx18_start_capture(id);
> +			mutex_unlock(&cx->serialize_lock);
> +			if (rc) {
> +				CX18_DEBUG_INFO(
> +					"Could not start capture for %s (%d)\n",
> +					s->name, rc);
> +				return -EINVAL;
> +			}
> +			CX18_DEBUG_FILE("Encoder poll started capture\n");
> +		}
> +
> +		return videobuf_mmap_mapper(&id->vbuf_q, vma);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +void cx18_vb_timeout(unsigned long data)
> +{
> +	struct cx18_stream *s = (struct cx18_stream *)data;
> +	struct cx18_videobuf_buffer *buf;
> +	unsigned long flags;
> +
> +	/* Return all of the buffers in error state, so the vbi/vid inode
> +	 * can return from blocking.
> +	 */
> +	spin_lock_irqsave(&s->vb_lock, flags);
> +	while (!list_empty(&s->vb_capture)) {
> +		buf = list_entry(s->vb_capture.next,
> +			struct cx18_videobuf_buffer, vb.queue);
> +		list_del(&buf->vb.queue);
> +		buf->vb.state = VIDEOBUF_ERROR;
> +		wake_up(&buf->vb.done);
> +	}
> +	spin_unlock_irqrestore(&s->vb_lock, flags);
> +}
> +
>  void cx18_stop_capture(struct cx18_open_id *id, int gop_end)
>  {
>  	struct cx18 *cx = id->cx;
> @@ -716,12 +780,150 @@ int cx18_v4l2_close(struct file *filp)
>  		cx18_release_stream(s);
>  	} else {
>  		cx18_stop_capture(id, 0);
> +		if (id->type == CX18_ENC_STREAM_TYPE_YUV)
> +			videobuf_mmap_free(&id->vbuf_q);
>  	}
>  	kfree(id);
>  	mutex_unlock(&cx->serialize_lock);
>  	return 0;
>  }
>  
> +void cx18_dma_free(struct videobuf_queue *q,
> +	struct cx18_stream *s, struct cx18_videobuf_buffer *buf)
> +{
> +	videobuf_waiton(q, &buf->vb, 0, 0);
> +	videobuf_vmalloc_free(&buf->vb);
> +	buf->vb.state = VIDEOBUF_NEEDS_INIT;
> +}
> +
> +static int cx18_prepare_buffer(struct videobuf_queue *q,
> +	struct cx18_stream *s,
> +	struct cx18_videobuf_buffer *buf,
> +	u32 pixelformat,
> +	unsigned int width, unsigned int height,
> +	enum v4l2_field field)
> +{
> +	int rc = 0;
> +
> +	/* check settings */
> +	buf->bytes_used = 0;
> +
> +	if ((width  < 48) || (height < 32))
> +		return -EINVAL;
> +
> +	buf->vb.size = (width * height * 16 /*fmt->depth*/) >> 3;
> +	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
> +		return -EINVAL;
> +
> +	/* alloc + fill struct (if changed) */
> +	if (buf->vb.width != width || buf->vb.height != height ||
> +	    buf->vb.field != field || s->pixelformat != pixelformat ||
> +	    buf->tvnorm != s->tvnorm) {
> +
> +		buf->vb.width  = width;
> +		buf->vb.height = height;
> +		buf->vb.field  = field;
> +		buf->tvnorm    = s->tvnorm;
> +		s->pixelformat = pixelformat;
> +
> +		cx18_dma_free(q, s, buf);
> +	}
> +
> +	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
> +		return -EINVAL;
> +
> +	if (buf->vb.field == 0)
> +		buf->vb.field = V4L2_FIELD_INTERLACED;
> +
> +	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> +		buf->vb.width  = width;
> +		buf->vb.height = height;
> +		buf->vb.field  = field;
> +		buf->tvnorm    = s->tvnorm;
> +		s->pixelformat = pixelformat;
> +
> +		rc = videobuf_iolock(q, &buf->vb, &s->fbuf);
> +		if (rc != 0)
> +			goto fail;
> +	}
> +	buf->vb.state = VIDEOBUF_PREPARED;
> +	return 0;
> +
> +fail:
> +	cx18_dma_free(q, s, buf);
> +	return rc;
> +
> +}
> +
> +#define VB_MIN_BUFFERS 32
> +#define VB_MIN_BUFSIZE 0x208000
> +
> +static int buffer_setup(struct videobuf_queue *q,
> +	unsigned int *count, unsigned int *size)
> +{
> +	struct cx18_open_id *id = q->priv_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +
> +	*size = 2 * s->vbwidth * s->vbheight;
> +	if (*count == 0)
> +		*count = VB_MIN_BUFFERS;
> +
> +	while (*size * *count > VB_MIN_BUFFERS * VB_MIN_BUFSIZE)
> +		(*count)--;
> +
> +	q->field = V4L2_FIELD_INTERLACED;
> +	q->last = V4L2_FIELD_INTERLACED;
> +
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct videobuf_queue *q,
> +	struct videobuf_buffer *vb,
> +	enum v4l2_field field)
> +{
> +	struct cx18_videobuf_buffer *buf =
> +		container_of(vb, struct cx18_videobuf_buffer, vb);
> +	struct cx18_open_id *id = q->priv_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +
> +	return cx18_prepare_buffer(q, s, buf, s->pixelformat,
> +		s->vbwidth, s->vbheight, field);
> +}
> +
> +static void buffer_release(struct videobuf_queue *q,
> +	struct videobuf_buffer *vb)
> +{
> +	struct cx18_videobuf_buffer *buf =
> +		container_of(vb, struct cx18_videobuf_buffer, vb);
> +	struct cx18_open_id *id = q->priv_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +
> +	cx18_dma_free(q, s, buf);
> +}
> +
> +static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
> +{
> +	struct cx18_videobuf_buffer *buf =
> +		container_of(vb, struct cx18_videobuf_buffer, vb);
> +	struct cx18_open_id *id = q->priv_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +
> +	buf->vb.state = VIDEOBUF_QUEUED;
> +
> +	list_add_tail(&buf->vb.queue, &s->vb_capture);
> +}
> +
> +static struct videobuf_queue_ops cx18_videobuf_qops = {
> +	.buf_setup    = buffer_setup,
> +	.buf_prepare  = buffer_prepare,
> +	.buf_queue    = buffer_queue,
> +	.buf_release  = buffer_release,
> +};
> +
>  static int cx18_serialized_open(struct cx18_stream *s, struct file *filp)
>  {
>  	struct cx18 *cx = s->cx;
> @@ -740,6 +942,9 @@ static int cx18_serialized_open(struct cx18_stream *s, struct file *filp)
>  	item->cx = cx;
>  	item->type = s->type;
>  
> +	spin_lock_init(&item->s_lock);
> +	item->vb_type = 0;
> +
>  	item->open_id = cx->open_id++;
>  	filp->private_data = &item->fh;
>  
> @@ -774,6 +979,15 @@ static int cx18_serialized_open(struct cx18_stream *s, struct file *filp)
>  		/* Done! Unmute and continue. */
>  		cx18_unmute(cx);
>  	}
> +	if (item->type == CX18_ENC_STREAM_TYPE_YUV) {
> +		item->vb_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		videobuf_queue_vmalloc_init(&item->vbuf_q, &cx18_videobuf_qops,
> +			&cx->pci_dev->dev, &item->s_lock,
> +			V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +			V4L2_FIELD_INTERLACED,
> +			sizeof(struct cx18_videobuf_buffer),
> +			item, &cx->serialize_lock);
> +	}
>  	v4l2_fh_add(&item->fh);
>  	return 0;
>  }
> diff --git a/drivers/media/video/cx18/cx18-fileops.h b/drivers/media/video/cx18/cx18-fileops.h
> index 5c8fcb8..b9e5110 100644
> --- a/drivers/media/video/cx18/cx18-fileops.h
> +++ b/drivers/media/video/cx18/cx18-fileops.h
> @@ -33,6 +33,8 @@ int cx18_start_capture(struct cx18_open_id *id);
>  void cx18_stop_capture(struct cx18_open_id *id, int gop_end);
>  void cx18_mute(struct cx18 *cx);
>  void cx18_unmute(struct cx18 *cx);
> +int cx18_v4l2_mmap(struct file *file, struct vm_area_struct *vma);
> +void cx18_vb_timeout(unsigned long data);
>  
>  /* Shared with cx18-alsa module */
>  int cx18_claim_stream(struct cx18_open_id *id, int type);
> diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
> index 4f041c0..777d726 100644
> --- a/drivers/media/video/cx18/cx18-ioctl.c
> +++ b/drivers/media/video/cx18/cx18-ioctl.c
> @@ -41,6 +41,18 @@
>  #include <media/tveeprom.h>
>  #include <media/v4l2-chip-ident.h>
>  
> +static struct v4l2_fmtdesc formats[] = {
> +	{ 0, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
> +	  "HM12 (YUV 4:1:1)", V4L2_PIX_FMT_HM12, { 0, 0, 0, 0 }
> +	},
> +	{ 1, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FMT_FLAG_COMPRESSED,
> +	  "MPEG", V4L2_PIX_FMT_MPEG, { 0, 0, 0, 0 }
> +	},
> +	{ 2, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
> +	  "YUYV 4:2:2", V4L2_PIX_FMT_YUYV, { 0, 0, 0, 0 }
> +	},
> +};
> +
>  u16 cx18_service2vbi(int type)
>  {
>  	switch (type) {
> @@ -150,6 +162,7 @@ static int cx18_g_fmt_vid_cap(struct file *file, void *fh,
>  {
>  	struct cx18_open_id *id = fh2id(fh);
>  	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
>  	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
>  
>  	pixfmt->width = cx->cxhdl.width;
> @@ -158,7 +171,7 @@ static int cx18_g_fmt_vid_cap(struct file *file, void *fh,
>  	pixfmt->field = V4L2_FIELD_INTERLACED;
>  	pixfmt->priv = 0;
>  	if (id->type == CX18_ENC_STREAM_TYPE_YUV) {
> -		pixfmt->pixelformat = V4L2_PIX_FMT_HM12;
> +		pixfmt->pixelformat = s->pixelformat;
>  		/* YUV size is (Y=(h*720) + UV=(h*(720/2))) */
>  		pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
>  		pixfmt->bytesperline = 720;
> @@ -237,7 +250,6 @@ static int cx18_try_fmt_vid_cap(struct file *file, void *fh,
>  	h = min(h, cx->is_50hz ? 576 : 480);
>  	h = max(h, min_h);
>  
> -	cx18_g_fmt_vid_cap(file, fh, fmt);
>  	fmt->fmt.pix.width = w;
>  	fmt->fmt.pix.height = h;
>  	return 0;
> @@ -274,6 +286,7 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
>  	struct cx18_open_id *id = fh2id(fh);
>  	struct cx18 *cx = id->cx;
>  	struct v4l2_mbus_framefmt mbus_fmt;
> +	struct cx18_stream *s = &cx->streams[id->type];
>  	int ret;
>  	int w, h;
>  
> @@ -283,6 +296,10 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
>  	w = fmt->fmt.pix.width;
>  	h = fmt->fmt.pix.height;
>  
> +	s->pixelformat = fmt->fmt.pix.pixelformat;
> +	s->vbheight = h;
> +	s->vbwidth = w;
> +
>  	if (cx->cxhdl.width == w && cx->cxhdl.height == h)
>  		return 0;
>  
> @@ -540,16 +557,7 @@ static int cx18_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
>  static int cx18_enum_fmt_vid_cap(struct file *file, void *fh,
>  					struct v4l2_fmtdesc *fmt)
>  {
> -	static struct v4l2_fmtdesc formats[] = {
> -		{ 0, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
> -		  "HM12 (YUV 4:1:1)", V4L2_PIX_FMT_HM12, { 0, 0, 0, 0 }
> -		},
> -		{ 1, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FMT_FLAG_COMPRESSED,
> -		  "MPEG", V4L2_PIX_FMT_MPEG, { 0, 0, 0, 0 }
> -		}
> -	};
> -
> -	if (fmt->index > 1)
> +	if (fmt->index > ARRAY_SIZE(formats) - 1)
>  		return -EINVAL;
>  	*fmt = formats[fmt->index];
>  	return 0;
> @@ -863,6 +871,104 @@ static int cx18_g_enc_index(struct file *file, void *fh,
>  	return 0;
>  }
>  
> +static struct videobuf_queue *cx18_vb_queue(struct cx18_open_id *id)
> +{
> +	struct videobuf_queue *q = NULL;
> +
> +	switch (id->vb_type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		q = &id->vbuf_q;
> +		break;
> +	case V4L2_BUF_TYPE_VBI_CAPTURE:
> +		break;
> +	default:
> +		break;
> +	}
> +	return q;
> +}
> +
> +static int cx18_streamon(struct file *file, void *priv,
> +	enum v4l2_buf_type type)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +	struct cx18 *cx = id->cx;
> +	struct cx18_stream *s = &cx->streams[id->type];
> +
> +	/* Start the hardware only if we're the video device */
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	if (id->type != CX18_ENC_STREAM_TYPE_YUV)
> +		return -EINVAL;
> +
> +	/* Establish a buffer timeout */
> +	mod_timer(&s->vb_timeout, jiffies + (HZ * 2));
> +
> +	return videobuf_streamon(cx18_vb_queue(id));
> +}
> +
> +static int cx18_streamoff(struct file *file, void *priv,
> +	enum v4l2_buf_type type)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +
> +	/* Start the hardware only if we're the video device */
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	if (id->type != CX18_ENC_STREAM_TYPE_YUV)
> +		return -EINVAL;
> +
> +	return videobuf_streamoff(cx18_vb_queue(id));
> +}
> +
> +static int cx18_reqbufs(struct file *file, void *priv,
> +	struct v4l2_requestbuffers *rb)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	return videobuf_reqbufs(cx18_vb_queue(id), rb);
> +}
> +
> +static int cx18_querybuf(struct file *file, void *priv,
> +	struct v4l2_buffer *b)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	return videobuf_querybuf(cx18_vb_queue(id), b);
> +}
> +
> +static int cx18_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	return videobuf_qbuf(cx18_vb_queue(id), b);
> +}
> +
> +static int cx18_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
> +{
> +	struct cx18_open_id *id = file->private_data;
> +	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> +		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
> +		return -EINVAL;
> +
> +	return videobuf_dqbuf(cx18_vb_queue(id), b, file->f_flags & O_NONBLOCK);
> +}
> +
>  static int cx18_encoder_cmd(struct file *file, void *fh,
>  				struct v4l2_encoder_cmd *enc)
>  {
> @@ -1081,6 +1187,12 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
>  	.vidioc_s_register              = cx18_s_register,
>  #endif
>  	.vidioc_default                 = cx18_default,
> +	.vidioc_streamon                = cx18_streamon,
> +	.vidioc_streamoff               = cx18_streamoff,
> +	.vidioc_reqbufs                 = cx18_reqbufs,
> +	.vidioc_querybuf                = cx18_querybuf,
> +	.vidioc_qbuf                    = cx18_qbuf,
> +	.vidioc_dqbuf                   = cx18_dqbuf,
>  };
>  
>  void cx18_set_funcs(struct video_device *vdev)
> diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
> index 9605d54..d4d8873 100644
> --- a/drivers/media/video/cx18/cx18-mailbox.c
> +++ b/drivers/media/video/cx18/cx18-mailbox.c
> @@ -81,6 +81,7 @@ static const struct cx18_api_info api_info[] = {
>  	API_ENTRY(CPU, CX18_CPU_SET_SLICED_VBI_PARAM,           0),
>  	API_ENTRY(CPU, CX18_CPU_SET_USERDATA_PLACE_HOLDER,      0),
>  	API_ENTRY(CPU, CX18_CPU_GET_ENC_PTS,                    0),
> +	API_ENTRY(CPU, CX18_CPU_SET_VFC_PARAM,                  0),
>  	API_ENTRY(CPU, CX18_CPU_DE_SET_MDL_ACK,			0),
>  	API_ENTRY(CPU, CX18_CPU_DE_SET_MDL,			API_FAST),
>  	API_ENTRY(CPU, CX18_CPU_DE_RELEASE_MDL,			API_SLOW),
> @@ -158,6 +159,72 @@ static void cx18_mdl_send_to_dvb(struct cx18_stream *s, struct cx18_mdl *mdl)
>  	}
>  }
>  
> +static void cx18_mdl_send_to_videobuf(struct cx18_stream *s,
> +	struct cx18_mdl *mdl)
> +{
> +	struct cx18_videobuf_buffer *vb_buf;
> +	struct cx18_buffer *buf;
> +	u8 *p, u;
> +	u32 offset = 0;
> +	int dispatch = 0;
> +	int i;
> +
> +	if (mdl->bytesused == 0)
> +		return;
> +
> +	/* Acquire a videobuf buffer, clone to and and release it */
> +	spin_lock(&s->vb_lock);
> +	if (list_empty(&s->vb_capture))
> +		goto out;
> +
> +	vb_buf = list_entry(s->vb_capture.next, struct cx18_videobuf_buffer,
> +		vb.queue);
> +
> +	p = videobuf_to_vmalloc(&vb_buf->vb);
> +	if (!p)
> +		goto out;
> +
> +	offset = vb_buf->bytes_used;
> +	list_for_each_entry(buf, &mdl->buf_list, list) {
> +		if (buf->bytesused == 0)
> +			break;
> +
> +		if ((offset + buf->bytesused) <= vb_buf->vb.bsize) {
> +			memcpy(p + offset, buf->buf, buf->bytesused);
> +			offset += buf->bytesused;
> +			vb_buf->bytes_used += buf->bytesused;
> +		}
> +	}
> +
> +	/* If we've filled the buffer as per the callers res then dispatch it */
> +	if (vb_buf->bytes_used >= (vb_buf->vb.width * vb_buf->vb.height * 2)) {
> +		dispatch = 1;
> +		vb_buf->bytes_used = 0;
> +	}
> +
> +	/* */
> +	if (dispatch) {
> +
> +		if (s->pixelformat == V4L2_PIX_FMT_YUYV) {
> +			/* UYVY to YUYV */
> +			for (i = 0; i < (720 * 480 * 2); i += 2) {
> +				u = *(p + i);
> +				*(p + i) = *(p + i + 1);
> +				*(p + i + 1) = u;
> +			}
> +		}
> +
> +		do_gettimeofday(&vb_buf->vb.ts);
> +		list_del(&vb_buf->vb.queue);
> +		vb_buf->vb.state = VIDEOBUF_DONE;
> +		wake_up(&vb_buf->vb.done);
> +	}
> +
> +	mod_timer(&s->vb_timeout, jiffies + (HZ / 10));
> +
> +out:
> +	spin_unlock(&s->vb_lock);
> +}
>  
>  static void cx18_mdl_send_to_alsa(struct cx18 *cx, struct cx18_stream *s,
>  				  struct cx18_mdl *mdl)
> @@ -263,6 +330,9 @@ static void epu_dma_done(struct cx18 *cx, struct cx18_in_work_order *order)
>  			} else {
>  				cx18_enqueue(s, mdl, &s->q_full);
>  			}
> +		} else if (s->type == CX18_ENC_STREAM_TYPE_YUV) {
> +			cx18_mdl_send_to_videobuf(s, mdl);
> +			cx18_enqueue(s, mdl, &s->q_free);
>  		} else {
>  			cx18_enqueue(s, mdl, &s->q_full);
>  			if (s->type == CX18_ENC_STREAM_TYPE_IDX)
> diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
> index c6e2ca3..53f5e4f 100644
> --- a/drivers/media/video/cx18/cx18-streams.c
> +++ b/drivers/media/video/cx18/cx18-streams.c
> @@ -44,6 +44,7 @@ static struct v4l2_file_operations cx18_v4l2_enc_fops = {
>  	.unlocked_ioctl = cx18_v4l2_ioctl,
>  	.release = cx18_v4l2_close,
>  	.poll = cx18_v4l2_enc_poll,
> +	.mmap = cx18_v4l2_mmap,
>  };
>  
>  /* offset from 0 to register ts v4l2 minors on */
> @@ -132,6 +133,15 @@ static void cx18_stream_init(struct cx18 *cx, int type)
>  	cx18_queue_init(&s->q_idle);
>  
>  	INIT_WORK(&s->out_work_order, cx18_out_work_handler);
> +
> +	INIT_LIST_HEAD(&s->vb_capture);
> +	s->vb_timeout.function = cx18_vb_timeout;
> +	s->vb_timeout.data = (unsigned long)s;
> +	init_timer(&s->vb_timeout);
> +	spin_lock_init(&s->vb_lock);
> +
> +	/* Assume the previous pixel default */
> +	s->pixelformat = V4L2_PIX_FMT_HM12;
>  }
>  
>  static int cx18_prep_dev(struct cx18 *cx, int type)
> @@ -721,6 +731,19 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
>  		    test_bit(CX18_F_I_RADIO_USER, &cx->i_flags))
>  			cx18_vapi(cx, CX18_CPU_SET_VIDEO_MUTE, 2, s->handle,
>  			  (v4l2_ctrl_g_ctrl(cx->cxhdl.video_mute_yuv) << 8) | 1);
> +
> +		/* Enable the Video Format Converter for UYVY 4:2:2 support,
> +		 * rather than the default HM12 Macroblovk 4:2:0 support.
> +		 */
> +		if (captype == CAPTURE_CHANNEL_TYPE_YUV) {
> +			if (s->pixelformat == V4L2_PIX_FMT_YUYV)
> +				cx18_vapi(cx, CX18_CPU_SET_VFC_PARAM, 2,
> +					s->handle, 1);
> +			else
> +				/* If in doubt, default to HM12 */
> +				cx18_vapi(cx, CX18_CPU_SET_VFC_PARAM, 2,
> +					s->handle, 0);
> +		}
>  	}
>  
>  	if (atomic_read(&cx->tot_capturing) == 0) {
> diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
> index 935f557..767a8d2 100644
> --- a/drivers/media/video/cx18/cx23418.h
> +++ b/drivers/media/video/cx18/cx23418.h
> @@ -342,6 +342,12 @@
>     ReturnCode */
>  #define CX18_CPU_GET_ENC_PTS			(CPU_CMD_MASK_CAPTURE | 0x0022)
>  
> +/* Description: Set VFC parameters
> +   IN[0] - task handle
> +   IN[1] - VFC enable flag, 1 - enable, 0 - disable
> +*/
> +#define CX18_CPU_SET_VFC_PARAM                  (CPU_CMD_MASK_CAPTURE | 0x0023)
> +
>  /* Below is the list of commands related to the data exchange */
>  #define CPU_CMD_MASK_DE 			(CPU_CMD_MASK | 0x040000)
>  
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 
> 
