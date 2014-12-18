Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56342 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaLRWId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 17:08:33 -0500
Date: Thu, 18 Dec 2014 23:08:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
In-Reply-To: <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1412182307100.11953@axis700.grange>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
 <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 4 Dec 2014, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Weird, this op isn't used at all. Seems to be orphaned code.
> Remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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

After so many cheerful acks I feel a bit bluffed, but... Your subject says 
"drop enum_mbus_fmt" and your patch drops enum_mbus_fsizes... What am I 
missing??

Thanks
Guennadi

>  	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *fmt);
>  	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
> -- 
> 2.1.3
> 
