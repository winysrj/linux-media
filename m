Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57056 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731683AbeKVXA6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 18:00:58 -0500
Date: Thu, 22 Nov 2018 14:21:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 03/14] media: ov7670: hook s_power onto v4l2 core
Message-ID: <20181122122146.a6wydozsg676i3w7@valkosipuli.retiisi.org.uk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
 <20181120100318.367987-4-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120100318.367987-4-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lubomir,

On Tue, Nov 20, 2018 at 11:03:08AM +0100, Lubomir Rintel wrote:
> The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function")
> added a power control routing. However, it was not good enough to use as
> a s_power() callback: it merely flipped on the power GPIOs without
> restoring the register settings.
> 
> Fix this now and register an actual power callback.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> ---
> Changes since v2:
> - Restore the controls, format and frame rate on power on
> 
>  drivers/media/i2c/ov7670.c | 50 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index ead0c360df33..cbaab60aaaac 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -242,6 +242,7 @@ struct ov7670_info {
>  	struct ov7670_format_struct *fmt;  /* Current format */
>  	struct ov7670_win_size *wsize;
>  	struct clk *clk;
> +	int on;
>  	struct gpio_desc *resetb_gpio;
>  	struct gpio_desc *pwdn_gpio;
>  	unsigned int mbus_config;	/* Media bus configuration flags */
> @@ -1615,19 +1616,54 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
>  }
>  #endif
>  
> -static int ov7670_s_power(struct v4l2_subdev *sd, int on)
> +static void ov7670_power_on(struct v4l2_subdev *sd)
>  {
>  	struct ov7670_info *info = to_state(sd);
>  
> +	if (info->on)
> +		return;
> +
>  	if (info->pwdn_gpio)
> -		gpiod_set_value(info->pwdn_gpio, !on);
> -	if (on && info->resetb_gpio) {
> +		gpiod_set_value(info->pwdn_gpio, 0);
> +	if (info->resetb_gpio) {
>  		gpiod_set_value(info->resetb_gpio, 1);
>  		usleep_range(500, 1000);
>  		gpiod_set_value(info->resetb_gpio, 0);
>  		usleep_range(3000, 5000);
>  	}
>  
> +	info->on = true;
> +}
> +
> +static void ov7670_power_off(struct v4l2_subdev *sd)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +
> +	if (!info->on)
> +		return;
> +
> +	if (info->pwdn_gpio)
> +		gpiod_set_value(info->pwdn_gpio, 1);
> +
> +	info->on = false;
> +}
> +
> +static int ov7670_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +
> +	if (info->on == on)
> +		return 0;
> +
> +	if (on) {
> +		ov7670_power_on (sd);
> +		ov7670_apply_fmt(sd);
> +		ov7675_apply_framerate(sd);
> +		v4l2_ctrl_handler_setup(&info->hdl);
> +	} else {
> +		ov7670_power_off (sd);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1660,6 +1696,7 @@ static int ov7670_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  static const struct v4l2_subdev_core_ops ov7670_core_ops = {
>  	.reset = ov7670_reset,
>  	.init = ov7670_init,
> +	.s_power = ov7670_s_power,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.g_register = ov7670_g_register,
>  	.s_register = ov7670_s_register,
> @@ -1825,6 +1862,7 @@ static int ov7670_probe(struct i2c_client *client,
>  		else
>  			return ret;
>  	}
> +
>  	if (info->clk) {
>  		ret = clk_prepare_enable(info->clk);
>  		if (ret)
> @@ -1841,7 +1879,7 @@ static int ov7670_probe(struct i2c_client *client,
>  	if (ret)
>  		goto clk_disable;
>  
> -	ov7670_s_power(sd, 1);
> +	ov7670_power_on(sd);
>  
>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
> @@ -1929,7 +1967,7 @@ static int ov7670_probe(struct i2c_client *client,
>  hdl_free:
>  	v4l2_ctrl_handler_free(&info->hdl);
>  power_off:
> -	ov7670_s_power(sd, 0);
> +	ov7670_power_off(sd);
>  clk_disable:
>  	clk_disable_unprepare(info->clk);
>  	return ret;
> @@ -1945,7 +1983,7 @@ static int ov7670_remove(struct i2c_client *client)
>  	v4l2_ctrl_handler_free(&info->hdl);
>  	clk_disable_unprepare(info->clk);
>  	media_entity_cleanup(&info->sd.entity);
> -	ov7670_s_power(sd, 0);
> +	ov7670_power_off(sd);
>  	return 0;
>  }
>  

Could you consider instead switching to runtime PM? A few drivers such as
the ov2685 driver does that already.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
