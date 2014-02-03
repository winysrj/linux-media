Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([69.56.144.7]:52352 "EHLO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaBCR1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 12:27:36 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway12.websitewelcome.com (Postfix) with ESMTP id 46C3049CC182B
	for <linux-media@vger.kernel.org>; Mon,  3 Feb 2014 11:06:55 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Feb 2014 11:06:53 -0600
From: Dean Anderson <linux-dev@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] s2255drv: port to videobuf2
In-Reply-To: <52EF66A4.30401@xs4all.nl>
References: <1391189745-11398-1-git-send-email-linux-dev@sensoray.com>
 <52EF66A4.30401@xs4all.nl>
Message-ID: <4019df5ff7ddbc7945122a7a571ed57b@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-02-03 03:51, Hans Verkuil wrote:
> Hi Dean,
> 
> Some specific comments below, but first two general comments:
> 
> It is easier to review if at least the removal of the old s2255_fh 
> struct
> was done as a separate patch. It's always good to try and keep the 
> changes
> in patches as small as possible. The actual vb2 conversion is always a
> 'big bang' patch, that's unavoidable, but it's easier if it isn't 
> mixed in
> with other changes that are not directly related to the vb2 
> conversion.


I figured removal of s2255_fh was a natural part of the videobuf2 
conversion process, but I can break it up.
I also did change some formatting and naming changes (s2255_channel to 
s2255_vc) that can be postponed.

> 
> And did you also run the v4l2-compliance utility for this driver? 
> That's
> useful to check that everything it still correct.

Thanks for the comments.  I'll do a v2 soon with v4l2-compliance fully 
tested too.

I added some comments below too.



