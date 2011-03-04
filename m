Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51423 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab1CDL0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 06:26:39 -0500
Date: Fri, 04 Mar 2011 12:26:18 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v7 1/5] Changes in include/linux/videodev2.h for MFC 5.1
In-reply-to: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1299237982-31687-2-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds fourcc values for compressed video stream formats and
V4L2_CTRL_CLASS_CODEC. Also adds controls used by MFC 5.1 driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/videodev2.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a94c4d5..a48a42e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -369,6 +369,19 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
 
+#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264    */
+#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263    */
+#define V4L2_PIX_FMT_MPEG12   v4l2_fourcc('M', 'P', '1', '2') /* MPEG-1/2  */
+#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4  */
+#define V4L2_PIX_FMT_DIVX     v4l2_fourcc('D', 'I', 'V', 'X') /* DivX  */
+#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX 3.11  */
+#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX 4.12  */
+#define V4L2_PIX_FMT_DIVX500    v4l2_fourcc('D', 'X', '5', '2') /* DivX 5.00 - 5.02  */
+#define V4L2_PIX_FMT_DIVX503    v4l2_fourcc('D', 'X', '5', '3') /* DivX 5.03 - x  */
+#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid */
+#define V4L2_PIX_FMT_VC1      v4l2_fourcc('V', 'C', '1', 'A') /* VC-1 */
+#define V4L2_PIX_FMT_VC1_RCV      v4l2_fourcc('V', 'C', '1', 'R') /* VC-1 RCV */
+
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
 #define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /* Winnov hw compress */
@@ -1016,6 +1029,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_CODEC 0x009c0000	/* Codec control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1349,6 +1363,31 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
 #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
 #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
 
+/* For codecs */
+
+#define V4L2_CID_CODEC_BASE 			(V4L2_CTRL_CLASS_CODEC | 0x900)
+#define V4L2_CID_CODEC_CLASS 			(V4L2_CTRL_CLASS_CODEC | 1)
+
+/* For both decoding and encoding */
+
+/* For encoding */
+#define V4L2_CID_CODEC_LOOP_FILTER_H264		(V4L2_CID_CODEC_BASE + 1)
+enum v4l2_cid_codec_loop_filter_h264 {
+	V4L2_CID_CODEC_LOOP_FILTER_H264_ENABLE = 0,
+	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE = 1,
+	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE_AT_BOUNDARY = 2,
+};
+
+/* For decoding */
+
+#define V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE	(V4L2_CID_CODEC_BASE + 2)
+#define V4L2_CID_CODEC_DISPLAY_DELAY		(V4L2_CID_CODEC_BASE + 3)
+#define V4L2_CID_CODEC_DISPLAY_DELAY_ENABLE	(V4L2_CID_CODEC_BASE + 4)
+#define V4L2_CID_CODEC_MIN_REQ_BUFS_OUT		(V4L2_CID_CODEC_BASE + 5)
+#define V4L2_CID_CODEC_MIN_REQ_BUFS_CAP		(V4L2_CID_CODEC_BASE + 6)
+#define V4L2_CID_CODEC_SLICE_INTERFACE		(V4L2_CID_CODEC_BASE + 7)
+#define V4L2_CID_CODEC_PACKED_PB		(V4L2_CID_CODEC_BASE + 8)
+
 /*  Camera class control IDs */
 #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
 #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
-- 
1.6.3.3
