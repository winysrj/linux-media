Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3DULKQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 07:10:16 -0400
Message-ID: <5173C910.3000803@redhat.com>
Date: Sun, 21 Apr 2013 08:10:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add SDR at V4L2 API
References: <366469499-31640-1-git-send-email-mchehab@redhat.com> <201304211134.09073.hverkuil@xs4all.nl> <5173BAEF.3000805@redhat.com> <201304211234.45282.hverkuil@xs4all.nl>
In-Reply-To: <201304211234.45282.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-04-2013 07:34, Hans Verkuil escreveu:
> On Sun April 21 2013 12:09:51 Mauro Carvalho Chehab wrote:
>> Em 21-04-2013 06:34, Hans Verkuil escreveu:
>>> Hi Mauro,
>>>
>>> On Sat April 20 2013 19:51:11 Mauro Carvalho Chehab wrote:
>>>> This is a version 2 of the V4L2 API bits to support Software Digital
>>>> Radio (SDR).
>>>
>>> It looks pretty good to me. Just one question though: what is your rationale
>>> for choosing a new device name (/dev/sdrX) instead of using the existing
>>> /dev/radioX?
>>>
>>> I'm not saying I'm opposed to it, in fact I agree with it, but I think the
>>> reasons for it should be stated explicitly.
>>
>> Because a SDR radio is different than a normal radio device:
>>
>> A normal radio device is actually radio and hardware demod. As the demod
>> is in hardware, several things that are required for the demodulate the
>> signal (IF, bandwidth, sample rate, RF/IF filters, etc) are internal to
>> the device and aren't part of the API.
>>
>> SDR radio, on the other hand, requires that every control needed by the
>> tuner to be exposed on userspace, as userspace needs to adjust the
>> software decoder to match them.
>>
>> So, they're different.
>>
>> Btw, it is also possible that the same device to offer analog TV,
>> digital TV, hardware-decoded radio and SDR. One example of such devices
>> are cx88. The existing drivers supports already hardware demodulers,
>> but the device also allows to export the collected samples to userspace.
>> It is just a matter of programming the cx88 RISC code to do that.
>>
>> Internally, cx2388x has 2 10 bits ADC, one for baseband (composite inputs)
>> and another one for IF signal capable of working up to 35.44 MHz sampling
>> rate (on "8x FSC PAL" supported mode). It would be easy to export its
>> output to userspace.
>>
>> Btw, while seeking for more data about SDR this weekend, I discovered
>> one project doing exactly that:
>>
>> 	http://www.geocities.ws/how_chee/cx23881fc6.htm
>>
>> I did a very quick look at its source code. It is limited, as it works
>> only at a fixed sample rate of 27 MHz provides only 8 bits samples[1], and
>> I'm not sure if it allows using both ADCs.
>>
>> Yet, It shows that it is possible that a driver/subdrivers to offer
>> the 4 different types of devices:
>> 	- analog TV;
>> 	- digital TV;
>> 	- radio;
>> 	- SDR.
>>
>> So, IMO we should not abuse of /dev/radio for SDR.
>
> I agree. I just wanted to have it explicit :-)

Sure. I'll summarize the above at the commit patch on a next version.

> I also think we should provide and maintain a library doing the decoding for
> SDR that is part of v4l-utils. Otherwise you'll end up with a big userspace
> mess.

I partially agree. I've seen some SDR usages that are experimental
app-specific stuff like GSM and ADSB receivers.

You can see a sample of such projects that use one of the existing
userspace libraries at:
	http://sdr.osmocom.org/trac/wiki/rtl-sdr#KnownApps

In principle, I don't think it is worth to invest our time handling
all sorts of possible decoders at v4l-apps[1].

It makes more sense to offer instead low level library there to allow
applications to abstract from hardware differences, like doing
fourcc conversions.

There are at least two ways of outputting data on the known devices:
	- simple ADC samples in time domain;
	- IF using in-phase/quadrature (I/Q) samples.

Also, the number of bits can vary from device to device, being 8 bits
and 10 bits the most common ones. I think I saw some analog TV devices
using a 12 bits sampler somewhere, but I can't remember if it is
flexible enough to output sampled data to the DMA engine, or if they're
just simple I2C devices that output only decoded data via I2S.

Anyway, the low-level library should take care of those differences,
just like it is done at libv4l for image standards.

With time, the library may also provide a basic set of decoders for
more common analog radio standards: FM, AM DSB-FC, AM DSB-SC, AM SSB.

