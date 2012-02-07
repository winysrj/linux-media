Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33291 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2BGKF0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 05:05:26 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v3 1/2] media: add new mediabus format enums for dm365
Date: Tue, 7 Feb 2012 15:35:13 +0530
Message-ID: <1328609114-5487-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1328609114-5487-1-git-send-email-manjunath.hadli@ti.com>
References: <1328609114-5487-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add new enum entries for supporting the media-bus formats on dm365.
These include some bayer and some non-bayer formats.
V4L2_MBUS_FMT_YDYC8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
internal to the hardware by the resizer.
V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
that is supported by dm365 hardware.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml |  171 ++++++++++++++++++++
 include/linux/v4l2-mediabus.h                      |   10 +-
 2 files changed, 179 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..48d92bb 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -356,6 +356,9 @@
 	<listitem><para>If the pixel components are DPCM-compressed, a mention of the
 	DPCM compression and the number of bits per compressed pixel component.</para>
 	</listitem>
+	<listitem><para>If the pixel components are ALAW-compressed, a mention of the
+	ALAW compression and the number of bits per compressed pixel component.</para>
+	</listitem>
 	<listitem><para>The number of bus samples per pixel. Pixels that are wider than
 	the bus width must be transferred in multiple samples. Common values are
 	1 and 2.</para></listitem>
@@ -572,6 +575,74 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-ALAW8-1X8">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8</entry>
+	      <entry>0x3015</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGBRG10-ALAW8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8</entry>
+	      <entry>0x3016</entry>
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
+	    <row id="V4L2-MBUS-FMT-SGRBG10-ALAW8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8</entry>
+	      <entry>0x3017</entry>
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
+	    <row id="V4L2-MBUS-FMT-SRGGB10-ALAW8-1X8">
+	      <entry>V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8</entry>
+	      <entry>0x3018</entry>
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
 	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-BE">
 	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
 	      <entry>0x3003</entry>
@@ -965,6 +1036,56 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-UV8-1X8">
+	      <entry>V4L2_MBUS_FMT_UV8_1X8</entry>
+	      <entry>0x2015</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-UYVY8-1_5X8">
 	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
 	      <entry>0x2002</entry>
@@ -2415,6 +2536,56 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-YDYC8-1X16">
+	      <entry>V4L2_MBUS_FMT_YDYC8_1X16</entry>
+	      <entry>0x2014</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>d<subscript>7</subscript></entry>
+	      <entry>d<subscript>6</subscript></entry>
+	      <entry>d<subscript>5</subscript></entry>
+	      <entry>d<subscript>4</subscript></entry>
+	      <entry>d<subscript>3</subscript></entry>
+	      <entry>d<subscript>2</subscript></entry>
+	      <entry>d<subscript>1</subscript></entry>
+	      <entry>d<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>c<subscript>7</subscript></entry>
+	      <entry>c<subscript>6</subscript></entry>
+	      <entry>c<subscript>5</subscript></entry>
+	      <entry>c<subscript>4</subscript></entry>
+	      <entry>c<subscript>3</subscript></entry>
+	      <entry>c<subscript>2</subscript></entry>
+	      <entry>c<subscript>1</subscript></entry>
+	      <entry>c<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
 	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
 	      <entry>0x200d</entry>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..8d68fa1 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -47,8 +47,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
 
-	/* YUV (including grey) - next is 0x2014 */
+	/* YUV (including grey) - next is 0x2016 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
+	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
 	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
@@ -65,10 +66,11 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
 	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
 	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
+	V4L2_MBUS_FMT_YDYC8_1X16 = 0x2014,
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x3015 */
+	/* Bayer - next is 0x3019 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
@@ -77,6 +79,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
 	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
+	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
+	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
+	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
+	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
-- 
1.6.2.4

