Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1I3K2h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 06:28:37 -0400
Message-ID: <4E8599CF.1040402@redhat.com>
Date: Fri, 30 Sep 2011 07:28:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christian Gmeiner <christian.gmeiner@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Make use of media bus pixel codes in adv7175 driver
References: <CAH9NwWdkc20XQXPB4VmT1vf+kGWZWmuA0JPomEKO5ERjdbAn6Q@mail.gmail.com>
In-Reply-To: <CAH9NwWdkc20XQXPB4VmT1vf+kGWZWmuA0JPomEKO5ERjdbAn6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-09-2011 16:16, Christian Gmeiner escreveu:
> The ADV7175A/ADV7176A can operate in either 8-bit or 16-bit YCrCb mode.
> 
> * 8-Bit YCrCb Mode
> This default mode accepts multiplexed YCrCb inputs through
> the P7-P0 pixel inputs. The inputs follow the sequence Cb0, Y0
> Cr0, Y1 Cb1, Y2, etc. The Y, Cb and Cr data are input on a
> rising clock edge.
> 
> * 16-Bit YCrCb Mode
> This mode accepts Y inputs through the P7–P0 pixel inputs and
> multiplexed CrCb inputs through the P15–P8 pixel inputs. The
> data is loaded on every second rising edge of CLOCK. The inputs
> follow the sequence Cb0, Y0 Cr0, Y1 Cb1, Y2, etc.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
> diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
> index d2327db..206078e 100644
> --- a/drivers/media/video/adv7175.c
> +++ b/drivers/media/video/adv7175.c
> @@ -61,6 +61,11 @@ static inline struct adv7175 *to_adv7175(struct
> v4l2_subdev *sd)

Patch looks ok, but it got truncated by your emailer [1]... Couldn't apply it
[1] http://patchwork.linuxtv.org/patch/7973/

Care to fix it and re-send?

Thanks!
Mauro

> 
>  static char *inputs[] = { "pass_through", "play_back", "color_bar" };
> 
> +static enum v4l2_mbus_pixelcode adv7175_codes[] = {
> +	V4L2_MBUS_FMT_UYVY8_2X8,
> +	V4L2_MBUS_FMT_UYVY8_1X16,
> +};
> +
>  /* ----------------------------------------------------------------------- */
> 
>  static inline int adv7175_write(struct v4l2_subdev *sd, u8 reg, u8 value)
> @@ -296,6 +301,60 @@ static int adv7175_s_routing(struct v4l2_subdev *sd,
>  	return 0;
>  }
> 
> +static int adv7175_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
> +				enum v4l2_mbus_pixelcode *code)
> +{
> +	if (index >= ARRAY_SIZE(adv7175_codes))
> +		return -EINVAL;
> +
> +	*code = adv7175_codes[index];
> +	return 0;
> +}
> +
> +static int adv7175_g_fmt(struct v4l2_subdev *sd,
> +				struct v4l2_mbus_framefmt *mf)
> +{
> +	u8 val = adv7175_read(sd, 0x7);
> +
> +	if ((val & 0x40) == (1 << 6))
> +		mf->code = V4L2_MBUS_FMT_UYVY8_1X16;
> +	else
> +		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
> +
> +	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
> +	mf->width       = 0;
> +	mf->height      = 0;
> +	mf->field       = V4L2_FIELD_ANY;
> +
> +	return 0;
> +}
> +
> +static int adv7175_s_fmt(struct v4l2_subdev *sd,
> +				struct v4l2_mbus_framefmt *mf)
> +{
> +	u8 val = adv7175_read(sd, 0x7);
> +	int ret;
> +
> +	switch (mf->code) {
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +		val &= ~0x40;
> +		break;
> +
> +	case V4L2_MBUS_FMT_UYVY8_1X16:
> +		val |= 0x40;
> +		break;
> +
> +	default:
> +		v4l2_dbg(1, debug, sd,
> +			"illegal v4l2_mbus_framefmt code: %d\n", mf->code);
> +		return -EINVAL;
> +	}
> +
> +	ret = adv7175_write(sd, 0x7, val);
> +
> +	return ret;
> +}
> +
>  static int adv7175_g_chip_ident(struct v4l2_subdev *sd, struct
> v4l2_dbg_chip_ident *chip)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -324,6 +383,9 @@ static const struct v4l2_subdev_core_ops
> adv7175_core_ops = {
>  static const struct v4l2_subdev_video_ops adv7175_video_ops = {
>  	.s_std_output = adv7175_s_std_output,
>  	.s_routing = adv7175_s_routing,
> +	.s_mbus_fmt = adv7175_s_fmt,
> +	.g_mbus_fmt = adv7175_g_fmt,
> +	.enum_mbus_fmt  = adv7175_enum_fmt,
>  };
> 
>  static const struct v4l2_subdev_ops adv7175_ops = {
> --
> 1.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

