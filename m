Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0IXOOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 05/16] go7007: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:03 +0200
Message-Id: <1285337654-5044-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the go7007
driver uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/go7007/go7007-driver.c |   43 ++-----------------------------
 1 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 372a7c6..0a1d925 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -194,51 +194,15 @@ int go7007_reset_encoder(struct go7007 *go)
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
 static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
-			   int id, int addr)
+			   int addr)
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
-	char *modname;
 
-	switch (id) {
-	case I2C_DRIVERID_WIS_SAA7115:
-		modname = "wis-saa7115";
-		break;
-	case I2C_DRIVERID_WIS_SAA7113:
-		modname = "wis-saa7113";
-		break;
-	case I2C_DRIVERID_WIS_UDA1342:
-		modname = "wis-uda1342";
-		break;
-	case I2C_DRIVERID_WIS_SONY_TUNER:
-		modname = "wis-sony-tuner";
-		break;
-	case I2C_DRIVERID_WIS_TW9903:
-		modname = "wis-tw9903";
-		break;
-	case I2C_DRIVERID_WIS_TW2804:
-		modname = "wis-tw2804";
-		break;
-	case I2C_DRIVERID_WIS_OV7640:
-		modname = "wis-ov7640";
-		break;
-	case I2C_DRIVERID_S2250:
-		modname = "s2250";
-		break;
-	default:
-		modname = NULL;
-		break;
-	}
-
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, modname, type, addr, NULL))
+	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, NULL, type, addr, NULL))
 		return 0;
 
-	if (modname != NULL)
-		printk(KERN_INFO
-			"go7007: probing for module %s failed\n", modname);
-	else
-		printk(KERN_INFO
-			"go7007: sensor %u seems to be unsupported!\n", id);
+	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
 	return -1;
 }
 
@@ -277,7 +241,6 @@ int go7007_register_encoder(struct go7007 *go)
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
 			init_i2c_module(&go->i2c_adapter,
 					go->board_info->i2c_devs[i].type,
-					go->board_info->i2c_devs[i].id,
 					go->board_info->i2c_devs[i].addr);
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
 			i2c_clients_command(&go->i2c_adapter,
-- 
1.7.2.2

