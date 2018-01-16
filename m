Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43735 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbeAPODD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:03 -0500
Date: Tue, 16 Jan 2018 15:02:41 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Message-ID: <20180116140241.GA1943@w540>
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-7-git-send-email-jacopo+renesas@jmondi.org>
 <d0249577-ebd5-aa4d-b017-c11fae9c612a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d0249577-ebd5-aa4d-b017-c11fae9c612a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jan 16, 2018 at 11:08:17AM +0100, Hans Verkuil wrote:
> On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> > Remove soc_camera framework dependencies from ov772x sensor driver.
> > - Handle clock and gpios
> > - Register async subdevice
> > - Remove soc_camera specific g/s_mbus_config operations
> > - Change image format colorspace from JPEG to SRGB as the two use the
> >   same colorspace information but JPEG makes assumptions on color
> >   components quantization that do not apply to the sensor
> > - Remove sizes crop from get_selection as driver can't scale
> > - Add kernel doc to driver interface header file
> > - Adjust build system
> >
> > This commit does not remove the original soc_camera based driver as long
> > as other platforms depends on soc_camera-based CEU driver.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> >  static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
> > @@ -855,24 +910,21 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
> >  		struct v4l2_subdev_pad_config *cfg,
> >  		struct v4l2_subdev_selection *sel)
> >  {
> > +	struct ov772x_priv *priv = to_ov772x(sd);
> > +
> >  	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> >  		return -EINVAL;
> >
> > -	sel->r.left = 0;
> > -	sel->r.top = 0;
>
> Why are these two lines removed?
>
> >  	switch (sel->target) {
> >  	case V4L2_SEL_TGT_CROP_BOUNDS:
> >  	case V4L2_SEL_TGT_CROP_DEFAULT:
> > -		sel->r.width = OV772X_MAX_WIDTH;
> > -		sel->r.height = OV772X_MAX_HEIGHT;
> > -		return 0;
> >  	case V4L2_SEL_TGT_CROP:
> > -		sel->r.width = VGA_WIDTH;
> > -		sel->r.height = VGA_HEIGHT;
> > -		return 0;
> > -	default:
> > -		return -EINVAL;
>
> Why is this default case removed?
>

Ooops. I have badly addressed your comment on v1.

Will fix in v6.

> > +		sel->r.width = priv->win->rect.width;
> > +		sel->r.height = priv->win->rect.height;
> > +		break;
> >  	}
> > +
> > +	return 0;
> >  }
> >
> >  static int ov772x_get_fmt(struct v4l2_subdev *sd,
> > @@ -997,24 +1049,8 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
> >  	return 0;
> >  }
> >
> > -static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
> > -				struct v4l2_mbus_config *cfg)
> > -{
> > -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> > -
> > -	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
> > -		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> > -		V4L2_MBUS_DATA_ACTIVE_HIGH;
> > -	cfg->type = V4L2_MBUS_PARALLEL;
> > -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
> > -
> > -	return 0;
> > -}
> > -
> >  static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
> >  	.s_stream	= ov772x_s_stream,
> > -	.g_mbus_config	= ov772x_g_mbus_config,
> >  };
> >
> >  static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
> > @@ -1038,12 +1074,11 @@ static int ov772x_probe(struct i2c_client *client,
> >  			const struct i2c_device_id *did)
> >  {
> >  	struct ov772x_priv	*priv;
> > -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> > -	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
> > +	struct i2c_adapter	*adapter = client->adapter;
> >  	int			ret;
> >
> > -	if (!ssdd || !ssdd->drv_priv) {
> > -		dev_err(&client->dev, "OV772X: missing platform data!\n");
> > +	if (!client->dev.platform_data) {
> > +		dev_err(&client->dev, "Missing OV7725 platform data\n");
>
> Nitpick: I'd prefer lowercase in this string: ov7725. It also should be
> ov772x.
>
> >  		return -EINVAL;
> >  	}
> >
> > @@ -1059,7 +1094,7 @@ static int ov772x_probe(struct i2c_client *client,
> >  	if (!priv)
> >  		return -ENOMEM;
> >
> > -	priv->info = ssdd->drv_priv;
> > +	priv->info = client->dev.platform_data;
> >
> >  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
> >  	v4l2_ctrl_handler_init(&priv->hdl, 3);
> > @@ -1073,22 +1108,42 @@ static int ov772x_probe(struct i2c_client *client,
> >  	if (priv->hdl.error)
> >  		return priv->hdl.error;
> >
> > -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> > +	priv->clk = clk_get(&client->dev, "xclk");
> >  	if (IS_ERR(priv->clk)) {
> > +		dev_err(&client->dev, "Unable to get xclk clock\n");
> >  		ret = PTR_ERR(priv->clk);
> > -		goto eclkget;
> > +		goto error_ctrl_free;
> >  	}
> >
> > -	ret = ov772x_video_probe(priv);
> > -	if (ret < 0) {
> > -		v4l2_clk_put(priv->clk);
> > -eclkget:
> > -		v4l2_ctrl_handler_free(&priv->hdl);
> > -	} else {
> > -		priv->cfmt = &ov772x_cfmts[0];
> > -		priv->win = &ov772x_win_sizes[0];
> > +	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "pwdn",
> > +					     GPIOD_OUT_LOW);
> > +	if (IS_ERR(priv->pwdn_gpio)) {
> > +		dev_info(&client->dev, "Unable to get GPIO \"pwdn\"");
> > +		ret = PTR_ERR(priv->pwdn_gpio);
> > +		goto error_clk_put;
> >  	}
> >
> > +	ret = ov772x_video_probe(priv);
> > +	if (ret < 0)
> > +		goto error_gpio_put;
> > +
> > +	priv->cfmt = &ov772x_cfmts[0];
> > +	priv->win = &ov772x_win_sizes[0];
> > +
> > +	ret = v4l2_async_register_subdev(&priv->subdev);
> > +	if (ret)
> > +		goto error_gpio_put;
> > +
> > +	return 0;
> > +
> > +error_gpio_put:
> > +	if (priv->pwdn_gpio)
> > +		gpiod_put(priv->pwdn_gpio);
> > +error_clk_put:
> > +	clk_put(priv->clk);
> > +error_ctrl_free:
> > +	v4l2_ctrl_handler_free(&priv->hdl);
> > +
> >  	return ret;
> >  }
> >
> > @@ -1096,7 +1151,9 @@ static int ov772x_remove(struct i2c_client *client)
> >  {
> >  	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
> >
> > -	v4l2_clk_put(priv->clk);
> > +	clk_put(priv->clk);
> > +	if (priv->pwdn_gpio)
> > +		gpiod_put(priv->pwdn_gpio);
> >  	v4l2_device_unregister_subdev(&priv->subdev);
> >  	v4l2_ctrl_handler_free(&priv->hdl);
> >  	return 0;
> > @@ -1119,6 +1176,6 @@ static struct i2c_driver ov772x_i2c_driver = {
> >
> >  module_i2c_driver(ov772x_i2c_driver);
> >
> > -MODULE_DESCRIPTION("SoC Camera driver for ov772x");
> > +MODULE_DESCRIPTION("V4L2 driver for OV772x image sensor");
>
> Ditto: lower case ov772x.

Will change both. Thanks.

>
> >  MODULE_AUTHOR("Kuninori Morimoto");
> >  MODULE_LICENSE("GPL v2");
>
> Hmm, shouldn't there be a struct of_device_id as well? So this can be
> used in the device tree?
>
> I see this sensor was only tested with a non-dt platform. Is it possible
> to test this sensor with the GR-Peach platform (which I gather uses the
> device tree)?

I don't have that sensor, I'm sorry. I have it on Migo-R which I'm
accessing and developing on from remote.

>
> Making this driver DT compliant can be done as a follow-up patch.

Adding DT compatibility would imply adding bindings etc.
I can do it later and only compile-test, I assume.

Thanks
   j

>
> > diff --git a/include/media/i2c/ov772x.h b/include/media/i2c/ov772x.h
> > index 00dbb7c..27d087b 100644
> > --- a/include/media/i2c/ov772x.h
> > +++ b/include/media/i2c/ov772x.h
> > @@ -48,8 +48,10 @@ struct ov772x_edge_ctrl {
> >  	.threshold = (t & OV772X_EDGE_THRESHOLD_MASK),	\
> >  }
> >
> > -/*
> > - * ov772x camera info
> > +/**
> > + * ov772x_camera_info -	ov772x driver interface structure
> > + * @flags:		Sensor configuration flags
> > + * @edgectrl:		Sensor edge control
> >   */
> >  struct ov772x_camera_info {
> >  	unsigned long		flags;
> >
>
> Regards,
>
> 	Hans
