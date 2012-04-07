Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50514 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab2DGWFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 18:05:06 -0400
Received: by wera1 with SMTP id a1so2665890wer.34
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 15:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1204072349280.25526@axis700.grange>
References: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
 <Pine.LNX.4.64.1204072316460.25526@axis700.grange> <CAKnK67RtoOVV0P_9kdc5q0mQTVhqN6MCbvj0eTLuS98096uAHw@mail.gmail.com>
 <Pine.LNX.4.64.1204072349280.25526@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 7 Apr 2012 17:04:43 -0500
Message-ID: <CAKnK67SCS3LyQcf_bGi8grhkDA8uYKvGCFnjMUj_Z0+3x46Hng@mail.gmail.com>
Subject: Re: [Query] About NV12 pixel format support in a subdevice
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Sat, Apr 7, 2012 at 4:51 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Sat, 7 Apr 2012, Aguirre, Sergio wrote:
>
>> Hi Guennadi,
>>
>> Thanks for your reply.
>>
>> On Sat, Apr 7, 2012 at 4:21 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Hi Sergio
>> >
>> > On Sat, 7 Apr 2012, Aguirre, Sergio wrote:
>> >
>> >> Hi everyone,
>> >>
>> >> I'll like to request for your advice on adding NV12 support for my omap4iss
>> >> camera driver, which is done after the resizer block in the OMAP4 ISS ISP
>> >> (Imaging SubSystem Image Signal Processor).
>> >>
>> >> So, the problem with that, is that I don't see a match for V4L2_PIX_FMT_NV12
>> >> pixel format in "enum v4l2_mbus_pixelcode".
>> >>
>> >> Now, I wonder what's the best way to describe the format... Is this correct?
>> >>
>> >> V4L2_MBUS_FMT_NV12_1X12
>> >>
>> >> Because every pixel is comprised of a 8-bit Y element, and it's UV components
>> >> are grouped in pairs with the next horizontal pixel, whcih in combination
>> >> are represented in 8 bits... So it's like that UV component per-pixel is 4-bits.
>> >> Not exactly, but it's the best representation I could think of to
>> >> simplify things.
>> >
>> > Do I understand it right, that your resizer is sending the data to the DMA
>> > engine interleaved, not Y and UV planes separately, and it's only the DMA
>> > engine, that is separating the planes, when writing to buffers? In such a
>> > case I'd use a suitable YUV420 V4L2_MBUS_FMT_* format for that and have
>> > the DMA engine convert it to NV12, similar to what sh_mobile_ceu_camera
>> > does.
>>
>> No, it actually has 2 register sets for specifying the start address
>> for each plane.
>
> Sorry, what "it?" The DMA engine, right? Then it still looks pretty
> similar to the CEU case to me: it also can either write the data
> interleaved into RAM and produce a YUV420 format, or convert to NV12.
> Which one to do is decided by the format, configured on the video device
> node by the driver.

Hmm, ok. I think I know what you mean now, sorry.

So you're saying I should really use, say: V4L2_MBUS_FMT_YUYV8_1_5X8 as
subdevice format, and let the v4l2 device output node either use:

- V4L2_PIX_FMT_NV12
or
- V4L2_PIX_FMT_YUV420

depending on how I want the DMA engine to organize the data.

Did I got your point correctly?

Thanks for your patience.

Regards,
Sergio

>
> Thanks
> Guennadi
>
>> So, I have one register that I program with "Y-start" address, and
>> another register
>> that I program with "UV-start" address.
>>
>> For both cases, you control the byte offset between every begin of each line.
>>
>> So, in theory, you could save it interleaved in memory if you want, or
>> in 2 separate
>> buffers depending on how you program the address/offset pair.
>>
>> Regards,
>> Sergio
>>
>> >
>> > Thanks
>> > Guennadi
>> >
>> >> I mean, the HW itself writes in memory to 2 contiguous buffers, so there's 2
>> >> separate DMA writes. I have to program 2 starting addresses, which, in an
>> >> internal non-v4l2-subdev implementation, I have been programming like this:
>> >>
>> >> paddr = start of 32-byte aligned physical address to store buffer
>> >> x = width
>> >> y = height
>> >>
>> >> Ysize = (x * y)
>> >> UVsize = (x / 2) * y
>> >> Total size = Ysize + UVsize
>> >>
>> >> Ystart = paddr
>> >> UVstart = (paddr + Ysize)
>> >>
>> >> But, in the media controller framework, i have a single DMA output pad, that
>> >> creates a v4l2 capture device node, and i'll be queueing a single buffer.
>> >>
>> >> Any advice on how to address this properly? Does anyone has/had a similar need?
>> >>
>> >> Regards,
>> >> Sergio
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >
>> > ---
>> > Guennadi Liakhovetski, Ph.D.
>> > Freelance Open-Source Software Developer
>> > http://www.open-technology.de/
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
