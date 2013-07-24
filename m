Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3GXLVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 07:21:48 -0400
Date: Wed, 24 Jul 2013 13:21:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 3/5] V4L2: Add V4L2_ASYNC_MATCH_OF subdev matching
 type
In-Reply-To: <1374516287-7638-4-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1307241320170.30777@axis700.grange>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <1374516287-7638-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:

> Add support for matching by device_node pointer. This allows
> the notifier user to simply pass a list of device_node pointers
> corresponding to sub-devices.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c |    9 +++++++++
>  include/media/v4l2-async.h           |    5 +++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 86934ca..9f91013 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -39,6 +39,11 @@ static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
>  	return !strcmp(asd->match.device_name.name, dev_name(dev));
>  }
>  
> +static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
> +{
> +	return dev->of_node == asd->match.of.node;
> +}
> +
>  static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
>  static DEFINE_MUTEX(list_lock);
> @@ -66,6 +71,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>  		case V4L2_ASYNC_MATCH_I2C:
>  			match = match_i2c;
>  			break;
> +		case V4L2_ASYNC_MATCH_OF:
> +			match = match_of;
> +			break;
>  		default:
>  			/* Cannot happen, unless someone breaks us */
>  			WARN_ON(true);
> @@ -145,6 +153,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  		case V4L2_ASYNC_MATCH_CUSTOM:
>  		case V4L2_ASYNC_MATCH_DEVNAME:
>  		case V4L2_ASYNC_MATCH_I2C:
> +		case V4L2_ASYNC_MATCH_OF:
>  			break;
>  		default:
>  			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 33e3b2a..295782e 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -13,6 +13,7 @@
>  
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> +#include <linux/of.h>
>  
>  struct device;
>  struct v4l2_device;

A nitpick: it is common to just forward-declare structs as above instead 
of including a header if just a pointer to that struct is needed. I think 
it would be more consistent to update it here.

Thanks
Guennadi

> @@ -26,6 +27,7 @@ enum v4l2_async_match_type {
>  	V4L2_ASYNC_MATCH_CUSTOM,
>  	V4L2_ASYNC_MATCH_DEVNAME,
>  	V4L2_ASYNC_MATCH_I2C,
> +	V4L2_ASYNC_MATCH_OF,
>  };
>  
>  /**
> @@ -39,6 +41,9 @@ struct v4l2_async_subdev {
>  	enum v4l2_async_match_type match_type;
>  	union {
>  		struct {
> +			const struct device_node *node;
> +		} of;
> +		struct {
>  			const char *name;
>  		} device_name;
>  		struct {
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
