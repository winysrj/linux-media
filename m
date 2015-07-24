Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33489 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbbGXJJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 05:09:19 -0400
Message-ID: <55B20076.6090809@xs4all.nl>
Date: Fri, 24 Jul 2015 11:08:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: j.anaszewski@samsung.com
Subject: Re: [PATCH 1/1] v4l: subdev: Serialise open and release internal
 ops
References: <1437581650-1422-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1437581650-1422-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/22/2015 06:14 PM, Sakari Ailus wrote:
> By default, serialise open and release internal ops using a mutex.
> 
> The underlying problem is that a large proportion of the drivers do use
> v4l2_fh_is_singular() in their open() handlers (struct
> v4l2_subdev_internal_ops). v4l2_subdev_open(), .open file operation handler
> of the V4L2 sub-device framework, calls v4l2_fh_add() which adds the file
> handle to the list of open file handles of the device. Later on in the
> open() handler of the sub-device driver uses v4l2_fh_is_singular() to
> determine whether it was the file handle which was first opened. The check
> may go wrong if the device was opened by multiple process closely enough in
> time.

I don't like this patch for a few reasons: first of all it makes open/close
different from the open/close handling for normal v4l2 drivers. The decision
was made to use a core lock to serialize ioctls, but not the file operations.

The reason was that not all file operations need to take a lock, and that
drivers often need to do special things in the open/close anyway and using
the core lock for this caused more headaches than it solved.

I think we need to stick to the same scheme here. Note that I wouldn't mind
introducing a serialization lock for subdev ioctls. There isn't one at the
moment, and I think that that will simplify locking for subdevs, just as it
did for non-subdev drivers.

The second problem is that this depends on a new flag which is fairly ugly.

Drivers should just take a lock before calling fh_add and fh_singular.

Things can be simplified a bit with the v4l2-fh functions: I think it makes
sense if v4l2_fh_add and v4l2_fh_del both return a bool which is true if it
was the first or last filehandle.

That way you can just do:

	mutex_lock(&lock);
	if (v4l2_fh_add()) {
		...
	}
	mutex_unlock(&lock);

Same with v4l2_fh_del().

While we're at it: v4l2_fh_is_singular(_file) should return a bool, not an int.

Hmm, let me make a patch series for these fh changes, shouldn't be too difficult.

Regards,

	Hans

