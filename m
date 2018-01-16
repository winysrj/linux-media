Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:43305 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751427AbeAPJqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:46:48 -0500
Subject: Re: [PATCH v5 3/9] v4l: platform: Add Renesas CEU driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-4-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ba0540cd-c0b9-31a3-4bc8-7f32e4d85cf5@xs4all.nl>
Date: Tue, 16 Jan 2018 10:46:42 +0100
MIME-Version: 1.0
In-Reply-To: <1515765849-10345-4-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Sorry for the late review, but here is finally is.

BTW, can you provide the v4l2-compliance output (ideally with the -f option)
in the cover letter for v6?

On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> 
> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    1 +
>  drivers/media/platform/renesas-ceu.c | 1648 ++++++++++++++++++++++++++++++++++
>  3 files changed, 1658 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index fd0c998..fe7bd26 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -144,6 +144,15 @@ config VIDEO_STM32_DCMI
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called stm32-dcmi.
>  
> +config VIDEO_RENESAS_CEU
> +	tristate "Renesas Capture Engine Unit (CEU) driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> +	depends on ARCH_SHMOBILE || ARCH_R7S72100 || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	---help---
> +	  This is a v4l2 driver for the Renesas CEU Interface
> +
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 003b0bb..6580a6b 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -62,6 +62,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
>  obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  
>  obj-$(CONFIG_VIDEO_RCAR_DRIF)		+= rcar_drif.o
> +obj-$(CONFIG_VIDEO_RENESAS_CEU)		+= renesas-ceu.o
>  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
>  obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
>  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> new file mode 100644
> index 0000000..ccca838
> --- /dev/null
> +++ b/drivers/media/platform/renesas-ceu.c

<snip>

> +/*
> + * ceu_vb2_setup() - is called to check whether the driver can accept the
> + *		     requested number of buffers and to fill in plane sizes
> + *		     for the current frame format, if required.
> + */
> +static int ceu_vb2_setup(struct vb2_queue *vq, unsigned int *count,
> +			 unsigned int *num_planes, unsigned int sizes[],
> +			 struct device *alloc_devs[])
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	unsigned int i;
> +
> +	if (!*count)
> +		*count = 2;

Don't do this. Instead set the min_buffers_needed field to 2 in the vb2_queue
struct.

> +
> +	/* num_planes is set: just check plane sizes. */
> +	if (*num_planes) {
> +		for (i = 0; i < pix->num_planes; i++)
> +			if (sizes[i] < pix->plane_fmt[i].sizeimage)
> +				return -EINVAL;
> +
> +		return 0;
> +	}
> +
> +	/* num_planes not set: called from REQBUFS, just set plane sizes. */
> +	*num_planes = pix->num_planes;
> +	for (i = 0; i < pix->num_planes; i++)
> +		sizes[i] = pix->plane_fmt[i].sizeimage;
> +
> +	return 0;
> +}
> +
> +static void ceu_vb2_queue(struct vb2_buffer *vb)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	struct ceu_buffer *buf = vb2_to_ceu(vbuf);
> +	unsigned long irqflags;
> +	unsigned int i;
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		if (vb2_plane_size(vb, i) < pix->plane_fmt[i].sizeimage) {
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +			return;
> +		}
> +
> +		vb2_set_plane_payload(vb, i, pix->plane_fmt[i].sizeimage);

This is not the right vb2 op for this test, this belongs in the buf_prepare
op. There you can just return an error and you don't need to call buffer_done.

