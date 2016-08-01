Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54068 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbcHAJsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 05:48:23 -0400
Subject: Re: [PATCH v7 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@atmel.com
References: <1469778856-24253-1-git-send-email-songjun.wu@microchip.com>
 <1469778856-24253-2-git-send-email-songjun.wu@microchip.com>
Cc: robh@kernel.org, laurent.pinchart@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, linux-kernel@vger.kernel.org,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f77652aa-3d41-d85f-11a9-9f5290223834@xs4all.nl>
Date: Mon, 1 Aug 2016 11:47:29 +0200
MIME-Version: 1.0
In-Reply-To: <1469778856-24253-2-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Songjun,

Some more comments below. Except for one in the open/release functions
it's all small things.

On 07/29/2016 09:54 AM, Songjun Wu wrote:
> Add driver for the Image Sensor Controller. It manages
> incoming data from a parallel based CMOS/CCD sensor.
> It has an internal image processor, also integrates a
> triple channel direct memory access controller master
> interface.
> 
> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
> ---
> 
> Changes in v7:
> - Add enum_framesizes and enum_frameintervals.
> - Call s_stream(0) when stream start fail.
> - Fill the device_caps field of struct video_device
>   with V4L2_CAP_STREAMING and V4L2_CAP_VIDEO_CAPTURE.
> - Initialize the dev of struct vb2_queue.
> - Set field to FIELD_NONE if the pix field is not supported.
> - Return the result directly when call g/s_parm of subdev.
> 
> Changes in v6: None
> Changes in v5:
> - Modify the macro definition and the related code.
> 
> Changes in v4:
> - Modify the isc clock code since the dt is changed.
> 
> Changes in v3:
> - Add pm runtime feature.
> - Modify the isc clock code since the dt is changed.
> 
> Changes in v2:
> - Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
>   in Kconfig file.
> - Correct typos and coding style according to Laurent's remarks
> - Delete the loop while in 'isc_clk_enable' function.
> - Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
>   with 'pfe_cfg0' in struct isc_subdev_entity.
> - Add the code to support VIDIOC_CREATE_BUFS in
>   'isc_queue_setup' function.
> - Invoke isc_config to configure register in
>   'isc_start_streaming' function.
> - Add the struct completion 'comp' to synchronize with
>   the frame end interrupt in 'isc_stop_streaming' function.
> - Check the return value of the clk_prepare_enable
>   in 'isc_open' function.
> - Set the default format in 'isc_open' function.
> - Add an exit condition in the loop while in 'isc_config'.
> - Delete the hardware setup operation in 'isc_set_format'.
> - Refuse format modification during streaming
>   in 'isc_s_fmt_vid_cap' function.
> - Invoke v4l2_subdev_alloc_pad_config to allocate and
>   initialize the pad config in 'isc_async_complete' function.
> - Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
> - Replace the module_platform_driver_probe() with
>   module_platform_driver().
> 
>  drivers/media/platform/Kconfig                |    1 +
>  drivers/media/platform/Makefile               |    2 +
>  drivers/media/platform/atmel/Kconfig          |    9 +
>  drivers/media/platform/atmel/Makefile         |    1 +
>  drivers/media/platform/atmel/atmel-isc-regs.h |  165 +++
>  drivers/media/platform/atmel/atmel-isc.c      | 1611 +++++++++++++++++++++++++
>  6 files changed, 1789 insertions(+)
>  create mode 100644 drivers/media/platform/atmel/Kconfig
>  create mode 100644 drivers/media/platform/atmel/Makefile
>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c
> 

<snip>

> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> new file mode 100644
> index 0000000..f2ef664
> --- /dev/null
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -0,0 +1,1611 @@

<snip>

> +static unsigned int sensor_preferred = 1;
> +module_param(sensor_preferred, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(sensor_preferred,
> +		 "Sensor is preferred to output the specified format (1-on 0-off) default 1");

I have no idea what this means. Can you elaborate? Why would you want to set this to 0?

<snip>

> +static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
> +{
> +	if ((sensor_preferred && isc_fmt->sd_support) ||
> +	    !isc_fmt->isc_support)

I'd just do:

	return (sensor_preferred && isc_fmt->sd_support) ||
	       !isc_fmt->isc_support;

> +		return true;
> +	else
> +		return false;
> +}
> +

<snip>

> +static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
> +			struct isc_format **current_fmt, u32 *code)
> +{
> +	struct isc_format *isc_fmt;
> +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +	u32 mbus_code;
> +	int ret;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	isc_fmt = find_format_by_fourcc(isc, pixfmt->pixelformat);
> +	if (!isc_fmt) {
> +		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
> +			  pixfmt->pixelformat);
> +		isc_fmt = isc->user_formats[isc->num_user_formats - 1];
> +		pixfmt->pixelformat = isc_fmt->fourcc;
> +	}
> +
> +	/* Limit to Atmel ISC hardware capabilities */
> +	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
> +		pixfmt->width = ISC_MAX_SUPPORT_WIDTH;
> +	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
> +		pixfmt->height = ISC_MAX_SUPPORT_HEIGHT;
> +
> +	if (sensor_is_preferred(isc_fmt))
> +		mbus_code = isc_fmt->sd_mbus_code;
> +	else
> +		mbus_code = isc_fmt->isc_mbus_code;
> +
> +	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
> +	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
> +			       isc->current_subdev->config, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pixfmt, &format.format);
> +
> +	switch (pixfmt->field) {
> +	case V4L2_FIELD_ANY:
> +	case V4L2_FIELD_NONE:
> +		break;
> +	default:
> +		pixfmt->field = V4L2_FIELD_NONE;
> +	}

