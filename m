Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50622 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeAPRTD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 12:19:03 -0500
Date: Tue, 16 Jan 2018 18:18:56 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/9] v4l: platform: Add Renesas CEU driver
Message-ID: <20180116171856.GD24926@w540>
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-4-git-send-email-jacopo+renesas@jmondi.org>
 <ba0540cd-c0b9-31a3-4bc8-7f32e4d85cf5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba0540cd-c0b9-31a3-4bc8-7f32e4d85cf5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jan 16, 2018 at 10:46:42AM +0100, Hans Verkuil wrote:
> Hi Jacopo,
>
> Sorry for the late review, but here is finally is.
>
> BTW, can you provide the v4l2-compliance output (ideally with the -f option)
> in the cover letter for v6?

Sure, it was attacched to v3 I guess, since then it has not changed.
I will include that in v6 cover letter.

> On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> > Add driver for Renesas Capture Engine Unit (CEU).
> >
> > The CEU interface supports capturing 'data' (YUV422) and 'images'
> > (NV[12|21|16|61]).
> >
> > This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> >
> > Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> > platform GR-Peach.
> >
> > Tested with ov7725 camera sensor on SH4 platform Migo-R.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/platform/Kconfig       |    9 +
> >  drivers/media/platform/Makefile      |    1 +
> >  drivers/media/platform/renesas-ceu.c | 1648 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 1658 insertions(+)
> >  create mode 100644 drivers/media/platform/renesas-ceu.c
> >
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index fd0c998..fe7bd26 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -144,6 +144,15 @@ config VIDEO_STM32_DCMI
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called stm32-dcmi.
> >
> > +config VIDEO_RENESAS_CEU
> > +	tristate "Renesas Capture Engine Unit (CEU) driver"
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> > +	depends on ARCH_SHMOBILE || ARCH_R7S72100 || COMPILE_TEST
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select V4L2_FWNODE
> > +	---help---
> > +	  This is a v4l2 driver for the Renesas CEU Interface
> > +
> >  source "drivers/media/platform/soc_camera/Kconfig"
> >  source "drivers/media/platform/exynos4-is/Kconfig"
> >  source "drivers/media/platform/am437x/Kconfig"
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> > index 003b0bb..6580a6b 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -62,6 +62,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
> >  obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
> >
> >  obj-$(CONFIG_VIDEO_RCAR_DRIF)		+= rcar_drif.o
> > +obj-$(CONFIG_VIDEO_RENESAS_CEU)		+= renesas-ceu.o
> >  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
> >  obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
> >  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
> > diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> > new file mode 100644
> > index 0000000..ccca838
> > --- /dev/null
> > +++ b/drivers/media/platform/renesas-ceu.c
>
> <snip>
>
> > +/*
> > + * ceu_vb2_setup() - is called to check whether the driver can accept the
> > + *		     requested number of buffers and to fill in plane sizes
> > + *		     for the current frame format, if required.
> > + */
> > +static int ceu_vb2_setup(struct vb2_queue *vq, unsigned int *count,
> > +			 unsigned int *num_planes, unsigned int sizes[],
> > +			 struct device *alloc_devs[])
> > +{
> > +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> > +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> > +	unsigned int i;
> > +
> > +	if (!*count)
> > +		*count = 2;
>
> Don't do this. Instead set the min_buffers_needed field to 2 in the vb2_queue
> struct.
>

I guess setting min_buffers_needed makes this check not required. Will
drop.

> > +
> > +	/* num_planes is set: just check plane sizes. */
> > +	if (*num_planes) {
> > +		for (i = 0; i < pix->num_planes; i++)
> > +			if (sizes[i] < pix->plane_fmt[i].sizeimage)
> > +				return -EINVAL;
> > +
> > +		return 0;
> > +	}
> > +
> > +	/* num_planes not set: called from REQBUFS, just set plane sizes. */
> > +	*num_planes = pix->num_planes;
> > +	for (i = 0; i < pix->num_planes; i++)
> > +		sizes[i] = pix->plane_fmt[i].sizeimage;
> > +
> > +	return 0;
> > +}
> > +
> > +static void ceu_vb2_queue(struct vb2_buffer *vb)
> > +{
> > +	struct ceu_device *ceudev = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> > +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> > +	struct ceu_buffer *buf = vb2_to_ceu(vbuf);
> > +	unsigned long irqflags;
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < pix->num_planes; i++) {
> > +		if (vb2_plane_size(vb, i) < pix->plane_fmt[i].sizeimage) {
> > +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> > +			return;
> > +		}
> > +
> > +		vb2_set_plane_payload(vb, i, pix->plane_fmt[i].sizeimage);
>
> This is not the right vb2 op for this test, this belongs in the buf_prepare
> op. There you can just return an error and you don't need to call buffer_done.
>

Actually, most (all?) of the mainline drivers also set plane payload
in buf_prepare(). I will move the whole block to that function and
just add the buffer to the capture list here.

> > +
> > +static int ceu_g_fmt_vid_cap(struct file *file, void *priv,
> > +			     struct v4l2_format *f)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +
> > +	f->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>
> This is already filled in, no need to set type again.
>
> > +	f->fmt.pix_mp = ceudev->v4l2_pix;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ceu_enum_input(struct file *file, void *priv,
> > +			  struct v4l2_input *inp)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +	struct ceu_subdev *ceusd;
> > +
> > +	if (inp->index >= ceudev->num_sd)
> > +		return -EINVAL;
> > +
> > +	ceusd = &ceudev->subdevs[inp->index];
> > +
> > +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> > +	inp->std = 0;
> > +	snprintf(inp->name, sizeof(inp->name), "Camera%u: %s",
> > +		 inp->index, ceusd->v4l2_sd->name);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ceu_g_input(struct file *file, void *priv, unsigned int *i)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +
> > +	*i = ceudev->sd_index;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ceu_s_input(struct file *file, void *priv, unsigned int i)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +	struct ceu_subdev *ceu_sd_old;
> > +	int ret;
> > +
>
> Add a check:
>
> 	if (i == ceudev->sd_index)
> 		return 0;
>
> I.e. if the new input == the old input, then that's fine regardless of the
> streaming state.
>
> > +	if (vb2_is_streaming(&ceudev->vb2_vq))
> > +		return -EBUSY;
> > +
> > +	if (i >= ceudev->num_sd)
> > +		return -EINVAL;
>
> Move this up as the first test.
>
> > +
> > +	ceu_sd_old = ceudev->sd;
> > +	ceudev->sd = &ceudev->subdevs[i];
> > +
> > +	/* Make sure we can generate output image formats. */
> > +	ret = ceu_init_formats(ceudev);
> > +	if (ret) {
> > +		ceudev->sd = ceu_sd_old;
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* now that we're sure we can use the sensor, power off the old one. */
> > +	v4l2_subdev_call(ceu_sd_old->v4l2_sd, core, s_power, 0);
> > +	v4l2_subdev_call(ceudev->sd->v4l2_sd, core, s_power, 1);
> > +
> > +	ceudev->sd_index = i;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ceu_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		return -EINVAL;
> > +
> > +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, g_parm, a);
> > +}
> > +
> > +
> > +static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> > +	struct video_device *vdev = &ceudev->vdev;
> > +	struct vb2_queue *q = &ceudev->vb2_vq;
> > +	struct v4l2_subdev *v4l2_sd;
> > +	int ret;
> > +
> > +	/* Initialize vb2 queue. */
> > +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	q->io_modes		= VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>
> Don't include VB2_USERPTR. It shouldn't be used with dma_contig.
>
> You also added a read() fop (vb2_fop_read), so either add VB2_READ here
> or remove the read fop.

