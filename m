Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35150 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaJDE0T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Oct 2014 00:26:19 -0400
Message-ID: <542F76E5.8080601@iki.fi>
Date: Sat, 04 Oct 2014 07:26:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] af9033: fix DVBv3 signal strength value not correct
 issue
References: <1412227954.1699.2.camel@ite-desktop>
In-Reply-To: <1412227954.1699.2.camel@ite-desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I did some review and testing. Before that patch, IT9133 DVBv3 signal 
strength measurement was broken - it returned 0xffff all the time. After 
that is returns some realistic values between 0-0xffff.

Anyhow, AF9033 chip version it worked earlier too, just like old comment 
says hw returns 0-100, which was scaled to 0-0xffff.

AF9033 and IT9133 firmware differs on signal strength measurement. For 
AF9033 it provides both percentage and dBm reports, for IT9133 I know 
only dBm report.

AF9033:
0x800048 relative (0-100, percentage)
0x80004a decibel (-VAL dBm)

IT9133:
0x8000f7 decibel (VAL - 100 dBm)


Now you changed that AF9033 implementation from 0x800048 (percentage) to 
0x80004a (dBm) and scale that to 0-0xffff, which results poorer result 
than old implementation calculated by firmware.

What I tested that implementation, it gives maximum value 0x6e14, which 
we could calc is 43dBm. I was using -18dBm RF level (which is very very 
strong), so I suspect that 43dBm is maximum what firmware even could 
report. Having maximum possible signal strength only 43% (out of 100%) 
is not nice.


So I ask you change AF9035 as it has been (percentage reported by FW). 
Change only non-working IT9135 what you like.

Also, add error checking just after register reads and jump out if fails.

regards
Antti


On 10/02/2014 08:32 AM, Bimow Chen wrote:
> Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.
>
>
> 0001-af9033-fix-DVBv3-signal-strength-value-not-correct-i.patch
>
>
>>From 02ee7de4600a43a322f75cf04d273effa04d3a42 Mon Sep 17 00:00:00 2001
> From: Bimow Chen<Bimow.Chen@ite.com.tw>
> Date: Wed, 1 Oct 2014 18:28:54 +0800
> Subject: [PATCH 1/2] af9033: fix DVBv3 signal strength value not correct issue
>
> Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.
>
> Signed-off-by: Bimow Chen<Bimow.Chen@ite.com.tw>
> ---
>   drivers/media/dvb-frontends/af9033.c      |   43 +++++++++++++++++++++++-----
>   drivers/media/dvb-frontends/af9033_priv.h |    6 ++++
>   2 files changed, 41 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
> index 63a89c1..2b3d2f0 100644
> --- a/drivers/media/dvb-frontends/af9033.c
> +++ b/drivers/media/dvb-frontends/af9033.c
> @@ -862,16 +862,43 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
>   static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>   {
>   	struct af9033_dev *dev = fe->demodulator_priv;
> -	int ret;
> -	u8 strength2;
> +	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
> +	int ret, tmp, power_real;
> +	u8 u8tmp, gain_offset, buf[7];
>
> -	/* read signal strength of 0-100 scale */
> -	ret = af9033_rd_reg(dev, 0x800048, &strength2);
> -	if (ret < 0)
> -		goto err;
> +	if (dev->is_af9035) {
> +		ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
> +		/* scale value to 0x0000-0xffff */
> +		*strength = u8tmp * 0xffff / 100;
> +	} else {
> +		ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
> +		ret |= af9033_rd_regs(dev, 0x80f900, buf, 7);
> +
> +		if (c->frequency <= 300000000)
> +			gain_offset = 7; /* VHF */
> +		else
> +			gain_offset = 4; /* UHF */
> +
> +		power_real = (u8tmp - 100 - gain_offset) -
> +			power_reference[((buf[3] >> 0) & 3)][((buf[6] >> 0) & 7)];
> +
> +		if (power_real < -15)
> +			tmp = 0;
> +		else if ((power_real >= -15) && (power_real < 0))
> +			tmp = (2 * (power_real + 15)) / 3;
> +		else if ((power_real >= 0) && (power_real < 20))
> +			tmp = 4 * power_real + 10;
> +		else if ((power_real >= 20) && (power_real < 35))
> +			tmp = (2 * (power_real - 20)) / 3 + 90;
> +		else
> +			tmp = 100;
> +
> +		/* scale value to 0x0000-0xffff */
> +		*strength = tmp * 0xffff / 100;
> +	}
>
> -	/* scale value to 0x0000-0xffff */
> -	*strength = strength2 * 0xffff / 100;
> +	if (ret)
> +		goto err;
>
>   	return 0;
>
> diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
> index c12c92c..c9c8798 100644
> --- a/drivers/media/dvb-frontends/af9033_priv.h
> +++ b/drivers/media/dvb-frontends/af9033_priv.h
> @@ -2051,4 +2051,10 @@ static const struct reg_val tuner_init_it9135_62[] = {
>   	{ 0x80fd8b, 0x00 },
>   };
>
> +/* NorDig power reference table */
> +static const int power_reference[][5] = {
> +	{-93, -91, -90, -89, -88}, /* QPSK 1/2 ~ 7/8 */
> +	{-87, -85, -84, -83, -82}, /* 16QAM 1/2 ~ 7/8 */
> +	{-82, -80, -78, -77, -76}, /* 64QAM 1/2 ~ 7/8 */
> +};
>   #endif /* AF9033_PRIV_H */
> -- 1.7.0.4
>

-- 
http://palosaari.fi/
