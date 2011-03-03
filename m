Return-path: <mchehab@pedra>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:58516 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758263Ab1CCV34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2011 16:29:56 -0500
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Cc: dilinger@queued.net
Subject: [PATCH] via-camera: Fix OLPC serial check
Message-Id: <20110303190331.E8ED79D401D@zog.reactivated.net>
Date: Thu,  3 Mar 2011 19:03:31 +0000 (GMT)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The code that checks the OLPC serial port is never built at the moment,
because CONFIG_OLPC_XO_1_5 doesn't exist and probably won't be added.

Fix it so that it gets compiled in, only executes on OLPC laptops, and
move the check into the probe routine.

The compiler is smart enough to eliminate this code when CONFIG_OLPC=n
(due to machine_is_olpc() always returning false).

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |   83 +++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 2f973cd..4f19edc 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -25,6 +25,7 @@
 #include <linux/via-core.h>
 #include <linux/via-gpio.h>
 #include <linux/via_i2c.h>
+#include <asm/olpc.h>
 
 #include "via-camera.h"
 
@@ -38,14 +39,12 @@ MODULE_PARM_DESC(flip_image,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
-#ifdef CONFIG_OLPC_XO_1_5
 static int override_serial;
 module_param(override_serial, bool, 0444);
 MODULE_PARM_DESC(override_serial,
 		"The camera driver will normally refuse to load if "
 		"the XO 1.5 serial port is enabled.  Set this option "
-		"to force the issue.");
-#endif
+		"to force-enable the camera.");
 
 /*
  * Basic window sizes.
@@ -1261,6 +1260,37 @@ static struct video_device viacam_v4l_template = {
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
+static __devinit bool viacam_serial_is_enabled(void)
+{
+	struct pci_bus *pbus = pci_find_bus(0, 0);
+	u8 cbyte;
+
+	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
+			VIACAM_SERIAL_CREG, &cbyte);
+	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
+		return false; /* Not enabled */
+	if (override_serial == 0) {
+		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
+				"refusing to load.\n");
+		printk(KERN_NOTICE "Specify override_serial=1 to force " \
+				"module loading.\n");
+		return true;
+	}
+	printk(KERN_NOTICE "Via camera: overriding serial port\n");
+	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
+			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
+	return false;
+}
 
 static __devinit int viacam_probe(struct platform_device *pdev)
 {
@@ -1292,6 +1322,10 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 		printk(KERN_ERR "viacam: No I/O memory, so no pictures\n");
 		return -ENOMEM;
 	}
+
+	if (machine_is_olpc() && viacam_serial_is_enabled())
+		return -EBUSY;
+
 	/*
 	 * Basic structure initialization.
 	 */
@@ -1395,7 +1429,6 @@ static __devexit int viacam_remove(struct platform_device *pdev)
 	return 0;
 }
 
-
 static struct platform_driver viacam_driver = {
 	.driver = {
 		.name = "viafb-camera",
@@ -1404,50 +1437,8 @@ static struct platform_driver viacam_driver = {
 	.remove = viacam_remove,
 };
 
-
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
1.7.4

