Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33878 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965295AbcAZOYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:24:12 -0500
Received: by mail-lf0-f65.google.com with SMTP id n70so9708066lfn.1
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 06:24:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1601261509120.28816@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
	<1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
	<1453121545-27528-8-git-send-email-rainyfeeling@gmail.com>
	<Pine.LNX.4.64.1601241931430.16570@axis700.grange>
	<CAJe_HAeTWqaqFHPbLGzbTKV6s2xDxf+Dg8DFc6HAqs03RJFh3g@mail.gmail.com>
	<Pine.LNX.4.64.1601261509120.28816@axis700.grange>
Date: Tue, 26 Jan 2016 22:24:10 +0800
Message-ID: <CAJe_HAdtFCmYKeCgfs9FeE80ckH3+WRfejmc_WOxdxZEntgL8A@mail.gmail.com>
Subject: Re: [PATCH 12/13] atmel-isi: use union for the fbd (frame buffer descriptor)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

2016-01-26 22:10 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi Josh,
>
> (resending with all CC)
>
> On Tue, 26 Jan 2016, Josh Wu wrote:
>
>> Hi, Guennadi
>>
>> Thanks for the review.
>>
>> 2016-01-25 3:31 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > On Mon, 18 Jan 2016, Josh Wu wrote:
>> >
>> >> From: Josh Wu <josh.wu@atmel.com>
>> >>
>> >> This way, we can easy to add other type of fbd for new hardware.
>> >
>> > Ok, I've applied all your 13 patches to check, what the resulting driver
>> > would look like. To me it looks like you really abstract away _everything_
>> > remotely hardware-specific. What is left is yet another abstraction layer,
>> > into which you can pack a wide range of hardware types, which are very
>> > different from the original ISI. I mean, you could probably pack - to some
>> > extent, maybe sacrificing some features - other existing soc-camera
>> > drivers, like MX3, MX2, CEU,... - essentially those, using VB2. And I
>> > don't think that's a good idea. We have a class of V4L2 camera bridge
>> > drivers, that's fine. They use all the standard APIs to connect to the
>> > user-space and to other V4L2 drivers in video pipelines - V4L2 ioctl()s,
>> > subdev, Media Controller, VB2, V4L2 control API etc. Under that we have
>> > soc-camera - mainly for a few existing bridge drivers, because it takes a
>> > part of bridge driver's implementation freedom away and many or most
>> > modern camera bridge interfaces are more complex, than what soc-camera
>> > currently supports, and extending it makes little sense, it is just more
>> > logical to create a full-features V4L2 bridge driver with a full access to
>> > all relevant APIs.
>>
>> It sounds the general v4l2 driver framework is more suitable than
>> soc-camera framework for the new hardware.
>
> Then, please, go for one!
>
>> So is it easy for v4l2 platform driver to use the soc-camera sensors?
>
> Not sure, haven't tried in a while. It used to be difficult, but it must
> have become more simple, I think there are examples of that in the
> mainline. I think em28xx does that, but probably in the meantime the
> integration possibilities have become even better.

I'll try to see what I'll get.

>
>> > With your patches #12 and #13 you seem to be creating
>> > an even tighter, narrower API for very thin drivers. That just provide a
>> > couple of hardware-related functions and create a V4L2 bridge driver from
>> > that. What kind of hardware is that new controller, that you'd like to
>> > support by the same driver? Wouldn't it be better to create a new driver
>> > for it? Is it really similar to the ISI controller?
>>
>> The new hardware is SAMA5D2 Image Sensor Controller. You can find the
>> datasheet here:
>> http://www.atmel.com/Images/Atmel-11267-32-bit-Cortex-A5-Microcontroller-SAMA5D2_Datasheet.pdf
>>
>> Actually, The ISC hardware is very different from ISI hardware. ISC
>> has no Preivew/Codec path, it just has many data blocks to process
>> sensor data.
>> With the abstraction of my patches, ISC can rewrite the interrupt
>> handler, initialization, configure and etc to work in same ISI driver,
>> though. But like you mentioned, it's very tight, maybe it's not easy
>> to add extend functions.
>>
>> So I was convinced to write a new v4l2 camera driver for ISC if it is
>> easy to support soc-camera sensors.
>
> Please, write a new driver :)

Ok, so for this serial patch, I will drop the abstract interface
relevant patches, and keep the refactor patch in v2. Thanks.

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>> Best Regards,
>> Josh Wu
