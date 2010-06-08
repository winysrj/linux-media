Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44227 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0FHBCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 21:02:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Add the viafb video capture driver
Date: Tue, 8 Jun 2010 03:03:14 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <20100607172615.311edce9@bike.lwn.net>
In-Reply-To: <20100607172615.311edce9@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006080303.14784.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Tuesday 08 June 2010 01:26:15 Jonathan Corbet wrote:
> Hi, Mauro,
> 
> Linus has quietly ignored a couple of pull requests for this driver; I
> guess he's gotten tired of me this time around or something.  There's
> little profit in pushing the issue, so, can you just send it up through
> your tree (for 2.6.36 at this point) instead?

If it's not too late for review, here are some comments. I've reviewed the 
code from bottom to top, so comments might be a bit inconsistent sometimes.

[snip]

> diff --git a/drivers/media/video/via-camera.c
> b/drivers/media/video/via-camera.c new file mode 100644
> index 0000000..7b1ff0c
> --- /dev/null
> +++ b/drivers/media/video/via-camera.c

[snip]

> +/*
> + * Basic window sizes.
> + */
> +#define VGA_WIDTH	640
> +#define VGA_HEIGHT	480

That's already defined in include/linux/via-core.h (ugly defines though). It 
would be better to define constants such as VIA_SENSOR_WIDTH, 
VIA_xxx_MIN_WIDTH, VIA_xxx_MAX_WIDTH, ...

> +#define QCIF_WIDTH	176
> +#define	QCIF_HEIGHT	144
> +
> +/*
> + * The structure describing our camera.
> + */
> +enum viacam_opstate { S_IDLE = 0, S_RUNNING = 1 };
> +
> +static struct via_camera {
> +	struct v4l2_device v4l2_dev;
> +	struct video_device vdev;
> +	struct v4l2_subdev *sensor;
> +	struct platform_device *platdev;
> +	struct viafb_dev *viadev;
> +	struct mutex lock;
> +	enum viacam_opstate opstate;
> +	unsigned long flags;
> +	/*
> +	 * GPIO info for power/reset management
> +	 */
> +	int power_gpio;
> +	int reset_gpio;
> +	/*
> +	 * I/O memory stuff.
> +	 */
> +	void __iomem *mmio;	/* Where the registers live */
> +	void __iomem *fbmem;	/* Frame buffer memory */
> +	u32 fb_offset;		/* Reserved memory offset (FB) */
> +	/*
> +	 * Capture buffers and related.	 The controller supports
> +	 * up to three, so that's what we have here.  These buffers
> +	 * live in frame buffer memory, so we don't call them "DMA".
> +	 */
> +	unsigned int cb_offsets[3];	/* offsets into fb mem */
> +	u8 *cb_addrs[3];		/* Kernel-space addresses */
> +	int n_cap_bufs;			/* How many are we using? */
> +	int next_buf;
> +	struct videobuf_queue vb_queue;
> +	struct list_head buffer_queue;	/* prot. by reg_lock */
> +	/*
> +	 * User tracking.
> +	 */
> +	int users;
> +	struct file *owner;
> +	/*
> +	 * Video format information.  sensor_format is kept in a form
> +	 * that we can use to pass to the sensor.  We always run the
> +	 * sensor in VGA resolution, though, and let the controller
> +	 * downscale things if need be.	 So we keep the "real*
> +	 * dimensions separately.
> +	 */
> +	struct v4l2_pix_format sensor_format;
> +	struct v4l2_pix_format user_format;
> +} via_cam_info;

Don't define device structures as static object. You must kmalloc the 
via_camera structure in probe and set the pointer as driver private data to 
access it later in V4L2 operations and device core callbacks. Otherwise Bad 
Things (TM) will happen if the device is removed while the video device node 
is opened.

[snip]

> +/*
> + * Configure the sensor.  It's up to the caller to ensure
> + * that the camera is in the correct operating state.
> + */
> +static int viacam_configure_sensor(struct via_camera *cam)
> +{
> +	struct v4l2_format fmt;
> +	int ret;
> +
> +	fmt.fmt.pix = cam->sensor_format;
> +	ret = sensor_call(cam, core, init, 0);
> +	if (ret == 0)
> +		ret = sensor_call(cam, video, s_fmt, &fmt);
> +	/*
> +	 * OV7670 does weird things if flip is set *before* format...

What if the user sets vflip using VIDIOC_S_CTRL directly before setting the 
format ?

> +	 */
> +	if (ret == 0)
> +		ret = viacam_set_flip(cam);
> +	return ret;
> +}

