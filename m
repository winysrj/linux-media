Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54553 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2HLQ3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 12:29:00 -0400
Received: by lbbgj3 with SMTP id gj3so968131lbb.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 09:28:58 -0700 (PDT)
Message-ID: <5027D9BD.9020108@iki.fi>
Date: Sun, 12 Aug 2012 19:28:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] dvb_frontend: do not allow statistic IOCTLs when
 sleeping
References: <1344551101-16700-1-git-send-email-crope@iki.fi> <1344551101-16700-4-git-send-email-crope@iki.fi> <5027CB8A.1020204@redhat.com>
In-Reply-To: <5027CB8A.1020204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2012 06:28 PM, Mauro Carvalho Chehab wrote:
> Em 09-08-2012 19:25, Antti Palosaari escreveu:
>> Demodulator cannot perform statistic IOCTLs when it is not tuned.
>> Return -EPERM in such case.
>
> While, in general, doing it makes sense, -EPERM is a very bad return code.
> It is used to indicate when accessing some resources would require root access.

OK, makes sense. As I mentioned in coder letter I selected that due to 
V4L2 usage to keep consistent.
VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD
VIDIOC_ENCODER_CMD, VIDIOC_TRY_ENCODER_CMD

Cover letter also lists all the other error codes I found suitable. 
Which one you prefer?


>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++--------
>>   1 file changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index 4fc11eb..40efcde 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -2157,27 +2157,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
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
>> +				err = -EPERM;
>> +		}
>>   		break;
>>
>>   	case FE_READ_SIGNAL_STRENGTH:
>> -		if (fe->ops.read_signal_strength)
>> -			err = fe->ops.read_signal_strength(fe, (__u16*) parg);
>> +		if (fe->ops.read_signal_strength) {
>> +			if (fepriv->thread)
>> +				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
>> +			else
>> +				err = -EPERM;
>> +		}
>>   		break;
>
> Signal strength can still be available even without locking.

So it is correct. :)
It checks if frontend thread is running, not demodulator lock flags.

Actually, my original plan was to use demod lock flags but after looking 
various demod drivers I ended-up conclusion it is not wise. Many demod 
drivers just set all flags at the same time when there is full lock 
gained and never provide more accurate info - all or nothing.

Anyhow, that solution prevents I/O errors when demod is so deep sleep 
state (like reset) it cannot even answer at all.


>>   	case FE_READ_SNR:
>> -		if (fe->ops.read_snr)
>> -			err = fe->ops.read_snr(fe, (__u16*) parg);
>> +		if (fe->ops.read_snr) {
>> +			if (fepriv->thread)
>> +				err = fe->ops.read_snr(fe, (__u16 *) parg);
>> +			else
>> +				err = -EPERM;
>> +		}
>>   		break;
>>
>>   	case FE_READ_UNCORRECTED_BLOCKS:
>> -		if (fe->ops.read_ucblocks)
>> -			err = fe->ops.read_ucblocks(fe, (__u32*) parg);
>> +		if (fe->ops.read_ucblocks) {
>> +			if (fepriv->thread)
>> +				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
>> +			else
>> +				err = -EPERM;
>> +		}
>>   		break;
>>
>> -
>>   	case FE_DISEQC_RESET_OVERLOAD:
>>   		if (fe->ops.diseqc_reset_overload) {
>>   			err = fe->ops.diseqc_reset_overload(fe);
>>
>
> Regards,
> Mauro

regards
Antti


-- 
http://palosaari.fi/
