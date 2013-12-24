Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59653 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LXLpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 06:45:32 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so6416853pbc.39
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 03:45:32 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org
Subject: [PATCH 2/3] [media] s5k5baf: Fix checkpatch error
Date: Tue, 24 Dec 2013 17:12:04 +0530
Message-Id: <1387885325-17639-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
References: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following error:
ERROR: return is not a function, parentheses are not required
FILE: drivers/media/i2c/s5k5baf.c:1353:

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5k5baf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 139bdd4f5dde..974b865c2ee1 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1350,8 +1350,8 @@ static enum selection_rect s5k5baf_get_sel_rect(u32 pad, u32 target)
 
 static int s5k5baf_is_bound_target(u32 target)
 {
-	return (target == V4L2_SEL_TGT_CROP_BOUNDS ||
-		target == V4L2_SEL_TGT_COMPOSE_BOUNDS);
+	return target == V4L2_SEL_TGT_CROP_BOUNDS ||
+		target == V4L2_SEL_TGT_COMPOSE_BOUNDS;
 }
 
 static int s5k5baf_get_selection(struct v4l2_subdev *sd,
-- 
1.7.9.5