[snip]

> +/*
> + * The threaded IRQ handler.
> + */
> +static irqreturn_t viacam_irq(int irq, void *data)
> +{
> +	int bufn;
> +	struct videobuf_buffer *vb;
> +	struct via_camera *cam = data;
> +	struct videobuf_dmabuf *vdma;
> +
> +	/*
> +	 * If there is no place to put the data frame, don't bother
> +	 * with anything else.
> +	 */
> +	vb = viacam_next_buffer(cam);
> +	if (vb == NULL)
> +		goto done;
> +	/*
> +	 * Figure out which buffer we just completed.
> +	 */
> +	bufn = (viacam_read_reg(cam, VCR_INTCTRL) & VCR_IC_ACTBUF) >> 3;
> +	bufn -= 1;
> +	if (bufn < 0)
> +		bufn = cam->n_cap_bufs - 1;
> +	/*
> +	 * Copy over the data and let any waiters know.
> +	 */
> +	vdma = videobuf_to_dma(vb);
> +	viafb_dma_copy_out_sg(cam->cb_offsets[bufn], vdma->sglist, vdma->sglen);

Ouch that's going to hurt performances !

What are the hardware restrictions regarding the memory it can capture images 
to ? Does it just have to be physically contiguous, or does the memory need to 
come from a specific memory area ? In the first case you could use 
videobuf_dma_contig and avoid the memcpy completely. In the second case you 
should still mmap the memory to userspace when using kernel-allocated buffers 
instead of memcpying the data. If you really need a memcpy, you should then 
probably use videobuf_vmalloc instead of videobuf_dma_sg.

> +	vb->state = VIDEOBUF_DONE;
> +	vb->size = cam->user_format.sizeimage;
> +	wake_up(&vb->done);
> +done:
> +	return IRQ_HANDLED;
> +}

[snip]

