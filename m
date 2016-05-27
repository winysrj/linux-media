Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:58677 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbcE0Myh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:54:37 -0400
Subject: Re: [PATCH v2 4/8] Input: atmel_mxt_ts - output diagnostic debug via
 v4l2 device
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
 <1462381638-7818-5-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57484386.2050809@xs4all.nl>
Date: Fri, 27 May 2016 14:54:30 +0200
MIME-Version: 1.0
In-Reply-To: <1462381638-7818-5-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nick,

On 05/04/2016 07:07 PM, Nick Dyer wrote:
> Register a video device to output T37 diagnostic data.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/Kconfig        |   2 +
>  drivers/input/touchscreen/atmel_mxt_ts.c | 271 +++++++++++++++++++++++++++++++
>  2 files changed, 273 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 1f99e7f..4aa7609 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -105,6 +105,8 @@ config TOUCHSCREEN_AR1021_I2C
>  config TOUCHSCREEN_ATMEL_MXT
>  	tristate "Atmel mXT I2C Touchscreen"
>  	depends on I2C
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF2_VMALLOC
>  	select FW_LOADER
>  	help
>  	  Say Y here if you have Atmel mXT series I2C touchscreen,
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index cd97713..8945235 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -28,6 +28,10 @@
>  #include <linux/of.h>
>  #include <linux/slab.h>
>  #include <asm/unaligned.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-vmalloc.h>
>  
>  /* Firmware files */
>  #define MXT_FW_NAME		"maxtouch.fw"
> @@ -222,6 +226,23 @@ struct mxt_dbg {
>  	struct t37_debug *t37_buf;
>  	unsigned int t37_pages;
>  	unsigned int t37_nodes;
> +
> +	struct v4l2_device v4l2;
> +	struct v4l2_pix_format format;
> +	struct video_device vdev;
> +	struct vb2_queue queue;
> +	struct mutex lock;
> +	int input;
> +};
> +
> +static const struct v4l2_file_operations mxt_video_fops = {
> +	.owner = THIS_MODULE,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.unlocked_ioctl = video_ioctl2,
> +	.read = vb2_fop_read,
> +	.mmap = vb2_fop_mmap,
> +	.poll = vb2_fop_poll,
>  };
>  
>  /* Each client has this additional data */
> @@ -277,6 +298,11 @@ struct mxt_data {
>  	struct completion crc_completion;
>  };
>  
> +struct mxt_vb2_buffer {
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +};
> +
>  static size_t mxt_obj_size(const struct mxt_object *obj)
>  {
>  	return obj->size_minus_one + 1;
> @@ -1523,6 +1549,9 @@ static void mxt_free_input_device(struct mxt_data *data)
>  
>  static void mxt_free_object_table(struct mxt_data *data)
>  {
> +	video_unregister_device(&data->dbg.vdev);
> +	v4l2_device_unregister(&data->dbg.v4l2);
> +
>  	kfree(data->object_table);
>  	data->object_table = NULL;
>  	kfree(data->msg_buf);
> @@ -2154,10 +2183,215 @@ wait_cmd:
>  	return mxt_convert_debug_pages(data, outbuf);
>  }
>  
> +static int mxt_queue_setup(struct vb2_queue *q,
> +		       unsigned int *nbuffers, unsigned int *nplanes,
> +		       unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct mxt_data *data = q->drv_priv;
> +
> +	*nbuffers = 1;

That's not right. You can just drop this line since you've already set min_buffers_needed below.

This line forces vb2 to always allocate just one buffer, even if userspace wants more.

And in order to correctly support VIDIOC_CREATE_BUFS you need this:

        if (*nplanes)
                return sizes[0] < data->dbg.t37_nodes * sizeof(u16) ? -EINVAL : 0;

> +	*nplanes = 1;
> +	sizes[0] = data->dbg.t37_nodes * sizeof(u16);
> +
> +	return 0;
> +}
> +
> +static int mxt_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	return 0;
> +}

Just drop this function since it doesn't do anything.

