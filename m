Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52436 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753877AbeBSUcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 15:32:07 -0500
Date: Mon, 19 Feb 2018 22:32:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] v4l2: i2c: ov7670: Implement OF mbus configuration
Message-ID: <20180219203203.aeiuedswxrpthxia@valkosipuli.retiisi.org.uk>
References: <1516786250-3750-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516786250-3750-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516786250-3750-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 24, 2018 at 10:30:50AM +0100, Jacopo Mondi wrote:
> ov7670 driver supports two optional properties supplied through platform
> data, but currently does not support any standard video interface
> property.
> 
> Add support through OF parsing for 2 generic properties (vsync and hsync
> polarities) and for one custom property already supported through
> platform data to suppress pixel clock output during horizontal
> blanking.
> 
> While at there, check return value of register writes in set_fmt
> function and rationalize spacings.
> 
> Signal polarities and pixel clock blanking verified through scope and
> image capture.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Hi Jacopo,

I'll add the following diff to the patch in order to fix the build error
without V4L2_FWNODE:

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 535f85b73075..245387f7b65e 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -683,6 +683,7 @@ config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
 	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV7670 VGA camera.  It currently only works with the M88ALP01

> ---
>  drivers/media/i2c/ov7670.c | 98 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 84 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 61c472e..80c822c 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -21,6 +21,7 @@
>  #include <linux/gpio/consumer.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/i2c/ov7670.h>
> @@ -242,6 +243,7 @@ struct ov7670_info {
>  	struct clk *clk;
>  	struct gpio_desc *resetb_gpio;
>  	struct gpio_desc *pwdn_gpio;
> +	unsigned int mbus_config;	/* Media bus configuration flags */
>  	int min_width;			/* Filter out smaller sizes */
>  	int min_height;			/* Filter out smaller sizes */
>  	int clock_speed;		/* External clock speed (MHz) */
> @@ -1018,7 +1020,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
>  #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>  	struct v4l2_mbus_framefmt *mbus_fmt;
>  #endif
> -	unsigned char com7;
> +	unsigned char com7, com10 = 0;
>  	int ret;
>  
>  	if (format->pad)
> @@ -1038,7 +1040,6 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
>  	}
>  
>  	ret = ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);
> -
>  	if (ret)
>  		return ret;
>  	/*
> @@ -1049,16 +1050,41 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
>  	 */
>  	com7 = ovfmt->regs[0].value;
>  	com7 |= wsize->com7_bit;
> -	ov7670_write(sd, REG_COM7, com7);
> +	ret = ov7670_write(sd, REG_COM7, com7);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Configure the media bus through COM10 register
> +	 */
> +	if (info->mbus_config & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +		com10 |= COM10_VS_NEG;
> +	if (info->mbus_config & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +		com10 |= COM10_HREF_REV;
> +	if (info->pclk_hb_disable)
> +		com10 |= COM10_PCLK_HB;
> +	ret = ov7670_write(sd, REG_COM10, com10);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Now write the rest of the array.  Also store start/stops
>  	 */
> -	ov7670_write_array(sd, ovfmt->regs + 1);
> -	ov7670_set_hw(sd, wsize->hstart, wsize->hstop, wsize->vstart,
> -			wsize->vstop);
> -	ret = 0;
> -	if (wsize->regs)
> +	ret = ov7670_write_array(sd, ovfmt->regs + 1);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov7670_set_hw(sd, wsize->hstart, wsize->hstop, wsize->vstart,
> +			    wsize->vstop);
> +	if (ret)
> +		return ret;
> +
> +	if (wsize->regs) {
>  		ret = ov7670_write_array(sd, wsize->regs);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	info->fmt = ovfmt;
>  
>  	/*
> @@ -1071,8 +1097,10 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
>  	 * to write it unconditionally, and that will make the frame
>  	 * rate persistent too.
>  	 */
> -	if (ret == 0)
> -		ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> +	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> +	if (ret)
> +		return ret;
> +
>  	return 0;
>  }
>  
> @@ -1698,6 +1726,45 @@ static int ov7670_init_gpio(struct i2c_client *client, struct ov7670_info *info)
>  	return 0;
>  }
>  
> +/*
> + * ov7670_parse_dt() - Parse device tree to collect mbus configuration
> + *			properties
> + */
> +static int ov7670_parse_dt(struct device *dev,
> +			   struct ov7670_info *info)
> +{
> +	struct fwnode_handle *fwnode = dev_fwnode(dev);
> +	struct v4l2_fwnode_endpoint bus_cfg;
> +	struct fwnode_handle *ep;
> +	int ret;
> +
> +	if (!fwnode)
> +		return -EINVAL;
> +
> +	info->pclk_hb_disable = false;
> +	if (fwnode_property_present(fwnode, "ov7670,pclk-hb-disable"))
> +		info->pclk_hb_disable = true;
> +
> +	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
> +	if (!ep)
> +		return -EINVAL;
> +
> +	ret = v4l2_fwnode_endpoint_parse(ep, &bus_cfg);
> +	if (ret) {
> +		fwnode_handle_put(ep);
> +		return ret;
> +	}
> +
> +	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
> +		dev_err(dev, "Unsupported media bus type\n");
> +		fwnode_handle_put(ep);
> +		return ret;
> +	}
> +	info->mbus_config = bus_cfg.bus.parallel.flags;
> +
> +	return 0;
> +}
> +
>  static int ov7670_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
>  {
> @@ -1718,7 +1785,13 @@ static int ov7670_probe(struct i2c_client *client,
>  #endif
>  
>  	info->clock_speed = 30; /* default: a guess */
> -	if (client->dev.platform_data) {
> +
> +	if (dev_fwnode(&client->dev)) {
> +		ret = ov7670_parse_dt(&client->dev, info);
> +		if (ret)
> +			return ret;
> +
> +	} else if (client->dev.platform_data) {
>  		struct ov7670_config *config = client->dev.platform_data;
>  
>  		/*
> @@ -1785,9 +1858,6 @@ static int ov7670_probe(struct i2c_client *client,
>  	tpf.denominator = 30;
>  	info->devtype->set_framerate(sd, &tpf);
>  
> -	if (info->pclk_hb_disable)
> -		ov7670_write(sd, REG_COM10, COM10_PCLK_HB);
> -
>  	v4l2_ctrl_handler_init(&info->hdl, 10);
>  	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
>  			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