> +	}
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	list_add_tail(&buf->queue, &ceudev->capture);
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +}
> +
> +static int ceu_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +	int ret;
> +
> +	/* Program the CEU interface according to the CEU image format. */
> +	ret = ceu_hw_config(ceudev);
> +	if (ret)
> +		goto error_return_bufs;
> +
> +	ret = v4l2_subdev_call(v4l2_sd, video, s_stream, 1);
> +	if (ret && ret != -ENOIOCTLCMD) {
> +		dev_dbg(ceudev->dev,
> +			"Subdevice failed to start streaming: %d\n", ret);
> +		goto error_return_bufs;
> +	}
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	ceudev->sequence = 0;
> +
> +	/* Grab the first available buffer and trigger the first capture. */
> +	buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
> +			       queue);
> +	if (!buf) {
> +		spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +		dev_dbg(ceudev->dev,
> +			"No buffer available for capture.\n");
> +		goto error_stop_sensor;
> +	}
> +
> +	list_del(&buf->queue);
> +	ceudev->active = &buf->vb;
> +
> +	/* Clean and program interrupts for first capture. */
> +	ceu_write(ceudev, CEU_CETCR, ~ceudev->irq_mask);
> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);
> +
> +	ceu_capture(ceudev);
> +
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	return 0;
> +
> +error_stop_sensor:
> +	v4l2_subdev_call(v4l2_sd, video, s_stream, 0);
> +
> +error_return_bufs:
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	list_for_each_entry(buf, &ceudev->capture, queue)
> +		vb2_buffer_done(&ceudev->active->vb2_buf,
> +				VB2_BUF_STATE_QUEUED);
> +	ceudev->active = NULL;
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	return ret;
> +}
> +
> +static void ceu_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +
> +	/* Clean and disable interrupt sources. */
> +	ceu_write(ceudev, CEU_CETCR,
> +		  ceu_read(ceudev, CEU_CETCR) & ceudev->irq_mask);
> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);
> +
> +	v4l2_subdev_call(v4l2_sd, video, s_stream, 0);
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	if (ceudev->active) {
> +		vb2_buffer_done(&ceudev->active->vb2_buf,
> +				VB2_BUF_STATE_ERROR);
> +		ceudev->active = NULL;
> +	}
> +
> +	/* Release all queued buffers. */
> +	list_for_each_entry(buf, &ceudev->capture, queue)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	INIT_LIST_HEAD(&ceudev->capture);
> +
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	ceu_soft_reset(ceudev);
> +}
> +
> +static const struct vb2_ops ceu_vb2_ops = {
> +	.queue_setup		= ceu_vb2_setup,
> +	.buf_queue		= ceu_vb2_queue,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +	.start_streaming	= ceu_start_streaming,
> +	.stop_streaming		= ceu_stop_streaming,
> +};
> +
> +/* --- CEU image formats handling --- */
> +
> +/*
> + * ceu_try_fmt() - test format on CEU and sensor
> + * @ceudev: The CEU device.
> + * @v4l2_fmt: format to test.
> + *
> + * Returns 0 for success, < 0 for errors.
> + */
> +static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_pix_format_mplane *pix = &v4l2_fmt->fmt.pix_mp;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	const struct ceu_fmt *ceu_fmt;
> +	int ret;
> +
> +	struct v4l2_subdev_format sd_format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		break;
> +
> +	default:
> +		pix->pixelformat = V4L2_PIX_FMT_NV16;

Please add a break here.