> +/*
> + * Set the scaling register for downscaling the image.
> + *
> + * This register works like this...  Vertical scaling is enabled
> + * by bit 26; if that bit is set, downscaling is controlled by the
> + * value in bits 16:25.	 Those bits are divided by 1024 to get
> + * the scaling factor; setting just bit 25 thus cuts the height
> + * in half.
> + *
> + * Horizontal scaling works about the same, but it's enabled by
> + * bit 11, with bits 0:10 giving the numerator of a fraction
> + * (over 2048) for the scaling value.
> + *
> + * This function is naive in that, if the user departs from
> + * the 3x4 VGA scaling factor, the image will distort.	We
> + * could work around that if it really seemed important.

I don't think that's a problem. If the user really wants to have different H 
and V scaling factors, we shouldn't prevent him from getting them.

> + */
> +static void viacam_set_scale(struct via_camera *cam)
> +{
> +	unsigned int avscale;
> +	int sf;
> +
> +	if (cam->user_format.width == VGA_WIDTH)
> +		avscale = 0;
> +	else {
> +		sf = (cam->user_format.width*2048)/VGA_WIDTH;
> +		avscale = VCR_AVS_HEN | sf;
> +	}
> +	if (cam->user_format.height < VGA_HEIGHT) {
> +		sf = (1024*cam->user_format.height)/VGA_HEIGHT;
> +		avscale |= VCR_AVS_VEN | (sf << 16);
> +	}
> +	viacam_write_reg(cam, VCR_AVSCALE, avscale);
> +}
> +
> +
> +/*
> + * Configure image-related information into the capture engine.
> + */
> +static void viacam_ctlr_image(struct via_camera *cam)
> +{
> +	int cicreg;
> +
> +	/*
> +	 * Disable clock before messing with stuff - from the via
> +	 * sample driver.
> +	 */
> +	viacam_write_reg(cam, VCR_CAPINTC, ~VCR_CI_ENABLE);
> +	viacam_write_reg(cam, VCR_CAPINTC, ~(VCR_CI_ENABLE|VCR_CI_CLKEN));

I don't know how the VCR_CAPINTC register works, but did you really mean to 
write all bits to 1 except VCR_CI_ENABLE and VCR_CI_CLKEN ?

> +	/*
> +	 * Disable a bunch of stuff.
> +	 */
> +	viacam_write_reg(cam, VCR_HORRANGE, 0x06200120);
> +	viacam_write_reg(cam, VCR_VERTRANGE, 0x01de0000);

Any idea what that bunch of stuff is ? Replacing the magic numbers by 
#define'd constants would be nice.

> +	viacam_set_scale(cam);
> +	/*
> +	 * Image size info.
> +	 */
> +	viacam_write_reg(cam, VCR_MAXDATA,
> +			(cam->sensor_format.height << 16) |
> +			(cam->sensor_format.bytesperline >> 3));
> +	viacam_write_reg(cam, VCR_MAXVBI, 0);
> +	viacam_write_reg(cam, VCR_VSTRIDE,
> +			cam->user_format.bytesperline & VCR_VS_STRIDE);
> +	/*
> +	 * Set up the capture interface control register,
> +	 * everything but the "go" bit.
> +	 *
> +	 * The FIFO threshold is a bit of a magic number; 8 is what
> +	 * VIA's sample code uses.
> +	 */
> +	cicreg = VCR_CI_CLKEN |
> +		0x08000000 |		/* FIFO threshold */
> +		VCR_CI_FLDINV |		/* OLPC-specific? */
> +		VCR_CI_VREFINV |	/* OLPC-specific? */
> +		VCR_CI_DIBOTH |		/* Capture both fields */
> +		VCR_CI_CCIR601_8;
> +	if (cam->n_cap_bufs == 3)
> +		cicreg |= VCR_CI_3BUFS;
> +	/*
> +	 * YUV formats need different byte swapping than RGB.
> +	 */
> +	if (cam->user_format.pixelformat == V4L2_PIX_FMT_YUYV)
> +		cicreg |= VCR_CI_YUYV;
> +	else
> +		cicreg |= VCR_CI_UYVY;
> +	viacam_write_reg(cam, VCR_CAPINTC, cicreg);
> +}

[snip]

> +/*
> + * Make it start grabbing data.
> + */
> +static void viacam_start_engine(struct via_camera *cam)
> +{
> +	spin_lock_irq(&cam->viadev->reg_lock);
> +	cam->next_buf = 0;
> +	viacam_write_reg_mask(cam, VCR_CAPINTC, VCR_CI_ENABLE, VCR_CI_ENABLE);
> +	viacam_int_enable(cam);
> +	(void) viacam_read_reg(cam, VCR_CAPINTC); /* Force post */

Why a (void) cast ?

> +	cam->opstate = S_RUNNING;
> +	spin_unlock_irq(&cam->viadev->reg_lock);
> +}
> +
> +
> +static void viacam_stop_engine(struct via_camera *cam)
> +{
> +	spin_lock_irq(&cam->viadev->reg_lock);
> +	viacam_int_disable(cam);
> +	viacam_write_reg_mask(cam, VCR_CAPINTC, 0, VCR_CI_ENABLE);
> +	(void) viacam_read_reg(cam, VCR_CAPINTC); /* Force post */

Why a (void) cast ?

> +	cam->opstate = S_IDLE;
> +	spin_unlock_irq(&cam->viadev->reg_lock);
> +}

[snip]

> +static int viacam_vb_buf_setup(struct videobuf_queue *q,
> +		unsigned int *count, unsigned int *size)
> +{
> +	struct via_camera *cam = q->priv_data;
> +
> +	*size = cam->user_format.sizeimage;
> +	if (*count == 0 || *count > 6)  /* Arbitrary number */
> +		*count = 6;

Shouldn't the limit should be computed from the available fb memory ?

> +	return 0;
> +}

> +/*
> + * We've got a buffer to put data into.
> + *
> + * FIXME: check for a running engine and valid buffers?
> + */
> +static void viacam_vb_buf_queue(struct videobuf_queue *q,
> +		struct videobuf_buffer *vb)
> +{
> +	struct via_camera *cam = q->priv_data;
> +
> +	/*
> +	 * Note that videobuf holds the lock when it calls
> +	 * us, so we need not (indeed, cannot) take it here.
> +	 */
> +	vb->state = VIDEOBUF_QUEUED;
> +	list_add_tail(&vb->queue, &cam->buffer_queue);
> +}

