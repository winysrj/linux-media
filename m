Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40242 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750885AbdE2KZD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 06:25:03 -0400
Subject: Re: [PATCH v2 2/2] v4l: async: add subnotifier registration for
 subdevices
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20170524000727.12936-1-niklas.soderlund@ragnatech.se>
 <20170524000727.12936-3-niklas.soderlund@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a1d3dc61-e021-59f8-14df-ae2f64ea54be@xs4all.nl>
Date: Mon, 29 May 2017 12:24:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170524000727.12936-3-niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2017 02:07 AM, Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> When registered() of v4l2_subdev_internal_ops is called the subdevice

When the registered() callback of...

> have access to the master devices v4l2_dev and it's called with the

have access -> has access

(since it's just one subdevice)

> async frameworks list_lock held. In this context the subdevice can
> register its own notifiers to allow for incremental discovery of
> subdevices.
> 
> The master device registers the subdevices closest to itself in its
> notifier while the subdevice(s) themself register notifiers for there

themself -> themselves (or better, just drop it)
there -> their

> closest neighboring devices when they are registered. Using this
> incremental approach two problems can be solved.

solved. -> solved:

> 
> 1. The master device no longer have to care how many devices exist in

have -> has

>     the pipeline. It only needs to care about its closest subdevice and
>     arbitrary long pipelines can be created without having to adapt the
>     master device for each case.

Nice! :-)

> 
> 2. Subdevices which are represented as a single DT node but register
>     more then one subdevice can use this to further the pipeline

then -> than

'further the...': would 'improve the...' be better? It's not entirely clear
to me what you mean.

>     discovery. Since the subdevice driver is the only one who knows which

discovery. Since -> discovery, since

>     of its subdevices is linked with which subdevice of a neighboring DT
>     node.
> 
> To enable subdevices to register/unregister notifiers from the
> registered()/unregistered() callback v4l2_async_subnotifier_register()
> and v4l2_async_subnotifier_unregister() are added. These new notifier
> register functions are similar to the master device equivalent functions
> but run without taking the v4l2-async list_lock which already are held

are -> is

> when he registered()/unregistered() callbacks are called.

he -> the

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>   Documentation/media/kapi/v4l2-subdev.rst | 20 ++++++++
>   drivers/media/v4l2-core/v4l2-async.c     | 88 ++++++++++++++++++++++++++------
>   include/media/v4l2-async.h               | 22 ++++++++
>   3 files changed, 113 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> index e1f0b726e438f963..28ae681c63ff1330 100644
> --- a/Documentation/media/kapi/v4l2-subdev.rst
> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> @@ -262,6 +262,26 @@ is called. After all subdevices have been located the .complete() callback is
>   called. When a subdevice is removed from the system the .unbind() method is
>   called. All three callbacks are optional.
>   
> +Subdevice drivers might in turn register subnotifier objects with an
> +array of other subdevice descriptors that the subdevice needs for its
> +own operation. Subnotifiers are an extension of the bridge drivers
> +notifier to allow for a incremental registering and matching of
> +subdevices. This is useful when a driver only have information about

have -> has

> +which subdevice is closet it self and would require knowledge from the

closet -> closest
it self -> to itself

> +driver of that subdevice to know which other subdevice(s) lies beyond.

lies -> lie

> +By registering subnotifiers drivers can incrementally move the subdevice
> +matching down the chain of drivers. This is performed using the
> +:c:func:`v4l2_async_subnotifier_register` call. To unregister the
> +subnotifier the driver has to call
> +:c:func:`v4l2_async_subnotifier_unregister`. These functions and its

its -> their

> +arguments behave almost the same as the bridge driver notifiers
> +described above and are treated equally by the V4L2 core when matching
> +asynchronously registered subdevices. The differences are that the
> +subnotifier functions act on :c:type:`v4l2_subdev` instead of
> +:c:type:`v4l2_device` and that they should be called from the subdevices

subdevices -> subdevice's

