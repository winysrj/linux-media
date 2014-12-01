Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAWZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 17:25:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4] media: ov2640: add a master clock for sensor
Date: Tue, 02 Dec 2014 00:26:17 +0200
Message-ID: <2284801.0jEi8Kph7L@avalon>
In-Reply-To: <1417170507-11172-4-git-send-email-josh.wu@atmel.com>
References: <1417170507-11172-1-git-send-email-josh.wu@atmel.com> <1417170507-11172-4-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

(CC'ing the devicetree@vger.kernel.org mailing list)

Thank you for the patch.

On Friday 28 November 2014 18:28:26 Josh Wu wrote:
> The master clock can be optional. It's a common clock framework clock.
> It can make sensor output a pixel clock to the camera interface.
> 
> If you just use a external oscillator clock as the master clock, then,
> just don't need set 'mck' in dt node.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  drivers/media/i2c/soc_camera/ov2640.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
> b/drivers/media/i2c/soc_camera/ov2640.c index 6506126..06c2aa9 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -13,6 +13,7 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#include <linux/clk.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> @@ -31,6 +32,8 @@
> 
>  #define VAL_SET(x, mask, rshift, lshift)  \
>  		((((x) >> rshift) & mask) << lshift)
> +#define DEFAULT_MASTER_CLK_FREQ		25000000
> +
>  /*
>   * DSP registers
>   * register offset for BANK_SEL == BANK_SEL_DSP
> @@ -284,6 +287,7 @@ struct ov2640_priv {
>  	struct v4l2_ctrl_handler	hdl;
>  	u32	cfmt_code;
>  	struct v4l2_clk			*clk;
> +	struct clk			*master_clk;
>  	const struct ov2640_win_size	*win;
> 
>  	struct soc_camera_subdev_desc	ssdd_dt;
> @@ -746,6 +750,7 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int
> on) struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> struct ov2640_priv *priv = to_ov2640(client);
>  	struct v4l2_clk *clk;
> +	int ret = 0;
> 
>  	if (!priv->clk) {
>  		clk = v4l2_clk_get(&client->dev, "mclk");
> @@ -755,6 +760,16 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int
> on) priv->clk = clk;
>  	}
> 
> +	if (!IS_ERR(priv->master_clk)) {

The clock should be mandatory, you can thus drop this check.

> +		if (on)
> +			ret = clk_prepare_enable(priv->master_clk);
> +		else
> +			clk_disable_unprepare(priv->master_clk);
> +
> +		if (ret)
> +			return ret;

You can move the error check inside the first branch of the if and remove the 
ret = 0 initialization above.

> +	}
> +
>  	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);

If this call fails you should disable or enable the clock to undo the 
enable/disable above.

>  }
> 
> @@ -1153,6 +1168,16 @@ static int ov2640_probe(struct i2c_client *client,
>  		}
>  	}
> 
> +	priv->master_clk = devm_clk_get(&client->dev, "mck");
> +	if (!IS_ERR(priv->master_clk)) {
> +		/* Set ISI_MCK's frequency, it should be faster than pixel
> +		 * clock.
> +		 */
> +		ret = clk_set_rate(priv->master_clk, DEFAULT_MASTER_CLK_FREQ);

The clock frequency should be system-dependent. For the DT case an easy 
implementation would be to use the assigned-clock-rates to set the desired 
clock frequency is case of a variable clock, as adding a sensor-specific 
property to specify the desired clock frequency only to read that property in 
the driver and call clk_set_rate() seems a bit pointless to me.

> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,

-- 
Regards,

Laurent Pinchart

