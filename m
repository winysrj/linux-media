Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2680 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0KSNmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:42:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
Date: Fri, 19 Nov 2010 14:42:31 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191442.31982.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday 19 November 2010 14:26:42 Laurent Pinchart wrote:
> Some buggy sensors generate corrupt frames when the stream is started.
> This new operation returns the number of corrupt frames to skip when
> starting the stream.

Looks OK, but perhaps the two should be combined to one function?

I also have my doubts about the sensor_ops in general. I expected originally
to see a lot of ops here, but apparently there is little or no need for it.

Do we expect to see this grow, or would it make more sense to move the ops
to video_ops? I'd be interested to hear what sensor specialists think.

Regards.

	Hans

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
>  };
>  
>  struct v4l2_subdev_ops {
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
