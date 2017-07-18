Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56230 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbdGROWp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 10:22:45 -0400
Subject: Re: [PATCH v4 3/3] v4l: async: add subnotifier to subdevices
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1da4fac1-3bf4-e66a-2341-b1f71f0f917d@xs4all.nl>
Date: Tue, 18 Jul 2017 16:22:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/07/17 18:59, Niklas Söderlund wrote:
> Add a subdevice specific notifier which can be used by a subdevice
> driver to compliment the master device notifier to extend the subdevice

compliment -> complement

Just one character difference, but a wildly different meaning :-)

Although it was very polite of the subdevice driver to compliment the
master driver. Impeccable manners. :-)

> discovery.
> 
> The master device registers the subdevices closest to itself in its
> notifier while the subdevice(s) register notifiers for their closest
> neighboring devices. Subdevice drivers configures a notifier at probe

configures -> configure

> time which are registered by the v4l2-async framework once the subdevice

are -> is

> itself is register, since it's only at this point the v4l2_dev is

register -> registered

> available to the subnotifier.
> 
> Using this incremental approach two problems can be solved:
> 
> 1. The master device no longer has to care how many devices exist in
>    the pipeline. It only needs to care about its closest subdevice and
>    arbitrary long pipelines can be created without having to adapt the
>    master device for each case.
> 
> 2. Subdevices which are represented as a single DT node but register
>    more than one subdevice can use this to improve the pipeline
>    discovery, since the subdevice driver is the only one who knows which
>    of its subdevices is linked with which subdevice of a neighboring DT
>    node.
> 
> To allow subdevices to provide its own list of subdevices to the

its -> their

> v4l2-async framework v4l2_async_subdev_register_notifier() is added.
> This new function must be called before the subdevice itself is
> registered with the v4l2-async framework using
> v4l2_async_register_subdev().
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/media/kapi/v4l2-subdev.rst |  12 +++
>  drivers/media/v4l2-core/v4l2-async.c     | 134 +++++++++++++++++++++++++++++--
>  include/media/v4l2-async.h               |  25 ++++++
>  include/media/v4l2-subdev.h              |   5 ++
>  4 files changed, 168 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> index e1f0b726e438f963..5957176965a6a3ef 100644
> --- a/Documentation/media/kapi/v4l2-subdev.rst
> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> @@ -262,6 +262,18 @@ is called. After all subdevices have been located the .complete() callback is
>  called. When a subdevice is removed from the system the .unbind() method is
>  called. All three callbacks are optional.
>  
> +Subdevice drivers might in turn register subnotifier objects with an
> +array of other subdevice descriptors that the subdevice needs for its
> +own operation. Subnotifiers are an extension of the bridge drivers
> +notifier to allow for a incremental registering and matching of
> +subdevices. This is useful when a driver only has information about
> +which subdevice is closest to itself and would require knowledge from the
> +driver of that subdevice to know which other subdevice(s) lie beyond.
> +By registering subnotifiers drivers can incrementally move the subdevice
> +matching down the chain of drivers. This is performed using the
> +:c:func:`v4l2_async_subdev_register_notifier` call which must be performed
> +before registering the subdevice using :c:func:`v4l2_async_register_subdev`.
> +
>  V4L2 sub-device userspace API
>  -----------------------------
>  
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 8fc84f7962386ddd..558fb3ec07e7fba8 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -100,6 +100,61 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>  	return NULL;
>  }
>  
> +static int v4l2_async_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	if (!notifier->num_subdevs)
> +		return 0;
> +
> +	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		v4l2_async_notifier_complete(&sd->subnotifier);
> +	}

Curly brackets aren't needed here (didn't checkpatch complain about this?)

