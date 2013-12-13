Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1799 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3LMOGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:06:24 -0500
Message-ID: <52AB1447.9090601@xs4all.nl>
Date: Fri, 13 Dec 2013 15:05:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 4/4] v4l: 1 Hz resolution flag for tuners
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-5-git-send-email-crope@iki.fi> <52A96C00.8060607@xs4all.nl> <52A9F0C7.2050602@iki.fi>
In-Reply-To: <52A9F0C7.2050602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 06:22 PM, Antti Palosaari wrote:
> Hi Hans!
> 
> On 12.12.2013 09:55, Hans Verkuil wrote:
>> On 12/12/2013 12:54 AM, Antti Palosaari wrote:
>>> Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.
>>>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>> ---
>>>   include/uapi/linux/videodev2.h | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 6c6a601..1bac6c4 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -1349,6 +1349,7 @@ struct v4l2_modulator {
>>>   #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>>>   #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>>>   #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
>>> +#define V4L2_TUNER_CAP_1HZ		0x1000
>>>
>>>   /*  Flags for the 'rxsubchans' field */
>>>   #define V4L2_TUNER_SUB_MONO		0x0001
>>>
>>
>> I was wondering, do the band modulation systems (V4L2_BAND_MODULATION_VSB etc.) cover SDR?
> 
> There is no such modulations defined for SDR hardware level. SDR 
> demodulation is done by software called DSP (digital signal processing) 
> in host computer.
> 
> In ideal case, SDR receiver has only 1 property: ADC (analog to digital 
> converter) sampling rate.

So in that case the band modulation would be 0, right?

> 
> But as digital signal processing is very CPU intensive when sampling 
> rates are increased, there is very often RF tuner used to down-convert 
> actual radio frequency to low-IF / BB. Then ADC is used to sample that 
> baseband / low-IF signal and only small sampling rate is needed => 
> stream is smaller => DSP does not need so much CPU.

How does the application know that there is an RF tuner? I assume that
the app needs to know this?

As you can probably tell, I basically know nothing about SDR, so forgive
me if I am asking stupid questions. I just want to make sure all bases
are covered when it comes to the V4L2 API.

Regards,

	Hans

>> Anyway, I'm happy with this patch series. As far as I am concerned, the next step would
>> be to add documention and I would also recommend updating v4l2-compliance. Writing docs
>> and adding compliance tests has proven useful in the past to discover ambiguous API specs.
> 
> I will do these at finally when I drivers and applications are tested to 
> be working.
> 
> regards
> Antti
> 

