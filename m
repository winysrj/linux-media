Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44073 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932409AbdJZVw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 17:52:58 -0400
Received: by mail-lf0-f68.google.com with SMTP id 75so5342832lfx.1
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 14:52:58 -0700 (PDT)
Date: Thu, 26 Oct 2017 23:52:55 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 15/32] v4l: async: Register sub-devices before
 calling bound callback
Message-ID: <20171026215255.GI2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-16-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-16-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:25 +0300, Sakari Ailus wrote:
> Register the sub-device before calling the notifier's bound callback.
> Doing this the other way around is problematic as the struct v4l2_device
> has not assigned for the sub-device yet and may be required by the bound
> callback.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index e170682dae78..46db85685894 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -130,13 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
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
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
