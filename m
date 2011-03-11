Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47491 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1CKIGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 03:06:06 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v3 2/4] media: add 8-bit bayer formats and Y12
Date: Fri, 11 Mar 2011 09:05:47 +0100
Message-Id: <1299830749-7269-3-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 Documentation/DocBook/v4l/subdev-formats.xml |   59 ++++++++++++++++++++++++++
 include/linux/v4l2-mediabus.h                |    7 ++-
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
index 2fed9be..37e5bc6 100644
--- a/Documentation/DocBook/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -456,6 +456,23 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-SGBRG8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGBRG8_1X8</entry>
+	      <entry>0x3013</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-SGRBG8-1X8">
 	      <entry>V4L2_MBUS_FMT_SGRBG8_1X8</entry>
 	      <entry>0x3002</entry>
@@ -473,6 +490,23 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-SRGGB8-1X8">
+	      <entry>V4L2_MBUS_FMT_SRGGB8_1X8</entry>
+	      <entry>0x3014</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
 	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
 	      <entry>0x300b</entry>
@@ -2159,6 +2193,31 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-Y12-1X12">
+	      <entry>V4L2_MBUS_FMT_Y12_1X12</entry>
+	      <entry>0x2013</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-UYVY8-1X16">
 	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
 	      <entry>0x200f</entry>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 7054a7a..de5c159 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -47,7 +47,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
 
-	/* YUV (including grey) - next is 0x2013 */
+	/* YUV (including grey) - next is 0x2014 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
@@ -60,6 +60,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
 	V4L2_MBUS_FMT_YUYV10_2X10 = 0x200b,
 	V4L2_MBUS_FMT_YVYU10_2X10 = 0x200c,
+	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
 	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200f,
 	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
 	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
@@ -67,9 +68,11 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x3013 */
+	/* Bayer - next is 0x3015 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
+	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
+	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
 	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
 	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
