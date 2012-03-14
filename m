Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40718 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab2CNVgQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 17:36:16 -0400
Message-ID: <4F610F4D.6080402@iki.fi>
Date: Wed, 14 Mar 2012 23:36:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 FOR 3.4] af9015: fix i2c failures for dual-tuner devices
 - part 2
References: <1331735251-15393-1-git-send-email-crope@iki.fi>  <1331735251-15393-2-git-send-email-crope@iki.fi> <1331759693.5713.12.camel@tvbox>
In-Reply-To: <1331759693.5713.12.camel@tvbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.03.2012 23:14, Malcolm Priestley wrote:
> On Wed, 2012-03-14 at 16:27 +0200, Antti Palosaari wrote:
>> Some changes for previous patch I liked to do.
>> Just move tuner init and sleep to own functions from the demod
>> init and sleep functions.  Functionality remains still almost the same.
>>
>> Signed-off-by: Antti Palosaari<crope@iki.fi>
>> ---
>>   drivers/media/dvb/dvb-usb/af9015.c |   74 ++++++++++++++++++++++-------------
>>   drivers/media/dvb/dvb-usb/af9015.h |    4 +-
>>   2 files changed, 48 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
>> index 9307b4ca..7e70ea5 100644
>> --- a/drivers/media/dvb/dvb-usb/af9015.c
>> +++ b/drivers/media/dvb/dvb-usb/af9015.c
>> @@ -1141,18 +1141,7 @@ static int af9015_af9013_init(struct dvb_frontend *fe)
>>   		return -EAGAIN;
>>
>>   	ret = priv->init[adap->id](fe);
>> -	if (ret)
>> -		goto err_unlock;
>> -
>> -	if (priv->tuner_ops_init[adap->id]) {
>> -		if (fe->ops.i2c_gate_ctrl)
>> -			fe->ops.i2c_gate_ctrl(fe, 1);
>> -		ret = priv->tuner_ops_init[adap->id](fe);
>> -		if (fe->ops.i2c_gate_ctrl)
>> -			fe->ops.i2c_gate_ctrl(fe, 0);
>> -	}
>>
>> -err_unlock:
>>   	mutex_unlock(&adap->dev->usb_mutex);
>>
>>   	return ret;
>> @@ -1168,24 +1157,48 @@ static int af9015_af9013_sleep(struct dvb_frontend *fe)
>>   	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
>>   		return -EAGAIN;
>>
>> -	if (priv->tuner_ops_sleep[adap->id]) {
>> -		if (fe->ops.i2c_gate_ctrl)
>> -			fe->ops.i2c_gate_ctrl(fe, 1);
>> -		ret = priv->tuner_ops_sleep[adap->id](fe);
>> -		if (fe->ops.i2c_gate_ctrl)
>> -			fe->ops.i2c_gate_ctrl(fe, 0);
>> -		if (ret)
>> -			goto err_unlock;
>> -	}
>> -
>>   	ret = priv->sleep[adap->id](fe);
>>
>> -err_unlock:
>>   	mutex_unlock(&adap->dev->usb_mutex);
>>
>>   	return ret;
>>   }
>>
>> +/* override tuner callbacks for resource locking */
>> +static int af9015_tuner_init(struct dvb_frontend *fe)
>> +{
>> +	int ret;
>> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
>> +	struct af9015_state *priv = adap->dev->priv;
>> +
>> +	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
>> +		return -EAGAIN;
> Hi Antti
>
> I think using mutex_lock_interruptible errors into dvb-usb causes false
> errors and errors caused by missed registers.
>
> I prefer to use mutex_lock only return genuine device errors.

IIRC documentation says mutex_lock_interruptible() must be used instead 
of mutex_lock() when possible. I don't see any reason why I it should be 
changed.

regards
Antti

-- 
http://palosaari.fi/