Shouldn't you also pass the buffer to the hardware if the interrupt handler 
ran out of buffers earlier ?

[snip]

> +static int viacam_open(struct file *filp)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	filp->private_data = cam;
> +	/*
> +	 * Note the new user.  If this is the first one, we'll also
> +	 * need to power up the sensor.
> +	 */
> +	mutex_lock(&cam->lock);
> +	if (cam->users == 0) {
> +		int ret = viafb_request_dma();
> +
> +		if (ret) {
> +			mutex_unlock(&cam->lock);
> +			return ret;
> +		}
> +		via_sensor_power_up(cam);
> +		set_bit(CF_CONFIG_NEEDED, &cam->flags);
> +		/*
> +		 * Hook into videobuf.	Evidently this cannot fail.
> +		 */
> +		videobuf_queue_sg_init(&cam->vb_queue, &viacam_vb_ops,
> +				&cam->platdev->dev, &cam->viadev->reg_lock,
> +				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> +				sizeof(struct videobuf_buffer), cam);

Why don't you initialize the queue on probe ?

> +	}
> +	(cam->users)++;

No need for parenthesis.

> +	mutex_unlock(&cam->lock);
> +	return 0;
> +}
> +
> +static int viacam_release(struct file *filp)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	mutex_lock(&cam->lock);
> +	(cam->users)--;

No need for parenthesis.

> +	/*
> +	 * If the "owner" is closing, shut down any ongoing
> +	 * operations.
> +	 */
> +	if (filp == cam->owner) {
> +		videobuf_stop(&cam->vb_queue);
> +		if (cam->opstate != S_IDLE)
> +			viacam_stop_engine(cam);
> +		cam->owner = NULL;
> +	}
> +	/*
> +	 * Last one out needs to turn out the lights.
> +	 */
> +	if (cam->users == 0) {
> +		videobuf_mmap_free(&cam->vb_queue);
> +		via_sensor_power_down(cam);
> +		viafb_release_dma();
> +	}
> +	mutex_unlock(&cam->lock);
> +	return 0;
> +}
> +

[snip]

> +/*
> + * Control ops are passed through to the sensor.
> + */
> +static int viacam_queryctrl(struct file *filp, void *priv,
> +		struct v4l2_queryctrl *qc)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, queryctrl, qc);
> +	mutex_unlock(&cam->lock);

If the sensor needs locking shouldn't it provide it itself ?

> +	return ret;
> +}
> +
> +
> +static int viacam_g_ctrl(struct file *filp, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, g_ctrl, ctrl);
> +	mutex_unlock(&cam->lock);

Same here.

> +	return ret;
> +}
> +
> +
> +static int viacam_s_ctrl(struct file *filp, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, s_ctrl, ctrl);
> +	mutex_unlock(&cam->lock);

Same here.

> +	return ret;
> +}
> +
> +/*
> + * Only one input.
> + */
> +static int viacam_enum_input(struct file *filp, void *priv,
> +		struct v4l2_input *input)
> +{
> +	if (input->index != 0)
> +		return -EINVAL;
> +
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	input->std = V4L2_STD_ALL; /* Not sure what should go here */
> +	strcpy(input->name, "Camera");
> +	return 0;
> +}
> +
> +static int viacam_g_input(struct file *filp, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int viacam_s_input(struct file *filp, void *priv, unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +	return 0;
> +}

The single-input case should be handled entirely inside v4l2-ioctl, but I 
digress :-)

> +static int viacam_s_std(struct file *filp, void *priv, v4l2_std_id *std)
> +{
> +	return 0;
> +}

Norms make no sense for sensors, you can remove that operation.

> +/*
> + * Video format stuff.	Here is our default format until
> + * user space messes with things.
> + */
> +static struct v4l2_pix_format viacam_def_pix_format = {

You can make it static const.

> +	.width		= VGA_WIDTH,
> +	.height		= VGA_HEIGHT,
> +	.pixelformat	= V4L2_PIX_FMT_YUYV,
> +	.field		= V4L2_FIELD_NONE,
> +	.bytesperline	= VGA_WIDTH*2,
> +	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
> +};
> +
> +static int viacam_enum_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_fmtdesc *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, enum_fmt, fmt);
> +	mutex_unlock(&cam->lock);

