Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37151 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGUUhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 16:37:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: Add ARGB555X and XRGB555X pixel formats
Date: Mon, 21 Jul 2014 22:37:45 +0200
Message-Id: <1405975065-9190-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The existing RGB555X pixel format is ill-defined in respect to its alpha
bit and its meaning is driver dependent. Create new standard ARGB555X
and XRGB555X variants with clearly defined meanings and make the
existing variant deprecated.

The new pixel formats 4CC values have been selected to match the DRM
4CCs for the same in-memory formats.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 50 ++++++++++++++++++++--
 include/uapi/linux/videodev2.h                     |  3 ++
 2 files changed, 50 insertions(+), 3 deletions(-)

Hello,

These two formats where missing from commit 977ff0e4fb3460df ("v4l: Add ARGB
and XRGB pixel formats"). By popular request, here they are.

I've decided to reuse the DRM 4CC values to ease future compatibility, but as
DRM makes big-endian 4CCs by OR'ing the little-endian 4CC with (1 << 31), I'll
be flexible if values are frowned upon.

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 5f1602f..32feac9 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -240,9 +240,9 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>g<subscript>4</subscript></entry>
 	    <entry>g<subscript>3</subscript></entry>
 	  </row>
-	  <row id="V4L2-PIX-FMT-RGB555X">
-	    <entry><constant>V4L2_PIX_FMT_RGB555X</constant></entry>
-	    <entry>'RGBQ'</entry>
+	  <row id="V4L2-PIX-FMT-ARGB555X">
+	    <entry><constant>V4L2_PIX_FMT_ARGB555X</constant></entry>
+	    <entry>'AR15' | (1 &lt;&lt; 31)</entry>
 	    <entry></entry>
 	    <entry>a</entry>
 	    <entry>r<subscript>4</subscript></entry>
@@ -262,6 +262,28 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-XRGB555X">
+	    <entry><constant>V4L2_PIX_FMT_XRGB555X</constant></entry>
+	    <entry>'XR15' | (1 &lt;&lt; 31)</entry>
+	    <entry></entry>
+	    <entry>-</entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
+	    <entry>g<subscript>4</subscript></entry>
+	    <entry>g<subscript>3</subscript></entry>
+	    <entry></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
+	    <entry>b<subscript>4</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-RGB565X">
 	    <entry><constant>V4L2_PIX_FMT_RGB565X</constant></entry>
 	    <entry>'RGBR'</entry>
@@ -803,6 +825,28 @@ image</title>
 	    <entry>g<subscript>4</subscript></entry>
 	    <entry>g<subscript>3</subscript></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-RGB555X">
+	    <entry><constant>V4L2_PIX_FMT_RGB555X</constant></entry>
+	    <entry>'RGBQ'</entry>
+	    <entry></entry>
+	    <entry>a</entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
+	    <entry>g<subscript>4</subscript></entry>
+	    <entry>g<subscript>3</subscript></entry>
+	    <entry></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
+	    <entry>b<subscript>4</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-BGR32">
 	    <entry><constant>V4L2_PIX_FMT_BGR32</constant></entry>
 	    <entry>'BGR4'</entry>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1f1a65c..8ccaa0a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -79,6 +79,7 @@
 /*  Four-character-code (FOURCC) */
 #define v4l2_fourcc(a, b, c, d)\
 	((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
+#define v4l2_fourcc_be(a, b, c, d)	(v4l2_fourcc(a, b, c, d) | (1 << 31))
 
 /*
  *	E N U M S
@@ -307,6 +308,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1', '5') /* 16  XRGB-1-5-5-5  */
 #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
+#define V4L2_PIX_FMT_ARGB555X v4l2_fourcc_be('A', 'R', '1', '5') /* 16  ARGB-5-5-5 BE */
+#define V4L2_PIX_FMT_XRGB555X v4l2_fourcc_be('X', 'R', '1', '5') /* 16  XRGB-5-5-5 BE */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
 #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
-- 
Regards,

Laurent Pinchart

