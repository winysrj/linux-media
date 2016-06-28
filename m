Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54121 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbcF1OQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 10:16:00 -0400
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 11E77181A05
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 16:14:20 +0200 (CEST)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-tpg: ignore V4L2_DV_RGB_RANGE setting for YUV formats
Message-ID: <5772863B.9010609@xs4all.nl>
Date: Tue, 28 Jun 2016 16:14:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_DV_RGB_RANGE_* settings are, as the name says, for RGB formats only.
So they should be ignored for non-RGB formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index cf1dadd..3ec3ceb 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -777,7 +777,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	 * Remember that r, g and b are still in the 0 - 0xff0 range.
 	 */
 	if (tpg->real_rgb_range == V4L2_DV_RGB_RANGE_LIMITED &&
-	    tpg->rgb_range == V4L2_DV_RGB_RANGE_FULL) {
+	    tpg->rgb_range == V4L2_DV_RGB_RANGE_FULL && !tpg->is_yuv) {
 		/*
 		 * Convert from full range (which is what r, g and b are)
 		 * to limited range (which is the 'real' RGB range), which
@@ -787,7 +787,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g = (g * 219) / 255 + (16 << 4);
 		b = (b * 219) / 255 + (16 << 4);
 	} else if (tpg->real_rgb_range != V4L2_DV_RGB_RANGE_LIMITED &&
-		   tpg->rgb_range == V4L2_DV_RGB_RANGE_LIMITED) {
+		   tpg->rgb_range == V4L2_DV_RGB_RANGE_LIMITED && !tpg->is_yuv) {
 		/*
 		 * Clamp r, g and b to the limited range and convert to full
 		 * range since that's what we deliver.
