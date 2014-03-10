Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:63104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaCJXXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:23:40 -0400
Date: Tue, 11 Mar 2014 00:23:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 1/3] v4l2-subdev.h: add g_tvnorms video op
In-Reply-To: <1392637454-29179-2-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1403110014000.10570@axis700.grange>
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
 <1392637454-29179-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for taking care about this problem. I'm not sure it would be ok for 
me to pull this specific patch via my tree, because it's for the V4L2 
core, and the other 2 patches in this series depend on this one. But 
anyway I've got a question to this patch:

On Mon, 17 Feb 2014, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> While there was already a g_tvnorms_output video op, it's counterpart for
> video capture was missing. Add it.
> 
> This is necessary for generic bridge drivers like soc-camera to set the
> video_device tvnorms field correctly. Otherwise ENUMSTD cannot work.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/v4l2-subdev.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index d67210a..787d078 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -264,8 +264,11 @@ struct v4l2_mbus_frame_desc {
>     g_std_output: get current standard for video OUTPUT devices. This is ignored
>  	by video input devices.
>  
> -   g_tvnorms_output: get v4l2_std_id with all standards supported by video
> -	OUTPUT device. This is ignored by video input devices.
> +   g_tvnorms: get v4l2_std_id with all standards supported by the video
> +	CAPTURE device. This is ignored by video output devices.
> +
> +   g_tvnorms_output: get v4l2_std_id with all standards supported by the video
> +	OUTPUT device. This is ignored by video capture devices.

Why do we need two separate operations with the same functionality - one 
for capture and one for output? Can we have subdevices, that need to 
implement both? Besides, what about these two core ops:

	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);

? Seems like a slightly different approach is needed? Or am I missing 
anything?

Thanks
Guennadi

>     s_crystal_freq: sets the frequency of the crystal used to generate the
>  	clocks in Hz. An extra flags field allows device specific configuration
> @@ -308,6 +311,7 @@ struct v4l2_subdev_video_ops {
>  	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
>  	int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
>  	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
> +	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
>  	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
>  	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
>  	int (*s_stream)(struct v4l2_subdev *sd, int enable);
> -- 
> 1.8.5.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
