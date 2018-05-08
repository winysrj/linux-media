Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:18680 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754366AbeEHKMl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 06:12:41 -0400
Date: Tue, 8 May 2018 13:12:35 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 03/13] media: v4l2: async: Add
 v4l2_async_notifier_add_subdev
Message-ID: <20180508101235.wctorewkzt3jgxnh@kekkonen.localdomain>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-4-git-send-email-steve_longerbeam@mentor.com>
 <20180420122450.j3wkyoardgpyzbh2@paasikivi.fi.intel.com>
 <854dab64-caf7-be8e-e5b6-10ff78aa811a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <854dab64-caf7-be8e-e5b6-10ff78aa811a@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 10:12:33AM -0700, Steve Longerbeam wrote:
> Hi Sakari,
> 
> 
> On 04/20/2018 05:24 AM, Sakari Ailus wrote:
> > Hi Steve,
> > 
> > Thanks for the patchset.
> > 
> > On Tue, Mar 20, 2018 at 05:37:19PM -0700, Steve Longerbeam wrote:
> > > v4l2_async_notifier_add_subdev() adds an asd to the notifier. It checks
> > > that the asd's match_type is valid and that no other equivalent asd's
> > > have already been added to this notifier's asd list, or to other
> > > registered notifier's waiting or done lists, and increments num_subdevs.
> > > 
> > > v4l2_async_notifier_add_subdev() does not make use of the notifier subdevs
> > > array, otherwise it would have to re-allocate the array every time the
> > > function was called. In place of the subdevs array, the function adds
> > > the asd to a new master asd_list. The function will return error with a
> > > WARN() if it is ever called with the subdevs array allocated.
> > > 
> > > In v4l2_async_notifier_has_async_subdev(), __v4l2_async_notifier_register(),
> > > and v4l2_async_notifier_cleanup(), alternatively operate on the subdevs
> > > array or a non-empty notifier->asd_list.
> > I do agree with the approach, but this patch leaves the remaining users of
> > the subdevs array in the notifier intact. Could you rework them to use the
> > v4l2_async_notifier_add_subdev() as well?
> > 
> > There seem to be just a few of them --- exynos4-is and rcar_drif.
> 
> I count more than a few :)
> 
> % cd drivers/media && grep -l -r --include "*.[ch]"
> 'notifier[\.\-]>*subdevs[   ]*='
> v4l2-core/v4l2-async.c
> platform/pxa_camera.c
> platform/ti-vpe/cal.c
> platform/exynos4-is/media-dev.c
> platform/qcom/camss-8x16/camss.c
> platform/soc_camera/soc_camera.c
> platform/atmel/atmel-isi.c
> platform/atmel/atmel-isc.c
> platform/stm32/stm32-dcmi.c
> platform/davinci/vpif_capture.c
> platform/davinci/vpif_display.c
> platform/renesas-ceu.c
> platform/am437x/am437x-vpfe.c
> platform/xilinx/xilinx-vipp.c
> platform/rcar_drif.c
> 
> 
> So not including v4l2-core, the list is:
> 
> pxa_camera
> ti-vpe
> exynos4-is
> qcom
> soc_camera
> atmel
> stm32
> davinci
> renesas-ceu
> am437x
> xilinx
> rcar_drif
> 
> 
> Given such a large list of the users of the notifier->subdevs array,
> I think this should be done is two steps: submit this patchset first,
> that keeps the backward compatibility, and then a subsequent patchset
> that converts all drivers to use v4l2_async_notifier_add_subdev(), at
> which point the subdevs array can be removed from struct
> v4l2_async_notifier.
> 
> Or, do you still think this should be done all at once? I could add a
> large patch to this patchset that does the conversion and removes
> the subdevs array.

