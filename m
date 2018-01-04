Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4388 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbeADDs5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 22:48:57 -0500
From: tian.shu.qiu@intel.com
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Qiu@vger.kernel.org, Tianshu <tian.shu.qiu@intel.com>
Subject: [MAIN PATCH v1 2/2] Add support for intel ipu3 specific raw formats
Date: Thu,  4 Jan 2018 11:48:13 +0800
Message-Id: <1515037693-29631-3-git-send-email-tian.shu.qiu@intel.com>
In-Reply-To: <1515037693-29631-1-git-send-email-tian.shu.qiu@intel.com>
References: <1515037693-29631-1-git-send-email-tian.shu.qiu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tianshu Qiu <tian.shu.qiu@intel.com>

Add support for these pixel formats:

V4L2_PIX_FMT_IPU3_SBGGR10
V4L2_PIX_FMT_IPU3_SGBRG10
V4L2_PIX_FMT_IPU3_SGRBG10
V4L2_PIX_FMT_IPU3_SRGGB10

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 yavta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/yavta.c b/yavta.c
index afe96331a520..524e549efd08 100644
--- a/yavta.c
+++ b/yavta.c
@@ -220,6 +220,10 @@ static struct v4l2_format_info {
 	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
 	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
 	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
+	{ "IPU3_GRBG10", V4L2_PIX_FMT_IPU3_SGRBG10, 1 },
+	{ "IPU3_RGGB10", V4L2_PIX_FMT_IPU3_SRGGB10, 1 },
+	{ "IPU3_BGGR10", V4L2_PIX_FMT_IPU3_SBGGR10, 1 },
+	{ "IPU3_GBRG10", V4L2_PIX_FMT_IPU3_SGBRG10, 1 },
 	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
 	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
 	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },
-- 
2.7.4
