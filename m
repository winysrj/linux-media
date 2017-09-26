Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:40557 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967934AbdIZIMw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:12:52 -0400
Subject: Re: [PATCH v14 14/28] v4l: async: Prepare for async sub-device
 notifiers
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-15-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ba80e242-a3c2-39af-01cd-6aa54649fb93@xs4all.nl>
Date: Tue, 26 Sep 2017 10:12:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170925222540.371-15-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/17 00:25, Sakari Ailus wrote:
> Refactor the V4L2 async framework a little in preparation for async
> sub-device notifiers.

Perhaps extend this a bit to also state the reason for these changes?

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Anyway,

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 66 +++++++++++++++++++++++++-----------
>  1 file changed, 47 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 77b9f851bfa9..1d4132305243 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -125,12 +125,13 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  }
>  
>  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_device *v4l2_dev,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
>  	int ret;
>  
> -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> +	ret = v4l2_device_register_subdev(v4l2_dev, sd);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -154,6 +155,31 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  	return 0;
>  }
>  
> +/* Test all async sub-devices in a notifier for a match. */
> +static int v4l2_async_notifier_try_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +		struct v4l2_async_subdev *asd;
> +		int ret;
> +
> +		asd = v4l2_async_find_match(notifier, sd);
> +		if (!asd)
> +			continue;
> +
> +		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> +		if (ret < 0) {
> +			mutex_unlock(&list_lock);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  {
>  	v4l2_device_unregister_subdev(sd);
> @@ -163,17 +189,15 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	sd->dev = NULL;
>  }
>  
> -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -				 struct v4l2_async_notifier *notifier)
> +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> +	int ret;
>  	int i;
>  
> -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
>  
> -	notifier->v4l2_dev = v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
>  
> @@ -206,18 +230,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	mutex_lock(&list_lock);
>  
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
> -		asd = v4l2_async_find_match(notifier, sd);
> -		if (!asd)
> -			continue;
> -
> -		ret = v4l2_async_match_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> +	if (ret) {
> +		mutex_unlock(&list_lock);
> +		return ret;
>  	}
>  
>  	/* Keep also completed notifiers on the list */
> @@ -227,6 +243,17 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  
>  	return 0;
>  }
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	if (WARN_ON(!v4l2_dev))
> +		return -EINVAL;
> +
> +	notifier->v4l2_dev = v4l2_dev;
> +
> +	return __v4l2_async_notifier_register(notifier);
> +}
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> @@ -303,7 +330,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
>  								      sd);
>  		if (asd) {
> -			int ret = v4l2_async_match_notify(notifier, sd, asd);
> +			int ret = v4l2_async_match_notify(
> +				notifier, notifier->v4l2_dev, sd, asd);
>  			mutex_unlock(&list_lock);
>  			return ret;
>  		}
> 
