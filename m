Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35416 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935330AbdCJKj4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:39:56 -0500
Date: Fri, 10 Mar 2017 12:39:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 07/15] atmel-isi: remove dependency of the soc-camera
 framework
Message-ID: <20170310103920.GW3220@valkosipuli.retiisi.org.uk>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306145616.38485-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks! It's very nice to see one more driver converted to stand-alone one!

Speaking of which --- this seems to be the second last one. The only
remaining one is sh_mobile_ceu_camera.c!

On Mon, Mar 06, 2017 at 03:56:08PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch converts the atmel-isi driver from a soc-camera driver to a driver
> that is stand-alone.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/soc_camera/ov2640.c         |   23 +-
>  drivers/media/platform/soc_camera/Kconfig     |    3 +-
>  drivers/media/platform/soc_camera/atmel-isi.c | 1223 +++++++++++++++----------
>  3 files changed, 735 insertions(+), 514 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 56de18263359..b9a0069f5b33 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c

Should this part go to a different patch?

> @@ -794,10 +794,11 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>  		dev_dbg(&client->dev, "%s: Selected cfmt YUYV (YUV422)", __func__);
>  		selected_cfmt_regs = ov2640_yuyv_regs;
>  		break;
> -	default:
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	default:
>  		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
>  		selected_cfmt_regs = ov2640_uyvy_regs;
> +		break;
>  	}
>  
>  	/* reset hardware */
> @@ -865,17 +866,7 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
>  	mf->width	= priv->win->width;
>  	mf->height	= priv->win->height;
>  	mf->code	= priv->cfmt_code;
> -
> -	switch (mf->code) {
> -	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> -	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> -		mf->colorspace = V4L2_COLORSPACE_SRGB;
> -		break;
> -	default:
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		mf->colorspace = V4L2_COLORSPACE_JPEG;
> -	}
> +	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  	mf->field	= V4L2_FIELD_NONE;
>  
>  	return 0;
> @@ -897,17 +888,17 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>  	ov2640_select_win(&mf->width, &mf->height);
>  
>  	mf->field	= V4L2_FIELD_NONE;
> +	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  
>  	switch (mf->code) {
>  	case MEDIA_BUS_FMT_RGB565_2X8_BE:
>  	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> -		mf->colorspace = V4L2_COLORSPACE_SRGB;
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		break;
>  	default:
>  		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		mf->colorspace = V4L2_COLORSPACE_JPEG;
> +		break;
>  	}
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 86d74788544f..a37ec91b026e 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -29,9 +29,8 @@ config VIDEO_SH_MOBILE_CEU
>  
>  config VIDEO_ATMEL_ISI
>  	tristate "ATMEL Image Sensor Interface (ISI) support"
> -	depends on VIDEO_DEV && SOC_CAMERA
> +	depends on VIDEO_V4L2 && OF && HAS_DMA
>  	depends on ARCH_AT91 || COMPILE_TEST
> -	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This module makes the ATMEL Image Sensor Interface available
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 46de657c3e6d..a837b94281ef 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
...
> @@ -457,60 +431,83 @@ static void buffer_queue(struct vb2_buffer *vb)
>  		if (vb2_is_streaming(vb->vb2_queue))
>  			start_dma(isi, buf);
>  	}
> -	spin_unlock_irqrestore(&isi->lock, flags);
> +	spin_unlock_irqrestore(&isi->irqlock, flags);
>  }
>  
>  static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
> -	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct atmel_isi *isi = ici->priv;
> +	struct atmel_isi *isi = vb2_get_drv_priv(vq);
> +	struct frame_buffer *buf, *node;
>  	int ret;
>  
> -	pm_runtime_get_sync(ici->v4l2_dev.dev);
> +	/* Enable stream on the sub device */
> +	ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 1);
> +	if (ret && ret != -ENOIOCTLCMD) {
> +		v4l2_err(&isi->v4l2_dev, "stream on failed in subdev\n");

You mostly use dev_*() functions to print infromation in the driver. How
about using them consistently? There are few other cases of v4l2_err(), too.

> +		goto err_start_stream;
> +	}
> +
> +	pm_runtime_get_sync(isi->dev);
>  
>  	/* Reset ISI */
>  	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
>  	if (ret < 0) {
> -		dev_err(icd->parent, "Reset ISI timed out\n");
> -		pm_runtime_put(ici->v4l2_dev.dev);
> -		return ret;
> +		dev_err(isi->dev, "Reset ISI timed out\n");
> +		goto err_reset;
>  	}
>  	/* Disable all interrupts */
>  	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
>  
> -	configure_geometry(isi, icd->user_width, icd->user_height,
> -				icd->current_fmt);
> +	isi->sequence = 0;
> +	configure_geometry(isi);
>  
> -	spin_lock_irq(&isi->lock);
> +	spin_lock_irq(&isi->irqlock);
>  	/* Clear any pending interrupt */
>  	isi_readl(isi, ISI_STATUS);
>  
> -	if (count)
> -		start_dma(isi, isi->active);
> -	spin_unlock_irq(&isi->lock);
> +	start_dma(isi, isi->active);
> +	spin_unlock_irq(&isi->irqlock);
>  
>  	return 0;
> +
> +err_reset:
> +	pm_runtime_put(isi->dev);
> +	v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
> +
> +err_start_stream:
> +	spin_lock_irq(&isi->irqlock);
> +	isi->active = NULL;
> +	/* Release all active buffers */
> +	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
> +		list_del_init(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +	}
> +	spin_unlock_irq(&isi->irqlock);
> +
> +	return ret;
>  }
>  
>  /* abort streaming and wait for last buffer */
>  static void stop_streaming(struct vb2_queue *vq)
>  {
> -	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct atmel_isi *isi = ici->priv;
> +	struct atmel_isi *isi = vb2_get_drv_priv(vq);
>  	struct frame_buffer *buf, *node;
>  	int ret = 0;
>  	unsigned long timeout;
>  
> -	spin_lock_irq(&isi->lock);
> +	/* Disable stream on the sub device */
> +	ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		v4l2_err(&isi->v4l2_dev, "stream off failed in subdev\n");
> +
> +	spin_lock_irq(&isi->irqlock);
>  	isi->active = NULL;
>  	/* Release all active buffers */
>  	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
>  		list_del_init(&buf->list);
>  		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>  	}
> -	spin_unlock_irq(&isi->lock);
> +	spin_unlock_irq(&isi->irqlock);
>  
>  	if (!isi->enable_preview_path) {
>  		timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;

...

> @@ -1021,13 +864,349 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>  	return 0;
>  }
>  
> +static int isi_open(struct file *file)
> +{
> +	struct atmel_isi *isi = video_drvdata(file);
> +	struct v4l2_subdev *sd = isi->entity.subdev;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&isi->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto fh_rel;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto fh_rel;
> +
> +	ret = isi_set_fmt(isi, &isi->fmt);
> +	if (ret)
> +		v4l2_subdev_call(sd, core, s_power, 0);
> +fh_rel:
> +	if (ret)
> +		v4l2_fh_release(file);
> +unlock:
> +	mutex_unlock(&isi->lock);
> +	return ret;
> +}
> +
> +static int isi_release(struct file *file)
> +{
> +	struct atmel_isi *isi = video_drvdata(file);
> +	struct v4l2_subdev *sd = isi->entity.subdev;
> +	bool fh_singular;
> +	int ret;
> +
> +	mutex_lock(&isi->lock);
> +
> +	fh_singular = v4l2_fh_is_singular_file(file);
> +
> +	ret = _vb2_fop_release(file, NULL);
> +
> +	if (fh_singular)
> +		v4l2_subdev_call(sd, core, s_power, 0);
> +
> +	mutex_unlock(&isi->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ioctl_ops isi_ioctl_ops = {
> +	.vidioc_querycap		= isi_querycap,
> +
> +	.vidioc_try_fmt_vid_cap		= isi_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= isi_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= isi_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	= isi_enum_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= isi_enum_input,
> +	.vidioc_g_input			= isi_g_input,
> +	.vidioc_s_input			= isi_s_input,
> +
> +	.vidioc_g_parm			= isi_g_parm,
> +	.vidioc_s_parm			= isi_s_parm,
> +	.vidioc_enum_framesizes		= isi_enum_framesizes,
> +	.vidioc_enum_frameintervals	= isi_enum_frameintervals,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +static const struct v4l2_file_operations isi_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= isi_open,
> +	.release	= isi_release,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +	.read		= vb2_fop_read,
> +};
> +
> +static int isi_set_default_fmt(struct atmel_isi *isi)
> +{
> +	struct v4l2_format f = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.fmt.pix = {
> +			.width		= VGA_WIDTH,
> +			.height		= VGA_HEIGHT,
> +			.field		= V4L2_FIELD_NONE,
> +			.pixelformat	= isi->user_formats[0]->fourcc,
> +		},
> +	};
> +	int ret;
> +
> +	ret = isi_try_fmt(isi, &f, NULL);
> +	if (ret)
> +		return ret;
> +	isi->current_fmt = isi->user_formats[0];
> +	isi->fmt = f;
> +	return 0;
> +}
> +
> +static struct isi_format *find_format_by_code(unsigned int code, int *index)
> +{
> +	struct isi_format *fmt = &isi_formats[0];
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isi_formats); i++) {
> +		if (fmt->mbus_code == code && !fmt->support && !fmt->skip) {
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
> +static int isi_formats_init(struct atmel_isi *isi)
> +{
> +	struct isi_format *fmt;
> +	struct v4l2_subdev *subdev = isi->entity.subdev;
> +	int num_fmts = 0, i, j;
> +	struct v4l2_subdev_mbus_code_enum mbus_code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	fmt = &isi_formats[0];
> +
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
> +	       NULL, &mbus_code)) {
> +		fmt = find_format_by_code(mbus_code.code, &i);
> +		if (!fmt) {
> +			mbus_code.index++;
> +			continue;
> +		}
> +
> +		fmt->support = true;
> +		for (i = 0; i < ARRAY_SIZE(isi_formats); i++)
> +			if (isi_formats[i].fourcc == fmt->fourcc &&
> +			    !isi_formats[i].support)
> +				isi_formats[i].skip = true;
> +		num_fmts++;
> +	}
> +
> +	if (!num_fmts)
> +		return -ENXIO;
> +
> +	isi->num_user_formats = num_fmts;
> +	isi->user_formats = devm_kcalloc(isi->dev,
> +					 num_fmts, sizeof(struct isi_format *),
> +					 GFP_KERNEL);
> +	if (!isi->user_formats) {
> +		v4l2_err(&isi->v4l2_dev, "could not allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	fmt = &isi_formats[0];
> +	for (i = 0, j = 0; i < ARRAY_SIZE(isi_formats); i++) {
> +		if (fmt->support)
> +			isi->user_formats[j++] = fmt;
> +
> +		fmt++;
> +	}
> +	isi->current_fmt = isi->user_formats[0];
> +
> +	return 0;
> +}
> +
> +static int isi_graph_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct atmel_isi *isi = notifier_to_isi(notifier);
> +	int ret;
> +
> +	isi->vdev->ctrl_handler	= isi->entity.subdev->ctrl_handler;
> +	ret = isi_formats_init(isi);
> +	if (ret) {
> +		dev_err(isi->dev, "No supported mediabus format found\n");
> +		return ret;
> +	}
> +	isi_camera_set_bus_param(isi);
> +
> +	ret = isi_set_default_fmt(isi);
> +	if (ret) {
> +		dev_err(isi->dev, "Could not set default format\n");
> +		return ret;
> +	}
> +
> +	ret = video_register_device(isi->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(isi->dev, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	dev_info(isi->dev, "Device registered as %s\n",
> +		 video_device_node_name(isi->vdev));

dev_dbg()?

> +	return 0;
> +}
> +
> +static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
> +				     struct v4l2_subdev *sd,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct atmel_isi *isi = notifier_to_isi(notifier);
> +
> +	dev_info(isi->dev, "Removing %s\n",
> +		 video_device_node_name(isi->vdev));

Fits on a single line. dev_dbg()=

> +
> +	/* Checks internaly if vdev have been init or not */
> +	video_unregister_device(isi->vdev);
> +}
> +
> +static int isi_graph_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct atmel_isi *isi = notifier_to_isi(notifier);
> +
> +	dev_dbg(isi->dev, "subdev %s bound\n", subdev->name);
> +
> +	isi->entity.subdev = subdev;
> +
> +	return 0;
> +}
> +
> +static int isi_graph_parse(struct atmel_isi *isi,
> +			    struct device_node *node)

Fits on a single line.

> +{
> +	struct device_node *remote;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	int ret = 0;
> +
> +	while (1) {
> +		next = of_graph_get_next_endpoint(node, ep);
> +		if (!next)
> +			break;

You could make this a while loop condition.

> +
> +		of_node_put(ep);

ep is put by of_graph_get_next_endpoint(), no need to do it manually here.

> +		ep = next;
> +
> +		remote = of_graph_get_remote_port_parent(ep);
> +		if (!remote) {

of_node_put(ep);

> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		/* Skip entities that we have already processed. */
> +		if (remote == isi->dev->of_node) {
> +			of_node_put(remote);
> +			continue;
> +		}
> +
> +		/* Remote node to connect */
> +		if (!isi->entity.node) {

There would have to be something wrong about the DT graph for the two above
to happen. I guess one could just return an error if something is terribly
wrong.

I'm thinking this from the point of view of making this function generic,
and moving it to the framework as most drivers to something very similar,
but I'd prefer to get the fwnode patches in first.

> +			isi->entity.node = remote;

You could use entity.asd.match.of.node instead, and drop the node field.

> +			isi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
> +			isi->entity.asd.match.of.node = remote;
> +			ret++;
> +		}
> +	}
> +
> +	of_node_put(ep);
> +
> +	return ret;
> +}
> +
> +static int isi_graph_init(struct atmel_isi *isi)
> +{
> +	struct v4l2_async_subdev **subdevs = NULL;
> +	int ret;
> +
> +	/* Parse the graph to extract a list of subdevice DT nodes. */
> +	ret = isi_graph_parse(isi, isi->dev->of_node);
> +	if (ret < 0) {
> +		dev_err(isi->dev, "Graph parsing failed\n");
> +		goto done;
> +	}
> +
> +	if (!ret) {
> +		dev_err(isi->dev, "No subdev found in graph\n");
> +		goto done;
> +	}
> +
> +	if (ret != 1) {
> +		dev_err(isi->dev, "More then one subdev found in graph\n");

Is this an error case? As there's no allocation of memory for subdevs, I
assume so. If multiple devices aren't supported (driver or hardware), how
about flagging this as an error in isi_graph_parse() instead? Putting the
related OF node could be done there, too.

> +		goto done;
> +	}
> +
> +	/* Register the subdevices notifier. */
> +	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
> +	if (subdevs == NULL) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	subdevs[0] = &isi->entity.asd;
> +
> +	isi->notifier.subdevs = subdevs;
> +	isi->notifier.num_subdevs = 1;
> +	isi->notifier.bound = isi_graph_notify_bound;
> +	isi->notifier.unbind = isi_graph_notify_unbind;
> +	isi->notifier.complete = isi_graph_notify_complete;
> +
> +	ret = v4l2_async_notifier_register(&isi->v4l2_dev, &isi->notifier);
> +	if (ret < 0) {
> +		dev_err(isi->dev, "Notifier registration failed\n");
> +		goto done;
> +	}
> +
> +	ret = 0;
> +
> +done:
> +	if (ret < 0) {
> +		v4l2_async_notifier_unregister(&isi->notifier);
> +		of_node_put(isi->entity.node);
> +	}
> +
> +	return ret;
> +}
> +
> +
>  static int atmel_isi_probe(struct platform_device *pdev)
>  {
>  	int irq;
>  	struct atmel_isi *isi;
> +	struct vb2_queue *q;
>  	struct resource *regs;
>  	int ret, i;
> -	struct soc_camera_host *soc_host;
>  
>  	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
>  	if (!isi) {

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
