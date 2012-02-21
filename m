Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59764 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2BUOhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 09:37:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 05/33] v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
Date: Tue, 21 Feb 2012 15:37:39 +0100
Message-ID: <1872813.c6cpg0FnTW@avalon>
In-Reply-To: <1329703032-31314-5-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-5-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:56:44 Sakari Ailus wrote:
> vdev_to_v4l2_subdev() should return struct v4l2_subdev *, not void *. Fix
> this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Sounds like you've been bitten by this :-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-subdev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index feab950..bcaf6b8 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -545,7 +545,7 @@ struct v4l2_subdev {
>  #define media_entity_to_v4l2_subdev(ent) \
>  	container_of(ent, struct v4l2_subdev, entity)
>  #define vdev_to_v4l2_subdev(vdev) \
> -	video_get_drvdata(vdev)
> +	((struct v4l2_subdev *)video_get_drvdata(vdev))
> 
>  /*
>   * Used for storing subdev information per file handle
-- 
Regards,

Laurent Pinchart
