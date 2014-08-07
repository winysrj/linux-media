Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35865 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbaHGISE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Aug 2014 04:18:04 -0400
Message-ID: <53E33638.4070104@iki.fi>
Date: Thu, 07 Aug 2014 11:18:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] support for DVBSky dvb-s2 usb: add some config and
 set_voltage for m88ds3103
References: <201408061227374212345@gmail.com>
In-Reply-To: <201408061227374212345@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

That patch contains (too) many changes:
1) TS clock config option
2) TS clock polarity config option
3) start_ctrl() callback
4) set_voltage implementation
5) set_voltage() callback

Generally I am fine with 1, 2 and 4.

When you do that many different logical changes for existing driver, you
should split it is one patch per change.

Rest of the comments are between the code.


On 08/06/2014 07:27 AM, nibble.max wrote:
> Add some config parameters and set_voltage function for m88ds3103.
> 
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
>   drivers/media/dvb-frontends/m88ds3103.c | 91 +++++++++++++++++++++++----------
>   drivers/media/dvb-frontends/m88ds3103.h | 37 ++++++++++++--
>   2 files changed, 96 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> index dfe0c2f..df2f89c 100644
> --- a/drivers/media/dvb-frontends/m88ds3103.c
> +++ b/drivers/media/dvb-frontends/m88ds3103.c
> @@ -247,8 +247,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   	u8 u8tmp, u8tmp1, u8tmp2;
>   	u8 buf[2];
>   	u16 u16tmp, divide_ratio;
> -	u32 tuner_frequency, target_mclk, ts_clk;
> +	u32 tuner_frequency, target_mclk;
>   	s32 s32tmp;
> +	fe_status_t status;
>   	dev_dbg(&priv->i2c->dev,
>   			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
>   			__func__, c->delivery_system,
> @@ -316,9 +317,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   				target_mclk = 144000;
>   			break;
>   		case M88DS3103_TS_PARALLEL:
> -		case M88DS3103_TS_PARALLEL_12:
> -		case M88DS3103_TS_PARALLEL_16:
> -		case M88DS3103_TS_PARALLEL_19_2:
>   		case M88DS3103_TS_CI:
>   			if (c->symbol_rate < 18000000)
>   				target_mclk = 96000;
> @@ -352,33 +350,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   	switch (priv->cfg->ts_mode) {
>   	case M88DS3103_TS_SERIAL:
>   		u8tmp1 = 0x00;
> -		ts_clk = 0;
> -		u8tmp = 0x46;
> +		u8tmp = 0x06;
>   		break;
>   	case M88DS3103_TS_SERIAL_D7:
>   		u8tmp1 = 0x20;
> -		ts_clk = 0;
> -		u8tmp = 0x46;
> +		u8tmp = 0x06;
>   		break;
>   	case M88DS3103_TS_PARALLEL:
> -		ts_clk = 24000;
> -		u8tmp = 0x42;
> -		break;
> -	case M88DS3103_TS_PARALLEL_12:
> -		ts_clk = 12000;
> -		u8tmp = 0x42;
> -		break;
> -	case M88DS3103_TS_PARALLEL_16:
> -		ts_clk = 16000;
> -		u8tmp = 0x42;
> -		break;
> -	case M88DS3103_TS_PARALLEL_19_2:
> -		ts_clk = 19200;
> -		u8tmp = 0x42;
> +		u8tmp = 0x02;
>   		break;
>   	case M88DS3103_TS_CI:
> -		ts_clk = 6000;
> -		u8tmp = 0x43;
> +		u8tmp = 0x03;
>   		break;
>   	default:
>   		dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n", __func__);
> @@ -386,6 +368,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   		goto err;
>   	}
>   
> +	if (priv->cfg->ts_clk_pol)
> +		u8tmp |= 0x40;
> +
>   	/* TS mode */
>   	ret = m88ds3103_wr_reg(priv, 0xfd, u8tmp);
>   	if (ret)
> @@ -399,8 +384,8 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   			goto err;
>   	}
>   
> -	if (ts_clk) {
> -		divide_ratio = DIV_ROUND_UP(target_mclk, ts_clk);
> +	if (priv->cfg->ts_clk) {
> +		divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
>   		u8tmp1 = divide_ratio / 2;
>   		u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
>   	} else {
> @@ -411,7 +396,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   
>   	dev_dbg(&priv->i2c->dev,
>   			"%s: target_mclk=%d ts_clk=%d divide_ratio=%d\n",
> -			__func__, target_mclk, ts_clk, divide_ratio);
> +			__func__, target_mclk, priv->cfg->ts_clk, divide_ratio);
>   
>   	u8tmp1--;
>   	u8tmp2--;
> @@ -523,6 +508,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   
>   	priv->delivery_system = c->delivery_system;
>   
> +	if (priv->cfg->start_ctrl) {
> +		for (len = 0; len < 30 ; len++) {
> +			m88ds3103_read_status(fe, &status);
> +			if (status & FE_HAS_LOCK) {
> +				priv->cfg->start_ctrl(fe);
> +				break;
> +			}
> +			msleep(20);
> +		}
> +	}
> +

What is idea of that start_ctrl logic? It looks ugly. Why it is needed?
What is wrong with default DVB-core implementation? You should not need
to poll demod lock here and then call streaming control callback from
USB driver. If you implement .streaming_ctrl() callback to DVB USB
driver, it is called automatically for you.


>   	return 0;
>   err:
>   	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
> @@ -1053,6 +1049,46 @@ err:
>   	return ret;
>   }
>   
> +static int m88ds3103_set_voltage(struct dvb_frontend *fe,
> +	fe_sec_voltage_t voltage)
> +{
> +	struct m88ds3103_priv *priv = fe->demodulator_priv;
> +	u8 data;
> +
> +	dev_dbg(&priv->i2c->dev, "%s: pin_ctrl = (%02x)\n",
> +			__func__, priv->cfg->pin_ctrl);
> +
> +	if (priv->cfg->set_voltage)
> +		priv->cfg->set_voltage(fe, voltage);

Own callback. Why?
If you really need alter some standard demod callback execution path,
you should do it overriding callback inside bus interface driver (USB
driver in that case) and not taint demod driver with custom callbacks
like that. Also, if you really need some weird stuff (something which is
not normal looking) you need to add comments why it is needed.
See af9015.c driver as a example how to override demod callbacks.

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
> +	return 0;
> +}
> +

