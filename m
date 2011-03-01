Return-path: <mchehab@pedra>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:37631 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab1CALFE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 06:05:04 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 1 Mar 2011 19:04:34 +0800
Subject: RE: isp or soc-camera for image co-processors
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
 <201103011041.03424.laurent.pinchart@ideasonboard.com>
 <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com>
 <201103011110.06258.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103011110.06258.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, March 01, 2011 3:40 PM
> To: Bhupesh SHARMA
> Cc: Guennadi Liakhovetski; linux-media@vger.kernel.org
> Subject: Re: isp or soc-camera for image co-processors
> 
> Hi Bhupesh,
> 
> On Tuesday 01 March 2011 10:46:36 Bhupesh SHARMA wrote:
> > On Tuesday, March 01, 2011 3:11 PM Laurent Pinchart wrote:
> > > On Tuesday 01 March 2011 08:25:12 Bhupesh SHARMA wrote:
> > > > Hi Guennadi and Laurent,
> > > >
> > > > We are now evaluating another ST platform that supports a image
> > > > co-processor between the camera sensor and the camera host (SoC).
> > > >
> > > > The simple architecture diagram will be similar to one shown
> below
> > > > (for the sake of simplicity I show only a single sensor. At least
> > >
> > > > two sensors can be supported by the co-processor):
> > > [snip] (as the ascii-art looks more like a Picasso painting with
> the
> > > quote
> > > characters)
> > :
> > :(
> >
> > Despite my efforts to align it properly :)
> 
> Try to configure your mailer to use spaces instead of tabs, or to make
> tabs 8
> spaces wide. It should then look good. Replies will usually mess the
> diagrams
> up though.

Ok, I will try it :)

> > > > The co-processor supports a video progressing logic engine
> capable of
> > > > performing a variety of operations like image recovery, cropping,
> > > > scaling, gamma correction etc.
> > > >
> > > > Now, evaluating the framework available for supporting for the
> camera
> > > > host, sensor and co-processor, I am wondering whether soc-
> camera(v4l2)
> > > > can support this complex design or something similar to the ISP
> driver
> > > > written for OMAP is the way forward.
> > >
> > > I think this can be a good candidate for the media controller API.
> It
> > > depends on how complex the co-processor is and what kind of
> processing it
> > > performs. I suppose there's no public datasheet.
> > >
> > > You will probably need to enhance subdev registration, as I'm not
> aware
> > > of any existing use case such as yours where a chain of subdevs
> unknown to
> > > the host controller is connected to the host controller input.
> >
> > Could you please give me some documentation links for media
> controller API.
> 
> The media controller documentation is part of the V4L2 kernel
> documentation.
> You can find a compiled copy at
> http://www.ideasonboard.org/media/media/

Thanks, I will go through the same.

> The in-kernel API is documented in the kernel sources, in
> Documentation/media-
> framework.txt
> 
> > Are there are reference drivers that I can use for my study?
> 
> The OMAP3 ISP driver.

Thanks, I will go through the same.

> > Unfortunately the data-sheet of the co-processor cannot be made
> public
> > as of yet.
> 
> Can you publish a block diagram of the co-processor internals ?

I will check internally to see if I can send a block-diagram
of the co-processor internals to you. The internals seem similar to 
OMAP ISP (which I can see from the public TRM). However, our
co-processor doesn't have the circular buffer and MMU that ISP seem to
have (and some other features).

In the meantime I copy the features of the co-processor here for your review:

Input / Output interfaces of co-processor:
==========================================
- Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to 1.6 Gbit/s
 and 1 x single lane up to 800 Mbit/s)
- Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s) or ITU
 (8-bit CCIR interface, up to 100 MHz) - all with independent variable
 transmitter clock (PLL)
- Control interface: CCI (up to 400 kHz) or SPI

Sensor support:
===============
- Supports two MIPI compliant sensors of up to 8 Megapixel resolution
 (one sensor streaming at a time)
- Support for auto-focus (AF), extended depth of field (EDOF) and wide dynamic
 range (WDR)sensors 

Internal Features:
==================
- Versatile clock manager and internal buffer to accommodate a wide range of data rates
  between sensors and the coprocessor and between the coprocessor and the host.
- Synchronized flash gun control with red-eye reduction (pre-flash and main-flash strobes) for
  high-power LED or Xenon strobe light
- Low power standby mode
- Two video pipes (enables concurrent viewfinding and video/stills capture)
- Face detection and tracking algorithm
- Video stabilization
- Adaptive 4-channel lens shading and barrel distortion correction
- Statistics processor for advanced automatic exposure and white balance
- Automatic contrast stretch
- Nine-zone auto-focus with flexible actuator driver
- Digital zoom: smooth 16x down-scale capability and 4x up-scale capability
- Advanced noise and defect filtering
- Color reconstruction
- Adaptive color correction matrix
- Sharpness enhancement
- Programmable gamma correction
- Lighting frequency detection and automatic flicker reduction
- Image rotation/mirroring/flip for the viewfinder (up to 480 x 360)
- Special effects

Data Formats:
=============
- Output formats: JPEG, YUV4:2:2, YUV4:2:0, Planar YUV4:2:0 (up to 480 x 360), RGB888,
  RGB565, RGB444 
- JPEG compression with programmable quantization matrix and target file size

Regards,
Bhupesh
