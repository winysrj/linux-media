Return-path: <mchehab@pedra>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:10662 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757786Ab0JSVYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 17:24:42 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] cafe_ccic: Configure ov7670 correctly
Message-Id: <20101019212439.15C339D401B@zog.reactivated.net>
Date: Tue, 19 Oct 2010 22:24:38 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Force smbus communication, disable QCIF mode, and set the correct
clock speed on the OLPC XO-1.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/cafe_ccic.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index b4f5b3b..4378597 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/dmi.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/i2c.h>
@@ -46,6 +47,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include "ov7670.h"
 #include "cafe_ccic-regs.h"
 
 #define CAFE_VERSION 0x000002
@@ -1974,11 +1976,33 @@ static irqreturn_t cafe_irq(int irq, void *data)
  * PCI interface stuff.
  */
 
+static const struct dmi_system_id olpc_xo1_dmi[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
+		},
+	},
+	{ }
+};
+
 static int cafe_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	int ret;
 	struct cafe_camera *cam;
+	struct ov7670_config sensor_cfg = {
+		/* This controller only does SMBUS */
+		.use_smbus = true,
+
+		/*
+		 * Exclude QCIF mode, because it only captures a tiny portion
+		 * of the sensor FOV
+		 */
+		.min_width = 320,
+		.min_height = 240,
+	};
 
 	/*
 	 * Start putting together one of our big camera structures.
@@ -2036,13 +2060,18 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto out_freeirq;
 
+	/* Apply XO-1 clock speed */
+	if (dmi_check_system(olpc_xo1_dmi))
+		sensor_cfg.clock_speed = 45;
+
 	cam->sensor_addr = 0x42;
-	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, &cam->i2c_adapter,
-			"ov7670", "ov7670", cam->sensor_addr, NULL);
+	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
+		"ov7670", "ov7670", 0, &sensor_cfg, cam->sensor_addr, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
 	}
+
 	ret = cafe_cam_init(cam);
 	if (ret)
 		goto out_smbus;
-- 
1.7.2.3

