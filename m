Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1A0MbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:31:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v1 8/8] v4l: Add 12 bits bayer pixel formats
Date: Thu, 27 Jan 2011 13:31:12 +0100
Message-Id: <1296131472-30045-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131472-30045-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1296131472-30045-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add FCCs for the following pixel formats:

- V4L2_PIX_FMT_SBGGR12
- V4L2_PIX_FMT_SGBRG12
- V4L2_PIX_FMT_SGRBG12
- V4L2_PIX_FMT_SRGGB12

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/videodev2.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5f6f470..02da9e7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -328,6 +328,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
+#define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
 	/* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
 	/*
-- 
1.7.3.4

