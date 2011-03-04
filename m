Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:42359 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab1CDI6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 03:58:39 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/4] omap3isp: ccdc: support Y10, Y12, SGRBG8, SBGGR8
Date: Fri,  4 Mar 2011 09:58:03 +0100
Message-Id: <1299229084-8335-4-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3-isp/ispccdc.c  |    4 ++++
 drivers/media/video/omap3-isp/ispvideo.c |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3-isp/ispccdc.c b/drivers/media/video/omap3-isp/ispccdc.c
index e4d04ce..166115d 100644
--- a/drivers/media/video/omap3-isp/ispccdc.c
+++ b/drivers/media/video/omap3-isp/ispccdc.c
@@ -43,6 +43,10 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_Y10_1X10,
+	V4L2_MBUS_FMT_Y12_1X12,
+	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
 	V4L2_MBUS_FMT_SGRBG10_1X10,
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
diff --git a/drivers/media/video/omap3-isp/ispvideo.c b/drivers/media/video/omap3-isp/ispvideo.c
index f16d787..c406043 100644
--- a/drivers/media/video/omap3-isp/ispvideo.c
+++ b/drivers/media/video/omap3-isp/ispvideo.c
@@ -48,6 +48,14 @@
 static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
 	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
+	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
+	  V4L2_MBUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10, 10, },
+	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
+	  V4L2_MBUS_FMT_Y12_1X12, V4L2_PIX_FMT_Y12, 12, },
+	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8, },
+	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
