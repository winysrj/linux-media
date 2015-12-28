Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28439 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbbL1Omr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 09:42:47 -0500
Date: Mon, 28 Dec 2015 15:42:18 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] m88rs6000t: Better exception handling in
 five functions
In-Reply-To: <5681497E.7030702@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1512281541330.2702@hadrien>
References: <566ABCD9.1060404@users.sourceforge.net> <5680FDB3.7060305@users.sourceforge.net> <alpine.DEB.2.10.1512281019050.2702@hadrien> <56810F56.4080306@users.sourceforge.net> <alpine.DEB.2.10.1512281134590.2702@hadrien> <568148FD.7080209@users.sourceforge.net>
 <5681497E.7030702@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 28 Dec 2015, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 28 Dec 2015 15:10:30 +0100
>
> This issue was detected by using the Coccinelle software.
>
> Move the jump label directly before the desired log statement
> so that the variable "ret" will not be checked once more
> after a function call.

This commit message fits with the previous change.

It could be nice to put a blank line before the error handling code.  See
what is done elsewhere in the file.

julia

>
> Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/tuners/m88rs6000t.c | 154 +++++++++++++++++++-------------------
>  1 file changed, 78 insertions(+), 76 deletions(-)
>
> diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
> index 504bfbc..7e59a9f 100644
> --- a/drivers/media/tuners/m88rs6000t.c
> +++ b/drivers/media/tuners/m88rs6000t.c
> @@ -44,7 +44,7 @@ static int m88rs6000t_set_demod_mclk(struct dvb_frontend *fe)
>  	/* select demod main mclk */
>  	ret = regmap_read(dev->regmap, 0x15, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg15 = utmp;
>  	if (c->symbol_rate > 45010000) {
>  		reg11 = 0x0E;
> @@ -106,7 +106,7 @@ static int m88rs6000t_set_demod_mclk(struct dvb_frontend *fe)
>
>  	ret = regmap_read(dev->regmap, 0x1D, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg1D = utmp;
>  	reg1D &= ~0x03;
>  	reg1D |= N - 1;
> @@ -116,42 +116,42 @@ static int m88rs6000t_set_demod_mclk(struct dvb_frontend *fe)
>  	/* program and recalibrate demod PLL */
>  	ret = regmap_write(dev->regmap, 0x05, 0x40);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x11, 0x08);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x15, reg15);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x16, reg16);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x1D, reg1D);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x1E, reg1E);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x1F, reg1F);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x17, 0xc1);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x17, 0x81);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(5000, 50000);
>  	ret = regmap_write(dev->regmap, 0x05, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x11, reg11);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(5000, 50000);
> -err:
> -	if (ret)
> -		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
> +	return 0;
> +report_failure:
> +	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>
> @@ -169,13 +169,13 @@ static int m88rs6000t_set_pll_freq(struct m88rs6000t_dev *dev,
>
>  	ret = regmap_write(dev->regmap, 0x36, (refDiv - 8));
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x31, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x2c, 0x02);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>
>  	if (tuner_freq_MHz >= 1550) {
>  		ucLoDiv1 = 2;
> @@ -227,105 +227,105 @@ static int m88rs6000t_set_pll_freq(struct m88rs6000t_dev *dev,
>  	reg27 = (((ulNDiv1 >> 8) & 0x0F) + ucLomod1) & 0x7F;
>  	ret = regmap_write(dev->regmap, 0x27, reg27);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x28, (u8)(ulNDiv1 & 0xFF));
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg29 = (((ulNDiv2 >> 8) & 0x0F) + ucLomod2) & 0x7f;
>  	ret = regmap_write(dev->regmap, 0x29, reg29);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x2a, (u8)(ulNDiv2 & 0xFF));
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x2F, 0xf5);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x30, 0x05);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x1f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x3f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x20);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x3e, 0x11);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x2f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x3f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x10);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(2000, 50000);
>
>  	ret = regmap_read(dev->regmap, 0x42, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg42 = utmp;
>
>  	ret = regmap_write(dev->regmap, 0x3e, 0x10);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x2f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x08, 0x3f);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x10);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x09, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(2000, 50000);
>
>  	ret = regmap_read(dev->regmap, 0x42, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg42buf = utmp;
>  	if (reg42buf < reg42) {
>  		ret = regmap_write(dev->regmap, 0x3e, 0x11);
>  		if (ret)
> -			goto err;
> +			goto report_failure;
>  	}
>  	usleep_range(5000, 50000);
>
>  	ret = regmap_read(dev->regmap, 0x2d, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x2d, utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_read(dev->regmap, 0x2e, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x2e, utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>
>  	ret = regmap_read(dev->regmap, 0x27, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	reg27 = utmp & 0x70;
>  	ret = regmap_read(dev->regmap, 0x83, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	if (reg27 == (utmp & 0x70)) {
>  		ucLoDiv	= ucLoDiv1;
>  		ulNDiv = ulNDiv1;
> @@ -340,7 +340,7 @@ static int m88rs6000t_set_pll_freq(struct m88rs6000t_dev *dev,
>  		refDiv = 18;
>  		ret = regmap_write(dev->regmap, 0x36, (refDiv - 8));
>  		if (ret)
> -			goto err;
> +			goto report_failure;
>  		ulNDiv = ((tuner_freq_MHz * ucLoDiv * 1000) * refDiv
>  				/ fcry_KHz - 1024) / 2;
>  	}
> @@ -349,16 +349,16 @@ static int m88rs6000t_set_pll_freq(struct m88rs6000t_dev *dev,
>  			+ ((ulNDiv >> 8) & 0x0F)) & 0xFF;
>  	ret = regmap_write(dev->regmap, 0x27, reg27);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x28, (u8)(ulNDiv & 0xFF));
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x29, 0x80);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x31, 0x03);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>
>  	if (ucLoDiv == 3)
>  		utmp = 0xCE;
> @@ -366,15 +366,15 @@ static int m88rs6000t_set_pll_freq(struct m88rs6000t_dev *dev,
>  		utmp = 0x8A;
>  	ret = regmap_write(dev->regmap, 0x3b, utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>
>  	dev->frequency_khz = fcry_KHz * (ulNDiv * 2 + 1024) / refDiv / ucLoDiv;
>
>  	dev_dbg(&dev->client->dev,
>  		"actual tune frequency=%d\n", dev->frequency_khz);
> -err:
> -	if (ret)
> -		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
> +	return 0;
> +report_failure:
> +	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>
> @@ -413,21 +413,23 @@ static int m88rs6000t_set_params(struct dvb_frontend *fe)
>  	freq_MHz = (realFreq + 500) / 1000;
>  	ret = m88rs6000t_set_pll_freq(dev, freq_MHz);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = m88rs6000t_set_bb(dev, c->symbol_rate / 1000, lpf_offset_KHz);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x00, 0x01);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	ret = regmap_write(dev->regmap, 0x00, 0x00);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	/* set demod mlck */
>  	ret = m88rs6000t_set_demod_mclk(fe);
> -err:
>  	if (ret)
> -		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
> +		goto report_failure;
> +	return 0;
> +report_failure:
> +	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>
> @@ -440,16 +442,16 @@ static int m88rs6000t_init(struct dvb_frontend *fe)
>
>  	ret = regmap_update_bits(dev->regmap, 0x11, 0x08, 0x08);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(5000, 50000);
>  	ret = regmap_update_bits(dev->regmap, 0x10, 0x01, 0x01);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	usleep_range(10000, 50000);
>  	ret = regmap_write(dev->regmap, 0x07, 0x7d);
> -err:
> -	if (ret)
> -		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
> +	return 0;
> +report_failure:
> +	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>
> @@ -510,27 +512,27 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
>
>  	ret = regmap_read(dev->regmap, 0x5A, &val);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	RF_GC = val & 0x0f;
>
>  	ret = regmap_read(dev->regmap, 0x5F, &val);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	IF_GC = val & 0x0f;
>
>  	ret = regmap_read(dev->regmap, 0x3F, &val);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	TIA_GC = (val >> 4) & 0x07;
>
>  	ret = regmap_read(dev->regmap, 0x77, &val);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	BB_GC = (val >> 4) & 0x0f;
>
>  	ret = regmap_read(dev->regmap, 0x76, &val);
>  	if (ret)
> -		goto err;
> +		goto report_failure;
>  	PGA2_GC = val & 0x3f;
>  	PGA2_cri = PGA2_GC >> 2;
>  	PGA2_crf = PGA2_GC & 0x03;
> @@ -562,9 +564,9 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
>  	/* scale value to 0x0000-0xffff */
>  	gain = clamp_val(gain, 1000U, 10500U);
>  	*strength = (10500 - gain) * 0xffff / (10500 - 1000);
> -err:
> -	if (ret)
> -		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
> +	return 0;
> +report_failure:
> +	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>
> --
> 2.6.3
>
>
