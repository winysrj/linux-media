Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35046 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750862AbdISPRf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 11:17:35 -0400
Date: Tue, 19 Sep 2017 18:17:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 14/25] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20170919151732.4yafxfcxrreizd7r@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-15-sakari.ailus@linux.intel.com>
 <3338675.o4HGi8X83V@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3338675.o4HGi8X83V@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 04:52:29PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:13 EEST Sakari Ailus wrote:
> > Registering a notifier has required the knowledge of struct v4l2_device
> > for the reason that sub-devices generally are registered to the
> > v4l2_device (as well as the media device, also available through
> > v4l2_device).
> > 
> > This information is not available for sub-device drivers at probe time.
> > 
> > What this patch does is that it allows registering notifiers without
> > having v4l2_device around. Instead the sub-device pointer is stored in the
> > notifier. Once the sub-device of the driver that registered the notifier
> > is registered, the notifier will gain the knowledge of the v4l2_device,
> > and the binding of async sub-devices from the sub-device driver's notifier
> > may proceed.
> > 
> > The root notifier's complete callback is only called when all sub-device
> > notifiers are completed.
> 
> This is a bit hard to review, shouldn't it be split in two patches, one that 
> refactors the functions, and another one that allows binding notifiers to 
> subdevs ?
> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 218 +++++++++++++++++++++++++++-----
> >  include/media/v4l2-async.h           |  16 ++-
> >  2 files changed, 203 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 4be2f16af051..52fe22b9b6b4
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -53,6 +53,10 @@ static int v4l2_async_notifier_call_complete(struct
> > v4l2_async_notifier *n) return n->ops->complete(n);
> >  }
> > 
> > +static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> > +				   struct v4l2_subdev *sd,
> > +				   struct v4l2_async_subdev *asd);
> 
> Forward declarations are often a sign that something is wrong :-/ If you 
> really need to keep this I'd move it right before the function that needs it.

"Something being wrong" here is that we have a data structure (the graph)
and a portion of the graph is parsed at any given point of time; there is
no central location with the knowledge of each node in the graph. Therefore
the process is recursive: you only learn of new nodes to parse when you
have parsed something.

I can move the declaration closer to where it's used.

