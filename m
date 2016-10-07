Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:48280 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933163AbcJGQaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 12:30:46 -0400
Subject: Re: [PATCH 01/22] [media] v4l2-async: move code out of
 v4l2_async_notifier_register into v4l2_async_test_nofity_all
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-2-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
From: Marek Vasut <marex@denx.de>
Message-ID: <9edf9ac6-8f8d-f421-5d88-604cfeaaff64@denx.de>
Date: Fri, 7 Oct 2016 18:30:42 +0200
MIME-Version: 1.0
In-Reply-To: <20161007160107.5074-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> This will be reused in the following patch to catch already registered,
> newly added asynchronous subdevices from v4l2_async_register_subdev.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 38 +++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 5bada20..c4f1930 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -134,11 +134,31 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	sd->dev = NULL;
>  }
>  
> +static int v4l2_async_test_notify_all(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +		struct v4l2_async_subdev *asd;
> +		int ret;
> +
> +		asd = v4l2_async_belongs(notifier, sd);
> +		if (!asd)
> +			continue;
> +
> +		ret = v4l2_async_test_notify(notifier, sd, asd);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  				 struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> +	int ret;
>  	int i;
>  
>  	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> @@ -171,23 +191,9 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
>  
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
> -		asd = v4l2_async_belongs(notifier, sd);
> -		if (!asd)
> -			continue;
> -
> -		ret = v4l2_async_test_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> -	}

Shouldn't you call ret = v4l2_async_test_notify_all() here now instead ?

>  	mutex_unlock(&list_lock);
>  
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
>  
> 


-- 
Best regards,
Marek Vasut