enum_fmt is stateless, no need to lock.

> +	return ret;
> +}
> +
> +/*
> + * Figure out proper image dimensions, but always force the
> + * sensor to VGA.
> + */
> +static void viacam_fmt_pre(struct v4l2_pix_format *userfmt,
> +		struct v4l2_pix_format *sensorfmt)
> +{
> +	*sensorfmt = *userfmt;
> +	if (userfmt->width < QCIF_WIDTH || userfmt->height < QCIF_HEIGHT) {
> +		userfmt->width = QCIF_WIDTH;
> +		userfmt->height = QCIF_HEIGHT;

If only one of width or height is out of bounds there's no need to reset the 
other value.

> +	}
> +	if (userfmt->width > VGA_WIDTH || userfmt->height > VGA_HEIGHT) {
> +		userfmt->width = VGA_WIDTH;
> +		userfmt->height = VGA_HEIGHT;
> +	}
> +	sensorfmt->width = VGA_WIDTH;
> +	sensorfmt->height = VGA_HEIGHT;
> +}

[snip]

> +static int viacam_try_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +	struct v4l2_format sfmt;
> +
> +	viacam_fmt_pre(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, try_fmt, &sfmt);
> +	mutex_unlock(&cam->lock);

The try operation is stateless, a mutex shouldn't be needed.

> +	viacam_fmt_post(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	return ret;
> +}
> +
> +static int viacam_g_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +
> +	fmt->fmt.pix = cam->user_format;

You need to protect cam->user_format with a mutex.

> +	return 0;
> +}
> +
> +static int viacam_s_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +	struct v4l2_format sfmt;
> +
> +	/*
> +	 * Camera must be idle or we can't mess with the
> +	 * video setup.
> +	 */
> +	if (cam->opstate != S_IDLE)
> +		return -EBUSY;

cam->opstate should be protected by a mutex.

> +	/*
> +	 * Let the sensor code look over and tweak the
> +	 * requested formatting.
> +	 */
> +	mutex_lock(&cam->lock);
> +	viacam_fmt_pre(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	ret = sensor_call(cam, video, try_fmt, &sfmt);
> +	if (ret)
> +		goto out;
> +	viacam_fmt_post(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	/*
> +	 * OK, let's commit to the new format.
> +	 */
> +	cam->user_format = fmt->fmt.pix;
> +	cam->sensor_format = sfmt.fmt.pix;
> +	ret = viacam_configure_sensor(cam);
> +	if (!ret)
> +		ret = viacam_config_controller(cam);
> +out:
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +static int viacam_querycap(struct file *filp, void *priv,
> +		struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "via-camera");
> +	strcpy(cap->card, "via-camera");
> +	cap->version = 1;

According to the V4L2 spec the version number should be formatted using 
KERNEL_VERSION().

> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> +	return 0;
> +}

[snip]

> +static int viacam_streamon(struct file *filp, void *priv, enum
> v4l2_buf_type t) +{
> +	struct via_camera *cam = priv;
> +	int ret = 0;
> +
> +	if (t != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +	if (cam->opstate != S_IDLE)
> +		return -EBUSY;
> +	/*
> +	 * Enforce the V4l2 "only one owner gets to read data" rule.
> +	 */
> +	if (cam->owner && cam->owner != filp)
> +		return -EBUSY;
> +	cam->owner = filp;

This calls for a mutex.

> +	/*
> +	 * Configure things if need be.
> +	 */
> +	if (test_bit(CF_CONFIG_NEEDED, &cam->flags)) {
> +		mutex_lock(&cam->lock);
> +		ret = viacam_configure_sensor(cam);
> +		if (!ret)
> +			ret = viacam_config_controller(cam);
> +		mutex_unlock(&cam->lock);
> +	}
> +	/*
> +	 * If the CPU goes into C3, the DMA transfer gets corrupted and
> +	 * users start filing unsightly bug reports.  Put in a "latency"
> +	 * requirement which will keep the CPU out of the deeper sleep
> +	 * states.
> +	 */
> +	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "viafb-dma", 50);
> +	/*
> +	 * Fire things up.
> +	 */
> +	if (!ret) {
> +		INIT_LIST_HEAD(&cam->buffer_queue);
> +		ret = videobuf_streamon(&cam->vb_queue);
> +		if (!ret)
> +			viacam_start_engine(cam);
> +	}
> +	return ret;
> +}
> +
> +static int viacam_streamoff(struct file *filp, void *priv, enum
> v4l2_buf_type t) +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	if (t != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "viafb-dma");
> +	viacam_stop_engine(cam);

If the user calls VIDIOC_STREAMOFF twice you will try to remove the DMA 
latency requirement and stop the engine twice. Is that OK ?

> +	/*
> +	 * Videobuf will recycle all of the outstanding buffers, but
> +	 * we should be sure we don't retain any references to
> +	 * any of them.
> +	 */
> +	ret = videobuf_streamoff(&cam->vb_queue);
> +	INIT_LIST_HEAD(&cam->buffer_queue);
> +	return ret;
> +}

