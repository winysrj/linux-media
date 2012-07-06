Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2GFNqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:46:43 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6Q00J2SRLPRD10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Jul 2012 22:46:42 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6Q00L9JRLECT00@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Jul 2012 22:46:42 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, hans.verkuil@cisco.com,
	mchehab@infradead.org
Subject: [PATCH v2 1/2] [media] v4l: add fourcc definitions for new formats
Date: Fri, 06 Jul 2012 19:30:16 +0530
Message-id: <1341583217-11305-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
References: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

Add new fourcc definitions for interleaved YCbCr and
compressed formats MVC and VP8.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 include/linux/videodev2.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f79d0cc..e23e6a7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -359,7 +359,9 @@ struct v4l2_pix_format {
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
+#define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
+#define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
 
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
@@ -395,6 +397,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
 #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
 #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
+#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
@@ -402,6 +405,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
+#define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
1.7.0.4

