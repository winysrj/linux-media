Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54479 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbeHMQzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 12:55:02 -0400
Date: Mon, 13 Aug 2018 16:12:29 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Petr Cvek <petrcvekcz@gmail.com>
Cc: marek.vasut@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v1 4/5] [media] i2c: drop soc_camera code from ov9640 and
 switch to v4l2_async
Message-ID: <20180813141229.cuh64rpbsscb5wzh@apu3b.nibble.pw>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
 <60f150555da249bea9da274ee1e0e30c2d50ca02.1533774451.git.petrcvekcz@gmail.com>
 <20180810075100.GC7060@w540>
 <dcce1f38-83d2-78a7-8337-6fc7857ba75f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dcce1f38-83d2-78a7-8337-6fc7857ba75f@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Petr,

On Sun, Aug 12, 2018 at 03:13:39PM +0200, Petr Cvek wrote:
> Dne 10.8.2018 v 09:51 jacopo mondi napsal(a):
> > Hi Petr,
> > 
> > On Thu, Aug 09, 2018 at 03:39:48AM +0200, petrcvekcz@gmail.com wrote:
> >> From: Petr Cvek <petrcvekcz@gmail.com>
> >>
> >> This patch removes the dependency on an obsoleted soc_camera from ov9640
> >> driver and changes the code to be a standalone v4l2 async subdevice.
> >> It also adds GPIO allocations for power and reset signals (as they are not
> >> handled by soc_camera now).
> >>
> >> The patch should make ov9640 again compatible with the pxa_camera driver.
> > 
> > Are there board files using this driverin mainline ? (git grep says so)
> > Care to port them to use the new driver if necessary? You can have a
> > look at the SH4 Migo-R board, which recently underwent the same
> > process (arch/sh/boards/mach-migor/setup.c)
> > 
> 
> Yes there are Magician and Palm Zire72 which are directly using ov9640
> (and few others which are using pxa_camera with a different sensor). I'm
> working on HTC magician (pxa_camera is not a soc_camera subdev anymore,
> ov9640 still is).
> 
> > I also suggest to adjust the build system in a single patch with this
> > changes, but that's not a big deal...
> > 
> 
> OK (at the end of the patchset I suppose?)
> 

When I did the same soc_camera removal process on other drivers, I
adjusted the build system in the same patch that removed soc_camera
dependencies in the driver.

The process looked like:
01: copy the driver from drivers/media/i2c/soc_camera to
drivers/media/i2c/
02: Remove soc_camera dependencies from the driver and adjust
drivers/media/i2c/Kconfg drivers/media/i2c/Makefile accordingly
03: Port existing users of the soc_camera driver to use the new one

I guess patch ordering is not a big deal though ;)

Thanks
  j

> > 
> >> +		ret = v4l2_clk_enable(priv->clk);
> > 
> > Is this required by the pxa camera driver using v4l2_clk_ APIs?
> > Otherwise you should use the clk API directly.
> > 
> 
> Yes the clock is registered by pxa camera with v4l2_clk_register(). I
> will probably get to that in the future, but there is stuff (bugs, dead
> code from soc_camera removal, ...) with more priority in the driver for now.
> 
> 
> >> +		mdelay(1);
> >> +		gpiod_set_value(priv->gpio_reset, 0);
> >> +	} else {
> >> +		gpiod_set_value(priv->gpio_reset, 1);
> >> +		mdelay(1);
> >> +		v4l2_clk_disable(priv->clk);
> >> +		mdelay(1);
> >> +		gpiod_set_value(priv->gpio_power, 0);
> >> +	}
> >> +	return ret;
> >>  }
> >>
> >>  /* select nearest higher resolution for capture */
> >> @@ -631,14 +648,10 @@ static const struct v4l2_subdev_core_ops ov9640_core_ops = {
> >>  static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
> >>  				struct v4l2_mbus_config *cfg)
> > 
> > g_mbus/s_mbus are deprecated. Unless the pxa camera driver wants them
> > all format negotiation should go through s_fmt/g_fmt pad operations
> > 
> 
> Yeah it does:
> 
>   ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
> 
> 
> >>  {
> >> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> >> -
> >>  	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
> >>  		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> >>  		V4L2_MBUS_DATA_ACTIVE_HIGH;
> >>  	cfg->type = V4L2_MBUS_PARALLEL;
> >> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
> >>
> >>  	return 0;
> >>  }
> >> @@ -667,18 +680,27 @@ static int ov9640_probe(struct i2c_client *client,
> >>  			const struct i2c_device_id *did)
> >>  {
> >>  	struct ov9640_priv *priv;
> >> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> >>  	int ret;
> >>
> >> -	if (!ssdd) {
> >> -		dev_err(&client->dev, "Missing platform_data for driver\n");
> >> -		return -EINVAL;
> >> -	}
> >> -
> >> -	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
> >> +	priv = devm_kzalloc(&client->dev, sizeof(*priv),
> >> +			    GFP_KERNEL);
> >>  	if (!priv)
> >>  		return -ENOMEM;
> >>
> >> +	priv->gpio_power = devm_gpiod_get(&client->dev, "Camera power",
> >> +					  GPIOD_OUT_LOW);
> >> +	if (IS_ERR_OR_NULL(priv->gpio_power)) {
> >> +		ret = PTR_ERR(priv->gpio_power);
> >> +		return ret;
> >> +	}
> >> +
> >> +	priv->gpio_reset = devm_gpiod_get(&client->dev, "Camera reset",
> >> +					  GPIOD_OUT_HIGH);
> >> +	if (IS_ERR_OR_NULL(priv->gpio_reset)) {
> >> +		ret = PTR_ERR(priv->gpio_reset);
> >> +		return ret;
> >> +	}
> >> +
> >>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
> >>
> >>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
> >> @@ -692,17 +714,25 @@ static int ov9640_probe(struct i2c_client *client,
> >>
> >>  	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> >>  	if (IS_ERR(priv->clk)) {
> >> -		ret = PTR_ERR(priv->clk);
> >> +		ret = -EPROBE_DEFER;
> > 
> > Why are you forcing EPROBE_DEFER instead of returning the clk_get()
> > return value?
> > 
> 
> That may be residue from testing, I will fix that.
> 
> Petr
