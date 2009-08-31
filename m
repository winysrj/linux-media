Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1285 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZHaKki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 06:40:38 -0400
Message-ID: <dbf33f17b45c024b40d0bfb90c63511a.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.0908311149400.4189@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>
    <200908270851.27073.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>
    <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
    <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
    <Pine.LNX.4.64.0908311113520.4189@axis700.grange>
    <3e6334da11a2c64cce09bf694dc3b29a.squirrel@webmail.xs4all.nl>
    <Pine.LNX.4.64.0908311149400.4189@axis700.grange>
Date: Mon, 31 Aug 2009 12:40:38 +0200
Subject: Re: [RFC] Pixel format definition on the "image" bus
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Hans de Goede" <j.w.r.degoede@hhs.nl>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Mon, 31 Aug 2009, Hans Verkuil wrote:
>
>>
>> > On Thu, 27 Aug 2009, Hans Verkuil wrote:
>> >
>> >> It's my opinion that we have to be careful in trying to be too
>> >> intelligent. There is simply too much variation in hardware out there
>> to
>> >> ever hope to be able to do that.
>> >
>> > An opinion has been expressed, that my proposed API was too complex,
>> that,
>> > for example, the .packing parameter was not needed. Just to give an
>> > argument, why it is indeed needed, OMAP 3 can pack raw 10, 12, (and
>> 14?)
>> > bit data in two ways in RAM, so, a sensor would use the .packing
>> parameter
>> > to specify how its data has to be arranged in RAM to produce a
>> specific
>> > fourcc code.
>>
>> One thing that I do not understand in your proposal: how would a sensor
>> know how its data is going to be arranged in RAM? It knows nothing about
>> that. It can just transport the image data over the data pins in a
>> certain
>> number of formats, but how those are eventually arranged in RAM is
>> something that only the bridge driver will know.
>>
>> A sensor should tell how its data is transported over the data pins, not
>> what it will look like in RAM.
>
> Yes, in a way. We agree, that we describe the data from the sensor on the
> image bus with a unique ID (data format code enum), right? Now, what does
> this ID tell us? It should tell us what we can get from this format in
> RAM, right?

No, it does not. That is only true for the bridge which is actually doing
the DMA. So calling VIDIOC_S_FMT in the application will indeed request a
specific memory layout of the image. But you cannot attach that same
meaning when configuring a sensor or video decoder/encoder device. That
has no knowledge whatsoever about memory layouts.

In principle sensor devices (to stay with that example) support certain
bus configurations and for each configuration they can transfer an image
in certain formats (the format being the order in which image data is
transported over the data bus). These formats can be completely unique to
that sensor, or (much more likely) be one of a set of fairly common
formats. If unique formats are encountered it is likely to be some sort of
compressed image. Raw images are unlikely to be unique.

I do not believe that you can in general autonegotiate this. But there are
many cases where you can do a decent job of it. To do that the bridge
needs a mapping of memory layouts (the pixelformat specified with S_FMT)
and the image format coming in on the data pins (lets call it datapin
format). Then it can query the sensor which datapin formats it supports
and select the appropriate one.

This approach makes the correct split between memory and datapin formats.
Mixing them is a really bad idea.

Regards,

          Hans

> Since codes are unique, this information should be globally
> available. That's why I'm decoding format codes into (RAM) format
> descriptors centrally in v4l2-imagebus.c. And then hosts can use those
> descriptors to decide which packing to use to obtain the required fourcc
> in RAM.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