Drop the switch and just always set field to FIELD_NONE.

> +
> +	pixfmt->bytesperline = pixfmt->width * isc_fmt->bpp;
> +	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> +
> +	if (current_fmt)
> +		*current_fmt = isc_fmt;
> +
> +	if (code)
> +		*code = mbus_code;
> +
> +	return 0;
> +}

<snip>

> +static int isc_set_default_fmt(struct isc_device *isc)
> +{
> +	u32 index = isc->num_user_formats - 1;
> +	struct v4l2_format f = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.fmt.pix = {
> +			.width		= VGA_WIDTH,
> +			.height		= VGA_HEIGHT,
> +			.field		= V4L2_FIELD_ANY,

Use FIELD_NONE instead of ANY.

> +			.pixelformat	= isc->user_formats[index]->fourcc,
> +		},
> +	};
> +
> +	return isc_set_fmt(isc, &f);
> +}
> +
> +static int isc_open(struct file *file)
> +{
> +	struct isc_device *isc = video_drvdata(file);
> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&isc->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);

Only do this if this is the first open...

> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto unlock;
> +
> +	ret = isc_set_default_fmt(isc);
> +	if (ret)
> +		goto unlock;
> +
> +unlock:
> +	mutex_unlock(&isc->lock);
> +	return ret;
> +}
> +
> +static int isc_release(struct file *file)
> +{
> +	struct isc_device *isc = video_drvdata(file);
> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
> +	int ret;
> +
> +	mutex_lock(&isc->lock);
> +
> +	ret = _vb2_fop_release(file, NULL);
> +
> +	v4l2_subdev_call(sd, core, s_power, 0);

...and only do this on the last release.

Otherwise a simple 'v4l2-ctl -D' call would turn off the power when it closes its
filehandle, even if another process is streaming.

See drivers/media/platform/am437x/am437x-vpfe.c for a good example on how to handle
this (search for v4l2_fh_is_singular).

> +
> +	mutex_unlock(&isc->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations isc_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= isc_open,
> +	.release	= isc_release,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.read		= vb2_fop_read,
> +	.mmap		= vb2_fop_mmap,
> +	.poll		= vb2_fop_poll,
> +};
> +
> +static irqreturn_t isc_interrupt(int irq, void *dev_id)
> +{
> +	struct isc_device *isc = (struct isc_device *)dev_id;
> +	struct regmap *regmap = isc->regmap;
> +	u32 isc_intsr, isc_intmask, pending;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	spin_lock(&isc->dma_queue_lock);
> +
> +	regmap_read(regmap, ISC_INTSR, &isc_intsr);
> +	regmap_read(regmap, ISC_INTMASK, &isc_intmask);
> +
> +	pending = isc_intsr & isc_intmask;
> +
> +	if (likely(pending & ISC_INT_DDONE)) {
> +		if (isc->cur_frm) {
> +			struct vb2_v4l2_buffer *vbuf = &isc->cur_frm->vb;
> +			struct vb2_buffer *vb = &vbuf->vb2_buf;
> +
> +			vb->timestamp = ktime_get_ns();
> +			vbuf->sequence = isc->sequence++;
> +			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +			isc->cur_frm = NULL;
> +		}
> +
> +		if (!list_empty(&isc->dma_queue) && !isc->stop) {
> +			isc->cur_frm = list_first_entry(&isc->dma_queue,
> +						     struct isc_buffer, list);
> +			list_del(&isc->cur_frm->list);
> +
> +			isc_start_dma(regmap, isc->cur_frm,
> +				      isc->current_fmt->reg_dctrl_dview);
> +		}
> +
> +		if (isc->stop)
> +			complete(&isc->comp);
> +
> +		ret = IRQ_HANDLED;
> +	}
> +
> +	spin_unlock(&isc->dma_queue_lock);
> +
> +	return ret;
> +}
> +
> +static int isc_async_bound(struct v4l2_async_notifier *notifier,
> +			    struct v4l2_subdev *subdev,
> +			    struct v4l2_async_subdev *asd)
> +{
> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
> +					      struct isc_device, v4l2_dev);
> +	struct isc_subdev_entity *subdev_entity =
> +		container_of(notifier, struct isc_subdev_entity, notifier);
> +
> +	if (video_is_registered(&isc->video_dev)) {
> +		v4l2_err(&isc->v4l2_dev, "only supports one sub-device.\n");
> +		return -EBUSY;
> +	}
> +
> +	subdev_entity->sd = subdev;
> +
> +	return 0;
> +}
> +
> +static void isc_async_unbind(struct v4l2_async_notifier *notifier,
> +			      struct v4l2_subdev *subdev,
> +			      struct v4l2_async_subdev *asd)
> +{
> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
> +					      struct isc_device, v4l2_dev);
> +
> +	video_unregister_device(&isc->video_dev);
> +	if (isc->current_subdev->config)
> +		v4l2_subdev_free_pad_config(isc->current_subdev->config);
> +}
> +
> +static struct isc_format *find_format_by_code(unsigned int code, int *index)
> +{
> +	struct isc_format *fmt = &isc_formats[0];
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
> +		if (fmt->sd_mbus_code == code) {
> +			*index = i;
> +			return fmt;
> +		}
> +
> +		fmt++;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int isc_formats_init(struct isc_device *isc)
> +{
> +	struct isc_format *fmt;
> +	struct v4l2_subdev *subdev = isc->current_subdev->sd;
> +	int num_fmts, i, j;
> +	struct v4l2_subdev_mbus_code_enum mbus_code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	fmt = &isc_formats[0];
> +	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
> +		fmt->isc_support = false;
> +		fmt->sd_support = false;
> +
> +		fmt++;
> +	}
> +
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
> +	       NULL, &mbus_code)) {
> +		mbus_code.index++;
> +		fmt = find_format_by_code(mbus_code.code, &i);
> +		if (!fmt)
> +			continue;
> +
> +		fmt->sd_support = true;
> +
> +		if (i <= RAW_FMT_INDEX_END) {
> +			for (j = ISC_FMT_INDEX_START;
> +			     j <= ISC_FMT_INDEX_END; j++) {
> +				isc_formats[j].isc_support = true;
> +				isc_formats[j].isc_mbus_code = mbus_code.code;
> +				isc_formats[j].reg_isc_bps = fmt->reg_sd_bps;
> +				isc_formats[j].reg_bay_cfg = fmt->reg_bay_cfg;
> +			}
> +		}
> +	}
> +
> +	fmt = &isc_formats[0];
> +	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
> +		if (fmt->isc_support || fmt->sd_support)
> +			num_fmts++;
> +
> +		fmt++;
> +	}
> +
> +	if (!num_fmts)
> +		return -ENXIO;
> +
> +	isc->num_user_formats = num_fmts;
> +	isc->user_formats = devm_kcalloc(isc->dev,
> +					 num_fmts, sizeof(struct isc_format *),
> +					 GFP_KERNEL);
> +	if (!isc->user_formats) {
> +		v4l2_err(&isc->v4l2_dev, "could not allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	fmt = &isc_formats[0];
> +	for (i = 0, j = 0; i < ARRAY_SIZE(isc_formats); i++) {
> +		if (fmt->isc_support || fmt->sd_support)
> +			isc->user_formats[j++] = fmt;
> +
> +		fmt++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int isc_async_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
> +					      struct isc_device, v4l2_dev);
> +	struct isc_subdev_entity *sd_entity;
> +	struct video_device *vdev = &isc->video_dev;
> +	struct vb2_queue *q = &isc->vb2_vidq;
> +	int ret;
> +
> +	isc->current_subdev = container_of(notifier,
> +					   struct isc_subdev_entity, notifier);
> +	sd_entity = isc->current_subdev;
> +
> +	mutex_init(&isc->lock);
> +	init_completion(&isc->comp);
> +
> +	/* Initialize videobuf2 queue */
> +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes		= VB2_MMAP;

Is there any reason VB2_DMABUF and VB2_READ are missing here?

> +	q->drv_priv		= isc;
> +	q->buf_struct_size	= sizeof(struct isc_buffer);
> +	q->ops			= &isc_vb2_ops;
> +	q->mem_ops		= &vb2_dma_contig_memops;
> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock			= &isc->lock;
> +	q->min_buffers_needed	= 1;
> +	q->dev			= isc->dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		v4l2_err(&isc->v4l2_dev,
> +			 "vb2_queue_init() failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Init video dma queues */
> +	INIT_LIST_HEAD(&isc->dma_queue);
> +	spin_lock_init(&isc->dma_queue_lock);
> +
> +	/* Register video device */
> +	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
> +	vdev->release		= video_device_release_empty;
> +	vdev->fops		= &isc_fops;
> +	vdev->ioctl_ops		= &isc_ioctl_ops;
> +	vdev->v4l2_dev		= &isc->v4l2_dev;
> +	vdev->vfl_dir		= VFL_DIR_RX;
> +	vdev->queue		= q;
> +	vdev->lock		= &isc->lock;
> +	vdev->ctrl_handler	= isc->current_subdev->sd->ctrl_handler;
> +	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> +	video_set_drvdata(vdev, isc);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		v4l2_err(&isc->v4l2_dev,
> +			 "video_register_device failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	sd_entity->config = v4l2_subdev_alloc_pad_config(sd_entity->sd);
> +	if (sd_entity->config == NULL)
> +		return -ENOMEM;
> +
> +	ret = isc_formats_init(isc);
> +	if (ret < 0) {
> +		v4l2_err(&isc->v4l2_dev,
> +			 "Init format failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Regards,

	Hans
