Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44950 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932106AbZJ3OBB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:01:01 -0400
Date: Fri, 30 Oct 2009 15:01:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/9] v4l: Add a 10-bit monochrome and missing 8- and 10-bit
 Bayer fourcc codes
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301405590.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 16-bit monochrome fourcc code has been previously abused for a 10-bit
format, add a new 10-bit code instead. Also add missing 8- and 10-bit Bayer
fourcc codes for completeness.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/videodev2.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..9b240d5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -294,6 +294,7 @@ struct v4l2_pix_format {
 
 /* Grey formats */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
+#define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
@@ -329,7 +330,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
-#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw bayer */
+#define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
+#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0') /* 10  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
 	/* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
 	/*
-- 
1.6.2.4

