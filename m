Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38787 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaBEJQm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 04:16:42 -0500
Message-ID: <52F20176.5070302@iki.fi>
Date: Wed, 05 Feb 2014 11:16:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] e4000: implement controls via v4l2 control framework
References: <1391558734-26237-1-git-send-email-crope@iki.fi> <1391558734-26237-2-git-send-email-crope@iki.fi> <52F1E828.6020000@xs4all.nl>
In-Reply-To: <52F1E828.6020000@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Hans

On 05.02.2014 09:28, Hans Verkuil wrote:
> Hi Antti,
>
> Hmm, it's a bit ugly this code. I have some suggestions below...

Yeah, there is some redundancy, I though also the same. But 
functionality is now correct what I see.

It is mostly that DVB gate-control logic which I personally dislike. 
There is quite big changes on my TODO list in order to improve overall 
situation. I already converted that driver to I2C model, it was the 
first step. Next thing is to implement I2C adapter properly => get rid 
of those gate-control callbacks. I did it already [1], but there is 
still some things to study (gate closing, regmap). After driver is 100% 
I2C model (I2C client + no I2C gate hacks) I could switch to regmap, 
which gives some nice stuff like register shadowing and I2C message 
splitting?. So there is a long road to learn and improve things towards 
to current kernel practices, due to payload from history...

After that I likely try to separate tuner functionality out from DVB / 
V4L APIs, still keeping those in same driver, but wrapping functionality.

So lets see if I get some inspiration to rebase that anymore at that 
point :]


[1] 
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/mn88472_dvbc

regards
Antti