As also suggested by Laurent, I'll drop fop_read and remove
VB2_USERPTR from the supported io_modes.

Thanks
   j

>
> > +	q->drv_priv		= ceudev;
> > +	q->ops			= &ceu_vb2_ops;
> > +	q->mem_ops		= &vb2_dma_contig_memops;
> > +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> > +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	q->lock			= &ceudev->mlock;
> > +	q->dev			= ceudev->v4l2_dev.dev;
> > +
> > +	ret = vb2_queue_init(q);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Make sure at least one sensor is primary and use it to initialize
> > +	 * ceu formats.
> > +	 */
> > +	if (!ceudev->sd) {
> > +		ceudev->sd = &ceudev->subdevs[0];
> > +		ceudev->sd_index = 0;
> > +	}
> > +
> > +	v4l2_sd = ceudev->sd->v4l2_sd;
> > +
> > +	ret = ceu_init_formats(ceudev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ceu_set_default_fmt(ceudev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Register the video device. */
> > +	strncpy(vdev->name, DRIVER_NAME, strlen(DRIVER_NAME));
> > +	vdev->v4l2_dev		= v4l2_dev;
> > +	vdev->lock		= &ceudev->mlock;
> > +	vdev->queue		= &ceudev->vb2_vq;
> > +	vdev->ctrl_handler	= v4l2_sd->ctrl_handler;
> > +	vdev->fops		= &ceu_fops;
> > +	vdev->ioctl_ops		= &ceu_ioctl_ops;
> > +	vdev->release		= ceu_vdev_release;
> > +	vdev->device_caps	= V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> > +				  V4L2_CAP_STREAMING;
> > +	video_set_drvdata(vdev, ceudev);
> > +
> > +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +	if (ret < 0) {
> > +		v4l2_err(vdev->v4l2_dev,
> > +			 "video_register_device failed: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_async_notifier_operations ceu_notify_ops = {
> > +	.bound		= ceu_notify_bound,
> > +	.complete	= ceu_notify_complete,
> > +};
> > +
> > +/*
> > + * ceu_init_async_subdevs() - Initialize CEU subdevices and async_subdevs in
> > + *			      ceu device. Both DT and platform data parsing use
> > + *			      this routine.
> > + *
> > + * Returns 0 for success, -ENOMEM for failure.
> > + */
> > +static int ceu_init_async_subdevs(struct ceu_device *ceudev, unsigned int n_sd)
> > +{
> > +	/* Reserve memory for 'n_sd' ceu_subdev descriptors. */
> > +	ceudev->subdevs = devm_kcalloc(ceudev->dev, n_sd,
> > +				       sizeof(*ceudev->subdevs), GFP_KERNEL);
> > +	if (!ceudev->subdevs)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Reserve memory for 'n_sd' pointers to async_subdevices.
> > +	 * ceudev->asds members will point to &ceu_subdev.asd
> > +	 */
> > +	ceudev->asds = devm_kcalloc(ceudev->dev, n_sd,
> > +				    sizeof(*ceudev->asds), GFP_KERNEL);
> > +	if (!ceudev->asds)
> > +		return -ENOMEM;
> > +
> > +	ceudev->sd = NULL;
> > +	ceudev->sd_index = 0;
> > +	ceudev->num_sd = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * ceu_parse_platform_data() - Initialize async_subdevices using platform
> > + *			       device provided data.
> > + */
> > +static int ceu_parse_platform_data(struct ceu_device *ceudev,
> > +				   const struct ceu_platform_data *pdata)
> > +{
> > +	const struct ceu_async_subdev *async_sd;
> > +	struct ceu_subdev *ceu_sd;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	if (pdata->num_subdevs == 0)
> > +		return -ENODEV;
> > +
> > +	ret = ceu_init_async_subdevs(ceudev, pdata->num_subdevs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (i = 0; i < pdata->num_subdevs; i++) {
> > +		/* Setup the ceu subdevice and the async subdevice. */
> > +		async_sd = &pdata->subdevs[i];
> > +		ceu_sd = &ceudev->subdevs[i];
> > +
> > +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> > +
> > +		ceu_sd->mbus_flags	= async_sd->flags;
> > +		ceu_sd->asd.match_type	= V4L2_ASYNC_MATCH_I2C;
> > +		ceu_sd->asd.match.i2c.adapter_id = async_sd->i2c_adapter_id;
> > +		ceu_sd->asd.match.i2c.address = async_sd->i2c_address;
> > +
> > +		ceudev->asds[i] = &ceu_sd->asd;
> > +	}
> > +
> > +	return pdata->num_subdevs;
> > +}
> > +
> > +/*
> > + * ceu_parse_dt() - Initialize async_subdevs parsing device tree graph.
> > + */
> > +static int ceu_parse_dt(struct ceu_device *ceudev)
> > +{
> > +	struct device_node *of = ceudev->dev->of_node;
> > +	struct v4l2_fwnode_endpoint fw_ep;
> > +	struct ceu_subdev *ceu_sd;
> > +	struct device_node *ep;
> > +	unsigned int i;
> > +	int num_ep;
> > +	int ret;
> > +
> > +	num_ep = of_graph_get_endpoint_count(of);
> > +	if (!num_ep)
> > +		return -ENODEV;
> > +
> > +	ret = ceu_init_async_subdevs(ceudev, num_ep);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (i = 0; i < num_ep; i++) {
> > +		ep = of_graph_get_endpoint_by_regs(of, 0, i);
> > +		if (!ep) {
> > +			dev_err(ceudev->dev,
> > +				"No subdevice connected on endpoint %u.\n", i);
> > +			ret = -ENODEV;
> > +			goto error_put_node;
> > +		}
> > +
> > +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
> > +		if (ret) {
> > +			dev_err(ceudev->dev,
> > +				"Unable to parse endpoint #%u.\n", i);
> > +			goto error_put_node;
> > +		}
> > +
> > +		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> > +			dev_err(ceudev->dev,
> > +				"Only parallel input supported.\n");
> > +			ret = -EINVAL;
> > +			goto error_put_node;
> > +		}
> > +
> > +		/* Setup the ceu subdevice and the async subdevice. */
> > +		ceu_sd = &ceudev->subdevs[i];
> > +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> > +
> > +		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
> > +		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +		ceu_sd->asd.match.fwnode.fwnode =
> > +			fwnode_graph_get_remote_port_parent(
> > +					of_fwnode_handle(ep));
> > +
> > +		ceudev->asds[i] = &ceu_sd->asd;
> > +		of_node_put(ep);
> > +	}
> > +
> > +	return num_ep;
> > +
> > +error_put_node:
> > +	of_node_put(ep);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * struct ceu_data - Platform specific CEU data
> > + * @irq_mask: CETCR mask with all interrupt sources enabled. The mask differs
> > + *	      between SH4 and RZ platforms.
> > + */
> > +struct ceu_data {
> > +	u32 irq_mask;
> > +};
> > +
> > +static const struct ceu_data ceu_data_rz = {
> > +	.irq_mask = CEU_CETCR_ALL_IRQS_RZ,
> > +};
> > +
> > +static const struct ceu_data ceu_data_sh4 = {
> > +	.irq_mask = CEU_CETCR_ALL_IRQS_SH4,
> > +};
> > +
> > +#if IS_ENABLED(CONFIG_OF)
> > +static const struct of_device_id ceu_of_match[] = {
> > +	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, ceu_of_match);
> > +#endif
> > +
> > +static int ceu_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	const struct ceu_data *ceu_data;
> > +	struct ceu_device *ceudev;
> > +	struct resource *res;
> > +	unsigned int irq;
> > +	int num_subdevs;
> > +	int ret;
> > +
> > +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
> > +	if (!ceudev)
> > +		return -ENOMEM;
> > +
> > +	platform_set_drvdata(pdev, ceudev);
> > +	ceudev->dev = dev;
> > +
> > +	INIT_LIST_HEAD(&ceudev->capture);
> > +	spin_lock_init(&ceudev->lock);
> > +	mutex_init(&ceudev->mlock);
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	ceudev->base = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(ceudev->base))
> > +		goto error_free_ceudev;
> > +
> > +	ret = platform_get_irq(pdev, 0);
> > +	if (ret < 0) {
> > +		dev_err(dev, "Failed to get irq: %d\n", ret);
> > +		goto error_free_ceudev;
> > +	}
> > +	irq = ret;
> > +
> > +	ret = devm_request_irq(dev, irq, ceu_irq,
> > +			       0, dev_name(dev), ceudev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Unable to request CEU interrupt.\n");
> > +		goto error_free_ceudev;
> > +	}
> > +
> > +	pm_runtime_enable(dev);
> > +
> > +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> > +	if (ret)
> > +		goto error_pm_disable;
> > +
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> > +		ceu_data = of_match_device(ceu_of_match, dev)->data;
> > +		num_subdevs = ceu_parse_dt(ceudev);
> > +	} else if (dev->platform_data) {
> > +		/* Assume SH4 if booting with platform data. */
> > +		ceu_data = &ceu_data_sh4;
> > +		num_subdevs = ceu_parse_platform_data(ceudev,
> > +						      dev->platform_data);
> > +	} else {
> > +		num_subdevs = -EINVAL;
> > +	}
> > +
> > +	if (num_subdevs < 0) {
> > +		ret = num_subdevs;
> > +		goto error_v4l2_unregister;
> > +	}
> > +	ceudev->irq_mask = ceu_data->irq_mask;
> > +
> > +	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
> > +	ceudev->notifier.subdevs	= ceudev->asds;
> > +	ceudev->notifier.num_subdevs	= num_subdevs;
> > +	ceudev->notifier.ops		= &ceu_notify_ops;
> > +	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
> > +					   &ceudev->notifier);
> > +	if (ret)
> > +		goto error_v4l2_unregister;
> > +
> > +	dev_info(dev, "Renesas Capture Engine Unit %s\n", dev_name(dev));
> > +
> > +	return 0;
> > +
> > +error_v4l2_unregister:
> > +	v4l2_device_unregister(&ceudev->v4l2_dev);
> > +error_pm_disable:
> > +	pm_runtime_disable(dev);
> > +error_free_ceudev:
> > +	kfree(ceudev);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ceu_remove(struct platform_device *pdev)
> > +{
> > +	struct ceu_device *ceudev = platform_get_drvdata(pdev);
> > +
> > +	pm_runtime_disable(ceudev->dev);
> > +
> > +	v4l2_async_notifier_unregister(&ceudev->notifier);
> > +
> > +	v4l2_device_unregister(&ceudev->v4l2_dev);
> > +
> > +	video_unregister_device(&ceudev->vdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct dev_pm_ops ceu_pm_ops = {
> > +	SET_RUNTIME_PM_OPS(ceu_runtime_suspend,
> > +			   ceu_runtime_resume,
> > +			   NULL)
> > +};
> > +
> > +static struct platform_driver ceu_driver = {
> > +	.driver		= {
> > +		.name	= DRIVER_NAME,
> > +		.pm	= &ceu_pm_ops,
> > +		.of_match_table = of_match_ptr(ceu_of_match),
> > +	},
> > +	.probe		= ceu_probe,
> > +	.remove		= ceu_remove,
> > +};
> > +
> > +module_platform_driver(ceu_driver);
> > +
> > +MODULE_DESCRIPTION("Renesas CEU camera driver");
> > +MODULE_AUTHOR("Jacopo Mondi <jacopo+renesas@jmondi.org>");
> > +MODULE_LICENSE("GPL v2");
> >
>
> Regards,
>
> 	Hans
