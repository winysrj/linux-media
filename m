Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3027 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbZFQKiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 06:38:10 -0400
Message-ID: <10860.62.70.2.252.1245235091.squirrel@webmail.xs4all.nl>
Date: Wed, 17 Jun 2009 12:38:11 +0200 (CEST)
Subject: Re: [PATCH] v4l: add cropping prototypes to struct
     v4l2_subdev_video_ops
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Add g_crop, s_crop and cropcap methods to video v4l2-subdev operations.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Hans, is this all that's needed?

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

       Hans

>
>  include/media/v4l2-subdev.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1785608..673a4e1 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -215,6 +215,9 @@ struct v4l2_subdev_video_ops {
>  	int (*g_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
>  	int (*try_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
>  	int (*s_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
> +	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
> +	int (*g_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
> +	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
>  	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum
> *fsize);
> --
> 1.6.2.4
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

