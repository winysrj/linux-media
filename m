Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53009 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753163AbaKHXJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:09:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 05/10] smiapp: The sensor only needs a single clock, name may be NULL
Date: Sun,  9 Nov 2014 01:09:26 +0200
Message-Id: <1415488171-27636-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
References: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SMIA compatible sensors only need a single clock.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7c79e72..c2c9a1f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2483,7 +2483,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	}
 
 	if (!sensor->platform_data->set_xclk) {
-		sensor->ext_clk = devm_clk_get(&client->dev, "ext_clk");
+		sensor->ext_clk = devm_clk_get(&client->dev, NULL);
 		if (IS_ERR(sensor->ext_clk)) {
 			dev_err(&client->dev, "could not get clock\n");
 			return PTR_ERR(sensor->ext_clk);
-- 
1.7.10.4

