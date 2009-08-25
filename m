Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2565 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZHYRCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 13:02:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: add new v4l2-subdev sensor operations, use skip_top_lines in soc-camera
Date: Tue, 25 Aug 2009 19:02:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908251902.03790.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 25 August 2009 18:56:29 Guennadi Liakhovetski wrote:
> Introduce new v4l2-subdev sensor operations, move .enum_framesizes() and
> .enum_frameintervals() methods to it, add a new .skip_top_lines() method
> and switch soc-camera to use it instead of .y_skip_top soc_camera_device
> member, which can now be removed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/mt9m001.c             |   28 +++++++++++++++++++++-------
>  drivers/media/video/mt9m111.c             |    1 -
>  drivers/media/video/mt9t031.c             |    8 +++-----
>  drivers/media/video/mt9v022.c             |   28 +++++++++++++++++++++-------
>  drivers/media/video/pxa_camera.c          |    9 +++++++--
>  drivers/media/video/soc_camera_platform.c |    1 -
>  include/media/soc_camera.h                |    1 -
>  include/media/v4l2-subdev.h               |   11 +++++++++++
>  8 files changed, 63 insertions(+), 24 deletions(-)
> 

<snip>

> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 89a39ce..169b336 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -225,8 +225,18 @@ struct v4l2_subdev_video_ops {
>  	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
>  	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> +};
> +
> +/**
> + * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
> + * @enum_framesizes: enumerate supported framesizes
> + * @enum_frameintervals: enumerate supported frame format intervals
> + * @skip_top_lines: number of lines at the top of the image to be skipped

You should add some comments here why this function is needed.

Other than that it's OK.

Regards,

	Hans

> + */
> +struct v4l2_subdev_sensor_ops {
>  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
>  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
> +	int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
>  };
>  
>  struct v4l2_subdev_ops {
> @@ -234,6 +244,7 @@ struct v4l2_subdev_ops {
>  	const struct v4l2_subdev_tuner_ops *tuner;
>  	const struct v4l2_subdev_audio_ops *audio;
>  	const struct v4l2_subdev_video_ops *video;
> +	const struct v4l2_subdev_sensor_ops *sensor;
>  };
>  
>  #define V4L2_SUBDEV_NAME_SIZE 32



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