Sorry for the delay. I grepped for this, too, but I guess I ended up using
an expression that missed most of the users. :-(

I think it'd be very good to perform that conversion --- the code in the
framework would be quite a bit cleaner and easier to maintain whereas the
per-driver conversions seem pretty simple, such as this on in
drivers/media/platform/atmel/atmel-isi.c :

	/* Register the subdevices notifier. */
	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
	if (!subdevs) {
	        of_node_put(isi->entity.node);
		return -ENOMEM;
	}

	subdevs[0] = &isi->entity.asd;

	isi->notifier.subdevs = subdevs;
	isi->notifier.num_subdevs = 1;
	isi->notifier.ops = &isi_graph_notify_ops;

> 
> Steve
> 
> 
> > 
> > > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > > ---
> > > Changes since v2:
> > > - add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
> > > Changes since v1:
> > > - none
> > > ---
> > >   drivers/media/v4l2-core/v4l2-async.c | 206 +++++++++++++++++++++++++++--------
> > >   include/media/v4l2-async.h           |  22 ++++
> > >   2 files changed, 184 insertions(+), 44 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > > index b59bbac..7b7f7e2 100644
> > > --- a/drivers/media/v4l2-core/v4l2-async.c
> > > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > > @@ -366,16 +366,26 @@ static bool v4l2_async_notifier_has_async_subdev(
> > >   	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
> > >   	unsigned int this_index)
> > >   {
> > > +	struct v4l2_async_subdev *asd_y;
> > >   	unsigned int j;
> > >   	lockdep_assert_held(&list_lock);
> > >   	/* Check that an asd is not being added more than once. */
> > > -	for (j = 0; j < this_index; j++) {
> > > -		struct v4l2_async_subdev *asd_y = notifier->subdevs[j];
> > > -
> > > -		if (asd_equal(asd, asd_y))
> > > -			return true;
> > > +	if (notifier->subdevs) {
> > > +		for (j = 0; j < this_index; j++) {
> > > +			asd_y = notifier->subdevs[j];
> > > +			if (asd_equal(asd, asd_y))
> > > +				return true;
> > > +		}
> > > +	} else {
> > > +		j = 0;
> > > +		list_for_each_entry(asd_y, &notifier->asd_list, asd_list) {
> > > +			if (j++ >= this_index)
> > > +				break;
> > > +			if (asd_equal(asd, asd_y))
> > > +				return true;
> > > +		}
> > >   	}
> > >   	/* Check that an asd does not exist in other notifiers. */
> > > @@ -386,10 +396,46 @@ static bool v4l2_async_notifier_has_async_subdev(
> > >   	return false;
> > >   }
> > > -static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> > > +static int v4l2_async_notifier_asd_valid(struct v4l2_async_notifier *notifier,
> > > +					 struct v4l2_async_subdev *asd,
> > > +					 unsigned int this_index)
> > >   {
> > >   	struct device *dev =
> > >   		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
> > > +
> > > +	if (!asd)
> > > +		return -EINVAL;
> > > +
> > > +	switch (asd->match_type) {
> > > +	case V4L2_ASYNC_MATCH_CUSTOM:
> > > +	case V4L2_ASYNC_MATCH_DEVNAME:
> > > +	case V4L2_ASYNC_MATCH_I2C:
> > > +	case V4L2_ASYNC_MATCH_FWNODE:
> > > +		if (v4l2_async_notifier_has_async_subdev(notifier, asd,
> > > +							 this_index))
> > > +			return -EEXIST;
> > > +		break;
> > > +	default:
> > > +		dev_err(dev, "Invalid match type %u on %p\n",
> > > +			asd->match_type, asd);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void __v4l2_async_notifier_init(struct v4l2_async_notifier *notifier)
> > > +{
> > > +	lockdep_assert_held(&list_lock);
> > > +
> > > +	INIT_LIST_HEAD(&notifier->asd_list);
> > > +	INIT_LIST_HEAD(&notifier->waiting);
> > > +	INIT_LIST_HEAD(&notifier->done);
> > > +	notifier->lists_initialized = true;
> > > +}
> > > +
> > > +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> > > +{
> > >   	struct v4l2_async_subdev *asd;
> > >   	int ret;
> > >   	int i;
> > > @@ -397,34 +443,40 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> > >   	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > >   		return -EINVAL;
> > > -	INIT_LIST_HEAD(&notifier->waiting);
> > > -	INIT_LIST_HEAD(&notifier->done);
> > > -
> > >   	mutex_lock(&list_lock);
> > > -	for (i = 0; i < notifier->num_subdevs; i++) {
> > > -		asd = notifier->subdevs[i];
> > > +	if (!notifier->lists_initialized)
> > > +		__v4l2_async_notifier_init(notifier);
> > > -		switch (asd->match_type) {
> > > -		case V4L2_ASYNC_MATCH_CUSTOM:
> > > -		case V4L2_ASYNC_MATCH_DEVNAME:
> > > -		case V4L2_ASYNC_MATCH_I2C:
> > > -		case V4L2_ASYNC_MATCH_FWNODE:
> > > -			if (v4l2_async_notifier_has_async_subdev(
> > > -				    notifier, asd, i)) {
> > > -				dev_err(dev,
> > > -					"asd has already been registered or in notifier's subdev list\n");
> > > -				ret = -EEXIST;
> > > -				goto err_unlock;
> > > -			}
> > > -			break;
> > > -		default:
> > > -			dev_err(dev, "Invalid match type %u on %p\n",
> > > -				asd->match_type, asd);
> > > +	if (!list_empty(&notifier->asd_list)) {
> > > +		/*
> > > +		 * Caller must have either used v4l2_async_notifier_add_subdev
> > > +		 * to add asd's to notifier->asd_list, or provided the
> > > +		 * notifier->subdevs array, but not both.
> > > +		 */
> > > +		if (WARN_ON(notifier->subdevs)) {
> > >   			ret = -EINVAL;
> > >   			goto err_unlock;
> > >   		}
> > > -		list_add_tail(&asd->list, &notifier->waiting);
> > > +
> > > +		i = 0;
> > > +		list_for_each_entry(asd, &notifier->asd_list, asd_list) {
> > > +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);
> > > +			if (ret)
> > > +				goto err_unlock;
> > > +
> > > +			list_add_tail(&asd->list, &notifier->waiting);
> > > +		}
> > > +	} else if (notifier->subdevs) {
> > > +		for (i = 0; i < notifier->num_subdevs; i++) {
> > > +			asd = notifier->subdevs[i];
> > > +
> > > +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i);
> > > +			if (ret)
> > > +				goto err_unlock;
> > > +
> > > +			list_add_tail(&asd->list, &notifier->waiting);
> > > +		}
> > >   	}
> > >   	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> > > @@ -514,36 +566,102 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > >   }
> > >   EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> > > -void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> > > +static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> > >   {
> > > +	struct v4l2_async_subdev *asd, *tmp;
> > >   	unsigned int i;
> > > -	if (!notifier || !notifier->max_subdevs)
> > > +	if (!notifier)
> > >   		return;
> > > -	for (i = 0; i < notifier->num_subdevs; i++) {
> > > -		struct v4l2_async_subdev *asd = notifier->subdevs[i];
> > > +	if (notifier->subdevs) {
> > > +		if (!notifier->max_subdevs)
> > > +			return;
> > > -		switch (asd->match_type) {
> > > -		case V4L2_ASYNC_MATCH_FWNODE:
> > > -			fwnode_handle_put(asd->match.fwnode);
> > > -			break;
> > > -		default:
> > > -			WARN_ON_ONCE(true);
> > > -			break;
> > > +		for (i = 0; i < notifier->num_subdevs; i++) {
> > > +			asd = notifier->subdevs[i];
> > > +
> > > +			switch (asd->match_type) {
> > > +			case V4L2_ASYNC_MATCH_FWNODE:
> > > +				fwnode_handle_put(asd->match.fwnode);
> > > +				break;
> > > +			default:
> > > +				break;
> > > +			}
> > > +
> > > +			kfree(asd);
> > >   		}
> > > -		kfree(asd);
> > > +		notifier->max_subdevs = 0;
> > > +		kvfree(notifier->subdevs);
> > > +		notifier->subdevs = NULL;
> > > +	} else if (notifier->lists_initialized) {
> > > +		list_for_each_entry_safe(asd, tmp,
> > > +					 &notifier->asd_list, asd_list) {
> > > +			switch (asd->match_type) {
> > > +			case V4L2_ASYNC_MATCH_FWNODE:
> > > +				fwnode_handle_put(asd->match.fwnode);
> > > +				break;
> > > +			default:
> > > +				break;
> > > +			}
> > > +
> > > +			list_del(&asd->asd_list);
> > > +			kfree(asd);
> > > +		}
> > >   	}
> > > -	notifier->max_subdevs = 0;
> > >   	notifier->num_subdevs = 0;
> > > +}
> > > -	kvfree(notifier->subdevs);
> > > -	notifier->subdevs = NULL;
> > > +void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> > > +{
> > > +	mutex_lock(&list_lock);
> > > +
> > > +	__v4l2_async_notifier_cleanup(notifier);
> > > +
> > > +	mutex_unlock(&list_lock);
> > >   }
> > >   EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
> > > +int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
> > > +				   struct v4l2_async_subdev *asd)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&list_lock);
> > > +
> > > +	if (notifier->num_subdevs >= V4L2_MAX_SUBDEVS) {
> > > +		ret = -EINVAL;
> > > +		goto unlock;
> > > +	}
> > > +
> > > +	if (!notifier->lists_initialized)
> > > +		__v4l2_async_notifier_init(notifier);
> > > +
> > > +	/*
> > > +	 * If caller uses this function, it cannot also allocate and
> > > +	 * place asd's in the notifier->subdevs array.
> > > +	 */
> > > +	if (WARN_ON(notifier->subdevs)) {
> > > +		ret = -EINVAL;
> > > +		goto unlock;
> > > +	}
> > > +
> > > +	ret = v4l2_async_notifier_asd_valid(notifier, asd,
> > > +					    notifier->num_subdevs);
> > > +	if (ret)
> > > +		goto unlock;
> > > +
> > > +	list_add_tail(&asd->asd_list, &notifier->asd_list);
> > > +	notifier->num_subdevs++;
> > > +
> > > +unlock:
> > > +	mutex_unlock(&list_lock);
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_subdev);
> > > +
> > >   int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> > >   {
> > >   	struct v4l2_async_notifier *subdev_notifier;
> > > @@ -617,7 +735,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
> > >   	mutex_lock(&list_lock);
> > >   	__v4l2_async_notifier_unregister(sd->subdev_notifier);
> > > -	v4l2_async_notifier_cleanup(sd->subdev_notifier);
> > > +	__v4l2_async_notifier_cleanup(sd->subdev_notifier);
> > >   	kfree(sd->subdev_notifier);
> > >   	sd->subdev_notifier = NULL;
> > > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > > index 1592d32..fa05905 100644
> > > --- a/include/media/v4l2-async.h
> > > +++ b/include/media/v4l2-async.h
> > > @@ -73,6 +73,8 @@ enum v4l2_async_match_type {
> > >    * @match.custom.priv:
> > >    *		Driver-specific private struct with match parameters
> > >    *		to be used if %V4L2_ASYNC_MATCH_CUSTOM.
> > > + * @asd_list:	used to add struct v4l2_async_subdev objects to the
> > > + *		master notifier->asd_list
> > >    * @list:	used to link struct v4l2_async_subdev objects, waiting to be
> > >    *		probed, to a notifier->waiting list
> > >    *
> > > @@ -98,6 +100,7 @@ struct v4l2_async_subdev {
> > >   	/* v4l2-async core private: not to be used by drivers */
> > >   	struct list_head list;
> > > +	struct list_head asd_list;
> > >   };
> > >   /**
> > > @@ -127,9 +130,11 @@ struct v4l2_async_notifier_operations {
> > >    * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
> > >    * @sd:		sub-device that registered the notifier, NULL otherwise
> > >    * @parent:	parent notifier
> > > + * @asd_list:	master list of struct v4l2_async_subdev, replaces @subdevs
> > >    * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> > >    * @done:	list of struct v4l2_subdev, already probed
> > >    * @list:	member in a global list of notifiers
> > > + * @lists_initialized: list_head's have been initialized
> > >    */
> > >   struct v4l2_async_notifier {
> > >   	const struct v4l2_async_notifier_operations *ops;
> > > @@ -139,12 +144,29 @@ struct v4l2_async_notifier {
> > >   	struct v4l2_device *v4l2_dev;
> > >   	struct v4l2_subdev *sd;
> > >   	struct v4l2_async_notifier *parent;
> > > +	struct list_head asd_list;
> > >   	struct list_head waiting;
> > >   	struct list_head done;
> > >   	struct list_head list;
> > > +	bool lists_initialized;
> > >   };
> > >   /**
> > > + * v4l2_async_notifier_add_subdev - Add an async subdev to the
> > > + *				notifier's master asd_list.
> > > + *
> > > + * @notifier: pointer to &struct v4l2_async_notifier
> > > + * @asd: pointer to &struct v4l2_async_subdev
> > > + *
> > > + * This can be used before registering a notifier to add an
> > > + * asd to the notifiers master asd_list. If the caller uses
> > > + * this method to compose an asd list, it must never allocate
> > > + * or place asd's in the @subdevs array.
> > > + */
> > > +int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
> > > +				   struct v4l2_async_subdev *asd);
> > > +
> > > +/**
> > >    * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
> > >    *
> > >    * @v4l2_dev: pointer to &struct v4l2_device
> > > -- 
> > > 2.7.4
> > > 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
