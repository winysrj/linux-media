Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52559 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592Ab3HZJyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 05:54:20 -0400
Date: Mon, 26 Aug 2013 12:53:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Fix typo in v4l2_subdev_get_try_crop()
Message-ID: <20130826095346.GB2835@valkosipuli.retiisi.org.uk>
References: <1377508671-13188-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377508671-13188-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Aug 26, 2013 at 11:17:51AM +0200, Laurent Pinchart wrote:
> The helper function is defined by a macro that is erroneously called
> with the compose rectangle instead of the crop rectangle. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index bfda0fe..34d9219 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -628,7 +628,7 @@ struct v4l2_subdev_fh {
>  	}
>  
>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
>  #endif
>  

Oops. My bad I guess... it's a surprise to me this one slipped through.
Excellent find!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
