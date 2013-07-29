Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4695 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3G2MlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/8] v4l2-dv-timings.h: remove duplicate V4L2_DV_BT_DMT_1366X768P60
Date: Mon, 29 Jul 2013 14:40:54 +0200
Message-Id: <1375101661-6493-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This particular DMT timing definition was duplicated in the header.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-dv-timings.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 4e0c58d..be709fe 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -823,12 +823,4 @@
 		V4L2_DV_FL_REDUCED_BLANKING) \
 }
 
-#define V4L2_DV_BT_DMT_1366X768P60 { \
-	.type = V4L2_DV_BT_656_1120, \
-	V4L2_INIT_BT_TIMINGS(1366, 768, 0, \
-		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
-		85500000, 70, 143, 213, 3, 3, 24, 0, 0, 0, \
-		V4L2_DV_BT_STD_DMT, 0) \
-}
-
 #endif
-- 
1.8.3.2

