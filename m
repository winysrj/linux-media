Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38358 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaLGW4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 17:56:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
Date: Mon, 08 Dec 2014 00:57:19 +0200
Message-ID: <12562125.ajfSyzY5sH@avalon>
In-Reply-To: <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 04 December 2014 10:54:54 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Weird, this op isn't used at all. Seems to be orphaned code.
> Remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

That's easy, I like it :-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-subdev.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index b052184..5beeb87 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -342,8 +342,6 @@ struct v4l2_subdev_video_ops {
>  			struct v4l2_dv_timings *timings);
>  	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>  			     u32 *code);
> -	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> -			     struct v4l2_frmsizeenum *fsize);
>  	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *fmt);
>  	int (*try_mbus_fmt)(struct v4l2_subdev *sd,

-- 
Regards,

Laurent Pinchart

