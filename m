Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60112 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbaBDTlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 14:41:22 -0500
Message-ID: <52F1425C.6030604@iki.fi>
Date: Tue, 04 Feb 2014 21:41:16 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 2/4] e4000: implement controls via v4l2 control framework
References: <1391478000-24239-1-git-send-email-crope@iki.fi> <1391478000-24239-3-git-send-email-crope@iki.fi> <52F134BD.2050201@xs4all.nl>
In-Reply-To: <52F134BD.2050201@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Hans

On 04.02.2014 20:43, Hans Verkuil wrote:
> On 02/04/2014 02:39 AM, Antti Palosaari wrote:
>> Implement gain and bandwidth controls using v4l2 control framework.
>> Pointer to control handler is provided by exported symbol.
>>
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/tuners/e4000.c      | 142 +++++++++++++++++++++++++++++++++++++-
>>   drivers/media/tuners/e4000.h      |  14 ++++
>>   drivers/media/tuners/e4000_priv.h |  12 ++++
>>   3 files changed, 167 insertions(+), 1 deletion(-)

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
>> +	case  V4L2_CID_MIXER_GAIN_AUTO:
>> +	case  V4L2_CID_MIXER_GAIN:
>> +	case  V4L2_CID_IF_GAIN_AUTO:
>> +	case  V4L2_CID_IF_GAIN:
>> +		ret = e4000_set_gain(priv->fe);
>
> That won't work. You need to handle each gain cluster separately. The control
> framework processes the controls one cluster at a time and takes a lock on the
> master control before calling s_ctrl. The ctrl->val field is only valid inside
> s_ctrl for the controls in the cluster, not for other controls. For other
> controls only the ctrl->cur.val field is valid.

hmm, actually it worked fine on my tests - but I think see your point. 
It likely woks as my app sets one control per call, but if you try to 
set multiple controls then it go out of sync I think.

I am going to split that gain function to three pieces then.

regards
Antti

-- 
http://palosaari.fi/
