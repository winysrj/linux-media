Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44350 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751943AbdECI6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 04:58:06 -0400
Date: Wed, 3 May 2017 11:58:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170503085801.GM7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

A few more minor comments below...

On Sat, Apr 29, 2017 at 06:34:36PM -0500, Yong Zhi wrote:
...
> +/******* V4L2 sub-device asynchronous registration callbacks***********/
> +
> +static struct cio2_queue *cio2_find_queue_by_sensor_node(struct cio2_queue *q,
> +						struct fwnode_handle *fwnode)
> +{
> +	int i;
> +
> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		if (q[i].sensor->fwnode == fwnode)
> +			return &q[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +/* The .bound() notifier callback when a match is found */
> +static int cio2_notifier_bound(struct v4l2_async_notifier *notifier,
> +			       struct v4l2_subdev *sd,
> +			       struct v4l2_async_subdev *asd)
> +{
> +	struct cio2_device *cio2 = container_of(notifier,
> +					struct cio2_device, notifier);
> +	struct sensor_async_subdev *s_asd = container_of(asd,
> +					struct sensor_async_subdev, asd);
> +	struct cio2_queue *q;
> +	struct device *dev;
> +	int i;
> +
> +	dev = &cio2->pci_dev->dev;
> +
> +	/* Find first free slot for the subdev */
> +	for (i = 0; i < CIO2_QUEUES; i++)
> +		if (!cio2->queue[i].sensor)
> +			break;
> +
> +	if (i >= CIO2_QUEUES) {
> +		dev_err(dev, "too many subdevs\n");
> +		return -ENOSPC;
> +	}
> +	q = &cio2->queue[i];
> +
> +	q->csi2.port = s_asd->vfwn_endpt.base.port;
> +	q->csi2.num_of_lanes = s_asd->vfwn_endpt.bus.mipi_csi2.num_data_lanes;
> +	q->sensor = sd;
> +	q->csi_rx_base = cio2->base + CIO2_REG_PIPE_BASE(q->csi2.port);
> +
> +	return 0;
> +}
> +
> +/* The .unbind callback */
> +static void cio2_notifier_unbind(struct v4l2_async_notifier *notifier,
> +				 struct v4l2_subdev *sd,
> +				 struct v4l2_async_subdev *asd)
> +{
> +	struct cio2_device *cio2 = container_of(notifier,
> +						struct cio2_device, notifier);
> +	unsigned int i;
> +
> +	/* Note: sd may here point to unallocated memory. Do not access. */

When can this happen?

> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		if (cio2->queue[i].sensor == sd) {
> +			cio2->queue[i].sensor = NULL;
> +			return;
> +		}
> +	}
> +}
> +
> +/* .complete() is called after all subdevices have been located */
> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> +						notifier);
> +	struct sensor_async_subdev *s_asd;
> +	struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
> +	struct cio2_queue *q;
> +	struct fwnode_endpoint remote_endpt;
> +	int i, ret;
> +
> +	for (i = 0; i < notifier->num_subdevs; i++) {
> +		s_asd = container_of(cio2->notifier.subdevs[i],
> +					struct sensor_async_subdev,
> +					asd);

Fits on previous line. It's a good practice to align the further function
arguments wrapped on the following lines to the character just right of the
opening parenthesis, e.g.

ret = foo(bar,
	  foobar);

> +
> +		fwn_remote = s_asd->asd.match.fwnode.fwn;
> +		fwn_endpt = (struct fwnode_handle *)
> +					s_asd->vfwn_endpt.base.local_fwnode;
> +		fwn_remote_endpt = fwnode_graph_get_remote_endpoint(fwn_endpt);
> +		if (!fwn_remote_endpt) {
> +			dev_err(&cio2->pci_dev->dev,
> +					"failed to get remote endpt %d\n", ret);
> +			return ret;
> +		}
> +
> +		ret = fwnode_graph_parse_endpoint(fwn_remote_endpt,
> +							&remote_endpt);
> +		if (ret) {
> +			dev_err(&cio2->pci_dev->dev,
> +				"failed to parse remote endpt %d\n", ret);
> +			return ret;
> +		}
> +
> +		q = cio2_find_queue_by_sensor_node(cio2->queue, fwn_remote);
> +		if (!q) {
> +			dev_err(&cio2->pci_dev->dev,
> +					"failed to find cio2 queue %d\n", ret);
> +			return ret;
> +		}
> +
> +		ret = media_create_pad_link(
> +				&q->sensor->entity, remote_endpt.id,
> +				&q->subdev.entity, s_asd->vfwn_endpt.base.id,
> +				0);
> +		if (ret) {
> +			dev_err(&cio2->pci_dev->dev,
> +					"failed to create link for %s\n",
> +					cio2->queue[i].sensor->name);
> +			return ret;
> +		}
> +	}
> +
> +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
> +}
> +
> +static int cio2_notifier_init(struct cio2_device *cio2)
> +{
> +	struct device *dev;
> +	struct fwnode_handle *dev_fwn, *fwn, *fwn_remote;
> +	struct v4l2_async_subdev *asd;
> +	struct sensor_async_subdev *s_asd;
> +	int ret, endpt_i;
> +
> +	dev = &cio2->pci_dev->dev;
> +	dev_fwn = dev_fwnode(dev);
> +
> +	asd = devm_kzalloc(dev, sizeof(asd) * CIO2_QUEUES, GFP_KERNEL);
> +	if (!asd)
> +		return -ENOMEM;
> +
> +	cio2->notifier.subdevs = (struct v4l2_async_subdev **)asd;
> +	cio2->notifier.num_subdevs = 0;

No need to initialise to zero --- it's already zero.

> +	cio2->notifier.bound = cio2_notifier_bound;
> +	cio2->notifier.unbind = cio2_notifier_unbind;
> +	cio2->notifier.complete = cio2_notifier_complete;
> +
> +	fwn = NULL;
> +	endpt_i = 0;

You could initialise these in variable declaration.

> +	while (endpt_i < CIO2_QUEUES &&
> +			(fwn = fwnode_graph_get_next_endpoint(dev_fwn, fwn))) {
> +		s_asd = devm_kzalloc(dev, sizeof(*s_asd), GFP_KERNEL);
> +		if (!asd)
> +			return -ENOMEM;
> +
> +		fwn_remote = fwnode_graph_get_remote_port_parent(fwn);
> +		if (!fwn_remote) {
> +			dev_err(dev, "bad remote port parent\n");
> +			return -ENOENT;
> +		}
> +
> +		ret = v4l2_fwnode_endpoint_parse(fwn, &s_asd->vfwn_endpt);
> +		if (ret) {
> +			dev_err(dev, "endpoint parsing error : %d\n", ret);
> +			return ret;
> +		}
> +
> +		if (s_asd->vfwn_endpt.bus_type != V4L2_MBUS_CSI2) {
> +			dev_warn(dev, "endpoint bus type error\n");
> +			devm_kfree(dev, s_asd);
> +			continue;
> +		}
> +
> +		s_asd->asd.match.fwnode.fwn = fwn_remote;
> +		s_asd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +
> +		cio2->notifier.subdevs[endpt_i++] = &s_asd->asd;
> +	}
> +
> +	if (!endpt_i)
> +		return 0;	/* No endpoint */
> +
> +	cio2->notifier.num_subdevs = endpt_i;

You only use endpt_i in a single location. How about dropping it and using
cio2->notifier.num_subdevs instead?

> +	ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
> +	if (ret) {
> +		cio2->notifier.num_subdevs = 0;
> +		dev_err(dev, "failed to register async notifier : %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void cio2_notifier_exit(struct cio2_device *cio2)
> +{
> +	if (cio2->notifier.num_subdevs > 0)
> +		v4l2_async_notifier_unregister(&cio2->notifier);
> +}
> +
> +/**************** Queue initialization ****************/
> +static const struct media_entity_operations cio2_media_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	static const u32 default_width = 1936;
> +	static const u32 default_height = 1096;
> +	static const u32 default_mbusfmt = MEDIA_BUS_FMT_SRGGB10_1X10;
> +
> +	struct video_device *vdev = &q->vdev;
> +	struct vb2_queue *vbq = &q->vbq;
> +	struct v4l2_subdev *subdev = &q->subdev;
> +	struct v4l2_mbus_framefmt *fmt;
> +	int r;
> +
> +	/* Initialize miscellaneous variables */
> +	mutex_init(&q->lock);
> +
> +	/* Initialize formats to default values */
> +	fmt = &q->subdev_fmt;
> +	fmt->width = default_width;
> +	fmt->height = default_height;
> +	fmt->code = default_mbusfmt;
> +	fmt->field = V4L2_FIELD_NONE;
> +	fmt->colorspace = V4L2_COLORSPACE_RAW;
> +	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +
> +	q->pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> +
> +	/* Initialize fbpt */
> +	r = cio2_fbpt_init(cio2, q);
> +	if (r)
> +		goto fail_fbpt;
> +
> +	/* Initialize media entities */
> +	r = media_entity_pads_init(&subdev->entity, CIO2_PADS, q->subdev_pads);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize subdev media entity (%d)\n", r);
> +		goto fail_subdev_media_entity;
> +	}
> +	q->subdev_pads[CIO2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
> +		MEDIA_PAD_FL_MUST_CONNECT;
> +	q->subdev_pads[CIO2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +	subdev->entity.ops = &cio2_media_ops;
> +	r = media_entity_pads_init(&vdev->entity, 1, &q->vdev_pad);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize videodev media entity (%d)\n", r);
> +		goto fail_vdev_media_entity;
> +	}
> +	q->vdev_pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	vdev->entity.ops = &cio2_media_ops;
> +
> +	/* Initialize subdev */
> +	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> +	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	subdev->owner = THIS_MODULE;
> +	snprintf(subdev->name, sizeof(subdev->name),
> +		 CIO2_ENTITY_NAME ":%li", q - cio2->queue);
> +	v4l2_set_subdevdata(subdev, cio2);
> +	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize subdev (%d)\n", r);
> +		goto fail_subdev;
> +	}
> +
> +	/* Initialize vbq */
> +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vbq->io_modes = VB2_USERPTR | VB2_MMAP;
> +	vbq->ops = &cio2_vb2_ops;
> +	vbq->mem_ops = &vb2_dma_sg_memops;
> +	vbq->buf_struct_size = sizeof(struct cio2_buffer);
> +	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vbq->min_buffers_needed = 1;
> +	vbq->drv_priv = cio2;
> +	vbq->lock = &q->lock;
> +	r = vb2_queue_init(vbq);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to initialize videobuf2 queue (%d)\n", r);
> +		goto fail_vbq;
> +	}
> +
> +	/* Initialize vdev */
> +	snprintf(vdev->name, sizeof(vdev->name),
> +		 "%s:%li", CIO2_NAME, q - cio2->queue);
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &cio2_v4l2_fops;
> +	vdev->ioctl_ops = &cio2_v4l2_ioctl_ops;
> +	vdev->lock = &cio2->lock;
> +	vdev->v4l2_dev = &cio2->v4l2_dev;
> +	vdev->queue = &q->vbq;
> +	video_set_drvdata(vdev, cio2);
> +	r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to register video device (%d)\n", r);
> +		goto fail_vdev;
> +	}
> +
> +	/* Create link from CIO2 subdev to output node */
> +	r = media_create_pad_link(
> +		&subdev->entity, CIO2_PAD_SOURCE, &vdev->entity, 0,
> +		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +	if (r)
> +		goto fail_link;
> +
> +	return 0;
> +
> +fail_link:
> +	video_unregister_device(&q->vdev);
> +fail_vdev:
> +	vb2_queue_release(vbq);
> +fail_vbq:
> +	v4l2_device_unregister_subdev(subdev);
> +fail_subdev:
> +	media_entity_cleanup(&vdev->entity);
> +fail_vdev_media_entity:
> +	media_entity_cleanup(&subdev->entity);
> +fail_subdev_media_entity:
> +	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
> +fail_fbpt:
> +	mutex_destroy(&q->lock);
> +
> +	return r;
> +}
> +
> +static void cio2_queue_exit(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	video_unregister_device(&q->vdev);
> +	vb2_queue_release(&q->vbq);
> +	v4l2_device_unregister_subdev(&q->subdev);
> +	media_entity_cleanup(&q->vdev.entity);
> +	media_entity_cleanup(&q->subdev.entity);
> +	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
> +	mutex_destroy(&q->lock);
> +}
> +
> +/**************** PCI interface ****************/
> +
> +static int cio2_pci_config_setup(struct pci_dev *dev)
> +{
> +	u16 pci_command;
> +	int r = pci_enable_msi(dev);

It's a good practice to obtain local references to data structures you need
in a function while you're declaring variables but I wouldn't enable MSI
here. Instead do:

int r;

r = pci_enable_msi();

> +
> +	if (r) {
> +		dev_err(&dev->dev, "failed to enable MSI (%d)\n", r);
> +		return r;
> +	}
> +
> +	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> +	pci_command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER |
> +		PCI_COMMAND_INTX_DISABLE;
> +	pci_write_config_word(dev, PCI_COMMAND, pci_command);
> +
> +	return 0;
> +}
> +
> +static int cio2_pci_probe(struct pci_dev *pci_dev,
> +			  const struct pci_device_id *id)
> +{
> +	struct cio2_device *cio2;
> +	phys_addr_t phys;
> +	void __iomem *const *iomap;
> +	int i = -1, r = -ENODEV;

No need to initialise r. It's soon assigned again.

> +
> +	cio2 = devm_kzalloc(&pci_dev->dev, sizeof(*cio2), GFP_KERNEL);
> +	if (!cio2)
> +		return -ENOMEM;
> +	cio2->pci_dev = pci_dev;
> +
> +	r = pcim_enable_device(pci_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to enable device (%d)\n", r);
> +		return r;
> +	}
> +
> +	dev_info(&pci_dev->dev, "device 0x%x (rev: 0x%x)\n",
> +		 pci_dev->device, pci_dev->revision);
> +
> +	phys = pci_resource_start(pci_dev, CIO2_PCI_BAR);
> +
> +	r = pcim_iomap_regions(pci_dev, 1 << CIO2_PCI_BAR, pci_name(pci_dev));
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to remap I/O memory (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	iomap = pcim_iomap_table(pci_dev);
> +	if (!iomap) {
> +		dev_err(&pci_dev->dev, "failed to iomap table\n");
> +		return -ENODEV;
> +	}
> +
> +	cio2->base = iomap[CIO2_PCI_BAR];
> +
> +	pci_set_drvdata(pci_dev, cio2);
> +
> +	pci_set_master(pci_dev);
> +
> +	r = pci_set_dma_mask(pci_dev, CIO2_DMA_MASK);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to set DMA mask (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	r = cio2_pci_config_setup(pci_dev);
> +	if (r)
> +		return -ENODEV;
> +
> +	mutex_init(&cio2->lock);
> +
> +	cio2->media_dev.dev = &cio2->pci_dev->dev;
> +	strlcpy(cio2->media_dev.model, CIO2_DEVICE_NAME,
> +		sizeof(cio2->media_dev.model));
> +	snprintf(cio2->media_dev.bus_info, sizeof(cio2->media_dev.bus_info),
> +		 "PCI:%s", pci_name(cio2->pci_dev));
> +	cio2->media_dev.driver_version = KERNEL_VERSION(4, 11, 0);
> +	cio2->media_dev.hw_revision = 0;
> +
> +	media_device_init(&cio2->media_dev);
> +	r = media_device_register(&cio2->media_dev);
> +	if (r < 0)
> +		goto fail_mutex_destroy;
> +
> +	cio2->v4l2_dev.mdev = &cio2->media_dev;
> +	r = v4l2_device_register(&pci_dev->dev, &cio2->v4l2_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev,
> +			"failed to register V4L2 device (%d)\n", r);
> +		goto fail_mutex_destroy;
> +	}
> +
> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		r = cio2_queue_init(cio2, &cio2->queue[i]);
> +		if (r)
> +			goto fail;
> +	}
> +
> +	r = cio2_fbpt_init_dummy(cio2);
> +	if (r)
> +		goto fail;
> +
> +	/* Register notifier for subdevices we care */
> +	r = cio2_notifier_init(cio2);
> +	if (r)
> +		goto fail;
> +
> +	r = devm_request_irq(&pci_dev->dev, pci_dev->irq, cio2_irq,
> +			     IRQF_SHARED, CIO2_NAME, cio2);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to request IRQ (%d)\n", r);
> +		goto fail;
> +	}
> +
> +	pm_runtime_put_noidle(&pci_dev->dev);
> +	pm_runtime_allow(&pci_dev->dev);
> +
> +	return 0;
> +
> +fail:
> +	cio2_notifier_exit(cio2);
> +	cio2_fbpt_exit_dummy(cio2);
> +	for (; i >= 0; i--)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +	v4l2_device_unregister(&cio2->v4l2_dev);
> +	media_device_unregister(&cio2->media_dev);
> +	media_device_cleanup(&cio2->media_dev);
> +fail_mutex_destroy:
> +	mutex_destroy(&cio2->lock);
> +
> +	return r;
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
