Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48783 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbaD3Q0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 12:26:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	a.hajda@samsung.com, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] [media] v4l2-device: fix potential NULL pointer dereference for subdev unregister path
Date: Wed, 30 Apr 2014 18:27:07 +0200
Message-ID: <1820972.unmABxgn1R@avalon>
In-Reply-To: <1398831921-5652-1-git-send-email-Ying.Liu@freescale.com>
References: <1398831921-5652-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Liu,

Thank you for the patch.

On Wednesday 30 April 2014 12:25:21 Liu Ying wrote:
> The pointer 'sd->v4l2_dev' is likely to be NULL and dereferenced in the
> subdev unregister path.  The issue should happen if CONFIG_MEDIA_CONTROLLER
> is defined.
> 
> This patch fixes the issue by setting the pointer to be NULL after it will
> not be derefereneced any more in the path.

I'm not sure to understand the problem. Where do you see sd->v4l2_dev being 
(potentially) dereferenced after being set to NULL ?

> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
>  drivers/media/v4l2-core/v4l2-device.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c
> b/drivers/media/v4l2-core/v4l2-device.c index 02d1b63..d98d96f 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -271,7 +271,6 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev
> *sd)
> 
>  	if (sd->internal_ops && sd->internal_ops->unregistered)
>  		sd->internal_ops->unregistered(sd);
> -	sd->v4l2_dev = NULL;
> 
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	if (v4l2_dev->mdev) {
> @@ -279,6 +278,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev
> *sd) media_device_unregister_entity(&sd->entity);
>  	}
>  #endif
> +	v4l2_dev = NULL;
>  	video_unregister_device(sd->devnode);
>  	module_put(sd->owner);
>  }

-- 
Regards,

Laurent Pinchart

