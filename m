Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46367 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754068AbdJILVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:21:31 -0400
Subject: Re: [PATCH v15 02/32] v4l: async: Don't set sd->dev NULL in
 v4l2_async_cleanup
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-3-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ba959391-f16e-57f6-fa4f-3dd49743c633@xs4all.nl>
Date: Mon, 9 Oct 2017 13:21:28 +0200
MIME-Version: 1.0
In-Reply-To: <20171004215051.13385-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/17 23:50, Sakari Ailus wrote:
> v4l2_async_cleanup() is called when the async sub-device is unbound from
> the media device. As the pointer is set by the driver registering the
> async sub-device, leave the pointer as set by the driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

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
> 
