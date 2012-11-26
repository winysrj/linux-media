Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2KZEzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:43 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:42 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/9] [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
Date: Mon, 26 Nov 2012 10:19:02 +0530
Message-Id: <1353905348-15475-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences checkpatch warnings of the type:
WARNING: sizeof filter_y_horiz_tap8 should be sizeof(filter_y_horiz_tap8)
FILE: media/platform/s5p-tv/mixer_reg.c:473:
		filter_y_horiz_tap8, sizeof filter_y_horiz_tap8);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_reg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index 3b1670a..b713403 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -470,11 +470,11 @@ static inline void mxr_reg_vp_filter_set(struct mxr_device *mdev,
 static void mxr_reg_vp_default_filter(struct mxr_device *mdev)
 {
 	mxr_reg_vp_filter_set(mdev, VP_POLY8_Y0_LL,
-		filter_y_horiz_tap8, sizeof filter_y_horiz_tap8);
+		filter_y_horiz_tap8, sizeof(filter_y_horiz_tap8));
 	mxr_reg_vp_filter_set(mdev, VP_POLY4_Y0_LL,
-		filter_y_vert_tap4, sizeof filter_y_vert_tap4);
+		filter_y_vert_tap4, sizeof(filter_y_vert_tap4));
 	mxr_reg_vp_filter_set(mdev, VP_POLY4_C0_LL,
-		filter_cr_horiz_tap4, sizeof filter_cr_horiz_tap4);
+		filter_cr_horiz_tap4, sizeof(filter_cr_horiz_tap4));
 }
 
 static void mxr_reg_mxr_dump(struct mxr_device *mdev)
-- 
1.7.4.1

