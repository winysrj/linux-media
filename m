Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58459 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbdIIPe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 11:34:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 03/24] v4l: async: Use more intuitive names for internal functions
Date: Sat, 09 Sep 2017 18:34:25 +0300
Message-ID: <3924992.Y6xJjAbaat@avalon>
In-Reply-To: <20170908131235.30294-4-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com> <20170908131235.30294-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 8 September 2017 16:11:54 EEST Sakari Ailus wrote:
> Rename internal functions to make the names of the functions better
> describe what they do.
> 
> 	Old name			New name
> 	v4l2_async_test_notify	v4l2_async_match_notify
> 	v4l2_async_belongs	v4l2_async_find_match
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Kerneldoc for the two functions would of course have been even better :-) That 
can be added in a separate patch.

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index e109d9da4653..831f185ecd47
> 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -60,8 +60,8 @@ static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
>  static DEFINE_MUTEX(list_lock);
> 
> -static struct v4l2_async_subdev *v4l2_async_belongs(struct
> v4l2_async_notifier *notifier, -						    struct v4l2_subdev *sd)
> +static struct v4l2_async_subdev *v4l2_async_find_match(
> +	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
>  {
>  	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
>  	struct v4l2_async_subdev *asd;
> @@ -95,9 +95,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct
> v4l2_async_notifier * return NULL;
>  }
> 
> -static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> -				  struct v4l2_subdev *sd,
> -				  struct v4l2_async_subdev *asd)
> +static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *sd,
> +				   struct v4l2_async_subdev *asd)
>  {
>  	int ret;
> 
> @@ -175,11 +175,11 @@ int v4l2_async_notifier_register(struct v4l2_device
> *v4l2_dev, list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
>  		int ret;
> 
> -		asd = v4l2_async_belongs(notifier, sd);
> +		asd = v4l2_async_find_match(notifier, sd);
>  		if (!asd)
>  			continue;
> 
> -		ret = v4l2_async_test_notify(notifier, sd, asd);
> +		ret = v4l2_async_match_notify(notifier, sd, asd);
>  		if (ret < 0) {
>  			mutex_unlock(&list_lock);
>  			return ret;
> @@ -236,9 +236,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	INIT_LIST_HEAD(&sd->async_list);
> 
>  	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> +		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
> +								      sd);
>  		if (asd) {
> -			int ret = v4l2_async_test_notify(notifier, sd, asd);
> +			int ret = v4l2_async_match_notify(notifier, sd, asd);
>  			mutex_unlock(&list_lock);
>  			return ret;
>  		}


-- 
Regards,

Laurent Pinchart