> +	}
> +
> +	ceu_fmt = get_ceu_fmt_from_fourcc(pix->pixelformat);
> +
> +	/* CFSZR requires height and width to be 4-pixel aligned. */
> +	v4l_bound_align_image(&pix->width, 2, CEU_MAX_WIDTH, 4,
> +			      &pix->height, 4, CEU_MAX_HEIGHT, 4, 0);
> +
> +	/*
> +	 * Set format on sensor sub device: bus format used to produce memory
> +	 * format is selected at initialization time.
> +	 */
> +	v4l2_fill_mbus_format_mplane(&sd_format.format, pix);
> +	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, &pad_cfg, &sd_format);
> +	if (ret)
> +		return ret;
> +
> +	/* Apply size returned by sensor as the CEU can't scale. */
> +	v4l2_fill_pix_format_mplane(pix, &sd_format.format);
> +
> +	/* Calculate per-plane sizes based on image format. */
> +	ceu_calc_plane_sizes(ceudev, ceu_fmt, pix);
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_set_fmt() - Apply the supplied format to both sensor and CEU
> + */
> +static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	ret = ceu_try_fmt(ceudev, v4l2_fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_mbus_format_mplane(&format.format, &v4l2_fmt->fmt.pix_mp);
> +	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, NULL, &format);
> +	if (ret)
> +		return ret;
> +
> +	ceudev->v4l2_pix = v4l2_fmt->fmt.pix_mp;
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_set_default_fmt() - Apply default NV16 memory output format with VGA
> + *			   sizes.
> + */
> +static int ceu_set_default_fmt(struct ceu_device *ceudev)
> +{
> +	int ret;
> +
> +	struct v4l2_format v4l2_fmt = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +		.fmt.pix_mp = {
> +			.width		= VGA_WIDTH,
> +			.height		= VGA_HEIGHT,
> +			.field		= V4L2_FIELD_NONE,
> +			.pixelformat	= V4L2_PIX_FMT_NV16,
> +			.num_planes	= 2,
> +			.plane_fmt	= {
> +				[0]	= {
> +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> +					.bytesperline = VGA_WIDTH * 2,
> +				},
> +				[1]	= {
> +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> +					.bytesperline = VGA_WIDTH * 2,
> +				},
> +			},
> +		},
> +	};
> +
> +	ret = ceu_try_fmt(ceudev, &v4l2_fmt);
> +	if (ret)
> +		return ret;
> +
> +	ceudev->v4l2_pix = v4l2_fmt.fmt.pix_mp;
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_init_formats() - Query sensor for supported formats and initialize
> + *			CEU supported format list
> + *
> + * Find out if sensor can produce a permutation of 8-bits YUYV bus format.
> + * From a single 8-bits YUYV bus format the CEU can produce several memory
> + * output formats:
> + * - NV[12|21|16|61] through image fetch mode;
> + * - YUYV422 if sensor provides YUYV422
> + *
> + * TODO: Other YUYV422 permutations through data fetch sync mode and DTARY
> + * TODO: Binary data (eg. JPEG) and raw formats through data fetch sync mode
> + */
> +static int ceu_init_formats(struct ceu_device *ceudev)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct ceu_mbus_fmt *mbus_fmt = &ceu_sd->mbus_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	bool yuyv_bus_fmt = false;
> +
> +	struct v4l2_subdev_mbus_code_enum sd_mbus_fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.index = 0,
> +	};
> +
> +	/* Find out if sensor can produce any permutation of 8-bits YUYV422. */
> +	while (!yuyv_bus_fmt &&
> +	       !v4l2_subdev_call(v4l2_sd, pad, enum_mbus_code,
> +				 NULL, &sd_mbus_fmt)) {
> +		switch (sd_mbus_fmt.code) {
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +			yuyv_bus_fmt = true;
> +			break;
> +		default:
> +			/*
> +			 * Only support 8-bits YUYV bus formats at the moment;
> +			 *
> +			 * TODO: add support for binary formats (data sync
> +			 * fetch mode).
> +			 */
> +			break;
> +		}
> +
> +		sd_mbus_fmt.index++;
> +	}
> +
> +	if (!yuyv_bus_fmt)
> +		return -ENXIO;
> +
> +	/*
> +	 * Save the first encountered YUYV format as "mbus_fmt" and use it
> +	 * to output all planar YUV422 and YUV420 (NV*) formats to memory as
> +	 * well as for data synch fetch mode (YUYV - YVYU etc. ).
> +	 */
> +	mbus_fmt->mbus_code	= sd_mbus_fmt.code;
> +	mbus_fmt->bps		= 8;
> +
> +	/* Annotate the selected bus format components ordering. */
> +	switch (sd_mbus_fmt.code) {
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_YUYV;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_YVYU;
> +		mbus_fmt->swapped		= false;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_YVYU;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_YUYV;
> +		mbus_fmt->swapped		= true;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_UYVY;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_VYUY;
> +		mbus_fmt->swapped		= false;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_VYUY;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_UYVY;
> +		mbus_fmt->swapped		= true;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +	}
> +
> +	ceudev->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +/* --- Runtime PM Handlers --- */
> +
> +/*
> + * ceu_runtime_resume() - soft-reset the interface and turn sensor power on.
> + */
> +static int ceu_runtime_resume(struct device *dev)
> +{
> +	struct ceu_device *ceudev = dev_get_drvdata(dev);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	v4l2_subdev_call(v4l2_sd, core, s_power, 1);
> +
> +	ceu_soft_reset(ceudev);
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_runtime_suspend() - disable capture and interrupts and soft-reset.
> + *			   Turn sensor power off.
> + */
> +static int ceu_runtime_suspend(struct device *dev)
> +{
> +	struct ceu_device *ceudev = dev_get_drvdata(dev);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	v4l2_subdev_call(v4l2_sd, core, s_power, 0);
> +
> +	ceu_write(ceudev, CEU_CEIER, 0);
> +	ceu_soft_reset(ceudev);
> +
> +	return 0;
> +}
> +
> +/* --- File Operations --- */
> +
> +static int ceu_open(struct file *file)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&ceudev->mlock);
> +	/* Causes soft-reset and sensor power on on first open */
> +	pm_runtime_get_sync(ceudev->dev);
> +	mutex_unlock(&ceudev->mlock);
> +
> +	return 0;
> +}
> +
> +static int ceu_release(struct file *file)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	vb2_fop_release(file);
> +
> +	mutex_lock(&ceudev->mlock);
> +	/* Causes soft-reset and sensor power down on last close */
> +	pm_runtime_put(ceudev->dev);
> +	mutex_unlock(&ceudev->mlock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations ceu_fops = {
> +	.owner			= THIS_MODULE,
> +	.open			= ceu_open,
> +	.release		= ceu_release,
> +	.unlocked_ioctl		= video_ioctl2,
> +	.read			= vb2_fop_read,
> +	.mmap			= vb2_fop_mmap,
> +	.poll			= vb2_fop_poll,
> +};
> +
> +/* --- Video Device IOCTLs --- */
> +
> +static int ceu_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	strlcpy(cap->card, "Renesas CEU", sizeof(cap->card));
> +	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:renesas-ceu-%s", dev_name(ceudev->dev));
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	const struct ceu_fmt *fmt;
> +
> +	if (f->index >= ARRAY_SIZE(ceu_fmt_list))
> +		return -EINVAL;
> +
> +	fmt = &ceu_fmt_list[f->index];
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int ceu_try_fmt_vid_cap(struct file *file, void *priv,
> +			       struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	return ceu_try_fmt(ceudev, f);
> +}
> +
> +static int ceu_s_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (vb2_is_streaming(&ceudev->vb2_vq))
> +		return -EBUSY;
> +
> +	return ceu_set_fmt(ceudev, f);
> +}
> +
> +static int ceu_g_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	f->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;

