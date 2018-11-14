Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:40031 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbeKOAjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 19:39:05 -0500
Subject: Re: [PATCH v2 02/11] media: ov7670: control clock along with power
To: Lubomir Rintel <lkundrak@v3.sk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
References: <20181112003520.577592-1-lkundrak@v3.sk>
 <20181112003520.577592-3-lkundrak@v3.sk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <13adbb92-1815-a7ac-f8df-6b1b05ca9527@xs4all.nl>
Date: Wed, 14 Nov 2018 15:35:27 +0100
MIME-Version: 1.0
In-Reply-To: <20181112003520.577592-3-lkundrak@v3.sk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/18 01:35, Lubomir Rintel wrote:
> This provides more power saving when the sensor is off.
> 
> While at that, do the delay on power/clock enable even if the sensor driver
> itself doesn't control the GPIOs. This is required for the OLPC XO-1
> platform, that lacks the proper power/reset properties in its DT, but
> needs the delay after the sensor is clocked up.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/media/i2c/ov7670.c | 37 +++++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index d87f2362bf40..a3e72c62382c 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -241,6 +241,7 @@ struct ov7670_info {
>  	struct v4l2_mbus_framefmt format;
>  	struct ov7670_format_struct *fmt;  /* Current format */
>  	struct clk *clk;
> +	int on;
>  	struct gpio_desc *resetb_gpio;
>  	struct gpio_desc *pwdn_gpio;
>  	unsigned int mbus_config;	/* Media bus configuration flags */
> @@ -1610,15 +1611,26 @@ static int ov7670_s_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct ov7670_info *info = to_state(sd);
>  
> +	if (info->on == on)
> +		return 0;
> +
> +	if (on)
> +		clk_prepare_enable(info->clk);
> +	else
> +		clk_disable_unprepare(info->clk);
> +
>  	if (info->pwdn_gpio)
>  		gpiod_set_value(info->pwdn_gpio, !on);
>  	if (on && info->resetb_gpio) {
>  		gpiod_set_value(info->resetb_gpio, 1);
>  		usleep_range(500, 1000);
>  		gpiod_set_value(info->resetb_gpio, 0);
> -		usleep_range(3000, 5000);
>  	}
>  
> +	if (on && (info->pwdn_gpio || info->resetb_gpio || info->clk))
> +		usleep_range(3000, 5000);
> +
> +	info->on = on;

I assume that when powered off all control settings (brightness etc) are
lost. That means that when it is powered on you should call
v4l2_ctrl_handler_setup() to re-init the control-related registers.

The same might be the case with ov7670_set_fmt and the framerate functions.

Basically the state has to be preserved across power on -> off -> on
transitions.

Regards,

	Hans

>  	return 0;
>  }
>  
> @@ -1817,24 +1829,20 @@ static int ov7670_probe(struct i2c_client *client,
>  		else
>  			return ret;
>  	}
> -	if (info->clk) {
> -		ret = clk_prepare_enable(info->clk);
> -		if (ret)
> -			return ret;
> +	ret = ov7670_init_gpio(client, info);
> +	if (ret)
> +		return ret;
> +
> +	ov7670_s_power(sd, 1);
>  
> +	if (info->clk) {
>  		info->clock_speed = clk_get_rate(info->clk) / 1000000;
>  		if (info->clock_speed < 10 || info->clock_speed > 48) {
>  			ret = -EINVAL;
> -			goto clk_disable;
> +			goto power_off;
>  		}
>  	}
>  
> -	ret = ov7670_init_gpio(client, info);
> -	if (ret)
> -		goto clk_disable;
> -
> -	ov7670_s_power(sd, 1);
> -
>  	/* Make sure it's an ov7670 */
>  	ret = ov7670_detect(sd);
>  	if (ret) {
> @@ -1913,6 +1921,7 @@ static int ov7670_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto entity_cleanup;
>  
> +	ov7670_s_power(sd, 0);
>  	return 0;
>  
>  entity_cleanup:
> @@ -1921,12 +1930,9 @@ static int ov7670_probe(struct i2c_client *client,
>  	v4l2_ctrl_handler_free(&info->hdl);
>  power_off:
>  	ov7670_s_power(sd, 0);
> -clk_disable:
> -	clk_disable_unprepare(info->clk);
>  	return ret;
>  }
>  
> -
>  static int ov7670_remove(struct i2c_client *client)
>  {
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> @@ -1934,7 +1940,6 @@ static int ov7670_remove(struct i2c_client *client)
>  
>  	v4l2_async_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&info->hdl);
> -	clk_disable_unprepare(info->clk);
>  	media_entity_cleanup(&info->sd.entity);
>  	ov7670_s_power(sd, 0);
>  	return 0;
> 
