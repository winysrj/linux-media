Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58318 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab3BGRWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:22:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	linux-omap@vger.kernel.org
Subject: Re: On MIPI-CSI2 YUV420 formats and V4L2 Media Bus formats
Date: Thu, 07 Feb 2013 18:23:03 +0100
Message-ID: <2144542.XDLSl73tEu@avalon>
In-Reply-To: <20130206233347.aa2f12b45f487677b7c2cd5d@studenti.unina.it>
References: <20130128132210.433568c8c28fe1b7f0e70085@studenti.unina.it> <3106282.VAxg78mvQZ@avalon> <20130206233347.aa2f12b45f487677b7c2cd5d@studenti.unina.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

On Wednesday 06 February 2013 23:33:47 Antonio Ospite wrote:
> On Wed, 30 Jan 2013 01:23:48 +0100 Laurent Pinchart wrote:
> > On Monday 28 January 2013 13:22:10 Antonio Ospite wrote:
> > > Hi,
> > > 
> > > looking at the MIPI Alliance Specification for Camera Serial Interface
> > > 2 (I'll call it MIPI-CSI2 from now on, the document I am referring to
> > > is mentioned at [1] and available at [2]), I see there is an YUV420 8
> > > bit format (MIPI Data Type 0x18) specified with interleaved components
> > > 
> > > in the form of:
> > >   YYYY...     (odd lines)
> > >   UYVYUYVY... (even lines)
> > > 
> > > With even lines twice the size of odd lines.
> > > Such format is also supported by some sensors, for instance ov5640, and
> > > by MIPI-CSI2 receivers like OMAP4 ISS.
> > > 
> > > The doubt I have is: how should I represent those formats as media bus
> > > formats?
> > 
> > We likely need new media bus formats to describe those.
> 
> OK, I'll think to some names if I am going to actually use them.
> 
> > > I've seen that some drivers (sensors and SoC, for instance[3]) tend to
> > > identify the MIPI-CSI2 format above (0x18) with media bus formats like
> > > V4L2_MBUS_FMT_UYVY8_1_5X8 (actually the code above uses
> > > V4L2_MBUS_FMT_YUYV8_1_5X8 is this OK?), but from the v4l2 documentation
> > > [4] I understand that this format is supposed to have data in this
> > > 
> > > configuration:
> > >   UUUU...
> > >   YYYY...
> > >   YYYY...
> > >   VVVV...
> > >   YYYY...
> > >   YYYY...
> > 
> > Not exactly, the UYVY8_1_5X8 is transmits Y, U and V samples as UYYVYY...
> 
> Wait, am I misunderstanding the documentation at
> http://kernel.org/doc/htmldocs/media/subdev.html#v4l2-mbus-pixelcode-yuv8
> ? From the tables there it looks like that in UYVY8_1_5X8 the
> components are not interleaved on the same line, only the lines are.

Yes there's a misunderstanding. The table shows how bits are layed in in 
samples transmitted on the bus. The first sample transmits a U byte (8 bits, 
u7 to u0), the next two samples two Y bytes, the next sample a V byte, ... 
Every line does contain Y, U and V data.

> And that's why I was believing the code in [3] which maps YUYV8_1_5X8 (line
> interleaved, according to my interpretation of the v4l doc) to the MIPI-CSI2
> 0x18 format (components interleaved), was inaccurate (in the sense that I
> would have expected another [new] media bus format).
> 
> > > That is with interleaved lines, but NOT interleaved components. Should
> > > new media bus formats be added for YYYY.../UYVYUYVY...?
> > 
> > Yes, I think so.
> > 
> > > Another doubt I have is: how is the YYYY.../UYVYUYVY... data supposed
> > > to be processed in userspace? Is the MIPI Receiver (i.e, the SoC)
> > > expected to be able to convert it to a more usable format like YUV420P
> > > or NV12/NV21? Or are there applications capable of handling this data
> > > directly, or efficiently convert them to planar or semi-planar YUV420
> > > formats?
> > 
> > The bridge (receiver and DMA engine) driver will expose V4L2 pixel formats
> > corresponding to the bridge capabilities. If the bridge can store the
> > above stream in memory in NV12 it will expose that to applications. If the
> > bridge stores data in memory as described above, it will just expose that
> > format (it seems to correspond to the V4L2 M420 pixel format), and
> > applications will need to handle that explicitly.
> 
> I see, so what I can get in userspace obviously depends on the hardware
> _and_ the driver (i.e. how complete it is in exposing the hardware
> capabilities), but that means that if a bridge can transparently pass
> the data it gets from the sensor (in a given mediabus format) we could
> have as many pixelformats as we have media bus formats, I know these
> latter won't be added in practice, but is my reasoning right in
> principle? Each mediabus format is a possible candidate for a new
> pixelformat. Maybe I am asking the obvious but I am trying to complete
> my understanding about the relationship between media bus formats and
> pixelformats.

That's nearly correct. Let's say that you have two sensors that generate YUYV 
4:2:2 packed data. The first one has an 8-bit parallel bus and transmits 
samples as Y0 U0 Y1 V0 Y2 U2 Y3 V2... The second one has a 16-bit parallel bus 
and transmits samples as Y0U0 Y1V0 Y2U2 Y3V2... Both would result in the same 
pixel format in memory, even though they are different media bus pixel codes.

Other than that, yes, your understanding is correct.

> BTW that M420 format you mention is a bit different, from what I can
> see[6] it is something like a "line interleaved NV12":
> 
>   YYYY...
>   YYYY...
>   UVUV...
>   YYYY...
>   YYYY...
>   UVUV...
>   ....
> 
> [6]
> http://www.linuxtv.org/downloads/v4l-dvb-apis/V4L2-PIX-FMT-M420.html
> 
> So still another variation  on the theme :) Or am I still reading the
> documentation the wrong way?

You're right, my bad.

> > > In particular I am curios if the OMAP4 ISS can do the conversion to
> > > NV12, I understand that the formats with interleaved _lines_ can be
> > > produced by the resizer and handled by the OMAP ISP DMA-Engine by
> > > setting buffers offsets to Y and UV in order to send NV12 data to
> > > userspace, but I couldn't find info about how to handle the YUV420 MIPI-
> > > CSI2 formats (interleaved components) without the resizer in the
> > > Developer Manual [5]; having NV12 data directly from the hardware
> > > without using the OMAP4 ISS/ISP Resizer can be valuable in some use
> > > cases (e.g. dual camera setups).
> > 
> > No idea about that, sorry.
> 
> Not at all. I was hoping Sergio would step up here.
> 
> Thanks again,
>    Antonio
> 
> > > [1] http://www.mipi.org/specifications/camera-interface#CSI2
> > > [2] http://ishare.sina.cn/dintro.php?id=20498632
> > > [3]
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=dr
> > > iver
> > > s/media/platform/soc_camera/sh_mobile_csi2.c;h=a17aba9a0104c41cbc4e5e5d
> > > 27701 0ecac577600;hb=HEAD#l108 [4]
> > > http://kernel.org/doc/htmldocs/media/subdev.html#v4l2-mbus-pixelcode-yuv
> > > 8
> > > [5] http://www.ti.com/lit/ug/swpu235w/swpu235w.pdf

-- 
Regards,

Laurent Pinchart

