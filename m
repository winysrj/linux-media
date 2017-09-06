Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:33916 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751675AbdIFHva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 03:51:30 -0400
Subject: Re: [PATCH v8 13/21] v4l: async: Register sub-devices before calling
 bound callback
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-14-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ddbea2fe-a740-518e-deb4-bdb3d65c0e9d@xs4all.nl>
Date: Wed, 6 Sep 2017 09:51:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170905130553.1332-14-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> Register the sub-device before calling the notifier's bound callback.
> Doing this the other way around is problematic as the struct v4l2_device
> has not assigned for the sub-device yet and may be required by the bound
> callback.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index baee95eacbba..79f216723a3f 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -135,13 +135,13 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  {
>  	int ret;
>  
> -	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> +	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> +	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
>  	if (ret < 0) {
> -		v4l2_async_notifier_call_unbind(notifier, sd, asd);
> +		v4l2_device_unregister_subdev(sd);
>  		return ret;
>  	}
>  
> 