It may also provide analog TV decoders and even digital TV ones,
but writing them may take a lot of time. It could be good projects
for Google's Summer of Code and similar events.

I would love to have a set of those decodes there, as they can
offer a nice set of instrumentation tools to test what is being
received on some place and calibrate device drivers.

I would love even more to have SDR TX devices. With both TX and RX
working, one could send us a sample of what they're receiving on
some place, and this signal could be used by the developer to test
their devices, improving the driver to better receive such signals.

I suspect that low-cost SDR TX devices will come with time.

[1] Ok, if someone wants to add support for those app-specific decoders,
maintain it there and it doesn't offer any legal issues that would
restrict v4l-utils distribution, I'm not against to add it there.

>
> And we want this checked by v4l2-compliance, and qv4l2 should be able to use
> the library so we have at least one application that can handle it.
>
> Regards,
>
> 	Hans
>
>>
>> Regards,
>> Mauro
>>
>> [1] The trick is to program the cx88 RISC to output data from the
>> samplers, instead of from the demods. We do that already for the
>> audio standard detection.
>>
>> I've no idea if cx88 has any upper DMA maximum bandwidth. If it has,
>> that might be the reason to limit to 27MHz, 8 bits, but I suspect
>> that it was done that way just because it was easier.
>>
>> Btw, I'm almost sure that other Conexant designs can also offer
>> similar interfaces.
>>
>>
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>>>
>>>>
>>>> The changes from version 1 are:
>>>> 	- fix compilation;
>>>> 	- add a new capture type for SDR (V4L2_BUF_TYPE_SDR_CAPTURE),
>>>> 	  with the corresponding documentation;
>>>> 	- remove legacy V4L1 buffer types from videobuf2.h.
>>>>
>>>> With regards to VIDIOC_S_TUNER, what's currently defined there is
>>>> that, in contrary to what a radio device does, this ioctl would
>>>> set the input.
>>>>
>>>> This patch adds the very basic stuff for SDR:
>>>>
>>>> 	- a separate devnode;
>>>> 	- an VIDIOC_QUERYCAP caps for SDR;
>>>> 	- a fourcc group for SDR;
>>>> 	- a few DocBook bits.
>>>>
>>>> What's missing:
>>>> 	- SDR specific controls;
>>>> 	- Sample rate config;
>>>> 	...
>>>>
>>>> As discussing DocBook changes inside the patch is hard, I'm adding here
>>>> the DocBook formatted changes.
>>>>
>>>> The DocBook changes add the following bits:
>>>>
>>>> At Chapter 1. Common API Elements, it adds:
>>>>
>>>> <text>
>>>> Software Digital Radio (SDR) Tuners and Modulators
>>>> ==================================================
>>>>
>>>> Those devices are special types of Radio devices that don't have any
>>>> analog demodulator. Instead, it samples the radio IF or baseband and
>>>> sends the samples for userspace to demodulate.
>>>>
>>>> Tuners
>>>> ======
>>>>
>>>> SDR receivers can have one or more tuners sampling RF signals. Each
>>>> tuner is associated with one or more inputs, depending on the number of
>>>> RF connectors on the tuner. The type field of the respective struct
>>>> v4l2_input returned by the VIDIOC_ENUMINPUT ioctl is set to
>>>> V4L2_INPUT_TYPE_TUNER and its tuner field contains the index number of
>>>> the tuner input.
>>>>
>>>> To query and change tuner properties applications use the VIDIOC_G_TUNER
>>>> and VIDIOC_S_TUNER ioctl, respectively. The struct v4l2_tuner returned
>>>> by VIDIOC_G_TUNER also contains signal status information applicable
>>>> when the tuner of the current SDR input is queried. In order to change
>>>> the SDR input, VIDIOC_S_TUNER with a new SDR index should be called.
>>>> Drivers must support both ioctls and set the V4L2_CAP_SDR and
>>>> V4L2_CAP_TUNER flags in the struct v4l2_capability returned by the
>>>> VIDIOC_QUERYCAP ioctl.
>>>>
>>>> Modulators
>>>> ==========
>>>>
>>>> To be defined.
>>>> </text>
>>>>
>>>> At the end of Chapter 2. Image Formats, it adds:
>>>>
>>>> <text>
>>>> SDR format struture
>>>> ===================
>>>>
>>>> Table 2.4. struct v4l2_sdr_format
>>>> =================================
>>>>
>>>> __u32	sampleformat	The format of the samples used by the SDR device.
>>>> 			This is a little endian four character code.
>>>>
>>>> Table 2.5. SDR formats
>>>> ======================
>>>>
>>>> V4L2_SDR_FMT_I8Q8	Samples are given by a sequence of 8 bits in-phase(I)
>>>> 			and 8 bits quadrature (Q) samples taken from a
>>>> 			signal(t) represented by the following expression:
>>>> 			signal(t) = I * cos(2Ï€ fc t) - Q * sin(2Ï€ fc t)
>>>> </text>
>>>>
>>>> Of course, other formats will be needed at Table 2.5, as SDR could also
>>>> be taken baseband samples, being, for example, a simple sequence of
>>>> equally time-spaced digitalized samples of the signal in time.
>>>> SDR samples could also use other resolutions, use a non-linear
>>>> (A-law, u-law) ADC, or even compress the samples (with ADPCM, for
>>>> example). So, this table will grow as newer devices get added, and an
>>>> userspace library may be required to convert them into some common
>>>> format.
>>>>
>>>> At "Chapter 4. Interfaces", it adds the following text:
>>>>
>>>> <text>
>>>> Software Digital Radio(SDR) Interface
>>>> =====================================
>>>>
>>>> This interface is intended for Software Digital Radio (SDR) receivers
>>>> and transmitters.
>>>>
>>>> Conventionally V4L2 SDR devices are accessed through character device
>>>> special files named /dev/sdr0 to/dev/radio255 and uses a dynamically
>>>> allocated major/minor number.
>>>>
>>>> Querying Capabilities
>>>> =====================
>>>>
>>>> Devices supporting the radio interface set the V4L2_CAP_SDR and
>>>> V4L2_CAP_TUNER or V4L2_CAP_MODULATOR flag in the capabilities field of
>>>> struct v4l2_capability returned by the VIDIOC_QUERYCAP ioctl. Other
>>>> combinations of capability flags are reserved for future extensions.
>>>>
>>>> Supplemental Functions
>>>> ======================
>>>>
>>>> SDR receivers should support tuner ioctls.
>>>>
>>>> SDR transmitter ioctl's will be defined in the future.
>>>>
>>>> SDR devices should also support one or more of the following I/O ioctls:
>>>> read or write, memory mapped IO, user memory IO and/or DMA buffers.
>>>>
>>>> SDR devices can also support controls ioctls.
>>>>
>>>> The SDR Input/Output are A/D or D/A samples taken from a modulated
>>>> signal, and can eventually be packed by the hardware. They are generally
>>>> encoded using cartesian in-phase/quadrature (I/Q) samples, to make
>>>> demodulation easier. The format of the samples should be according with
>>>> SDR format.
>>>> </text>
>>>>
>>>> Note: "SDR format" on the last paragraph is an hyperlink to
>>>> Chapter 2. Image Formats.
>>>>
>>>> At "Appendix A. Function Reference - ioctl VIDIOC_QUERYCAP", it adds:
>>>>
>>>> <text>
>>>> Table A.93. Device Capabilities Flags
>>>> ...
>>>> V4L2_CAP_SDR	0x00100000	The device is a Software Digital Radio.
>>>> 				For more information about SDR programming
>>>> 				see the section called â€œSoftware Digital
>>>> 				Radio (SDR) Tuners and Modulatorsâ€�.
>>>> </text>
>>>>
>>>> Mauro Carvalho Chehab (3):
>>>>     [media] Add SDR at V4L2 API
>>>>     videodev2.h: Remove the unused old V4L1 buffer types
>>>>     [media] V4L2 api: Add a buffer capture type for SDR
>>>>
>>>>    Documentation/DocBook/media/v4l/common.xml         | 35 ++++++++++++++++++
>>>>    Documentation/DocBook/media/v4l/dev-capture.xml    | 26 ++++++++------
>>>>    Documentation/DocBook/media/v4l/io.xml             |  6 ++++
>>>>    Documentation/DocBook/media/v4l/pixfmt.xml         | 41 ++++++++++++++++++++++
>>>>    Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
>>>>    .../DocBook/media/v4l/vidioc-querycap.xml          |  7 ++++
>>>>    drivers/media/v4l2-core/v4l2-dev.c                 |  3 ++
>>>>    drivers/media/v4l2-core/v4l2-ioctl.c               | 32 +++++++++++++++++
>>>>    include/media/v4l2-dev.h                           |  3 +-
>>>>    include/media/v4l2-ioctl.h                         |  8 +++++
>>>>    include/uapi/linux/videodev2.h                     | 33 +++++++----------
>>>>    11 files changed, 163 insertions(+), 32 deletions(-)
>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

