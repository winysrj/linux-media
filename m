Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58948 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757333AbdECUZw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 16:25:52 -0400
Date: Wed, 3 May 2017 23:25:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170503202550.GR7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <20170503085801.GM7456@valkosipuli.retiisi.org.uk>
 <5919000.XlyggKpzoZ@ttoivone-desk1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5919000.XlyggKpzoZ@ttoivone-desk1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tuukka,

On Wed, May 03, 2017 at 02:06:23PM +0300, Tuukka Toivonen wrote:
> Hi Sakari,
> 
> On Wednesday, May 03, 2017 11:58:01 Sakari Ailus wrote:
> > Hi Yong,
> > 
> > A few more minor comments below...
> > 
> > On Sat, Apr 29, 2017 at 06:34:36PM -0500, Yong Zhi wrote:
> > ...
> > > +/******* V4L2 sub-device asynchronous registration callbacks***********/
> > > +
> > > +static struct cio2_queue *cio2_find_queue_by_sensor_node(struct cio2_queue *q,
> > > +						struct fwnode_handle *fwnode)
> > > +{
> > > +	int i;
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
> > > +	struct device *dev;
> > > +	int i;
> > > +
> > > +	dev = &cio2->pci_dev->dev;
> > > +
> > > +	/* Find first free slot for the subdev */
> > > +	for (i = 0; i < CIO2_QUEUES; i++)
> > > +		if (!cio2->queue[i].sensor)
> > > +			break;
> > > +
> > > +	if (i >= CIO2_QUEUES) {
> > > +		dev_err(dev, "too many subdevs\n");
> > > +		return -ENOSPC;
> > > +	}
> > > +	q = &cio2->queue[i];
> > > +
> > > +	q->csi2.port = s_asd->vfwn_endpt.base.port;
> > > +	q->csi2.num_of_lanes = s_asd->vfwn_endpt.bus.mipi_csi2.num_data_lanes;
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
> > When can this happen?
> 
> If v4l2_device_register_subdev() fails, it may lead to
> calling subdevice's remove function and the devres system
> freeing the subdevice before unbind is called. This did
> happen during driver development.

Ouch. Indeed, we do have object lifetime issues. :-( They will obviously
need to be fixed.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
