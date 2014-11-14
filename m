Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47890 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935404AbaKNXgx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 18:36:53 -0500
Message-ID: <54669210.1070101@iki.fi>
Date: Sat, 15 Nov 2014 01:36:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] rtl2832: implement PIP mode
References: <1415766190-24482-1-git-send-email-crope@iki.fi>	<1415766190-24482-3-git-send-email-crope@iki.fi> <20141114173440.427324a8@recife.lan>
In-Reply-To: <20141114173440.427324a8@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 11/14/2014 09:34 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 12 Nov 2014 06:23:04 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Implement PIP mode to stream from slave demodulator. PIP mode is
>> enabled when .set_frontend is called with RF frequency 0, otherwise
>> normal demod mode is enabled.
>
> This would be an API change, so, a DocBook patch is required.

You are wrong. PIP mode is driver/device internal thing and will not be 
revealed to userspace.

> Anyway, using frequency=0 for PIP doesn't seem to be a good idea,
> as a read from GET_PROPERTY should override the cache with the real
> frequency.

Yes, it is a hackish solution, used to put demod#0 on certain config 
when demod#1 is used. When PIP mode is set that demod#0 is totally 
useless as demod#1 is in use instead. Cache is garbage and no meaning at 
all.

> Also, someone came with me with a case where auto-frequency would
> be interesting, and proposed frequency=0. I was not convinced
> (and patches weren't sent), but using 0 for AUTO seems more
> appropriate, as we do the same for bandwidth (and may do the same
> for symbol_rate).

I totally agree that is is hackish solution. That is called from 
rtl28xxu.c driver and I added already comment it is hackish solution, 
but you didn't apply that commit.

> So, the best seems to add a new property to enable PIP mode.

No, no, no. It is like a PIP filter. It is actually special case of PID 
filter, having mux, to multiplex 2 TS interfaces to one (PIP = Picture 
in Picture).


.............................................
. RTL2832P integrates RTL2832 demodulator   .
. ____________                ____________  .              ____________
.|   USB IF   |              |   demod    | .             |   demod    |
.|------------|              |------------| .             |------------|
.|  RTL2832P  |              |  RTL2832   | .             |  MN88472   |
.|            |----TS bus----|-----/ -----|-.---TS bus----|            |
.|____________|              |____________| .             |____________|
.............................................


So the basically both demod PID filters are now implemented in RTL2832 
demod. Currently PIP mode is configured just to pass all the PIDs from 
MN88472 and reject RTL2832 PIDs. And when PIP mode is off, at pass all 
the PIDs from RTL2832, but rejects all PIDs from MN88472.

regards
Antti


>
> Regards,
> Mauro
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/rtl2832.c | 42 ++++++++++++++++++++++++++++++++---
>>   1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
>> index eb737cf..a58b456 100644
>> --- a/drivers/media/dvb-frontends/rtl2832.c
>> +++ b/drivers/media/dvb-frontends/rtl2832.c
>> @@ -258,13 +258,11 @@ static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
>>   	return rtl2832_rd(priv, reg, val, len);
>>   }
>>
>> -#if 0 /* currently not used */
>>   /* write single register */
>>   static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 val)
>>   {
>>   	return rtl2832_wr_regs(priv, reg, page, &val, 1);
>>   }
>> -#endif
>>
>>   /* read single register */
>>   static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
>> @@ -595,6 +593,44 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
>>   			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
>>   			__func__, c->frequency, c->bandwidth_hz, c->inversion);
>>
>> +	/* PIP mode */
>> +	if (c->frequency == 0) {
>> +		dev_dbg(&priv->i2c->dev, "%s: setting PIP mode\n", __func__);
>> +		ret = rtl2832_wr_regs(priv, 0x0c, 1, "\x5f\xff", 2);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_demod_reg(priv, DVBT_PIP_ON, 0x1);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_reg(priv, 0xbc, 0, 0x18);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_reg(priv, 0x22, 0, 0x01);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_reg(priv, 0x26, 0, 0x1f);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_reg(priv, 0x27, 0, 0xff);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ret = rtl2832_wr_regs(priv, 0x92, 1, "\x7f\xf7\xff", 3);
>> +		if (ret)
>> +			goto err;
>> +
>> +		goto exit_soft_reset;
>> +	} else {
>> +		ret = rtl2832_wr_regs(priv, 0x92, 1, "\x00\x0f\xff", 3);
>> +		if (ret)
>> +			goto err;
>> +	}
>> +
>>   	/* program tuner */
>>   	if (fe->ops.tuner_ops.set_params)
>>   		fe->ops.tuner_ops.set_params(fe);
>> @@ -661,7 +697,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
>>   	if (ret)
>>   		goto err;
>>
>> -
>> +exit_soft_reset:
>>   	/* soft reset */
>>   	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
>>   	if (ret)

-- 
http://palosaari.fi/
