Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3834 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0ANKRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:17:25 -0500
Message-ID: <b9869b35004c5f383c2e76791b91a20d.squirrel@webmail.xs4all.nl>
In-Reply-To: <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
    <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
    <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
    <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
Date: Thu, 14 Jan 2010 11:17:21 +0100
Subject: Re: About driver architecture
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Manu Abraham" <abraham.manu@gmail.com>
Cc: "Michael Qiu" <fallwind@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Thu, Jan 14, 2010 at 1:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> Hi,
>>>
>>>
>>> On Thu, Jan 14, 2010 at 11:35 AM, Michael Qiu <fallwind@gmail.com>
>>> wrote:
>>>> Hi guys,
>>>>  I'm going to write drivers for a new soc which designed for dvb-s set
>>>> top box.
>>>> It will support these features:
>>>> 1. Multi-layer display with alpha blending feature, including
>>>> video(YUV), OSDs(2 same RGB layers), background(with fixed YUV color)
>>>> and still picture(YUV color for still image)
>>>> 2. DVB-S tuner and demod
>>>> 3. HW MPEG2/4 decoder
>>>> 4. HW accelerated JPEG decoder engine.
>>>>
>>>> My targets are:
>>>> 1. Fit all the drivers in proper framework so they can be easily used
>>>> by applications in open source community.
>>>> 2. As flexible as I can to add new software features in the future.
>>>>
>>>> My questions are:
>>>> How many drivers should I implement, and how should I divide all the
>>>> features?
>>>> As far as I know:
>>>> A) a frame buffer driver for 2 OSDs, maybe also the control point for
>>>> whole display module?
>>>> B) video output device for video layer, which will output video
>>>> program.
>>>> C) drivers for tuner and demo (or just a driver which will export 2
>>>> devices files for each?)
>>>> D) driver for jpeg accelerate interface, or should it be a part of
>>>> MPEG2/4 decoder driver?
>>>> E) driver for MPEG2/4 decoder which will control the behave of H/W
>>>> decoder.
>>>>
>>>> Actually I think all the display functions are relative, some
>>>> functions i listed upper are operating one HW module, for instance:
>>>> OSD and video layer are implemented by display module in H/W level.
>>>> What's the right way to implement these functions in driver level,
>>>> united or separated?
>>>> And, I've read some documents for V4L2, but I still cannot figure out
>>>> where should I implement my driver in the framework.
>>>>
>>>> In a word, I'm totally confused. Can you guys show me the right way or
>>>> just kick me to a existing example with similar features?
>>>>
>>>
>>> Currently, there are 2 drivers which have exactly the functionality
>>> that you have mentioned. The first one is an AV7110 based device and
>>> the other one is a STi7109 SOC based device.
>>>
>>> With regards to the AV7110 based hardware, you can have a look at
>>> linux/drivers/media/dvb/ttpci/ *
>>>
>>> And with regards to the STi7109 SOC based, you can have a look at
>>> http://jusst.de/hg/saa716x/
>>> linux/drivers/media/common/saa716x/ *
>>> specifically you will need to look at saa716x_ff.c/h for the STi7109
>>> related stuff
>>>
>>>
>>> Both the AV7110 and STi7109 SOC feature a OSD interface, in addition
>>> to the audio and video layers. which you can see from the drivers,
>>> themselves. Additionally the STi7109 SOC features HDMI outputs. The
>>> AV7110 based cards, they incorporate DVB-S/C/T frontends for different
>>> products. The STi7109 product that we have currently features only a
>>> DVB-S/S2 system only, though that doesn't make any difference at all.
>>
>> The AV7110 OSD is not framebuffer based AFAIK. So probably not a good
>> place to look.
>
>
> It doesn't support OSD ?

I didn't say that. Of course it supports an OSD. Just not through a
traditional /dev/fbX device which allows you to put Qt or whatever on top
of it. Instead it requires custom commands to use it. I'm assuming that
the SoC Michael is talking about is framebuffer based in which case ivtv
is the closest match.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

