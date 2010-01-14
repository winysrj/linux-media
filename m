Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f228.google.com ([209.85.217.228]:42703 "EHLO
	mail-gx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0ANJrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 04:47:07 -0500
Received: by gxk28 with SMTP id 28so17299438gxk.9
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 01:47:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bc1576c0e8d05b415e03292a4640021e.squirrel@webmail.xs4all.nl>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <bc1576c0e8d05b415e03292a4640021e.squirrel@webmail.xs4all.nl>
Date: Thu, 14 Jan 2010 17:47:04 +0800
Message-ID: <f74f98341001140147u7f5f1e91ga6ae3a06e23360@mail.gmail.com>
Subject: Re: About driver architecture
From: Michael Qiu <fallwind@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for you reply.

The SOC is still under development stage, it's not a product yet. And
a small mistake I've made, the tuner will not integrated into the SOC.
The demod might be.

Some more questions:
As far as I know, relationship between demod and decoder is the buffer
used as demod output(also the input for a/v decoder), and maybe a
shared interrupt used to catch some misc event from tuner/demo/av
decoder(a interrupt status register will be used to determine who
cause it). Do you think this will be a problem if I write individual
drivers?

And would you please tell me that is the "memory-to-memory decoding" for?

Best regards
Michael Qiu

2010/1/14 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Michael,
>
>> Hi guys,
>>   I'm going to write drivers for a new soc which designed for dvb-s set
>> top box.
>> It will support these features:
>> 1. Multi-layer display with alpha blending feature, including
>> video(YUV), OSDs(2 same RGB layers), background(with fixed YUV color)
>> and still picture(YUV color for still image)
>> 2. DVB-S tuner and demod
>> 3. HW MPEG2/4 decoder
>> 4. HW accelerated JPEG decoder engine.
>
> Interesting device. Which SoC is this?
>
>>
>> My targets are:
>> 1. Fit all the drivers in proper framework so they can be easily used
>> by applications in open source community.
>> 2. As flexible as I can to add new software features in the future.
>>
>> My questions are:
>> How many drivers should I implement, and how should I divide all the
>> features?
>> As far as I know:
>> A) a frame buffer driver for 2 OSDs, maybe also the control point for
>> whole display module?
>> B) video output device for video layer, which will output video program.
>> C) drivers for tuner and demo (or just a driver which will export 2
>> devices files for each?)
>> D) driver for jpeg accelerate interface, or should it be a part of
>> MPEG2/4 decoder driver?
>> E) driver for MPEG2/4 decoder which will control the behave of H/W
>> decoder.
>>
>> Actually I think all the display functions are relative, some
>> functions i listed upper are operating one HW module, for instance:
>> OSD and video layer are implemented by display module in H/W level.
>> What's the right way to implement these functions in driver level,
>> united or separated?
>> And, I've read some documents for V4L2, but I still cannot figure out
>> where should I implement my driver in the framework.
>>
>> In a word, I'm totally confused. Can you guys show me the right way or
>> just kick me to a existing example with similar features?
>
> The driver that comes closest to this in terms of functionality is the
> ivtv driver. That driver supports MPEG2 encoding and decoding, an OSD and
> raw YUV input and output.
>
> There are several ways you can design devices like this, but the way ivtv
> is designed is that there is one master driver (ivtv) that handles all the
> encoding and decoding, and the framebuffer driver that you need for the
> OSD is just an 'add-on' module that provides the FB API but internally
> talks to the master driver.
>
> The tuner/demod part is usually integrated in the master driver. See the
> cx18 driver for example. But it is probably also possible to implement it
> as a separate driver in a similar manner as a framebuffer driver.
>
> Generally the key criteria on how to design drivers like this is the
> hardware design: for example, if the tuner/demod part is completely
> independent from the decoder part, then it is possible to write completely
> independent drivers as well, but if they share hardware components (e.g.
> the interrupt handling hardware), then you usually have to combine
> functions in one driver.
>
> Note that some features that you probably need (such as memory-to-memory
> decoding) are not yet implemented in V4L2 (although work is in progress on
> this).
>
> Regards,
>
>        Hans
>
>>
>>
>> Best regards
>> Michael Qiu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>
>
