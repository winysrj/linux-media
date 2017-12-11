Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57448 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdLKOzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 09:55:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 10/10] media: i2c: tw9910: Remove soc_camera dependencies
Date: Mon, 11 Dec 2017 16:55:04 +0200
Message-ID: <27021466.BkUbn5OdDG@avalon>
In-Reply-To: <1510743363-25798-11-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-11-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 15 November 2017 12:56:03 EET Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from tw9910 sensor driver.
> - Handle clock directly
> - Register async subdevice
> - Add platform specific enable/disable functions
> - Adjust build system
> 
> This commit does not remove the original soc_camera based driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/Kconfig  |  9 ++++++
>  drivers/media/i2c/Makefile |  1 +
>  drivers/media/i2c/tw9910.c | 80 +++++++++++++++++++++++++++++++------------
>  include/media/i2c/tw9910.h |  6 ++++
>  4 files changed, 75 insertions(+), 21 deletions(-)

[snip]

> diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> index bdb5e0a..f422da2 100644
> --- a/drivers/media/i2c/tw9910.c
> +++ b/drivers/media/i2c/tw9910.c

[snip]

> @@ -582,13 +581,40 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
> 
> +static int tw9910_power_on(struct tw9910_priv *priv)
> +{
> +	int ret;
> +
> +	if (priv->info->platform_enable) {
> +		ret = priv->info->platform_enable();
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->clk)
> +		return clk_enable(priv->clk);

Shouldn't you use clk_prepare_enable() here ?

> +	return 0;
> +}
> +
> +static int tw9910_power_off(struct tw9910_priv *priv)
> +{
> +	if (priv->info->platform_enable)
> +		priv->info->platform_disable();
> +
> +	if (priv->clk)
> +		clk_disable(priv->clk);

And clk_disable_unprepare() here ?

> +
> +	return 0;
> +}

[snip]

> @@ -959,13 +979,27 @@ static int tw9910_probe(struct i2c_client *client,
> 
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
> 
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> -	if (IS_ERR(priv->clk))
> +	priv->clk = clk_get(&client->dev, "mclk");
> +	if (PTR_ERR(priv->clk) == -ENOENT) {
> +		priv->clk = NULL;
> +	} else if (IS_ERR(priv->clk)) {
> +		dev_err(&client->dev, "Unable to get mclk clock\n");
>  		return PTR_ERR(priv->clk);
> +	}
> 
>  	ret = tw9910_video_probe(client);
>  	if (ret < 0)
> -		v4l2_clk_put(priv->clk);
> +		goto error_put_clk;
> +
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret)
> +		goto error_put_clk;
> +
> +	return ret;
> +
> +error_put_clk:
> +	if (priv->clk)
> +		clk_put(priv->clk);

No need to check if priv->clk is NULL here, clk_put() should handle that 
properly.

>  	return ret;
>  }
> @@ -973,7 +1007,11 @@ static int tw9910_probe(struct i2c_client *client,
>  static int tw9910_remove(struct i2c_client *client)
>  {
>  	struct tw9910_priv *priv = to_tw9910(client);
> -	v4l2_clk_put(priv->clk);
> +
> +	if (priv->clk)
> +		clk_put(priv->clk);

Same here.

> +	v4l2_device_unregister_subdev(&priv->subdev);
> +
>  	return 0;
>  }
> 
> diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
> index 90bcf1f..b80e45c 100644
> --- a/include/media/i2c/tw9910.h
> +++ b/include/media/i2c/tw9910.h
> @@ -18,6 +18,9 @@
> 
>  #include <media/soc_camera.h>
> 
> +#define TW9910_DATAWIDTH_8	BIT(0)
> +#define TW9910_DATAWIDTH_16	BIT(1)
> +
>  enum tw9910_mpout_pin {
>  	TW9910_MPO_VLOSS,
>  	TW9910_MPO_HLOCK,
> @@ -32,6 +35,9 @@ enum tw9910_mpout_pin {
>  struct tw9910_video_info {
>  	unsigned long		buswidth;
>  	enum tw9910_mpout_pin	mpout;

How about storing that as an unsigned int that takes values 8 or 16 ? It would 
be more explicit (and a bit of kerneldoc for the tw9910_video_info structure 
would make that even better).

> +	int (*platform_enable)(void);
> +	void (*platform_disable)(void);
>  };

-- 
Regards,

Laurent Pinchart
