Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751005AbdIKJa2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:30:28 -0400
Date: Mon, 11 Sep 2017 12:30:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v10 14/24] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20170911093024.jmdsi3zrypj5hndc@valkosipuli.retiisi.org.uk>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-15-sakari.ailus@linux.intel.com>
 <19a5c075-92ca-050e-fc50-c78f02579df3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a5c075-92ca-050e-fc50-c78f02579df3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review!

On Mon, Sep 11, 2017 at 10:57:16AM +0200, Hans Verkuil wrote:
> On 09/11/2017 09:59 AM, Sakari Ailus wrote:
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
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 217 ++++++++++++++++++++++++++++++-----
> >  include/media/v4l2-async.h           |  16 ++-
> >  2 files changed, 202 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 9ebc2e079d03..6f788b2e922a 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -53,6 +53,10 @@ static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
> >  	return n->ops->complete(n);
> >  }
> >  
> > +static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> > +				   struct v4l2_subdev *sd,
> > +				   struct v4l2_async_subdev *asd);
> > +
> >  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> >  {
> >  #if IS_ENABLED(CONFIG_I2C)
> > @@ -124,14 +128,128 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
> >  	return NULL;
> >  }
> >  
> > +/* Get the sub-device notifier registered by a sub-device driver. */
> > +static struct v4l2_async_notifier *v4l2_async_get_subdev_notifier(
> 
> I prefer to call this v4l2_async_find_subdev_notifier(). 'get' suggests
> a getter function, but this actually has to find it. I think this may have
> confused me during an earlier review of this code. The comment also needs
> updating: "Find the sub-device...".

Yes, makes sense. Get also suggests that there would be reference counting
which is not the case here.

I made the corresponding change to v4l2_async_notifier_find_v4l2_dev() as
well.

> 
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
> > +/* Return true if all sub-device notifiers are complete, false otherwise. */
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
> > +			v4l2_async_get_subdev_notifier(sd);
> 
> Would it make sense to add a 'struct v4l2_async_notifier *subdev_notifier'
> field to struct v4l2_subdev? It's set when a subdev registers a notifier.
> 
> That way you can just use sd->subdev_notifier here.
> 
> I wonder if v4l2_async_get_subdev_notifier() is needed at all if you do
> this.

I thought of that, but ended up keeping the information in the notifier. As
the information is already available elsewhere, I didn't end up adding a
new field for the purpose. This is certainly not performance critical
either.

> 
> > +
> > +		if (!subdev_notifier)
> > +			continue;
> > +
> > +		if (!v4l2_async_subdev_notifiers_complete(subdev_notifier))
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +/* Get v4l2_device related to the notifier if one can be found. */
> > +static struct v4l2_device *v4l2_async_notifier_get_v4l2_dev(
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
> > +	if (!v4l2_async_notifier_get_v4l2_dev(notifier))
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
> > +	} while ((notifier = notifier->parent));
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
> > +		v4l2_async_notifier_get_v4l2_dev(notifier), sd);
> > +	if (ret)
> >  		return ret;
> >  
> >  	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> > @@ -148,10 +266,20 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> >  	/* Move from the global subdevice list to notifier's done */
> >  	list_move(&sd->async_list, &notifier->done);
> >  
> > -	if (list_empty(&notifier->waiting))
> > -		return v4l2_async_notifier_call_complete(notifier);
> > +	/*
> > +	 * See if the sub-device has a notifier. If it does, proceed
> > +	 * with checking for its async sub-devices.
> > +	 */
> > +	subdev_notifier = v4l2_async_get_subdev_notifier(sd);
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
> > @@ -163,20 +291,18 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> >  	sd->dev = NULL;
> >  }
> >  
> > -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > -				 struct v4l2_async_notifier *notifier)
> > +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  {
> > -	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> > +	int ret;
> >  	int i;
> >  
> > -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> >  		return -EINVAL;
> >  
> >  	if (!notifier->num_subdevs)
> >  		return v4l2_async_notifier_call_complete(notifier);
> >  
> > -	notifier->v4l2_dev = v4l2_dev;
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> >  
> > @@ -200,18 +326,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
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
> > @@ -221,28 +339,67 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  
> >  	return 0;
> >  }
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier)
> > +{
> > +	if (!v4l2_dev || notifier->sd)
> 
> Should this be a WARN_ON?

Added WARN_ON().

> 
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
> > +	if (!sd || notifier->v4l2_dev)
> 
> Ditto.

Indeed.

> 
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
> > +			v4l2_async_get_subdev_notifier(sd);
> > +
> > +		if (subdev_notifier)
> > +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> > +
> >  		v4l2_async_cleanup(sd);
> >  
> >  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> > +
> > +		list_del(&sd->async_list);
> > +		list_add(&sd->async_list, &subdev_list);
> >  	}
> >  
> > -	mutex_unlock(&list_lock);
> > +	notifier->parent = NULL;
> 
> Shouldn't notifier->v4l2_dev and notifier->sd be set to NULL as well?
> I can't really tell.

Well spotted. Yes. This was actually broken by the patch; v4l2_dev used to
be set NULL. Will fix.

> 
> > +}
> > +
> > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +{
> > +	if (!notifier->v4l2_dev && !notifier->sd)
> > +		return;
> >  
> > -	notifier->v4l2_dev = NULL;
> > +	mutex_lock(&list_lock);
> > +
> > +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> > +
> > +	list_del(&notifier->list);
> > +
> > +	mutex_unlock(&list_lock);
> >  }
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> >  
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index 3bc8a7c0d83f..cf409d45208c 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -102,7 +102,9 @@ struct v4l2_async_notifier_operations {
> >   * @num_subdevs: number of subdevices used in the subdevs array
> >   * @max_subdevs: number of subdevices allocated in the subdevs array
> >   * @subdevs:	array of pointers to subdevice descriptors
> > - * @v4l2_dev:	pointer to struct v4l2_device
> > + * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
> > + * @sd:		sub-device that registered the notifier, NULL otherwise
> > + * @parent:	parent notifier carrying @v4l2_dev
> 
> That's not correct, it only carries v4l2_dev if it is the root notifier.
> I think just 'parent notifier' is sufficient here.

Will change.

> 
> >   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> >   * @done:	list of struct v4l2_subdev, already probed
> >   * @list:	member in a global list of notifiers
> > @@ -113,6 +115,8 @@ struct v4l2_async_notifier {
> >  	unsigned int max_subdevs;
> >  	struct v4l2_async_subdev **subdevs;
> >  	struct v4l2_device *v4l2_dev;
> > +	struct v4l2_subdev *sd;
> > +	struct v4l2_async_notifier *parent;
> >  	struct list_head waiting;
> >  	struct list_head done;
> >  	struct list_head list;
> > @@ -128,6 +132,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  				 struct v4l2_async_notifier *notifier);
> >  
> >  /**
> > + * v4l2_async_subdev_notifier_register - registers a subdevice asynchronous
> > + *					 notifier for a sub-device
> > + *
> > + * @sd: pointer to &struct v4l2_subdev
> > + * @notifier: pointer to &struct v4l2_async_notifier
> > + */
> > +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> > +					struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
> >   *
> >   * @notifier: pointer to &struct v4l2_async_notifier
> > 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
