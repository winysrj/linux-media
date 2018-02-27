Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34230 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbeB0ODz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 09:03:55 -0500
Date: Tue, 27 Feb 2018 15:03:51 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH 2/2] media: tw9910: solve coding style issues
Message-ID: <20180227140350.GB23738@w540>
References: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
 <876e32e5dd6e08320288862440e3e8a9542b5d9b.1519655282.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <876e32e5dd6e08320288862440e3e8a9542b5d9b.1519655282.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
   thanks for doing this.

I didn't dare to touch this driver style issues as it was mainline
already, but since you addressed this I now would have more changes to
apply...

On Mon, Feb 26, 2018 at 09:28:08AM -0500, Mauro Carvalho Chehab wrote:
> As we're adding this as a new driver, make checkpatch happier by
> solving several style issues, using --fix-inplace at strict mode.
>
> Some issues required manual work.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/tw9910.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)

[snip]

>
>  	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
> @@ -532,16 +533,16 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
>  	}
>  	if (!ret)
>  		ret = i2c_smbus_write_byte_data(client, CROP_HI,
> -			((vdelay >> 2) & 0xc0) |
> +						((vdelay >> 2) & 0xc0) |
>  			((vact >> 4) & 0x30) |
>  			((hdelay >> 6) & 0x0c) |
>  			((hact >> 8) & 0x03));

If you move the first line, all the following ones should be be moved
too.

I can send a few patches more on top of this two, to address this and
a few other style issues on this driver.

Would this work for you?

Thanks
  j

>  	if (!ret)
>  		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
> -			vdelay & 0xff);
> +						vdelay & 0xff);
>  	if (!ret)
>  		ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
> -			vact & 0xff);
> +						vact & 0xff);
>
>  	return ret;
>  }
> @@ -731,7 +732,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
>  }
>
>  static int tw9910_get_selection(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_selection *sel)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -756,7 +757,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
>  }
>
>  static int tw9910_get_fmt(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *mf = &format->format;
> @@ -807,7 +808,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
>  }
>
>  static int tw9910_set_fmt(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *mf = &format->format;
> @@ -818,9 +819,9 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
>  	if (format->pad)
>  		return -EINVAL;
>
> -	if (V4L2_FIELD_ANY == mf->field) {
> +	if (mf->field == V4L2_FIELD_ANY) {
>  		mf->field = V4L2_FIELD_INTERLACED_BT;
> -	} else if (V4L2_FIELD_INTERLACED_BT != mf->field) {
> +	} else if (mf->field != V4L2_FIELD_INTERLACED_BT) {
>  		dev_err(&client->dev, "Field type %d invalid.\n", mf->field);
>  		return -EINVAL;
>  	}
> @@ -870,8 +871,7 @@ static int tw9910_video_probe(struct i2c_client *client)
>  	priv->revision = GET_REV(id);
>  	id = GET_ID(id);
>
> -	if (0x0B != id ||
> -	    0x01 < priv->revision) {
> +	if (id != 0x0b || priv->revision > 0x01) {
>  		dev_err(&client->dev,
>  			"Product ID error %x:%x\n",
>  			id, priv->revision);
> @@ -899,7 +899,7 @@ static const struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
>  };
>
>  static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_mbus_code_enum *code)
>  {
>  	if (code->pad || code->index)
> --
> 2.14.3
>
