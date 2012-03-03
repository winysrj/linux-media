Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2CCP2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 04/10] mt9m032: Use module_i2c_driver() macro
Date: Sat,  3 Mar 2012 16:28:09 +0100
Message-Id: <1330788495-18762-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the custom driver init and exit functions by
module_i2c_driver().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index e09f9a5..a821b91 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -806,24 +806,7 @@ static struct i2c_driver mt9m032_i2c_driver = {
 	.id_table = mt9m032_id_table,
 };
 
-static int __init mt9m032_init(void)
-{
-	int rval;
-
-	rval = i2c_add_driver(&mt9m032_i2c_driver);
-	if (rval)
-		pr_err("%s: failed registering " MT9M032_NAME "\n", __func__);
-
-	return rval;
-}
-
-static void mt9m032_exit(void)
-{
-	i2c_del_driver(&mt9m032_i2c_driver);
-}
-
-module_init(mt9m032_init);
-module_exit(mt9m032_exit);
+module_i2c_driver(mt9m032_i2c_driver);
 
 MODULE_AUTHOR("Martin Hostettler <martin@neutronstar.dyndns.org>");
 MODULE_DESCRIPTION("MT9M032 camera sensor driver");
-- 
1.7.3.4