> 
> >  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev
> > *asd) {
> >  #if IS_ENABLED(CONFIG_I2C)
> > @@ -124,14 +128,127 @@ static struct v4l2_async_subdev
> > *v4l2_async_find_match( return NULL;
> >  }
> > 
> > +/* Find the sub-device notifier registered by a sub-device driver. */
> > +static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
> > +	struct v4l2_subdev *sd)
> > +{
> > +	struct v4l2_async_notifier *n;
> > +
> > +	list_for_each_entry(n, &notifier_list, list)
> > +		if (n->sd == sd)
> > +			return n;
> > +
> > +	return NULL;
> > +}
> > +
> > +/* Return true if all sub-device notifiers are complete, false otherwise.
> > */ 
> > +static bool v4l2_async_subdev_notifiers_complete(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd;
> > +
> > +	if (!list_empty(&notifier->waiting))
> > +		return false;
> > +
> > +	list_for_each_entry(sd, &notifier->done, async_list) {
> > +		struct v4l2_async_notifier *subdev_notifier =
> > +			v4l2_async_find_subdev_notifier(sd);
> > +
> > +		if (subdev_notifier &&
> > +		    !v4l2_async_subdev_notifiers_complete(subdev_notifier))
> > +			return false;
> 
> This will loop forever if two subdevs add each other to their respective 
> notifiers. We might not have any use case for that right now, but it's bound 
> to happen, at least as a bug during development, and an infinite loop (with an 
> additional stack overflow bonus) isn't very nice to debug.

Well, yes. If you have a driver bug then this is what could happen.

One option is to check whether an fwnode has already been associated with
an async subdev and fail if it is. I was originally thinking of adding that
but then ended up postponing that for later. I can add that to v14.

> 
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +/* Get v4l2_device related to the notifier if one can be found. */
> > +static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	while (notifier->parent)
> > +		notifier = notifier->parent;
> > +
> > +	return notifier->v4l2_dev;
> > +}
> > +
> > +/* Test all async sub-devices in a notifier for a match. */
> > +static int v4l2_async_notifier_try_all_subdevs(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd;
> > +
> > +	if (!v4l2_async_notifier_find_v4l2_dev(notifier))
> > +		return 0;
> > +
> > +again:
> > +	list_for_each_entry(sd, &subdev_list, async_list) {
> > +		struct v4l2_async_subdev *asd;
> > +		int ret;
> > +
> > +		asd = v4l2_async_find_match(notifier, sd);
> > +		if (!asd)
> > +			continue;
> > +
> > +		ret = v4l2_async_match_notify(notifier, sd, asd);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/*
> > +		 * v4l2_async_match_notify() may lead to registering a
> > +		 * new notifier and thus changing the async subdevs
> > +		 * list. In order to proceed safely from here, restart
> > +		 * parsing the list from the beginning.
> > +		 */
> > +		goto again;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Try completing a notifier. */
> > +static int v4l2_async_notifier_try_complete(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	do {
> > +		int ret;
> > +
> > +		/* Any local async sub-devices left? */
> > +		if (!list_empty(&notifier->waiting))
> > +			return 0;
> > +
> > +		/*
> > +		 * Any sub-device notifiers waiting for async subdevs
> > +		 * to be bound?
> > +		 */
> > +		if (!v4l2_async_subdev_notifiers_complete(notifier))
> > +			return 0;
> > +
> > +		/* Proceed completing the notifier */
> > +		ret = v4l2_async_notifier_call_complete(notifier);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/*
> > +		 * Obtain notifier's parent. If there is one, repeat
> > +		 * the process, otherwise we're done here.
> > +		 */
> > +		notifier = notifier->parent;
> > +	} while (notifier);
> > +
> > +	return 0;
> > +}
> > +
> >  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> >  				   struct v4l2_subdev *sd,
> >  				   struct v4l2_async_subdev *asd)
> >  {
> > +	struct v4l2_async_notifier *subdev_notifier;
> >  	int ret;
> > 
> > -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> > -	if (ret < 0)
> > +	ret = v4l2_device_register_subdev(
> > +		v4l2_async_notifier_find_v4l2_dev(notifier), sd);
> > +	if (ret)
> >  		return ret;
> > 
> >  	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> > @@ -148,10 +265,20 @@ static int v4l2_async_match_notify(struct
> > v4l2_async_notifier *notifier, /* Move from the global subdevice list to
> > notifier's done */
> >  	list_move(&sd->async_list, &notifier->done);
> > 
> > -	if (list_empty(&notifier->waiting))
> > -		return v4l2_async_notifier_call_complete(notifier);
> > +	/*
> > +	 * See if the sub-device has a notifier. If it does, proceed
> > +	 * with checking for its async sub-devices.
> > +	 */
> > +	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
> > +	if (subdev_notifier && !subdev_notifier->parent) {
> > +		subdev_notifier->parent = notifier;
> > +		ret = v4l2_async_notifier_try_all_subdevs(subdev_notifier);
> > +		if (ret)
> > +			return ret;
> > +	}
> > 
> > -	return 0;
> > +	/* Try completing the notifier and its parent(s). */
> > +	return v4l2_async_notifier_try_complete(notifier);
> >  }
> > 
> >  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> > @@ -163,17 +290,15 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> > sd->dev = NULL;
> >  }
> > 
> > -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > -				 struct v4l2_async_notifier *notifier)
> > +static int __v4l2_async_notifier_register(struct v4l2_async_notifier
> > *notifier) {
> > -	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> > +	int ret;
> >  	int i;
> > 
> > -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> >  		return -EINVAL;
> > 
> > -	notifier->v4l2_dev = v4l2_dev;
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> > 
> > @@ -200,18 +325,10 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev,
> > 
> >  	mutex_lock(&list_lock);
> > 
> > -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > -		int ret;
> > -
> > -		asd = v4l2_async_find_match(notifier, sd);
> > -		if (!asd)
> > -			continue;
> > -
> > -		ret = v4l2_async_match_notify(notifier, sd, asd);
> > -		if (ret < 0) {
> > -			mutex_unlock(&list_lock);
> > -			return ret;
> > -		}
> > +	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> > +	if (ret) {
> > +		mutex_unlock(&list_lock);
> > +		return ret;
> >  	}
> > 
> >  	/* Keep also completed notifiers on the list */
> > @@ -221,29 +338,70 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev,
> > 
> >  	return 0;
> >  }
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier)
> > +{
> > +	if (WARN_ON(!v4l2_dev || notifier->sd))
> > +		return -EINVAL;
> > +
> > +	notifier->v4l2_dev = v4l2_dev;
> > +
> > +	return __v4l2_async_notifier_register(notifier);
> > +}
> >  EXPORT_SYMBOL(v4l2_async_notifier_register);
> > 
> > -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> > +					struct v4l2_async_notifier *notifier)
> >  {
> > -	struct v4l2_subdev *sd, *tmp;
> > +	if (WARN_ON(!sd || notifier->v4l2_dev))
> > +		return -EINVAL;
> > 
> > -	if (!notifier->v4l2_dev)
> > -		return;
> > +	notifier->sd = sd;
> > 
> > -	mutex_lock(&list_lock);
> > +	return __v4l2_async_notifier_register(notifier);
> > +}
> > +EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
> > 
> > -	list_del(&notifier->list);
> > +/* Unbind all sub-devices in the notifier tree. */
> > +static void v4l2_async_notifier_unbind_all_subdevs(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd, *tmp;
> > 
> >  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> > +		struct v4l2_async_notifier *subdev_notifier =
> > +			v4l2_async_find_subdev_notifier(sd);
> > +
> > +		if (subdev_notifier)
> > +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> > +
> >  		v4l2_async_cleanup(sd);
> > 
> >  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> > -	}
> > 
> > -	mutex_unlock(&list_lock);
> > +		list_del(&sd->async_list);
> > +		list_add(&sd->async_list, &subdev_list);
> 
> How about list_move() ?

Yeah.

> 
> This seems to be new code, and by the look of it, I wonder whether it doesn't 
> belong in the reprobing removal patch.

This is not related to re-probing. Here we're moving an async sub-device
back to the global sub-device list when its notifier is going away.

> 
> > +	}
> > 
> > +	notifier->parent = NULL;
> > +	notifier->sd = NULL;
> >  	notifier->v4l2_dev = NULL;
> >  }
> > +
> > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +{
> > +	if (!notifier->v4l2_dev && !notifier->sd)
> > +		return;
> > +
> > +	mutex_lock(&list_lock);
> > +
> > +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> > +
> > +	list_del(&notifier->list);
> > +
> > +	mutex_unlock(&list_lock);
> > +}
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> > 
> >  void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
