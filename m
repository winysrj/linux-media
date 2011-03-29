Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:36046 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1C2ITk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 04:19:40 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v4 0/4] omap3isp: lane shifter support
Date: Tue, 29 Mar 2011 10:19:05 +0200
Message-Id: <1301386749-17497-1-git-send-email-michael.jones@matrix-vision.de>
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

These patches apply to Laurent's media-2.6.38-0001-omap3isp branch, based on 2.6.38

Changes since v3:
-applies to media-2.6.38-0001-omap3isp
-added missing DocBook changes needed for Y12, e.g. pixfmt-y12.xml
-omap3isp_configure_bridge() takes 'unsigned int' instead of 'int' shift
-renamed link_has_shifter -> shifter_link

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

 Documentation/DocBook/media-entities.tmpl    |    1 +
 Documentation/DocBook/v4l/pixfmt-y12.xml     |   79 +++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml         |    1 +
 Documentation/DocBook/v4l/subdev-formats.xml |   59 ++++++++++++++
 drivers/media/video/omap3isp/isp.c           |    7 +-
 drivers/media/video/omap3isp/isp.h           |    5 +-
 drivers/media/video/omap3isp/ispccdc.c       |   33 +++++++-
 drivers/media/video/omap3isp/ispvideo.c      |  108 ++++++++++++++++++++++----
 drivers/media/video/omap3isp/ispvideo.h      |    3 +
 include/linux/v4l2-mediabus.h                |    7 +-
 include/linux/videodev2.h                    |    1 +
 11 files changed, 278 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

-- 
1.7.4.2


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
