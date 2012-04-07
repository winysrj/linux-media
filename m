Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:45939 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab2DGVjP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 17:39:15 -0400
Received: by werf3 with SMTP id f3so2674336wer.11
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 14:39:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1204072316460.25526@axis700.grange>
References: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
 <Pine.LNX.4.64.1204072316460.25526@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 7 Apr 2012 16:38:52 -0500
Message-ID: <CAKnK67RtoOVV0P_9kdc5q0mQTVhqN6MCbvj0eTLuS98096uAHw@mail.gmail.com>
Subject: Re: [Query] About NV12 pixel format support in a subdevice
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for your reply.

On Sat, Apr 7, 2012 at 4:21 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Sergio
>
> On Sat, 7 Apr 2012, Aguirre, Sergio wrote:
>
>> Hi everyone,
>>
>> I'll like to request for your advice on adding NV12 support for my omap4iss
>> camera driver, which is done after the resizer block in the OMAP4 ISS ISP
>> (Imaging SubSystem Image Signal Processor).
>>
>> So, the problem with that, is that I don't see a match for V4L2_PIX_FMT_NV12
>> pixel format in "enum v4l2_mbus_pixelcode".
>>
>> Now, I wonder what's the best way to describe the format... Is this correct?
>>
>> V4L2_MBUS_FMT_NV12_1X12
>>
>> Because every pixel is comprised of a 8-bit Y element, and it's UV components
>> are grouped in pairs with the next horizontal pixel, whcih in combination
>> are represented in 8 bits... So it's like that UV component per-pixel is 4-bits.
>> Not exactly, but it's the best representation I could think of to
>> simplify things.
>
> Do I understand it right, that your resizer is sending the data to the DMA
> engine interleaved, not Y and UV planes separately, and it's only the DMA
> engine, that is separating the planes, when writing to buffers? In such a
> case I'd use a suitable YUV420 V4L2_MBUS_FMT_* format for that and have
> the DMA engine convert it to NV12, similar to what sh_mobile_ceu_camera
> does.

No, it actually has 2 register sets for specifying the start address
for each plane.

So, I have one register that I program with "Y-start" address, and
another register
that I program with "UV-start" address.

For both cases, you control the byte offset between every begin of each line.

So, in theory, you could save it interleaved in memory if you want, or
in 2 separate
buffers depending on how you program the address/offset pair.

Regards,
Sergio

>
> Thanks
> Guennadi
>
>> I mean, the HW itself writes in memory to 2 contiguous buffers, so there's 2
>> separate DMA writes. I have to program 2 starting addresses, which, in an
>> internal non-v4l2-subdev implementation, I have been programming like this:
>>
>> paddr = start of 32-byte aligned physical address to store buffer
>> x = width
>> y = height
>>
>> Ysize = (x * y)
>> UVsize = (x / 2) * y
>> Total size = Ysize + UVsize
>>
>> Ystart = paddr
>> UVstart = (paddr + Ysize)
>>
>> But, in the media controller framework, i have a single DMA output pad, that
>> creates a v4l2 capture device node, and i'll be queueing a single buffer.
>>
>> Any advice on how to address this properly? Does anyone has/had a similar need?
>>
>> Regards,
>> Sergio
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
