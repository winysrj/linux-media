Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50933 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbeABPno (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 10:43:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] media: i2c: ov772x: Remove soc_camera dependencies
Date: Tue, 02 Jan 2018 17:44:03 +0200
Message-ID: <5703631.yJ335LfYLI@avalon>
In-Reply-To: <1514469681-15602-8-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-8-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 28 December 2017 16:01:19 EET Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from ov772x sensor driver.
> - Handle clock and gpios
> - Register async subdevice
> - Remove soc_camera specific g/s_mbus_config operations
> - Change image format colorspace to SRGB

Could you explain the rationale for this ?

> - Remove sizes crop from get_selection as driver can't scale
> - Add kernel doc to driver interface header file
> - Adjust build system

That's a lot for a single patch. On the other hand I don't think splitting 
this in 7 patches would be a good idea either. If you can find a better 
granularity, go for it, otherwise keep it as-is. Same comment for the tw9910 
driver.

> This commit does not remove the original soc_camera based driver as long
> as other platforms depends on soc_camera-based CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/Kconfig  |  11 +++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/ov772x.c | 169 ++++++++++++++++++++++++++++-------------
>  include/media/i2c/ov772x.h |   8 ++-
>  4 files changed, 130 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index cb5d7ff..a61d7f4 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig

[snip]

> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 8063835..f7b293f 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1,6 +1,9 @@

[snip]

> @@ -25,8 +26,8 @@
>  #include <linux/videodev2.h>
> 
>  #include <media/i2c/ov772x.h>
> -#include <media/soc_camera.h>
> -#include <media/v4l2-clk.h>
> +
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>

I think C comes before D.

>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-image-sizes.h>

[snip]

> @@ -650,13 +653,63 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
> 
> +static int ov772x_power_on(struct ov772x_priv *priv)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	int ret;
> +
> +	if (priv->info->xclk_rate)
> +		ret = clk_set_rate(priv->clk, priv->info->xclk_rate);

The return value is then ignored.

I wonder whether the clk_set_rate() call shouldn't be kept in board code as 
it's a board-specific frequency. DT platforms would use the assigned-clock-
rates property that doesn't require any explicit handling in the driver.

> +	if (priv->clk) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->pwdn_gpio) {
> +		gpiod_set_value(priv->pwdn_gpio, 1);
> +		usleep_range(500, 1000);
> +	}
> +
> +	/* Reset GPIOs are shared in some platforms. */

I'd make this a FIXME comment as this is really a hack.

	/*
	 * FIXME: The reset signal is connected to a shared GPIO on some
	 * platforms (namely the SuperH Migo-R). Until a framework becomes
	 * available to handle this cleanly, request the GPIO temporarily
	 * only to avoid conflicts.
	 */

Same for the tw9910 driver.

> +	priv->rstb_gpio = gpiod_get_optional(&client->dev, "rstb",
> +					     GPIOD_OUT_LOW);
> +	if (IS_ERR(priv->rstb_gpio)) {
> +		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
> +		return PTR_ERR(priv->rstb_gpio);
> +	}
> +
> +	if (priv->rstb_gpio) {
> +		gpiod_set_value(priv->rstb_gpio, 0);
> +		usleep_range(500, 1000);
> +		gpiod_set_value(priv->rstb_gpio, 1);
> +		usleep_range(500, 1000);
> +
> +		gpiod_put(priv->rstb_gpio);
> +	}
> +
> +	return 0;
> +}

[snip]

--
Regards,

Laurent Pinchart
