Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39978 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752392AbdJLGUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 02:20:02 -0400
Date: Thu, 12 Oct 2017 09:19:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Subject: Re: [PATCH v5 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20171012061957.tx7buq2y4v45zkif@valkosipuli.retiisi.org.uk>
References: <1507333141-28242-1-git-send-email-yong.zhi@intel.com>
 <1507333141-28242-4-git-send-email-yong.zhi@intel.com>
 <20171010074543.xmqavghypbnv25xr@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1AE28D72@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE28D72@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

One more comment below...

On Thu, Oct 12, 2017 at 01:02:54AM +0000, Zhi, Yong wrote:
...
> > > +/******* V4L2 sub-device asynchronous registration
> > callbacks***********/
> > > +
> > > +struct sensor_async_subdev {
> > > +	struct v4l2_async_subdev asd;
> > > +	struct csi2_bus_info csi2;
> > > +};
> > > +
> > > +static struct cio2_queue *cio2_find_queue_by_sensor_node(struct
> > cio2_queue *q,
> > > +						struct fwnode_handle
> > *fwnode)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < CIO2_QUEUES; i++) {
> > > +		if (q[i].sensor->fwnode == fwnode)
> > > +			return &q[i];
> > > +	}
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > > +/* The .bound() notifier callback when a match is found */
> > > +static int cio2_notifier_bound(struct v4l2_async_notifier *notifier,
> > > +			       struct v4l2_subdev *sd,
> > > +			       struct v4l2_async_subdev *asd)
> > > +{
> > > +	struct cio2_device *cio2 = container_of(notifier,
> > > +					struct cio2_device, notifier);
> > > +	struct sensor_async_subdev *s_asd = container_of(asd,
> > > +					struct sensor_async_subdev, asd);
> > > +	struct cio2_queue *q;
> > > +	unsigned int i;
> > > +
> > > +
> > > +	/* Find first free slot for the subdev */
> > > +	for (i = 0; i < CIO2_QUEUES; i++)
> > > +		if (!cio2->queue[i].sensor)
> > > +			break;

The queues are related to sub-devices with the same number in the name,
whereas the number of the CSI-2 receiver is q->csi2.port. The problem here
is that the CSI-2 receiver that the sensor appears to be connected is a
incrementing number from zero onwards, depending on the order in which the
devices are bound rather than the real number of the receiver.

The easiest way to address this would be to create 1:1 mapping between the
queues and CSI-2 receivers.

> > > +
> > > +	if (i >= CIO2_QUEUES) {
> > > +		dev_err(&cio2->pci_dev->dev, "too many subdevs\n");
> > > +		return -ENOSPC;
> > > +	}
> > > +	q = &cio2->queue[i];
> > > +
> > > +	q->csi2 = s_asd->csi2;
> > > +	q->sensor = sd;
> > > +	q->csi_rx_base = cio2->base + CIO2_REG_PIPE_BASE(q->csi2.port);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* The .unbind callback */
> > > +static void cio2_notifier_unbind(struct v4l2_async_notifier *notifier,
> > > +				 struct v4l2_subdev *sd,
> > > +				 struct v4l2_async_subdev *asd)
> > > +{
> > > +	struct cio2_device *cio2 = container_of(notifier,
> > > +						struct cio2_device, notifier);
> > > +	unsigned int i;
> > > +
> > > +	/* Note: sd may here point to unallocated memory. Do not access. */
> > 
> > That may be the case but the patchset that this driver depends on changes
> > it. :-) So you can remove the comment.
> > 
> 
> Ack, will remove.
> 
> > > +	for (i = 0; i < CIO2_QUEUES; i++) {
> > > +		if (cio2->queue[i].sensor == sd) {
> > > +			cio2->queue[i].sensor = NULL;
> > > +			return;
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +/* .complete() is called after all subdevices have been located */
> > > +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> > > +{
> > > +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> > > +						notifier);
> > > +	struct sensor_async_subdev *s_asd;
> > > +	struct cio2_queue *q;
> > > +	unsigned int i, pad;
> > > +	int ret;
> > > +
> > > +	for (i = 0; i < notifier->num_subdevs; i++) {
> > > +		s_asd = container_of(cio2->notifier.subdevs[i],
> > > +					struct sensor_async_subdev,
> > > +					asd);
> > > +
> > > +		q = cio2_find_queue_by_sensor_node(
> > > +						cio2->queue,
> > > +						s_asd-
> > >asd.match.fwnode.fwnode);
> > > +		if (!q) {
> > > +			dev_err(&cio2->pci_dev->dev,
> > > +					"failed to find cio2 queue %d\n", ret);
> > > +			return -ENXIO;
> > > +		}
> > > +
> > > +		for (pad = 0; pad < q->sensor->entity.num_pads; pad++)
> > > +			if (q->sensor->entity.pads[pad].flags &
> > > +						MEDIA_PAD_FL_SOURCE)
> > > +				break;
> > > +
> > > +		if (pad == q->sensor->entity.num_pads) {
> > > +			dev_err(&cio2->pci_dev->dev,
> > > +				"failed to find src pad for %s\n",
> > > +				q->sensor->name);
> > > +			return -ENXIO;
> > > +		}
> > > +
> > > +		ret = media_create_pad_link(
> > > +				&q->sensor->entity, pad,
> > > +				&q->subdev.entity, CIO2_PAD_SINK,
> > > +				0);
> > > +		if (ret) {
> > > +			dev_err(&cio2->pci_dev->dev,
> > > +					"failed to create link for %s\n",
> > > +					cio2->queue[i].sensor->name);
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
> > > +}
> > > +
> > > +static const struct v4l2_async_notifier_operations cio2_async_ops = {
> > > +	.bound = cio2_notifier_bound,
> > > +	.unbind = cio2_notifier_unbind,
> > > +	.complete = cio2_notifier_complete,
> > > +};
> > > +
> > > +static int cio2_fwnode_parse(struct device *dev,
> > > +			     struct v4l2_fwnode_endpoint *vep,
> > > +			     struct v4l2_async_subdev *asd)
> > > +{
> > > +	struct sensor_async_subdev *s_asd =
> > > +			container_of(asd, struct sensor_async_subdev, asd);
> > > +
> > > +	if (vep->bus_type != V4L2_MBUS_CSI2) {
> > > +		dev_err(dev, "endpoint bus type error\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	s_asd->csi2.port = vep->base.port;
> > > +	s_asd->csi2.lanes = vep->bus.mipi_csi2.num_data_lanes;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cio2_notifier_init(struct cio2_device *cio2)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > > +		&cio2->pci_dev->dev, &cio2->notifier,
> > > +		sizeof(struct sensor_async_subdev),
> > > +		cio2_fwnode_parse);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (!cio2->notifier.num_subdevs)
> > > +		return 0;	/* no endpoint */
> > 
> > You could make this an error as well: there device won't do anything in
> > that case anyway. -ENODEV, perhaps.
> > 
> 
> Ack.
> 
> > > +
> > > +	cio2->notifier.ops = &cio2_async_ops;
> > > +	ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
> > > +	if (ret) {
> > > +		dev_err(&cio2->pci_dev->dev,
> > > +			"failed to register async notifier : %d\n", ret);
> > > +		goto error;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +error:
> > > +	v4l2_async_notifier_cleanup(&cio2->notifier);
> > > +
> > > +	return ret;
> > > +}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
