Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:54617 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1L1KVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 05:21:02 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/2] v4l: Add DPCM compressed formats
Date: Wed, 28 Dec 2011 12:20:56 +0200
Message-Id: <1325067657-32556-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111228102028.GR3677@valkosipuli.localdomain>
References: <20111228102028.GR3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/videodev2.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 0f8f904..560e468 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -365,7 +365,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
 	/* 10bit raw bayer DPCM compressed to 8 bits */
+#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('B', 'D', 'B', '1')
+#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('B', 'D', 'G', '1')
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
+#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('B', 'D', 'R', '1')
 	/*
 	 * 10bit raw bayer, expanded to 16 bits
 	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
-- 
1.7.2.5

