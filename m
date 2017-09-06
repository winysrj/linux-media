Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55277 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751837AbdIFHBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 03:01:32 -0400
Subject: Re: [PATCH v8 03/21] v4l: async: Use more intuitive names for
 internal functions
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-4-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7e466832-2c73-a552-1396-e9c282409272@xs4all.nl>
Date: Wed, 6 Sep 2017 09:01:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170905130553.1332-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> Rename internal functions to make the names of the functions better
> describe what they do.
> 
> 	Old name			New name
> 	v4l2_async_test_notify	v4l2_async_match_notify
> 	v4l2_async_belongs	v4l2_async_find_match
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index f50a82767863..3d81ff6a496f 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -65,8 +65,8 @@ static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
>  static DEFINE_MUTEX(list_lock);
>  
> -static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
> -						    struct v4l2_subdev *sd)
> +static struct v4l2_async_subdev *v4l2_async_find_match(
> +	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
>  {
>  	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
>  	struct v4l2_async_subdev *asd;
> @@ -100,9 +100,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>  	return NULL;
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
> @@ -180,11 +180,11 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
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
> @@ -241,9 +241,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
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
> 