> +``.registered()`` and ``.unregistered()``
> +:c:type:`v4l2_subdev_internal_ops` callbacks instead of at probe time.
> +
>   V4L2 sub-device userspace API
>   -----------------------------
>   
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index c16200c88417b151..e1e181db90f789c0 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -141,11 +141,13 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>   	sd->dev = NULL;
>   }
>   
> -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -				 struct v4l2_async_notifier *notifier)
> +static int v4l2_async_do_notifier_register(struct v4l2_device *v4l2_dev,
> +					   struct v4l2_async_notifier *notifier,
> +					   bool subnotifier)
>   {
>   	struct v4l2_subdev *sd, *tmp;
>   	struct v4l2_async_subdev *asd;
> +	bool found;
>   	int i;
>   
>   	if (!v4l2_dev || !notifier->num_subdevs ||
> @@ -174,32 +176,65 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>   		list_add_tail(&asd->list, &notifier->waiting);
>   	}
>   
> -	mutex_lock(&list_lock);
> +	if (subnotifier)
> +		lockdep_assert_held(&list_lock);
> +	else
> +		mutex_lock(&list_lock);
> +
> +	/*
> +	 * This function can be called recursively so the list
> +	 * might be modified in a recursive call. Start from the
> +	 * top of the list each iteration.
> +	 */
> +	found = true;
> +	while (found) {
> +		found = false;
>   
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> +		list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +			int ret;
>   
> -		asd = v4l2_async_belongs(notifier, sd);
> -		if (!asd)
> -			continue;
> +			asd = v4l2_async_belongs(notifier, sd);
> +			if (!asd)
> +				continue;
>   
> -		ret = v4l2_async_test_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> +			ret = v4l2_async_test_notify(notifier, sd, asd);
> +			if (ret < 0) {
> +				if (!subnotifier)
> +					mutex_unlock(&list_lock);
> +				return ret;
> +			}
> +
> +			found = true;
> +			break;
>   		}
>   	}
>   
>   	/* Keep also completed notifiers on the list */
>   	list_add(&notifier->list, &notifier_list);
>   
> -	mutex_unlock(&list_lock);
> +	if (!subnotifier)
> +		mutex_unlock(&list_lock);
>   
>   	return 0;
>   }
> +
> +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> +				    struct v4l2_async_notifier *notifier)
> +{
> +	return v4l2_async_do_notifier_register(sd->v4l2_dev, notifier, true);
> +}
> +EXPORT_SYMBOL(v4l2_async_subnotifier_register);
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	return v4l2_async_do_notifier_register(v4l2_dev, notifier, false);
> +}
>   EXPORT_SYMBOL(v4l2_async_notifier_register);
>   
> -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +static void
> +v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
> +				  bool subnotifier)
>   {
>   	struct v4l2_subdev *sd, *tmp;
>   	unsigned int notif_n_subdev = notifier->num_subdevs;
> @@ -216,7 +251,10 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>   			"Failed to allocate device cache!\n");
>   	}
>   
> -	mutex_lock(&list_lock);
> +	if (subnotifier)
> +		lockdep_assert_held(&list_lock);
> +	else
> +		mutex_lock(&list_lock);
>   
>   	list_del(&notifier->list);
>   
> @@ -243,15 +281,20 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>   			put_device(d);
>   	}
>   
> -	mutex_unlock(&list_lock);
> +	if (!subnotifier)
> +		mutex_unlock(&list_lock);
>   
>   	/*
>   	 * Call device_attach() to reprobe devices
>   	 *
>   	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
>   	 * executed.
> +	 * TODO: If we are unregistering a subdevice notifier we can't reprobe
> +	 * since the lock_list is held by the master device and attaching that
> +	 * device would call v4l2_async_register_subdev() and end in a deadlock
> +	 * on list_lock.
>   	 */
> -	while (i--) {
> +	while (i-- && !subnotifier) {
>   		struct device *d = dev[i];
>   
>   		if (d && device_attach(d) < 0) {
> @@ -275,6 +318,17 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>   	 * upon notifier registration.
>   	 */
>   }
> +
> +void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	v4l2_async_do_notifier_unregister(notifier, true);
> +}
> +EXPORT_SYMBOL(v4l2_async_subnotifier_unregister);
> +
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	v4l2_async_do_notifier_unregister(notifier, false);
> +}
>   EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>   
>   int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c69d8c8a66d0093a..7d55a5b0adc86580 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -105,6 +105,18 @@ struct v4l2_async_notifier {
>   };
>   
>   /**
> + * v4l2_async_notifier_register - registers a subdevice asynchronous subnotifier
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @notifier: pointer to &struct v4l2_async_notifier
> + *
> + * This function assumes the async list_lock is already locked, allowing
> + * it to be used from struct v4l2_subdev_internal_ops registered() callback.

from -> from the

> + */
> +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> +				    struct v4l2_async_notifier *notifier);
> +
> +/**
>    * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
>    *
>    * @v4l2_dev: pointer to &struct v4l2_device
> @@ -114,6 +126,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>   				 struct v4l2_async_notifier *notifier);
>   
>   /**
> + * v4l2_async_subnotifier_unregister - unregisters a asynchronous subnotifier
> + *
> + * @notifier: pointer to &struct v4l2_async_notifier
> + *
> + * This function assumes the async list_lock is already locked, allowing
> + * it to be used from struct v4l2_subdev_internal_ops unregistered() callback.

from -> from the

> + */
> +void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier);
> +
> +/**
>    * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
>    *
>    * @notifier: pointer to &struct v4l2_async_notifier
> 

Nice work! After fixing the typos you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I'd like to have another Ack from Sakari or Laurent before merging this, though.

Regards,

	Hans
