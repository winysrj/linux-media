Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbZHYS4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 14:56:08 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 25 Aug 2009 14:00:19 -0500
Subject: RE: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use
 skip_top_lines in soc-camera
Message-ID: <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
 <200908251902.03790.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0908252021200.4810@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908252021200.4810@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Some comments I came across embedded below:

<snip>

> +
> +/**
> + * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
> + * @enum_framesizes: enumerate supported framesizes
> + * @enum_frameintervals: enumerate supported frame format intervals
> + * @skip_top_lines: number of lines at the top of the image to be
> skipped. This
> + *		    is needed for some sensors, that corrupt several top
> lines.
> + */
> +struct v4l2_subdev_sensor_ops {
>  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
> v4l2_frmsizeenum *fsize);
>  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> v4l2_frmivalenum *fival);
> +	int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
>  };

1. I honestly find a bit misleading the skip_top_lines name, since that IMO could be misunderstood that the called function will DO skip lines in the sensor, which is not the intended response...

How about g_skip_top_lines, or get_skip_top_lines, or something that clarifies it's a "get information" abstraction interface?

2. Why enumeration mechanisms are not longer needed for a video device? (You're removing them from video_ops)

3. Wouldn't it be better to report a valid region, instead of just the top lines? I think that should be already covered by the driver reporting the valid size regions on enumeration, no?

Regards,
Sergio

> 
>  struct v4l2_subdev_ops {
> @@ -234,6 +245,7 @@ struct v4l2_subdev_ops {
>  	const struct v4l2_subdev_tuner_ops *tuner;
>  	const struct v4l2_subdev_audio_ops *audio;
>  	const struct v4l2_subdev_video_ops *video;
> +	const struct v4l2_subdev_sensor_ops *sensor;
>  };
> 
>  #define V4L2_SUBDEV_NAME_SIZE 32
> --
> 1.6.2.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

