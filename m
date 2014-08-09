Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52924 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaHIWQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 18:16:49 -0400
Message-ID: <53E69DCD.10804@iki.fi>
Date: Sun, 10 Aug 2014 01:16:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4 v2] support for DVBSky dvb-s2 usb: Add ts clock and
 clock polarity, lnb set voltage for m88ds3103
References: <201408081150404538007@gmail.com>
In-Reply-To: <201408081150404538007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2014 06:50 AM, nibble.max wrote:
> Add ts clock and clock polarity, lnb set voltage.

> +static int m88ds3103_set_voltage(struct dvb_frontend *fe,
> +	fe_sec_voltage_t voltage)
> +{
> +	struct m88ds3103_priv *priv = fe->demodulator_priv;
> +	u8 data;
> +
> +	dev_dbg(&priv->i2c->dev, "%s: pin_ctrl = (%02x)\n",
> +			__func__, priv->cfg->pin_ctrl);
> +
> +	m88ds3103_rd_reg(priv, 0xa2, &data);
> +
> +	if (priv->cfg->pin_ctrl & 0x80) { /*If control pin is assigned.*/
> +		data &= ~0x03; /* bit0 V/H, bit1 off/on */
> +		if (priv->cfg->pin_ctrl & 0x02)
> +			data |= 0x02;
> +
> +		switch (voltage) {
> +		case SEC_VOLTAGE_18:
> +		     if ((priv->cfg->pin_ctrl & 0x01) == 0)
> +			data |= 0x01;
> +		     break;
> +		case SEC_VOLTAGE_13:
> +		     if (priv->cfg->pin_ctrl & 0x01)
> +			data |= 0x01;
> +		     break;
> +		case SEC_VOLTAGE_OFF:
> +		     if (priv->cfg->pin_ctrl & 0x02)
> +			data &= ~0x02;
> +		     else
> +			data |= 0x02;
> +		     break;
> +		}
> +	}
> +	m88ds3103_wr_reg(priv, 0xa2, data);
> +
> +	return 0;
> +}

> +	/*
> +	 * LNB pin control
> +	 *
> +	 */
> +	u8 pin_ctrl;

That do not do anything meaningful if pin_ctrl b7 is 0? I think our way 
to implement things is to set unneeded callbacks to NULL. DVB-core 
checks existence of each callback before calling - if callback is NULL 
it means it is not used. No need to add special driver specific 
configuration values.

Other LNB control bits are not documented in m88ds3103_config. What it 
looks, there is 2 other bits used too - b0 and b1.
b0 : polarity of vertical/horizontal output pin
b1 : polarity of LNB enable/disable output pin

I think better to define 2 one bit wide bit vector (like you did for 
ts_clk_pol) and set defaults (bit == zero) like reference design does.

After these changes I am fine with this driver and will apply it.

regards
Antti

-- 
http://palosaari.fi/
