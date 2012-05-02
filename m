Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53911 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756261Ab2EBTrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 15:47:05 -0400
Date: Wed, 2 May 2012 22:47:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 07/10] arm: omap4430sdp: Add support for omap4iss
 camera
Message-ID: <20120502194700.GF852@valkosipuli.localdomain>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
 <1335971749-21258-8-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335971749-21258-8-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sergio,

Thanks for the patches!!

On Wed, May 02, 2012 at 10:15:46AM -0500, Sergio Aguirre wrote:
...
> +static int sdp4430_ov_cam1_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct device *dev = subdev->v4l2_dev->dev;
> +	int ret;
> +
> +	if (on) {
> +		if (!regulator_is_enabled(sdp4430_cam2pwr_reg)) {
> +			ret = regulator_enable(sdp4430_cam2pwr_reg);
> +			if (ret) {
> +				dev_err(dev,
> +					"Error in enabling sensor power regulator 'cam2pwr'\n");
> +				return ret;
> +			}
> +
> +			msleep(50);
> +		}
> +
> +		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 1);
> +		msleep(10);
> +		ret = clk_enable(sdp4430_cam1_aux_clk); /* Enable XCLK */
> +		if (ret) {
> +			dev_err(dev,
> +				"Error in clk_enable() in %s(%d)\n",
> +				__func__, on);
> +			gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
> +			return ret;
> +		}
> +		msleep(10);
> +	} else {
> +		clk_disable(sdp4430_cam1_aux_clk);
> +		msleep(1);
> +		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
> +		if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
> +			ret = regulator_disable(sdp4430_cam2pwr_reg);
> +			if (ret) {
> +				dev_err(dev,
> +					"Error in disabling sensor power regulator 'cam2pwr'\n");
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}

Isn't this something that should be part of the sensor driver? There's
nothing in the above code that would be board specific, except the names of
the clocks, regulators and GPIOs. The sensor driver could hold the names
instead; this would be also compatible with the device tree.

It should be possible to have s_power() callback NULL, too.

> +static int sdp4430_ov_cam2_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct device *dev = subdev->v4l2_dev->dev;
> +	int ret;
> +
> +	if (on) {
> +		u8 gpoctl = 0;
> +
> +		ret = regulator_enable(sdp4430_cam2pwr_reg);
> +		if (ret) {
> +			dev_err(dev,
> +				"Error in enabling sensor power regulator 'cam2pwr'\n");
> +			return ret;
> +		}
> +
> +		msleep(50);
> +
> +		if (twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &gpoctl,
> +				    TWL6040_REG_GPOCTL))
> +			return -ENODEV;
> +		if (twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE,
> +				     gpoctl | TWL6040_GPO3,
> +				     TWL6040_REG_GPOCTL))
> +			return -ENODEV;

The above piece of code looks quite interesting. What does it do?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
