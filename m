Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42549 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175Ab1KCRBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 13:01:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU30084YGMWR190@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU3009NHGMW9N@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Date: Thu, 03 Nov 2011 18:01:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 0/3] New g_framesamples subdev callback for compressed
 formats
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Many of our embedded systems I deal with are equipped with (too) smart camera 
sensors (devices) which use MIPI-CSI bus to send already compressed image data.
Usually the media bus is used with camera for transmitting raw image data, where
it's easy to calculate target memory buffer size given the pixel resolution,
bus width and number of bus samples per pixel.

However when compressed formats come into play, there is no standard way to obtain
information from a subdev how much data it is going to transmit per single frame.
In other words MIPI-CSI receiver can't know how much memory it should allocate
for MIPI-CSI transmitter to proceed.

The following change set adds g_framesamples callback to the subdev video operations
set, so the host drivers can query subdev for memory requirements per specific format.
I have added media bus pixel format as an argument because the host may need to know
number of samples per frame' if user space issues VIDIOC_TRY_FMT, at this time pixel
format at MIPI-CSI transmitter subdev might not be set yet.

I have also been preparing patches utilising '__u32 framesamples' field added to
struct v4l2_mbus_framefmt. Extending v4l2_mbus_framefmt data structure allows
to associate frame length with pads, similarly as it's done with media bus pixel
format. But if would force application to set proper framesamples value at each pad,
I suppose it could be done only for compressed formats, then the host driver would
validate the values before actually starting streaming.

Any critics and suggestions are welcome :-)


Sylwester Nawrocki (3):
  v4l: Add new g_framesamples subdev video operation
  s5p-fimc: Add g_framesamples subdev operation support
  m5mols: Add g_framesamples operation support

 drivers/media/video/m5mols/m5mols.h         |    2 +
 drivers/media/video/m5mols/m5mols_capture.c |    4 ++
 drivers/media/video/m5mols/m5mols_core.c    |   16 ++++++-
 drivers/media/video/m5mols/m5mols_reg.h     |    2 +
 drivers/media/video/s5p-fimc/fimc-capture.c |   63 +++++++++++++++++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.c    |   11 ++++-
 drivers/media/video/s5p-fimc/fimc-core.h    |    9 +++-
 include/media/v4l2-subdev.h                 |    6 +++
 8 files changed, 103 insertions(+), 10 deletions(-)


--
Regards,
Sylwester

