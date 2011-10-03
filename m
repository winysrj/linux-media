Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32939 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JCLO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 07:14:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 8/9] V4L: mt9t112: add pad level operations
Date: Mon, 3 Oct 2011 13:14:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deepthy Ravi <deepthy.ravi@ti.com>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de> <1317313137-4403-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-9-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110031314.37234.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Thursday 29 September 2011 18:18:56 Guennadi Liakhovetski wrote:
> On Media Controller enabled systems this patch allows the user to
> communicate with the driver directly over /dev/v4l-subdev* device nodes
> using VIDIOC_SUBDEV_* ioctl()s.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

[snip]

> diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> index 32114a3..bb95ad1 100644
> --- a/drivers/media/video/mt9t112.c
> +++ b/drivers/media/video/mt9t112.c

[snip]

> @@ -739,8 +741,7 @@ static int mt9t112_init_camera(const struct i2c_client
> *client) static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct mt9t112_priv *priv = to_mt9t112(client);
> +	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv,
> subdev);

What about modifying to_mt9t112() to take a subdev pointer, or possibly 
creating a sd_to_mt9t112() ?

>  	id->ident    = priv->model;
>  	id->revision = 0;

[snip]

> @@ -1018,14 +1015,67 @@ static struct v4l2_subdev_video_ops

[snip]

> +static int mt9t112_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh, +			   struct v4l2_subdev_format *sd_fmt)
> +{
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return mt9t112_s_fmt(sd, &sd_fmt->format);
> +
> +	mf = v4l2_subdev_get_try_format(fh, sd_fmt->pad);
> +	*mf = sd_fmt->format;
> +	return mt9t112_try_fmt(sd, mf);

I think the code would be clea[nr]er if you split mt9t112_s_fmt() into try and 
set, and called try unconditionally in mt9t112_set_fmt().

> +}
> +
> +struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
> +	.enum_mbus_code	= mt9t112_enum_mbus_code,
> +	.get_fmt	= mt9t112_get_fmt,
> +	.set_fmt	= mt9t112_set_fmt,

Having bot mt9t112_[gs]_fmt and mt9t112_[gs]et_fmt looks confusing to me. What 
about renaming the later mt9t112_[gs]et_pad_fmt ?

> +};
> +
>  static struct v4l2_subdev_ops mt9t112_subdev_ops = {
>  	.core	= &mt9t112_subdev_core_ops,
>  	.video	= &mt9t112_subdev_video_ops,
> +	.pad	= &mt9t112_subdev_pad_ops,
>  };
> 
> +static int mt9t112_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
> +	return mf ? mt9t112_try_fmt(sd, mf) : 0;

Can mf be NULL ?

> +}

-- 
Regards,

Laurent Pinchart