> +
> +	if (notifier->complete)
> +		return notifier->complete(notifier);
> +
> +	return 0;
> +}
> +
> +static bool
> +v4l2_async_is_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	if (!list_empty(&notifier->waiting))
> +		return false;
> +
> +	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		/* Don't consider empty subnotifiers */
> +		if (!sd->subnotifier.num_subdevs)
> +			continue;
> +
> +		if (!v4l2_async_is_notifier_complete(&sd->subnotifier))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int
> +v4l2_async_try_complete_notifier(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_notifier *root = notifier;
> +
> +	while (root->subnotifier) {
> +		root = subnotifier_to_v4l2_subdev(root)->notifier;
> +		/* No root notifier can be found at this time */
> +		if (!root)
> +			return 0;
> +	}
> +
> +	if (v4l2_async_is_notifier_complete(root))
> +		return v4l2_async_notifier_complete(root);
> +
> +	return 0;
> +}
> +
>  static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  				  struct v4l2_subdev *sd,
>  				  struct v4l2_async_subdev *asd)
> @@ -119,6 +174,17 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  		return ret;
>  	}
>  
> +	/* Register the subnotifier if it's not empty */
> +	if (sd->subnotifier.num_subdevs) {
> +		ret = v4l2_async_notifier_register(sd->v4l2_dev,
> +						   &sd->subnotifier);
> +		if (ret) {
> +			if (notifier->unbind)
> +				notifier->unbind(notifier, sd, asd);
> +			v4l2_device_unregister_subdev(sd);
> +			return ret;
> +		}
> +	}
>  	/* Remove from the waiting list */
>  	list_del(&asd->list);
>  	sd->asd = asd;
> @@ -127,10 +193,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
>  
> -	if (list_empty(&notifier->waiting) && notifier->complete)
> -		return notifier->complete(notifier);
> -
> -	return 0;
> +	return v4l2_async_try_complete_notifier(notifier);
>  }
>  
>  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> @@ -140,6 +203,7 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	list_del_init(&sd->async_list);
>  	sd->asd = NULL;
>  	sd->dev = NULL;
> +	sd->notifier = NULL;
>  }
>  
>  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> @@ -175,8 +239,17 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		list_add_tail(&asd->list, &notifier->waiting);
>  	}
>  
> -	mutex_lock(&list_lock);
> +	if (notifier->subnotifier)
> +		lockdep_assert_held(&list_lock);
> +	else
> +		mutex_lock(&list_lock);
>  
> +	/*
> +	 * This function can be called recursively so the list
> +	 * might be modified in a recursive call. Start from the
> +	 * top of the list each iteration.
> +	 */
> +again:
>  	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
>  		int ret;
>  
> @@ -186,15 +259,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  		ret = v4l2_async_test_notify(notifier, sd, asd);
>  		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> +			if (!notifier->subnotifier)
> +				mutex_unlock(&list_lock);
>  			return ret;
>  		}
> +		goto again;
>  	}
>  
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
>  
> -	mutex_unlock(&list_lock);
> +	if (!notifier->subnotifier)
> +		mutex_unlock(&list_lock);
>  
>  	return 0;
>  }
> @@ -202,7 +278,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
> +	struct v4l2_subdev *sd, *tmp, **subdev;
>  	unsigned int notif_n_subdev = notifier->num_subdevs;
>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
>  	struct device **dev;
> @@ -217,6 +293,12 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  			"Failed to allocate device cache!\n");
>  	}
>  
> +	subdev = kvmalloc_array(n_subdev, sizeof(*subdev), GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(notifier->v4l2_dev->dev,
> +			"Failed to allocate subdevice cache!\n");
> +	}
> +

How about making a little struct:

	struct whatever {
		struct device *dev;
		struct v4l2_subdev *sd;
	};

and allocate an array of that. Only need to call kvmalloc_array once.

Some comments after the dev_err of why you ignore the failed memory allocation
and what the consequences of that are would be helpful. It is unexpected code,
and that needs documentation.

See also my comment for patch 2/3.

