Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:49869 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdLCV6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 16:58:04 -0500
Subject: Re: [PATCH v2 3/4] media: ov5640: add support of DVP parallel
 interface
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com>
 <1511975472-26659-4-git-send-email-hugues.fruchet@st.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <2f640898-872b-3211-0e7c-c1707e8a63c4@mentor.com>
Date: Sun, 3 Dec 2017 13:58:00 -0800
MIME-Version: 1.0
In-Reply-To: <1511975472-26659-4-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/29/2017 09:11 AM, Hugues Fruchet wrote:
> Add support of DVP parallel mode in addition of
> existing MIPI CSI mode. The choice between two modes
> and configuration is made through device tree.
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>   drivers/media/i2c/ov5640.c | 101 +++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 83 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index a576d11..826b102 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -34,14 +34,20 @@
>   
>   #define OV5640_DEFAULT_SLAVE_ID 0x3c
>   
> +#define OV5640_REG_SYS_CTRL0		0x3008
>   #define OV5640_REG_CHIP_ID_HIGH		0x300a
>   #define OV5640_REG_CHIP_ID_LOW		0x300b
> +#define OV5640_REG_IO_MIPI_CTRL00	0x300e
> +#define OV5640_REG_PAD_OUTPUT_ENABLE01	0x3017
> +#define OV5640_REG_PAD_OUTPUT_ENABLE02	0x3018
>   #define OV5640_REG_PAD_OUTPUT00		0x3019
> +#define OV5640_REG_SYSTEM_CONTROL1	0x302e
>   #define OV5640_REG_SC_PLL_CTRL0		0x3034
>   #define OV5640_REG_SC_PLL_CTRL1		0x3035
>   #define OV5640_REG_SC_PLL_CTRL2		0x3036
>   #define OV5640_REG_SC_PLL_CTRL3		0x3037
>   #define OV5640_REG_SLAVE_ID		0x3100
> +#define OV5640_REG_SCCB_SYS_CTRL1	0x3103
>   #define OV5640_REG_SYS_ROOT_DIVIDER	0x3108
>   #define OV5640_REG_AWB_R_GAIN		0x3400
>   #define OV5640_REG_AWB_G_GAIN		0x3402
> @@ -1006,7 +1012,65 @@ static int ov5640_get_gain(struct ov5640_dev *sensor)
>   	return gain & 0x3ff;
>   }
>   
> -static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
> +static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
> +{
> +	int ret;
> +
> +	if (on) {
> +		/*
> +		 * reset MIPI PCLK/SERCLK divider
> +		 *
> +		 * SC PLL CONTRL1 0
> +		 * - [3..0]:	MIPI PCLK/SERCLK divider
> +		 */
> +		ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0xF, 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * powerdown MIPI TX/RX PHY & disable MIPI
> +	 *
> +	 * MIPI CONTROL 00
> +	 * 4:	 PWDN PHY TX
> +	 * 3:	 PWDN PHY RX
> +	 * 2:	 MIPI enable
> +	 */
> +	ret = ov5640_write_reg(sensor,
> +			       OV5640_REG_IO_MIPI_CTRL00, on ? 0x18 : 0);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * enable VSYNC/HREF/PCLK DVP control lines
> +	 * & D[9:6] DVP data lines
> +	 *
> +	 * PAD OUTPUT ENABLE 01
> +	 * - 6:		VSYNC output enable
> +	 * - 5:		HREF output enable
> +	 * - 4:		PCLK output enable
> +	 * - [3:0]:	D[9:6] output enable
> +	 */
> +	ret = ov5640_write_reg(sensor,
> +			       OV5640_REG_PAD_OUTPUT_ENABLE01, on ? 0x7f : 0);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * enable D[5:2] DVP data lines (D[0:1] are unused with 8 bits
> +	 * parallel mode, 8 bits output are mapped on D[9:2])
> +	 *
> +	 * PAD OUTPUT ENABLE 02
> +	 * - [7:4]:	D[5:2] output enable
> +	 *		0:1 are unused with 8 bits
> +	 *		parallel mode (8 bits output
> +	 *		are on D[9:2])
> +	 */

It should be verified in this driver, at probe, that the device tree
endpoint for the OV5640 output parallel interface has specified this
with "bus-width=<8>; data-shift=<2>;"

Steve

> +	return ov5640_write_reg(sensor,
> +				OV5640_REG_PAD_OUTPUT_ENABLE02, on ? 0xf0 : 0);
> +}
> +
> +static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
>   {
>   	int ret;
>   
> @@ -1598,17 +1662,19 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
>   		if (ret)
>   			goto power_off;
>   
> -		/*
> -		 * start streaming briefly followed by stream off in
> -		 * order to coax the clock lane into LP-11 state.
> -		 */
> -		ret = ov5640_set_stream(sensor, true);
> -		if (ret)
> -			goto power_off;
> -		usleep_range(1000, 2000);
> -		ret = ov5640_set_stream(sensor, false);
> -		if (ret)
> -			goto power_off;
> +		if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
> +			/*
> +			 * start streaming briefly followed by stream off in
> +			 * order to coax the clock lane into LP-11 state.
> +			 */
> +			ret = ov5640_set_stream_mipi(sensor, true);
> +			if (ret)
> +				goto power_off;
> +			usleep_range(1000, 2000);
> +			ret = ov5640_set_stream_mipi(sensor, false);
> +			if (ret)
> +				goto power_off;
> +		}
>   
>   		return 0;
>   	}
> @@ -2185,7 +2251,11 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>   				goto out;
>   		}
>   
> -		ret = ov5640_set_stream(sensor, enable);
> +		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
> +			ret = ov5640_set_stream_mipi(sensor, enable);
> +		else
> +			ret = ov5640_set_stream_dvp(sensor, enable);
> +
>   		if (!ret)
>   			sensor->streaming = enable;
>   	}
> @@ -2270,11 +2340,6 @@ static int ov5640_probe(struct i2c_client *client,
>   		return ret;
>   	}
>   
> -	if (sensor->ep.bus_type != V4L2_MBUS_CSI2) {
> -		dev_err(dev, "invalid bus type, must be MIPI CSI2\n");
> -		return -EINVAL;
> -	}
> -
>   	/* get system clock (xclk) */
>   	sensor->xclk = devm_clk_get(dev, "xclk");
>   	if (IS_ERR(sensor->xclk)) {
