Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DGVV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 17:21:56 -0400
Date: Sat, 7 Apr 2012 23:21:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Query] About NV12 pixel format support in a subdevice
In-Reply-To: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204072316460.25526@axis700.grange>
References: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

On Sat, 7 Apr 2012, Aguirre, Sergio wrote:

> Hi everyone,
> 
> I'll like to request for your advice on adding NV12 support for my omap4iss
> camera driver, which is done after the resizer block in the OMAP4 ISS ISP
> (Imaging SubSystem Image Signal Processor).
> 
> So, the problem with that, is that I don't see a match for V4L2_PIX_FMT_NV12
> pixel format in "enum v4l2_mbus_pixelcode".
> 
> Now, I wonder what's the best way to describe the format... Is this correct?
> 
> V4L2_MBUS_FMT_NV12_1X12
> 
> Because every pixel is comprised of a 8-bit Y element, and it's UV components
> are grouped in pairs with the next horizontal pixel, whcih in combination
> are represented in 8 bits... So it's like that UV component per-pixel is 4-bits.
> Not exactly, but it's the best representation I could think of to
> simplify things.

Do I understand it right, that your resizer is sending the data to the DMA 
engine interleaved, not Y and UV planes separately, and it's only the DMA 
engine, that is separating the planes, when writing to buffers? In such a 
case I'd use a suitable YUV420 V4L2_MBUS_FMT_* format for that and have 
the DMA engine convert it to NV12, similar to what sh_mobile_ceu_camera 
does.

Thanks
Guennadi

> I mean, the HW itself writes in memory to 2 contiguous buffers, so there's 2
> separate DMA writes. I have to program 2 starting addresses, which, in an
> internal non-v4l2-subdev implementation, I have been programming like this:
> 
> paddr = start of 32-byte aligned physical address to store buffer
> x = width
> y = height
> 
> Ysize = (x * y)
> UVsize = (x / 2) * y
> Total size = Ysize + UVsize
> 
> Ystart = paddr
> UVstart = (paddr + Ysize)
> 
> But, in the media controller framework, i have a single DMA output pad, that
> creates a v4l2 capture device node, and i'll be queueing a single buffer.
> 
> Any advice on how to address this properly? Does anyone has/had a similar need?
> 
> Regards,
> Sergio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
