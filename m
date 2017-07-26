Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58829
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750867AbdGZRtK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 13:49:10 -0400
Date: Wed, 26 Jul 2017 14:48:59 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Subject: Re: [RFC 1/1] v4l2-subdev: Add a function to set sub-device
 notifier callbacks
Message-ID: <20170726144859.387f4490@vento.lan>
In-Reply-To: <20170719223329.10112-1-sakari.ailus@linux.intel.com>
References: <20170718211922.GI28538@bigcity.dyn.berto.se>
        <20170719223329.10112-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Jul 2017 01:33:29 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The sub-device's sub-notifier is hidded in the sub-device and not meant to
> be accessed directly by drivers. Still the driver may wish to set callbacks
> to the notifier. Add a function to do that:
> v4l2_subdev_notifier_set_callbacks().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Well, this appears to be quite straightforward. The code is entirely untested
> but trivial at the same time. 
> 
>  drivers/media/v4l2-core/v4l2-subdev.c | 20 ++++++++++++++++++++
>  include/media/v4l2-subdev.h           |  6 ++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index a6976d4a52ac..8629224bfdba 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -666,3 +666,23 @@ int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd)
>  	return v4l2_fwnode_reference_parse_sensor_common(sd->dev, subnotifier);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_subdev_fwnode_reference_parse_sensor_common);
> +
> +int v4l2_subdev_notifier_set_callbacks(
> +	struct v4l2_subdev *sd,
> +	int (*bound)(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd),
> +	int (*complete)(struct v4l2_async_notifier *notifier))
> +{
> +	struct v4l2_async_notifier *subnotifier =
> +		v4l2_subdev_get_subnotifier(sd);
> +
> +	if (!subnotifier)
> +		return -ENOMEM;
> +
> +	subnotifier->bound = bound;
> +	subnotifier->complete = complete;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_subdev_notifier_set_callbacks);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index e309a2e2030b..ee85b64ad4f4 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -1012,4 +1012,10 @@ int v4l2_subdev_fwnode_endpoints_parse(
>  
>  int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd);
>  
> +int v4l2_subdev_notifier_set_callbacks(
> +	struct v4l2_subdev *sd,
> +	int (*bound)(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd),
> +	int (*complete)(struct v4l2_async_notifier *notifier));

I guess currently v4l2-subdev.h is not included at the kAPI guide,
but it should (patches documenting it are welcomed!).

Yet, let's try to not increase the documentation gap here. So,
if we're willing to add this upstream, please add the 
kernel-doc macro for such function at the final patch, and test it.

I suspect that the best is to use typedefs for bound and complete,
in order for them to be properly documented and to be parsed by 
kernel-doc/Sphinx.

Regards,

Thanks,
Mauro
