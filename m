Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16208 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaLOQdo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:33:44 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2 3/3] yavta: Add support for 10-bit packed raw bayer formats
Date: Mon, 15 Dec 2014 18:26:49 +0200
Message-Id: <1418660809-30548-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for these pixel formats:

V4L2_PIX_FMT_SBGGR10P
V4L2_PIX_FMT_SGBRG10P
V4L2_PIX_FMT_SGRBG10P
V4L2_PIX_FMT_SRGGB10P

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/yavta.c b/yavta.c
index 003d6ba..f40562a 100644
--- a/yavta.c
+++ b/yavta.c
@@ -202,6 +202,10 @@ static struct v4l2_format_info {
 	{ "SGBRG10", V4L2_PIX_FMT_SGBRG10, 1 },
 	{ "SGRBG10", V4L2_PIX_FMT_SGRBG10, 1 },
 	{ "SRGGB10", V4L2_PIX_FMT_SRGGB10, 1 },
+	{ "SBGGR10P", V4L2_PIX_FMT_SBGGR10P, 1 },
+	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
+	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
+	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
 	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
 	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
 	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },
-- 
2.1.0.231.g7484e3b

