Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34212 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbbFNWH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 18:07:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 2/7] v4l2: replace video op g_mbus_fmt by pad op get_fmt
Date: Mon, 15 Jun 2015 01:08:09 +0300
Message-ID: <1988961.x4zUjgPhSL@avalon>
In-Reply-To: <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl> <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

(CC'ing Javier Martin)

On Thursday 09 April 2015 12:21:23 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The g_mbus_fmt video op is a duplicate of the pad op. Replace all uses
> by the get_fmt pad op and remove the video op.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Kamil Debski <k.debski@samsung.com>

[snip]

> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index f2f87b7..e4fa074 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -828,14 +828,18 @@ static int tvp5150_enum_mbus_code(struct v4l2_subdev
> *sd, return 0;
>  }
> 
> -static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
> -			    struct v4l2_mbus_framefmt *f)
> +static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
>  {
> +	struct v4l2_mbus_framefmt *f;
>  	struct tvp5150 *decoder = to_tvp5150(sd);
> 
> -	if (f == NULL)
> +	if (!format || format->pad)
>  		return -EINVAL;
> 
> +	f = &format->format;
> +
>  	tvp5150_reset(sd, 0);

This resets the device every time a get or set format is issued, even for TRY 
formats. I don't think that's right.

Do you have any idea why this is needed ? The code was introduced in commit 
ec2c4f3f93cb ("[media] media: tvp5150: Add mbus_fmt callbacks"), with Javier 
listed as the author but Mauro being the only SoB.

>  	f->width = decoder->rect.width;
> @@ -1069,9 +1073,6 @@ static const struct v4l2_subdev_tuner_ops
> tvp5150_tuner_ops = { static const struct v4l2_subdev_video_ops
> tvp5150_video_ops = {
>  	.s_std = tvp5150_s_std,
>  	.s_routing = tvp5150_s_routing,
> -	.s_mbus_fmt = tvp5150_mbus_fmt,
> -	.try_mbus_fmt = tvp5150_mbus_fmt,
> -	.g_mbus_fmt = tvp5150_mbus_fmt,
>  	.s_crop = tvp5150_s_crop,
>  	.g_crop = tvp5150_g_crop,
>  	.cropcap = tvp5150_cropcap,
> @@ -1086,6 +1087,8 @@ static const struct v4l2_subdev_vbi_ops
> tvp5150_vbi_ops = {
> 
>  static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
>  	.enum_mbus_code = tvp5150_enum_mbus_code,
> +	.set_fmt = tvp5150_fill_fmt,
> +	.get_fmt = tvp5150_fill_fmt,
>  };
> 
>  static const struct v4l2_subdev_ops tvp5150_ops = {

-- 
Regards,

Laurent Pinchart

