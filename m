Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33975 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934001AbdEWHqw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 03:46:52 -0400
Received: by mail-lf0-f43.google.com with SMTP id 99so43359013lfu.1
        for <linux-media@vger.kernel.org>; Tue, 23 May 2017 00:46:51 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 23 May 2017 09:46:49 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v4 21/27] rcar-vin: add group allocator functions
Message-ID: <20170523074649.GE24633@bigcity.dyn.berto.se>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-22-niklas.soderlund+renesas@ragnatech.se>
 <20170504151219.GB7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170504151219.GB7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2017-05-04 18:12:20 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Fri, Apr 28, 2017 at 12:41:57AM +0200, Niklas S�derlund wrote:
> > In media controller mode all VIN instances needs to be part of the same
> > media graph. There is also a need to each VIN instance to know and in
> > some cases be able to communicate with other VIN instances.
> > 
> > Add a allocator framework where the first VIN instance to be probed
> > creates a shared data structure and creates a media device.
> > 
> > Signed-off-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 112 +++++++++++++++++++++++++++-
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  38 ++++++++++
> >  2 files changed, 147 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index f560d27449b84882..c10770d5ec37816c 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -20,12 +20,110 @@
> >  #include <linux/of_graph.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/slab.h>
> >  
> >  #include <media/v4l2-of.h>
> >  
> >  #include "rcar-vin.h"
> >  
> >  /* -----------------------------------------------------------------------------
> > + * Gen3 CSI2 Group Allocator
> > + */
> > +
> > +static DEFINE_MUTEX(rvin_group_lock);
> > +static struct rvin_group *rvin_group_data;
> 
> Uh-oh.
> 
> It'd be nice to find a way for managing the group of devices without a
> global list for the group.
> 
> Do all the callers operating on a group have some kind of identifying
> information, e.g. OF node or struct device? Could it be used to obtain the
> group?

I agree that a none global list would be better. There is room for 
improvement here in the future. I do believe some key can be found in DT 
as to create the group of all VIN instances who are part of the same OF 
graph or something similar.

There is also one other limiting factor at play here. The VIN instances 
0-3 and 4-7 must be in the same group since there are registers in VIN0 
that controls VIN1-3 and likewise in VIN4 for VIN5-6. And it is these 
shared control registers which is the primary reason this global group 
exists to begin with.

> 
> I'm not sure if this would be a real problem though as long as you have only
> a single group in a system.

No for now all VIN instances should be part of a single group as this is 
the only use-case which is valid (that I know of). So I hope to keep 
this as is for now and at a later time come back and improve it.

> 
> > +
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
> > +
> > +	vin_dbg(vin, "%s: alloc group=%p\n", __func__, group);
> > +	return group;
> > +}
> > +
> > +static struct rvin_group *rvin_group_allocate(struct rvin_dev *vin)
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
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	/* Init group data if its not already initialized */
> > +	mdev = &group->mdev;
> > +	if (!mdev->dev) {
> > +		mutex_init(&group->lock);
> > +		mdev->dev = vin->dev;
> > +
> > +		strlcpy(mdev->driver_name, "Renesas VIN",
> > +			sizeof(mdev->driver_name));
> > +		strlcpy(mdev->model, vin->dev->of_node->name,
> > +			sizeof(mdev->model));
> > +		strlcpy(mdev->bus_info, of_node_full_name(vin->dev->of_node),
> > +			sizeof(mdev->bus_info));
> > +		mdev->driver_version = LINUX_VERSION_CODE;
> > +		media_device_init(mdev);
> > +
> > +		ret = media_device_register(mdev);
> > +		if (ret) {
> > +			vin_err(vin, "Failed to register media device\n");
> > +			kref_put(&group->refcount, rvin_group_release);
> > +			mutex_unlock(&rvin_group_lock);
> > +			return ERR_PTR(ret);
> > +		}
> > +	}
> > +
> > +	vin->v4l2_dev.mdev = mdev;
> > +
> > +	mutex_unlock(&rvin_group_lock);
> > +
> > +	return group;
> > +}
> > +
> > +static void rvin_group_delete(struct rvin_dev *vin)
> > +{
> > +	vin_dbg(vin, "%s: group=%p\n", __func__, &vin->group);
> > +	kref_put(&vin->group->refcount, rvin_group_release);
> > +}
> > +
> > +/* -----------------------------------------------------------------------------
> >   * Async notifier
> >   */
> >  
> > @@ -263,9 +361,13 @@ static int rvin_group_init(struct rvin_dev *vin)
> >  {
> >  	int ret;
> >  
> > +	vin->group = rvin_group_allocate(vin);
> > +	if (IS_ERR(vin->group))
> > +		return PTR_ERR(vin->group);
> > +
> >  	ret = rvin_v4l2_mc_probe(vin);
> >  	if (ret)
> > -		return ret;
> > +		goto error_group;
> >  
> >  	vin->pad.flags = MEDIA_PAD_FL_SINK;
> >  	ret = media_entity_pads_init(&vin->vdev->entity, 1, &vin->pad);
> > @@ -275,6 +377,8 @@ static int rvin_group_init(struct rvin_dev *vin)
> >  	return 0;
> >  error_v4l2:
> >  	rvin_v4l2_mc_remove(vin);
> > +error_group:
> > +	rvin_group_delete(vin);
> >  
> >  	return ret;
> >  }
> > @@ -398,10 +502,12 @@ static int rcar_vin_remove(struct platform_device *pdev)
> >  
> >  	v4l2_async_notifier_unregister(&vin->notifier);
> >  
> > -	if (vin->info->use_mc)
> > +	if (vin->info->use_mc) {
> >  		rvin_v4l2_mc_remove(vin);
> > -	else
> > +		rvin_group_delete(vin);
> > +	} else {
> >  		rvin_v4l2_remove(vin);
> > +	}
> >  
> >  	rvin_dma_remove(vin);
> >  
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> > index 06934313950253f4..21b6c9292686e41a 100644
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
> > +
> >  /**
> >   * struct rvin_info- Information about the particular VIN implementation
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
> >  	struct rvin_graph_entity digital;
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
> > +};
> > +
> >  int rvin_dma_probe(struct rvin_dev *vin, int irq);
> >  void rvin_dma_remove(struct rvin_dev *vin);
> >  
> 
> -- 
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas S�derlund
