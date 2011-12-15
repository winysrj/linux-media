Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOKAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:00:25 -0500
Message-ID: <4EE9C534.7020305@infradead.org>
Date: Thu, 15 Dec 2011 08:00:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 2/2] media: tvp5150: Add mbus_fmt callbacks.
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com> <1323941987-23428-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1323941987-23428-2-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 07:39, Javier Martin wrote:
> These callbacks allow a host video driver
> to poll video supported video formats of tvp5150.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/tvp5150.c |   72 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
> index 26cc75b..8f01f08 100644
> --- a/drivers/media/video/tvp5150.c
> +++ b/drivers/media/video/tvp5150.c
> @@ -778,6 +778,75 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return -EINVAL;
>  }
>  
> +static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
> +{
> +	int val = tvp5150_read(sd, TVP5150_STATUS_REG_5);
> +
> +	switch (val & 0x0F) {
> +	case 0x01:
> +		return V4L2_STD_NTSC;
> +	case 0x03:
> +		return V4L2_STD_PAL;
> +	case 0x05:
> +		return V4L2_STD_PAL_M;
> +	case 0x07:
> +		return V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;
> +	case 0x09:
> +		return V4L2_STD_NTSC_443;
> +	case 0xb:
> +		return V4L2_STD_SECAM;
> +	default:
> +		return V4L2_STD_UNKNOWN;
> +	}
> +}
> +
> +static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
> +						enum v4l2_mbus_pixelcode *code)
> +{
> +	if (index)
> +		return -EINVAL;
> +
> +	*code = V4L2_MBUS_FMT_YUYV8_2X8;
> +	return 0;
> +}
> +
> +static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_mbus_framefmt *f)
> +{
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +	v4l2_std_id std;
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	tvp5150_reset(sd, 0);
> +
> +	/* Calculate height and width based on current standard */
> +	if (decoder->norm == V4L2_STD_ALL)
> +		std = tvp5150_read_std(sd);
> +	else
> +		std = decoder->norm;
> +
> +	if ((std == V4L2_STD_NTSC) || (std == V4L2_STD_NTSC_443) ||
> +		(std == V4L2_STD_PAL_M)) {
> +		f->width = 720;
> +		f->height = 480;
> +	}
> +	if ((std == V4L2_STD_PAL) ||
> +		(std == (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) ||
> +		(std == V4L2_STD_SECAM)) {
> +		f->width = 720;
> +		f->height = 576;
> +	}

The above is wrong, as std is a bitmask. So, userspace can pass more than
one bit set there. It should be, instead:

	f->width = 720;
	if (std & V4L2_STD_525_60)
		f->height = 480;
	else
		f->height = 576;

> +	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
> +	f->field = V4L2_FIELD_SEQ_TB;
> +	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
> +			f->height);
> +	return 0;
> +}
> +
>  /****************************************************************************
>  			I2C Command
>   ****************************************************************************/
> @@ -930,6 +999,9 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
>  
>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
>  	.s_routing = tvp5150_s_routing,
> +	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
> +	.s_mbus_fmt = tvp5150_mbus_fmt,
> +	.try_mbus_fmt = tvp5150_mbus_fmt,
>  };
>  
>  static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {

