Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:52218 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932369AbdJZVqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 17:46:49 -0400
Received: by mail-lf0-f66.google.com with SMTP id r129so5301940lff.8
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 14:46:49 -0700 (PDT)
Date: Thu, 26 Oct 2017 23:46:47 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 14/32] v4l: async: Introduce helpers for calling
 async ops callbacks
Message-ID: <20171026214646.GH2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-15-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-15-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:24 +0300, Sakari Ailus wrote:
> Add three helper functions to call async operations callbacks. Besides
> simplifying callbacks, this allows async notifiers to have no ops set,
> i.e. it can be left NULL.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 56 +++++++++++++++++++++++++-----------
>  1 file changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 9d6fc5f25619..e170682dae78 100644
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
> @@ -140,8 +165,7 @@ static void v4l2_async_notifier_unbind_all_subdevs(
>  	struct v4l2_subdev *sd, *tmp;
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, sd->asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  		v4l2_async_cleanup(sd);
>  
>  		list_move(&sd->async_list, &subdev_list);
> @@ -198,8 +222,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		}
>  	}
>  
> -	if (list_empty(&notifier->waiting) && notifier->ops->complete) {
> -		ret = notifier->ops->complete(notifier);
> +	if (list_empty(&notifier->waiting)) {
> +		ret = v4l2_async_notifier_call_complete(notifier);
>  		if (ret)
>  			goto err_complete;
>  	}
> @@ -296,10 +320,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  		if (ret)
>  			goto err_unlock;
>  
> -		if (!list_empty(&notifier->waiting) || !notifier->ops->complete)
> +		if (!list_empty(&notifier->waiting))
>  			goto out_unlock;
>  
> -		ret = notifier->ops->complete(notifier);
> +		ret = v4l2_async_notifier_call_complete(notifier);
>  		if (ret)
>  			goto err_cleanup;
>  
> @@ -315,8 +339,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	return 0;
>  
>  err_cleanup:
> -	if (notifier->ops->unbind)
> -		notifier->ops->unbind(notifier, sd, sd->asd);
> +	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	v4l2_async_cleanup(sd);
>  
>  err_unlock:
> @@ -335,8 +358,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  
>  		list_add(&sd->asd->list, &notifier->waiting);
>  
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, sd->asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	}
>  
>  	v4l2_async_cleanup(sd);
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
