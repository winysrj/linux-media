Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35659 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbCHNqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 09:46:51 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 5F5852000F
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 14:45:51 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: mt9v032: Consider control initialization errors as fatal
Date: Sun,  8 Mar 2015 15:46:50 +0200
Message-Id: <1425822410-19284-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device requires control to be properly operated, they're not
optional.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index a6ea091..1ca82d4 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1013,9 +1013,12 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mt9v032->subdev.ctrl_handler = &mt9v032->ctrls;
 
-	if (mt9v032->ctrls.error)
-		printk(KERN_INFO "%s: control initialization error %d\n",
-		       __func__, mt9v032->ctrls.error);
+	if (mt9v032->ctrls.error) {
+		dev_err(&client->dev, "control initialization error %d\n",
+			mt9v032->ctrls.error);
+		ret = mt9v032->ctrls.error;
+		goto err;
+	}
 
 	mt9v032->crop.left = MT9V032_COLUMN_START_DEF;
 	mt9v032->crop.top = MT9V032_ROW_START_DEF;
-- 
Regards,

Laurent Pinchart

