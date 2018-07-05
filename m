Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:35101 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753814AbeGEOlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 10:41:46 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>
Subject: [PATCH] media: smiapp: fix debug message
Date: Thu,  5 Jul 2018 16:41:11 +0200
Message-Id: <1530801671-30757-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ask_h gets printed here instead of ask_w.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e9e0f21efc2a..1234958acf0b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1892,7 +1892,7 @@ static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
 		val -= SCALING_GOODNESS_EXTREME;
 
 	dev_dbg(&client->dev, "w %d ask_w %d h %d ask_h %d goodness %d\n",
-		w, ask_h, h, ask_h, val);
+		w, ask_w, h, ask_h, val);
 
 	return val;
 }
-- 
2.7.4