>
> On 02/05/2014 01:05 AM, Antti Palosaari wrote:
>> Implement gain and bandwidth controls using v4l2 control framework.
>> Pointer to control handler is provided by exported symbol.
>>
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
>>   drivers/media/tuners/e4000.h      |  14 +++
>>   drivers/media/tuners/e4000_priv.h |  12 +++
>>   3 files changed, 235 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>> index 9187190..77318e9 100644
>> --- a/drivers/media/tuners/e4000.c
>> +++ b/drivers/media/tuners/e4000.c
>> @@ -448,6 +448,178 @@ err:
>>   	return ret;
>>   }
>>
>> +static int e4000_set_lna_gain(struct dvb_frontend *fe)
>
> I would change this to:
>
>   e4000_set_lna_if_gain(struct dvb_frontend *fe, bool lna_auto, bool if_auto, bool set_lna)
>
>> +{
>> +	struct e4000_priv *priv = fe->tuner_priv;
>> +	int ret;
>> +	u8 u8tmp;
>
> General comment: always add a newline after variable declarations.
>
>> +	dev_dbg(&priv->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
>> +			__func__, priv->lna_gain_auto->cur.val,
>> +			priv->lna_gain_auto->val, priv->lna_gain->cur.val,
>> +			priv->lna_gain->val);
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 1);
>> +
>> +	if (priv->lna_gain_auto->val && priv->if_gain_auto->cur.val)
>> +		u8tmp = 0x17;
>> +	else if (priv->lna_gain_auto->val)
>> +		u8tmp = 0x19;
>> +	else if (priv->if_gain_auto->cur.val)
>> +		u8tmp = 0x16;
>> +	else
>> +		u8tmp = 0x10;
>> +
>> +	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
>> +	if (ret)
>> +		goto err;
>> +
>> +	if (priv->lna_gain_auto->val == false) {
>> +		ret = e4000_wr_reg(priv, 0x14, priv->lna_gain->val);
>> +		if (ret)
>> +			goto err;
>> +	}
>
> Set lna gain if set_lna is true and lna_auto is false, set if gain if
> set_lna is false and if_gain is false.
>
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +	return 0;
>
> I would remove the 4 lines above, and instead just...
>
>> +err:
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>
> ...add this:
>
> 	if (ret)
>
>> +	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
>> +	return ret;
>> +}
>> +
>> +static int e4000_set_mixer_gain(struct dvb_frontend *fe)
>> +{
>> +	struct e4000_priv *priv = fe->tuner_priv;
>> +	int ret;
>> +	u8 u8tmp;
>> +	dev_dbg(&priv->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
>> +			__func__, priv->mixer_gain_auto->cur.val,
>> +			priv->mixer_gain_auto->val, priv->mixer_gain->cur.val,
>> +			priv->mixer_gain->val);
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 1);
>> +
>> +	if (priv->mixer_gain_auto->val)
>> +		u8tmp = 0x15;
>> +	else
>> +		u8tmp = 0x14;
>> +
>> +	ret = e4000_wr_reg(priv, 0x20, u8tmp);
>> +	if (ret)
>> +		goto err;
>> +
>> +	if (priv->mixer_gain_auto->val == false) {
>> +		ret = e4000_wr_reg(priv, 0x15, priv->mixer_gain->val);
>> +		if (ret)
>> +			goto err;
>> +	}
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +	return 0;
>> +err:
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
>> +	return ret;
>> +}
>> +
>> +static int e4000_set_if_gain(struct dvb_frontend *fe)
>> +{
>> +	struct e4000_priv *priv = fe->tuner_priv;
>> +	int ret;
>> +	u8 buf[2];
>> +	u8 u8tmp;
>> +	dev_dbg(&priv->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
>> +			__func__, priv->if_gain_auto->cur.val,
>> +			priv->if_gain_auto->val, priv->if_gain->cur.val,
>> +			priv->if_gain->val);
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 1);
>> +
>> +	if (priv->if_gain_auto->val && priv->lna_gain_auto->cur.val)
>> +		u8tmp = 0x17;
>> +	else if (priv->lna_gain_auto->cur.val)
>> +		u8tmp = 0x19;
>> +	else if (priv->if_gain_auto->val)
>> +		u8tmp = 0x16;
>> +	else
>> +		u8tmp = 0x10;
>> +
>> +	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
>> +	if (ret)
>> +		goto err;
>> +
>> +	if (priv->if_gain_auto->val == false) {
>> +		buf[0] = e4000_if_gain_lut[priv->if_gain->val].reg16_val;
>> +		buf[1] = e4000_if_gain_lut[priv->if_gain->val].reg17_val;
>> +		ret = e4000_wr_regs(priv, 0x16, buf, 2);
>> +		if (ret)
>> +			goto err;
>> +	}
>> +
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +	return 0;
>> +err:
>> +	if (fe->ops.i2c_gate_ctrl)
>> +		fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
>> +	return ret;
>> +}
>
> This function can be dropped.
>
>> +
>> +static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct e4000_priv *priv =
>> +			container_of(ctrl->handler, struct e4000_priv, hdl);
>> +	struct dvb_frontend *fe = priv->fe;
>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>> +	int ret;
>> +	dev_dbg(&priv->client->dev,
>> +			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
>> +			__func__, ctrl->id, ctrl->name, ctrl->val,
>> +			ctrl->minimum, ctrl->maximum, ctrl->step);
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_BANDWIDTH_AUTO:
>> +	case V4L2_CID_BANDWIDTH:
>> +		c->bandwidth_hz = priv->bandwidth->val;
>> +		ret = e4000_set_params(priv->fe);
>> +		break;
>> +	case  V4L2_CID_LNA_GAIN_AUTO:
>> +	case  V4L2_CID_LNA_GAIN:
>> +		ret = e4000_set_lna_gain(priv->fe);
>
> Becomes:
>
> 		ret = e4000_set_lna_if_gain(priv->fe, priv->lna_gain_auto->val,
> 				priv->if_gain_auto->cur.val, true);
>
>> +		break;
>> +	case  V4L2_CID_MIXER_GAIN_AUTO:
>> +	case  V4L2_CID_MIXER_GAIN:
>> +		ret = e4000_set_mixer_gain(priv->fe);
>> +		break;
>> +	case  V4L2_CID_IF_GAIN_AUTO:
>> +	case  V4L2_CID_IF_GAIN:
>> +		ret = e4000_set_if_gain(priv->fe);
>
> 		ret = e4000_set_lna_if_gain(priv->fe, priv->lna_gain_auto->cur.val,
> 				priv->if_gain_auto->val, false);
>
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>
> Regards,
>
> 	Hans
>


-- 
http://palosaari.fi/
