Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:53531 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932315AbdJZPjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 11:39:32 -0400
Received: by mail-lf0-f68.google.com with SMTP id l23so4223812lfk.10
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 08:39:31 -0700 (PDT)
Date: Thu, 26 Oct 2017 17:39:30 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 06/32] v4l: async: Use more intuitive names for
 internal functions
Message-ID: <20171026153930.GE2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-7-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-7-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:16 +0300, Sakari Ailus wrote:
> Rename internal functions to make the names of the functions better
> describe what they do.
> 
> 	Old name			New name
> 	v4l2_async_test_notify	v4l2_async_match_notify
> 	v4l2_async_belongs	v4l2_async_find_match
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index cde2cf2ab4b0..8b84fea50c2a 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -60,8 +60,8 @@ static LIST_HEAD(subdev_list);
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
> @@ -95,9 +95,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
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
> @@ -187,11 +187,11 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
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
> @@ -255,13 +255,14 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	INIT_LIST_HEAD(&sd->async_list);
>  
>  	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> +		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
> +								      sd);
>  		int ret;
>  
>  		if (!asd)
>  			continue;
>  
> -		ret = v4l2_async_test_notify(notifier, sd, asd);
> +		ret = v4l2_async_match_notify(notifier, sd, asd);
>  		if (ret)
>  			goto err_unlock;
>  
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