Otherwise that m88ds3103_set_voltage looks fine, but custom callback
(priv->cfg->set_voltage) should go away as there is no need for it.

>   static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
>   		struct dvb_diseqc_master_cmd *diseqc_cmd)
>   {
> @@ -1370,6 +1406,7 @@ static struct dvb_frontend_ops m88ds3103_ops = {
>   	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
>   
>   	.set_tone = m88ds3103_set_tone,
> +	.set_voltage = m88ds3103_set_voltage,
>   };
>   
>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
> diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
> index bbb7e3a..db82d89 100644
> --- a/drivers/media/dvb-frontends/m88ds3103.h
> +++ b/drivers/media/dvb-frontends/m88ds3103.h
> @@ -47,14 +47,23 @@ struct m88ds3103_config {
>   	 */
>   #define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
>   #define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
> -#define M88DS3103_TS_PARALLEL           2 /* 24 MHz, normal */
> -#define M88DS3103_TS_PARALLEL_12        3 /* 12 MHz */
> -#define M88DS3103_TS_PARALLEL_16        4 /* 16 MHz */
> -#define M88DS3103_TS_PARALLEL_19_2      5 /* 19.2 MHz */
> -#define M88DS3103_TS_CI                 6 /* 6 MHz */
> +#define M88DS3103_TS_PARALLEL           2 /* TS Parallel mode */
> +#define M88DS3103_TS_CI                 3 /* TS CI Mode */
>   	u8 ts_mode;
>   
>   	/*
> +	 * TS clk in KHz
> +	 * Default: 0.
> +	 */
> +	u32 ts_clk;
> +
> +	/*
> +	 * TS clk polarity.
> +	 * Default: 0. 1-active at falling edge; 0-active at rising edge.
> +	 */
> +	u8 ts_clk_pol:1;
> +
> +	/*
>   	 * spectrum inversion
>   	 * Default: 0
>   	 */
> @@ -86,6 +95,24 @@ struct m88ds3103_config {
>   	 * Default: none, must set
>   	 */
>   	u8 agc;
> +
> +	/*
> +	 * LNB pin control
> +	 *
> +	 */
> +	u8 pin_ctrl;
> +
> +	/*
> +	 * LNB voltage function
> +	 *
> +	 */
> +	int (*set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
> +
> +	/*
> +	 * start stream function
> +	 *
> +	 */
> +	int (*start_ctrl)(struct dvb_frontend *fe);
>   };
>   
>   /*

regards
Antti

-- 
http://palosaari.fi/
