Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:54756 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0IPIzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 04:55:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 11/11] v4l: Make v4l2_subdev inherit from media_entity
Date: Thu, 16 Sep 2010 10:55:34 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-12-git-send-email-laurent.pinchart@ideasonboard.com> <4C883792.3080208@redhat.com>
In-Reply-To: <4C883792.3080208@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161055.36156.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 09 September 2010 03:25:38 Mauro Carvalho Chehab wrote:
> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> > V4L2 subdevices are media entities. As such they need to inherit from
> > (include) the media_entity structure.
> > 
> > When registering/unregistering the subdevice, the media entity is
> > automatically registered/unregistered. The entity is acquired on device
> > open and released on device close.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> > 
> >  Documentation/video4linux/v4l2-framework.txt |   23 ++++++++++++++++++
> >  drivers/media/video/v4l2-device.c            |   32
> >  +++++++++++++++++++++----- drivers/media/video/v4l2-subdev.c           
> >  |   27 +++++++++++++++++++++- include/media/v4l2-subdev.h              
> >     |    7 +++++
> >  4 files changed, 82 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/video4linux/v4l2-framework.txt
> > b/Documentation/video4linux/v4l2-framework.txt index 7ff4016..3416d93
> > 100644
> > --- a/Documentation/video4linux/v4l2-framework.txt
> > +++ b/Documentation/video4linux/v4l2-framework.txt
> > 
> > @@ -263,6 +263,26 @@ A sub-device driver initializes the v4l2_subdev 
struct using:
> >  Afterwards you need to initialize subdev->name with a unique name and
> >  set the module owner. This is done for you if you use the i2c helper
> >  functions.
> > 
> > +If integration with the media framework is needed, you must initialize
> > the +media_entity struct embedded in the v4l2_subdev struct (entity
> > field) by +calling media_entity_init():
> > +
> > +	struct media_pad *pads = &my_sd->pads;
> > +	int err;
> > +
> > +	err = media_entity_init(&sd->entity, npads, pads, 0);
> > +
> > +The pads array must have been previously initialized. There is no need
> > to +manually set the struct media_entity type and name fields, but the
> > revision +field must be initialized if needed.
> > +
> > +A reference to the entity will be automatically acquired/released when
> > the +subdev device node (if any) is opened/closed.
> > +
> > +Don't forget to cleanup the media entity before the sub-device is
> > destroyed: +
> > +	media_entity_cleanup(&sd->entity);
> > +
> > 
> >  A device (bridge) driver needs to register the v4l2_subdev with the
> > 
> >  v4l2_device:
> > @@ -272,6 +292,9 @@ This can fail if the subdev module disappeared before
> > it could be registered.
> > 
> >  After this function was called successfully the subdev->dev field points
> >  to the v4l2_device.
> > 
> > +If the v4l2_device parent device has a non-NULL mdev field, the
> > sub-device +entity will be automatically registered with the media
> > device.
> > +
> > 
> >  You can unregister a sub-device using:
> >  	v4l2_device_unregister_subdev(sd);
> > 
> > diff --git a/drivers/media/video/v4l2-device.c
> > b/drivers/media/video/v4l2-device.c index 91452cd..4f74d01 100644
> > --- a/drivers/media/video/v4l2-device.c
> > +++ b/drivers/media/video/v4l2-device.c
> > @@ -114,10 +114,11 @@ void v4l2_device_unregister(struct v4l2_device
> > *v4l2_dev)
> > 
> >  EXPORT_SYMBOL_GPL(v4l2_device_unregister);
> >  
> >  int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> > 
> > -						struct v4l2_subdev *sd)
> > +				struct v4l2_subdev *sd)
> > 
> >  {
> > 
> > +	struct media_entity *entity = &sd->entity;
> > 
> >  	struct video_device *vdev;
> > 
> > -	int ret = 0;
> > +	int ret;
> > 
> >  	/* Check for valid input */
> >  	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
> > 
> > @@ -129,6 +130,15 @@ int v4l2_device_register_subdev(struct v4l2_device
> > *v4l2_dev,
> > 
> >  	if (!try_module_get(sd->owner))
> >  	
> >  		return -ENODEV;
> > 
> > +	/* Register the entity. */
> > +	if (v4l2_dev->mdev) {
> > +		ret = media_device_register_entity(v4l2_dev->mdev, entity);
> > +		if (ret < 0) {
> > +			module_put(sd->owner);
> > +			return ret;
> > +		}
> > +	}
> > +
> > 
> >  	sd->v4l2_dev = v4l2_dev;
> >  	spin_lock(&v4l2_dev->lock);
> >  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
> > 
> > @@ -143,26 +153,36 @@ int v4l2_device_register_subdev(struct v4l2_device
> > *v4l2_dev,
> > 
> >  	if (sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE) {
> >  	
> >  		ret = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
> >  		
> >  					      sd->owner);
> > 
> > -		if (ret < 0)
> > +		if (ret < 0) {
> > 
> >  			v4l2_device_unregister_subdev(sd);
> > 
> > +			return ret;
> > +		}
> > 
> >  	}
> > 
> > -	return ret;
> > +	entity->v4l.major = VIDEO_MAJOR;
> > +	entity->v4l.minor = vdev->minor;
> 
> Hmm... it needs to check if entity is not null.

Entity is set to

struct media_entity *entity = &sd->entity;

It can't be NULL.

> > +	return 0;
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
> >  
> >  void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
> >  {
> > 
> > +	struct v4l2_device *v4l2_dev;
> > +
> > 
> >  	/* return if it isn't registered */
> >  	if (sd == NULL || sd->v4l2_dev == NULL)
> >  	
> >  		return;
> > 
> > -	spin_lock(&sd->v4l2_dev->lock);
> > +	v4l2_dev = sd->v4l2_dev;
> > +
> > +	spin_lock(&v4l2_dev->lock);
> > 
> >  	list_del(&sd->list);
> > 
> > -	spin_unlock(&sd->v4l2_dev->lock);
> > +	spin_unlock(&v4l2_dev->lock);
> > 
> >  	sd->v4l2_dev = NULL;
> >  	
> >  	module_put(sd->owner);
> > 
> > +	if (v4l2_dev->mdev)
> > +		media_device_unregister_entity(&sd->entity);
> > 
> >  	video_unregister_device(&sd->devnode);
> >  
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> > 
> > diff --git a/drivers/media/video/v4l2-subdev.c
> > b/drivers/media/video/v4l2-subdev.c index b063195..1efa267 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -32,7 +32,8 @@ static int subdev_open(struct file *file)
> > 
> >  {
> >  
> >  	struct video_device *vdev = video_devdata(file);
> >  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> > 
> > -	struct v4l2_fh *vfh;
> > +	struct media_entity *entity;
> > +	struct v4l2_fh *vfh = NULL;
> > 
> >  	int ret;
> >  	
> >  	if (!sd->initialized)
> > 
> > @@ -59,10 +60,17 @@ static int subdev_open(struct file *file)
> > 
> >  		file->private_data = vfh;
> >  	
> >  	}
> > 
> > +	entity = media_entity_get(&sd->entity);
> > +	if (!entity) {
> > +		ret = -EBUSY;
> > +		goto err;
> > +	}
> > +
> 
> It needs to check if v4l2_dev->mdev is not null, as it makes no sense to
> get an entity if the driver is not using the media entity.

OK.

> >  	return 0;
> >  
> >  err:
> >  	if (vfh != NULL) {
> > 
> > +		v4l2_fh_del(vfh);
> > 
> >  		v4l2_fh_exit(vfh);
> >  		kfree(vfh);
> >  	
> >  	}
> > 
> > @@ -72,8 +80,12 @@ err:
> >  static int subdev_close(struct file *file)
> >  {
> > 
> > +	struct video_device *vdev = video_devdata(file);
> > +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> > 
> >  	struct v4l2_fh *vfh = file->private_data;
> > 
> > +	media_entity_put(&sd->entity);
> 
> Same here: don't put it, if v4l2_dev->mdev = NULL (I think that you're
> already checking for it at media_entity_put).
> 
> > +
> > 
> >  	if (vfh != NULL) {
> >  	
> >  		v4l2_fh_del(vfh);
> >  		v4l2_fh_exit(vfh);
> > 
> > @@ -172,5 +184,18 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const
> > struct v4l2_subdev_ops *ops)
> > 
> >  	sd->grp_id = 0;
> >  	sd->priv = NULL;
> >  	sd->initialized = 1;
> > 
> > +	sd->entity.name = sd->name;
> > +	sd->entity.type = MEDIA_ENTITY_TYPE_SUBDEV;
> > 
> >  }
> >  EXPORT_SYMBOL(v4l2_subdev_init);
> > 
> > +
> > +int v4l2_subdev_set_power(struct media_entity *entity, int power)
> > +{
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +
> > +	dev_dbg(entity->parent->dev,
> > +		"%s power%s\n", entity->name, power ? "on" : "off");
> > +
> > +	return v4l2_subdev_call(sd, core, s_power, power);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_subdev_set_power);
> 
> Also, should do nothing if media entity is null.
> 
> PS.: Not sure where this function is called, as the caller is not on this
> patch series. The better would be to add this together with the patch
> calling v4l2_subdev_set_power().

v4l2_subdev_set_power() is a helper meant to be assigned to struct 
media_entity_operations::set_power in subdev drivers.

-- 
Regards,

Laurent Pinchart
