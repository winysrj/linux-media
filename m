Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53476 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750997AbdEHMKJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 08:10:09 -0400
Date: Mon, 8 May 2017 15:10:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170508121003.GJ7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <a33ac20c-5a72-3e6e-c55c-78bdb46449a5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33ac20c-5a72-3e6e-c55c-78bdb46449a5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 08, 2017 at 11:06:29AM +0200, Hans Verkuil wrote:
...
> > +static void cio2_queue_event_sof(struct cio2_device *cio2, struct cio2_queue *q)
> > +{
> > +	struct v4l2_event event = {
> > +		.type = V4L2_EVENT_FRAME_SYNC,
> > +		.u.frame_sync.frame_sequence =
> > +			atomic_inc_return(&q->frame_sequence) - 1,
> > +	};
> > +
> > +	v4l2_event_queue(q->subdev.devnode, &event);
> 
> Out of curiosity: why do you need this event? I recommend that you document the
> reasons for having this event somewhere.

For the user space camera control algorithms it is essential to know when
the reception of a frame has begun. That's often the best timing information
you get from the hardware, and not specific to this device --- the omap3isp
driver does the same.

...

> > +static const struct v4l2_file_operations cio2_v4l2_fops = {
> > +	.owner = THIS_MODULE,
> > +	.unlocked_ioctl = video_ioctl2,
> > +	.open = v4l2_fh_open,
> > +	.release = vb2_fop_release,
> > +	.poll = vb2_fop_poll,
> > +	.mmap = vb2_fop_mmap,
> 
> I suggest adding .read = vb2_fop_read as well. It's for free, and I never see any
> reason not to do this (although opinions differ on that :-) ).

I wonder if any real applications use it. A number of drivers have never
supported it either and frankly I'd be happy to rather see it disappear.
Complexity is one of the biggest problems also in videobuf2.

The support can be added later on but it cannot be reasonably removed going
forward.

> 
> > +};
> > +
> > +static const struct v4l2_ioctl_ops cio2_v4l2_ioctl_ops = {
> > +	.vidioc_querycap = cio2_v4l2_querycap,
> > +	.vidioc_enum_fmt_vid_cap = cio2_v4l2_enum_fmt,
> > +	.vidioc_g_fmt_vid_cap = cio2_v4l2_g_fmt,
> > +	.vidioc_s_fmt_vid_cap = cio2_v4l2_s_fmt,
> > +	.vidioc_try_fmt_vid_cap = cio2_v4l2_try_fmt,
> > +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> > +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> > +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> > +	.vidioc_querybuf = vb2_ioctl_querybuf,
> > +	.vidioc_qbuf = vb2_ioctl_qbuf,
> > +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> > +	.vidioc_streamon = vb2_ioctl_streamon,
> > +	.vidioc_streamoff = vb2_ioctl_streamoff,
> > +	.vidioc_expbuf = vb2_ioctl_expbuf,
> > +};
> > +
> > +static int cio2_subdev_subscribe_event(struct v4l2_subdev *sd,
> > +				       struct v4l2_fh *fh,
> > +				       struct v4l2_event_subscription *sub)
> > +{
> > +	if (sub->type != V4L2_EVENT_FRAME_SYNC)
> > +		return -EINVAL;
> 
> You must also support V4L2_EVENT_CTRL.
> 
> > +
> > +	/* Line number. For now only zero accepted. */
> > +	if (sub->id != 0)
> > +		return -EINVAL;
> > +
> > +	return v4l2_event_subscribe(fh, sub, 0, NULL);
> 
> You support room in the event queue for only one V4L2_EVENT_FRAME_SYNC event. Is
> that what you want? If userspace can't keep up you will lose older frame_sync events.
> 
> It's probably OK for this event, but I want to make sure you thought about this :-)

I think I'd like to have as many events as there can be buffers. I have to
say I don't write much user space software, but I presume it'll be extra
work to prepare for one more not-seen-often special case.

...

> > +/* .complete() is called after all subdevices have been located */
> > +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> > +						notifier);
> > +	struct sensor_async_subdev *s_asd;
> > +	struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
> > +	struct cio2_queue *q;
> > +	struct fwnode_endpoint remote_endpt;
> > +	int i, ret;
> > +
> > +	for (i = 0; i < notifier->num_subdevs; i++) {
> > +		s_asd = container_of(cio2->notifier.subdevs[i],
> > +					struct sensor_async_subdev,
> > +					asd);
> > +
> > +		fwn_remote = s_asd->asd.match.fwnode.fwn;
> > +		fwn_endpt = (struct fwnode_handle *)
> > +					s_asd->vfwn_endpt.base.local_fwnode;
> > +		fwn_remote_endpt = fwnode_graph_get_remote_endpoint(fwn_endpt);
> > +		if (!fwn_remote_endpt) {
> > +			dev_err(&cio2->pci_dev->dev,
> > +					"failed to get remote endpt %d\n", ret);
> > +			return ret;
> > +		}
> > +
> > +		ret = fwnode_graph_parse_endpoint(fwn_remote_endpt,
> > +							&remote_endpt);
> > +		if (ret) {
> > +			dev_err(&cio2->pci_dev->dev,
> > +				"failed to parse remote endpt %d\n", ret);
> > +			return ret;
> > +		}
> > +
> > +		q = cio2_find_queue_by_sensor_node(cio2->queue, fwn_remote);
> > +		if (!q) {
> > +			dev_err(&cio2->pci_dev->dev,
> > +					"failed to find cio2 queue %d\n", ret);
> > +			return ret;
> > +		}
> > +
> > +		ret = media_create_pad_link(
> > +				&q->sensor->entity, remote_endpt.id,
> > +				&q->subdev.entity, s_asd->vfwn_endpt.base.id,
> > +				0);
> > +		if (ret) {
> > +			dev_err(&cio2->pci_dev->dev,
> > +					"failed to create link for %s\n",
> > +					cio2->queue[i].sensor->name);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
> > +}
> 
> The current code only supports sensor subdevs, right? Not non-sensor subdevs such as
> for focus etc. control (e.g. voice coil).

The CIO2 driver only supports sensors (I presume you could attach e.g. a TV
tuner, too) but then again I don't think it's its job to support voice coils
either: they're related to the sensors instead and the CIO2 driver wouldn't
have enough information on them to associate them to a particular sensor.

There are DT binding patches for such devices + async sub-device notifier
patches floating around to support these.


...

> > +/**************** Queue initialization ****************/
> > +static const struct media_entity_operations cio2_media_ops = {
> > +	.link_validate = v4l2_subdev_link_validate,
> > +};
> > +
> > +int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
> > +{
> > +	static const u32 default_width = 1936;
> > +	static const u32 default_height = 1096;
> > +	static const u32 default_mbusfmt = MEDIA_BUS_FMT_SRGGB10_1X10;
> > +
> > +	struct video_device *vdev = &q->vdev;
> > +	struct vb2_queue *vbq = &q->vbq;
> > +	struct v4l2_subdev *subdev = &q->subdev;
> > +	struct v4l2_mbus_framefmt *fmt;
> > +	int r;
> > +
> > +	/* Initialize miscellaneous variables */
> > +	mutex_init(&q->lock);
> > +
> > +	/* Initialize formats to default values */
> > +	fmt = &q->subdev_fmt;
> > +	fmt->width = default_width;
> > +	fmt->height = default_height;
> > +	fmt->code = default_mbusfmt;
> > +	fmt->field = V4L2_FIELD_NONE;
> 
> > +	fmt->colorspace = V4L2_COLORSPACE_RAW;
> > +	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> > +	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
> > +	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> 
> Same question as before: shouldn't this all come from the sensor subdev?

This is done at device initialisation time. I guess the above four lines
could be simply dropped.

> 
> > +
> > +	q->pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> > +
> > +	/* Initialize fbpt */
> > +	r = cio2_fbpt_init(cio2, q);
> > +	if (r)
> > +		goto fail_fbpt;
> > +
> > +	/* Initialize media entities */
> > +	r = media_entity_pads_init(&subdev->entity, CIO2_PADS, q->subdev_pads);
> > +	if (r) {
> > +		dev_err(&cio2->pci_dev->dev,
> > +			"failed initialize subdev media entity (%d)\n", r);
> > +		goto fail_subdev_media_entity;
> > +	}
> > +	q->subdev_pads[CIO2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
> > +		MEDIA_PAD_FL_MUST_CONNECT;
> > +	q->subdev_pads[CIO2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> > +	subdev->entity.ops = &cio2_media_ops;
> > +	r = media_entity_pads_init(&vdev->entity, 1, &q->vdev_pad);
> > +	if (r) {
> > +		dev_err(&cio2->pci_dev->dev,
> > +			"failed initialize videodev media entity (%d)\n", r);
> > +		goto fail_vdev_media_entity;
> > +	}
> > +	q->vdev_pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> > +	vdev->entity.ops = &cio2_media_ops;
> > +
> > +	/* Initialize subdev */
> > +	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> > +	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> > +	subdev->owner = THIS_MODULE;
> > +	snprintf(subdev->name, sizeof(subdev->name),
> > +		 CIO2_ENTITY_NAME ":%li", q - cio2->queue);
> > +	v4l2_set_subdevdata(subdev, cio2);
> > +	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
> > +	if (r) {
> > +		dev_err(&cio2->pci_dev->dev,
> > +			"failed initialize subdev (%d)\n", r);
> > +		goto fail_subdev;
> > +	}
> > +
> > +	/* Initialize vbq */
> > +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	vbq->io_modes = VB2_USERPTR | VB2_MMAP;
> 
> No DMABUF?!

I don't think it should require really code from the driver but I wonder if
something could go wrong if you don't test it.

> 
> > +	vbq->ops = &cio2_vb2_ops;
> > +	vbq->mem_ops = &vb2_dma_sg_memops;
> > +	vbq->buf_struct_size = sizeof(struct cio2_buffer);
> > +	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	vbq->min_buffers_needed = 1;
> > +	vbq->drv_priv = cio2;
> > +	vbq->lock = &q->lock;
> > +	r = vb2_queue_init(vbq);
> > +	if (r) {
> > +		dev_err(&cio2->pci_dev->dev,
> > +			"failed to initialize videobuf2 queue (%d)\n", r);
> > +		goto fail_vbq;
> > +	}
> > +

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
