Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46460 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2ELJPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 05:15:05 -0400
Received: by bkcji2 with SMTP id ji2so2786280bkc.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 02:15:03 -0700 (PDT)
Message-ID: <4FAE2A14.9090409@googlemail.com>
Date: Sat, 12 May 2012 11:15:00 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] fc0012 ver. 0.6: introduction of get_rf_strength function
References: <201205121111.36181.hfvogt@gmx.net>
In-Reply-To: <201205121111.36181.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.05.2012 11:11, Hans-Frieder Vogt wrote:
> Changes compared to version 0.5 of driver (sent 6 May):
> - Initial implementation of get_rf_strength function.
> 
> Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
> 
>  fc0012.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 71 insertions(+), 1 deletion(-)
> 
> diff -up --new-file --recursive a/drivers/media/common/tuners/fc0012.c b/drivers/media/common/tuners/fc0012.c
> --- a/drivers/media/common/tuners/fc0012.c	2012-05-12 10:53:55.330058209 +0200
> +++ b/drivers/media/common/tuners/fc0012.c	2012-05-09 23:27:37.781193720 +0200
> @@ -343,6 +343,74 @@ static int fc0012_get_bandwidth(struct d
>  	return 0;
>  }
>  
> +#define INPUT_ADC_LEVEL	-8
> +
> +static int fc0012_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
> +{
> +	struct fc0012_priv *priv = fe->tuner_priv;
> +	int ret;
> +	unsigned char tmp;
> +	int int_temp, lna_gain, int_lna, tot_agc_gain, power;
> +	const int fc0012_lna_gain_table[] = {
> +		/* low gain */
> +		-63, -58, -99, -73,
> +		-63, -65, -54, -60,
> +		/* middle gain */
> +		 71,  70,  68,  67,
> +		 65,  63,  61,  58,
> +		/* high gain */
> +		197, 191, 188, 186,
> +		184, 182, 181, 179,
> +	};
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> +
> +	ret = fc0012_writereg(priv, 0x12, 0x00);
> +	if (ret)
> +		goto err;
> +
> +	ret = fc0012_readreg(priv, 0x12, &tmp);
> +	if (ret)
> +		goto err;
> +	int_temp = tmp;
> +
> +	ret = fc0012_readreg(priv, 0x13, &tmp);
> +	if (ret)
> +		goto err;
> +	lna_gain = tmp & 0x1f;
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> +
> +	if (lna_gain < ARRAY_SIZE(fc0012_lna_gain_table)) {
> +		int_lna = fc0012_lna_gain_table[lna_gain];
> +		tot_agc_gain = (abs((int_temp >> 5) - 7) - 2 +
> +				(int_temp & 0x1f)) * 2;
> +		power = INPUT_ADC_LEVEL - tot_agc_gain - int_lna / 10;
> +
> +		if (power >= 45)
> +			*strength = 255;	/* 100% */
> +		else if (power < -95)
> +			*strength = 0;
> +		else
> +			*strength = (power + 95) * 255 / 140;
> +
> +		*strength |= *strength << 8;
> +	} else {
> +		ret = -1;
> +	}
> +
> +	goto exit;
> +
> +err:
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> +exit:
> +	if (ret)
> +		warn("%s: failed: %d", __func__, ret);
> +	return ret;
> +}
>  
>  static const struct dvb_tuner_ops fc0012_tuner_ops = {
>  	.info = {
> @@ -363,6 +431,8 @@ static const struct dvb_tuner_ops fc0012
>  	.get_frequency	= fc0012_get_frequency,
>  	.get_if_frequency = fc0012_get_if_frequency,
>  	.get_bandwidth	= fc0012_get_bandwidth,
> +
> +	.get_rf_strength = fc0012_get_rf_strength,
>  };
>  
>  struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> @@ -394,4 +464,4 @@ EXPORT_SYMBOL(fc0012_attach);
>  MODULE_DESCRIPTION("Fitipower FC0012 silicon tuner driver");
>  MODULE_AUTHOR("Hans-Frieder Vogt <hfvogt@gmx.net>");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION("0.5");
> +MODULE_VERSION("0.6");
> 
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

Thanks!
I was just doing the same to get it to work with the rtl2832 demod. I will
test the fc0012 driver with the rtl2832 driver today.
