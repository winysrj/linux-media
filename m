Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41995 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751326AbdILJie (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 05:38:34 -0400
Subject: Re: [PATCH v11 13/24] v4l: async: Allow async notifier register call
 succeed with no subdevs
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-14-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e803a034-b0c8-4f28-c4c2-ef964699d7e3@xs4all.nl>
Date: Tue, 12 Sep 2017 11:38:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170912084236.1154-14-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/17 10:42, Sakari Ailus wrote:
> The information on how many async sub-devices would be bindable to a
> notifier is typically dependent on information from platform firmware and
> it's not driver's business to be aware of that.
> 
> Many V4L2 main drivers are perfectly usable (and useful) without async
> sub-devices and so if there aren't any around, just proceed call the
> notifier's complete callback immediately without registering the notifier
> itself.
> 
> If a driver needs to check whether there are async sub-devices available,
> it can be done by inspecting the notifier's num_subdevs field which tells
> the number of async sub-devices.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 7b396ff4302b..4525b03d59c1 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -170,14 +170,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  	struct v4l2_async_subdev *asd;
>  	int i;
>  
> -	if (!v4l2_dev || !notifier->num_subdevs ||
> -	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> +	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
>  
>  	notifier->v4l2_dev = v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
>  
> +	if (!notifier->num_subdevs)
> +		return v4l2_async_notifier_call_complete(notifier);
> +
>  	for (i = 0; i < notifier->num_subdevs; i++) {
>  		asd = notifier->subdevs[i];
>  
> 
