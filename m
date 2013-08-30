Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64681 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3H3M3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:29:44 -0400
Received: by mail-ee0-f48.google.com with SMTP id l10so881858eei.21
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 05:29:43 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 3/4] ad9389b: fix compilation with GCC < 4.4.6
Date: Fri, 30 Aug 2013 14:29:24 +0200
Message-Id: <1377865765-25203-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
References: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/i2c/ad9389b.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index bb0c99d..b06a7e5 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -628,16 +628,13 @@ static int ad9389b_s_stream(struct v4l2_subdev *sd, int enable)
 
 static const struct v4l2_dv_timings_cap ad9389b_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = 1920,
-		.max_height = 1200,
-		.min_pixelclock = 25000000,
-		.max_pixelclock = 170000000,
-		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
-	},
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+		V4L2_DV_BT_CAP_CUSTOM)
 };
 
 static int ad9389b_s_dv_timings(struct v4l2_subdev *sd,
-- 
1.8.4

