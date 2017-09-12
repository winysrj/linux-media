Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52263 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751286AbdILJjg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 05:39:36 -0400
Subject: Re: [PATCH v11 11/24] v4l: async: Introduce helpers for calling async
 ops callbacks
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-12-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a9e96a8c-25d2-109d-da22-a6771da6b68d@xs4all.nl>
Date: Tue, 12 Sep 2017 11:39:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170912084236.1154-12-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/17 10:42, Sakari Ailus wrote:
> Add three helper functions to call async operations callbacks. Besides
> simplifying callbacks, this allows async notifiers to have no ops set,
> i.e. it can be left NULL.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I'm sure I acked this already, but in case it was lost:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++++++++++----------
>  include/media/v4l2-async.h           |  1 +
>  2 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index a2df85ea00f4..c34f93593b41 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -25,6 +25,34 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
> +static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier *n,
> +					  struct v4l2_subdev *subdev,
> +					  struct v4l2_async_subdev *asd)
> +{
> +	if (!n->ops || !n->ops->bound)
> +		return 0;
> +
> +	return n->ops->bound(n, subdev, asd);
> +}
> +
> +static void v4l2_async_notifier_call_unbind(struct v4l2_async_notifier *n,
> +					    struct v4l2_subdev *subdev,
> +					    struct v4l2_async_subdev *asd)
> +{
> +	if (!n->ops || !n->ops->unbind)
> +		return;
> +
> +	n->ops->unbind(n, subdev, asd);
> +}
> +
> +static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
> +{
> +	if (!n->ops || !n->ops->complete)
> +		return 0;
> +
> +	return n->ops->complete(n);
> +}
> +
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
>  #if IS_ENABLED(CONFIG_I2C)
> @@ -102,16 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  {
>  	int ret;
>  
> -	if (notifier->ops->bound) {
> -		ret = notifier->ops->bound(notifier, sd, asd);
> -		if (ret < 0)
> -			return ret;
> -	}
> +	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> +	if (ret < 0)
> +		return ret;
>  
>  	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0) {
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, asd);
>  		return ret;
>  	}
>  
> @@ -123,8 +148,8 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
>  
> -	if (list_empty(&notifier->waiting) && notifier->ops->complete)
> -		return notifier->ops->complete(notifier);
> +	if (list_empty(&notifier->waiting))
> +		return v4l2_async_notifier_call_complete(notifier);
>  
>  	return 0;
>  }
> @@ -210,8 +235,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
>  		v4l2_async_cleanup(sd);
>  
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, sd->asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	}
>  
>  	mutex_unlock(&list_lock);
> @@ -300,8 +324,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  
>  	v4l2_async_cleanup(sd);
>  
> -	if (notifier->ops->unbind)
> -		notifier->ops->unbind(notifier, sd, sd->asd);
> +	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  
>  	mutex_unlock(&list_lock);
>  }
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 3c48f8b66d12..3bc8a7c0d83f 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -164,4 +164,5 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
>   * @sd: pointer to &struct v4l2_subdev
>   */
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
> +
>  #endif
> 
