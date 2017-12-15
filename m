Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10951 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756692AbdLOPVO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 10:21:14 -0500
Date: Fri, 15 Dec 2017 17:20:40 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] v4l2: async: Postpone subdev_notifier registration
Message-ID: <20171215152040.nex4jjk7awk4ckg3@paasikivi.fi.intel.com>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
 <1513189580-32202-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513189580-32202-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Dec 13, 2017 at 07:26:19PM +0100, Jacopo Mondi wrote:
> Currently, subdevice notifiers are tested against all available
> subdevices as soon as they get registered. It often happens anyway
> that the subdevice they are connected to is not yet initialized, as
> it usually gets registered later in drivers' code. This makes debug
> of v4l2_async particularly painful, as identifying a notifier with
> an unitialized subdevice is tricky as they don't have a valid
> 'struct device *' or 'struct fwnode_handle *' to be identified with.
> 
> In order to make sure that the notifier's subdevices is initialized
> when the notifier is tesed against available subdevices post-pone the
> actual notifier registration at subdevice registration time.
> 
> It is worth noting that post-poning registration of a subdevice notifier
> does not impact on the completion of the notifiers chain, as even if a
> subdev notifier completes as soon as it gets registered, the complete()
> call chain cannot be upscaled as long as the subdevice the notifiers
> belongs to is not registered.

Let me rephrase to make sure I understand the problem correctly ---

A sub-device notifier is registered but the notifier's sub-device is not
registered yet, and finding a match for this notifier leads, to, well
problems. Is that the reason for this patch?

I think there could be simpler solutions to address this.

I wonder if we could simply check for sub-device notifier's v4l2_dev field,
and fail in matching if it's not set. v4l2_device_register_subdev() would
still need to proceed with calling v4l2_async_notifier_try_all_subdevs()
and v4l2_async_notifier_try_complete() if that was the case.

What do you think?

> 
> Also, it is now safe to access a notifier 'struct device *' as we're now
> sure it is properly initialized when the notifier is actually
> registered.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 65 +++++++++++++++++++++++-------------
>  include/media/v4l2-async.h           |  2 ++
>  2 files changed, 43 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 0a1bf1d..c13a781 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -25,6 +25,13 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
> 
> +static struct device *v4l2_async_notifier_dev(
> +					struct v4l2_async_notifier *notifier)
> +{
> +	return notifier->v4l2_dev ? notifier->v4l2_dev->dev :
> +				    notifier->sd->dev;
> +}
> +
>  static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier *n,
>  					  struct v4l2_subdev *subdev,
>  					  struct v4l2_async_subdev *asd)
> @@ -124,19 +131,6 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  	return NULL;
>  }
> 
> -/* Find the sub-device notifier registered by a sub-device driver. */
> -static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
> -	struct v4l2_subdev *sd)
> -{
> -	struct v4l2_async_notifier *n;
> -
> -	list_for_each_entry(n, &notifier_list, list)
> -		if (n->sd == sd)
> -			return n;
> -
> -	return NULL;
> -}
> -
>  /* Get v4l2_device related to the notifier if one can be found. */
>  static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
>  	struct v4l2_async_notifier *notifier)
> @@ -160,7 +154,7 @@ static bool v4l2_async_notifier_can_complete(
> 
>  	list_for_each_entry(sd, &notifier->done, async_list) {
>  		struct v4l2_async_notifier *subdev_notifier =
> -			v4l2_async_find_subdev_notifier(sd);
> +							sd->subdev_notifier;
> 
>  		if (subdev_notifier &&
>  		    !v4l2_async_notifier_can_complete(subdev_notifier))
> @@ -228,7 +222,7 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  	/*
>  	 * See if the sub-device has a notifier. If not, return here.
>  	 */
> -	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> +	subdev_notifier = sd->subdev_notifier;
>  	if (!subdev_notifier || subdev_notifier->parent)
>  		return 0;
> 
> @@ -294,7 +288,7 @@ static void v4l2_async_notifier_unbind_all_subdevs(
> 
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
>  		struct v4l2_async_notifier *subdev_notifier =
> -			v4l2_async_find_subdev_notifier(sd);
> +							sd->subdev_notifier;
> 
>  		if (subdev_notifier)
>  			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> @@ -371,8 +365,7 @@ static bool v4l2_async_notifier_fwnode_has_async_subdev(
> 
>  static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  {
> -	struct device *dev =
> -		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
> +	struct device *dev = v4l2_async_notifier_dev(notifier);
>  	struct v4l2_async_subdev *asd;
>  	int ret;
>  	int i;
> @@ -383,6 +376,8 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> 
> +	notifier->owner = dev_fwnode(dev);
> +
>  	mutex_lock(&list_lock);
> 
>  	for (i = 0; i < notifier->num_subdevs; i++) {
> @@ -421,6 +416,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> 
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
> +	notifier->registered = true;
> 
>  	mutex_unlock(&list_lock);
> 
> @@ -447,7 +443,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		return -EINVAL;
> 
>  	notifier->v4l2_dev = v4l2_dev;
> -	notifier->owner = dev_fwnode(v4l2_dev->dev);
> +	notifier->registered = false;
> 
>  	ret = __v4l2_async_notifier_register(notifier);
>  	if (ret)
> @@ -466,7 +462,11 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
>  		return -EINVAL;
> 
>  	notifier->sd = sd;
> -	notifier->owner = dev_fwnode(sd->dev);
> +	sd->subdev_notifier = notifier;
> +	notifier->registered = false;
> +
> +	if (!sd->dev || !sd->fwnode)
> +		return 0;
> 
>  	ret = __v4l2_async_notifier_register(notifier);
>  	if (ret)
> @@ -482,12 +482,15 @@ static void __v4l2_async_notifier_unregister(
>  	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
>  		return;
> 
> -	v4l2_async_notifier_unbind_all_subdevs(notifier);
> +	if (notifier->registered) {
> +		v4l2_async_notifier_unbind_all_subdevs(notifier);
> +		list_del(&notifier->list);
> +	}
> 
>  	notifier->sd = NULL;
>  	notifier->v4l2_dev = NULL;
> -
> -	list_del(&notifier->list);
> +	notifier->owner = NULL;
> +	notifier->registered = false;
>  }
> 
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> @@ -548,6 +551,20 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  			sd->fwnode = dev_fwnode(sd->dev);
>  	}
> 
> +	/*
> +	 * If the subdevice has an unregisterd notifier, it's now time
> +	 * to register it.
> +	 */
> +	subdev_notifier = sd->subdev_notifier;
> +	if (subdev_notifier && !subdev_notifier->registered) {
> +		ret = __v4l2_async_notifier_register(subdev_notifier);
> +		if (ret) {
> +			sd->fwnode = NULL;
> +			subdev_notifier->owner = NULL;
> +			return ret;
> +		}
> +	}
> +
>  	mutex_lock(&list_lock);
> 
>  	INIT_LIST_HEAD(&sd->async_list);
> @@ -589,7 +606,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	 * Complete failed. Unbind the sub-devices bound through registering
>  	 * this async sub-device.
>  	 */
> -	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> +	subdev_notifier = sd->subdev_notifier;
>  	if (subdev_notifier)
>  		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> 
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index a15c01d..6ab04ad 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -110,6 +110,7 @@ struct v4l2_async_notifier_operations {
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> + * @registered: notifier registered complete flag
>   */
>  struct v4l2_async_notifier {
>  	const struct v4l2_async_notifier_operations *ops;
> @@ -123,6 +124,7 @@ struct v4l2_async_notifier {
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> +	bool registered;
>  };
> 
>  /**
> --
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
