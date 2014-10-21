Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38191 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376AbaJUVYB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 17:24:01 -0400
Message-ID: <5446CEED.30501@iki.fi>
Date: Wed, 22 Oct 2014 00:23:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nibble Max <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 3/3] DVBSky V3 PCIe card: add some changes to M88DS3103
 for supporting the demod of M88RS6000
References: <201410131444110937756@gmail.com>
In-Reply-To: <201410131444110937756@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/13/2014 09:44 AM, Nibble Max wrote:
> M88RS6000 is the integrated chip, which includes tuner and demod.
> Its internal demod is similar with M88DS3103 except some registers definition.
> The main different part of this internal demod from others is its clock/pll generation IP block sitting inside the tuner die.
> So clock/pll functions should be configed through its tuner i2c bus, NOT its demod i2c bus.
> The demod of M88RS6000 need the firmware: dvb-demod-m88rs6000.fw
> firmware download link: http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz

> @@ -250,6 +251,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   	u16 u16tmp, divide_ratio;
>   	u32 tuner_frequency, target_mclk;
>   	s32 s32tmp;
> +	struct m88rs6000_mclk_config mclk_cfg;
>
>   	dev_dbg(&priv->i2c->dev,
>   			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
> @@ -291,6 +293,26 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	if (priv->chip_id == M88RS6000_CHIP_ID) {
> +		ret = m88ds3103_wr_reg(priv, 0x06, 0xe0);
> +		if (ret)
> +			goto err;
> +		if (fe->ops.tuner_ops.set_config) {
> +			/* select main mclk */
> +			mclk_cfg.config_op = 0;
> +			mclk_cfg.TunerfreqMHz = c->frequency / 1000;
> +			mclk_cfg.SymRateKSs = c->symbol_rate / 1000;
> +			ret = fe->ops.tuner_ops.set_config(fe, &mclk_cfg);
> +			if (ret)
> +				goto err;
> +			priv->mclk_khz = mclk_cfg.MclkKHz;
> +		}
> +		ret = m88ds3103_wr_reg(priv, 0x06, 0x00);
> +		if (ret)
> +			goto err;
> +		usleep_range(10000, 20000);
> +	}

That looks odd and also ugly. You pass some values from demod to tuner 
using set_config callback. Tuner driver can get symbol_rate and 
frequency just similarly from property cache than demod. Why you do it 
like that?

Clock is provided by tuner as you mention. I see you use that to pass 
used clock frequency from tuner to demod. This does not look nice and I 
would like to see clock framework instead. Or calculate clock on both 
drivers. Does the demod clock even needs to be changed? I think it is 
only TS stream size which defines used clock frequency - smaller the TS 
bitstream, the smaller the clock frequency needed => optimizes power 
consumption a little. But TS clock is calculated on tuner driver in any 
case?

regards
Antti

-- 
http://palosaari.fi/
