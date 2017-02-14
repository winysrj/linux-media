Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55504 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750923AbdBNV5n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 16:57:43 -0500
Date: Tue, 14 Feb 2017 23:57:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 06/13] v4l2-async: per notifier locking
Message-ID: <20170214215737.GM16975@valkosipuli.retiisi.org.uk>
References: <20170214133956.GA8530@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214133956.GA8530@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel and Sebastian,

On Tue, Feb 14, 2017 at 02:39:56PM +0100, Pavel Machek wrote:
> From: Sebastian Reichel <sre@kernel.org>
> 
> Without this, camera support breaks boot on N900.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 54 ++++++++++++++++++------------------
>  include/media/v4l2-async.h           |  2 ++
>  2 files changed, 29 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 96cc733..26492a2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -57,7 +57,6 @@ static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  
>  static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
> -static DEFINE_MUTEX(list_lock);
>  
>  static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
>  						    struct v4l2_subdev *sd)
> @@ -102,12 +101,15 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  
>  	if (notifier->bound) {
>  		ret = notifier->bound(notifier, sd, asd);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			dev_warn(notifier->v4l2_dev->dev, "subdev bound failed\n");
>  			return ret;
> +		}
>  	}
>  
>  	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0) {
> +		dev_warn(notifier->v4l2_dev->dev, "subdev register failed\n");
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, asd);
>  		return ret;
> @@ -141,7 +143,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> -	int i;
> +	int ret = 0, i;
>  
>  	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
> @@ -149,6 +151,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  	notifier->v4l2_dev = v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> +	mutex_init(&notifier->lock);
>  
>  	for (i = 0; i < notifier->num_subdevs; i++) {
>  		asd = notifier->subdevs[i];
> @@ -168,28 +171,22 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		list_add_tail(&asd->list, &notifier->waiting);
>  	}
>  
> -	mutex_lock(&list_lock);
> +	/* Keep also completed notifiers on the list */
> +	list_add(&notifier->list, &notifier_list);
> +	mutex_lock(&notifier->lock);
>  
>  	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
>  		asd = v4l2_async_belongs(notifier, sd);
>  		if (!asd)
>  			continue;
>  
>  		ret = v4l2_async_test_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +		if (ret < 0)
> +			break;
>  	}
> +	mutex_unlock(&notifier->lock);
>  
> -	/* Keep also completed notifiers on the list */
> -	list_add(&notifier->list, &notifier_list);
> -
> -	mutex_unlock(&list_lock);
> -
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> @@ -210,7 +207,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  			"Failed to allocate device cache!\n");
>  	}
>  
> -	mutex_lock(&list_lock);
> +	mutex_lock(&notifier->lock);
>  
>  	list_del(&notifier->list);
>  
> @@ -237,7 +234,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  			put_device(d);
>  	}
>  
> -	mutex_unlock(&list_lock);
> +	mutex_unlock(&notifier->lock);
>  
>  	/*
>  	 * Call device_attach() to reprobe devices
> @@ -262,6 +259,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	}
>  	kfree(dev);
>  
> +	mutex_destroy(&notifier->lock);
>  	notifier->v4l2_dev = NULL;
>  
>  	/*
> @@ -274,6 +272,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier *tmp;
>  
>  	/*
>  	 * No reference taken. The reference is held by the device
> @@ -283,24 +282,25 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	if (!sd->of_node && sd->dev)
>  		sd->of_node = sd->dev->of_node;
>  
> -	mutex_lock(&list_lock);
> -
>  	INIT_LIST_HEAD(&sd->async_list);
>  
> -	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> +	list_for_each_entry_safe(notifier, tmp, &notifier_list, list) {

You still need to serialise access to the global notifier list.

The _safe iterator variants allow deleting the current entry from the list
but they do not help more than that.

One possible approach could be to gather the matching async sub-devices and
call the v4l2_async_test_notify() while not holding the notifier list mutex
anymore.

I presume the same problem is present in notifier registration.

> +		struct v4l2_async_subdev *asd;
> +
> +		/* TODO: FIXME: if this is called by ->bound() we will also iterate over the locked notifier */
> +		mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
> +		asd = v4l2_async_belongs(notifier, sd);
>  		if (asd) {
>  			int ret = v4l2_async_test_notify(notifier, sd, asd);
> -			mutex_unlock(&list_lock);
> +			mutex_unlock(&notifier->lock);
>  			return ret;
>  		}
> +		mutex_unlock(&notifier->lock);
>  	}
>  
>  	/* None matched, wait for hot-plugging */
>  	list_add(&sd->async_list, &subdev_list);
>  
> -	mutex_unlock(&list_lock);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_async_register_subdev);
> @@ -315,7 +315,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  		return;
>  	}
>  
> -	mutex_lock(&list_lock);
> +	mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
>  
>  	list_add(&sd->asd->list, &notifier->waiting);
>  
> @@ -324,6 +324,6 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  	if (notifier->unbind)
>  		notifier->unbind(notifier, sd, sd->asd);
>  
> -	mutex_unlock(&list_lock);
> +	mutex_unlock(&notifier->lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 8e2a236..690a81f 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -84,6 +84,7 @@ struct v4l2_async_subdev {
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> + * @lock:       lock hold when the notifier is being processed
>   * @bound:	a subdevice driver has successfully probed one of subdevices
>   * @complete:	all subdevices have been probed successfully
>   * @unbind:	a subdevice is leaving
> @@ -95,6 +96,7 @@ struct v4l2_async_notifier {
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> +	struct mutex lock;
>  	int (*bound)(struct v4l2_async_notifier *notifier,
>  		     struct v4l2_subdev *subdev,
>  		     struct v4l2_async_subdev *asd);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
