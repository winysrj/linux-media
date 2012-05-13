Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46193 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2EMIQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 04:16:22 -0400
Received: by wgbdr13 with SMTP id dr13so3686101wgb.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 01:16:21 -0700 (PDT)
Message-ID: <4FAF6DD1.6080709@gmail.com>
Date: Sun, 13 May 2012 10:16:17 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] fc0012 ver. 0.6: introduction of get_rf_strength function
References: <201205121111.36181.hfvogt@gmx.net>
In-Reply-To: <201205121111.36181.hfvogt@gmx.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/2012 11:11 AM, Hans-Frieder Vogt wrote:
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

rtl2832/fc0012:

femon -H -a 2 -c 10:
FE: Realtek RTL2832 (DVB-T) (DVBT)
status SCVYL | signal  23% | snr  79% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  23% | snr  79% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  23% | snr  79% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  23% | snr  79% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  23% | snr  82% | ber 0 | unc 100 | FE_HAS_LOCK
// without tzap/lock:
Problem retrieving frontend information: Remote I/O error
status       | signal  23% | snr  82% | ber 0 | unc 100 |
Problem retrieving frontend information: Remote I/O error
status       | signal  23% | snr  82% | ber 0 | unc 100 |
Problem retrieving frontend information: Remote I/O error
status       | signal  23% | snr  82% | ber 0 | unc 100 |
Problem retrieving frontend information: Remote I/O error
status       | signal  23% | snr  82% | ber 0 | unc 100 |
Problem retrieving frontend information: Remote I/O error
status       | signal  23% | snr  82% | ber 0 | unc 100 |

dmesg:
[…]
// without tzap/lock:
rtl2832: i2c rd failed=-32 reg=4e len=2
rtl2832: rtl2832_read_ber: failed=-121
rtl2832: i2c rd failed=-32 reg=01 len=1
fc0012: I2C write reg failed, reg: 12, val: 00
fc0012: fc0012_get_rf_strength: failed: -121
rtl2832: i2c rd failed=-32 reg=51 len=1
rtl2832: rtl2832_read_snr: failed=-121
rtl2832: i2c rd failed=-32 reg=51 len=1
rtl2832: rtl2832_read_ucblocks: failed=-121


Comparable readings - af9013/mxl5007t:

femon -H -a 1 -c 10
FE: Afatech AF9013 (DVBT)
status SCVYL | signal  55% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  55% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  55% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  55% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
status SCVYL | signal  55% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
// without tzap/lock:
status SCV   | signal  55% | snr   0% | ber 0 | unc 0 |
status SCV   | signal  55% | snr   0% | ber 0 | unc 0 |
status SCV   | signal  55% | snr   0% | ber 0 | unc 0 |
status SCV   | signal  55% | snr   0% | ber 0 | unc 0 |
status SCV   | signal  55% | snr   0% | ber 0 | unc 0 |

dmesg:
[…]
// without tzap/lock:
'NONE'


Is it necessary to populate a log buffer while frontend not locking?

regards,
poma

ps.
Thanks for fc0012!
