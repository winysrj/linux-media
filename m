Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57732 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbbLNJ6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 04:58:33 -0500
Date: Mon, 14 Dec 2015 10:58:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] mt9t001: fix clean up in case of power-on failures
Message-ID: <Pine.LNX.4.64.1512141049310.11891@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver fails to reset the camera or to set up control handlers, it
has to power the camera back off.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/mt9t001.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 8ae99f7..f262cf2 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -233,10 +233,21 @@ static int __mt9t001_set_power(struct mt9t001 *mt9t001, bool on)
 	ret = mt9t001_reset(mt9t001);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to reset the camera\n");
-		return ret;
+		goto e_power;
 	}
 
-	return v4l2_ctrl_handler_setup(&mt9t001->ctrls);
+	ret = v4l2_ctrl_handler_setup(&mt9t001->ctrls);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to set up control handlers\n");
+		goto e_power;
+	}
+
+	return 0;
+
+e_power:
+	mt9t001_power_off(mt9t001);
+
+	return ret;
 }
 
 /* -----------------------------------------------------------------------------
-- 
1.9.3