> On 01/31/2014 06:35 PM, Dean Anderson wrote:
>> Update s2255drv to use videobuf2 instead of videobuf.
>> s2255_fh file handle removed and driver simplified.
>> 
>> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
>> ---
>>  drivers/media/usb/s2255/s2255drv.c | 1170 
>> +++++++++++++++---------------------
>>  1 file changed, 473 insertions(+), 697 deletions(-)
>> 
>> diff --git a/drivers/media/usb/s2255/s2255drv.c 
>> b/drivers/media/usb/s2255/s2255drv.c
>> index c6bdccc..d6e9332 100644
>> --- a/drivers/media/usb/s2255/s2255drv.c
>> +++ b/drivers/media/usb/s2255/s2255drv.c
> 
> <snip>
> 
>> @@ -666,146 +641,131 @@ static void s2255_fillbuff(struct 
>> s2255_channel *channel,
>>  	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
>>  		(unsigned long)vbuf, pos);
>>  	/* tell v4l buffer was filled */
>> -	buf->vb.field_count = channel->frame_count * 2;
>> -	v4l2_get_timestamp(&buf->vb.ts);
>> -	buf->vb.state = VIDEOBUF_DONE;
>> +	vc->field_count = vc->frame_count * 2;
>> +	buf->vb.v4l2_buf.field = vc->field;
>> +	buf->vb.v4l2_buf.sequence = vc->field_count >> 1;
> 
> Just drop field_count (left-over from vivi) and use frame_count 
> directly.
> 
>> +	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
>> +	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>>  }
>> 
>> +/*
>> + * setup the contraints of the queue
>> + */
>> +static int queue_setup(struct vb2_queue *vq, const struct 
>> v4l2_format *fmt,
>> +				unsigned int *nbuffers, unsigned int *nplanes,
>> +				unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>> +	unsigned long size;
>> 
>> -/* 
>> ------------------------------------------------------------------
>> -   Videobuf operations
>> -   
>> ------------------------------------------------------------------*/
>> +	size = vc->width * vc->height * (vc->fmt->depth >> 3);
>> 
>> -static int buffer_setup(struct videobuf_queue *vq, unsigned int 
>> *count,
>> -			unsigned int *size)
>> -{
>> -	struct s2255_fh *fh = vq->priv_data;
>> -	struct s2255_channel *channel = fh->channel;
>> -	*size = channel->width * channel->height * (channel->fmt->depth >> 
>> 3);
>> +	if (0 == *nbuffers)
>> +		*nbuffers = S2255_DEF_BUFS;
> 
> Unfortunately vivi was a bad example to use for this (I'm going to 
> post patches
> to fix vivi to avoid this in the future).
> 
> What really needs to happen is that you test against the minimum 
> number of
> buffers required to stream (usually somewhere between 1 and 3, test 
> with e.g.
> qv4l2 or v4l2-ctl) and if it is less, set *nbuffers to that minimum.
> 
>> 
>> -	if (0 == *count)
>> -		*count = S2255_DEF_BUFS;
>> +	if (size * *nbuffers > vid_limit * 1024 * 1024)
>> +		*nbuffers = (vid_limit * 1024 * 1024) / size;
>> 
>> -	if (*size * *count > vid_limit * 1024 * 1024)
>> -		*count = (vid_limit * 1024 * 1024) / *size;
> 
> This vid_limit makes no sense. If the application wants 32 buffers
> (the maximum),
> then it should be able to get 32 buffers if there is enough memory. 
> Having a
> vid_limit is pointless. I plan on removing this from vivi as well.
> 
>> +	if (size == 0)
>> +		return -EINVAL;
>> 
>> +	*nplanes = 1;
>> +	sizes[0] = size;
>>  	return 0;
>>  }
>> 
>> -static void free_buffer(struct videobuf_queue *vq, struct 
>> s2255_buffer *buf)
>> -{
>> -	videobuf_vmalloc_free(&buf->vb);
>> -	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>> -}
>> 
>> -static int buffer_prepare(struct videobuf_queue *vq, struct 
>> videobuf_buffer *vb,
>> -			  enum v4l2_field field)
>> +static int buffer_prepare(struct vb2_buffer *vb)
>>  {
>> -	struct s2255_fh *fh = vq->priv_data;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
>>  	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, 
>> vb);
>> -	int rc;
>> -	int w = channel->width;
>> -	int h = channel->height;
>> -	dprintk(fh->dev, 4, "%s, field=%d\n", __func__, field);
>> -	if (channel->fmt == NULL)
>> -		return -EINVAL;
>> +	unsigned long size;
>> +	int w = vc->width;
>> +	int h = vc->height;
>> 
>> -	if ((w < norm_minw(channel)) ||
>> -	    (w > norm_maxw(channel)) ||
>> -	    (h < norm_minh(channel)) ||
>> -	    (h > norm_maxh(channel))) {
>> -		dprintk(fh->dev, 4, "invalid buffer prepare\n");
>> +	if (vc->fmt == NULL)
>>  		return -EINVAL;
>> -	}
>> -	buf->vb.size = w * h * (channel->fmt->depth >> 3);
>> -	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
>> -		dprintk(fh->dev, 4, "invalid buffer prepare\n");
>> +
>> +	if ((w < norm_minw(vc)) ||
>> +	    (w > norm_maxw(vc)) ||
>> +	    (h < norm_minh(vc)) ||
>> +	    (h > norm_maxh(vc))) {
>> +		dprintk(vc->dev, 4, "invalid buffer prepare\n");
>>  		return -EINVAL;
>>  	}
>> +	size = w * h * (vc->fmt->depth >> 3);
>> 
>> -	buf->fmt = channel->fmt;
>> -	buf->vb.width = w;
>> -	buf->vb.height = h;
>> -	buf->vb.field = field;
>> -
>> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
>> -		rc = videobuf_iolock(vq, &buf->vb, NULL);
>> -		if (rc < 0)
>> -			goto fail;
>> -	}
>> +	if (vb2_plane_size(vb, 0) < size)
>> +		return -EINVAL;
>> 
>> -	buf->vb.state = VIDEOBUF_PREPARED;
>> +	vb2_set_plane_payload(&buf->vb, 0, size);
>> +	buf->fmt = vc->fmt;
> 
> buf->fmt can be dropped. It's used in only one place, and there 
> vc->fmt can be
> used as well. I need to remove that in vivi as well.
> 
>>  	return 0;
>> -fail:
>> -	free_buffer(vq, buf);
>> -	return rc;
>>  }
>> 
>> -static void buffer_queue(struct videobuf_queue *vq, struct 
>> videobuf_buffer *vb)
>> +static void buffer_queue(struct vb2_buffer *vb)
>>  {
>>  	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, 
>> vb);
>> -	struct s2255_fh *fh = vq->priv_data;
>> -	struct s2255_channel *channel = fh->channel;
>> -	struct s2255_dmaqueue *vidq = &channel->vidq;
>> -	dprintk(fh->dev, 1, "%s\n", __func__);
>> -	buf->vb.state = VIDEOBUF_QUEUED;
>> -	list_add_tail(&buf->vb.queue, &vidq->active);
>> -}
>> -
>> -static void buffer_release(struct videobuf_queue *vq,
>> -			   struct videobuf_buffer *vb)
>> -{
>> -	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, 
>> vb);
>> -	struct s2255_fh *fh = vq->priv_data;
>> -	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->channel->idx);
>> -	free_buffer(vq, buf);
>> -}
>> -
>> -static struct videobuf_queue_ops s2255_video_qops = {
>> -	.buf_setup = buffer_setup,
>> -	.buf_prepare = buffer_prepare,
>> -	.buf_queue = buffer_queue,
>> -	.buf_release = buffer_release,
>> -};
>> -
>> -
>> -static int res_get(struct s2255_fh *fh)
>> -{
>> -	struct s2255_channel *channel = fh->channel;
>> -	/* is it free? */
>> -	if (channel->resources)
>> -		return 0; /* no, someone else uses it */
>> -	/* it's free, grab it */
>> -	channel->resources = 1;
>> -	fh->resources = 1;
>> -	dprintk(fh->dev, 1, "s2255: res: get\n");
>> -	return 1;
>> +	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct s2255_dev *dev = vc->dev;
>> +	unsigned long flags = 0;
> 
> Please add an empty line here to make it more readable. In general, 
> after
> declaring variables add a newline before starting the actual code.
> 
>> +	dprintk(dev, 1, "%s\n", __func__);
>> +	spin_lock_irqsave(&vc->qlock, flags);
>> +	list_add_tail(&buf->list, &vc->buf_list);
>> +	spin_unlock_irqrestore(&vc->qlock, flags);
>>  }
>> 
>> -static int res_locked(struct s2255_fh *fh)
>> +/* begin streaming on a 2255 video channel */
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>>  {
>> -	return fh->channel->resources;
>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>> +	int j;
>> +	vc->last_frame = -1;
>> +	vc->bad_payload = 0;
>> +	vc->cur_frame = 0;
>> +	vc->frame_count = 0;
>> +	for (j = 0; j < SYS_FRAMES; j++) {
>> +		vc->buffer.frame[j].ulState = S2255_READ_IDLE;
>> +		vc->buffer.frame[j].cur_size = 0;
>> +	}
>> +	s2255_start_acquire(vc);
> 
> I noticed that s2255_start_acquire can fail and that that is not 
> checked here.
> In fact, s2255_start_acquire also ignores an error from 
> s2255_write_config().
> Several s2255 functions allocate a 512 buffer and release it again 
> after use.
> Would it not make more sense to allocate that buffer in probe() and 
> use that
> everywhere?


I don't like this dynamic memory allocation either.  I'll make a 
separate patch after the videobuf2 change.


> 
>> +	return 0;
>>  }
>> 
>> -static int res_check(struct s2255_fh *fh)
>> +/* abort streaming and wait for last buffer */
>> +static int stop_streaming(struct vb2_queue *vq)
>>  {
>> -	return fh->resources;
>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>> +	struct s2255_buffer *buf, *node;
>> +	unsigned long flags;
>> +	s2255_stop_acquire(vc);
>> +	spin_lock_irqsave(&vc->qlock, flags);
>> +	list_for_each_entry_safe(buf, node, &vc->buf_list, list) {
>> +		list_del(&buf->list);
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +		dprintk(vc->dev, 2, "[%p/%d] done\n",
>> +			buf, buf->vb.v4l2_buf.index);
>> +	}
>> +	spin_unlock_irqrestore(&vc->qlock, flags);
>> +	return 0;
>>  }
>> 
>> +static struct vb2_ops s2255_video_qops = {
>> +	.queue_setup = queue_setup,
>> +	.buf_prepare = buffer_prepare,
>> +	.buf_queue = buffer_queue,
>> +	.start_streaming = start_streaming,
>> +	.stop_streaming = stop_streaming,
>> +	.wait_prepare = vb2_ops_wait_prepare,
>> +	.wait_finish = vb2_ops_wait_finish,
>> 
>> -static void res_free(struct s2255_fh *fh)
>> -{
>> -	struct s2255_channel *channel = fh->channel;
>> -	channel->resources = 0;
>> -	fh->resources = 0;
>> -}
>> +};
>> 
>>  static int vidioc_querycap(struct file *file, void *priv,
>>  			   struct v4l2_capability *cap)
>>  {
>> -	struct s2255_fh *fh = file->private_data;
>> -	struct s2255_dev *dev = fh->dev;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	struct s2255_dev *dev = vc->dev;
>> 
>>  	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
>>  	strlcpy(cap->card, "s2255", sizeof(cap->card));
>> @@ -833,19 +793,18 @@ static int vidioc_enum_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>  			    struct v4l2_format *f)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> -	int is_ntsc = channel->std & V4L2_STD_525_60;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	int is_ntsc = vc->std & V4L2_STD_525_60;
>> 
>> -	f->fmt.pix.width = channel->width;
>> -	f->fmt.pix.height = channel->height;
>> +	f->fmt.pix.width = vc->width;
>> +	f->fmt.pix.height = vc->height;
>>  	if (f->fmt.pix.height >=
>>  	    (is_ntsc ? NUM_LINES_1CIFS_NTSC : NUM_LINES_1CIFS_PAL) * 2)
>>  		f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>>  	else
>>  		f->fmt.pix.field = V4L2_FIELD_TOP;
>> -	f->fmt.pix.pixelformat = channel->fmt->fourcc;
>> -	f->fmt.pix.bytesperline = f->fmt.pix.width * (channel->fmt->depth 
>> >> 3);
>> +	f->fmt.pix.pixelformat = vc->fmt->fourcc;
>> +	f->fmt.pix.bytesperline = f->fmt.pix.width * (vc->fmt->depth >> 3);
>>  	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>  	f->fmt.pix.priv = 0;
>> @@ -857,9 +816,8 @@ static int vidioc_try_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  {
>>  	const struct s2255_fmt *fmt;
>>  	enum v4l2_field field;
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> -	int is_ntsc = channel->std & V4L2_STD_525_60;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	int is_ntsc = vc->std & V4L2_STD_525_60;
>> 
>>  	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
>> 
>> @@ -868,7 +826,7 @@ static int vidioc_try_fmt_vid_cap(struct file 
>> *file, void *priv,
>> 
>>  	field = f->fmt.pix.field;
>> 
>> -	dprintk(fh->dev, 50, "%s NTSC: %d suggested width: %d, height: 
>> %d\n",
>> +	dprintk(vc->dev, 50, "%s NTSC: %d suggested width: %d, height: 
>> %d\n",
>>  		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
>>  	if (is_ntsc) {
>>  		/* NTSC */
>> @@ -910,7 +868,8 @@ static int vidioc_try_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>  	f->fmt.pix.priv = 0;
>> -	dprintk(fh->dev, 50, "%s: set width %d height %d field %d\n", 
>> __func__,
>> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	dprintk(vc->dev, 50, "%s: set width %d height %d field %d\n", 
>> __func__,
>>  		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
>>  	return 0;
>>  }
>> @@ -918,14 +877,13 @@ static int vidioc_try_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>>  			    struct v4l2_format *f)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	const struct s2255_fmt *fmt;
>> -	struct videobuf_queue *q = &fh->vb_vidq;
>> +	struct vb2_queue *q = &vc->vb_vidq;
>>  	struct s2255_mode mode;
>>  	int ret;
>> 
>> -	ret = vidioc_try_fmt_vid_cap(file, fh, f);
>> +	ret = vidioc_try_fmt_vid_cap(file, vc, f);
>> 
>>  	if (ret < 0)
>>  		return ret;
>> @@ -934,29 +892,24 @@ static int vidioc_s_fmt_vid_cap(struct file 
>> *file, void *priv,
>> 
>>  	if (fmt == NULL)
>>  		return -EINVAL;
>> +	/*
>> +	 * It is not allowed to change the format while buffers for use 
>> with
>> +	 * streaming have already been allocated.
>> +	 */
>> +	if (vb2_is_busy(q))
>> +		return -EBUSY;
>> 
>> -	mutex_lock(&q->vb_lock);
>> -
>> -	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
>> -		dprintk(fh->dev, 1, "queue busy\n");
>> -		ret = -EBUSY;
>> -		goto out_s_fmt;
>> -	}
>> -
>> -	if (res_locked(fh)) {
>> -		dprintk(fh->dev, 1, "%s: channel busy\n", __func__);
>> -		ret = -EBUSY;
>> -		goto out_s_fmt;
>> -	}
>> -	mode = channel->mode;
>> -	channel->fmt = fmt;
>> -	channel->width = f->fmt.pix.width;
>> -	channel->height = f->fmt.pix.height;
>> -	fh->vb_vidq.field = f->fmt.pix.field;
>> -	fh->type = f->type;
>> -	if (channel->width > norm_minw(channel)) {
>> -		if (channel->height > norm_minh(channel)) {
>> -			if (channel->cap_parm.capturemode &
>> +	/* change format */
>> +	mode = vc->mode;
>> +	vc->fmt = fmt;
>> +	vc->width = f->fmt.pix.width;
>> +	vc->height = f->fmt.pix.height;
>> +	vc->field = f->fmt.pix.field;
>> +	vc->type = f->type;
>> +
>> +	if (vc->width > norm_minw(vc)) {
>> +		if (vc->height > norm_minh(vc)) {
>> +			if (vc->cap_parm.capturemode &
>>  			    V4L2_MODE_HIGHQUALITY)
>>  				mode.scale = SCALE_4CIFSI;
>>  			else
>> @@ -968,7 +921,7 @@ static int vidioc_s_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  		mode.scale = SCALE_1CIFS;
>>  	}
>>  	/* color mode */
>> -	switch (channel->fmt->fourcc) {
>> +	switch (vc->fmt->fourcc) {
>>  	case V4L2_PIX_FMT_GREY:
>>  		mode.color &= ~MASK_COLOR;
>>  		mode.color |= COLOR_Y8;
>> @@ -977,7 +930,7 @@ static int vidioc_s_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  	case V4L2_PIX_FMT_MJPEG:
>>  		mode.color &= ~MASK_COLOR;
>>  		mode.color |= COLOR_JPG;
>> -		mode.color |= (channel->jpegqual << 8);
>> +		mode.color |= (vc->jpegqual << 8);
>>  		break;
>>  	case V4L2_PIX_FMT_YUV422P:
>>  		mode.color &= ~MASK_COLOR;
>> @@ -990,51 +943,15 @@ static int vidioc_s_fmt_vid_cap(struct file 
>> *file, void *priv,
>>  		mode.color |= COLOR_YUVPK;
>>  		break;
>>  	}
>> -	if ((mode.color & MASK_COLOR) != (channel->mode.color & 
>> MASK_COLOR))
>> +	if ((mode.color & MASK_COLOR) != (vc->mode.color & MASK_COLOR))
>>  		mode.restart = 1;
>> -	else if (mode.scale != channel->mode.scale)
>> +	else if (mode.scale != vc->mode.scale)
>>  		mode.restart = 1;
>> -	else if (mode.format != channel->mode.format)
>> +	else if (mode.format != vc->mode.format)
>>  		mode.restart = 1;
>> -	channel->mode = mode;
>> -	(void) s2255_set_mode(channel, &mode);
>> -	ret = 0;
>> -out_s_fmt:
>> -	mutex_unlock(&q->vb_lock);
>> -	return ret;
>> -}
>> -
>> -static int vidioc_reqbufs(struct file *file, void *priv,
>> -			  struct v4l2_requestbuffers *p)
>> -{
>> -	int rc;
>> -	struct s2255_fh *fh = priv;
>> -	rc = videobuf_reqbufs(&fh->vb_vidq, p);
>> -	return rc;
>> -}
>> -
>> -static int vidioc_querybuf(struct file *file, void *priv, struct 
>> v4l2_buffer *p)
>> -{
>> -	int rc;
>> -	struct s2255_fh *fh = priv;
>> -	rc = videobuf_querybuf(&fh->vb_vidq, p);
>> -	return rc;
>> -}
>> -
>> -static int vidioc_qbuf(struct file *file, void *priv, struct 
>> v4l2_buffer *p)
>> -{
>> -	int rc;
>> -	struct s2255_fh *fh = priv;
>> -	rc = videobuf_qbuf(&fh->vb_vidq, p);
>> -	return rc;
>> -}
>> -
>> -static int vidioc_dqbuf(struct file *file, void *priv, struct 
>> v4l2_buffer *p)
>> -{
>> -	int rc;
>> -	struct s2255_fh *fh = priv;
>> -	rc = videobuf_dqbuf(&fh->vb_vidq, p, file->f_flags & O_NONBLOCK);
>> -	return rc;
>> +	vc->mode = mode;
>> +	(void) s2255_set_mode(vc, &mode);
>> +	return 0;
>>  }
>> 
>>  /* write to the configuration pipe, synchronously */
>> @@ -1115,16 +1032,6 @@ static u32 get_transfer_size(struct s2255_mode 
>> *mode)
>>  	return usbInSize;
>>  }
>> 
>> -static void s2255_print_cfg(struct s2255_dev *sdev, struct 
>> s2255_mode *mode)
>> -{
>> -	struct device *dev = &sdev->udev->dev;
>> -	dev_info(dev, 
>> "------------------------------------------------\n");
>> -	dev_info(dev, "format: %d\nscale %d\n", mode->format, mode->scale);
>> -	dev_info(dev, "fdec: %d\ncolor %d\n", mode->fdec, mode->color);
>> -	dev_info(dev, "bright: 0x%x\n", mode->bright);
>> -	dev_info(dev, 
>> "------------------------------------------------\n");
>> -}
>> -
>>  /*
>>   * set mode is the function which controls the DSP.
>>   * the restart parameter in struct s2255_mode should be set whenever
>> @@ -1133,28 +1040,28 @@ static void s2255_print_cfg(struct s2255_dev 
>> *sdev, struct s2255_mode *mode)
>>   * When the restart parameter is set, we sleep for ONE frame to 
>> allow the
>>   * DSP time to get the new frame
>>   */
>> -static int s2255_set_mode(struct s2255_channel *channel,
>> +static int s2255_set_mode(struct s2255_vc *vc,
>>  			  struct s2255_mode *mode)
>>  {
>>  	int res;
>>  	__le32 *buffer;
>>  	unsigned long chn_rev;
>> -	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
>> +	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>>  	int i;
>> 
>> -	chn_rev = G_chnmap[channel->idx];
>> -	dprintk(dev, 3, "%s channel: %d\n", __func__, channel->idx);
>> +	chn_rev = G_chnmap[vc->idx];
>> +	dprintk(dev, 3, "%s channel: %d\n", __func__, vc->idx);
>>  	/* if JPEG, set the quality */
>>  	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
>>  		mode->color &= ~MASK_COLOR;
>>  		mode->color |= COLOR_JPG;
>>  		mode->color &= ~MASK_JPG_QUALITY;
>> -		mode->color |= (channel->jpegqual << 8);
>> +		mode->color |= (vc->jpegqual << 8);
>>  	}
>>  	/* save the mode */
>> -	channel->mode = *mode;
>> -	channel->req_image_size = get_transfer_size(mode);
>> -	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, 
>> channel->req_image_size);
>> +	vc->mode = *mode;
>> +	vc->req_image_size = get_transfer_size(mode);
>> +	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, vc->req_image_size);
>>  	buffer = kzalloc(512, GFP_KERNEL);
>>  	if (buffer == NULL) {
>>  		dev_err(&dev->udev->dev, "out of mem\n");
>> @@ -1165,36 +1072,38 @@ static int s2255_set_mode(struct 
>> s2255_channel *channel,
>>  	buffer[1] = (__le32) cpu_to_le32(chn_rev);
>>  	buffer[2] = CMD_SET_MODE;
>>  	for (i = 0; i < sizeof(struct s2255_mode) / sizeof(u32); i++)
>> -		buffer[3 + i] = cpu_to_le32(((u32 *)&channel->mode)[i]);
>> -	channel->setmode_ready = 0;
>> +		buffer[3 + i] = cpu_to_le32(((u32 *)&vc->mode)[i]);
>> +	vc->setmode_ready = 0;
>>  	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
>> -	if (debug)
>> -		s2255_print_cfg(dev, mode);
>> +
>> +	dprintk(dev, 1, "format: %d\nscale %d\n", mode->format, 
>> mode->scale);
>> +	dprintk(dev, 1, "fdec: %d\ncolor %d\n", mode->fdec, mode->color);
>> +
>>  	kfree(buffer);
>>  	/* wait at least 3 frames before continuing */
>>  	if (mode->restart) {
>> -		wait_event_timeout(channel->wait_setmode,
>> -				   (channel->setmode_ready != 0),
>> +		wait_event_timeout(vc->wait_setmode,
>> +				   (vc->setmode_ready != 0),
>>  				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
>> -		if (channel->setmode_ready != 1) {
>> +		if (vc->setmode_ready != 1) {
>>  			dprintk(dev, 0, "s2255: no set mode response\n");
>>  			res = -EFAULT;
>>  		}
>>  	}
>>  	/* clear the restart flag */
>> -	channel->mode.restart = 0;
>> -	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, channel->idx, 
>> res);
>> +	vc->mode.restart = 0;
>> +	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, vc->idx, res);
>>  	return res;
>>  }
>> 
>> -static int s2255_cmd_status(struct s2255_channel *channel, u32 
>> *pstatus)
>> +static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
>>  {
>>  	int res;
>>  	__le32 *buffer;
>>  	u32 chn_rev;
>> -	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
>> -	chn_rev = G_chnmap[channel->idx];
>> -	dprintk(dev, 4, "%s chan %d\n", __func__, channel->idx);
>> +	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>> +	chn_rev = G_chnmap[vc->idx];
>> +	dprintk(dev, 4, "%s chan %d\n", __func__, vc->idx);
>>  	buffer = kzalloc(512, GFP_KERNEL);
>>  	if (buffer == NULL) {
>>  		dev_err(&dev->udev->dev, "out of mem\n");
>> @@ -1205,127 +1114,70 @@ static int s2255_cmd_status(struct 
>> s2255_channel *channel, u32 *pstatus)
>>  	buffer[1] = (__le32) cpu_to_le32(chn_rev);
>>  	buffer[2] = CMD_STATUS;
>>  	*pstatus = 0;
>> -	channel->vidstatus_ready = 0;
>> +	vc->vidstatus_ready = 0;
>>  	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
>>  	kfree(buffer);
>> -	wait_event_timeout(channel->wait_vidstatus,
>> -			   (channel->vidstatus_ready != 0),
>> +	wait_event_timeout(vc->wait_vidstatus,
>> +			   (vc->vidstatus_ready != 0),
>>  			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
>> -	if (channel->vidstatus_ready != 1) {
>> +	if (vc->vidstatus_ready != 1) {
>>  		dprintk(dev, 0, "s2255: no vidstatus response\n");
>>  		res = -EFAULT;
>>  	}
>> -	*pstatus = channel->vidstatus;
>> +	*pstatus = vc->vidstatus;
>>  	dprintk(dev, 4, "%s, vid status %d\n", __func__, *pstatus);
>>  	return res;
>>  }
>> 
>> -static int vidioc_streamon(struct file *file, void *priv, enum 
>> v4l2_buf_type i)
>> -{
>> -	int res;
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_dev *dev = fh->dev;
>> -	struct s2255_channel *channel = fh->channel;
>> -	int j;
>> -	dprintk(dev, 4, "%s\n", __func__);
>> -	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>> -		dev_err(&dev->udev->dev, "invalid fh type0\n");
>> -		return -EINVAL;
>> -	}
>> -	if (i != fh->type) {
>> -		dev_err(&dev->udev->dev, "invalid fh type1\n");
>> -		return -EINVAL;
>> -	}
>> -
>> -	if (!res_get(fh)) {
>> -		s2255_dev_err(&dev->udev->dev, "stream busy\n");
>> -		return -EBUSY;
>> -	}
>> -	channel->last_frame = -1;
>> -	channel->bad_payload = 0;
>> -	channel->cur_frame = 0;
>> -	channel->frame_count = 0;
>> -	for (j = 0; j < SYS_FRAMES; j++) {
>> -		channel->buffer.frame[j].ulState = S2255_READ_IDLE;
>> -		channel->buffer.frame[j].cur_size = 0;
>> -	}
>> -	res = videobuf_streamon(&fh->vb_vidq);
>> -	if (res == 0) {
>> -		s2255_start_acquire(channel);
>> -		channel->b_acquire = 1;
>> -	} else
>> -		res_free(fh);
>> -
>> -	return res;
>> -}
>> -
>> -static int vidioc_streamoff(struct file *file, void *priv, enum 
>> v4l2_buf_type i)
>> -{
>> -	struct s2255_fh *fh = priv;
>> -	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, 
>> fh->channel->idx);
>> -	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>> -		dprintk(fh->dev, 1, "invalid fh type0\n");
>> -		return -EINVAL;
>> -	}
>> -	if (i != fh->type)
>> -		return -EINVAL;
>> -	s2255_stop_acquire(fh->channel);
>> -	videobuf_streamoff(&fh->vb_vidq);
>> -	res_free(fh);
>> -	return 0;
>> -}
>> -
>>  static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id 
>> i)
>>  {
>> -	struct s2255_fh *fh = priv;
>>  	struct s2255_mode mode;
>> -	struct videobuf_queue *q = &fh->vb_vidq;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	struct vb2_queue *q = &vc->vb_vidq;
>>  	int ret = 0;
>> 
>> -	mutex_lock(&q->vb_lock);
>> -	if (res_locked(fh)) {
>> -		dprintk(fh->dev, 1, "can't change standard after started\n");
>> -		ret = -EBUSY;
>> -		goto out_s_std;
>> -	}
>> -	mode = fh->channel->mode;
>> +	/*
>> +	 * Changing the standard implies a format change, which is not 
>> allowed
>> +	 * while buffers for use with streaming have already been 
>> allocated.
>> +	 */
>> +	if (vb2_is_busy(q))
>> +		return -EBUSY;
>> +
>> +	mode = vc->mode;
>>  	if (i & V4L2_STD_525_60) {
>> -		dprintk(fh->dev, 4, "%s 60 Hz\n", __func__);
>> +		dprintk(vc->dev, 4, "%s 60 Hz\n", __func__);
>>  		/* if changing format, reset frame decimation/intervals */
>>  		if (mode.format != FORMAT_NTSC) {
>>  			mode.restart = 1;
>>  			mode.format = FORMAT_NTSC;
>>  			mode.fdec = FDEC_1;
>> -			channel->width = LINE_SZ_4CIFS_NTSC;
>> -			channel->height = NUM_LINES_4CIFS_NTSC * 2;
>> +			vc->width = LINE_SZ_4CIFS_NTSC;
>> +			vc->height = NUM_LINES_4CIFS_NTSC * 2;
>>  		}
>>  	} else if (i & V4L2_STD_625_50) {
>> -		dprintk(fh->dev, 4, "%s 50 Hz\n", __func__);
>> +		dprintk(vc->dev, 4, "%s 50 Hz\n", __func__);
>>  		if (mode.format != FORMAT_PAL) {
>>  			mode.restart = 1;
>>  			mode.format = FORMAT_PAL;
>>  			mode.fdec = FDEC_1;
>> -			channel->width = LINE_SZ_4CIFS_PAL;
>> -			channel->height = NUM_LINES_4CIFS_PAL * 2;
>> +			vc->width = LINE_SZ_4CIFS_PAL;
>> +			vc->height = NUM_LINES_4CIFS_PAL * 2;
>>  		}
>>  	} else {
>>  		ret = -EINVAL;
>>  		goto out_s_std;
>>  	}
>> -	fh->channel->std = i;
>> +	vc->std = i;
>>  	if (mode.restart)
>> -		s2255_set_mode(fh->channel, &mode);
>> +		s2255_set_mode(vc, &mode);
>>  out_s_std:
>> -	mutex_unlock(&q->vb_lock);
>>  	return ret;
>>  }
>> 
>>  static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id 
>> *i)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -
>> -	*i = fh->channel->std;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	*i = vc->std;
>>  	return 0;
>>  }
>> 
>> @@ -1339,9 +1191,8 @@ static int vidioc_g_std(struct file *file, void 
>> *priv, v4l2_std_id *i)
>>  static int vidioc_enum_input(struct file *file, void *priv,
>>  			     struct v4l2_input *inp)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_dev *dev = fh->dev;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	struct s2255_dev *dev = vc->dev;
>>  	u32 status = 0;
>>  	if (inp->index != 0)
>>  		return -EINVAL;
>> @@ -1350,7 +1201,7 @@ static int vidioc_enum_input(struct file *file, 
>> void *priv,
>>  	inp->status = 0;
>>  	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
>>  		int rc;
>> -		rc = s2255_cmd_status(fh->channel, &status);
>> +		rc = s2255_cmd_status(vc, &status);
>>  		dprintk(dev, 4, "s2255_cmd_status rc: %d status %x\n",
>>  			rc, status);
>>  		if (rc == 0)
>> @@ -1363,7 +1214,7 @@ static int vidioc_enum_input(struct file *file, 
>> void *priv,
>>  		strlcpy(inp->name, "Composite", sizeof(inp->name));
>>  		break;
>>  	case 0x2257:
>> -		strlcpy(inp->name, (channel->idx < 2) ? "Composite" : "S-Video",
>> +		strlcpy(inp->name, (vc->idx < 2) ? "Composite" : "S-Video",
>>  			sizeof(inp->name));
>>  		break;
>>  	}
>> @@ -1384,10 +1235,10 @@ static int vidioc_s_input(struct file *file, 
>> void *priv, unsigned int i)
>> 
>>  static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>> -	struct s2255_channel *channel =
>> -		container_of(ctrl->handler, struct s2255_channel, hdl);
>> +	struct s2255_vc *vc =
>> +		container_of(ctrl->handler, struct s2255_vc, hdl);
>>  	struct s2255_mode mode;
>> -	mode = channel->mode;
>> +	mode = vc->mode;
>>  	/* update the mode to the corresponding value */
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_BRIGHTNESS:
>> @@ -1407,7 +1258,7 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
>>  		mode.color |= !ctrl->val << 16;
>>  		break;
>>  	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
>> -		channel->jpegqual = ctrl->val;
>> +		vc->jpegqual = ctrl->val;
>>  		return 0;
>>  	default:
>>  		return -EINVAL;
>> @@ -1417,48 +1268,44 @@ static int s2255_s_ctrl(struct v4l2_ctrl 
>> *ctrl)
>>  	   some V4L programs restart stream unnecessarily
>>  	   after a s_crtl.
>>  	*/
>> -	s2255_set_mode(channel, &mode);
>> +	s2255_set_mode(vc, &mode);
>>  	return 0;
>>  }
>> 
>>  static int vidioc_g_jpegcomp(struct file *file, void *priv,
>>  			 struct v4l2_jpegcompression *jc)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> -
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	memset(jc, 0, sizeof(*jc));
>> -	jc->quality = channel->jpegqual;
>> -	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
>> +	jc->quality = vc->jpegqual;
>> +	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
>>  	return 0;
>>  }
>> 
>>  static int vidioc_s_jpegcomp(struct file *file, void *priv,
>>  			 const struct v4l2_jpegcompression *jc)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	if (jc->quality < 0 || jc->quality > 100)
>>  		return -EINVAL;
>> -	v4l2_ctrl_s_ctrl(channel->jpegqual_ctrl, jc->quality);
>> -	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
>> +	v4l2_ctrl_s_ctrl(vc->jpegqual_ctrl, jc->quality);
>> +	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
>>  	return 0;
>>  }
>> 
>>  static int vidioc_g_parm(struct file *file, void *priv,
>>  			 struct v4l2_streamparm *sp)
>>  {
>> -	struct s2255_fh *fh = priv;
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	__u32 def_num, def_dem;
>> -	struct s2255_channel *channel = fh->channel;
>>  	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>  		return -EINVAL;
>>  	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>> -	sp->parm.capture.capturemode = channel->cap_parm.capturemode;
>> -	def_num = (channel->mode.format == FORMAT_NTSC) ? 1001 : 1000;
>> -	def_dem = (channel->mode.format == FORMAT_NTSC) ? 30000 : 25000;
>> +	sp->parm.capture.capturemode = vc->cap_parm.capturemode;
>> +	def_num = (vc->mode.format == FORMAT_NTSC) ? 1001 : 1000;
>> +	def_dem = (vc->mode.format == FORMAT_NTSC) ? 30000 : 25000;
>>  	sp->parm.capture.timeperframe.denominator = def_dem;
>> -	switch (channel->mode.fdec) {
>> +	switch (vc->mode.fdec) {
>>  	default:
>>  	case FDEC_1:
>>  		sp->parm.capture.timeperframe.numerator = def_num;
>> @@ -1473,7 +1320,7 @@ static int vidioc_g_parm(struct file *file, 
>> void *priv,
>>  		sp->parm.capture.timeperframe.numerator = def_num * 5;
>>  		break;
>>  	}
>> -	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
>> +	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
>>  		__func__,
>>  		sp->parm.capture.capturemode,
>>  		sp->parm.capture.timeperframe.numerator,
>> @@ -1484,18 +1331,19 @@ static int vidioc_g_parm(struct file *file, 
>> void *priv,
>>  static int vidioc_s_parm(struct file *file, void *priv,
>>  			 struct v4l2_streamparm *sp)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	struct s2255_mode mode;
>>  	int fdec = FDEC_1;
>>  	__u32 def_num, def_dem;
>>  	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>  		return -EINVAL;
>> -	mode = channel->mode;
>> +	mode = vc->mode;
>>  	/* high quality capture mode requires a stream restart */
>> -	if (channel->cap_parm.capturemode
>> -	    != sp->parm.capture.capturemode && res_locked(fh))
>> +	if ((vc->cap_parm.capturemode != sp->parm.capture.capturemode)
>> +	    && vb2_is_busy(&vc->vb_vidq))
>>  		return -EBUSY;
>> +
>> +	vc->cap_parm.capturemode = sp->parm.capture.capturemode;
>>  	def_num = (mode.format == FORMAT_NTSC) ? 1001 : 1000;
>>  	def_dem = (mode.format == FORMAT_NTSC) ? 30000 : 25000;
>>  	if (def_dem != sp->parm.capture.timeperframe.denominator)
>> @@ -1514,8 +1362,8 @@ static int vidioc_s_parm(struct file *file, 
>> void *priv,
>>  	}
>>  	mode.fdec = fdec;
>>  	sp->parm.capture.timeperframe.denominator = def_dem;
>> -	s2255_set_mode(channel, &mode);
>> -	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec 
>> %d\n",
>> +	s2255_set_mode(vc, &mode);
>> +	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec 
>> %d\n",
>>  		__func__,
>>  		sp->parm.capture.capturemode,
>>  		sp->parm.capture.timeperframe.numerator,
>> @@ -1538,9 +1386,8 @@ static const struct v4l2_frmsize_discrete 
>> pal_sizes[] = {
>>  static int vidioc_enum_framesizes(struct file *file, void *priv,
>>  			    struct v4l2_frmsizeenum *fe)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> -	int is_ntsc = channel->std & V4L2_STD_525_60;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	int is_ntsc = vc->std & V4L2_STD_525_60;
>>  	const struct s2255_fmt *fmt;
>> 
>>  	if (fe->index >= NUM_SIZE_ENUMS)
>> @@ -1557,11 +1404,10 @@ static int vidioc_enum_framesizes(struct file 
>> *file, void *priv,
>>  static int vidioc_enum_frameintervals(struct file *file, void *priv,
>>  			    struct v4l2_frmivalenum *fe)
>>  {
>> -	struct s2255_fh *fh = priv;
>> -	struct s2255_channel *channel = fh->channel;
>> +	struct s2255_vc *vc = video_drvdata(file);
>>  	const struct s2255_fmt *fmt;
>>  	const struct v4l2_frmsize_discrete *sizes;
>> -	int is_ntsc = channel->std & V4L2_STD_525_60;
>> +	int is_ntsc = vc->std & V4L2_STD_525_60;
>>  #define NUM_FRAME_ENUMS 4
>>  	int frm_dec[NUM_FRAME_ENUMS] = {1, 2, 3, 5};
>>  	int i;
>> @@ -1584,22 +1430,25 @@ static int vidioc_enum_frameintervals(struct 
>> file *file, void *priv,
>>  	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>>  	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
>>  	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * 
>> frm_dec[fe->index];
>> -	dprintk(fh->dev, 4, "%s discrete %d/%d\n", __func__,
>> +	dprintk(vc->dev, 4, "%s discrete %d/%d\n", __func__,
>>  		fe->discrete.numerator,
>>  		fe->discrete.denominator);
>>  	return 0;
>>  }
>> 
>> -static int __s2255_open(struct file *file)
>> +static int s2255_open(struct file *file)
>>  {
>> -	struct video_device *vdev = video_devdata(file);
>> -	struct s2255_channel *channel = video_drvdata(file);
>> -	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
>> -	struct s2255_fh *fh;
>> -	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	struct s2255_vc *vc = video_drvdata(file);
>> +	struct s2255_dev *dev = vc->dev;
>>  	int state;
>> -	dprintk(dev, 1, "s2255: open called (dev=%s)\n",
>> -		video_device_node_name(vdev));
>> +	int rc = 0;
>> +
>> +	/* allocate + initialize per filehandle data */
>> +	rc = v4l2_fh_open(file);
>> +	if (rc != 0)
>> +		return rc;
>> +
>> +	/* load firmware */
>>  	state = atomic_read(&dev->fw_data->fw_state);
>>  	switch (state) {
>>  	case S2255_FW_DISCONNECTING:
>> @@ -1661,66 +1510,23 @@ static int __s2255_open(struct file *file)
>>  		pr_info("%s: unknown state\n", __func__);
>>  		return -EFAULT;
>>  	}
>> -	/* allocate + initialize per filehandle data */
>> -	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
>> -	if (NULL == fh)
>> -		return -ENOMEM;
>> -	v4l2_fh_init(&fh->fh, vdev);
>> -	v4l2_fh_add(&fh->fh);
>> -	file->private_data = &fh->fh;
>> -	fh->dev = dev;
>> -	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> -	fh->channel = channel;
>> -	if (!channel->configured) {
>> +
>> +	if (!vc->configured) {
>> +		int rc;
>>  		/* configure channel to default state */
>> -		channel->fmt = &formats[0];
>> -		s2255_set_mode(channel, &channel->mode);
>> -		channel->configured = 1;
>> -	}
>> -	dprintk(dev, 1, "%s: dev=%s type=%s\n", __func__,
>> -		video_device_node_name(vdev), v4l2_type_names[type]);
>> -	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", 
>> __func__,
>> -		(unsigned long)fh, (unsigned long)dev,
>> -		(unsigned long)&channel->vidq);
>> -	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
>> -		list_empty(&channel->vidq.active));
>> -	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
>> -				    NULL, &dev->slock,
>> -				    fh->type,
>> -				    V4L2_FIELD_INTERLACED,
>> -				    sizeof(struct s2255_buffer),
>> -				    fh, vdev->lock);
>> +		vc->fmt = &formats[0];
>> +		rc = s2255_set_mode(vc, &vc->mode);
>> +		if (rc != 0) {
>> +			/* resend set mode. */
>> +			rc = s2255_set_mode(vc, &vc->mode);
>> +		}
>> +		if (rc == 0)
>> +			vc->configured = 1;
>> +	}
>> +	dprintk(dev, 2, "%s:\n", __func__);
>>  	return 0;
>>  }
>> 
>> -static int s2255_open(struct file *file)
>> -{
>> -	struct video_device *vdev = video_devdata(file);
>> -	int ret;
>> -
>> -	if (mutex_lock_interruptible(vdev->lock))
>> -		return -ERESTARTSYS;
>> -	ret = __s2255_open(file);
>> -	mutex_unlock(vdev->lock);
>> -	return ret;
>> -}
>> -
>> -static unsigned int s2255_poll(struct file *file,
>> -			       struct poll_table_struct *wait)
>> -{
>> -	struct s2255_fh *fh = file->private_data;
>> -	struct s2255_dev *dev = fh->dev;
>> -	int rc = v4l2_ctrl_poll(file, wait);
>> -
>> -	dprintk(dev, 100, "%s\n", __func__);
>> -	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
>> -		return POLLERR;
>> -	mutex_lock(&dev->lock);
>> -	rc |= videobuf_poll_stream(file, &fh->vb_vidq, wait);
>> -	mutex_unlock(&dev->lock);
>> -	return rc;
>> -}
>> -
>>  static void s2255_destroy(struct s2255_dev *dev)
>>  {
>>  	dprintk(dev, 1, "%s", __func__);
>> @@ -1744,57 +1550,14 @@ static void s2255_destroy(struct s2255_dev 
>> *dev)
>>  	kfree(dev);
>>  }
>> 
>> -static int s2255_release(struct file *file)
>> -{
>> -	struct s2255_fh *fh = file->private_data;
>> -	struct s2255_dev *dev = fh->dev;
>> -	struct video_device *vdev = video_devdata(file);
>> -	struct s2255_channel *channel = fh->channel;
>> -	if (!dev)
>> -		return -ENODEV;
>> -	mutex_lock(&dev->lock);
>> -	/* turn off stream */
>> -	if (res_check(fh)) {
>> -		if (channel->b_acquire)
>> -			s2255_stop_acquire(fh->channel);
>> -		videobuf_streamoff(&fh->vb_vidq);
>> -		res_free(fh);
>> -	}
>> -	videobuf_mmap_free(&fh->vb_vidq);
>> -	mutex_unlock(&dev->lock);
>> -	dprintk(dev, 1, "%s[%s]\n", __func__, 
>> video_device_node_name(vdev));
>> -	v4l2_fh_del(&fh->fh);
>> -	v4l2_fh_exit(&fh->fh);
>> -	kfree(fh);
>> -	return 0;
>> -}
>> -
>> -static int s2255_mmap_v4l(struct file *file, struct vm_area_struct 
>> *vma)
>> -{
>> -	struct s2255_fh *fh = file->private_data;
>> -	struct s2255_dev *dev;
>> -	int ret;
>> -	if (!fh)
>> -		return -ENODEV;
>> -	dev = fh->dev;
>> -	dprintk(dev, 4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
>> -	if (mutex_lock_interruptible(&dev->lock))
>> -		return -ERESTARTSYS;
>> -	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
>> -	mutex_unlock(&dev->lock);
>> -	dprintk(dev, 4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", 
>> __func__,
>> -		(unsigned long)vma->vm_start,
>> -		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
>> -	return ret;
>> -}
>> -
>>  static const struct v4l2_file_operations s2255_fops_v4l = {
>>  	.owner = THIS_MODULE,
>>  	.open = s2255_open,
>> -	.release = s2255_release,
>> -	.poll = s2255_poll,
>> -	.unlocked_ioctl = video_ioctl2,	/* V4L2 ioctl handler */
>> -	.mmap = s2255_mmap_v4l,
>> +	.release = vb2_fop_release,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.read = vb2_fop_read,
>> +	.mmap = vb2_fop_mmap,
>> +	.poll = vb2_fop_poll,
>>  };
>> 
>>  static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
>> @@ -1803,17 +1566,17 @@ static const struct v4l2_ioctl_ops 
>> s2255_ioctl_ops = {
>>  	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
>>  	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
>>  	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
>> -	.vidioc_reqbufs = vidioc_reqbufs,
>> -	.vidioc_querybuf = vidioc_querybuf,
>> -	.vidioc_qbuf = vidioc_qbuf,
>> -	.vidioc_dqbuf = vidioc_dqbuf,
>> +	.vidioc_reqbufs =  vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>>  	.vidioc_s_std = vidioc_s_std,
>>  	.vidioc_g_std = vidioc_g_std,
>>  	.vidioc_enum_input = vidioc_enum_input,
>>  	.vidioc_g_input = vidioc_g_input,
>>  	.vidioc_s_input = vidioc_s_input,
>> -	.vidioc_streamon = vidioc_streamon,
>> -	.vidioc_streamoff = vidioc_streamoff,
>> +	.vidioc_streamon = vb2_ioctl_streamon,
>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>>  	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
>>  	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
>>  	.vidioc_s_parm = vidioc_s_parm,
>> @@ -1828,13 +1591,13 @@ static const struct v4l2_ioctl_ops 
>> s2255_ioctl_ops = {
>>  static void s2255_video_device_release(struct video_device *vdev)
>>  {
>>  	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
>> -	struct s2255_channel *channel =
>> -		container_of(vdev, struct s2255_channel, vdev);
>> +	struct s2255_vc *vc =
>> +		container_of(vdev, struct s2255_vc, vdev);
>> 
>>  	dprintk(dev, 4, "%s, chnls: %d\n", __func__,
>>  		atomic_read(&dev->num_channels));
>> 
>> -	v4l2_ctrl_handler_free(&channel->hdl);
>> +	v4l2_ctrl_handler_free(&vc->hdl);
>> 
>>  	if (atomic_dec_and_test(&dev->num_channels))
>>  		s2255_destroy(dev);
>> @@ -1868,64 +1631,82 @@ static int s2255_probe_v4l(struct s2255_dev 
>> *dev)
>>  	int ret;
>>  	int i;
>>  	int cur_nr = video_nr;
>> -	struct s2255_channel *channel;
>> +	struct vb2_queue *q;
>> +	struct s2255_vc *vc;
>>  	ret = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
>>  	if (ret)
>>  		return ret;
>>  	/* initialize all video 4 linux */
>>  	/* register 4 video devices */
>>  	for (i = 0; i < MAX_CHANNELS; i++) {
>> -		channel = &dev->channel[i];
>> -		INIT_LIST_HEAD(&channel->vidq.active);
>> +		vc = &dev->vc[i];
>> +		INIT_LIST_HEAD(&vc->buf_list);
>> 
>> -		v4l2_ctrl_handler_init(&channel->hdl, 6);
>> -		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
>> +		v4l2_ctrl_handler_init(&vc->hdl, 6);
>> +		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
>>  				V4L2_CID_BRIGHTNESS, -127, 127, 1, DEF_BRIGHT);
>> -		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
>> +		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
>>  				V4L2_CID_CONTRAST, 0, 255, 1, DEF_CONTRAST);
>> -		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
>> +		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
>>  				V4L2_CID_SATURATION, 0, 255, 1, DEF_SATURATION);
>> -		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
>> +		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
>>  				V4L2_CID_HUE, 0, 255, 1, DEF_HUE);
>> -		channel->jpegqual_ctrl = v4l2_ctrl_new_std(&channel->hdl,
>> +		vc->jpegqual_ctrl = v4l2_ctrl_new_std(&vc->hdl,
>>  				&s2255_ctrl_ops,
>>  				V4L2_CID_JPEG_COMPRESSION_QUALITY,
>>  				0, 100, 1, S2255_DEF_JPEG_QUAL);
>>  		if (dev->dsp_fw_ver >= S2255_MIN_DSP_COLORFILTER &&
>> -		    (dev->pid != 0x2257 || channel->idx <= 1))
>> -			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl,
>> +		    (dev->pid != 0x2257 || vc->idx <= 1))
>> +			v4l2_ctrl_new_custom(&vc->hdl, &color_filter_ctrl,
>>  					     NULL);
>> -		if (channel->hdl.error) {
>> -			ret = channel->hdl.error;
>> -			v4l2_ctrl_handler_free(&channel->hdl);
>> +		if (vc->hdl.error) {
>> +			ret = vc->hdl.error;
>> +			v4l2_ctrl_handler_free(&vc->hdl);
>>  			dev_err(&dev->udev->dev, "couldn't register control\n");
>>  			break;
>>  		}
>> -		channel->vidq.dev = dev;
>> +		q = &vc->vb_vidq;
>> +		memset(q, 0, sizeof(vc->vb_vidq));
>> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +		q->io_modes = VB2_MMAP | VB2_READ;
> 
> You can add VB2_USERPTR here as well, that should work out-of-the-box.
> 
>> +		q->drv_priv = vc;
>> +		q->lock = &vc->vb_lock;
>> +		q->buf_struct_size = sizeof(struct s2255_buffer);
>> +		q->mem_ops = &vb2_vmalloc_memops;
>> +		q->ops = &s2255_video_qops;
>> +		q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +		ret = vb2_queue_init(q);
>> +		if (ret != 0) {
>> +			dev_err(&dev->udev->dev,
>> +				"%s vb2_queue_init err: 0x%x\n", __func__, ret);
>> +			break;
>> +		}
>>  		/* register 4 video devices */
>> -		channel->vdev = template;
>> -		channel->vdev.ctrl_handler = &channel->hdl;
>> -		channel->vdev.lock = &dev->lock;
>> -		channel->vdev.v4l2_dev = &dev->v4l2_dev;
>> -		set_bit(V4L2_FL_USE_FH_PRIO, &channel->vdev.flags);
>> -		video_set_drvdata(&channel->vdev, channel);
>> +		vc->vdev = template;
>> +		vc->vdev.queue = q;
>> +		vc->vdev.ctrl_handler = &vc->hdl;
>> +		/* main device lock */
>> +		vc->vdev.lock = &dev->lock;
>> +		vc->vdev.v4l2_dev = &dev->v4l2_dev;
>> +		set_bit(V4L2_FL_USE_FH_PRIO, &vc->vdev.flags);
>> +		video_set_drvdata(&vc->vdev, vc);
>>  		if (video_nr == -1)
>> -			ret = video_register_device(&channel->vdev,
>> +			ret = video_register_device(&vc->vdev,
>>  						    VFL_TYPE_GRABBER,
>>  						    video_nr);
>>  		else
>> -			ret = video_register_device(&channel->vdev,
>> +			ret = video_register_device(&vc->vdev,
>>  						    VFL_TYPE_GRABBER,
>>  						    cur_nr + i);
>> 
>>  		if (ret) {
>>  			dev_err(&dev->udev->dev,
>> -				"failed to register video device!\n");
>> +				"failed to register vid device: 0x%x!\n", ret);
>>  			break;
>>  		}
>>  		atomic_inc(&dev->num_channels);
>>  		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
>> -			  video_device_node_name(&channel->vdev));
>> +			  video_device_node_name(&vc->vdev));
>> 
>>  	}
>>  	pr_info("Sensoray 2255 V4L driver Revision: %s\n",
>> @@ -1962,11 +1743,11 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  	s32 idx = -1;
>>  	struct s2255_framei *frm;
>>  	unsigned char *pdata;
>> -	struct s2255_channel *ch;
>> +	struct s2255_vc *vc;
>>  	dprintk(dev, 100, "buffer to user\n");
>> -	ch = &dev->channel[dev->cc];
>> -	idx = ch->cur_frame;
>> -	frm = &ch->buffer.frame[idx];
>> +	vc = &dev->vc[dev->cc];
>> +	idx = vc->cur_frame;
>> +	frm = &vc->buffer.frame[idx];
>>  	if (frm->ulState == S2255_READ_IDLE) {
>>  		int jj;
>>  		unsigned int cc;
>> @@ -1990,15 +1771,15 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  				}
>>  				/* reverse it */
>>  				dev->cc = G_chnmap[cc];
>> -				ch = &dev->channel[dev->cc];
>> +				vc = &dev->vc[dev->cc];
>>  				payload =  le32_to_cpu(pdword[3]);
>> -				if (payload > ch->req_image_size) {
>> -					ch->bad_payload++;
>> +				if (payload > vc->req_image_size) {
>> +					vc->bad_payload++;
>>  					/* discard the bad frame */
>>  					return -EINVAL;
>>  				}
>> -				ch->pkt_size = payload;
>> -				ch->jpg_size = le32_to_cpu(pdword[4]);
>> +				vc->pkt_size = payload;
>> +				vc->jpg_size = le32_to_cpu(pdword[4]);
>>  				break;
>>  			case S2255_MARKER_RESPONSE:
>> 
>> @@ -2009,13 +1790,13 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  				cc = G_chnmap[le32_to_cpu(pdword[1])];
>>  				if (cc >= MAX_CHANNELS)
>>  					break;
>> -				ch = &dev->channel[cc];
>> +				vc = &dev->vc[cc];
>>  				switch (pdword[2]) {
>>  				case S2255_RESPONSE_SETMODE:
>>  					/* check if channel valid */
>>  					/* set mode ready */
>> -					ch->setmode_ready = 1;
>> -					wake_up(&ch->wait_setmode);
>> +					vc->setmode_ready = 1;
>> +					wake_up(&vc->wait_setmode);
>>  					dprintk(dev, 5, "setmode rdy %d\n", cc);
>>  					break;
>>  				case S2255_RESPONSE_FW:
>> @@ -2029,9 +1810,9 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  					wake_up(&dev->fw_data->wait_fw);
>>  					break;
>>  				case S2255_RESPONSE_STATUS:
>> -					ch->vidstatus = le32_to_cpu(pdword[3]);
>> -					ch->vidstatus_ready = 1;
>> -					wake_up(&ch->wait_vidstatus);
>> +					vc->vidstatus = le32_to_cpu(pdword[3]);
>> +					vc->vidstatus_ready = 1;
>> +					wake_up(&vc->wait_vidstatus);
>>  					dprintk(dev, 5, "vstat %x chan %d\n",
>>  						le32_to_cpu(pdword[3]), cc);
>>  					break;
>> @@ -2048,11 +1829,12 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  		if (!bframe)
>>  			return -EINVAL;
>>  	}
>> -	ch = &dev->channel[dev->cc];
>> -	idx = ch->cur_frame;
>> -	frm = &ch->buffer.frame[idx];
>> +	vc = &dev->vc[dev->cc];
>> +	idx = vc->cur_frame;
>> +	frm = &vc->buffer.frame[idx];
>> +
>>  	/* search done.  now find out if should be acquiring on this 
>> channel */
>> -	if (!ch->b_acquire) {
>> +	if (!vb2_is_streaming(&vc->vb_vidq)) {
>>  		/* we found a frame, but this channel is turned off */
>>  		frm->ulState = S2255_READ_IDLE;
>>  		return -EINVAL;
>> @@ -2066,7 +1848,6 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  	/* skip the marker 512 bytes (and offset if out of sync) */
>>  	psrc = (u8 *)pipe_info->transfer_buffer + offset;
>> 
>> -
>>  	if (frm->lpvbits == NULL) {
>>  		dprintk(dev, 1, "s2255 frame buffer == NULL.%p %p %d %d",
>>  			frm, dev, dev->cc, idx);
>> @@ -2074,13 +1855,11 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  	}
>> 
>>  	pdest = frm->lpvbits + frm->cur_size;
>> -
>>  	copy_size = (pipe_info->cur_transfer_size - offset);
>> -
>> -	size = ch->pkt_size - PREFIX_SIZE;
>> +	size = vc->pkt_size - PREFIX_SIZE;
>> 
>>  	/* sanity check on pdest */
>> -	if ((copy_size + frm->cur_size) < ch->req_image_size)
>> +	if ((copy_size + frm->cur_size) < vc->req_image_size)
>>  		memcpy(pdest, psrc, copy_size);
>> 
>>  	frm->cur_size += copy_size;
>> @@ -2089,19 +1868,18 @@ static int save_frame(struct s2255_dev *dev, 
>> struct s2255_pipeinfo *pipe_info)
>>  	if (frm->cur_size >= size) {
>>  		dprintk(dev, 2, "******[%d]Buffer[%d]full*******\n",
>>  			dev->cc, idx);
>> -		ch->last_frame = ch->cur_frame;
>> -		ch->cur_frame++;
>> +		vc->last_frame = vc->cur_frame;
>> +		vc->cur_frame++;
>>  		/* end of system frame ring buffer, start at zero */
>> -		if ((ch->cur_frame == SYS_FRAMES) ||
>> -		    (ch->cur_frame == ch->buffer.dwFrames))
>> -			ch->cur_frame = 0;
>> +		if ((vc->cur_frame == SYS_FRAMES) ||
>> +		    (vc->cur_frame == vc->buffer.dwFrames))
>> +			vc->cur_frame = 0;
>>  		/* frame ready */
>> -		if (ch->b_acquire)
>> -			s2255_got_frame(ch, ch->jpg_size);
>> -		ch->frame_count++;
>> +		if (vb2_is_streaming(&vc->vb_vidq))
>> +			s2255_got_frame(vc, vc->jpg_size);
>> +		vc->frame_count++;
>>  		frm->ulState = S2255_READ_IDLE;
>>  		frm->cur_size = 0;
>> -
>>  	}
>>  	/* done successfully */
>>  	return 0;
>> @@ -2121,7 +1899,7 @@ static void s2255_read_video_callback(struct 
>> s2255_dev *dev,
>>  	/* otherwise copy to the system buffers */
>>  	res = save_frame(dev, pipe_info);
>>  	if (res != 0)
>> -		dprintk(dev, 4, "s2255: read callback failed\n");
>> +		dprintk(dev, 50, "s2255: read callback: %d\n", res);
>> 
>>  	dprintk(dev, 50, "callback read video done\n");
>>  	return;
>> @@ -2171,11 +1949,11 @@ static int s2255_get_fx2fw(struct s2255_dev 
>> *dev)
>>   * Create the system ring buffer to copy frames into from the
>>   * usb read pipe.
>>   */
>> -static int s2255_create_sys_buffers(struct s2255_channel *channel)
>> +static int s2255_create_sys_buffers(struct s2255_vc *vc)
>>  {
>>  	unsigned long i;
>>  	unsigned long reqsize;
>> -	channel->buffer.dwFrames = SYS_FRAMES;
>> +	vc->buffer.dwFrames = SYS_FRAMES;
>>  	/* always allocate maximum size(PAL) for system buffers */
>>  	reqsize = SYS_FRAMES_MAXSIZE;
>> 
>> @@ -2184,33 +1962,33 @@ static int s2255_create_sys_buffers(struct 
>> s2255_channel *channel)
>> 
>>  	for (i = 0; i < SYS_FRAMES; i++) {
>>  		/* allocate the frames */
>> -		channel->buffer.frame[i].lpvbits = vmalloc(reqsize);
>> -		channel->buffer.frame[i].size = reqsize;
>> -		if (channel->buffer.frame[i].lpvbits == NULL) {
>> +		vc->buffer.frame[i].lpvbits = vmalloc(reqsize);
>> +		vc->buffer.frame[i].size = reqsize;
>> +		if (vc->buffer.frame[i].lpvbits == NULL) {
>>  			pr_info("out of memory.  using less frames\n");
>> -			channel->buffer.dwFrames = i;
>> +			vc->buffer.dwFrames = i;
>>  			break;
>>  		}
>>  	}
>> 
>>  	/* make sure internal states are set */
>>  	for (i = 0; i < SYS_FRAMES; i++) {
>> -		channel->buffer.frame[i].ulState = 0;
>> -		channel->buffer.frame[i].cur_size = 0;
>> +		vc->buffer.frame[i].ulState = 0;
>> +		vc->buffer.frame[i].cur_size = 0;
>>  	}
>> 
>> -	channel->cur_frame = 0;
>> -	channel->last_frame = -1;
>> +	vc->cur_frame = 0;
>> +	vc->last_frame = -1;
>>  	return 0;
>>  }
>> 
>> -static int s2255_release_sys_buffers(struct s2255_channel *channel)
>> +static int s2255_release_sys_buffers(struct s2255_vc *vc)
>>  {
>>  	unsigned long i;
>>  	for (i = 0; i < SYS_FRAMES; i++) {
>> -		if (channel->buffer.frame[i].lpvbits)
>> -			vfree(channel->buffer.frame[i].lpvbits);
>> -		channel->buffer.frame[i].lpvbits = NULL;
>> +		if (vc->buffer.frame[i].lpvbits)
>> +			vfree(vc->buffer.frame[i].lpvbits);
>> +		vc->buffer.frame[i].lpvbits = NULL;
>>  	}
>>  	return 0;
>>  }
>> @@ -2244,21 +2022,20 @@ static int s2255_board_init(struct s2255_dev 
>> *dev)
>>  		pr_info("s2255: newer USB firmware available\n");
>> 
>>  	for (j = 0; j < MAX_CHANNELS; j++) {
>> -		struct s2255_channel *channel = &dev->channel[j];
>> -		channel->b_acquire = 0;
>> -		channel->mode = mode_def;
>> +		struct s2255_vc *vc = &dev->vc[j];
>> +		vc->mode = mode_def;
>>  		if (dev->pid == 0x2257 && j > 1)
>> -			channel->mode.color |= (1 << 16);
>> -		channel->jpegqual = S2255_DEF_JPEG_QUAL;
>> -		channel->width = LINE_SZ_4CIFS_NTSC;
>> -		channel->height = NUM_LINES_4CIFS_NTSC * 2;
>> -		channel->std = V4L2_STD_NTSC_M;
>> -		channel->fmt = &formats[0];
>> -		channel->mode.restart = 1;
>> -		channel->req_image_size = get_transfer_size(&mode_def);
>> -		channel->frame_count = 0;
>> +			vc->mode.color |= (1 << 16);
>> +		vc->jpegqual = S2255_DEF_JPEG_QUAL;
>> +		vc->width = LINE_SZ_4CIFS_NTSC;
>> +		vc->height = NUM_LINES_4CIFS_NTSC * 2;
>> +		vc->std = V4L2_STD_NTSC_M;
>> +		vc->fmt = &formats[0];
>> +		vc->mode.restart = 1;
>> +		vc->req_image_size = get_transfer_size(&mode_def);
>> +		vc->frame_count = 0;
>>  		/* create the system buffers */
>> -		s2255_create_sys_buffers(channel);
>> +		s2255_create_sys_buffers(vc);
>>  	}
>>  	/* start read pipe */
>>  	s2255_start_readpipe(dev);
>> @@ -2270,14 +2047,13 @@ static int s2255_board_shutdown(struct 
>> s2255_dev *dev)
>>  {
>>  	u32 i;
>>  	dprintk(dev, 1, "%s: dev: %p", __func__,  dev);
>> -
>>  	for (i = 0; i < MAX_CHANNELS; i++) {
>> -		if (dev->channel[i].b_acquire)
>> -			s2255_stop_acquire(&dev->channel[i]);
>> +		if (vb2_is_streaming(&dev->vc[i].vb_vidq))
>> +			s2255_stop_acquire(&dev->vc[i]);
>>  	}
>>  	s2255_stop_readpipe(dev);
>>  	for (i = 0; i < MAX_CHANNELS; i++)
>> -		s2255_release_sys_buffers(&dev->channel[i]);
>> +		s2255_release_sys_buffers(&dev->vc[i]);
>>  	/* release transfer buffer */
>>  	kfree(dev->pipe.transfer_buffer);
>>  	return 0;
>> @@ -2366,26 +2142,26 @@ static int s2255_start_readpipe(struct 
>> s2255_dev *dev)
>>  }
>> 
>>  /* starts acquisition process */
>> -static int s2255_start_acquire(struct s2255_channel *channel)
>> +static int s2255_start_acquire(struct s2255_vc *vc)
>>  {
>>  	unsigned char *buffer;
>>  	int res;
>>  	unsigned long chn_rev;
>>  	int j;
>> -	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
>> -	chn_rev = G_chnmap[channel->idx];
>> +	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>> +	chn_rev = G_chnmap[vc->idx];
>>  	buffer = kzalloc(512, GFP_KERNEL);
>>  	if (buffer == NULL) {
>>  		dev_err(&dev->udev->dev, "out of mem\n");
>>  		return -ENOMEM;
>>  	}
>> 
>> -	channel->last_frame = -1;
>> -	channel->bad_payload = 0;
>> -	channel->cur_frame = 0;
>> +	vc->last_frame = -1;
>> +	vc->bad_payload = 0;
>> +	vc->cur_frame = 0;
>>  	for (j = 0; j < SYS_FRAMES; j++) {
>> -		channel->buffer.frame[j].ulState = 0;
>> -		channel->buffer.frame[j].cur_size = 0;
>> +		vc->buffer.frame[j].ulState = 0;
>> +		vc->buffer.frame[j].cur_size = 0;
>>  	}
>> 
>>  	/* send the start command */
>> @@ -2396,18 +2172,18 @@ static int s2255_start_acquire(struct 
>> s2255_channel *channel)
>>  	if (res != 0)
>>  		dev_err(&dev->udev->dev, "CMD_START error\n");
>> 
>> -	dprintk(dev, 2, "start acquire exit[%d] %d\n", channel->idx, res);
>> +	dprintk(dev, 2, "start acquire exit[%d] %d\n", vc->idx, res);
>>  	kfree(buffer);
>>  	return 0;
>>  }
>> 
>> -static int s2255_stop_acquire(struct s2255_channel *channel)
>> +static int s2255_stop_acquire(struct s2255_vc *vc)
>>  {
>>  	unsigned char *buffer;
>>  	int res;
>>  	unsigned long chn_rev;
>> -	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
>> -	chn_rev = G_chnmap[channel->idx];
>> +	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>> +	chn_rev = G_chnmap[vc->idx];
>>  	buffer = kzalloc(512, GFP_KERNEL);
>>  	if (buffer == NULL) {
>>  		dev_err(&dev->udev->dev, "out of mem\n");
>> @@ -2421,8 +2197,7 @@ static int s2255_stop_acquire(struct 
>> s2255_channel *channel)
>>  	if (res != 0)
>>  		dev_err(&dev->udev->dev, "CMD_STOP error\n");
>>  	kfree(buffer);
>> -	channel->b_acquire = 0;
>> -	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, channel->idx, 
>> res);
>> +	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, vc->idx, res);
>>  	return res;
>>  }
>> 
>> @@ -2512,11 +2287,13 @@ static int s2255_probe(struct usb_interface 
>> *interface,
>>  	dev->timer.data = (unsigned long)dev->fw_data;
>>  	init_waitqueue_head(&dev->fw_data->wait_fw);
>>  	for (i = 0; i < MAX_CHANNELS; i++) {
>> -		struct s2255_channel *channel = &dev->channel[i];
>> -		channel->idx = i;
>> -		channel->dev = dev;
>> -		init_waitqueue_head(&channel->wait_setmode);
>> -		init_waitqueue_head(&channel->wait_vidstatus);
>> +		struct s2255_vc *vc = &dev->vc[i];
>> +		vc->idx = i;
>> +		vc->dev = dev;
>> +		init_waitqueue_head(&vc->wait_setmode);
>> +		init_waitqueue_head(&vc->wait_vidstatus);
>> +		spin_lock_init(&vc->qlock);
>> +		mutex_init(&vc->vb_lock);
>>  	}
>> 
>>  	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
>> @@ -2562,8 +2339,7 @@ static int s2255_probe(struct usb_interface 
>> *interface,
>>  	retval = s2255_board_init(dev);
>>  	if (retval)
>>  		goto errorBOARDINIT;
>> -	spin_lock_init(&dev->slock);
>> -	s2255_fwload_start(dev, 0);
>> +	s2255_fwload_start(dev, 1);
>>  	/* loads v4l specific */
>>  	retval = s2255_probe_v4l(dev);
>>  	if (retval)
>> @@ -2604,15 +2380,15 @@ static void s2255_disconnect(struct 
>> usb_interface *interface)
>>  	atomic_inc(&dev->num_channels);
>>  	/* unregister each video device. */
>>  	for (i = 0; i < channels; i++)
>> -		video_unregister_device(&dev->channel[i].vdev);
>> +		video_unregister_device(&dev->vc[i].vdev);
>>  	/* wake up any of our timers */
>>  	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
>>  	wake_up(&dev->fw_data->wait_fw);
>>  	for (i = 0; i < MAX_CHANNELS; i++) {
>> -		dev->channel[i].setmode_ready = 1;
>> -		wake_up(&dev->channel[i].wait_setmode);
>> -		dev->channel[i].vidstatus_ready = 1;
>> -		wake_up(&dev->channel[i].wait_vidstatus);
>> +		dev->vc[i].setmode_ready = 1;
>> +		wake_up(&dev->vc[i].wait_setmode);
>> +		dev->vc[i].vidstatus_ready = 1;
>> +		wake_up(&dev->vc[i].wait_vidstatus);
>>  	}
>>  	if (atomic_dec_and_test(&dev->num_channels))
>>  		s2255_destroy(dev);
>> 
> 
> Regards,
> 
> 	Hans
