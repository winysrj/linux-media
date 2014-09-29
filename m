Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49618 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaI2U2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 16:28:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH 04/11] v4l: Add VUY8 24 bits bus format
Date: Mon, 29 Sep 2014 23:27:50 +0300
Message-Id: <1412022477-28749-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hyun Kwon <hyun.kwon@xilinx.com>

Add VUY8 24 bits bus format, V4L2_MBUS_FMT_VUY8_1X24.

Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 30 ++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |  3 ++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 588aed4..aef3c8b 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2999,6 +2999,36 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-VUY8-1X24">
+	      <entry>V4L2_MBUS_FMT_VUY8_1X24</entry>
+	      <entry>0x201a</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-UYVY12-1X24">
 	      <entry>V4L2_MBUS_FMT_UYVY12_1X24</entry>
 	      <entry>0x2020</entry>
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 9be976f..31b4ce1 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -54,7 +54,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
 	V4L2_MBUS_FMT_RGB888_1X32_PADHI = 0x100f,
 
-	/* YUV (including grey) - next is 0x2024 */
+	/* YUV (including grey) - next is 0x2025 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
@@ -84,6 +84,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_VYUY10_1X20 = 0x201b,
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
+	V4L2_MBUS_FMT_VUY8_1X24 = 0x2024,
 	V4L2_MBUS_FMT_UYVY12_1X24 = 0x2020,
 	V4L2_MBUS_FMT_VYUY12_1X24 = 0x2021,
 	V4L2_MBUS_FMT_YUYV12_1X24 = 0x2022,
-- 
1.8.5.5

