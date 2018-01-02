Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50952 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbeABPuS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 10:50:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 9/9] media: i2c: tw9910: Remove soc_camera dependencies
Date: Tue, 02 Jan 2018 17:50:38 +0200
Message-ID: <3834014.tgMKCuKOQE@avalon>
In-Reply-To: <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 28 December 2017 16:01:21 EET Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from tw9910 sensor driver.
> - Handle clock and gpios
> - Register async subdevice
> - Remove soc_camera specific g/s_mbus_config operations
> - Add kernel doc to driver interface header file
> - Adjust build system
> 
> This commit does not remove the original soc_camera based driver as long
> as other platforms depends on soc_camera-based CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/Kconfig  |   9 +++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/tw9910.c | 158 ++++++++++++++++++++++++++---------------
>  include/media/i2c/tw9910.h |   9 +++
>  4 files changed, 116 insertions(+), 61 deletions(-)

[snip]

> diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> index bdb5e0a..efbdebe 100644
> --- a/drivers/media/i2c/tw9910.c
> +++ b/drivers/media/i2c/tw9910.c

[snip]

> @@ -799,8 +848,8 @@ static int tw9910_video_probe(struct i2c_client *client)
> /*
>  	 * tw9910 only use 8 or 16 bit bus width
>  	 */
> -	if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&
> -	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> +	if (priv->info->buswidth != 16 &&
> +	    priv->info->buswidth != 8) {

No need for a line break.

>  		dev_err(&client->dev, "bus width error\n");
>  		return -ENODEV;
>  	}

[snip]

> @@ -959,13 +966,37 @@ static int tw9910_probe(struct i2c_client *client,
> 
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
> 
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> -	if (IS_ERR(priv->clk))
> +	priv->clk = clk_get(&client->dev, "mclk");

The clock signal is called XTI (see page 60 of http://www.tecworth.com/
administrator/upload/200956419240864.pdf). You should add a clock alias as for 
the ov7725.

> +	if (PTR_ERR(priv->clk) == -ENOENT) {
> +		priv->clk = NULL;
> +	} else if (IS_ERR(priv->clk)) {
> +		dev_err(&client->dev, "Unable to get mclk clock\n");
>  		return PTR_ERR(priv->clk);
> +	}
> +
> +	priv->pdn_gpio = gpiod_get_optional(&client->dev, "pdn",
> +					    GPIOD_OUT_HIGH);
> +	if (IS_ERR(priv->pdn_gpio)) {
> +		dev_info(&client->dev, "Unable to get GPIO \"pdn\"");
> +		ret = PTR_ERR(priv->pdn_gpio);
> +		goto error_clk_put;
> +	}
> 
>  	ret = tw9910_video_probe(client);
>  	if (ret < 0)
> -		v4l2_clk_put(priv->clk);
> +		goto error_gpio_put;
> +
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret)
> +		goto error_gpio_put;
> +
> +	return ret;
> +
> +error_gpio_put:
> +	if (priv->pdn_gpio)
> +		gpiod_put(priv->pdn_gpio);
> +error_clk_put:
> +	clk_put(priv->clk);
> 
>  	return ret;
>  }

[snip]

With these small issues fixed, and the comments to ov7725 that apply to tw9910 
addressed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
