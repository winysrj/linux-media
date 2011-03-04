Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:42339 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285Ab1CDI61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 03:58:27 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/4] OMAP3-ISP lane shifter support
Date: Fri,  4 Mar 2011 09:58:00 +0100
Message-Id: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for the ISP's lane shifter.  To use the shifter, set different
pixel formats at each end of the link at the CCDC input.

This has only been tested shifting Y12 and SBGGR12 from a parallel sensor to Y8
and SBGGR12 (respectively) at the CCDC input.  Support has also been added for
other formats and other shifting values, but is untested.  Shifting data coming
from one of the serial sensor interfaces (CSI2a, etc) is also untested.

As before, ccdc_try_format() does not check that the format at its input is
compatible with the format coming from the sensor interface. This consistency
check is first done when activating the pipeline.

These patches apply to Laurent's media-0005-omap3isp branch, based on 2.6.38-rc5

Michael Jones (4):
  v4l: add V4L2_PIX_FMT_Y12 format
  media: add 8-bit bayer formats and Y12
  omap3isp: ccdc: support Y10, Y12, SGRBG8, SBGGR8
  omap3isp: lane shifter support

 drivers/media/video/omap3-isp/isp.c      |   82 +++++++++++++++++++++++++++++-
 drivers/media/video/omap3-isp/isp.h      |    4 +-
 drivers/media/video/omap3-isp/ispccdc.c  |    6 ++-
 drivers/media/video/omap3-isp/ispvideo.c |   65 ++++++++++++++++++-----
 drivers/media/video/omap3-isp/ispvideo.h |    3 +
 include/linux/v4l2-mediabus.h            |    7 ++-
 include/linux/videodev2.h                |    1 +
 7 files changed, 148 insertions(+), 20 deletions(-)

-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
