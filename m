Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54684 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1FKRrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH 3/8] marvell-cam: Pass sensor parameters from the platform
Date: Sat, 11 Jun 2011 11:46:44 -0600
Message-Id: <1307814409-46282-4-git-send-email-corbet@lwn.net>
In-Reply-To: <1307814409-46282-1-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Depending on the controller, the ov7670 sensor may be told to work with a
different clock speed or to use the SMBUS protocol.  Remove the wired-in
code and pass that information from the platform layer.  The Cafe driver
now just assumes it's running on an OLPC XO 1; I do not believe it has ever
run anywhere else.

Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |    6 ++++++
 drivers/media/video/marvell-ccic/mcam-core.c   |   22 ++--------------------
 drivers/media/video/marvell-ccic/mcam-core.h   |    2 ++
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index 3f38f2a..08edf95 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -404,6 +404,12 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	mcam->plat_power_down = cafe_ctlr_power_down;
 	mcam->dev = &pdev->dev;
 	/*
+	 * Set the clock speed for the XO 1; I don't believe this
+	 * driver has ever run anywhere else.
+	 */
+	mcam->clock_speed = 45;
+	mcam->use_smbus = 1;
+	/*
 	 * Get set up on the PCI bus.
 	 */
 	ret = pci_enable_device(pdev);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 18fce9e..0d60234 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/dmi.h>
 #include <linux/mm.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
@@ -1536,22 +1535,7 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
  * Registration and such.
  */
 
-/* FIXME this is really platform stuff */
-static const struct dmi_system_id olpc_xo1_dmi[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
-		},
-	},
-	{ }
-};
-
 static struct ov7670_config sensor_cfg = {
-	/* This controller only does SMBUS */
-	.use_smbus = true,
-
 	/*
 	 * Exclude QCIF mode, because it only captures a tiny portion
 	 * of the sensor FOV
@@ -1590,13 +1574,11 @@ int mccic_register(struct mcam_camera *cam)
 
 	mcam_ctlr_init(cam);
 
-	/* Apply XO-1 clock speed */
-	if (dmi_check_system(olpc_xo1_dmi))
-		sensor_cfg.clock_speed = 45;
-
 	/*
 	 * Try to find the sensor.
 	 */
+	sensor_cfg.clock_speed = cam->clock_speed;
+	sensor_cfg.use_smbus = cam->use_smbus;
 	cam->sensor_addr = ov7670_info.addr;
 	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
 			&cam->i2c_adapter, &ov7670_info, NULL);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 0b55b8e..21485e7 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -42,6 +42,8 @@ struct mcam_camera {
 	spinlock_t dev_lock;
 	struct device *dev; /* For messages, dma alloc */
 	unsigned int chip_id;
+	short int clock_speed;	/* Sensor clock speed, default 30 */
+	short int use_smbus;	/* SMBUS or straight I2c? */
 
 	/*
 	 * Callbacks from the core to the platform code.
-- 
1.7.5.4

