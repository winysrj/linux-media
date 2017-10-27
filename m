Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:55726 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdJ0Ioe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 04:44:34 -0400
Received: by mail-lf0-f67.google.com with SMTP id p184so6533562lfe.12
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 01:44:33 -0700 (PDT)
Date: Fri, 27 Oct 2017 10:44:31 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v16.1 18/32] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20171027084431.GN2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-19-sakari.ailus@linux.intel.com>
 <20171027082709.27725-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171027082709.27725-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-27 11:27:09 +0300, Sakari Ailus wrote:
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
> The complete callback of the root notifier will be called only when the
> v4l2_device is available and no notifier has pending sub-devices to bind.
> No complete callbacks are supported for sub-device notifiers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 212 ++++++++++++++++++++++++++++-------
>  include/media/v4l2-async.h           |  19 +++-
>  2 files changed, 189 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 6265717769d2..ed539c4fd5dc 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -124,11 +124,87 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
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
> +/*
> + * Return true if all child sub-device notifiers are complete, false otherwise.
> + */
> +static bool v4l2_async_notifier_can_complete(
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
> +		if (subdev_notifier &&
> +		    !v4l2_async_notifier_can_complete(subdev_notifier))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Complete the master notifier if possible. This is done when all async
> + * sub-devices have been bound; v4l2_device is also available then.
> + */
> +static int v4l2_async_notifier_try_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	/* Quick check whether there are still more sub-devices here. */
> +	if (!list_empty(&notifier->waiting))
> +		return 0;
> +
> +	/* Check the entire notifier tree; find the root notifier first. */
> +	while (notifier->parent)
> +		notifier = notifier->parent;
> +
> +	/* This is root if it has v4l2_dev. */
> +	if (!notifier->v4l2_dev)
> +		return 0;
> +
> +	/* Is everything ready? */
> +	if (!v4l2_async_notifier_can_complete(notifier))
> +		return 0;
> +
> +	return v4l2_async_notifier_call_complete(notifier);
> +}
> +
> +static int v4l2_async_notifier_try_all_subdevs(
> +	struct v4l2_async_notifier *notifier);
> +
>  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_device *v4l2_dev,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	int ret;
>  
>  	ret = v4l2_device_register_subdev(v4l2_dev, sd);
> @@ -149,17 +225,36 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
>  
> -	return 0;
> +	/*
> +	 * See if the sub-device has a notifier. If not, return here.
> +	 */
> +	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> +	if (!subdev_notifier || subdev_notifier->parent)
> +		return 0;
> +
> +	/*
> +	 * Proceed with checking for the sub-device notifier's async
> +	 * sub-devices, and return the result. The error will be handled by the
> +	 * caller.
> +	 */
> +	subdev_notifier->parent = notifier;
> +
> +	return v4l2_async_notifier_try_all_subdevs(subdev_notifier);
>  }
>  
>  /* Test all async sub-devices in a notifier for a match. */
>  static int v4l2_async_notifier_try_all_subdevs(
>  	struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> -	struct v4l2_subdev *sd, *tmp;
> +	struct v4l2_device *v4l2_dev =
> +		v4l2_async_notifier_find_v4l2_dev(notifier);
> +	struct v4l2_subdev *sd;
> +
> +	if (!v4l2_dev)
> +		return 0;
>  
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +again:
> +	list_for_each_entry(sd, &subdev_list, async_list) {
>  		struct v4l2_async_subdev *asd;
>  		int ret;
>  
> @@ -170,6 +265,14 @@ static int v4l2_async_notifier_try_all_subdevs(
>  		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
>  		if (ret < 0)
>  			return ret;
> +
> +		/*
> +		 * v4l2_async_match_notify() may lead to registering a
> +		 * new notifier and thus changing the async subdevs
> +		 * list. In order to proceed safely from here, restart
> +		 * parsing the list from the beginning.
> +		 */
> +		goto again;
>  	}
>  
>  	return 0;
> @@ -183,17 +286,26 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	sd->asd = NULL;
>  }
>  
> +/* Unbind all sub-devices in the notifier tree. */
>  static void v4l2_async_notifier_unbind_all_subdevs(
>  	struct v4l2_async_notifier *notifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		struct v4l2_async_notifier *subdev_notifier =
> +			v4l2_async_find_subdev_notifier(sd);
> +
> +		if (subdev_notifier)
> +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> +
>  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  		v4l2_async_cleanup(sd);
>  
>  		list_move(&sd->async_list, &subdev_list);
>  	}
> +
> +	notifier->parent = NULL;
>  }
>  
>  static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> @@ -208,15 +320,6 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
>  
> -	if (!notifier->num_subdevs) {
> -		int ret;
> -
> -		ret = v4l2_async_notifier_call_complete(notifier);
> -		notifier->v4l2_dev = NULL;
> -
> -		return ret;
> -	}
> -
>  	for (i = 0; i < notifier->num_subdevs; i++) {
>  		asd = notifier->subdevs[i];
>  
> @@ -238,16 +341,12 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  	mutex_lock(&list_lock);
>  
>  	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> -	if (ret) {
> -		mutex_unlock(&list_lock);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_unbind;
>  
> -	if (list_empty(&notifier->waiting)) {
> -		ret = v4l2_async_notifier_call_complete(notifier);
> -		if (ret)
> -			goto err_complete;
> -	}
> +	ret = v4l2_async_notifier_try_complete(notifier);
> +	if (ret)
> +		goto err_unbind;
>  
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
> @@ -256,7 +355,10 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  
>  	return 0;
>  
> -err_complete:
> +err_unbind:
> +	/*
> +	 * On failure, unbind all sub-devices registered through this notifier.
> +	 */
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
>  
>  	mutex_unlock(&list_lock);
> @@ -269,7 +371,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  {
>  	int ret;
>  
> -	if (WARN_ON(!v4l2_dev))
> +	if (WARN_ON(!v4l2_dev || notifier->sd))
>  		return -EINVAL;
>  
>  	notifier->v4l2_dev = v4l2_dev;
> @@ -282,20 +384,39 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!sd || notifier->v4l2_dev))
> +		return -EINVAL;
> +
> +	notifier->sd = sd;
> +
> +	ret = __v4l2_async_notifier_register(notifier);
> +	if (ret)
> +		notifier->sd = NULL;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
> +
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
> -	if (!notifier->v4l2_dev)
> +	if (!notifier->v4l2_dev && !notifier->sd)
>  		return;
>  
>  	mutex_lock(&list_lock);
>  
> -	list_del(&notifier->list);
> -
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
>  
> -	mutex_unlock(&list_lock);
> -
> +	notifier->sd = NULL;
>  	notifier->v4l2_dev = NULL;
> +
> +	list_del(&notifier->list);
> +
> +	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  
> @@ -331,6 +452,7 @@ EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
>  
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	struct v4l2_async_notifier *notifier;
>  	int ret;
>  
> @@ -347,24 +469,26 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	INIT_LIST_HEAD(&sd->async_list);
>  
>  	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
> -								      sd);
> +		struct v4l2_device *v4l2_dev =
> +			v4l2_async_notifier_find_v4l2_dev(notifier);
> +		struct v4l2_async_subdev *asd;
>  		int ret;
>  
> +		if (!v4l2_dev)
> +			continue;
> +
> +		asd = v4l2_async_find_match(notifier, sd);
>  		if (!asd)
>  			continue;
>  
>  		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
>  					      asd);
>  		if (ret)
> -			goto err_unlock;
> -
> -		if (!list_empty(&notifier->waiting))
> -			goto out_unlock;
> +			goto err_unbind;
>  
> -		ret = v4l2_async_notifier_call_complete(notifier);
> +		ret = v4l2_async_notifier_try_complete(notifier);
>  		if (ret)
> -			goto err_cleanup;
> +			goto err_unbind;
>  
>  		goto out_unlock;
>  	}
> @@ -377,11 +501,19 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  
>  	return 0;
>  
> -err_cleanup:
> -	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> +err_unbind:
> +	/*
> +	 * Complete failed. Unbind the sub-devices bound through registering
> +	 * this async sub-device.
> +	 */
> +	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> +	if (subdev_notifier)
> +		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> +
> +	if (sd->asd)
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	v4l2_async_cleanup(sd);
>  
> -err_unlock:
>  	mutex_unlock(&list_lock);
>  
>  	return ret;
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 68606afb5ef9..17c4ac7c73e8 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -82,7 +82,8 @@ struct v4l2_async_subdev {
>  /**
>   * struct v4l2_async_notifier_operations - Asynchronous V4L2 notifier operations
>   * @bound:	a subdevice driver has successfully probed one of the subdevices
> - * @complete:	all subdevices have been probed successfully
> + * @complete:	All subdevices have been probed successfully. The complete
> + *		callback is only executed for the root notifier.
>   * @unbind:	a subdevice is leaving
>   */
>  struct v4l2_async_notifier_operations {
> @@ -102,7 +103,9 @@ struct v4l2_async_notifier_operations {
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
> @@ -113,6 +116,8 @@ struct v4l2_async_notifier {
>  	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	struct v4l2_async_notifier *parent;
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> @@ -128,6 +133,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
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
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
