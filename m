Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:48620 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752462AbdLCVez (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 16:34:55 -0500
Subject: Re: [PATCH v2 2/4] media: ov5640: check chip id
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com>
 <1511975472-26659-3-git-send-email-hugues.fruchet@st.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <fcf7a6e3-e4b7-bf45-feca-8b9fa5b08716@mentor.com>
Date: Sun, 3 Dec 2017 13:34:48 -0800
MIME-Version: 1.0
In-Reply-To: <1511975472-26659-3-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/29/2017 09:11 AM, Hugues Fruchet wrote:
> Verify that chip identifier is correct before starting streaming
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>   drivers/media/i2c/ov5640.c | 30 +++++++++++++++++++++++++++++-
>   1 file changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 61071f5..a576d11 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -34,7 +34,8 @@
>   
>   #define OV5640_DEFAULT_SLAVE_ID 0x3c
>   
> -#define OV5640_REG_CHIP_ID		0x300a
> +#define OV5640_REG_CHIP_ID_HIGH		0x300a
> +#define OV5640_REG_CHIP_ID_LOW		0x300b

There is no need to separate low and high byte addresses.
See below.

>   #define OV5640_REG_PAD_OUTPUT00		0x3019
>   #define OV5640_REG_SC_PLL_CTRL0		0x3034
>   #define OV5640_REG_SC_PLL_CTRL1		0x3035
> @@ -926,6 +927,29 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
>   	return ret;
>   }
>   
> +static int ov5640_check_chip_id(struct ov5640_dev *sensor)
> +{
> +	struct i2c_client *client = sensor->i2c_client;
> +	int ret;
> +	u8 chip_id_h, chip_id_l;
> +
> +	ret = ov5640_read_reg(sensor, OV5640_REG_CHIP_ID_HIGH, &chip_id_h);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_read_reg(sensor, OV5640_REG_CHIP_ID_LOW, &chip_id_l);
> +	if (ret)
> +		return ret;
> +
> +	if (!(chip_id_h == 0x56 && chip_id_l == 0x40)) {
> +		dev_err(&client->dev, "%s: wrong chip identifier, expected 0x5640, got 0x%x%x\n",
> +			__func__, chip_id_h, chip_id_l);
> +		return -EINVAL;
> +	}
> +

This should all be be replaced by:

u16 chip_id;

ret = ov5640_read_reg16(sensor, OV5640_REG_CHIP_ID, &chip_id);

etc.

> +	return 0;
> +}
> +
>   /* read exposure, in number of line periods */
>   static int ov5640_get_exposure(struct ov5640_dev *sensor)
>   {
> @@ -1562,6 +1586,10 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
>   		ov5640_reset(sensor);
>   		ov5640_power(sensor, true);
>   
> +		ret = ov5640_check_chip_id(sensor);
> +		if (ret)
> +			goto power_off;
> +
>   		ret = ov5640_init_slave_id(sensor);
>   		if (ret)
>   			goto power_off;
