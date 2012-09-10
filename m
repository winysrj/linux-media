Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51313 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2IJOjw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 10:39:52 -0400
Message-ID: <504DFBA4.8050402@iki.fi>
Date: Mon, 10 Sep 2012 17:39:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 3/5] dvb_frontend: do not allow statistic IOCTLs when
 sleeping
References: <1345076921-9773-1-git-send-email-crope@iki.fi> <1345076921-9773-4-git-send-email-crope@iki.fi> <504DF8D5.7050709@redhat.com>
In-Reply-To: <504DF8D5.7050709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2012 05:27 PM, Mauro Carvalho Chehab wrote:
> Em 15-08-2012 21:28, Antti Palosaari escreveu:
>> Demodulator cannot perform statistic IOCTLs when it is not tuned.
>> Return -EAGAIN in such case.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++++---------
>>   1 file changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
>> index 2bc80b1..7d079fb 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -2132,27 +2132,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>>   			err = fe->ops.read_status(fe, status);
>>   		break;
>>   	}
>> +
>>   	case FE_READ_BER:
>> -		if (fe->ops.read_ber)
>> -			err = fe->ops.read_ber(fe, (__u32*) parg);
>> +		if (fe->ops.read_ber) {
>> +			if (fepriv->thread)
>> +				err = fe->ops.read_ber(fe, (__u32 *) parg);
>> +			else
>> +				err = -EAGAIN;
>> +		}
>>   		break;
>>
>
>
>>   	case FE_READ_SIGNAL_STRENGTH:
>> -		if (fe->ops.read_signal_strength)
>> -			err = fe->ops.read_signal_strength(fe, (__u16*) parg);
>> +		if (fe->ops.read_signal_strength) {
>> +			if (fepriv->thread)
>> +				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
>> +			else
>> +				err = -EAGAIN;
>> +		}
>>   		break;
>
> This one doesn't look right, as the frontend can be able to get the signal strength
> at the analog part (afaik, most DVB-S frontends do that). Also, some drivers just
> map it to the tuner RF strength.
>
> The proper approach for it is to break signal strength into two different statistics:
> 	- analog RF strength;
> 	- signal strength at the demod, after having demod locked.
>
> It makes sense to return -EAGAIN for the second case, but doing it for the first case
> is bad, as the RF strength can be used on DVB-S devices, in order to fine-adjust the
> antenna position.

I have to say I don't understand what you mean. That one is DVB frontend 
callback and it is not called in case of analog. Could you provide some 
example?

Frontend thread is running always when frontend is opened. It is hard 
for me to see why frontend FE_READ_SIGNAL_STRENGTH should be allowed 
call even frontend is closed.

OK, I will try to grep sources to see what you mean.

regards
Antti

-- 
http://palosaari.fi/
