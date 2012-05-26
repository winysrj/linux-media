Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35629 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2EZTbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 15:31:18 -0400
Received: by wibhn6 with SMTP id hn6so550636wib.1
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 12:31:16 -0700 (PDT)
Message-ID: <4FC12F82.6040705@gmail.com>
Date: Sat, 26 May 2012 21:31:14 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@redhat.com,
	linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
References: <201205261950.06022.hverkuil@xs4all.nl>
In-Reply-To: <201205261950.06022.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 05/26/2012 07:50 PM, Hans Verkuil wrote:
>> +/*
>> + * IOCTL vidioc handling
>> + */
>> +static int vidioc_reqbufs(struct file *file, void *priv,
>> +			  struct v4l2_requestbuffers *p)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_reqbufs(&dev->vb_vidq, p);
>> +}
>> +
>> +static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_querybuf(&dev->vb_vidq, p);
>> +}
>> +
>> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_qbuf(&dev->vb_vidq, p);
>> +}
>> +
>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
>> +}
>> +
>> +static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_streamon(&dev->vb_vidq, i);
>> +}
>> +
>> +static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +	return vb2_streamoff(&dev->vb_vidq, i);
>> +}
>> +
>> +static int vidioc_querycap(struct file *file,
>> +		void *priv, struct v4l2_capability *dev)
>> +{
>> +	strcpy(dev->driver, "stk1160");
>> +	strcpy(dev->card, "stk1160");
>> +	dev->version = STK1160_VERSION_NUM;

You can drop this line, it's overwritten with KERNEL_VERSION in v4l2-ioctl.c.
Also I could imagine there might be better names, than "dev", for capabilities.

>> +	dev->capabilities =
>> +		V4L2_CAP_VIDEO_CAPTURE |
>> +		V4L2_CAP_STREAMING |
>> +		V4L2_CAP_READWRITE;
>> +	return 0;
>> +}
>> +
>> +static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>> +		struct v4l2_fmtdesc *f)
>> +{
>> +	if (f->index != 0)
>> +		return -EINVAL;
>> +
>> +	strlcpy(f->description, format[f->index].name, sizeof(f->description));
>> +	f->pixelformat = format[f->index].fourcc;
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +					struct v4l2_format *f)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +
>> +	f->fmt.pix.width = dev->width;
>> +	f->fmt.pix.height = dev->height;
>> +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +	f->fmt.pix.pixelformat = dev->fmt->fourcc;
>> +	f->fmt.pix.bytesperline = dev->width<<  1;
                                  ^^^^^^^^^^^^^^^^
Probably better to just write: dev->width * 2.

>> +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
>> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +			struct v4l2_format *f)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +
>> +	if (f->fmt.pix.pixelformat != format[0].fourcc) {

I would rename format[] to stk1160_formats[], but it might just be me.

>> +		stk1160_err("fourcc format 0x%08x invalid\n",
>> +			f->fmt.pix.pixelformat);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * User can't choose size at his own will,
>> +	 * so we just return him the current size chosen
>> +	 * at standard selection.
>> +	 * TODO: Implement frame scaling?
>> +	 */
>> +
>> +	f->fmt.pix.width = dev->width;
>> +	f->fmt.pix.height = dev->height;
>> +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +	f->fmt.pix.bytesperline = dev->width<<  1;

dev->width * 2;

>> +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
>> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +	return 0;
>> +}
...
>> +/*
>> + * Videobuf2 operations
>> + */
>> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
>> +				unsigned int *nbuffers, unsigned int *nplanes,
>> +				unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
>> +	unsigned long size;
>> +
>> +	size = dev->width * dev->height * 2;
>> +
>> +	/*
>> +	 * Here we can change the number of buffers being requested.
>> +	 * For instance, we could set a minimum and a maximum,
>> +	 * like this:
>> +	 */
>> +	if (*nbuffers<  STK1160_MIN_VIDEO_BUFFERS)
>> +		*nbuffers = STK1160_MIN_VIDEO_BUFFERS;
>> +	else if (*nbuffers>  STK1160_MAX_VIDEO_BUFFERS)
>> +		*nbuffers = STK1160_MAX_VIDEO_BUFFERS;

Could be also done as:

	*buffers = clamp(*buffers, STK1160_MIN_VIDEO_BUFFERS,
			 STK1160_MAX_VIDEO_BUFFERS);
>> +
>> +	/* This means a packed colorformat */
>> +	*nplanes = 1;
>> +
>> +	sizes[0] = size;
>> +
>> +	/*
>> +	 * videobuf2-vmalloc allocator is context-less so no need to set
>> +	 * alloc_ctxs array.
>> +	 */
>> +
>> +	if (v4l_fmt) {
>> +		stk1160_info("selected format %d (%d)\n",
>> +			v4l_fmt->fmt.pix.pixelformat,
>> +			dev->fmt->fourcc);
>> +	}

This log is not exactly right. You just ignore v4l_fmt, so it is not selected
anywhere. The *v4l_fmt argument is here for ioctls like VIDIOC_CREATE_BUFS,
and in case you wanted to support this ioctl you would need to do something 
like:
	pix = &v4l_fmt->fmt.pix;
	sizes[0] = pix->width * pix->height * 2;

Of course with any required sanity checks.

But this driver does not implement vidioc_create_bufs/vidioc_prepare_buf ioctl
callbacks are not, so the code is generally OK.

>> +
>> +	stk1160_info("%s: buffer count %d, each %ld bytes\n",
>> +			__func__, *nbuffers, size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_init(struct vb2_buffer *vb)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct stk1160_buffer *buf =
>> +			container_of(vb, struct stk1160_buffer, vb);
>> +
>> +	/* If the device is disconnected, reject the buffer */
>> +	if (!dev->udev)
>> +		return -ENODEV;
>> +
>> +	buf->mem = vb2_plane_vaddr(vb, 0);
>> +	buf->length = vb2_plane_size(vb, 0);

Where do you check if the buffer you get from vb2 has correct parameters 
for your hardware (with current settings) to start writing data to it ?

It seems that this driver supports just one pixel format and resolution,
but still would be good to do such checks in buf_prepare().

And initialization of buf->mem, buf->length is better done from
buffer_queue() op. This way there would be no need to take dev->buf_lock 
spinlock also in buf_prepare() to protect the driver's buffer (queue),
which isn't done but it should in buffer_prepare() btw.

>> +	buf->bytesused = 0;
>> +	buf->pos = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_finish(struct vb2_buffer *vb)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void buffer_cleanup(struct vb2_buffer *vb)
>> +{
>> +}

buf_init, buf_finish, buf_cleanup are optional callbacks, so if you 
don't use them they could be removed altogether.

>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +	unsigned long flags = 0;
>> +	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct stk1160_buffer *buf =
>> +		container_of(vb, struct stk1160_buffer, vb);
>> +
>> +	spin_lock_irqsave(&dev->buf_lock, flags);
>> +	if (!dev->udev) {
>> +		/*
>> +		 * If the device is disconnected return the buffer to userspace
>> +		 * directly. The next QBUF call will fail with -ENODEV.
>> +		 */
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +	} else {
>> +		list_add_tail(&buf->list,&dev->avail_bufs);
>> +	}
>> +	spin_unlock_irqrestore(&dev->buf_lock, flags);
>> +}

--
Regards,
Sylwester
