Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42764 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751683AbdIRHfd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 03:35:33 -0400
Date: Mon, 18 Sep 2017 10:35:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 3/3] media: ov7670: Add the s_power operation
Message-ID: <20170918073529.wssxfbgfwgd2jzpl@valkosipuli.retiisi.org.uk>
References: <20170918064514.6841-1-wenyou.yang@microchip.com>
 <20170918064514.6841-4-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918064514.6841-4-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wenyou,

Thanks for the update.

The driver exposes controls that are accessible through the sub-device node
even if the device hasn't been powered on.

Many ISP and bridge drivers will also power the sensor down once the last
user of the user space device nodes disappears. You could keep the device
powered at all times or change the behaviour so that controls can be
accessed when the power is off.

The best option would be to convert the driver to use runtime PM. An
example of this can be found in drivers/media/i2c/ov13858.c .

On Mon, Sep 18, 2017 at 02:45:14PM +0800, Wenyou Yang wrote:
> Add the s_power operation which is responsible for manipulating the
> power dowm mode through the PWDN pin and the reset operation through
> the RESET pin.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> ---
> 
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
>  - Add the patch to support the get_fmt ops.
>  - Remove the redundant invoking ov7670_init_gpio().
> 
>  drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 456f48057605..304abc769a67 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1542,6 +1542,22 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
>  }
>  #endif
>  
> +static int ov7670_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +
> +	if (info->pwdn_gpio)
> +		gpiod_direction_output(info->pwdn_gpio, !on);
> +	if (on && info->resetb_gpio) {
> +		gpiod_set_value(info->resetb_gpio, 1);
> +		usleep_range(500, 1000);
> +		gpiod_set_value(info->resetb_gpio, 0);
> +		usleep_range(3000, 5000);
> +	}
> +
> +	return 0;
> +}
> +
>  static void ov7670_get_default_format(struct v4l2_subdev *sd,
>  				      struct v4l2_mbus_framefmt *format)
>  {
> @@ -1575,6 +1591,7 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
>  	.g_register = ov7670_g_register,
>  	.s_register = ov7670_s_register,
>  #endif
> +	.s_power = ov7670_s_power,
>  };
>  
>  static const struct v4l2_subdev_video_ops ov7670_video_ops = {
> @@ -1692,23 +1709,25 @@ static int ov7670_probe(struct i2c_client *client,
>  	if (ret)
>  		return ret;
>  
> -	ret = ov7670_init_gpio(client, info);
> -	if (ret)
> -		goto clk_disable;
> -
>  	info->clock_speed = clk_get_rate(info->clk) / 1000000;
>  	if (info->clock_speed < 10 || info->clock_speed > 48) {
>  		ret = -EINVAL;
>  		goto clk_disable;
>  	}
>  
> +	ret = ov7670_init_gpio(client, info);
> +	if (ret)
> +		goto clk_disable;
> +
> +	ov7670_s_power(sd, 1);
> +
>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
>  	if (ret) {
>  		v4l_dbg(1, debug, client,
>  			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
>  			client->addr << 1, client->adapter->name);
> -		goto clk_disable;
> +		goto power_off;
>  	}
>  	v4l_info(client, "chip found @ 0x%02x (%s)\n",
>  			client->addr << 1, client->adapter->name);
> @@ -1787,6 +1806,8 @@ static int ov7670_probe(struct i2c_client *client,
>  #endif
>  hdl_free:
>  	v4l2_ctrl_handler_free(&info->hdl);
> +power_off:
> +	ov7670_s_power(sd, 0);
>  clk_disable:
>  	clk_disable_unprepare(info->clk);
>  	return ret;
> @@ -1804,6 +1825,7 @@ static int ov7670_remove(struct i2c_client *client)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	media_entity_cleanup(&info->sd.entity);
>  #endif
> +	ov7670_s_power(sd, 0);
>  	return 0;
>  }
>  
> -- 
> 2.13.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
