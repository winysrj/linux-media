Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38134 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3H3M3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:29:46 -0400
Received: by mail-ee0-f54.google.com with SMTP id e53so877932eek.41
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 05:29:45 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 4/4] ths8200: fix compilation with GCC < 4.4.6
Date: Fri, 30 Aug 2013 14:29:25 +0200
Message-Id: <1377865765-25203-5-git-send-email-gennarone@gmail.com>
In-Reply-To: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
References: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/i2c/ths8200.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index a58a8f6..d9f65d7 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -46,14 +46,10 @@ struct ths8200_state {
 
 static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = 1920,
-		.max_height = 1080,
-		.min_pixelclock = 25000000,
-		.max_pixelclock = 148500000,
-		.standards = V4L2_DV_BT_STD_CEA861,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
-	},
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1080, 25000000, 148500000,
+		V4L2_DV_BT_STD_CEA861, V4L2_DV_BT_CAP_PROGRESSIVE)
 };
 
 static inline struct ths8200_state *to_state(struct v4l2_subdev *sd)
-- 
1.8.4

