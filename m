Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33535 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbdASBp6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 20:45:58 -0500
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <1484320822.31475.96.camel@pengutronix.de>
 <2b1d2418-1ad4-6373-cb07-c3aeab48187f@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <aaefdb64-5d45-a225-f764-b06ebda73264@gmail.com>
Date: Wed, 18 Jan 2017 17:44:53 -0800
MIME-Version: 1.0
In-Reply-To: <2b1d2418-1ad4-6373-cb07-c3aeab48187f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/14/2017 02:42 PM, Steve Longerbeam wrote:
>
>>> +/* parse inputs property from a sensor node */
>>> +static void of_parse_sensor_inputs(struct imx_media_dev *imxmd,
>>> +				   struct imx_media_subdev *sensor,
>>> +				   struct device_node *sensor_np)
>>> +{
>>> +	struct imx_media_sensor_input *sinput = &sensor->input;
>>> +	int ret, i;
>>> +
>>> +	for (i = 0; i < IMX_MEDIA_MAX_SENSOR_INPUTS; i++) {
>>> +		const char *input_name;
>>> +		u32 val;
>>> +
>>> +		ret = of_property_read_u32_index(sensor_np, "inputs", i, &val);
>>> +		if (ret)
>>> +			break;
>>> +
>>> +		sinput->value[i] = val;
>>> +
>>> +		ret = of_property_read_string_index(sensor_np, "input-names",
>>> +						    i, &input_name);
>>> +		/*
>>> +		 * if input-names not provided, they will be set using
>>> +		 * the subdev name once the sensor is known during
>>> +		 * async bind
>>> +		 */
>>> +		if (!ret)
>>> +			strncpy(sinput->name[i], input_name,
>>> +				sizeof(sinput->name[i]));
>>> +	}
>>> +
>>> +	sinput->num = i;
>>> +
>>> +	/* if no inputs provided just assume a single input */
>>> +	if (sinput->num == 0)
>>> +		sinput->num = 1;
>>> +}
>> This should be parsed by the sensor driver, not imx-media.
>
> you're probably right. I'll submit a patch for adv7180.c.

Actually, the problem here is that this parses an input routing value to
pass to s_routing, and an input name string. There would need to be
another subdev callback, maybe enum_imput, that would return this
information for the bridge driver, if this info were to be parsed and
maintained by the sensor.

But this info should really be known and parsed by the bridge anyway,
because as the header for s_routing states,

"An i2c device shouldn't know about whether an input pin is connected
  to a Composite connector, because on another board or platform it
  might be connected to something else entirely. The calling driver is
  responsible for mapping a user-level input to the right pins on the i2c
  device."

Steve


