Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:32805 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbeG1PVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 11:21:40 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab+samsung@kernel.org, jasmin@anw.at,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH] media: i2c: fix warning in Aptina MT9V111
Date: Sat, 28 Jul 2018 15:54:49 +0200
Message-Id: <1532786089-15015-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

This fixes the "'idx' may be used uninitialized in this function"
warning.

Cc:  Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/i2c/mt9v111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index da8f6ab..58d5f22 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -884,7 +884,7 @@ static int mt9v111_set_format(struct v4l2_subdev *subdev,
 	struct v4l2_mbus_framefmt new_fmt;
 	struct v4l2_mbus_framefmt *__fmt;
 	unsigned int best_fit = ~0L;
-	unsigned int idx;
+	unsigned int idx = 0;
 	unsigned int i;
 
 	mutex_lock(&mt9v111->stream_mutex);
-- 
2.7.4
