Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46407 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeAUJxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 04:53:33 -0500
Date: Sun, 21 Jan 2018 10:53:23 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/9] v4l: platform: Add Renesas CEU driver
Message-ID: <20180121095323.GL24926@w540>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516139101-7835-4-git-send-email-jacopo+renesas@jmondi.org>
 <d056343b-46be-436a-e316-0a588a182eb9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d056343b-46be-436a-e316-0a588a182eb9@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 19, 2018 at 12:20:19PM +0100, Hans Verkuil wrote:
> Some more comments:
>

[snip]

> > +/* --- CEU Videobuf2 operations --- */
> > +
> > +static void ceu_update_plane_sizes(struct v4l2_plane_pix_format *plane,
> > +				   unsigned int bpl, unsigned int szimage)
> > +{
> > +	if (plane->bytesperline < bpl)
> > +		plane->bytesperline = bpl;
> > +	if (plane->sizeimage < szimage)
> > +		plane->sizeimage = szimage;
>
> As mentioned in your cover letter, you do need to check for invalid
> bytesperline values. The v4l2-compliance test is to see what happens
> when userspace gives insane values, so yes, drivers need to be able
> to handle that.
>
> plane->sizeimage is set by the driver, so drop the 'if' before the
> assignment.

According to what suggested by you and Laurent I'll limit the h size
to the maximum value supported by the HW (I didn't notice this limit was
specified in the HW manual, and it's set to 8188 bytes).

And I will set sizeimage unconditionally.

> >

[snip]

> > +
> > +static int ceu_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		return -EINVAL;
> > +
> > +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, g_parm, a);
>
> Look at this v4l2-compliance failure:
>
> fail: v4l2-test-formats.cpp(1162): ret && node->has_frmintervals
>
> This is caused by the fact that the ov7670 driver has this code:
>
> static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> {
>         struct v4l2_captureparm *cp = &parms->parm.capture;
>         struct ov7670_info *info = to_state(sd);
>
>         if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>                 return -EINVAL;
>
> And parms->type is CAPTURE_MPLANE. Just drop this test from the ov7670 driver
> in the g/s_parm functions. It shouldn't test for that since a subdev driver
> knows nothing about buffer types.
>

I will drop that test in an additional patch part of next iteration of this series,

> It might be a good idea to check if other subdevs to the same test.
>
> > +static const struct v4l2_ioctl_ops ceu_ioctl_ops = {
> > +	.vidioc_querycap		= ceu_querycap,
> > +
> > +	.vidioc_enum_fmt_vid_cap_mplane	= ceu_enum_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap_mplane	= ceu_try_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap_mplane	= ceu_s_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap_mplane	= ceu_g_fmt_vid_cap,
> > +
> > +	.vidioc_enum_input		= ceu_enum_input,
> > +	.vidioc_g_input			= ceu_g_input,
> > +	.vidioc_s_input			= ceu_s_input,
> > +
> > +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> > +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> > +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> > +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> > +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> > +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> > +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> > +	.vidioc_streamon		= vb2_ioctl_streamon,
> > +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> > +
> > +	.vidioc_g_parm			= ceu_g_parm,
> > +	.vidioc_s_parm			= ceu_s_parm,
> > +	.vidioc_enum_framesizes		= ceu_enum_framesizes,
> > +	.vidioc_enum_frameintervals	= ceu_enum_frameintervals,
>
> You're missing these ioctls:
>
>         .vidioc_log_status              = v4l2_ctrl_log_status,
>         .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>         .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>
> These missing _event ops are the reason for this compliance failure:
>
> fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
>

Seems like they al comes almost for free! I will add them.

Thanks
   j

> > +};
> > +
> > +/*
> > + * ceu_vdev_release() - release CEU video device memory when last reference
> > + *			to this driver is closed
> > + */
> > +static void ceu_vdev_release(struct video_device *vdev)
> > +{
> > +	struct ceu_device *ceudev = video_get_drvdata(vdev);
> > +
> > +	kfree(ceudev);
> > +}
> > +
> > +static int ceu_notify_bound(struct v4l2_async_notifier *notifier,
> > +			    struct v4l2_subdev *v4l2_sd,
> > +			    struct v4l2_async_subdev *asd)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> > +	struct ceu_subdev *ceu_sd = to_ceu_subdev(asd);
> > +
> > +	ceu_sd->v4l2_sd = v4l2_sd;
> > +	ceudev->num_sd++;
> > +
> > +	return 0;
> > +}
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
> > +	q->io_modes		= VB2_MMAP | VB2_DMABUF;
> > +	q->drv_priv		= ceudev;
> > +	q->ops			= &ceu_vb2_ops;
> > +	q->mem_ops		= &vb2_dma_contig_memops;
> > +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> > +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	q->min_buffers_needed	= 2;
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
