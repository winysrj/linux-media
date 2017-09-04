Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:58098 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753827AbdIDO4e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 10:56:34 -0400
Subject: Re: [PATCH v7 12/18] v4l: async: Allow binding notifiers to
 sub-devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-13-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <60db0a4b-0560-9591-f41f-1d055a50ba12@xs4all.nl>
Date: Mon, 4 Sep 2017 16:56:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-13-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> Registering a notifier has required the knowledge of struct v4l2_device
> for the reason that sub-devices generally are registered to the
> v4l2_device (as well as the media device, also available through
> v4l2_device).
> 
> This information is not available for sub-device drivers at probe time.
> 
> What this patch does is that it allows registering notifiers without
> having v4l2_device around. Instead the sub-device pointer is stored to the
> notifier. Once the sub-device of the driver that registered the notifier
> is registered, the notifier will gain the knowledge of the v4l2_device,
> and the binding of async sub-devices from the sub-device driver's notifier
> may proceed.
> 
> The master notifier's complete callback is only called when all sub-device
> notifiers are completed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 153 +++++++++++++++++++++++++++++------
>  include/media/v4l2-async.h           |  19 ++++-
>  2 files changed, 146 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 70d02378b48f..55d7886103d2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -25,6 +25,10 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
> +static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> +				  struct v4l2_subdev *sd,
> +				  struct v4l2_async_subdev *asd);
> +
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
>  #if IS_ENABLED(CONFIG_I2C)
> @@ -101,14 +105,69 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>  	return NULL;
>  }
>  
> +static bool v4l2_async_subdev_notifiers_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier->notifiers, notifiers) {
> +		if (!n->master)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +#define notifier_v4l2_dev(n) \
> +	(!!(n)->v4l2_dev ? (n)->v4l2_dev : \
> +	 !!(n)->master ? (n)->master->v4l2_dev : NULL)

Why '!!'?

> +
> +static struct v4l2_async_notifier *v4l2_async_get_subdev_notifier(
> +	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier_list, list) {
> +		if (n->sd == sd)
> +			return n;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int v4l2_async_notifier_test_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	if (!notifier_v4l2_dev(notifier))
> +		return 0;
> +
> +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +		struct v4l2_async_subdev *asd;
> +		int ret;
> +
> +		asd = v4l2_async_belongs(notifier, sd);
> +		if (!asd)
> +			continue;
> +
> +		ret = v4l2_async_test_notify(notifier, sd, asd);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  				  struct v4l2_subdev *sd,
>  				  struct v4l2_async_subdev *asd)

A general note (not specific to this patch series): I really don't like
this function name. v4l2_async_match_notify is a much better name.

With 'test' I get association with 'testing something' and not that it is
a match.

I have a similar problem with v4l2_async_belongs: v4l2_async_find_match
makes a lot more sense.

>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	int ret;
>  
> -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> -	if (ret < 0)
> +	ret = v4l2_device_register_subdev(notifier_v4l2_dev(notifier), sd);
> +	if (ret)
>  		return ret;
>  
>  	ret = v4l2_async_notifier_call_int_op(notifier, bound, sd, asd);
> @@ -125,8 +184,26 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
>  
> -	if (list_empty(&notifier->waiting) && notifier->ops->complete)
> -		return v4l2_async_notifier_call_int_op(notifier, complete);
> +	subdev_notifier = v4l2_async_get_subdev_notifier(notifier, sd);
> +	if (subdev_notifier && !subdev_notifier->master) {
> +		subdev_notifier->master = notifier;
> +		list_add(&subdev_notifier->notifiers, &notifier->notifiers);
> +		ret = v4l2_async_notifier_test_all_subdevs(subdev_notifier);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (list_empty(&notifier->waiting) &&
> +	    v4l2_async_subdev_notifiers_complete(notifier)) {
> +		ret = v4l2_async_notifier_call_int_op(notifier, complete);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (notifier->master && list_empty(&notifier->master->waiting) &&
> +	    v4l2_async_subdev_notifiers_complete(notifier->master))
> +		return v4l2_async_notifier_call_int_op(notifier->master,
> +						       complete);
>  
>  	return 0;
>  }
> @@ -140,18 +217,17 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	sd->dev = NULL;
>  }
>  
> -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -				 struct v4l2_async_notifier *notifier)
> +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> +	int ret;
>  	int i;
>  
> -	if (!v4l2_dev || !notifier->num_subdevs ||
> +	if (!!notifier->v4l2_dev == !!notifier->sd || !notifier->num_subdevs ||

'!!notifier->v4l2_dev == !!notifier->sd'???

This is '(notifier->v4l2_dev && notifier->sd) || (!notifier->v4l2_dev && !notifier->sd)'
but it took me a bit of time to parse that.

A 10 for creativity, but not so much for readability :-)

I suspect it can be simplified as well, or some of these tests can be moved to
the two functions that call this one. I think that might be best, in fact.

>  	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
>  
> -	notifier->v4l2_dev = v4l2_dev;
> +	INIT_LIST_HEAD(&notifier->notifiers);
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
>  
> @@ -175,18 +251,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	mutex_lock(&list_lock);
>  
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
> -		asd = v4l2_async_belongs(notifier, sd);
> -		if (!asd)
> -			continue;
> -
> -		ret = v4l2_async_test_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +	ret = v4l2_async_notifier_test_all_subdevs(notifier);
> +	if (ret) {
> +		mutex_unlock(&list_lock);
> +		return ret;
>  	}
>  
>  	/* Keep also completed notifiers on the list */
> @@ -196,27 +264,62 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	return 0;
>  }
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	notifier->v4l2_dev = v4l2_dev;
> +
> +	return __v4l2_async_notifier_register(notifier);
> +}
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier)
> +{
> +	notifier->sd = sd;
> +
> +	return __v4l2_async_notifier_register(notifier);
> +}
> +EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
> +
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
> +	struct v4l2_async_notifier *notifier_iter, *notifier_tmp;
>  	struct v4l2_subdev *sd, *tmp;
>  	unsigned int notif_n_subdev = notifier->num_subdevs;
>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
>  	struct device **dev;
>  	int i = 0;
>  
> -	if (!notifier->v4l2_dev)
> +	if (!notifier->v4l2_dev && !notifier->sd)
>  		return;
>  
>  	dev = kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
>  	if (!dev) {
> -		dev_err(notifier->v4l2_dev->dev,
> +		dev_err(notifier->v4l2_dev ?
> +			notifier->v4l2_dev->dev : notifier->sd->dev,
>  			"Failed to allocate device cache!\n");
>  	}
>  
>  	mutex_lock(&list_lock);
>  
> +	if (notifier->v4l2_dev) {
> +		/* Remove all subdev notifiers from the master's list */
> +		list_for_each_entry_safe(notifier_iter, notifier_tmp,
> +					 &notifier->notifiers, notifiers) {
> +			list_del_init(&notifier_iter->notifiers);
> +			WARN_ON(notifier_iter->master != notifier);
> +			notifier_iter->master = NULL;
> +		}
> +		notifier->v4l2_dev = NULL;
> +	} else {
> +		/* Remove subdev notifier from the master's list */
> +		list_del_init(&notifier->notifiers);
> +		notifier->master = NULL;
> +		notifier->sd = NULL;
> +	}
> +
>  	list_del(&notifier->list);
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> @@ -266,8 +369,6 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	}
>  	kvfree(dev);
>  
> -	notifier->v4l2_dev = NULL;
> -
>  	/*
>  	 * Don't care about the waiting list, it is initialised and populated
>  	 * upon notifier registration.
> @@ -287,6 +388,8 @@ void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
>  
>  	kvfree(notifier->subdevs);
>  	notifier->subdevs = NULL;
> +
> +	WARN_ON(!list_empty(&notifier->notifiers));
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_release);
>  
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c3e001e0d1f1..a5c123ac2873 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -110,7 +110,11 @@ struct v4l2_async_notifier_operations {
>   * @num_subdevs: number of subdevices used in the subdevs array
>   * @max_subdevs: number of subdevices allocated in the subdevs array
>   * @subdevs:	array of pointers to subdevice descriptors
> - * @v4l2_dev:	pointer to struct v4l2_device
> + * @v4l2_dev:	v4l2_device of the master, for subdev notifiers NULL
> + * @sd:		sub-device that registered the notifier, NULL otherwise
> + * @notifiers:	list of struct v4l2_async_notifier, notifiers linked to this
> + *		notifier
> + * @master:	master notifier carrying @v4l2_dev
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> @@ -121,6 +125,9 @@ struct v4l2_async_notifier {
>  	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	struct list_head notifiers;
> +	struct v4l2_async_notifier *master;
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> @@ -136,6 +143,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  				 struct v4l2_async_notifier *notifier);
>  
>  /**
> + * v4l2_async_subdev_notifier_register - registers a subdevice asynchronous
> + *					 notifier for a sub-device
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @notifier: pointer to &struct v4l2_async_notifier
> + */
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier);
> +
> +/**
>   * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
>   *
>   * @notifier: pointer to &struct v4l2_async_notifier
> 

Do you have a git tree with this patch series? I think I need to look at this
in the final version, not just the patch.

Regards,

	Hans
