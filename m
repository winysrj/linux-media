Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54214 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752990AbdEHM4y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 08:56:54 -0400
Date: Mon, 8 May 2017 15:56:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170508125620.GK7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <a33ac20c-5a72-3e6e-c55c-78bdb46449a5@xs4all.nl>
 <20170508121003.GJ7456@valkosipuli.retiisi.org.uk>
 <8dbaa458-6476-ac3b-daf3-785b0f591a69@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dbaa458-6476-ac3b-daf3-785b0f591a69@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 08, 2017 at 02:32:22PM +0200, Hans Verkuil wrote:
> On 05/08/2017 02:10 PM, Sakari Ailus wrote:

...

> >>> +/* .complete() is called after all subdevices have been located */
> >>> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> >>> +{
> >>> +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> >>> +						notifier);
> >>> +	struct sensor_async_subdev *s_asd;
> >>> +	struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
> >>> +	struct cio2_queue *q;
> >>> +	struct fwnode_endpoint remote_endpt;
> >>> +	int i, ret;
> >>> +
> >>> +	for (i = 0; i < notifier->num_subdevs; i++) {
> >>> +		s_asd = container_of(cio2->notifier.subdevs[i],
> >>> +					struct sensor_async_subdev,
> >>> +					asd);
> >>> +
> >>> +		fwn_remote = s_asd->asd.match.fwnode.fwn;
> >>> +		fwn_endpt = (struct fwnode_handle *)
> >>> +					s_asd->vfwn_endpt.base.local_fwnode;
> >>> +		fwn_remote_endpt = fwnode_graph_get_remote_endpoint(fwn_endpt);
> >>> +		if (!fwn_remote_endpt) {
> >>> +			dev_err(&cio2->pci_dev->dev,
> >>> +					"failed to get remote endpt %d\n", ret);
> >>> +			return ret;
> >>> +		}
> >>> +
> >>> +		ret = fwnode_graph_parse_endpoint(fwn_remote_endpt,
> >>> +							&remote_endpt);
> >>> +		if (ret) {
> >>> +			dev_err(&cio2->pci_dev->dev,
> >>> +				"failed to parse remote endpt %d\n", ret);
> >>> +			return ret;
> >>> +		}
> >>> +
> >>> +		q = cio2_find_queue_by_sensor_node(cio2->queue, fwn_remote);
> >>> +		if (!q) {
> >>> +			dev_err(&cio2->pci_dev->dev,
> >>> +					"failed to find cio2 queue %d\n", ret);
> >>> +			return ret;
> >>> +		}
> >>> +
> >>> +		ret = media_create_pad_link(
> >>> +				&q->sensor->entity, remote_endpt.id,
> >>> +				&q->subdev.entity, s_asd->vfwn_endpt.base.id,
> >>> +				0);
> >>> +		if (ret) {
> >>> +			dev_err(&cio2->pci_dev->dev,
> >>> +					"failed to create link for %s\n",
> >>> +					cio2->queue[i].sensor->name);
> >>> +			return ret;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
> >>> +}
> >>
> >> The current code only supports sensor subdevs, right? Not non-sensor subdevs such as
> >> for focus etc. control (e.g. voice coil).
> > 
> > The CIO2 driver only supports sensors (I presume you could attach e.g. a TV
> > tuner, too) but then again I don't think it's its job to support voice coils
> > either: they're related to the sensors instead and the CIO2 driver wouldn't
> > have enough information on them to associate them to a particular sensor.
> > 
> > There are DT binding patches for such devices + async sub-device notifier
> > patches floating around to support these.
> 
> Can you give me a pointer to those?

Certainly. Lens etc. DT bindings:

<URL:http://www.spinics.net/lists/linux-media/msg115272.html>

And async sub-device notifier support:

<URL:http://www.spinics.net/lists/linux-media/msg114915.html>

...

> >>> +
> >>> +	q->pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> >>> +
> >>> +	/* Initialize fbpt */
> >>> +	r = cio2_fbpt_init(cio2, q);
> >>> +	if (r)
> >>> +		goto fail_fbpt;
> >>> +
> >>> +	/* Initialize media entities */
> >>> +	r = media_entity_pads_init(&subdev->entity, CIO2_PADS, q->subdev_pads);
> >>> +	if (r) {
> >>> +		dev_err(&cio2->pci_dev->dev,
> >>> +			"failed initialize subdev media entity (%d)\n", r);
> >>> +		goto fail_subdev_media_entity;
> >>> +	}
> >>> +	q->subdev_pads[CIO2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
> >>> +		MEDIA_PAD_FL_MUST_CONNECT;
> >>> +	q->subdev_pads[CIO2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> >>> +	subdev->entity.ops = &cio2_media_ops;
> >>> +	r = media_entity_pads_init(&vdev->entity, 1, &q->vdev_pad);
> >>> +	if (r) {
> >>> +		dev_err(&cio2->pci_dev->dev,
> >>> +			"failed initialize videodev media entity (%d)\n", r);
> >>> +		goto fail_vdev_media_entity;
> >>> +	}
> >>> +	q->vdev_pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> >>> +	vdev->entity.ops = &cio2_media_ops;
> >>> +
> >>> +	/* Initialize subdev */
> >>> +	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> >>> +	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> >>> +	subdev->owner = THIS_MODULE;
> >>> +	snprintf(subdev->name, sizeof(subdev->name),
> >>> +		 CIO2_ENTITY_NAME ":%li", q - cio2->queue);
> >>> +	v4l2_set_subdevdata(subdev, cio2);
> >>> +	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
> >>> +	if (r) {
> >>> +		dev_err(&cio2->pci_dev->dev,
> >>> +			"failed initialize subdev (%d)\n", r);
> >>> +		goto fail_subdev;
> >>> +	}
> >>> +
> >>> +	/* Initialize vbq */
> >>> +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >>> +	vbq->io_modes = VB2_USERPTR | VB2_MMAP;
> >>
> >> No DMABUF?!
> > 
> > I don't think it should require really code from the driver but I wonder if
> > something could go wrong if you don't test it.
> 
> Not to my knowledge. All new drivers should really support VB2_DMABUF. In fact, this
> driver supports vidioc_expbuf, which makes no sense unless VB2_DMABUF is set.

Ack.

> 
> The USERPTR mode is more dubious. Has this been tested? Can the DMA handle partially
> filled pages? (I.e. there must be no requirements such as that the DMA has to start
> at a page boundary, since that's not the case with USERPTR).

I rememeber this has been discussed before. :-)

Most hardware has some limitations on the granularity of the buffer start
address, and the drivers still support USERPTR memory. In practice the C
library allocated memory is always page aligned if the size is large enough,
which is in practice the case for video buffers. There's no guarantee of
this though. Unless I'm mistaken, the start address granularity for this
hardware is 64 bytes.

It's always possible to allocate memory using:

	memalign(sysconf(_SC_PAGESIZE), size)

Some cache architectures have real trouble of properly supporting USERPTR
such as VIVT AFAIR.

I guess the bottom line is that USERPTR is always dubious. :-) One should
rather user MMAP instead, and then map the buffer to user space. Application
developers still often appear to resort to the user of USERPTR because it's
convenient.

> 
> > 
> >>
> >>> +	vbq->ops = &cio2_vb2_ops;
> >>> +	vbq->mem_ops = &vb2_dma_sg_memops;
> >>> +	vbq->buf_struct_size = sizeof(struct cio2_buffer);
> >>> +	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> >>> +	vbq->min_buffers_needed = 1;
> >>> +	vbq->drv_priv = cio2;
> >>> +	vbq->lock = &q->lock;
> >>> +	r = vb2_queue_init(vbq);
> >>> +	if (r) {
> >>> +		dev_err(&cio2->pci_dev->dev,
> >>> +			"failed to initialize videobuf2 queue (%d)\n", r);
> >>> +		goto fail_vbq;
> >>> +	}
> >>> +
> > 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
