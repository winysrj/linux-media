Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:7279 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbFLLsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 07:48:13 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-dv-timings: print refresh rate with better precision
Date: Fri, 12 Jun 2015 17:18:10 +0530
Message-Id: <1434109690-27479-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In many cases, refresh rate is not exact integer. In such cases,
fraction was lost and it used to print, say, 59 in case of 59.94.
Now, capturing the fraction up to 2 decimal places.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 1e08eee..21f3480 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -256,6 +256,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 {
 	const struct v4l2_bt_timings *bt = &t->bt;
 	u32 htot, vtot;
+	u32 fps;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return;
@@ -265,13 +266,15 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 	if (bt->interlaced)
 		vtot /= 2;
 
+	fps = (htot * vtot) > 0 ? div_u64((100 * (u64)bt->pixelclock),
+				  (htot * vtot)) : 0;
+
 	if (prefix == NULL)
 		prefix = "";
 
-	pr_info("%s: %s%ux%u%s%u (%ux%u)\n", dev_prefix, prefix,
+	pr_info("%s: %s%ux%u%s%u.%u (%ux%u)\n", dev_prefix, prefix,
 		bt->width, bt->height, bt->interlaced ? "i" : "p",
-		(htot * vtot) > 0 ? ((u32)bt->pixelclock / (htot * vtot)) : 0,
-		htot, vtot);
+		fps / 100, fps % 100, htot, vtot);
 
 	if (!detailed)
 		return;
-- 
1.9.1

