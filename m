Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59819 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750704AbdIEGtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 02:49:52 -0400
Subject: Re: [PATCH v7 12/18] v4l: async: Allow binding notifiers to
 sub-devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-13-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6ad1c25a-e2a7-b73f-4d7c-6a5c071e6366@xs4all.nl>
Date: Tue, 5 Sep 2017 08:49:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-13-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> Registering a notifier has required the knowledge of struct v4l2_device
> for the reason that sub-devices generally are registered to the
> v4l2_device (as well as the media device, also available through
> v4l2_device).
> 
> This information is not available for sub-device drivers at probe time.
> 
> What this patch does is that it allows registering notifiers without
> having v4l2_device around. Instead the sub-device pointer is stored to the
> notifier. Once the sub-device of the driver that registered the notifier
> is registered, the notifier will gain the knowledge of the v4l2_device,
> and the binding of async sub-devices from the sub-device driver's notifier
> may proceed.
> 
> The master notifier's complete callback is only called when all sub-device
> notifiers are completed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 153 +++++++++++++++++++++++++++++------
>  include/media/v4l2-async.h           |  19 ++++-
>  2 files changed, 146 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 70d02378b48f..55d7886103d2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -25,6 +25,10 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
> +static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> +				  struct v4l2_subdev *sd,
> +				  struct v4l2_async_subdev *asd);
> +
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
>  #if IS_ENABLED(CONFIG_I2C)
> @@ -101,14 +105,69 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>  	return NULL;
>  }
>  
> +static bool v4l2_async_subdev_notifiers_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier->notifiers, notifiers) {
> +		if (!n->master)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +#define notifier_v4l2_dev(n) \
> +	(!!(n)->v4l2_dev ? (n)->v4l2_dev : \
> +	 !!(n)->master ? (n)->master->v4l2_dev : NULL)
> +
> +static struct v4l2_async_notifier *v4l2_async_get_subdev_notifier(
> +	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)

Why pass the notifier argument when it is not actually used in the function?

Is this function needed at all? As far as I can see the sd always belongs to
the given notifier, otherwise the v4l2_async_belongs() call would fail.
And v4l2_async_belongs() is always called before v4l2_async_test_notify().

This could all do with some more code comments. I'm having a difficult time
understanding it all.

I'll wait for v8 before continuing this.

Regards,

	Hans

> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier_list, list) {
> +		if (n->sd == sd)
> +			return n;
> +	}
> +
> +	return NULL;
> +}
