Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47477 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1CKIF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 03:05:59 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v3 0/4] OMAP3-ISP lane shifter support
Date: Fri, 11 Mar 2011 09:05:45 +0100
Message-Id: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for the ISP's lane shifter.  To use the shifter, set different
pixel formats at each end of the link at the CCDC input.

This has only been tested shifting Y12 and SBGGR12 from a parallel sensor to Y8
and SBGGR8 (respectively) at the CCDC input.  Support has also been added for
other formats and other shifting values, but is untested.  Shifting data coming
from one of the serial sensor interfaces (CSI2a, etc) is also untested.

As before, ccdc_try_format() does not check that the format at its input is
compatible with the format coming from the sensor interface. This consistency
check is first done when activating the pipeline.

These patches apply to Laurent's media-0005-omap3isp branch, based on 2.6.38-rc5

Changes since v2:
-new formats are also added to Documentation/DocBook/v4l/
-reintroduce .data_lane_shift for sensors whose LSB is not aligned with
 sensor interfaces's LSB.
-style changes according to feedback

Changes since v1:
-added support for remaining 8-bit Bayer formats (SGBRG8_1X8 & SRGGB8_1X8)
-moved omap3isp_is_shiftable() from isp.c to ispvideo.c and return bool
-moved 'shift' calculation from omap3isp_configure_bridge() to ccdc_configure()
-added 'shift' arg to omap3isp_configure_bridge()
-misc minor changes according to feedback (removed unnecessary tests, etc.)

Michael Jones (4):
  v4l: add V4L2_PIX_FMT_Y12 format
  media: add 8-bit bayer formats and Y12
  omap3isp: ccdc: support Y10/12, 8-bit bayer fmts
  omap3isp: lane shifter support

 Documentation/DocBook/v4l/pixfmt-y12.xml     |   79 +++++++++++++++++++
 Documentation/DocBook/v4l/subdev-formats.xml |   59 ++++++++++++++
 drivers/media/video/omap3-isp/isp.c          |    7 +-
 drivers/media/video/omap3-isp/isp.h          |    5 +-
 drivers/media/video/omap3-isp/ispccdc.c      |   33 +++++++-
 drivers/media/video/omap3-isp/ispvideo.c     |  108 ++++++++++++++++++++++----
 drivers/media/video/omap3-isp/ispvideo.h     |    3 +
 include/linux/v4l2-mediabus.h                |    7 +-
 include/linux/videodev2.h                    |    1 +
 9 files changed, 276 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
