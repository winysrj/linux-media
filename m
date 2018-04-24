Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55390 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932417AbeDXKZB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:25:01 -0400
Date: Tue, 24 Apr 2018 13:24:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
Subject: Re: [PATCH 3/3] media: ov5640: add support for xclk frequency control
Message-ID: <20180424102459.pgibl76nj66vj4ki@valkosipuli.retiisi.org.uk>
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-3-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420094419.11267-3-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 11:44:19AM +0200, Daniel Mack wrote:
> Allow setting the xclk rate via an optional 'clock-frequency' property in
> the device tree node.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov5640.txt |  2 ++
>  drivers/media/i2c/ov5640.c                             | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> index 8e36da0d8406..584bbc944978 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> @@ -13,6 +13,8 @@ Optional Properties:
>  	       This is an active low signal to the OV5640.
>  - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
>  		   if any. This is an active high signal to the OV5640.
> +- clock-frequency: frequency to set on the xclk input clock. The clock
> +		   is left untouched if this property is missing.
>  
>  The device node must contain one 'port' child node for its digital output
>  video port, in accordance with the video interface bindings defined in
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 78669ed386cd..2d94d6dbda5d 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2685,6 +2685,7 @@ static int ov5640_probe(struct i2c_client *client,
>  	struct fwnode_handle *endpoint;
>  	struct ov5640_dev *sensor;
>  	struct v4l2_mbus_framefmt *fmt;
> +	u32 freq;
>  	int ret;
>  
>  	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> @@ -2731,6 +2732,15 @@ static int ov5640_probe(struct i2c_client *client,
>  		return PTR_ERR(sensor->xclk);
>  	}
>  
> +	ret = of_property_read_u32(dev->of_node, "clock-frequency", &freq);

Please use

	ret = fwnode_property_read_u32(dev_fwnode(dev), ...);

Thanks.

> +	if (ret == 0) {
> +		ret = clk_set_rate(sensor->xclk, freq);
> +		if (ret) {
> +			dev_err(dev, "could not set xclk frequency\n");
> +			return ret;
> +		}
> +	}
> +
>  	sensor->xclk_freq = clk_get_rate(sensor->xclk);
>  	if (sensor->xclk_freq < OV5640_XCLK_MIN ||
>  	    sensor->xclk_freq > OV5640_XCLK_MAX) {
> -- 
> 2.14.3
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
