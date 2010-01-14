Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1338 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0ANKcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:32:31 -0500
Message-ID: <1533ce274baa3d69ed4adcbaab57a735.squirrel@webmail.xs4all.nl>
In-Reply-To: <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
    <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
    <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
Date: Thu, 14 Jan 2010 11:32:28 +0100
Subject: Re: About driver architecture
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Michael Qiu" <fallwind@gmail.com>
Cc: "Manu Abraham" <abraham.manu@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Thanks a lot for you advise.
>
> Before I read the source code you mentioned, I guess I should write a
> driver modules which provide /dev/dvb/adapter/audio, video, frontend,
> ca....,  and also provide a /dev/fbx for OSD layer. But in source
> level, all display HW relative functions would probably in a same
> module, because they are operation on same block of H/W.
> But I still don't know where to put my global display control
> interface, for instance, the function to control which layer open and
> close, the alpha values used for each layer...
>
> And I investigated DirectFB, it seems if I provide a /dev/fb0 device
> the DirectFB can play around it and it will the base for upper GUI
> system.
> I also found DirectFB support V4L as it's surface source. So it will
> need some kernel module to control layer blending. It seems the thing
> I am looking for which implement the global display control.

This is the same problem that also affects e.g. the Texas Instruments
omap3 SoC. What is missing is a high-level controller device.

To start with, take a look at this presentation:

http://www.xs4all.nl/~hverkuil/presentations/jls2009-v4l2.pdf

The key concept is that of a media controller. Work is in progress to
prototype it for omap3. RFCs have been posted on this as well.

Regards,

        Hans

>
>
>
> 2010/1/14 Manu Abraham <abraham.manu@gmail.com>:
>> Hi,
>>
>>
>> On Thu, Jan 14, 2010 at 11:35 AM, Michael Qiu <fallwind@gmail.com>
>> wrote:
>>> Hi guys,
>>>  I'm going to write drivers for a new soc which designed for dvb-s set
>>> top box.
>>> It will support these features:
>>> 1. Multi-layer display with alpha blending feature, including
>>> video(YUV), OSDs(2 same RGB layers), background(with fixed YUV color)
>>> and still picture(YUV color for still image)
>>> 2. DVB-S tuner and demod
>>> 3. HW MPEG2/4 decoder
>>> 4. HW accelerated JPEG decoder engine.
>>>
>>> My targets are:
>>> 1. Fit all the drivers in proper framework so they can be easily used
>>> by applications in open source community.
>>> 2. As flexible as I can to add new software features in the future.
>>>
>>> My questions are:
>>> How many drivers should I implement, and how should I divide all the
>>> features?
>>> As far as I know:
>>> A) a frame buffer driver for 2 OSDs, maybe also the control point for
>>> whole display module?
>>> B) video output device for video layer, which will output video
>>> program.
>>> C) drivers for tuner and demo (or just a driver which will export 2
>>> devices files for each?)
>>> D) driver for jpeg accelerate interface, or should it be a part of
>>> MPEG2/4 decoder driver?
>>> E) driver for MPEG2/4 decoder which will control the behave of H/W
>>> decoder.
>>>
>>> Actually I think all the display functions are relative, some
>>> functions i listed upper are operating one HW module, for instance:
>>> OSD and video layer are implemented by display module in H/W level.
>>> What's the right way to implement these functions in driver level,
>>> united or separated?
>>> And, I've read some documents for V4L2, but I still cannot figure out
>>> where should I implement my driver in the framework.
>>>
>>> In a word, I'm totally confused. Can you guys show me the right way or
>>> just kick me to a existing example with similar features?
>>>
>>
>> Currently, there are 2 drivers which have exactly the functionality
>> that you have mentioned. The first one is an AV7110 based device and
>> the other one is a STi7109 SOC based device.
>>
>> With regards to the AV7110 based hardware, you can have a look at
>> linux/drivers/media/dvb/ttpci/ *
>>
>> And with regards to the STi7109 SOC based, you can have a look at
>> http://jusst.de/hg/saa716x/
>> linux/drivers/media/common/saa716x/ *
>> specifically you will need to look at saa716x_ff.c/h for the STi7109
>> related stuff
>>
>>
>> Both the AV7110 and STi7109 SOC feature a OSD interface, in addition
>> to the audio and video layers. which you can see from the drivers,
>> themselves. Additionally the STi7109 SOC features HDMI outputs. The
>> AV7110 based cards, they incorporate DVB-S/C/T frontends for different
>> products. The STi7109 product that we have currently features only a
>> DVB-S/S2 system only, though that doesn't make any difference at all.
>>
>> The only application that does handle the complete use of the decoder,
>> is VDR and some other command line applications in the dvb-apps tree,
>> that I am aware of. But there could be other applications as well.
>>
>> I guess, you've been confused, since you have been looking in the
>> wrong place, ie in V4L, rather than with DVB.
>>
>> Regards,
>> Manu
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

