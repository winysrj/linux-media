Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:51620 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932315AbdJZPXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 11:23:40 -0400
Received: by mail-lf0-f65.google.com with SMTP id r129so4176026lff.8
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 08:23:40 -0700 (PDT)
Date: Thu, 26 Oct 2017 17:23:38 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 02/32] v4l: async: Don't set sd->dev NULL in
 v4l2_async_cleanup
Message-ID: <20171026152338.GB2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:12 +0300, Sakari Ailus wrote:
> v4l2_async_cleanup() is called when the async sub-device is unbound from
> the media device. As the pointer is set by the driver registering the
> async sub-device, leave the pointer as set by the driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 60a1a50b9537..21c748bf3a7b 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -134,7 +134,6 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	/* Subdevice driver will reprobe and put the subdev back onto the list */
>  	list_del_init(&sd->async_list);
>  	sd->asd = NULL;
> -	sd->dev = NULL;
>  }
>  
>  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
