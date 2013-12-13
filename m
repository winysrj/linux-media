Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3808 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3LMQIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:08:36 -0500
Message-ID: <52AB30E9.40209@xs4all.nl>
Date: Fri, 13 Dec 2013 17:08:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 4/4] v4l: 1 Hz resolution flag for tuners
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-5-git-send-email-crope@iki.fi> <52A96C00.8060607@xs4all.nl> <52A9F0C7.2050602@iki.fi> <52AB1447.9090601@xs4all.nl> <52AB2B02.3090300@iki.fi>
In-Reply-To: <52AB2B02.3090300@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2013 04:42 PM, Antti Palosaari wrote:
> On 13.12.2013 16:05, Hans Verkuil wrote:
>> On 12/12/2013 06:22 PM, Antti Palosaari wrote:
>>> Hi Hans!
>>>
>>> On 12.12.2013 09:55, Hans Verkuil wrote:
>>>> On 12/12/2013 12:54 AM, Antti Palosaari wrote:
>>>>> Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.
>>>>>
>>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>>> ---
>>>>>    include/uapi/linux/videodev2.h | 1 +
>>>>>    1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>>>> index 6c6a601..1bac6c4 100644
>>>>> --- a/include/uapi/linux/videodev2.h
>>>>> +++ b/include/uapi/linux/videodev2.h
>>>>> @@ -1349,6 +1349,7 @@ struct v4l2_modulator {
>>>>>    #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>>>>>    #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>>>>>    #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
>>>>> +#define V4L2_TUNER_CAP_1HZ		0x1000
>>>>>
>>>>>    /*  Flags for the 'rxsubchans' field */
>>>>>    #define V4L2_TUNER_SUB_MONO		0x0001
>>>>>
>>>>
>>>> I was wondering, do the band modulation systems (V4L2_BAND_MODULATION_VSB etc.) cover SDR?
>>>
>>> There is no such modulations defined for SDR hardware level. SDR
>>> demodulation is done by software called DSP (digital signal processing)
>>> in host computer.
>>>
>>> In ideal case, SDR receiver has only 1 property: ADC (analog to digital
>>> converter) sampling rate.
>>
>> So in that case the band modulation would be 0, right?
> 
> Yes. If you split that radio receiver to some logic blocs, from antenna 
> to host computer:
> 1. Antenna is here
> 2. RF tuner (RF frontend): tuner "band" belongs here
> 3. ADC: sampling rate
> 4. demodulator (modulation lives here)
> 
> In a case of traditional hw based demodulator PC/host computer is 
> located as a number 5. In a case of a software defined radio receiver 
> host computer is next to ADC, between 3-4. Demodulator itself is DSP 
> software running on host computer.
> 
> 
>>> But as digital signal processing is very CPU intensive when sampling
>>> rates are increased, there is very often RF tuner used to down-convert
>>> actual radio frequency to low-IF / BB. Then ADC is used to sample that
>>> baseband / low-IF signal and only small sampling rate is needed =>
>>> stream is smaller => DSP does not need so much CPU.
>>
>> How does the application know that there is an RF tuner? I assume that
>> the app needs to know this?
> 
> Yes, that indeed needs to be know. It is one key issue to resolve. 
> Something like a capability flag works or application could test it 
> when. Like if tuner type is "ADC" then enumerate if there is tuner type 
> "SDR" also.

Instead of calling it TUNER_TYPE_SDR, shouldn't it be called TUNER_TYPE_RF?
Or perhaps _SDR_RF?

> Or expect there is always RF tuner and frequency is 
> programmed as a 0 Hz when it is not really there. Enumeration of RF 
> tuner returns only supported frequency as a 0Hz to tell there is only ADC.

I think just enumerating tuners to see if there is a RF tuner would be
sufficient.

> 
> 
>> As you can probably tell, I basically know nothing about SDR, so forgive
>> me if I am asking stupid questions. I just want to make sure all bases
>> are covered when it comes to the V4L2 API.
> 
> I really appreciate that as simply has no enough knowledge from V4L2 API 
> and API changes are needed. I will try to list here shortly some SDR 
> devices in general level enough.
> 
> ant = antenna
> host = host computer, PC (SW modulator/demodulator)
> ADC = analog to digital converter
> DAC = digital to analog converter
> amp = amplifier
> mixer = "TX tuner"
> 
> receiver:
> ant <> RF tuner <> ADC <> bridge <> host
> ant <>ADC <> bridge <> host
> ant <> up-converter <> RF tuner <> ADC <> bridge <> host
> 
> transmitter:
> ant <> amp <> mixer <> DAC <> bridge <> host
> ant <> mixer <> DAC <> bridge <> host
> ant <> DAC <> bridge <> host
> 
> Those are the used building blocks in some general view. ADC (DAC) is 
> most important hardware block, but RF tuner is also critical in practice.
> 
> So what I understood, V4L2 API "tuner" is kinda logical entity that 
> represent single radio device, containing RF tuner, demodulator and so. 
> That same logical entity in DVB API side is frontend, which is mostly 
> implemented by demodulator with a help of RF tuner.
> 
> So what is needed is to make V4L2 API entity (tuner I guess) that could 
> represent both ADC and RF tuner.

Well, a V4L2 tuner represents the hardware that requires a frequency.
Which for typical radio and TV devices means the RF tuner + demodulator
combo. So externally you see only one tuner, but internally there are
often two devices (tuner and modulator) that have to be controlled.

For SDR you have an RF Tuner with a frequency and an ADC with a frequency,
and the two frequencies can be set independently. So representing that
as two tuners seems like a sensible mapping to me.

Regards,

	Hans
