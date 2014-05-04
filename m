Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54428 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753461AbaEDA31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 May 2014 20:29:27 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9280360095
	for <linux-media@vger.kernel.org>; Sun,  4 May 2014 03:29:24 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] smiapp: Use better regulator name for the Device tree
Date: Sun,  4 May 2014 03:31:55 +0300
Message-Id: <1399163517-5220-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename "VANA" regulator as "vana".

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8741cae..c1d6d1d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2355,7 +2355,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	unsigned int i;
 	int rval;
 
-	sensor->vana = devm_regulator_get(&client->dev, "VANA");
+	sensor->vana = devm_regulator_get(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
 		return -ENODEV;
-- 
1.7.10.4

