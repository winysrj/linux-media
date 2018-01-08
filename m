Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33264 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753223AbeAHRYv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:24:51 -0500
Received: by mail-lf0-f67.google.com with SMTP id j143so12916650lfg.0
        for <linux-media@vger.kernel.org>; Mon, 08 Jan 2018 09:24:50 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 8 Jan 2018 18:24:47 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 21/28] rcar-vin: add group allocator functions
Message-ID: <20180108172447.GD23075@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-22-niklas.soderlund+renesas@ragnatech.se>
 <2338267.IAVXeh1rRr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2338267.IAVXeh1rRr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2017-12-08 22:12:56 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:35 EET Niklas Söderlund wrote:
> > In media controller mode all VIN instances needs to be part of the same
> > media graph. There is also a need to each VIN instance to know and in
> > some cases be able to communicate with other VIN instances.
> > 
> > Add an allocator framework where the first VIN instance to be probed
> > creates a shared data structure and creates a media device.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 179 ++++++++++++++++++++++++-
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  38 ++++++
> >  2 files changed, 215 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> > b/drivers/media/platform/rcar-vin/rcar-core.c index
> > 45de4079fd835759..a6713fd61dd87a88 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -20,12 +20,170 @@
> >  #include <linux/of_graph.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/slab.h>
> > 
> >  #include <media/v4l2-async.h>
> >  #include <media/v4l2-fwnode.h>
> > 
> >  #include "rcar-vin.h"
> > 
> > +/* ------------------------------------------------------------------------
> >  + * Gen3 CSI2 Group Allocator
> > + */
> > +
> > +static int rvin_group_read_id(struct rvin_dev *vin, struct device_node *np)
> > +{
> > +	u32 val;
> > +	int ret;
> > +
> > +	ret = of_property_read_u32(np, "renesas,id", &val);
> > +	if (ret) {
> > +		vin_err(vin, "%pOF: No renesas,id property found\n", np);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (val >= RCAR_VIN_NUM) {
> > +		vin_err(vin, "%pOF: Invalid renesas,id '%u'\n", np, val);
> > +		return -EINVAL;
> > +	}
> 
> I'd move all this to the main DT parsing function.

Will do.

> 
> > +	return val;
> > +}
> > +
> > +static DEFINE_MUTEX(rvin_group_lock);
> > +static struct rvin_group *rvin_group_data;
> 
> Nitpicking, static variables are often defined at the beginning of the C file, 
> before any function. I'll let you decide whether you want to move them.

Will move.

> 
> > +static void rvin_group_release(struct kref *kref)
> > +{
> > +	struct rvin_group *group =
> > +		container_of(kref, struct rvin_group, refcount);
> > +
> > +	mutex_lock(&rvin_group_lock);
> > +
> > +	media_device_unregister(&group->mdev);
> > +	media_device_cleanup(&group->mdev);
> > +
> > +	rvin_group_data = NULL;
> > +
> > +	mutex_unlock(&rvin_group_lock);
> > +
> > +	kfree(group);
> > +}
> > +
> > +static struct rvin_group *__rvin_group_allocate(struct rvin_dev *vin)
> > +{
> > +	struct rvin_group *group;
> > +
> > +	if (rvin_group_data) {
> > +		group = rvin_group_data;
> > +		kref_get(&group->refcount);
> > +		vin_dbg(vin, "%s: get group=%p\n", __func__, group);
> > +		return group;
> > +	}
> > +
> > +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> > +	if (!group)
> > +		return NULL;
> > +
> > +	kref_init(&group->refcount);
> > +	rvin_group_data = group;
> 
> Ouch. While I agree with the global mutex, a single global group variable 
> reminds me of the days when per-device data was happily stored in global 
> variables because, you know, we will never have more than one instance of that 
> device, right ? (Or, sometimes, because the driver author didn't know what an 
> instance was.)
> 
> Ideally we'd want a linked list of groups, and this function would either 
> retrieve the group that the VIN instance is part of, or allocate a new one.

I agree that removing the global group variable would be for the better, 
and I was hoping to be able to use the device allocator API for this 
once it's ready. However for now on all supported hardware (I know of) 
there would only be one group for the whole system.

- On H3 and M3-W CSI20 is connected to all VINs.
- On V3M there is only one CSI40 and it is connected to all VINs.

Is this satisfactory for you or do you believe it would be better to 
complete the device allocator first. Or implement parts of the ideas 
from that API locally to this driver? If I understand things correctly 
there are still obstacles blocking that API which are not trivial. And 
even if they are cleared it have no DT support AFIK so functionality to 
iterate over all nodes in a graph would be needed which in itself is no 
trivial task.

> 
> > +	vin_dbg(vin, "%s: alloc group=%p\n", __func__, group);
> 
> Do you still need those two debug statements (and all of the other ones below) 
> ?

Wops, no they can be dropped.

> 
> > +	return group;
> > +}
> > +
> > +static int rvin_group_add_vin(struct rvin_dev *vin)
> > +{
> > +	int ret;
> > +
> > +	ret = rvin_group_read_id(vin, vin->dev->of_node);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mutex_lock(&vin->group->lock);
> > +
> > +	if (vin->group->vin[ret]) {
> > +		mutex_unlock(&vin->group->lock);
> > +		vin_err(vin, "VIN number %d already occupied\n", ret);
> > +		return -EINVAL;
> 
> Can this happen ?

Sure, the values are read from DT so if the renesas,id property have the 
same value for more then one node. This is a incorrect DT of course but 
better to handle and warn for such a case I think?

> 
> > +	}
> > +
> > +	vin->group->vin[ret] = vin;
> > +
> > +	mutex_unlock(&vin->group->lock);
> > +
> > +	vin_dbg(vin, "I'm VIN number %d", ret);
> > +
> > +	return 0;
> > +}
> > +
> > +static int rvin_group_allocate(struct rvin_dev *vin)
> > +{
> > +	struct rvin_group *group;
> > +	struct media_device *mdev;
> > +	int ret;
> > +
> > +	mutex_lock(&rvin_group_lock);
> > +
> > +	group = __rvin_group_allocate(vin);
> > +	if (!group) {
> > +		mutex_unlock(&rvin_group_lock);
> 
> I'd use a goto unlock instead of spreading mutex_unlock() calls through the 
> function. It's easier to locate a misplaced return in a function that should 
> only use gotos than a missing mutex_unlock().

Will fix.

> 
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Init group data if it is not already initialized */
> > +	mdev = &group->mdev;
> > +	if (!mdev->dev) {
> > +		mutex_init(&group->lock);
> > +		mdev->dev = vin->dev;
> > +
> > +		strlcpy(mdev->driver_name, "Renesas VIN",
> > +			sizeof(mdev->driver_name));
> 
> How about using the module name ?

Sure.

> 
> > +		strlcpy(mdev->model, vin->dev->of_node->name,
> > +			sizeof(mdev->model));
> 
> I wonder whether you shouldn't somehow use the compatible string to create the 
> model name, in order to accurately report the device model.

I will try and use the compatible string here.

> 
> > +		snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
> > +			 dev_name(mdev->dev));
> > +		media_device_init(mdev);
> > +
> > +		ret = media_device_register(mdev);
> > +		if (ret) {
> > +			vin_err(vin, "Failed to register media device\n");
> > +			kref_put(&group->refcount, rvin_group_release);
> 
> This will deadlock if you're releasing the last reference. There's an 
> identical issue below.

Wops, thanks for pointing this out.

> 
> > +			mutex_unlock(&rvin_group_lock);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	vin->group = group;
> > +	vin->v4l2_dev.mdev = mdev;
> > +
> > +	ret = rvin_group_add_vin(vin);
> 
> I'd inline the function here.
> 
> > +	if (ret) {
> > +		kref_put(&group->refcount, rvin_group_release);
> > +		mutex_unlock(&rvin_group_lock);
> > +		return ret;
> > +	}
> > +
> > +	mutex_unlock(&rvin_group_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static void rvin_group_delete(struct rvin_dev *vin)
> 
> This function doesn't completely delete the group, it only drops one 
> reference. How about rvin_group_put() ? rvin_group_allocate() could then be 
> called rvin_group_get().

Good point.

> 
> > +{
> > +	unsigned int i;
> > +
> > +	mutex_lock(&vin->group->lock);
> > +	for (i = 0; i < RCAR_VIN_NUM; i++)
> > +		if (vin->group->vin[i] == vin)
> > +			vin->group->vin[i] = NULL;
> > +	mutex_unlock(&vin->group->lock);
> > +
> > +	vin_dbg(vin, "%s: group=%p\n", __func__, &vin->group);
> > +	kref_put(&vin->group->refcount, rvin_group_release);
> > +}
> > +
> >  /* ------------------------------------------------------------------------
> >   * Async notifier
> >   */
> > @@ -236,12 +394,27 @@ static int rvin_digital_graph_init(struct rvin_dev
> > *vin)
> > 
> >  static int rvin_group_init(struct rvin_dev *vin)
> >  {
> > +	int ret;
> > +
> > +	ret = rvin_group_allocate(vin);
> > +	if (ret)
> > +		return ret;
> > +
> >  	/* All our sources are CSI-2 */
> >  	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> >  	vin->mbus_cfg.flags = 0;
> > 
> >  	vin->pad.flags = MEDIA_PAD_FL_SINK;
> > -	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > +	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > +	if (ret)
> > +		goto error_group;
> > +
> > +	return 0;
> > +
> > +error_group:
> > +	rvin_group_delete(vin);
> > +
> > +	return ret;
> >  }
> > 
> >  /* ------------------------------------------------------------------------
> > @@ -361,7 +534,9 @@ static int rcar_vin_remove(struct platform_device
> > *pdev) v4l2_async_notifier_unregister(&vin->notifier);
> >  	v4l2_async_notifier_cleanup(&vin->notifier);
> > 
> > -	if (!vin->info->use_mc)
> > +	if (vin->info->use_mc)
> > +		rvin_group_delete(vin);
> > +	else
> >  		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > 
> >  	rvin_dma_unregister(vin);
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > 07d270a976893cdb..5f736a3500b6e10f 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -17,6 +17,8 @@
> >  #ifndef __RCAR_VIN__
> >  #define __RCAR_VIN__
> > 
> > +#include <linux/kref.h>
> > +
> >  #include <media/v4l2-async.h>
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-dev.h>
> > @@ -30,6 +32,9 @@
> >  /* Address alignment mask for HW buffers */
> >  #define HW_BUFFER_MASK 0x7f
> > 
> > +/* Max number on VIN instances that can be in a system */
> > +#define RCAR_VIN_NUM 8
> > +
> >  enum chip_id {
> >  	RCAR_H1,
> >  	RCAR_M1,
> > @@ -37,6 +42,15 @@ enum chip_id {
> >  	RCAR_GEN3,
> >  };
> > 
> > +enum rvin_csi_id {
> > +	RVIN_CSI20,
> > +	RVIN_CSI21,
> > +	RVIN_CSI40,
> > +	RVIN_CSI41,
> > +	RVIN_CSI_MAX,
> > +	RVIN_NC, /* Not Connected */
> > +};
> > +
> >  /**
> >   * STOPPED  - No operation in progress
> >   * RUNNING  - Operation in progress have buffers
> > @@ -75,6 +89,8 @@ struct rvin_graph_entity {
> >  	unsigned int sink_pad;
> >  };
> > 
> > +struct rvin_group;
> 
> Forward declarations are usually grouped at the beginning of the header.

Will fix.

> 
> >  /**
> >   * struct rvin_info - Information about the particular VIN implementation
> >   * @chip:		type of VIN chip
> > @@ -103,6 +119,7 @@ struct rvin_info {
> >   * @notifier:		V4L2 asynchronous subdevs notifier
> >   * @digital:		entity in the DT for local digital subdevice
> >   *
> > + * @group:		Gen3 CSI group
> >   * @pad:		pad for media controller
> >   *
> >   * @lock:		protects @queue
> > @@ -134,6 +151,7 @@ struct rvin_dev {
> >  	struct v4l2_async_notifier notifier;
> >  	struct rvin_graph_entity *digital;
> > 
> > +	struct rvin_group *group;
> >  	struct media_pad pad;
> > 
> >  	struct mutex lock;
> > @@ -162,6 +180,26 @@ struct rvin_dev {
> >  #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
> >  #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
> > 
> > +/**
> > + * struct rvin_group - VIN CSI2 group information
> > + * @refcount:		number of VIN instances using the group
> > + *
> > + * @mdev:		media device which represents the group
> > + *
> > + * @lock:		protects the vin and csi members
> > + * @vin:		VIN instances which are part of the group
> > + * @csi:		CSI-2 entities that are part of the group
> > + */
> > +struct rvin_group {
> > +	struct kref refcount;
> > +
> > +	struct media_device mdev;
> > +
> > +	struct mutex lock;
> > +	struct rvin_dev *vin[RCAR_VIN_NUM];
> > +	struct rvin_graph_entity csi[RVIN_CSI_MAX];
> 
> Given that the number and types of CSI receivers varies quite a bit between 
> SoCs I wonder whether this couldn't be a linked list. If csi was an array of 
> pointers it would be less of an issue, but an array of rvin_graph_entity can 
> grow large.

I will see what makes most sens, a linked list or making it a array of 
pointers.

> 
> > +};
> > +
> >  int rvin_dma_register(struct rvin_dev *vin, int irq);
> >  void rvin_dma_unregister(struct rvin_dev *vin);
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
