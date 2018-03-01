Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:52461 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161033AbeCATCQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 14:02:16 -0500
Date: Thu, 1 Mar 2018 20:02:12 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: tw9910: Whitespace alignment
Message-ID: <20180301190212.GD1641@w540>
References: <2601b3771b35242dba70e1a9e50b2f2bc3dd41d8.1519904988.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2601b3771b35242dba70e1a9e50b2f2bc3dd41d8.1519904988.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

On Thu, Mar 01, 2018 at 03:50:22AM -0800, Joe Perches wrote:
> Update multiline statements to open parenthesis.
> Update a ?: to a single line.

Thanks for the cleanup.
You may want to rebase this on my series from a few days ago

https://patchwork.linuxtv.org/patch/47475/

which includes some of the changes you made here and in patch
[PATCH] media: tw9910: Miscellaneous neatening

or the other way around and I should rebase mine on these two patches.

Thanks
   j

>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/i2c/tw9910.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> index cc5d383fc6b8..ab32cd81ebd0 100644
> --- a/drivers/media/i2c/tw9910.c
> +++ b/drivers/media/i2c/tw9910.c
> @@ -445,7 +445,7 @@ static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
>
>  	for (i = 0; i < size; i++) {
>  		tmp = abs(width - scale[i].width) +
> -			abs(height - scale[i].height);
> +		      abs(height - scale[i].height);
>  		if (tmp < diff) {
>  			diff = tmp;
>  			ret = scale + i;
> @@ -534,9 +534,9 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
>  	if (!ret)
>  		ret = i2c_smbus_write_byte_data(client, CROP_HI,
>  						((vdelay >> 2) & 0xc0) |
> -			((vact >> 4) & 0x30) |
> -			((hdelay >> 6) & 0x0c) |
> -			((hact >> 8) & 0x03));
> +						((vact >> 4) & 0x30) |
> +						((hdelay >> 6) & 0x0c) |
> +						((hact >> 8) & 0x03));
>  	if (!ret)
>  		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
>  						vdelay & 0xff);
> @@ -642,8 +642,7 @@ static int tw9910_s_power(struct v4l2_subdev *sd, int on)
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>
> -	return on ? tw9910_power_on(priv) :
> -		    tw9910_power_off(priv);
> +	return on ? tw9910_power_on(priv) : tw9910_power_off(priv);
>  }
>
>  static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
> @@ -733,7 +732,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
>
>  static int tw9910_get_selection(struct v4l2_subdev *sd,
>  				struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_selection *sel)
> +				struct v4l2_subdev_selection *sel)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
> @@ -758,7 +757,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
>
>  static int tw9910_get_fmt(struct v4l2_subdev *sd,
>  			  struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_format *format)
> +			  struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -809,7 +808,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
>
>  static int tw9910_set_fmt(struct v4l2_subdev *sd,
>  			  struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_format *format)
> +			  struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -900,7 +899,7 @@ static const struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
>
>  static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
>  				 struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_mbus_code_enum *code)
> +				 struct v4l2_subdev_mbus_code_enum *code)
>  {
>  	if (code->pad || code->index)
>  		return -EINVAL;
> --
> 2.15.0
>
