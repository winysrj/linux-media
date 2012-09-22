Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2IVHcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 03:32:03 -0400
Received: by pbbrr4 with SMTP id rr4so4104427pbb.19
        for <linux-media@vger.kernel.org>; Sat, 22 Sep 2012 00:32:02 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5k6aa: Fix possible NULL pointer dereference
Date: Sat, 22 Sep 2012 12:58:27 +0530
Message-Id: <1348298907-20791-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is previously assumed that 'rect' could be NULL.
Hence add a check to print the members of 'rect' only when it is not
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5k6aa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 045ca7f..7531edb 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1177,8 +1177,9 @@ static int s5k6aa_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	mutex_unlock(&s5k6aa->lock);
 
-	v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
-		 rect->left, rect->top, rect->width, rect->height);
+	if (rect)
+		v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
+			 rect->left, rect->top, rect->width, rect->height);
 
 	return 0;
 }
-- 
1.7.4.1

