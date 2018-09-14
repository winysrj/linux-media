Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:54845 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbeINVnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 17:43:37 -0400
Subject: Re: [PATCH v4 1/2] media: ov5640: Re-work MIPI startup sequence
To: Jacopo Mondi <jacopo+renesas@jmondi.org>, <mchehab@kernel.org>,
        <laurent.pinchart@ideasonboard.com>, <maxime.ripard@bootlin.com>,
        <sam@elite-embedded.com>, <jagan@amarulasolutions.com>,
        <festevam@gmail.com>, <pza@pengutronix.de>,
        <hugues.fruchet@st.com>, <loic.poulain@linaro.org>,
        <daniel@zonque.org>
CC: <linux-media@vger.kernel.org>, Jacopo Mondi <jacopo@jmondi.org>
References: <1536940721-25802-1-git-send-email-jacopo+renesas@jmondi.org>
 <1536940721-25802-2-git-send-email-jacopo+renesas@jmondi.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <46b910a4-a257-f524-81bb-4dcfe18b88d0@mentor.com>
Date: Fri, 14 Sep 2018 09:27:23 -0700
MIME-Version: 1.0
In-Reply-To: <1536940721-25802-2-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 09/14/2018 08:58 AM, Jacopo Mondi wrote:
> From: Jacopo Mondi <jacopo@jmondi.org>
>
> Rework the MIPI interface startup sequence with the following changes:
>
> - Remove MIPI bus initialization from the initial settings blob
> - At set_power(1) time power up MIPI Tx/Rx and set data and clock lanes in
>    LP11 during 'sleep' and 'idle' with MIPI clock in non-continuous mode.
> - At s_stream time enable/disable the MIPI interface output.
> - Restore default settings at set_power(0) time.
>
> Before this commit the sensor MIPI interface was initialized with settings
> that require a start/stop sequence at power-up time in order to force lanes
> into LP11 state, as they were initialized in LP00 when in 'sleep mode',
> which is assumed to be the sensor manual definition for the D-PHY defined
> stop mode.
>
> The stream start/stop was performed by enabling disabling clock gating,
> and had the side effect to change the lanes sleep mode configuration when
> stream was stopped.
>
> Clock gating/ungating:
> -       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
> -                            on ? 0 : BIT(5));
> -       if (ret)
>
> Set lanes in LP11 when in 'sleep mode':
> -       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
> -                              on ? 0x00 : 0x70);
>
> This commit fixes an issue reported by Jagan Teki on i.MX6 platforms that
> prevents the host interface from powering up correctly:
> https://lkml.org/lkml/2018/6/1/38
>
> It also improves MIPI capture operations stability on my testing platform
> where MIPI capture often failed and returned all-purple frames.
>
> fixes: f22996db44e2 ("media: ov5640: add support of DVP parallel interface")
> Tested-by: Steve Longerbeam <slongerbeam@gmail.com>
> on i.MX6q SabreSD with MIPI CSI-2 OV5640 module

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

