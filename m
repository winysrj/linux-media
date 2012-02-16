Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2BPSYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:07 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZI00GPH0G4NK@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI00JQD0G31U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:53 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 0/6] Interleaved image data on media bus
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series presents a method of capturing interleaved YUYV/JPEG image
frames with the S5P/EXYNOS FIMC and MIPI-CSIS devices I went for to support 
a camera (sensor) that outputs interleaved image data at single User Defined 
MIPI-CSI2 data format. Such data is a combined two frames where each frame's 
resolution is separately configurable, i.e. both frames can have different
resolution. Additionally the sensor generates relatively small amount of 
meta data which is necessary for interpreting the interleaved format.  

I decided to use two-planar buffers for this, rather than using separate
buffer queues for the image and the meta data. Since both data are captured
at different devices and matching those data in user space might be hard to
achieve, and would add to complexity in the applications significantly.

So here is the initial patch series, I'm sending it early to possibly get
some better ideas...or just to have some background for discussion. :)

I suppose the get/set_frame_config callbacks are most open issues. I intended
these callbacks and the associated data structure as helpers for performing
additional configuration for transmission of more complex data than just
single raw image frame on media bus. I'm open to changing it, that's mainly
to indicate we really need such sort of an API.


Thoughts ?

--

Regards,
Sylwester

Sylwester Nawrocki (6):
  V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media bus format
  V4L: Add V4L2_PIX_FMT_JPG_YUV_S5C fourcc definition
  V4L: Add g_embedded_data subdev callback
  V4L: Add get/set_frame_config subdev callbacks
  s5p-fimc: Add support for V4L2_PIX_FMT_JPG_YUYV_S5C fourcc
  s5p-csis: Add support for non-image data packets capture

 Documentation/DocBook/media/v4l/pixfmt.xml  |    8 +
 drivers/media/video/s5p-fimc/fimc-capture.c |  123 ++++++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |   37 +++-
 drivers/media/video/s5p-fimc/fimc-core.h    |   22 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    5 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |  312 +++++++++++++++++++++++++--
 include/linux/v4l2-mediabus.h               |    3 +
 include/linux/videodev2.h                   |    1 +
 include/media/v4l2-subdev.h                 |   28 +++
 9 files changed, 483 insertions(+), 56 deletions(-)

-- 
1.7.9

