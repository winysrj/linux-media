Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab0IXOOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:41 -0400
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
Subject: [PATCH 08/16] sh_vou: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:06 +0200
Message-Id: <1285337654-5044-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, remove the module names hardcoded in platform data
and pass a NULL module name to those functions.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the sh_vou
platform data uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/sh/boards/mach-ecovec24/setup.c |    1 -
 arch/sh/boards/mach-se/7724/setup.c  |    1 -
 drivers/media/video/sh_vou.c         |    2 +-
 include/media/sh_vou.h               |    1 -
 4 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 1d7b495..4a9fa5d 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -793,7 +793,6 @@ static struct sh_vou_pdata sh_vou_pdata = {
 	.flags		= SH_VOU_HSYNC_LOW | SH_VOU_VSYNC_LOW,
 	.board_info	= &ak8813,
 	.i2c_adap	= 0,
-	.module_name	= "ak881x",
 };
 
 static struct resource sh_vou_resources[] = {
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 552ebd9..8cc1d72 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -550,7 +550,6 @@ static struct sh_vou_pdata sh_vou_pdata = {
 	.flags		= SH_VOU_HSYNC_LOW | SH_VOU_VSYNC_LOW,
 	.board_info	= &ak8813,
 	.i2c_adap	= 0,
-	.module_name	= "ak881x",
 };
 
 static struct resource sh_vou_resources[] = {
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index d394187..6e35eaa 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -1405,7 +1405,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 		goto ereset;
 
 	subdev = v4l2_i2c_new_subdev_board(&vou_dev->v4l2_dev, i2c_adap,
-			vou_pdata->module_name, vou_pdata->board_info, NULL);
+			NULL, vou_pdata->board_info, NULL);
 	if (!subdev) {
 		ret = -ENOMEM;
 		goto ei2cnd;
diff --git a/include/media/sh_vou.h b/include/media/sh_vou.h
index a3ef302..ec3ba9a 100644
--- a/include/media/sh_vou.h
+++ b/include/media/sh_vou.h
@@ -28,7 +28,6 @@ struct sh_vou_pdata {
 	int i2c_adap;
 	struct i2c_board_info *board_info;
 	unsigned long flags;
-	char *module_name;
 };
 
 #endif
-- 
1.7.2.2

