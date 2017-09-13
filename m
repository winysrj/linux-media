Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52805 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751842AbdIMHRN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 03:17:13 -0400
Subject: Re: [PATCH v12 15/26] v4l: async: Allow binding notifiers to
 sub-devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-16-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <575bf15b-62d2-3a51-d550-d462578471f7@xs4all.nl>
Date: Wed, 13 Sep 2017 09:17:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170912134200.19556-16-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> Registering a notifier has required the knowledge of struct v4l2_device
> for the reason that sub-devices generally are registered to the
> v4l2_device (as well as the media device, also available through
> v4l2_device).
> 
> This information is not available for sub-device drivers at probe time.
> 
> What this patch does is that it allows registering notifiers without
> having v4l2_device around. Instead the sub-device pointer is stored in the
> notifier. Once the sub-device of the driver that registered the notifier
> is registered, the notifier will gain the knowledge of the v4l2_device,
> and the binding of async sub-devices from the sub-device driver's notifier
> may proceed.
> 
> The root notifier's complete callback is only called when all sub-device
> notifiers are completed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Just two small comments (see below).

After changing those (the first is up to you) you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 219 ++++++++++++++++++++++++++++++-----
>  include/media/v4l2-async.h           |  16 ++-
>  2 files changed, 204 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 4525b03d59c1..5082b01d2b96 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -53,6 +53,10 @@ static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
>  	return n->ops->complete(n);
>  }
>  
> +static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *sd,
> +				   struct v4l2_async_subdev *asd);
> +
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
>  #if IS_ENABLED(CONFIG_I2C)
> @@ -124,14 +128,128 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  	return NULL;
>  }
>  
> +/* Find the sub-device notifier registered by a sub-device driver. */
> +static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
> +	struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier_list, list)
> +		if (n->sd == sd)
> +			return n;
> +
> +	return NULL;
> +}
> +
> +/* Return true if all sub-device notifiers are complete, false otherwise. */
> +static bool v4l2_async_subdev_notifiers_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd;
> +
> +	if (!list_empty(&notifier->waiting))
> +		return false;
> +
> +	list_for_each_entry(sd, &notifier->done, async_list) {
> +		struct v4l2_async_notifier *subdev_notifier =
> +			v4l2_async_find_subdev_notifier(sd);
> +
> +		if (!subdev_notifier)
> +			continue;
> +
> +		if (!v4l2_async_subdev_notifiers_complete(subdev_notifier))

I think it is better to change this to:

		if (subdev_notifier &&
		    !v4l2_async_subdev_notifiers_complete(subdev_notifier))

and drop this if..continue above. That's a bit overkill in this simple case.

It's up to you, though.

> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/* Get v4l2_device related to the notifier if one can be found. */
> +static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	while (notifier->parent)
> +		notifier = notifier->parent;
> +
> +	return notifier->v4l2_dev;
> +}
> +
> +/* Test all async sub-devices in a notifier for a match. */
> +static int v4l2_async_notifier_try_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd;
> +
> +	if (!v4l2_async_notifier_find_v4l2_dev(notifier))
> +		return 0;
> +
> +again:
> +	list_for_each_entry(sd, &subdev_list, async_list) {
> +		struct v4l2_async_subdev *asd;
> +		int ret;
> +
> +		asd = v4l2_async_find_match(notifier, sd);
> +		if (!asd)
> +			continue;
> +
> +		ret = v4l2_async_match_notify(notifier, sd, asd);
> +		if (ret < 0)
> +			return ret;
> +
> +		/*
> +		 * v4l2_async_match_notify() may lead to registering a
> +		 * new notifier and thus changing the async subdevs
> +		 * list. In order to proceed safely from here, restart
> +		 * parsing the list from the beginning.
> +		 */
> +		goto again;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Try completing a notifier. */
> +static int v4l2_async_notifier_try_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	do {
> +		int ret;
> +
> +		/* Any local async sub-devices left? */
> +		if (!list_empty(&notifier->waiting))
> +			return 0;
> +
> +		/*
> +		 * Any sub-device notifiers waiting for async subdevs
> +		 * to be bound?
> +		 */
> +		if (!v4l2_async_subdev_notifiers_complete(notifier))
> +			return 0;
> +
> +		/* Proceed completing the notifier */
> +		ret = v4l2_async_notifier_call_complete(notifier);
> +		if (ret < 0)
> +			return ret;
> +
> +		/*
> +		 * Obtain notifier's parent. If there is one, repeat
> +		 * the process, otherwise we're done here.
> +		 */
> +	} while ((notifier = notifier->parent));

I'd change this to:

		notifier = notifier->parent;
	} while (notifier);

