Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1026 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaBLMwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 07:52:36 -0500
Message-ID: <52FB6DB7.5030602@xs4all.nl>
Date: Wed, 12 Feb 2014 13:48:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 25/47] v4l: subdev: Remove deprecated video-level DV timings
 operations
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-26-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/14 17:42, Laurent Pinchart wrote:
> The video enum_dv_timings and dv_timings_cap operations are deprecated
> and unused. Remove them.

FYI: after this the adv7604 fails to compile since it is still using the
video ops. You should move the patches that convert the adv7604 before
this patch.

Regards,

	Hans

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 2c7355a..ddea899 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -326,12 +326,8 @@ struct v4l2_subdev_video_ops {
>  			struct v4l2_dv_timings *timings);
>  	int (*g_dv_timings)(struct v4l2_subdev *sd,
>  			struct v4l2_dv_timings *timings);
> -	int (*enum_dv_timings)(struct v4l2_subdev *sd,
> -			struct v4l2_enum_dv_timings *timings);
>  	int (*query_dv_timings)(struct v4l2_subdev *sd,
>  			struct v4l2_dv_timings *timings);
> -	int (*dv_timings_cap)(struct v4l2_subdev *sd,
> -			struct v4l2_dv_timings_cap *cap);
>  	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>  			     enum v4l2_mbus_pixelcode *code);
>  	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> 