>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
> @@ -224,6 +306,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
>  		if (dev)
>  			dev[count] = get_device(sd->dev);
> +		if (subdev)
> +			subdev[count] = sd;
>  		count++;
>  
>  		if (notifier->unbind)
> @@ -235,10 +319,15 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	mutex_unlock(&list_lock);
>  
>  	for (i = 0; i < count; i++) {
> +		/* If the subdev have a notifier unregister it */
> +		if (subdev && subdev[i]->subnotifier.num_subdevs)
> +			v4l2_async_notifier_unregister(&subdev[i]->subnotifier);
> +
>  		/* If we handled USB devices, we'd have to lock the parent too */
>  		if (dev)
>  			device_release_driver(dev[i]);
>  	}
> +	kvfree(subdev);
>  
>  	/*
>  	 * Call device_attach() to reprobe devices
> @@ -313,6 +402,9 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  		return;
>  	}
>  
> +	if (sd->subnotifier.num_subdevs)
> +		v4l2_async_notifier_unregister(&sd->subnotifier);
> +
>  	mutex_lock(&list_lock);
>  
>  	list_add(&sd->asd->list, &notifier->waiting);
> @@ -325,3 +417,29 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> +
> +int v4l2_async_subdev_register_notifier(

Since it is v4l2_async_notifier_register(), shouldn't this be v4l2_async_subdev_notifier_register()?

> +		struct v4l2_subdev *sd,
> +		unsigned int num_subdevs,
> +		struct v4l2_async_subdev **subdevs,
> +		int (*bound)(struct v4l2_async_notifier *notifier,
> +			     struct v4l2_subdev *subdev,
> +			     struct v4l2_async_subdev *asd),
> +		int (*complete)(struct v4l2_async_notifier *notifier),
> +		void (*unbind)(struct v4l2_async_notifier *notifier,
> +			       struct v4l2_subdev *subdev,
> +			       struct v4l2_async_subdev *asd))
> +{
> +	if (!sd)

Test for '!num_subdevs || !subdevs' as well?

> +		return -EINVAL;
> +
> +	sd->subnotifier.subnotifier = true;
> +	sd->subnotifier.num_subdevs = num_subdevs;
> +	sd->subnotifier.subdevs = subdevs;
> +	sd->subnotifier.bound = bound;
> +	sd->subnotifier.complete = complete;
> +	sd->subnotifier.unbind = unbind;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_async_subdev_register_notifier);
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c69d8c8a66d0093a..4f142a22373450af 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -78,6 +78,7 @@ struct v4l2_async_subdev {
>  /**
>   * struct v4l2_async_notifier - v4l2_device notifier data
>   *
> + * @subnotifier: flag if this notifier is part of a v4l2_subdev
>   * @num_subdevs: number of subdevices
>   * @subdevs:	array of pointers to subdevice descriptors
>   * @v4l2_dev:	pointer to struct v4l2_device
> @@ -89,6 +90,7 @@ struct v4l2_async_subdev {
>   * @unbind:	a subdevice is leaving
>   */
>  struct v4l2_async_notifier {
> +	bool subnotifier;
>  	unsigned int num_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
> @@ -135,4 +137,27 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
>   * @sd: pointer to &struct v4l2_subdev
>   */
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
> +
> +/**
> + * v4l2_async_subdev_register_notifier - registers a subdevice asynchronous
> + *	subnotifier
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @num_subdevs: number of subdevices
> + * @subdevs: array of pointers to subdevice descriptors
> + * @bound: a subdevice driver has successfully probed one of subdevices
> + * @complete: all subdevices have been probed successfully
> + * @unbind: a subdevice is leaving
> + */
> +int v4l2_async_subdev_register_notifier(
> +		struct v4l2_subdev *sd,
> +		unsigned int num_subdevs,
> +		struct v4l2_async_subdev **subdevs,
> +		int (*bound)(struct v4l2_async_notifier *notifier,
> +			     struct v4l2_subdev *subdev,
> +			     struct v4l2_async_subdev *asd),
> +		int (*complete)(struct v4l2_async_notifier *notifier),
> +		void (*unbind)(struct v4l2_async_notifier *notifier,
> +			       struct v4l2_subdev *subdev,
> +			       struct v4l2_async_subdev *asd));
>  #endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 0f92ebd2d7101acf..13a04af16a627394 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -793,6 +793,7 @@ struct v4l2_subdev_platform_data {
>   *	list.
>   * @asd: Pointer to respective &struct v4l2_async_subdev.
>   * @notifier: Pointer to the managing notifier.
> + * @subnotifier: Notifier for devices the subdevice depends on
>   * @pdata: common part of subdevice platform data
>   *
>   * Each instance of a subdev driver should create this struct, either
> @@ -823,6 +824,7 @@ struct v4l2_subdev {
>  	struct list_head async_list;
>  	struct v4l2_async_subdev *asd;
>  	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier subnotifier;
>  	struct v4l2_subdev_platform_data *pdata;
>  };
>  
> @@ -838,6 +840,9 @@ struct v4l2_subdev {
>  #define vdev_to_v4l2_subdev(vdev) \
>  	((struct v4l2_subdev *)video_get_drvdata(vdev))
>  
> +#define subnotifier_to_v4l2_subdev(sub) \
> +	container_of(sub, struct v4l2_subdev, subnotifier)
> +
>  /**
>   * struct v4l2_subdev_fh - Used for storing subdev information per file handle
>   *
> 

Regards,

	Hans