> Tested-by: Loic Poulain <loic.poulain@linaro.org>
> on Dragonboard-410c with MIPI CSI-2 OV5640 module
> Reported-by: Jagan Teki <jagan@amarulasolutions.com>
> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> ---
>   drivers/media/i2c/ov5640.c | 99 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 79 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 071f4bc..7ade416 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -286,10 +286,10 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
>   	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
>   	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
>   	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
> -	{0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
> +	{0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
>   	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
>   	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> -	{0x4837, 0x0a, 0, 0}, {0x4800, 0x04, 0, 0}, {0x3824, 0x02, 0, 0},
> +	{0x4837, 0x0a, 0, 0}, {0x3824, 0x02, 0, 0},
>   	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
>   	{0x5181, 0xf2, 0, 0}, {0x5182, 0x00, 0, 0}, {0x5183, 0x14, 0, 0},
>   	{0x5184, 0x25, 0, 0}, {0x5185, 0x24, 0, 0}, {0x5186, 0x09, 0, 0},
> @@ -1102,12 +1102,25 @@ static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
>   {
>   	int ret;
>
> -	ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
> -			     on ? 0 : BIT(5));
> -	if (ret)
> -		return ret;
> -	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
> -			       on ? 0x00 : 0x70);
> +	/*
> +	 * Enable/disable the MIPI interface
> +	 *
> +	 * 0x300e = on ? 0x45 : 0x40
> +	 *
> +	 * FIXME: the sensor manual (version 2.03) reports
> +	 * [7:5] = 000  : 1 data lane mode
> +	 * [7:5] = 001  : 2 data lanes mode
> +	 * But this settings do not work, while the following ones
> +	 * have been validated for 2 data lanes mode.
> +	 *
> +	 * [7:5] = 010	: 2 data lanes mode
> +	 * [4] = 0	: Power up MIPI HS Tx
> +	 * [3] = 0	: Power up MIPI LS Rx
> +	 * [2] = 1/0	: MIPI interface enable/disable
> +	 * [1:0] = 01/00: FIXME: 'debug'
> +	 */
> +	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00,
> +			       on ? 0x45 : 0x40);
>   	if (ret)
>   		return ret;
>
> @@ -1786,23 +1799,69 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
>   		if (ret)
>   			goto power_off;
>
> +		/* We're done here for DVP bus, while CSI-2 needs setup. */
> +		if (sensor->ep.bus_type != V4L2_MBUS_CSI2)
> +			return 0;
> +
> +		/*
> +		 * Power up MIPI HS Tx and LS Rx; 2 data lanes mode
> +		 *
> +		 * 0x300e = 0x40
> +		 * [7:5] = 010	: 2 data lanes mode (see FIXME note in
> +		 *		  "ov5640_set_stream_mipi()")
> +		 * [4] = 0	: Power up MIPI HS Tx
> +		 * [3] = 0	: Power up MIPI LS Rx
> +		 * [2] = 0	: MIPI interface disabled
> +		 */
> +		ret = ov5640_write_reg(sensor,
> +				       OV5640_REG_IO_MIPI_CTRL00, 0x40);
> +		if (ret)
> +			goto power_off;
> +
> +		/*
> +		 * Gate clock and set LP11 in 'no packets mode' (idle)
> +		 *
> +		 * 0x4800 = 0x24
> +		 * [5] = 1	: Gate clock when 'no packets'
> +		 * [2] = 1	: MIPI bus in LP11 when 'no packets'
> +		 */
> +		ret = ov5640_write_reg(sensor,
> +				       OV5640_REG_MIPI_CTRL00, 0x24);
> +		if (ret)
> +			goto power_off;
> +
> +		/*
> +		 * Set data lanes and clock in LP11 when 'sleeping'
> +		 *
> +		 * 0x3019 = 0x70
> +		 * [6] = 1	: MIPI data lane 2 in LP11 when 'sleeping'
> +		 * [5] = 1	: MIPI data lane 1 in LP11 when 'sleeping'
> +		 * [4] = 1	: MIPI clock lane in LP11 when 'sleeping'
> +		 */
> +		ret = ov5640_write_reg(sensor,
> +				       OV5640_REG_PAD_OUTPUT00, 0x70);
> +		if (ret)
> +			goto power_off;
> +
> +		/* Give lanes some time to coax into LP11 state. */
> +		usleep_range(500, 1000);
> +
> +	} else {
>   		if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
> -			/*
> -			 * start streaming briefly followed by stream off in
> -			 * order to coax the clock lane into LP-11 state.
> -			 */
> -			ret = ov5640_set_stream_mipi(sensor, true);
> -			if (ret)
> -				goto power_off;
> -			usleep_range(1000, 2000);
> -			ret = ov5640_set_stream_mipi(sensor, false);
> -			if (ret)
> -				goto power_off;
> +			/* Reset MIPI bus settings to their default values. */
> +			ov5640_write_reg(sensor,
> +					 OV5640_REG_IO_MIPI_CTRL00, 0x58);
> +			ov5640_write_reg(sensor,
> +					 OV5640_REG_MIPI_CTRL00, 0x04);
> +			ov5640_write_reg(sensor,
> +					 OV5640_REG_PAD_OUTPUT00, 0x00);
>   		}
>
> -		return 0;
> +		ov5640_set_power_off(sensor);
>   	}
>
> +	return 0;
> +
>   power_off:
>   	ov5640_set_power_off(sensor);
>   	return ret;
> --
> 2.7.4
>
