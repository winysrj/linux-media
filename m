Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1ECXCC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 19:02:02 -0400
Message-ID: <4DC08961.3060508@redhat.com>
Date: Tue, 03 May 2011 20:01:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
References: <4DBFDF71.5090705@redhat.com> <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk> <b418b252-4152-4666-9c83-85e91613b493@email.android.com>
In-Reply-To: <b418b252-4152-4666-9c83-85e91613b493@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-05-2011 19:51, Andy Walls escreveu:
> Simon Farnsworth <simon.farnsworth@onelan.co.uk> wrote:
> 
>> The initial version of this patch (commit
>> d5976931639176bb6777755d96b9f8d959f79e9e) had some issues:
>>
>> * It didn't correctly calculate the size of the YUV buffer for 4:2:2,
>>   resulting in capture sometimes being offset by 1/3rd of a picture.
>>
>> * There were a lot of variables duplicating information the driver
>>   already knew, which have been removed.
>>
>> * There was an in-kernel format conversion - libv4l can do this one,
>>   and is the right place to do format conversions anyway.
>>
>> * Some magic numbers weren't properly explained.
>>
>> Fix all these issues, leaving just the move from videobuf to videobuf2
>> to do.
>>
>> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
>> ---
>> drivers/media/video/cx18/Kconfig        |    1 -
>> drivers/media/video/cx18/cx18-driver.h  |    8 +-
>> drivers/media/video/cx18/cx18-fileops.c |  167
>> +++----------------------------
>> drivers/media/video/cx18/cx18-ioctl.c   |   84 +++++++++------
>> drivers/media/video/cx18/cx18-mailbox.c |   17 +---
>> drivers/media/video/cx18/cx18-streams.c |  160
>> ++++++++++++++++++++++++++++-
>> 6 files changed, 225 insertions(+), 212 deletions(-)
>>
>> diff --git a/drivers/media/video/cx18/Kconfig
>> b/drivers/media/video/cx18/Kconfig
>> index 9c23202..53b3c77 100644
>> --- a/drivers/media/video/cx18/Kconfig
>> +++ b/drivers/media/video/cx18/Kconfig
>> @@ -2,7 +2,6 @@ config VIDEO_CX18
>> 	tristate "Conexant cx23418 MPEG encoder support"
>> 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
>> 	select I2C_ALGOBIT
>> -	select VIDEOBUF_DVB
>> 	select VIDEOBUF_VMALLOC
>> 	depends on RC_CORE
>> 	select VIDEO_TUNER
>> diff --git a/drivers/media/video/cx18/cx18-driver.h
>> b/drivers/media/video/cx18/cx18-driver.h
>> index 70e1e04..0864272 100644
>> --- a/drivers/media/video/cx18/cx18-driver.h
>> +++ b/drivers/media/video/cx18/cx18-driver.h
>> @@ -412,11 +412,11 @@ struct cx18_stream {
>> 	u32 pixelformat;
>> 	struct list_head vb_capture;    /* video capture queue */
>> 	spinlock_t vb_lock;
>> -	struct v4l2_framebuffer fbuf;
>> -	v4l2_std_id tvnorm; /* selected tv norm */
>> 	struct timer_list vb_timeout;
>> -	int vbwidth;
>> -	int vbheight;
>> +
>> +	struct videobuf_queue vbuf_q;
>> +	spinlock_t vbuf_q_lock; /* Protect vbuf_q */
>> +	enum v4l2_buf_type vb_type;
>> };
>>
>> struct cx18_videobuf_buffer {
>> diff --git a/drivers/media/video/cx18/cx18-fileops.c
>> b/drivers/media/video/cx18/cx18-fileops.c
>> index c74eafd..6609222 100644
>> --- a/drivers/media/video/cx18/cx18-fileops.c
>> +++ b/drivers/media/video/cx18/cx18-fileops.c
>> @@ -598,9 +598,9 @@ ssize_t cx18_v4l2_read(struct file *filp, char
>> __user *buf, size_t count,
>> 	if (rc)
>> 		return rc;
>>
>> -	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +	if ((s->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> 		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
>> -		return videobuf_read_stream(&id->vbuf_q, buf, count, pos, 0,
>> +		return videobuf_read_stream(&s->vbuf_q, buf, count, pos, 0,
>> 			filp->f_flags & O_NONBLOCK);
>> 	}
>>
>> @@ -629,9 +629,13 @@ unsigned int cx18_v4l2_enc_poll(struct file *filp,
>> poll_table *wait)
>> 		CX18_DEBUG_FILE("Encoder poll started capture\n");
>> 	}
>>
>> -	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +	if ((s->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> 		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
>> -		return videobuf_poll_stream(filp, &id->vbuf_q, wait);
>> +		int videobuf_poll = videobuf_poll_stream(filp, &s->vbuf_q, wait);
>> +                if (eof && videobuf_poll == POLLERR)
>> +                        return POLLHUP;
>> +                else
>> +                        return videobuf_poll;
>> 	}
>>
>> 	/* add stream's waitq to the poll list */
>> @@ -652,7 +656,7 @@ int cx18_v4l2_mmap(struct file *file, struct
>> vm_area_struct *vma)
>> 	struct cx18_stream *s = &cx->streams[id->type];
>> 	int eof = test_bit(CX18_F_S_STREAMOFF, &s->s_flags);
>>
>> -	if ((id->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +	if ((s->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> 		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
>>
>> 		/* Start a capture if there is none */
>> @@ -668,10 +672,10 @@ int cx18_v4l2_mmap(struct file *file, struct
>> vm_area_struct *vma)
>> 					s->name, rc);
>> 				return -EINVAL;
>> 			}
>> -			CX18_DEBUG_FILE("Encoder poll started capture\n");
>> +			CX18_DEBUG_FILE("Encoder mmap started capture\n");
>> 		}
>>
>> -		return videobuf_mmap_mapper(&id->vbuf_q, vma);
>> +		return videobuf_mmap_mapper(&s->vbuf_q, vma);
>> 	}
>>
>> 	return -EINVAL;
>> @@ -788,142 +792,6 @@ int cx18_v4l2_close(struct file *filp)
>> 	return 0;
>> }
>>
>> -void cx18_dma_free(struct videobuf_queue *q,
>> -	struct cx18_stream *s, struct cx18_videobuf_buffer *buf)
>> -{
>> -	videobuf_waiton(q, &buf->vb, 0, 0);
>> -	videobuf_vmalloc_free(&buf->vb);
>> -	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>> -}
>> -
>> -static int cx18_prepare_buffer(struct videobuf_queue *q,
>> -	struct cx18_stream *s,
>> -	struct cx18_videobuf_buffer *buf,
>> -	u32 pixelformat,
>> -	unsigned int width, unsigned int height,
>> -	enum v4l2_field field)
>> -{
>> -	int rc = 0;
>> -
>> -	/* check settings */
>> -	buf->bytes_used = 0;
>> -
>> -	if ((width  < 48) || (height < 32))
>> -		return -EINVAL;
>> -
>> -	buf->vb.size = (width * height * 16 /*fmt->depth*/) >> 3;
>> -	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
>> -		return -EINVAL;
>> -
>> -	/* alloc + fill struct (if changed) */
>> -	if (buf->vb.width != width || buf->vb.height != height ||
>> -	    buf->vb.field != field || s->pixelformat != pixelformat ||
>> -	    buf->tvnorm != s->tvnorm) {
>> -
>> -		buf->vb.width  = width;
>> -		buf->vb.height = height;
>> -		buf->vb.field  = field;
>> -		buf->tvnorm    = s->tvnorm;
>> -		s->pixelformat = pixelformat;
>> -
>> -		cx18_dma_free(q, s, buf);
>> -	}
>> -
>> -	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
>> -		return -EINVAL;
>> -
>> -	if (buf->vb.field == 0)
>> -		buf->vb.field = V4L2_FIELD_INTERLACED;
>> -
>> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
>> -		buf->vb.width  = width;
>> -		buf->vb.height = height;
>> -		buf->vb.field  = field;
>> -		buf->tvnorm    = s->tvnorm;
>> -		s->pixelformat = pixelformat;
>> -
>> -		rc = videobuf_iolock(q, &buf->vb, &s->fbuf);
>> -		if (rc != 0)
>> -			goto fail;
>> -	}
>> -	buf->vb.state = VIDEOBUF_PREPARED;
>> -	return 0;
>> -
>> -fail:
>> -	cx18_dma_free(q, s, buf);
>> -	return rc;
>> -
>> -}
>> -
>> -#define VB_MIN_BUFFERS 32
>> -#define VB_MIN_BUFSIZE 0x208000
>> -
>> -static int buffer_setup(struct videobuf_queue *q,
>> -	unsigned int *count, unsigned int *size)
>> -{
>> -	struct cx18_open_id *id = q->priv_data;
>> -	struct cx18 *cx = id->cx;
>> -	struct cx18_stream *s = &cx->streams[id->type];
>> -
>> -	*size = 2 * s->vbwidth * s->vbheight;
>> -	if (*count == 0)
>> -		*count = VB_MIN_BUFFERS;
>> -
>> -	while (*size * *count > VB_MIN_BUFFERS * VB_MIN_BUFSIZE)
>> -		(*count)--;
>> -
>> -	q->field = V4L2_FIELD_INTERLACED;
>> -	q->last = V4L2_FIELD_INTERLACED;
>> -
>> -	return 0;
>> -}
>> -
>> -static int buffer_prepare(struct videobuf_queue *q,
>> -	struct videobuf_buffer *vb,
>> -	enum v4l2_field field)
>> -{
>> -	struct cx18_videobuf_buffer *buf =
>> -		container_of(vb, struct cx18_videobuf_buffer, vb);
>> -	struct cx18_open_id *id = q->priv_data;
>> -	struct cx18 *cx = id->cx;
>> -	struct cx18_stream *s = &cx->streams[id->type];
>> -
>> -	return cx18_prepare_buffer(q, s, buf, s->pixelformat,
>> -		s->vbwidth, s->vbheight, field);
>> -}
>> -
>> -static void buffer_release(struct videobuf_queue *q,
>> -	struct videobuf_buffer *vb)
>> -{
>> -	struct cx18_videobuf_buffer *buf =
>> -		container_of(vb, struct cx18_videobuf_buffer, vb);
>> -	struct cx18_open_id *id = q->priv_data;
>> -	struct cx18 *cx = id->cx;
>> -	struct cx18_stream *s = &cx->streams[id->type];
>> -
>> -	cx18_dma_free(q, s, buf);
>> -}
>> -
>> -static void buffer_queue(struct videobuf_queue *q, struct
>> videobuf_buffer *vb)
>> -{
>> -	struct cx18_videobuf_buffer *buf =
>> -		container_of(vb, struct cx18_videobuf_buffer, vb);
>> -	struct cx18_open_id *id = q->priv_data;
>> -	struct cx18 *cx = id->cx;
>> -	struct cx18_stream *s = &cx->streams[id->type];
>> -
>> -	buf->vb.state = VIDEOBUF_QUEUED;
>> -
>> -	list_add_tail(&buf->vb.queue, &s->vb_capture);
>> -}
>> -
>> -static struct videobuf_queue_ops cx18_videobuf_qops = {
>> -	.buf_setup    = buffer_setup,
>> -	.buf_prepare  = buffer_prepare,
>> -	.buf_queue    = buffer_queue,
>> -	.buf_release  = buffer_release,
>> -};
>> -
>> static int cx18_serialized_open(struct cx18_stream *s, struct file
>> *filp)
>> {
>> 	struct cx18 *cx = s->cx;
>> @@ -942,8 +810,8 @@ static int cx18_serialized_open(struct cx18_stream
>> *s, struct file *filp)
>> 	item->cx = cx;
>> 	item->type = s->type;
>>
>> -	spin_lock_init(&item->s_lock);
>> -	item->vb_type = 0;
>> +	spin_lock_init(&s->vbuf_q_lock);
>> +	s->vb_type = 0;
>>
>> 	item->open_id = cx->open_id++;
>> 	filp->private_data = &item->fh;
>> @@ -979,15 +847,6 @@ static int cx18_serialized_open(struct cx18_stream
>> *s, struct file *filp)
>> 		/* Done! Unmute and continue. */
>> 		cx18_unmute(cx);
>> 	}
>> -	if (item->type == CX18_ENC_STREAM_TYPE_YUV) {
>> -		item->vb_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> -		videobuf_queue_vmalloc_init(&item->vbuf_q, &cx18_videobuf_qops,
>> -			&cx->pci_dev->dev, &item->s_lock,
>> -			V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> -			V4L2_FIELD_INTERLACED,
>> -			sizeof(struct cx18_videobuf_buffer),
>> -			item, &cx->serialize_lock);
>> -	}
>> 	v4l2_fh_add(&item->fh);
>> 	return 0;
>> }
>> diff --git a/drivers/media/video/cx18/cx18-ioctl.c
>> b/drivers/media/video/cx18/cx18-ioctl.c
>> index 777d726..1933d4d 100644
>> --- a/drivers/media/video/cx18/cx18-ioctl.c
>> +++ b/drivers/media/video/cx18/cx18-ioctl.c
>> @@ -41,18 +41,6 @@
>> #include <media/tveeprom.h>
>> #include <media/v4l2-chip-ident.h>
>>
>> -static struct v4l2_fmtdesc formats[] = {
>> -	{ 0, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
>> -	  "HM12 (YUV 4:1:1)", V4L2_PIX_FMT_HM12, { 0, 0, 0, 0 }
>> -	},
>> -	{ 1, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FMT_FLAG_COMPRESSED,
>> -	  "MPEG", V4L2_PIX_FMT_MPEG, { 0, 0, 0, 0 }
>> -	},
>> -	{ 2, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
>> -	  "YUYV 4:2:2", V4L2_PIX_FMT_YUYV, { 0, 0, 0, 0 }
>> -	},
>> -};
>> -
>> u16 cx18_service2vbi(int type)
>> {
>> 	switch (type) {
>> @@ -172,8 +160,12 @@ static int cx18_g_fmt_vid_cap(struct file *file,
>> void *fh,
>> 	pixfmt->priv = 0;
>> 	if (id->type == CX18_ENC_STREAM_TYPE_YUV) {
>> 		pixfmt->pixelformat = s->pixelformat;
>> -		/* YUV size is (Y=(h*720) + UV=(h*(720/2))) */
>> -		pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
>> +		/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
>> +		   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
>> +		if (s->pixelformat == V4L2_PIX_FMT_HM12)
>> +			pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
>> +		else
>> +			pixfmt->sizeimage = pixfmt->height * 720 * 2;
>> 		pixfmt->bytesperline = 720;
>> 	} else {
>> 		pixfmt->pixelformat = V4L2_PIX_FMT_MPEG;
>> @@ -296,16 +288,15 @@ static int cx18_s_fmt_vid_cap(struct file *file,
>> void *fh,
>> 	w = fmt->fmt.pix.width;
>> 	h = fmt->fmt.pix.height;
>>
>> -	s->pixelformat = fmt->fmt.pix.pixelformat;
>> -	s->vbheight = h;
>> -	s->vbwidth = w;
>> -
>> -	if (cx->cxhdl.width == w && cx->cxhdl.height == h)
>> +	if (cx->cxhdl.width == w && cx->cxhdl.height == h &&
>> +	    s->pixelformat == fmt->fmt.pix.pixelformat)
>> 		return 0;
>>
>> 	if (atomic_read(&cx->ana_capturing) > 0)
>> 		return -EBUSY;
>>
>> +	s->pixelformat = fmt->fmt.pix.pixelformat;
>> +
>> 	mbus_fmt.width = cx->cxhdl.width = w;
>> 	mbus_fmt.height = cx->cxhdl.height = h;
>> 	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
>> @@ -557,6 +548,18 @@ static int cx18_g_crop(struct file *file, void
>> *fh, struct v4l2_crop *crop)
>> static int cx18_enum_fmt_vid_cap(struct file *file, void *fh,
>> 					struct v4l2_fmtdesc *fmt)
>> {
>> +	static const struct v4l2_fmtdesc formats[] = {
>> +		{ 0, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
>> +		  "HM12 (YUV 4:1:1)", V4L2_PIX_FMT_HM12, { 0, 0, 0, 0 }
>> +		},
>> +		{ 1, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FMT_FLAG_COMPRESSED,
>> +		  "MPEG", V4L2_PIX_FMT_MPEG, { 0, 0, 0, 0 }
>> +		},
>> +		{ 2, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
>> +		  "UYVY 4:2:2", V4L2_PIX_FMT_UYVY, { 0, 0, 0, 0 }
>> +		},
>> +	};
>> +
>> 	if (fmt->index > ARRAY_SIZE(formats) - 1)
>> 		return -EINVAL;
>> 	*fmt = formats[fmt->index];
>> @@ -874,10 +877,12 @@ static int cx18_g_enc_index(struct file *file,
>> void *fh,
>> static struct videobuf_queue *cx18_vb_queue(struct cx18_open_id *id)
>> {
>> 	struct videobuf_queue *q = NULL;
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>>
>> -	switch (id->vb_type) {
>> +	switch (s->vb_type) {
>> 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> -		q = &id->vbuf_q;
>> +		q = &s->vbuf_q;
>> 		break;
>> 	case V4L2_BUF_TYPE_VBI_CAPTURE:
>> 		break;
>> @@ -895,15 +900,15 @@ static int cx18_streamon(struct file *file, void
>> *priv,
>> 	struct cx18_stream *s = &cx->streams[id->type];
>>
>> 	/* Start the hardware only if we're the video device */
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	if (id->type != CX18_ENC_STREAM_TYPE_YUV)
>> 		return -EINVAL;
>>
>> 	/* Establish a buffer timeout */
>> -	mod_timer(&s->vb_timeout, jiffies + (HZ * 2));
>> +	mod_timer(&s->vb_timeout, msecs_to_jiffies(2000) + jiffies);
>>
>> 	return videobuf_streamon(cx18_vb_queue(id));
>> }
>> @@ -912,10 +917,12 @@ static int cx18_streamoff(struct file *file, void
>> *priv,
>> 	enum v4l2_buf_type type)
>> {
>> 	struct cx18_open_id *id = file->private_data;
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>>
>> 	/* Start the hardware only if we're the video device */
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	if (id->type != CX18_ENC_STREAM_TYPE_YUV)
>> @@ -928,9 +935,11 @@ static int cx18_reqbufs(struct file *file, void
>> *priv,
>> 	struct v4l2_requestbuffers *rb)
>> {
>> 	struct cx18_open_id *id = file->private_data;
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>>
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	return videobuf_reqbufs(cx18_vb_queue(id), rb);
>> @@ -940,9 +949,11 @@ static int cx18_querybuf(struct file *file, void
>> *priv,
>> 	struct v4l2_buffer *b)
>> {
>> 	struct cx18_open_id *id = file->private_data;
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>>
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	return videobuf_querybuf(cx18_vb_queue(id), b);
>> @@ -951,9 +962,11 @@ static int cx18_querybuf(struct file *file, void
>> *priv,
>> static int cx18_qbuf(struct file *file, void *priv, struct v4l2_buffer
>> *b)
>> {
>> 	struct cx18_open_id *id = file->private_data;
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>>
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	return videobuf_qbuf(cx18_vb_queue(id), b);
>> @@ -962,8 +975,11 @@ static int cx18_qbuf(struct file *file, void
>> *priv, struct v4l2_buffer *b)
>> static int cx18_dqbuf(struct file *file, void *priv, struct v4l2_buffer
>> *b)
>> {
>> 	struct cx18_open_id *id = file->private_data;
>> -	if ((id->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> -		(id->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> +	struct cx18 *cx = id->cx;
>> +	struct cx18_stream *s = &cx->streams[id->type];
>> +
>> +	if ((s->vb_type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
>> +		(s->vb_type != V4L2_BUF_TYPE_VBI_CAPTURE))
>> 		return -EINVAL;
>>
>> 	return videobuf_dqbuf(cx18_vb_queue(id), b, file->f_flags &
>> O_NONBLOCK);
>> diff --git a/drivers/media/video/cx18/cx18-mailbox.c
>> b/drivers/media/video/cx18/cx18-mailbox.c
>> index d4d8873..5ecae93 100644
>> --- a/drivers/media/video/cx18/cx18-mailbox.c
>> +++ b/drivers/media/video/cx18/cx18-mailbox.c
>> @@ -177,7 +177,7 @@ static void cx18_mdl_send_to_videobuf(struct
>> cx18_stream *s,
>> 	if (list_empty(&s->vb_capture))
>> 		goto out;
>>
>> -	vb_buf = list_entry(s->vb_capture.next, struct cx18_videobuf_buffer,
>> +	vb_buf = list_first_entry(&s->vb_capture, struct
>> cx18_videobuf_buffer,
>> 		vb.queue);
>>
>> 	p = videobuf_to_vmalloc(&vb_buf->vb);
>> @@ -202,25 +202,14 @@ static void cx18_mdl_send_to_videobuf(struct
>> cx18_stream *s,
>> 		vb_buf->bytes_used = 0;
>> 	}
>>
>> -	/* */
>> 	if (dispatch) {
>> -
>> -		if (s->pixelformat == V4L2_PIX_FMT_YUYV) {
>> -			/* UYVY to YUYV */
>> -			for (i = 0; i < (720 * 480 * 2); i += 2) {
>> -				u = *(p + i);
>> -				*(p + i) = *(p + i + 1);
>> -				*(p + i + 1) = u;
>> -			}
>> -		}
>> -
>> -		do_gettimeofday(&vb_buf->vb.ts);
>> +		ktime_get_ts(&vb_buf->vb.ts);
>> 		list_del(&vb_buf->vb.queue);
>> 		vb_buf->vb.state = VIDEOBUF_DONE;
>> 		wake_up(&vb_buf->vb.done);
>> 	}
>>
>> -	mod_timer(&s->vb_timeout, jiffies + (HZ / 10));
>> +	mod_timer(&s->vb_timeout, msecs_to_jiffies(2000) + jiffies);
>>
>> out:
>> 	spin_unlock(&s->vb_lock);
>> diff --git a/drivers/media/video/cx18/cx18-streams.c
>> b/drivers/media/video/cx18/cx18-streams.c
>> index 53f5e4f..24c9688 100644
>> --- a/drivers/media/video/cx18/cx18-streams.c
>> +++ b/drivers/media/video/cx18/cx18-streams.c
>> @@ -98,6 +98,141 @@ static struct {
>> 	},
>> };
>>
>> +
>> +void cx18_dma_free(struct videobuf_queue *q,
>> +	struct cx18_stream *s, struct cx18_videobuf_buffer *buf)
>> +{
>> +	videobuf_waiton(q, &buf->vb, 0, 0);
>> +	videobuf_vmalloc_free(&buf->vb);
>> +	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>> +}
>> +
>> +static int cx18_prepare_buffer(struct videobuf_queue *q,
>> +	struct cx18_stream *s,
>> +	struct cx18_videobuf_buffer *buf,
>> +	u32 pixelformat,
>> +	unsigned int width, unsigned int height,
>> +	enum v4l2_field field)
>> +{
>> +        struct cx18 *cx = s->cx;
>> +	int rc = 0;
>> +
>> +	/* check settings */
>> +	buf->bytes_used = 0;
>> +
>> +	if ((width  < 48) || (height < 32))
>> +		return -EINVAL;
>> +
>> +	buf->vb.size = (width * height * 2);
>> +	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
>> +		return -EINVAL;
>> +
>> +	/* alloc + fill struct (if changed) */
>> +	if (buf->vb.width != width || buf->vb.height != height ||
>> +	    buf->vb.field != field || s->pixelformat != pixelformat ||
>> +	    buf->tvnorm != cx->std) {
>> +
>> +		buf->vb.width  = width;
>> +		buf->vb.height = height;
>> +		buf->vb.field  = field;
>> +		buf->tvnorm    = cx->std;
>> +		s->pixelformat = pixelformat;
>> +
>> +		cx18_dma_free(q, s, buf);
>> +	}
>> +
>> +	if ((buf->vb.baddr != 0) && (buf->vb.bsize < buf->vb.size))
>> +		return -EINVAL;
>> +
>> +	if (buf->vb.field == 0)
>> +		buf->vb.field = V4L2_FIELD_INTERLACED;
>> +
>> +	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
>> +		buf->vb.width  = width;
>> +		buf->vb.height = height;
>> +		buf->vb.field  = field;
>> +		buf->tvnorm    = cx->std;
>> +		s->pixelformat = pixelformat;
>> +
>> +		rc = videobuf_iolock(q, &buf->vb, NULL);
>> +		if (rc != 0)
>> +			goto fail;
>> +	}
>> +	buf->vb.state = VIDEOBUF_PREPARED;
>> +	return 0;
>> +
>> +fail:
>> +	cx18_dma_free(q, s, buf);
>> +	return rc;
>> +
>> +}
>> +
>> +/* VB_MIN_BUFSIZE is lcm(1440 * 480, 1440 * 576)
>> +   1440 is a single line of 4:2:2 YUV at 720 luma samples wide
>> +*/
>> +#define VB_MIN_BUFFERS 32
>> +#define VB_MIN_BUFSIZE 4147200
>> +
>> +static int buffer_setup(struct videobuf_queue *q,
>> +	unsigned int *count, unsigned int *size)
>> +{
>> +	struct cx18_stream *s = q->priv_data;
>> +	struct cx18 *cx = s->cx;
>> +
>> +	*size = 2 * cx->cxhdl.width * cx->cxhdl.height;
>> +	if (*count == 0)
>> +		*count = VB_MIN_BUFFERS;
>> +
>> +	while (*size * *count > VB_MIN_BUFFERS * VB_MIN_BUFSIZE)
>> +		(*count)--;
>> +
>> +	q->field = V4L2_FIELD_INTERLACED;
>> +	q->last = V4L2_FIELD_INTERLACED;
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_prepare(struct videobuf_queue *q,
>> +	struct videobuf_buffer *vb,
>> +	enum v4l2_field field)
>> +{
>> +	struct cx18_videobuf_buffer *buf =
>> +		container_of(vb, struct cx18_videobuf_buffer, vb);
>> +	struct cx18_stream *s = q->priv_data;
>> +	struct cx18 *cx = s->cx;
>> +
>> +	return cx18_prepare_buffer(q, s, buf, s->pixelformat,
>> +		cx->cxhdl.width, cx->cxhdl.height, field);
>> +}
>> +
>> +static void buffer_release(struct videobuf_queue *q,
>> +	struct videobuf_buffer *vb)
>> +{
>> +	struct cx18_videobuf_buffer *buf =
>> +		container_of(vb, struct cx18_videobuf_buffer, vb);
>> +	struct cx18_stream *s = q->priv_data;
>> +
>> +	cx18_dma_free(q, s, buf);
>> +}
>> +
>> +static void buffer_queue(struct videobuf_queue *q, struct
>> videobuf_buffer *vb)
>> +{
>> +	struct cx18_videobuf_buffer *buf =
>> +		container_of(vb, struct cx18_videobuf_buffer, vb);
>> +	struct cx18_stream *s = q->priv_data;
>> +
>> +	buf->vb.state = VIDEOBUF_QUEUED;
>> +
>> +	list_add_tail(&buf->vb.queue, &s->vb_capture);
>> +}
>> +
>> +static struct videobuf_queue_ops cx18_videobuf_qops = {
>> +	.buf_setup    = buffer_setup,
>> +	.buf_prepare  = buffer_prepare,
>> +	.buf_queue    = buffer_queue,
>> +	.buf_release  = buffer_release,
>> +};
>> +
>> static void cx18_stream_init(struct cx18 *cx, int type)
>> {
>> 	struct cx18_stream *s = &cx->streams[type];
>> @@ -139,9 +274,18 @@ static void cx18_stream_init(struct cx18 *cx, int
>> type)
>> 	s->vb_timeout.data = (unsigned long)s;
>> 	init_timer(&s->vb_timeout);
>> 	spin_lock_init(&s->vb_lock);
>> -
>> -	/* Assume the previous pixel default */
>> -	s->pixelformat = V4L2_PIX_FMT_HM12;
>> +	if (type == CX18_ENC_STREAM_TYPE_YUV) {
>> +		s->vb_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +		videobuf_queue_vmalloc_init(&s->vbuf_q, &cx18_videobuf_qops,
>> +			&cx->pci_dev->dev, &s->vbuf_q_lock,
>> +			V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> +			V4L2_FIELD_INTERLACED,
>> +			sizeof(struct cx18_videobuf_buffer),
>> +			s, &cx->serialize_lock);
>> +
>> +		/* Assume the previous pixel default */
>> +		s->pixelformat = V4L2_PIX_FMT_HM12;
>> +	}
>> }
>>
>> static int cx18_prep_dev(struct cx18 *cx, int type)
>> @@ -374,6 +518,9 @@ void cx18_streams_cleanup(struct cx18 *cx, int
>> unregister)
>> 		if (vdev == NULL)
>> 			continue;
>>
>> +		if (type == CX18_ENC_STREAM_TYPE_YUV)
>> +			videobuf_mmap_free(&cx->streams[type].vbuf_q);
>> +
>> 		cx18_stream_free(&cx->streams[type]);
>>
>> 		/* Unregister or release device */
>> @@ -583,7 +730,10 @@ static void cx18_stream_configure_mdls(struct
>> cx18_stream *s)
>> 		 * Set the MDL size to the exact size needed for one frame.
>> 		 * Use enough buffers per MDL to cover the MDL size
>> 		 */
>> -		s->mdl_size = 720 * s->cx->cxhdl.height * 3 / 2;
>> +		if (s->pixelformat == V4L2_PIX_FMT_HM12)
>> +			s->mdl_size = 720 * s->cx->cxhdl.height * 3 / 2;
>> +		else
>> +			s->mdl_size = 720 * s->cx->cxhdl.height * 2;
>> 		s->bufs_per_mdl = s->mdl_size / s->buf_size;
>> 		if (s->mdl_size % s->buf_size)
>> 			s->bufs_per_mdl++;
>> @@ -736,7 +886,7 @@ int cx18_start_v4l2_encode_stream(struct
>> cx18_stream *s)
>> 		 * rather than the default HM12 Macroblovk 4:2:0 support.
>> 		 */
>> 		if (captype == CAPTURE_CHANNEL_TYPE_YUV) {
>> -			if (s->pixelformat == V4L2_PIX_FMT_YUYV)
>> +			if (s->pixelformat == V4L2_PIX_FMT_UYVY)
>> 				cx18_vapi(cx, CX18_CPU_SET_VFC_PARAM, 2,
>> 					s->handle, 1);
>> 			else
>> -- 
>> 1.7.4
> 
> Simon,
> 
> If these two changes are going in, please also bump the driver version to 1.5.0 in cx18-version.c.  These changes are significant enough perturbation.
> 
> End users are going to look to driver version 1.4.1 as the first version for proper analog tuner support of the HVR1600 model 74351.
> 
> Mauro,
> 
> Is cx18 v1.4.1 with HVR1600 model 74351 analog tuner support, without these mmap() changes going to be visible in kernel version .39 ?

Hmm... This is what I have at my for_upstream tree:

$ git grep -i 74351 drivers/media/video/cx18/
drivers/media/video/cx18/cx18-driver.c:   case 74351: /* OEM models */

drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_MAJOR 1
drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_MINOR 4
drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_PATCHLEVEL 0




> 
> Regards,
> Andy