[snip]

> +static int viacam_enum_framesizes(struct file *filp, void *priv,
> +		struct v4l2_frmsizeenum *sizes)
> +{
> +	if (sizes->index != 0)
> +		return -EINVAL;

You should also check the format and return an error if it's not valid.

> +	sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +	sizes->stepwise.min_width = QCIF_WIDTH;
> +	sizes->stepwise.min_height = QCIF_HEIGHT;
> +	sizes->stepwise.max_width = VGA_WIDTH;
> +	sizes->stepwise.max_height = VGA_HEIGHT;
> +	sizes->stepwise.step_width = sizes->stepwise.step_height = 1;
> +	return 0;
> +}
> +
> +static int viacam_enum_frameintervals(struct file *filp, void *priv,
> +		struct v4l2_frmivalenum *interval)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, enum_frameintervals, interval);
> +	mutex_unlock(&cam->lock);

Enumeration is state-less, do you need to lock ?

> +	return ret;
> +}

[snip]

> +/*
> + * Setup stuff.
> + */
> +
> +static struct video_device viacam_v4l_template = {
> +	.name		= "via-camera",
> +	.minor		= -1,
> +	.tvnorms	= V4L2_STD_NTSC_M,
> +	.current_norm	= V4L2_STD_NTSC_M,

It's a webcam, norms don't make sense.

> +	.fops		= &viacam_fops,
> +	.ioctl_ops	= &viacam_ioctl_ops,
> +	.release	= video_device_release_empty, /* Check this */
> +};

I would initialize the fields explicitly in viacam_probe instead of using a 
template but that might just be me.

[snip]

> +#ifdef CONFIG_OLPC_XO_1_5
> +/*
> + * The OLPC folks put the serial port on the same pin as
> + * the camera.	They also get grumpy if we break the
> + * serial port and keep them from using it.  So we have
> + * to check the serial enable bit and not step on it.
> + */
> +#define VIACAM_SERIAL_DEVFN 0x88
> +#define VIACAM_SERIAL_CREG 0x46
> +#define VIACAM_SERIAL_BIT 0x40
> +
> +static __devinit int viacam_check_serial_port(void)
> +{
> +	struct pci_bus *pbus = pci_find_bus(0, 0);
> +	u8 cbyte;
> +
> +	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
> +			VIACAM_SERIAL_CREG, &cbyte);
> +	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
> +		return 0; /* Not enabled */
> +	if (override_serial == 0) {
> +		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
> +				"refusing to load.\n");
> +		printk(KERN_NOTICE "Specify override_serial=1 to force " \
> +				"module loading.\n");

No need for a \ at the end of the line.

> +		return -EBUSY;
> +	}
> +	printk(KERN_NOTICE "Via camera: overriding serial port\n");
> +	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
> +			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
> +	return 0;
> +}
> +#endif
> +
> +
> +
> +
> +static int viacam_init(void)
> +{
> +#ifdef CONFIG_OLPC_XO_1_5
> +	if (viacam_check_serial_port())
> +		return -EBUSY;
> +#endif

Should this prevent the driver from being loaded at all, or would it better to 
perform the check in the probe function ?

-- 
Regards,

Laurent Pinchart