Assignment in a condition is frowned upon, and there is no need to do that
here.

> +
> +	return 0;
> +}
> +
>  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	int ret;
>  
> -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> -	if (ret < 0)
> +	ret = v4l2_device_register_subdev(
> +		v4l2_async_notifier_find_v4l2_dev(notifier), sd);
> +	if (ret)
>  		return ret;
>  
>  	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> @@ -148,10 +266,20 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
>  
> -	if (list_empty(&notifier->waiting))
> -		return v4l2_async_notifier_call_complete(notifier);
> +	/*
> +	 * See if the sub-device has a notifier. If it does, proceed
> +	 * with checking for its async sub-devices.
> +	 */
> +	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> +	if (subdev_notifier && !subdev_notifier->parent) {
> +		subdev_notifier->parent = notifier;
> +		ret = v4l2_async_notifier_try_all_subdevs(subdev_notifier);
> +		if (ret)
> +			return ret;
> +	}
>  
> -	return 0;
> +	/* Try completing the notifier and its parent(s). */
> +	return v4l2_async_notifier_try_complete(notifier);
>  }
>  
>  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> @@ -163,17 +291,15 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
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
> -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
>  
> -	notifier->v4l2_dev = v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
>  
> @@ -200,18 +326,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	mutex_lock(&list_lock);
>  
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
> -		asd = v4l2_async_find_match(notifier, sd);
> -		if (!asd)
> -			continue;
> -
> -		ret = v4l2_async_match_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> +	if (ret) {
> +		mutex_unlock(&list_lock);
> +		return ret;
>  	}
>  
>  	/* Keep also completed notifiers on the list */
> @@ -221,29 +339,70 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	return 0;
>  }
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	if (WARN_ON(!v4l2_dev || notifier->sd))
> +		return -EINVAL;
> +
> +	notifier->v4l2_dev = v4l2_dev;
> +
> +	return __v4l2_async_notifier_register(notifier);
> +}
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
> +	if (WARN_ON(!sd || notifier->v4l2_dev))
> +		return -EINVAL;
>  
> -	if (!notifier->v4l2_dev)
> -		return;
> +	notifier->sd = sd;
>  
> -	mutex_lock(&list_lock);
> +	return __v4l2_async_notifier_register(notifier);
> +}
> +EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
>  
> -	list_del(&notifier->list);
> +/* Unbind all sub-devices in the notifier tree. */
> +static void v4l2_async_notifier_unbind_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		struct v4l2_async_notifier *subdev_notifier =
> +			v4l2_async_find_subdev_notifier(sd);
> +
> +		if (subdev_notifier)
> +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> +
>  		v4l2_async_cleanup(sd);
>  
>  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> -	}
>  
> -	mutex_unlock(&list_lock);
> +		list_del(&sd->async_list);
> +		list_add(&sd->async_list, &subdev_list);
> +	}
>  
> +	notifier->parent = NULL;
> +	notifier->sd = NULL;
>  	notifier->v4l2_dev = NULL;
>  }
> +
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	if (!notifier->v4l2_dev && !notifier->sd)
> +		return;
> +
> +	mutex_lock(&list_lock);
> +
> +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> +
> +	list_del(&notifier->list);
> +
> +	mutex_unlock(&list_lock);
> +}
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  
>  void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 3bc8a7c0d83f..a13803a6371d 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -102,7 +102,9 @@ struct v4l2_async_notifier_operations {
>   * @num_subdevs: number of subdevices used in the subdevs array
>   * @max_subdevs: number of subdevices allocated in the subdevs array
>   * @subdevs:	array of pointers to subdevice descriptors
> - * @v4l2_dev:	pointer to struct v4l2_device
> + * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
> + * @sd:		sub-device that registered the notifier, NULL otherwise
> + * @parent:	parent notifier
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> @@ -113,6 +115,8 @@ struct v4l2_async_notifier {
>  	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	struct v4l2_async_notifier *parent;
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> @@ -128,6 +132,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
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
