Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:51797 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3HFJSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 05:18:16 -0400
Received: by mail-bk0-f45.google.com with SMTP id je2so54485bkc.18
        for <linux-media@vger.kernel.org>; Tue, 06 Aug 2013 02:18:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1308042252010.19244@axis700.grange>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
	<Pine.LNX.4.64.1308042252010.19244@axis700.grange>
Date: Tue, 6 Aug 2013 17:18:14 +0800
Message-ID: <CALxrGmV-SCDntaJGeaCDkuqmdzgk3VEYZG+koj9em+Z4PSG0XQ@mail.gmail.com>
Subject: Re: How to express planar formats with mediabus format code?
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the reply! Please see my description inline.

On Mon, Aug 5, 2013 at 5:02 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Su Jiaquan
>
> On Sun, 4 Aug 2013, Su Jiaquan wrote:
>
>> Hi,
>>
>> I know the title looks crazy, but here is our problem:
>>
>> In our SoC based ISP, the hardware can be divide to several blocks.
>> Some blocks can do color space conversion(raw to YUV
>> interleave/planar), others can do the pixel
>> re-order(interleave/planar/semi-planar conversion, UV planar switch).
>> We use one subdev to describe each of them, then came the problem: How
>> can we express the planar formats with mediabus format code?
>
> Could you please explain more exactly what you mean? How are those your
> blocks connected? How do they exchange data? If they exchange data over a
> serial bus, then I don't think planar formats make sense, right? Or do
> your blocks really output planes one after another, reordering data
> internally? That would be odd... If OTOH your blocks output data to RAM,
> and the next block takes data from there, then you use V4L2_PIX_FMT_*
> formats to describe them and any further processing block should be a
> mem2mem device. Wouldn't this work?

These two hardware blocks are both located inside of ISP, and is
connected by a hardware data bus.

Actually, there are three blocks inside ISP: One is close to sensor,
and can do color space conversion(RGB->YUV), we call it IPC; The other
two are at back end, which are basically DMA Engine, and they are
identical. When data flow out of IPC, it can go into each one of these
DMA Engines and finally into RAM. Whether the DMA Engine is turned
on/off and the output format can be controlled independently. Since
they are DMA Engines, they have some basic pixel reordering
ability(i.e. interleave->planar/semi-planar).

In our H/W design, when we want to get YUV semi-planar format, the IPC
output should be configured to interleave, and the DMA engine will do
the interleave->semi-planar job. If we want planar / interleave
format, the IPC will output planar format directly, DMA engine simply
send the data to RAM, and don't do any re-order. So in the planar
output case, media-bus formats can't express the format of the data
between IPC and DMA Engine, that's the problem we meet.

We want to adopt a formal solution before we send our patch to the
community, that's where our headache comes.
>
> Thanks
> Guennadi
>
>> I understand at beginning, media-bus was designed to describe the data
>> link between camera sensor and camera controller, where sensor is
>> described in subdev. So interleave formats looks good enough at that
>> time. But now as Media-controller is introduced, subdev can describe a
>> much wider range of hardware, which is not limited to camera sensor.
>> So now planar formats are possible to be passed between subdevs.
>>
>> I think the problem we meet can be very common for SoC based ISP
>> solutions, what do you think about it?
>>
>> there are many possible solution for it:
>>
>> 1> change the definition of v4l2_subdev_format::format, use v4l2_format;
>>
>> 2> extend the mediabus format code, add planar format code;
>>
>> 3> use a extra bit to tell the meaning of v4l2_mbus_framefmt::code, is
>> it in mediabus-format or in fourcc
>>
>>  Do you have any suggestions?
>>
>>  Thanks a lot!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

Thanks!

Jiaquan
