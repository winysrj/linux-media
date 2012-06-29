Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2F2O3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 10:29:07 -0400
Message-ID: <4FEDBB9B.9010400@redhat.com>
Date: Fri, 29 Jun 2012 11:28:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FED2FE0.9010602@redhat.com> <4FED3714.2080901@iki.fi> <2601054.j5eSD2QU7J@dibcom294>
In-Reply-To: <2601054.j5eSD2QU7J@dibcom294>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-06-2012 08:24, Patrick Boettcher escreveu:
> On Friday 29 June 2012 08:03:16 Antti Palosaari wrote:
>> On 06/29/2012 07:32 AM, Mauro Carvalho Chehab wrote:
>>> Em 27-06-2012 21:33, Antti Palosaari escreveu:
>>>> SDR - Softaware Defined Radio support DVB API
>>>> --------------------------------------------------
>>>> *
>>>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructu
>>>> re/44461 * there is existing devices that are SDR (RTL2832U "rtl-sdr")
>>>> * SDR is quite near what is digital TV streaming
>>>> * study what is needed
>>>> * new delivery system for frontend API called SDR?
>>>> * some core changes needed, like status (is locked etc)
>>>> * how about demuxer?
>>>> * stream conversion, inside Kernel?
>>>> * what are new parameters needed for DVB API?
>>>
>>> Let's not mix APIs: the radio control should use the V4L2 API, as this
>>> is not DVB. The V4L2 API has already everything needed for radio. The
>>> only missing part ther is the audio stream. However, there are a few
>>> drivers that provide audio via the radio device node, using
>>> read()/poll() syscalls, like pvrusb. On this specific driver, audio
>>> comes through a MPEG stream. As SDR provides audio on a different
>>> format, it could make sense to use VIDIOC_S_STD/VIDIOC_G_STD to
>>> set/retrieve the type of audio stream, for SDR, but maybe it better to
>>> just add capabilities flag at VIDIOC_QUERYCTL or VIDIOC_G_TUNER to
>>> indicate that the audio will come though the radio node and if the
>>> format is MPEG or SDR.
>> SDR is not a radio in mean of V4L2 analog audio radios. SDR can receive
>> all kind of signals, analog audio, analog television, digital radio,
>> digital television, cellular phones, etc. You can even receive DVB-T,
>> but hardware I have is not capable to receive such wide stream.
>>
>> That chip supports natively DVB-T TS but change be switched to SDR mode.
>> Is it even possible to switch from DVB API (DVB-T delivery system) to
>> V4L2 API at runtime?
> 
> It could be possible that neither the DVB-API nor the V4L2 API is the right
> user-interface for such devices. The output of such devices is the
> acquisition of raw (digitalized) data of a signal and here signal is meant
> in the sense of anything which can be digitalized (e.g.: sensors, tuners,
> ADCs).
> 
> Such device will surely be have a device-specific (user-space?) library to
> do the post/pre-processing before putting this data into a generic format.

That's one more reason why using the V4L2 API is better: at the V4L2 API, the
output format is represented by a 32 bits unique code. There are several
standard fourcc codes there, plus several proprietary formats represented.
The decoding between the proprietary formats is done via libv4l. Libv4l
can be used with any pre-compiled userspace application, via LD_PRELOAD,
although almost all V4L2 userspace applications[1] are using the libv4l to decode
data. Adding SDR decoding there should not be hard.

[1] Radio applications don't use it yet, as almost all radio devices output
audio via ALSA API, so some work will be needed there to add SDR radio
support.

>> That said, IMO, the rtl-sdr driver should sit on the DVB-API. Maybe V4L2
>> provides a device-specific control path (to configure the hardware) if not
>> somewhere else, or something new needs to be created.

> *argl* I wanted to say, ... should _not_ sit on the DVB-API...

Agreed. Tuning with the V4L2 API is more direct, as doesn't have any
threads looking for DVB demod status, in order to do frequency zig-zag.

It also have support for hardware frequency scanning, which can be an
interesting feature if supported.

Regards,
Mauro
