Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2DGWNc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 18:13:32 -0400
Date: Sun, 8 Apr 2012 00:13:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Query] About NV12 pixel format support in a subdevice
In-Reply-To: <CAKnK67SCS3LyQcf_bGi8grhkDA8uYKvGCFnjMUj_Z0+3x46Hng@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204080012110.25526@axis700.grange>
References: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
 <Pine.LNX.4.64.1204072316460.25526@axis700.grange>
 <CAKnK67RtoOVV0P_9kdc5q0mQTVhqN6MCbvj0eTLuS98096uAHw@mail.gmail.com>
 <Pine.LNX.4.64.1204072349280.25526@axis700.grange>
 <CAKnK67SCS3LyQcf_bGi8grhkDA8uYKvGCFnjMUj_Z0+3x46Hng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Apr 2012, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> On Sat, Apr 7, 2012 at 4:51 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Sat, 7 Apr 2012, Aguirre, Sergio wrote:
> >
> >> Hi Guennadi,
> >>
> >> Thanks for your reply.
> >>
> >> On Sat, Apr 7, 2012 at 4:21 PM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > Hi Sergio
> >> >
> >> > On Sat, 7 Apr 2012, Aguirre, Sergio wrote:
> >> >
> >> >> Hi everyone,
> >> >>
> >> >> I'll like to request for your advice on adding NV12 support for my omap4iss
> >> >> camera driver, which is done after the resizer block in the OMAP4 ISS ISP
> >> >> (Imaging SubSystem Image Signal Processor).
> >> >>
> >> >> So, the problem with that, is that I don't see a match for V4L2_PIX_FMT_NV12
> >> >> pixel format in "enum v4l2_mbus_pixelcode".
> >> >>
> >> >> Now, I wonder what's the best way to describe the format... Is this correct?
> >> >>
> >> >> V4L2_MBUS_FMT_NV12_1X12
> >> >>
> >> >> Because every pixel is comprised of a 8-bit Y element, and it's UV components
> >> >> are grouped in pairs with the next horizontal pixel, whcih in combination
> >> >> are represented in 8 bits... So it's like that UV component per-pixel is 4-bits.
> >> >> Not exactly, but it's the best representation I could think of to
> >> >> simplify things.
> >> >
> >> > Do I understand it right, that your resizer is sending the data to the DMA
> >> > engine interleaved, not Y and UV planes separately, and it's only the DMA
> >> > engine, that is separating the planes, when writing to buffers? In such a
> >> > case I'd use a suitable YUV420 V4L2_MBUS_FMT_* format for that and have
> >> > the DMA engine convert it to NV12, similar to what sh_mobile_ceu_camera
> >> > does.
> >>
> >> No, it actually has 2 register sets for specifying the start address
> >> for each plane.
> >
> > Sorry, what "it?" The DMA engine, right? Then it still looks pretty
> > similar to the CEU case to me: it also can either write the data
> > interleaved into RAM and produce a YUV420 format, or convert to NV12.
> > Which one to do is decided by the format, configured on the video device
> > node by the driver.
> 
> Hmm, ok. I think I know what you mean now, sorry.
> 
> So you're saying I should really use, say: V4L2_MBUS_FMT_YUYV8_1_5X8 as
> subdevice format, and let the v4l2 device output node either use:
> 
> - V4L2_PIX_FMT_NV12
> or
> - V4L2_PIX_FMT_YUV420
> 
> depending on how I want the DMA engine to organize the data.
> 
> Did I got your point correctly?

Yes, that's what I meant. Sorry for not explaining properly:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
