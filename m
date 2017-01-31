Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48248 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750884AbdAaGxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 01:53:20 -0500
Date: Tue, 31 Jan 2017 08:53:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 04/16] ov7670: add devicetree support
Message-ID: <20170131065308.GP7139@valkosipuli.retiisi.org.uk>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
 <20170130140628.18088-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130140628.18088-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 30, 2017 at 03:06:16PM +0100, Hans Verkuil wrote:
> @@ -1549,6 +1551,29 @@ static const struct ov7670_devtype ov7670_devdata[] = {
>  	},
>  };
>  
> +static int ov7670_init_gpio(struct i2c_client *client, struct ov7670_info *info)
> +{
> +	/* Request the power down GPIO asserted */

You're setting both GPIOs to low state. How about just removing the
comments? I think they're just confusing.

> +	info->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> +			GPIOD_OUT_LOW);
> +	if (IS_ERR(info->pwdn_gpio)) {
> +		dev_info(&client->dev, "can't get %s GPIO\n", "pwdn");
> +		return PTR_ERR(info->pwdn_gpio);
> +	}
> +
> +	/* Request the reset GPIO deasserted */
> +	info->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
> +			GPIOD_OUT_LOW);
> +	if (IS_ERR(info->resetb_gpio)) {
> +		dev_info(&client->dev, "can't get %s GPIO\n", "resetb");
> +		return PTR_ERR(info->resetb_gpio);
> +	}
> +
> +	usleep_range(3000, 5000);
> +
> +	return 0;
> +}
> +
>  static int ov7670_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
>  {

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
