Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44594 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750871AbdE2K5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 06:57:24 -0400
Date: Mon, 29 May 2017 13:57:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 2/2] v4l: async: add subnotifier registration for
 subdevices
Message-ID: <20170529105708.GB29527@valkosipuli.retiisi.org.uk>
References: <20170524000727.12936-1-niklas.soderlund@ragnatech.se>
 <20170524000727.12936-3-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170524000727.12936-3-niklas.soderlund@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wed, May 24, 2017 at 02:07:27AM +0200, Niklas Söderlund wrote:
...
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index c16200c88417b151..e1e181db90f789c0 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -141,11 +141,13 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	sd->dev = NULL;
>  }
>  
> -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -				 struct v4l2_async_notifier *notifier)
> +static int v4l2_async_do_notifier_register(struct v4l2_device *v4l2_dev,
> +					   struct v4l2_async_notifier *notifier,
> +					   bool subnotifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> +	bool found;
>  	int i;
>  
>  	if (!v4l2_dev || !notifier->num_subdevs ||
> @@ -174,32 +176,65 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		list_add_tail(&asd->list, &notifier->waiting);
>  	}
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

That looks a bit cumbersome. You can do:

do {
	found = false;
	...;
} while (found);

And remove the assignment above. Or even

for (found = true; found; found = false) {
	...;
}

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

Alternatively you could use goto and a label to restart the matching. That
would be quite clean, you'd remove one variable which is just serving as a
condition to restart the loop:

again:
	list_for_each_entry_safe() {
		ret = test_notify();
		if (ret < 0)
			return ret;
		goto again;
	}

I think I like this better. This considered,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +			break;
>  		}
>  	}
>  
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
>  
> -	mutex_unlock(&list_lock);
> +	if (!subnotifier)
> +		mutex_unlock(&list_lock);
>  
>  	return 0;
>  }
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
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +static void
> +v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
> +				  bool subnotifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  	unsigned int notif_n_subdev = notifier->num_subdevs;
> @@ -216,7 +251,10 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  			"Failed to allocate device cache!\n");
>  	}
>  
> -	mutex_lock(&list_lock);
> +	if (subnotifier)
> +		lockdep_assert_held(&list_lock);
> +	else
> +		mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
>  
> @@ -243,15 +281,20 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  			put_device(d);
>  	}
>  
> -	mutex_unlock(&list_lock);
> +	if (!subnotifier)
> +		mutex_unlock(&list_lock);
>  
>  	/*
>  	 * Call device_attach() to reprobe devices
>  	 *
>  	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
>  	 * executed.
> +	 * TODO: If we are unregistering a subdevice notifier we can't reprobe
> +	 * since the lock_list is held by the master device and attaching that
> +	 * device would call v4l2_async_register_subdev() and end in a deadlock
> +	 * on list_lock.
>  	 */
> -	while (i--) {
> +	while (i-- && !subnotifier) {
>  		struct device *d = dev[i];
>  
>  		if (d && device_attach(d) < 0) {
> @@ -275,6 +318,17 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	 * upon notifier registration.
>  	 */
>  }
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
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c69d8c8a66d0093a..7d55a5b0adc86580 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -105,6 +105,18 @@ struct v4l2_async_notifier {
>  };
>  
>  /**
> + * v4l2_async_notifier_register - registers a subdevice asynchronous subnotifier
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @notifier: pointer to &struct v4l2_async_notifier
> + *
> + * This function assumes the async list_lock is already locked, allowing
> + * it to be used from struct v4l2_subdev_internal_ops registered() callback.
> + */
> +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> +				    struct v4l2_async_notifier *notifier);
> +
> +/**
>   * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
>   *
>   * @v4l2_dev: pointer to &struct v4l2_device
> @@ -114,6 +126,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  				 struct v4l2_async_notifier *notifier);
>  
>  /**
> + * v4l2_async_subnotifier_unregister - unregisters a asynchronous subnotifier
> + *
> + * @notifier: pointer to &struct v4l2_async_notifier
> + *
> + * This function assumes the async list_lock is already locked, allowing
> + * it to be used from struct v4l2_subdev_internal_ops unregistered() callback.
> + */
> +void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier);
> +
> +/**
>   * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
>   *
>   * @notifier: pointer to &struct v4l2_async_notifier

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
