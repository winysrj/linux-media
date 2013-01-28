Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:59795 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3A1MWO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 07:22:14 -0500
Date: Mon, 28 Jan 2013 13:22:10 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	linux-omap@vger.kernel.org
Subject: On MIPI-CSI2 YUV420 formats and V4L2 Media Bus formats
Message-Id: <20130128132210.433568c8c28fe1b7f0e70085@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

looking at the MIPI Alliance Specification for Camera Serial Interface
2 (I'll call it MIPI-CSI2 from now on, the document I am referring to
is mentioned at [1] and available at [2]), I see there is an YUV420 8
bit format (MIPI Data Type 0x18) specified with interleaved components
in the form of:

  YYYY...     (odd lines)
  UYVYUYVY... (even lines)

With even lines twice the size of odd lines.
Such format is also supported by some sensors, for instance ov5640, and
by MIPI-CSI2 receivers like OMAP4 ISS.

The doubt I have is: how should I represent those formats as media bus
formats?

I've seen that some drivers (sensors and SoC, for instance[3]) tend to
identify the MIPI-CSI2 format above (0x18) with media bus formats like
V4L2_MBUS_FMT_UYVY8_1_5X8 (actually the code above uses
V4L2_MBUS_FMT_YUYV8_1_5X8 is this OK?), but from the v4l2 documentation
[4] I understand that this format is supposed to have data in this
configuration:

  UUUU...
  YYYY...
  YYYY...
  VVVV...
  YYYY...
  YYYY...

That is with interleaved lines, but NOT interleaved components. Should
new media bus formats be added for YYYY.../UYVYUYVY...?

Another doubt I have is: how is the YYYY.../UYVYUYVY... data supposed
to be processed in userspace? Is the MIPI Receiver (i.e, the SoC)
expected to be able to convert it to a more usable format like YUV420P
or NV12/NV21? Or are there applications capable of handling this data
directly, or efficiently convert them to planar or semi-planar YUV420
formats?

In particular I am curios if the OMAP4 ISS can do the conversion to
NV12, I understand that the formats with interleaved _lines_ can be
produced by the resizer and handled by the OMAP ISP DMA-Engine by
setting buffers offsets to Y and UV in order to send NV12 data to
userspace, but I couldn't find info about how to handle the YUV420
MIPI-CSI2 formats (interleaved components) without the resizer in the
Developer Manual [5]; having NV12 data directly from the hardware
without using the OMAP4 ISS/ISP Resizer can be valuable in some use
cases (e.g. dual camera setups).

Thanks,
   Antonio

[1] http://www.mipi.org/specifications/camera-interface#CSI2
[2] http://ishare.sina.cn/dintro.php?id=20498632
[3]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/media/platform/soc_camera/sh_mobile_csi2.c;h=a17aba9a0104c41cbc4e5e5d277010ecac577600;hb=HEAD#l108
[4]
http://kernel.org/doc/htmldocs/media/subdev.html#v4l2-mbus-pixelcode-yuv8
[5] http://www.ti.com/lit/ug/swpu235w/swpu235w.pdf 

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
