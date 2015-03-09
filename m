Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56491 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbCIKgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 06:36:12 -0400
Message-id: <54FD7788.2020709@samsung.com>
Date: Mon, 09 Mar 2015 11:35:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Add OF support
References: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/03/15 14:45, Laurent Pinchart wrote:
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> @@ -0,0 +1,41 @@
> +* Aptina 1/3-Inch WVGA CMOS Digital Image Sensor
> +
> +The Aptina MT9V032 is a 1/3-inch CMOS active pixel digital image sensor with
> +an active array size of 752H x 480V. It is programmable through a simple
> +two-wire serial interface.
> +
> +Required Properties:
> +
> +- compatible: value should be either one among the following
> +	(a) "aptina,mt9v032" for MT9V032 color sensor
> +	(b) "aptina,mt9v032m" for MT9V032 monochrome sensor
> +	(c) "aptina,mt9v034" for MT9V034 color sensor
> +	(d) "aptina,mt9v034m" for MT9V034 monochrome sensor

It can't be determined at runtime whether the sensor is just monochromatic ?
Al in all the color filter array is a physical property of the sensor, still
the driver seems to be ignoring the "m" suffix. Hence I suspect the register
interfaces for both color and monochromatic versions are compatible.
I'm wondering whether using a boolean property to indicate the color filter
array type would do as well.

> +static struct mt9v032_platform_data *
> +mt9v032_get_pdata(struct i2c_client *client)
> +{
> +	struct mt9v032_platform_data *pdata;
> +	struct v4l2_of_endpoint endpoint;
> +	struct device_node *np;
> +	struct property *prop;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!np)
> +		return NULL;
> +
> +	if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> +		goto done;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		goto done;
> +
> +	prop = of_find_property(np, "link-freqs", NULL);

I suspect you meant "link-frequencies" here ?

> +	if (prop) {
> +		size_t size = prop->length / 8;
> +		u64 *link_freqs;
> +
> +		link_freqs = devm_kzalloc(&client->dev,
> +					  size * sizeof(*link_freqs),
> +					  GFP_KERNEL);
> +		if (!link_freqs)
> +			goto done;
> +
> +		if (of_property_read_u64_array(np, "link-frequencies",
> +					       link_freqs, size) < 0)
> +			goto done;
> +
> +		pdata->link_freqs = link_freqs;
> +		pdata->link_def_freq = link_freqs[0];
> +	}
> +
> +	pdata->clk_pol = !!(endpoint.bus.parallel.flags &
> +			    V4L2_MBUS_PCLK_SAMPLE_RISING);
> +
> +done:
> +	of_node_put(np);
> +	return pdata;
> +}

> @@ -1034,9 +1086,21 @@ static const struct i2c_device_id mt9v032_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, mt9v032_id);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id mt9v032_of_match[] = {
> +	{ .compatible = "mt9v032" },
> +	{ .compatible = "mt9v032m" },
> +	{ .compatible = "mt9v034" },
> +	{ .compatible = "mt9v034m" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mt9v032_of_match);
> +#endif

-- 
Thanks,
Sylwester
