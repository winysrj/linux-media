Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37916 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3KUVTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 16:19:16 -0500
Message-ID: <528E78CC.2040808@iki.fi>
Date: Thu, 21 Nov 2013 23:19:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: SDR sampling rate - control or IOCTL?
References: <528E3D41.5010508@iki.fi> <20131121154923.32d76094@samsung.com> <528E4F7B.4040208@xs4all.nl> <528E51EB.2080404@iki.fi> <20131121171203.65719175@samsung.com> <528E6B99.5030108@iki.fi> <20131121185449.1104ea67@samsung.com>
In-Reply-To: <20131121185449.1104ea67@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.11.2013 22:54, Mauro Carvalho Chehab wrote:
> Em Thu, 21 Nov 2013 22:22:49 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 21.11.2013 21:12, Mauro Carvalho Chehab wrote:
>>> Em Thu, 21 Nov 2013 20:33:15 +0200
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> On 21.11.2013 20:22, Hans Verkuil wrote:

>>>>> BTW, can the sample rate change while streaming? Typically things you set
>>>>> through S_FMT can not be changed while streaming.
>>>>
>>>> Yes, but in practice it is uncommon. When I reverse-engineered Mirics
>>>> MSi2500 USB ADC I did it hundred of times. Just started streaming and
>>>> injected numbers to ADC control registers, then calculated sampling rate
>>>> from the stream.
>>>
>>> That's not an use case. It is just a developer's procedure. Anyway, you
>>> could still measure the bit rate like that, if you do a stream start and
>>> stop.
>>>
>>>> That is only use case I know currently, there still could be some others.
>>>
>>> Seriously? Since the Shannon theorem, all theory used on DSP assumes that
>>> the samples are spaced at the very same bit rate.
>>>
>>>> Nothing prevents do to it, the key issue is that
>>>> sampling rate is needed to known by app.
>>>
>>> No, it is harder than that: if the bit rate changes, then you need to pack
>>> the sampling rate changes when they occur inside the stream, as otherwise
>>> userspace will have no means to detect such changes.
>>
>> Heh, I cannot understood you. Could you explain why it works for me?
>> Here is video I recorded just for you:
>> http://palosaari.fi/linux/v4l-dvb/mirics_msi3101_sdrsharp_sampling_rate.mp4
>>
>> It is Mirics MSi3101 streaming FM radio with sampling rate 2.048 Msps,
>> then I switch to 1.024 Msps and back few times - on the fly. IMHO
>> results are just as expected. Sound start cracking when DSP application
>> sampling rate does not match, but when you change it back to correct it
>> recovers.
>
> In other words, changing the sampling rate while streaming breaks decoding.

Of course, in a case DSP does not know what it is. I have found that 
changing frequency during streaming breaks my audio as well.


>> If I will add button to tell app DSP that sampling rate is changed, it
>> will work for both cases. I haven't yet implemented that settings
>> button, it is hard coded to SDRSharp plugin.
>>
>> Could you explain why it works if it is impossible as you said?
>
> I can't imagine any "magic" button that will be able to discover
> on what exact sample the sampling rate changed. The hardware may
> have buffers; the DMA engines and the USB stack for sure have, and
> also V4L. Knowing on what exact sample the sampling rate changed
> would require hardware support, to properly tag the sample where the
> change started to apply.

"Magic button". It is just DSP application which sends request to 
hardware. And if hardware says OK, that magic SDR application says for 
own DSP hey change sampling rate to mach stream.

There is huge amount of bits streaming, no need to tag. You could just 
throw away second or two - does not matter. Imagine it similarly like a 
UDP VoIP call - when you lose data, so what, it is 20ms of audio and 
none cares.
It is similarly here, if you lose some data due to sampling rate 
mismatch, so what. It is only few ms of audio (or some other). One way 
radio channel is something it should be robust for such issues - you 
cannot request retry.

> If the hardware supports it, I don't see an reason why blocking calling
> VIDIOC_S_FMT in the middle of a stream.
>
> However, on all other hardwares, samples will be lost or will be
> badly decoded, with would cause audio/video artifacts or even break
> the decoding code if not properly written.
>
> Anyway, if samples will be lost anyway, the right thing to do is to
> just stop streaming, change the sampling rate and start streaming
> again. This way, you'll know that all buffers received before the
> changes will have the old sampling rate, and all new buffers, the new one.

I cannot agree. It is too slow, without real benefits, for many use cases.

Also, I am pretty sure many of the hw DSP implementations will not 
restart streaming when they hunt for demodulation lock. There is likely 
just a long shift-register or FIFO where bits are running even different 
sampling rates etc. are tested.

regards
Antti

-- 
http://palosaari.fi/