> 
> Why this is especially important is because many drivers perform power
> management and other hardware initialisation based on open file handles.
> 
> Example one: Two processes open the device, but both end up determining
> neither was the first file handle opened on the device.
> 
> 	process A: v4l2_fh_add()
> 	process B: v4l2_fh_add()
> 
> 	...
> 
> 	process A: v4l2_fh_is_singular() # false
> 	process B: v4l2_fh_is_singular() # false
> 
> Example two:
> 
> 	process A: v4l2_fh_add()
> 
> 	...
> 
> 	process A: v4l2_fh_is_singular() # true
> 					 # at this point the driver does
> 					 # time-consuming hardware
> 					 # initialisation in the context of
> 					 # process A
> 
> 	process B: v4l2_fh_add()
> 	process B: v4l2_fh_is_singular() # false
> 					 # open system call finishes
> 
> 	...
> 
> 	process B proceeds to access the sub-device
> 
> 	...
> 
> 	process A finishes hardware initialisation
> 
> If the sub-device's open() handler in struct v4l2_subdev_internal_ops is not
> defined, then the information on whether the file handle was the first to be
> opened is not needed to complete the open system call on the device, and
> serialisation of the open and release system calls thus is not needed, with
> the possible exception for the driver's own reasons, but that is entirely
> the job of the driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-device.c |  4 ++++
>  drivers/media/v4l2-core/v4l2-subdev.c | 41 +++++++++++++++++++++++++++++------
>  include/media/v4l2-subdev.h           |  4 ++++
>  3 files changed, 42 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 5b0a30b..a13e0be 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -191,6 +191,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  	}
>  #endif
>  
> +	mutex_init(&sd->open_lock);
> +
>  	spin_lock(&v4l2_dev->lock);
>  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
>  	spin_unlock(&v4l2_dev->lock);
> @@ -292,5 +294,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  	video_unregister_device(sd->devnode);
>  	if (!sd->owner_v4l2_dev)
>  		module_put(sd->owner);
> +
> +	mutex_destroy(&sd->open_lock);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index b3f7da9..d8a98c4 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -50,6 +50,18 @@ static void subdev_fh_free(struct v4l2_subdev_fh *fh)
>  #endif
>  }
>  
> +static void subdev_open_lock(struct v4l2_subdev *sd)
> +{
> +	if (sd->flags & V4L2_SUBDEV_FL_SERIALISE_OPEN)
> +		mutex_lock(&sd->open_lock);
> +}
> +
> +static void subdev_open_unlock(struct v4l2_subdev *sd)
> +{
> +	if (sd->flags & V4L2_SUBDEV_FL_SERIALISE_OPEN)
> +		mutex_unlock(&sd->open_lock);
> +}
> +
>  static int subdev_open(struct file *file)
>  {
>  	struct video_device *vdev = video_devdata(file);
> @@ -64,11 +76,11 @@ static int subdev_open(struct file *file)
>  	if (subdev_fh == NULL)
>  		return -ENOMEM;
>  
> +	subdev_open_lock(sd);
> +
>  	ret = subdev_fh_init(subdev_fh, sd);
> -	if (ret) {
> -		kfree(subdev_fh);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_free_subdev_fh;
>  
>  	v4l2_fh_init(&subdev_fh->vfh, vdev);
>  	v4l2_fh_add(&subdev_fh->vfh);
> @@ -78,7 +90,7 @@ static int subdev_open(struct file *file)
>  		entity = media_entity_get(&sd->entity);
>  		if (!entity) {
>  			ret = -EBUSY;
> -			goto err;
> +			goto err_media_entity_put;
>  		}
>  	}
>  #endif
> @@ -86,20 +98,26 @@ static int subdev_open(struct file *file)
>  	if (sd->internal_ops && sd->internal_ops->open) {
>  		ret = sd->internal_ops->open(sd, subdev_fh);
>  		if (ret < 0)
> -			goto err;
> +			goto err_media_entity_put;
>  	}
>  
> +	subdev_open_unlock(sd);
> +
>  	return 0;
>  
> -err:
> +err_media_entity_put:
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	media_entity_put(entity);
>  #endif
>  	v4l2_fh_del(&subdev_fh->vfh);
>  	v4l2_fh_exit(&subdev_fh->vfh);
>  	subdev_fh_free(subdev_fh);
> +
> +err_free_subdev_fh:
>  	kfree(subdev_fh);
>  
> +	subdev_open_unlock(sd);
> +
>  	return ret;
>  }
>  
> @@ -110,6 +128,8 @@ static int subdev_close(struct file *file)
>  	struct v4l2_fh *vfh = file->private_data;
>  	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
>  
> +	subdev_open_lock(sd);
> +
>  	if (sd->internal_ops && sd->internal_ops->close)
>  		sd->internal_ops->close(sd, subdev_fh);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> @@ -117,7 +137,11 @@ static int subdev_close(struct file *file)
>  		media_entity_put(&sd->entity);
>  #endif
>  	v4l2_fh_del(vfh);
> +
> +	subdev_open_unlock(sd);
> +
>  	v4l2_fh_exit(vfh);
> +
>  	subdev_fh_free(subdev_fh);
>  	kfree(subdev_fh);
>  	file->private_data = NULL;
> @@ -586,6 +610,9 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->ops = ops;
>  	sd->v4l2_dev = NULL;
>  	sd->flags = 0;
> +	/* Default to serialised open and release. */
> +	if (sd->internal_ops && sd->internal_ops->open)
> +		sd->flags |= V4L2_SUBDEV_FL_SERIALISE_OPEN;
>  	sd->name[0] = '\0';
>  	sd->grp_id = 0;
>  	sd->dev_priv = NULL;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5622699..11ffd50 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -624,6 +624,8 @@ struct v4l2_subdev_internal_ops {
>  #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
>  /* Set this flag if this subdev generates events. */
>  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> +/* Set this flag if the sub-device open/close do NOT need to be serialised. */
> +#define V4L2_SUBDEV_FL_SERIALISE_OPEN		(1U << 4)
>  
>  struct regulator_bulk_data;
>  
> @@ -672,6 +674,8 @@ struct v4l2_subdev {
>  	struct v4l2_async_notifier *notifier;
>  	/* common part of subdevice platform data */
>  	struct v4l2_subdev_platform_data *pdata;
> +	/* serialise open and release based on the flags field */
> +	struct mutex open_lock;
>  };
>  
>  #define media_entity_to_v4l2_subdev(ent) \
> 