> +
> +static void mxt_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
> +	u16 *ptr;
> +	int ret;
> +
> +	ptr = vb2_plane_vaddr(vb, 0);
> +	if (!ptr) {
> +		dev_err(&data->client->dev, "Error acquiring frame ptr\n");
> +		goto fault;
> +	}
> +
> +	ret = mxt_read_diagnostic_debug(data, MXT_DIAGNOSTIC_DELTAS, ptr);
> +	if (ret)
> +		goto fault;
> +
> +	vb2_set_plane_payload(vb, 0, data->dbg.t37_nodes * sizeof(u16));
> +	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +	return;
> +
> +fault:
> +	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +}
> +
> +/* V4L2 structures */
> +static const struct vb2_ops mxt_queue_ops = {
> +	.queue_setup		= mxt_queue_setup,
> +	.buf_prepare		= mxt_buffer_prepare,
> +	.buf_queue		= mxt_buffer_queue,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +static const struct vb2_queue mxt_queue = {
> +	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +	.io_modes = VB2_MMAP,

Add VB2_USERPTR | VB2_DMABUF | VB2_READ here as well. You get that for free, so why not?

> +	.buf_struct_size = sizeof(struct mxt_vb2_buffer),
> +	.ops = &mxt_queue_ops,
> +	.mem_ops = &vb2_vmalloc_memops,
> +	.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
> +	.min_buffers_needed = 1,
> +};
> +
> +static int mxt_vidioc_querycap(struct file *file, void *priv,
> +				 struct v4l2_capability *cap)
> +{
> +	struct mxt_data *data = video_drvdata(file);
> +
> +	strlcpy(cap->driver, "atmel_mxt_ts", sizeof(cap->driver));
> +	strlcpy(cap->card, "atmel_mxt_ts touch", sizeof(cap->card));
> +	strlcpy(cap->bus_info, data->phys, sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_READWRITE |
> +		V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

You can drop this line: it's now done for you by the v4l2 core code.

> +
> +	return 0;
> +}
> +
> +static int mxt_vidioc_enum_input(struct file *file, void *priv,
> +				   struct v4l2_input *i)
> +{
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;

I think we still need an V4L2_INPUT_TYPE_TOUCH_SENSOR here: it's just plain
weird to call this a camera IMHO.

> +	i->std = V4L2_STD_UNKNOWN;
> +	i->capabilities = 0;

Drop these two lines, v4l2_input is zeroed anyway.

> +	strlcpy(i->name, "Mutual References", sizeof(i->name));
> +	return 0;
> +}
> +
> +static int mxt_set_input(struct mxt_data *data, unsigned int i)
> +{
> +	struct v4l2_pix_format *f = &data->dbg.format;
> +
> +	if (i > 0)
> +		return -EINVAL;
> +
> +	f->width = data->info.matrix_xsize;
> +	f->height = data->info.matrix_ysize;
> +	f->pixelformat = V4L2_PIX_FMT_YS16;
> +	f->field = V4L2_FIELD_NONE;
> +	f->colorspace = V4L2_COLORSPACE_SRGB;

This makes no sense. Use COLORSPACE_RAW here.

> +	f->bytesperline = f->width * sizeof(u16);
> +	f->sizeimage = f->width * f->height * sizeof(u16);
> +
> +	data->dbg.input = i;
> +
> +	return 0;
> +}
> +
> +static int mxt_vidioc_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	return mxt_set_input(video_drvdata(file), i);
> +}
> +
> +static int mxt_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct mxt_data *data = video_drvdata(file);
> +
> +	*i = data->dbg.input;
> +
> +	return 0;
> +}
> +
> +static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct mxt_data *data = video_drvdata(file);
> +
> +	f->fmt.pix = data->dbg.format;
> +
> +	return 0;
> +}
> +
> +static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
> +				 struct v4l2_fmtdesc *fmt)
> +{
> +	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	fmt->pixelformat = V4L2_PIX_FMT_YS16;
> +	strlcpy(fmt->description, "16-bit raw debug data",
> +		sizeof(fmt->description));

Don't set the description here. Instead set it in v4l2-ioctls.c so all drivers
that need this will use a consistent description string.

> +	fmt->flags = 0;

You can drop this line, it's zeroed when this function is called.

> +	return 0;
> +}
> +
> +static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
> +					struct v4l2_frmsizeenum *f)
> +{
> +	struct mxt_data *data = video_drvdata(file);
> +
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	f->discrete.width = data->info.matrix_xsize;
> +	f->discrete.height = data->info.matrix_ysize;
> +	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	return 0;
> +}
> +
> +static int mxt_vidioc_enum_frameintervals(struct file *file, void *priv,
> +					  struct v4l2_frmivalenum *f)
> +{
> +	if ((f->index > 0) || (f->pixel_format != V4L2_PIX_FMT_YS16))
> +		return -EINVAL;
> +
> +	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +	f->discrete.denominator  = 10;
> +	f->discrete.numerator = 1;
> +	return 0;
> +}

