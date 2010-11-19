Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:38829 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751856Ab0KSNti (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:49:38 -0500
Date: Fri, 19 Nov 2010 14:49:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
In-Reply-To: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1011191439030.20751@axis700.grange>
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 19 Nov 2010, Laurent Pinchart wrote:

> Some buggy sensors generate corrupt frames when the stream is started.
> This new operation returns the number of corrupt frames to skip when
> starting the stream.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 04878e1..b196966 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -291,9 +291,13 @@ struct v4l2_subdev_pad_ops {
>   *		      This is needed for some sensors, which always corrupt
>   *		      several top lines of the output image, or which send their
>   *		      metadata in them.
> + * @g_skip_frames: number of frames to skip at stream start. This is needed for
> + * 		   buggy sensors that generate faulty frames when they are
> + * 		   turned on.
>   */
>  struct v4l2_subdev_sensor_ops {
>  	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> +	int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);

Well, yes, this would be useful, but, I think, it is a part of a larger 
problem - general video quality from sensors. Like, I think, there are 
other situations, when the sensor driver knows, that the next few frames 
will be of poor quality. E.g., when changing some parameters, which will 
make the sensor re-adjust auto-exposure, auto-gain or something similar. 
So, we can either just handle this one specific case, or try to design a 
more generic approach, or leave frame quality analysis completely to the 
user-space. Like - for a normal generic mplayer, just streaming video to 
an output device - you don't really care in most cases. If recording video 
- you edit it afterwords, if building an industrial quality 
purpose-designed application - it will, probably, take care of these 
things itself. And yes, there is also out-of-band data, that can carry 
such quality-related information. So, this is just one bit of a bigger 
problem, no idea though, wheather it's worth trying to tackle all those 
issues at once or better just fix this one small specific problem.

>  };
>  
>  struct v4l2_subdev_ops {
> -- 
> 1.7.2.2

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
