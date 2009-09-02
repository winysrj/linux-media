Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41103 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751422AbZIBMdb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 08:33:31 -0400
Date: Wed, 2 Sep 2009 14:33:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: [PATCH 1/3] v4l: Add a 10-bit monochrome and missing 8- and 10-bit
 Bayer fourcc codes
In-Reply-To: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
Message-ID: <Pine.LNX.4.64.0909021429000.6326@axis700.grange>
References: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The 16-bit monochrome fourcc code has been previously abused for a 10-bit
format, add a new 10-bit code instead. Also add missing 8- and 10-bit Bayer
fourcc codes for completeness.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Indeed, this is not directly related to the image-bus API, but I'd like to 
have these codes available for completeness and also to stop abusing 
16-bit codes for 10-bit formats.

 include/linux/videodev2.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9d9a615..ffea559 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -293,6 +293,7 @@ struct v4l2_pix_format {
 
 /* Grey formats */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
+#define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
@@ -328,7 +329,11 @@ struct v4l2_pix_format {
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

