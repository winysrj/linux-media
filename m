Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42701 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754143AbdGSLY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 07:24:57 -0400
Subject: Re: [RFC 11/19] v4l2-async: Register sub-devices before calling bound
 callback
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-12-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <03f4a632-30b8-bdc8-2b03-fa7c3eb811a1@xs4all.nl>
Date: Wed, 19 Jul 2017 13:24:54 +0200
MIME-Version: 1.0
In-Reply-To: <20170718190401.14797-12-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/07/17 21:03, Sakari Ailus wrote:
> The async notifier supports three callbacks to the notifier: bound, unbound
> and complete. The complete callback has been traditionally used for
> creating the sub-device nodes.
> 
> This approach has an inherent weakness: if registration of a single
> sub-device fails for whatever reason, it renders the entire media device
> unusable even if only that piece of hardware is not working. This is a
> problem in particular in systems with multiple independent image pipelines
> on a single device. We have had such devices (e.g. omap3isp) supported for
> a number of years and the problem is growing more pressing as time passes
> so there is an incentive to resolve this.

I don't think this is a good reason. If one of the subdevices fail, then your
hardware is messed up and there is no point in continuing.

There may be other valid reasons why you would want this (reconfigurable
FPGA, hotplugging of sensors), but the reason you give here doesn't hold
water IMHO.

Regards,

	Hans

> The solution is to register device nodes at the time when the driver of
> those devices is complete with initialising the piece of hardware it is
> controlling.
> 
> This leaves partial pipelines visible to the user. There are two things to
> consider here:
> 
> 1) Registering multiple device nodes was never an atomic operation so the
> user space still had to be prepared for partial media graph being visible
> and
> 
> 2) The user space can figure out that a pipeline is not startable from the
> fact that there are pads with MEDIA_PAD_FL_MUST_CONNECT flag set without
> an (enabled) link.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index d2ce39ac402e..55fa7106345c 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -127,19 +127,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  {
>  	int ret;
>  
> -	if (notifier->bound) {
> -		ret = notifier->bound(notifier, sd, asd);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
>  	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0) {
> -		if (notifier->unbind)
> -			notifier->unbind(notifier, sd, asd);
>  		return ret;
>  	}
>  
> +	if (notifier->bound) {
> +		ret = notifier->bound(notifier, sd, asd);
> +		if (ret < 0) {
> +			v4l2_device_unregister_subdev(sd);
> +			return ret;
> +		}
> +	}
> +
>  	/* Remove from the waiting list */
>  	list_del(&asd->list);
>  	sd->asd = asd;
> 