You can drop these two callbacks: since it is all fixed there is nothing to enumerate.

Instead you should implement g_parm so userspace can discover the framerate. That's all
that is needed.

> +
> +static const struct v4l2_ioctl_ops mxt_video_ioctl_ops = {
> +	.vidioc_querycap        = mxt_vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap = mxt_vidioc_enum_fmt,
> +	.vidioc_s_fmt_vid_cap   = mxt_vidioc_fmt,
> +	.vidioc_g_fmt_vid_cap   = mxt_vidioc_fmt,
> +
> +	.vidioc_enum_framesizes = mxt_vidioc_enum_framesizes,
> +	.vidioc_enum_frameintervals = mxt_vidioc_enum_frameintervals,
> +
> +	.vidioc_enum_input      = mxt_vidioc_enum_input,
> +	.vidioc_g_input         = mxt_vidioc_g_input,
> +	.vidioc_s_input         = mxt_vidioc_s_input,
> +
> +	.vidioc_reqbufs         = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs     = vb2_ioctl_create_bufs,
> +	.vidioc_querybuf        = vb2_ioctl_querybuf,
> +	.vidioc_qbuf            = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf           = vb2_ioctl_dqbuf,
> +	.vidioc_expbuf          = vb2_ioctl_expbuf,
> +
> +	.vidioc_streamon        = vb2_ioctl_streamon,
> +	.vidioc_streamoff       = vb2_ioctl_streamoff,
> +};
> +
> +static const struct video_device mxt_video_device = {
> +	.name = "Atmel maxTouch",
> +	.fops = &mxt_video_fops,
> +	.ioctl_ops = &mxt_video_ioctl_ops,
> +	.release = video_device_release_empty,
> +};
> +
>  static void mxt_debug_init(struct mxt_data *data)
>  {
>  	struct mxt_dbg *dbg = &data->dbg;
>  	struct mxt_object *object;
> +	int error;
>  
>  	object = mxt_get_object(data, MXT_GEN_COMMAND_T6);
>  	if (!object)
> @@ -2187,8 +2421,45 @@ static void mxt_debug_init(struct mxt_data *data)
>  	if (!dbg->t37_buf)
>  		goto error;
>  
> +	/* init channel to zero */
> +	mxt_set_input(data, 0);
> +
> +	/* register video device */
> +	snprintf(dbg->v4l2.name, sizeof(dbg->v4l2.name), "%s", "atmel_mxt_ts");
> +	error = v4l2_device_register(&data->client->dev, &dbg->v4l2);
> +	if (error) {
> +		dev_err(&data->client->dev, "Unable to register video master device.");
> +		goto error;
> +	}
> +
> +	/* initialize the queue */
> +	mutex_init(&dbg->lock);
> +	dbg->queue = mxt_queue;
> +	dbg->queue.drv_priv = data;
> +	dbg->queue.lock = &dbg->lock;
> +
> +	error = vb2_queue_init(&dbg->queue);
> +	if (error)
> +		goto error_unreg_v4l2;
> +
> +	dbg->vdev = mxt_video_device;
> +	dbg->vdev.v4l2_dev = &dbg->v4l2;
> +	dbg->vdev.lock = &dbg->lock;
> +	dbg->vdev.vfl_dir = VFL_DIR_RX;
> +	dbg->vdev.queue = &dbg->queue;
> +	video_set_drvdata(&dbg->vdev, data);
> +
> +	error = video_register_device(&dbg->vdev, VFL_TYPE_TOUCH_SENSOR, -1);
> +	if (error) {
> +		dev_err(&data->client->dev,
> +				"Unable to register video subdevice.");
> +		goto error_unreg_v4l2;
> +	}
> +
>  	return;
>  
> +error_unreg_v4l2:
> +	v4l2_device_unregister(&dbg->v4l2);
>  error:
>  	dev_err(&data->client->dev, "Error initialising T37 diagnostic data\n");
>  }
> 

BTW, did you run v4l2-compliance? I think it should work if you just do:

v4l2-compliance -d /dev/v4l-touch0

Regards,

	Hans