This is already filled in, no need to set type again.

> +	f->fmt.pix_mp = ceudev->v4l2_pix;
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_input(struct file *file, void *priv,
> +			  struct v4l2_input *inp)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceusd;
> +
> +	if (inp->index >= ceudev->num_sd)
> +		return -EINVAL;
> +
> +	ceusd = &ceudev->subdevs[inp->index];
> +
> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +	inp->std = 0;
> +	snprintf(inp->name, sizeof(inp->name), "Camera%u: %s",
> +		 inp->index, ceusd->v4l2_sd->name);
> +
> +	return 0;
> +}
> +
> +static int ceu_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	*i = ceudev->sd_index;
> +
> +	return 0;
> +}
> +
> +static int ceu_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd_old;
> +	int ret;
> +

Add a check:

	if (i == ceudev->sd_index)
		return 0;

I.e. if the new input == the old input, then that's fine regardless of the
streaming state.

> +	if (vb2_is_streaming(&ceudev->vb2_vq))
> +		return -EBUSY;
> +
> +	if (i >= ceudev->num_sd)
> +		return -EINVAL;

Move this up as the first test.

> +
> +	ceu_sd_old = ceudev->sd;
> +	ceudev->sd = &ceudev->subdevs[i];
> +
> +	/* Make sure we can generate output image formats. */
> +	ret = ceu_init_formats(ceudev);
> +	if (ret) {
> +		ceudev->sd = ceu_sd_old;
> +		return -EINVAL;
> +	}
> +
> +	/* now that we're sure we can use the sensor, power off the old one. */
> +	v4l2_subdev_call(ceu_sd_old->v4l2_sd, core, s_power, 0);
> +	v4l2_subdev_call(ceudev->sd->v4l2_sd, core, s_power, 1);
> +
> +	ceudev->sd_index = i;
> +
> +	return 0;
> +}
> +
> +static int ceu_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, g_parm, a);
> +}
> +
> +static int ceu_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, s_parm, a);
> +}
> +
> +static int ceu_enum_framesizes(struct file *file, void *fh,
> +			       struct v4l2_frmsizeenum *fsize)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	const struct ceu_fmt *ceu_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_frame_size_enum fse = {
> +		.code	= ceu_sd->mbus_fmt.mbus_code,
> +		.index	= fsize->index,
> +		.which	= V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	/* Just check if user supplied pixel format is supported. */
> +	ceu_fmt = get_ceu_fmt_from_fourcc(fsize->pixel_format);
> +	if (!ceu_fmt)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(v4l2_sd, pad, enum_frame_size,
> +			       NULL, &fse);
> +	if (ret)
> +		return ret;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	fsize->discrete.width = CEU_W_MAX(fse.max_width);
> +	fsize->discrete.height = CEU_H_MAX(fse.max_height);
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_frameintervals(struct file *file, void *fh,
> +				   struct v4l2_frmivalenum *fival)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	const struct ceu_fmt *ceu_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_frame_interval_enum fie = {
> +		.code	= ceu_sd->mbus_fmt.mbus_code,
> +		.index = fival->index,
> +		.width = fival->width,
> +		.height = fival->height,
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	/* Just check if user supplied pixel format is supported. */
> +	ceu_fmt = get_ceu_fmt_from_fourcc(fival->pixel_format);
> +	if (!ceu_fmt)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(v4l2_sd, pad, enum_frame_interval, NULL,
> +			       &fie);
> +	if (ret)
> +		return ret;
> +
> +	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +	fival->discrete = fie.interval;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops ceu_ioctl_ops = {
> +	.vidioc_querycap		= ceu_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane	= ceu_enum_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap_mplane	= ceu_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap_mplane	= ceu_s_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap_mplane	= ceu_g_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= ceu_enum_input,
> +	.vidioc_g_input			= ceu_g_input,
> +	.vidioc_s_input			= ceu_s_input,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_g_parm			= ceu_g_parm,
> +	.vidioc_s_parm			= ceu_s_parm,
> +	.vidioc_enum_framesizes		= ceu_enum_framesizes,
> +	.vidioc_enum_frameintervals	= ceu_enum_frameintervals,
> +};
> +
> +/*
> + * ceu_vdev_release() - release CEU video device memory when last reference
> + *			to this driver is closed
> + */
> +static void ceu_vdev_release(struct video_device *vdev)
> +{
> +	struct ceu_device *ceudev = video_get_drvdata(vdev);
> +
> +	kfree(ceudev);
> +}
> +
> +static int ceu_notify_bound(struct v4l2_async_notifier *notifier,
> +			    struct v4l2_subdev *v4l2_sd,
> +			    struct v4l2_async_subdev *asd)
> +{
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> +	struct ceu_subdev *ceu_sd = to_ceu_subdev(asd);
> +
> +	ceu_sd->v4l2_sd = v4l2_sd;
> +	ceudev->num_sd++;
> +
> +	return 0;
> +}
> +
> +static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> +	struct video_device *vdev = &ceudev->vdev;
> +	struct vb2_queue *q = &ceudev->vb2_vq;
> +	struct v4l2_subdev *v4l2_sd;
> +	int ret;
> +
> +	/* Initialize vb2 queue. */
> +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->io_modes		= VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Don't include VB2_USERPTR. It shouldn't be used with dma_contig.

You also added a read() fop (vb2_fop_read), so either add VB2_READ here
or remove the read fop.

> +	q->drv_priv		= ceudev;
> +	q->ops			= &ceu_vb2_ops;
> +	q->mem_ops		= &vb2_dma_contig_memops;
> +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock			= &ceudev->mlock;
> +	q->dev			= ceudev->v4l2_dev.dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Make sure at least one sensor is primary and use it to initialize
> +	 * ceu formats.
> +	 */
> +	if (!ceudev->sd) {
> +		ceudev->sd = &ceudev->subdevs[0];
> +		ceudev->sd_index = 0;
> +	}
> +
> +	v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	ret = ceu_init_formats(ceudev);
> +	if (ret)
> +		return ret;
> +
> +	ret = ceu_set_default_fmt(ceudev);
> +	if (ret)
> +		return ret;
> +
> +	/* Register the video device. */
> +	strncpy(vdev->name, DRIVER_NAME, strlen(DRIVER_NAME));
> +	vdev->v4l2_dev		= v4l2_dev;
> +	vdev->lock		= &ceudev->mlock;
> +	vdev->queue		= &ceudev->vb2_vq;
> +	vdev->ctrl_handler	= v4l2_sd->ctrl_handler;
> +	vdev->fops		= &ceu_fops;
> +	vdev->ioctl_ops		= &ceu_ioctl_ops;
> +	vdev->release		= ceu_vdev_release;
> +	vdev->device_caps	= V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> +				  V4L2_CAP_STREAMING;
> +	video_set_drvdata(vdev, ceudev);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		v4l2_err(vdev->v4l2_dev,
> +			 "video_register_device failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_async_notifier_operations ceu_notify_ops = {
> +	.bound		= ceu_notify_bound,
> +	.complete	= ceu_notify_complete,
> +};
> +
> +/*
> + * ceu_init_async_subdevs() - Initialize CEU subdevices and async_subdevs in
> + *			      ceu device. Both DT and platform data parsing use
> + *			      this routine.
> + *
> + * Returns 0 for success, -ENOMEM for failure.
> + */
> +static int ceu_init_async_subdevs(struct ceu_device *ceudev, unsigned int n_sd)
> +{
> +	/* Reserve memory for 'n_sd' ceu_subdev descriptors. */
> +	ceudev->subdevs = devm_kcalloc(ceudev->dev, n_sd,
> +				       sizeof(*ceudev->subdevs), GFP_KERNEL);
> +	if (!ceudev->subdevs)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Reserve memory for 'n_sd' pointers to async_subdevices.
> +	 * ceudev->asds members will point to &ceu_subdev.asd
> +	 */
> +	ceudev->asds = devm_kcalloc(ceudev->dev, n_sd,
> +				    sizeof(*ceudev->asds), GFP_KERNEL);
> +	if (!ceudev->asds)
> +		return -ENOMEM;
> +
> +	ceudev->sd = NULL;
> +	ceudev->sd_index = 0;
> +	ceudev->num_sd = 0;
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_parse_platform_data() - Initialize async_subdevices using platform
> + *			       device provided data.
> + */
> +static int ceu_parse_platform_data(struct ceu_device *ceudev,
> +				   const struct ceu_platform_data *pdata)
> +{
> +	const struct ceu_async_subdev *async_sd;
> +	struct ceu_subdev *ceu_sd;
> +	unsigned int i;
> +	int ret;
> +
> +	if (pdata->num_subdevs == 0)
> +		return -ENODEV;
> +
> +	ret = ceu_init_async_subdevs(ceudev, pdata->num_subdevs);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < pdata->num_subdevs; i++) {
> +		/* Setup the ceu subdevice and the async subdevice. */
> +		async_sd = &pdata->subdevs[i];
> +		ceu_sd = &ceudev->subdevs[i];
> +
> +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> +
> +		ceu_sd->mbus_flags	= async_sd->flags;
> +		ceu_sd->asd.match_type	= V4L2_ASYNC_MATCH_I2C;
> +		ceu_sd->asd.match.i2c.adapter_id = async_sd->i2c_adapter_id;
> +		ceu_sd->asd.match.i2c.address = async_sd->i2c_address;
> +
> +		ceudev->asds[i] = &ceu_sd->asd;
> +	}
> +
> +	return pdata->num_subdevs;
> +}
> +
> +/*
> + * ceu_parse_dt() - Initialize async_subdevs parsing device tree graph.
> + */
> +static int ceu_parse_dt(struct ceu_device *ceudev)
> +{
> +	struct device_node *of = ceudev->dev->of_node;
> +	struct v4l2_fwnode_endpoint fw_ep;
> +	struct ceu_subdev *ceu_sd;
> +	struct device_node *ep;
> +	unsigned int i;
> +	int num_ep;
> +	int ret;
> +
> +	num_ep = of_graph_get_endpoint_count(of);
> +	if (!num_ep)
> +		return -ENODEV;
> +
> +	ret = ceu_init_async_subdevs(ceudev, num_ep);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < num_ep; i++) {
> +		ep = of_graph_get_endpoint_by_regs(of, 0, i);
> +		if (!ep) {
> +			dev_err(ceudev->dev,
> +				"No subdevice connected on endpoint %u.\n", i);
> +			ret = -ENODEV;
> +			goto error_put_node;
> +		}
> +
> +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
> +		if (ret) {
> +			dev_err(ceudev->dev,
> +				"Unable to parse endpoint #%u.\n", i);
> +			goto error_put_node;
> +		}
> +
> +		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> +			dev_err(ceudev->dev,
> +				"Only parallel input supported.\n");
> +			ret = -EINVAL;
> +			goto error_put_node;
> +		}
> +
> +		/* Setup the ceu subdevice and the async subdevice. */
> +		ceu_sd = &ceudev->subdevs[i];
> +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> +
> +		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
> +		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		ceu_sd->asd.match.fwnode.fwnode =
> +			fwnode_graph_get_remote_port_parent(
> +					of_fwnode_handle(ep));
> +
> +		ceudev->asds[i] = &ceu_sd->asd;
> +		of_node_put(ep);
> +	}
> +
> +	return num_ep;
> +
> +error_put_node:
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +/*
> + * struct ceu_data - Platform specific CEU data
> + * @irq_mask: CETCR mask with all interrupt sources enabled. The mask differs
> + *	      between SH4 and RZ platforms.
> + */
> +struct ceu_data {
> +	u32 irq_mask;
> +};
> +
> +static const struct ceu_data ceu_data_rz = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_RZ,
> +};
> +
> +static const struct ceu_data ceu_data_sh4 = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_SH4,
> +};
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ceu_of_match[] = {
> +	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ceu_of_match);
> +#endif
> +
> +static int ceu_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	const struct ceu_data *ceu_data;
> +	struct ceu_device *ceudev;
> +	struct resource *res;
> +	unsigned int irq;
> +	int num_subdevs;
> +	int ret;
> +
> +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
> +	if (!ceudev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ceudev);
> +	ceudev->dev = dev;
> +
> +	INIT_LIST_HEAD(&ceudev->capture);
> +	spin_lock_init(&ceudev->lock);
> +	mutex_init(&ceudev->mlock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ceudev->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ceudev->base))
> +		goto error_free_ceudev;
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to get irq: %d\n", ret);
> +		goto error_free_ceudev;
> +	}
> +	irq = ret;
> +
> +	ret = devm_request_irq(dev, irq, ceu_irq,
> +			       0, dev_name(dev), ceudev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to request CEU interrupt.\n");
> +		goto error_free_ceudev;
> +	}
> +
> +	pm_runtime_enable(dev);
> +
> +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> +	if (ret)
> +		goto error_pm_disable;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		ceu_data = of_match_device(ceu_of_match, dev)->data;
> +		num_subdevs = ceu_parse_dt(ceudev);
> +	} else if (dev->platform_data) {
> +		/* Assume SH4 if booting with platform data. */
> +		ceu_data = &ceu_data_sh4;
> +		num_subdevs = ceu_parse_platform_data(ceudev,
> +						      dev->platform_data);
> +	} else {
> +		num_subdevs = -EINVAL;
> +	}
> +
> +	if (num_subdevs < 0) {
> +		ret = num_subdevs;
> +		goto error_v4l2_unregister;
> +	}
> +	ceudev->irq_mask = ceu_data->irq_mask;
> +
> +	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
> +	ceudev->notifier.subdevs	= ceudev->asds;
> +	ceudev->notifier.num_subdevs	= num_subdevs;
> +	ceudev->notifier.ops		= &ceu_notify_ops;
> +	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
> +					   &ceudev->notifier);
> +	if (ret)
> +		goto error_v4l2_unregister;
> +
> +	dev_info(dev, "Renesas Capture Engine Unit %s\n", dev_name(dev));
> +
> +	return 0;
> +
> +error_v4l2_unregister:
> +	v4l2_device_unregister(&ceudev->v4l2_dev);
> +error_pm_disable:
> +	pm_runtime_disable(dev);
> +error_free_ceudev:
> +	kfree(ceudev);
> +
> +	return ret;
> +}
> +
> +static int ceu_remove(struct platform_device *pdev)
> +{
> +	struct ceu_device *ceudev = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(ceudev->dev);
> +
> +	v4l2_async_notifier_unregister(&ceudev->notifier);
> +
> +	v4l2_device_unregister(&ceudev->v4l2_dev);
> +
> +	video_unregister_device(&ceudev->vdev);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops ceu_pm_ops = {
> +	SET_RUNTIME_PM_OPS(ceu_runtime_suspend,
> +			   ceu_runtime_resume,
> +			   NULL)
> +};
> +
> +static struct platform_driver ceu_driver = {
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.pm	= &ceu_pm_ops,
> +		.of_match_table = of_match_ptr(ceu_of_match),
> +	},
> +	.probe		= ceu_probe,
> +	.remove		= ceu_remove,
> +};
> +
> +module_platform_driver(ceu_driver);
> +
> +MODULE_DESCRIPTION("Renesas CEU camera driver");
> +MODULE_AUTHOR("Jacopo Mondi <jacopo+renesas@jmondi.org>");
> +MODULE_LICENSE("GPL v2");
> 

Regards,

	Hans
