Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33044 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2G3JMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 05:12:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH 1/1] v4l: Add missing compatibility definitions for bounds rectangles
Date: Mon, 30 Jul 2012 11:12:22 +0200
Message-ID: <15447077.9DCFLWqFYU@avalon>
In-Reply-To: <1343639327-31329-1-git-send-email-sakari.ailus@iki.fi>
References: <1343639327-31329-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 30 July 2012 12:08:47 Sakari Ailus wrote:
> Compatibility defines for ACTUAL subdev selection rectangles were added and
> also the name of the BOUNDS rectangles was changed in the process, which,
> alas, went unnoticed until now. Add compatibility definitions for these
> rectangles.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/linux/v4l2-common.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
> index 0fa8b64..4f0667e 100644
> --- a/include/linux/v4l2-common.h
> +++ b/include/linux/v4l2-common.h
> @@ -53,10 +53,10 @@
>  /* Backward compatibility target definitions --- to be removed. */
>  #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
>  #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
> -#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
> -	V4L2_SEL_TGT_CROP
> -#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
> -	V4L2_SEL_TGT_COMPOSE
> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL	V4L2_SEL_TGT_CROP
> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL V4L2_SEL_TGT_COMPOSE
> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS	V4L2_SEL_TGT_CROP_BOUNDS
> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS V4L2_SEL_TGT_COMPOSE_BOUNDS
> 
>  /* Selection flags */
>  #define V4L2_SEL_FLAG_GE		(1 << 0)

-- 
Regards,

Laurent Pinchart

