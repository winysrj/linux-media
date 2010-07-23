Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751756Ab0GWIN1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 04:13:27 -0400
Date: Fri, 23 Jul 2010 10:13:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
Message-ID: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pixel format codes, defined in the MIPI CSI-2 specification.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Even though it affects the same enum as my patch from yesterday, they are 
independent, Hans and Laurent CCed just to avoid possible conflicts, when 
further patching this file.

 include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index a870965..b0dcace 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -41,6 +41,32 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
 	V4L2_MBUS_FMT_SGRBG8_1X8,
+	/* MIPI CSI-2 codes */
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_L,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_CSPS,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10_CSPS,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_8,
+	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_10,
+	V4L2_MBUS_FMT_MIPI_CSI2_RGB888,
+	V4L2_MBUS_FMT_MIPI_CSI2_RGB666,
+	V4L2_MBUS_FMT_MIPI_CSI2_RGB565,
+	V4L2_MBUS_FMT_MIPI_CSI2_RGB555,
+	V4L2_MBUS_FMT_MIPI_CSI2_RGB444,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW6,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW7,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW8,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW10,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW12,
+	V4L2_MBUS_FMT_MIPI_CSI2_RAW14,
+	V4L2_MBUS_FMT_MIPI_CSI2_GEN_NULL,
+	V4L2_MBUS_FMT_MIPI_CSI2_GEN_BLANKING,
+	V4L2_MBUS_FMT_MIPI_CSI2_GEN_EMBEDDED8,
+	V4L2_MBUS_FMT_MIPI_CSI2_USER_1,
+	V4L2_MBUS_FMT_MIPI_CSI2_USER_2,
+	V4L2_MBUS_FMT_MIPI_CSI2_USER_3,
+	V4L2_MBUS_FMT_MIPI_CSI2_USER_4,
 };
 
 /**
-- 
1.6.2.4

