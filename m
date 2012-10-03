Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55488 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2JCRGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:06:13 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB00N73U663U30@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:11 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBB009RUU5VQI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:11 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH v10 1/7] [media] v4l: Add fourcc definitions for new formats
Date: Thu, 04 Oct 2012 06:49:05 +0530
Message-id: <1349313551-23368-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
References: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the following new fourcc definitions.
For multiplanar YCbCr
	- V4L2_PIX_FMT_NV21M
	- V4L2_PIX_FMT_NV12MT_16X16
and compressed formats
	- V4L2_PIX_FMT_H264_MVC
	- V4L2_PIX_FMT_VP8

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml |   17 ++++++++++++-----
 Documentation/DocBook/media/v4l/pixfmt.xml       |   10 ++++++++++
 include/linux/videodev2.h                        |    4 ++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
index 5274c24..a990b34 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
@@ -1,11 +1,13 @@
-    <refentry id="V4L2-PIX-FMT-NV12M">
+    <refentry>
       <refmeta>
-	<refentrytitle>V4L2_PIX_FMT_NV12M ('NM12')</refentrytitle>
+	<refentrytitle>V4L2_PIX_FMT_NV12M ('NM12'), V4L2_PIX_FMT_NV21M ('NM21'), V4L2_PIX_FMT_NV12MT_16X16</refentrytitle>
 	&manvol;
       </refmeta>
       <refnamediv>
-	<refname> <constant>V4L2_PIX_FMT_NV12M</constant></refname>
-	<refpurpose>Variation of <constant>V4L2_PIX_FMT_NV12</constant> with planes
+	<refname id="V4L2-PIX-FMT-NV12M"><constant>V4L2_PIX_FMT_NV12M</constant></refname>
+	<refname id="V4L2-PIX-FMT-NV21M"><constant>V4L2_PIX_FMT_NV21M</constant></refname>
+	<refname id="V4L2-PIX-FMT-NV12MT_16X16"><constant>V4L2_PIX_FMT_NV12MT_16X16</constant></refname>
+	<refpurpose>Variation of <constant>V4L2_PIX_FMT_NV12</constant> and <constant>V4L2_PIX_FMT_NV21</constant> with planes
 	  non contiguous in memory. </refpurpose>
       </refnamediv>
       <refsect1>
@@ -22,7 +24,12 @@ The CbCr plane is the same width, in bytes, as the Y plane (and of the image),
 but is half as tall in pixels. Each CbCr pair belongs to four pixels. For example,
 Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
 Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
-Y'<subscript>10</subscript>, Y'<subscript>11</subscript>. </para>
+Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.
+<constant>V4L2_PIX_FMT_NV12MT_16X16</constant> is the tiled version of
+<constant>V4L2_PIX_FMT_NV12M</constant> with 16x16 macroblock tiles. Here pixels
+are arranged in 16x16 2D tiles and tiles are arranged in linear order in memory.
+<constant>V4L2_PIX_FMT_NV21M</constant> is the same as <constant>V4L2_PIX_FMT_NV12M</constant>
+except the Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.</para>
 
 	<para><constant>V4L2_PIX_FMT_NV12M</constant> is intended to be
 used only in drivers and applications that support the multi-planar API,
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 1ddbfab..6ca0be4 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -758,6 +758,11 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 		<entry>'AVC1'</entry>
 		<entry>H264 video elementary stream without start codes.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-H264-MVC">
+		<entry><constant>V4L2_PIX_FMT_H264_MVC</constant></entry>
+		<entry>'MVC'</entry>
+		<entry>H264 MVC video elementary stream.</entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-H263">
 		<entry><constant>V4L2_PIX_FMT_H263</constant></entry>
 		<entry>'H263'</entry>
@@ -793,6 +798,11 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 		<entry>'VC1L'</entry>
 		<entry>VC1, SMPTE 421M Annex L compliant stream.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-VP8">
+		<entry><constant>V4L2_PIX_FMT_VP8</constant></entry>
+		<entry>'VP8'</entry>
+		<entry>VP8 video elementary stream.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 61395ef..16e6ab0 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -366,7 +366,9 @@ struct v4l2_pix_format {
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
+#define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
+#define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
 
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
@@ -403,6 +405,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
 #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
+#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
@@ -410,6 +413,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
+#define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
1.7.0.4

