Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:54407 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbdJZPiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 11:38:06 -0400
Received: by mail-lf0-f65.google.com with SMTP id a2so4214560lfh.11
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 08:38:05 -0700 (PDT)
Date: Thu, 26 Oct 2017 17:38:03 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 05/32] v4l: async: Correctly serialise async
 sub-device unregistration
Message-ID: <20171026153803.GD2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-6-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-6-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:15 +0300, Sakari Ailus wrote:
> The check whether an async sub-device is bound to a notifier was performed
> without list_lock held, making it possible for another process to
> unbind the async sub-device before the sub-device unregistration function
> proceeds to take the lock.
> 
> Fix this by first acquiring the lock and then proceeding with the check.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 4924481451ca..cde2cf2ab4b0 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -298,20 +298,16 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
>  
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
> -	struct v4l2_async_notifier *notifier = sd->notifier;
> -
> -	if (!sd->asd) {
> -		if (!list_empty(&sd->async_list))
> -			v4l2_async_cleanup(sd);
> -		return;
> -	}
> -
>  	mutex_lock(&list_lock);
>  
> -	list_add(&sd->asd->list, &notifier->waiting);
> +	if (sd->asd) {
> +		struct v4l2_async_notifier *notifier = sd->notifier;
>  
> -	if (notifier->unbind)
> -		notifier->unbind(notifier, sd, sd->asd);
> +		list_add(&sd->asd->list, &notifier->waiting);
> +
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, sd, sd->asd);
> +	}
>  
>  	v4l2_async_cleanup(sd);
>  
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
