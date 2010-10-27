Return-path: <mchehab@pedra>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:46131 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab0J0TCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 15:02:35 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
Cc: linux-media@vger.kernel.org
Subject: [PATCH] via-camera: fix OLPC serial port check
Message-Id: <20101027190228.3C87D9D401B@zog.reactivated.net>
Date: Wed, 27 Oct 2010 20:02:28 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

CONFIG_OLPC_XO_1_5 does not exist in mainline, and it's not certain that
we'll find a reason to add it later.

We should also be detecting this at runtime, and if we do it at probe
time we can be sure not to mess around with the PCI config space on XO-1.

viafb already depends on X86 so there won't be any problems including
the olpc.h header directly.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |   82 ++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 02a21bc..118c26b 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -28,6 +28,8 @@
 #include <linux/via-gpio.h>
 #include <linux/via_i2c.h>
 
+#include <asm/olpc.h>
+
 #include "via-camera.h"
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
@@ -40,14 +42,12 @@ MODULE_PARM_DESC(flip_image,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
-#ifdef CONFIG_OLPC_XO_1_5
 static int override_serial;
 module_param(override_serial, bool, 0444);
 MODULE_PARM_DESC(override_serial,
 		"The camera driver will normally refuse to load if "
 		"the XO 1.5 serial port is enabled.  Set this option "
 		"to force the issue.");
-#endif
 
 /*
  * Basic window sizes.
@@ -1276,6 +1276,40 @@ static struct video_device viacam_v4l_template = {
 	.release	= video_device_release_empty, /* Check this */
 };
 
+/*
+ * The OLPC folks put the serial port on the same pin as
+ * the camera.	They also get grumpy if we break the
+ * serial port and keep them from using it.  So we have
+ * to check the serial enable bit and not step on it.
+ */
+#define VIACAM_SERIAL_DEVFN 0x88
+#define VIACAM_SERIAL_CREG 0x46
+#define VIACAM_SERIAL_BIT 0x40
+
+static __devinit int viacam_check_serial_port(void)
+{
+	struct pci_bus *pbus = pci_find_bus(0, 0);
+	u8 cbyte;
+
+	if (!machine_is_olpc())
+		return 0;
+
+	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
+			VIACAM_SERIAL_CREG, &cbyte);
+	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
+		return 0; /* Not enabled */
+	if (override_serial == 0) {
+		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
+				"refusing to load.\n");
+		printk(KERN_NOTICE "Specify override_serial=1 to force " \
+				"module loading.\n");
+		return -EBUSY;
+	}
+	printk(KERN_NOTICE "Via camera: overriding serial port\n");
+	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
+			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
+	return 0;
+}
 
 static __devinit int viacam_probe(struct platform_device *pdev)
 {
@@ -1291,6 +1325,9 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 	 */
 	struct via_camera *cam;
 
+	if (viacam_check_serial_port())
+		return -EBUSY;
+
 	/*
 	 * Ensure that frame buffer memory has been set aside for
 	 * this purpose.  As an arbitrary limit, refuse to work
@@ -1420,49 +1457,8 @@ static struct platform_driver viacam_driver = {
 };
 
 
-#ifdef CONFIG_OLPC_XO_1_5
-/*
- * The OLPC folks put the serial port on the same pin as
- * the camera.	They also get grumpy if we break the
- * serial port and keep them from using it.  So we have
- * to check the serial enable bit and not step on it.
- */
-#define VIACAM_SERIAL_DEVFN 0x88
-#define VIACAM_SERIAL_CREG 0x46
-#define VIACAM_SERIAL_BIT 0x40
-
-static __devinit int viacam_check_serial_port(void)
-{
-	struct pci_bus *pbus = pci_find_bus(0, 0);
-	u8 cbyte;
-
-	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
-			VIACAM_SERIAL_CREG, &cbyte);
-	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
-		return 0; /* Not enabled */
-	if (override_serial == 0) {
-		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
-				"refusing to load.\n");
-		printk(KERN_NOTICE "Specify override_serial=1 to force " \
-				"module loading.\n");
-		return -EBUSY;
-	}
-	printk(KERN_NOTICE "Via camera: overriding serial port\n");
-	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
-			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
-	return 0;
-}
-#endif
-
-
-
-
 static int viacam_init(void)
 {
-#ifdef CONFIG_OLPC_XO_1_5
-	if (viacam_check_serial_port())
-		return -EBUSY;
-#endif
 	return platform_driver_register(&viacam_driver);
 }
 module_init(viacam_init);
-- 
1.7.2.3

