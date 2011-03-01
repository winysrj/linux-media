Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab1CAQEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 11:04:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: isp or soc-camera for image co-processors
Date: Tue, 1 Mar 2011 17:04:47 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com> <201103011110.06258.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011704.47946.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh,

On Tuesday 01 March 2011 12:04:34 Bhupesh SHARMA wrote:
> On Tuesday, March 01, 2011 3:40 PM Laurent Pinchart wrote: > > On Tuesday 01 
March 2011 10:46:36 Bhupesh SHARMA wrote:
> > > On Tuesday, March 01, 2011 3:11 PM Laurent Pinchart wrote:
> > > > On Tuesday 01 March 2011 08:25:12 Bhupesh SHARMA wrote:

[snip]

> > > Unfortunately the data-sheet of the co-processor cannot be made public
> > > as of yet.
> > 
> > Can you publish a block diagram of the co-processor internals ?
> 
> I will check internally to see if I can send a block-diagram of the co-
> processor internals to you. The internals seem similar to OMAP ISP (which I
> can see from the public TRM). However, our co-processor doesn't have the
> circular buffer and MMU that ISP seem to have (and some other features).

The co-processor doesn't write to the system main memory but outputs the data 
on a CSI2 or ITU interface, so that's not really surprising.

> In the meantime I copy the features of the co-processor here for your
> review:
> 
> Input / Output interfaces of co-processor:
> ==========================================
> - Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to 1.6
> Gbit/s and 1 x single lane up to 800 Mbit/s)
> - Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s) or
> ITU (8-bit CCIR interface, up to 100 MHz) - all with independent variable
> transmitter clock (PLL)
> - Control interface: CCI (up to 400 kHz) or SPI
> 
> Sensor support:
> ===============
> - Supports two MIPI compliant sensors of up to 8 Megapixel resolution
>  (one sensor streaming at a time)
> - Support for auto-focus (AF), extended depth of field (EDOF) and wide
> dynamic range (WDR)sensors
> 
> Internal Features:
> ==================
> - Versatile clock manager and internal buffer to accommodate a wide range
> of data rates between sensors and the coprocessor and between the
> coprocessor and the host.
> - Synchronized flash gun control with red-eye reduction (pre-flash and main-
> flash strobes) for high-power LED or Xenon strobe light
> - Low power standby mode
> - Two video pipes (enables concurrent viewfinding and video/stills capture)
> - Face detection and tracking algorithm
> - Video stabilization
> - Adaptive 4-channel lens shading and barrel distortion correction
> - Statistics processor for advanced automatic exposure and white balance
> - Automatic contrast stretch
> - Nine-zone auto-focus with flexible actuator driver
> - Digital zoom: smooth 16x down-scale capability and 4x up-scale capability
> - Advanced noise and defect filtering
> - Color reconstruction
> - Adaptive color correction matrix
> - Sharpness enhancement
> - Programmable gamma correction
> - Lighting frequency detection and automatic flicker reduction
> - Image rotation/mirroring/flip for the viewfinder (up to 480 x 360)
> - Special effects
> 
> Data Formats:
> =============
> - Output formats: JPEG, YUV4:2:2, YUV4:2:0, Planar YUV4:2:0 (up to 480 x
> 360), RGB888, RGB565, RGB444
> - JPEG compression with programmable quantization matrix and target file
> size

Given the complexity of the co-processor, I think it would make sense to break 
it in pieces and use the media controller API, especially if data routing is 
configurable inside the co-processor.

-- 
Regards,

Laurent Pinchart
