Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:37674 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759139Ab2CVSxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 14:53:42 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 2/2] [resend] radio-gemtek: add PnP support for AOpen FX-3D/Pro Radio
Cc: linux-media@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 22 Mar 2012 19:53:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203221953.31823.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PnP support to radio-gemtek for AOpen FX-3D/Pro Radio card
(AD1816 + Gemtek radio).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 9d7fdae..235c0e3 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -29,6 +29,8 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/pnp.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include "radio-isa.h"
@@ -282,6 +284,16 @@ static const struct radio_isa_ops gemtek_ops = {
 
 static const int gemtek_ioports[] = { 0x20c, 0x30c, 0x24c, 0x34c, 0x248, 0x28c };
 
+#ifdef CONFIG_PNP
+static struct pnp_device_id gemtek_pnp_devices[] = {
+	/* AOpen FX-3D/Pro Radio */
+	{.id = "ADS7183", .driver_data = 0},
+	{.id = ""}
+};
+
+MODULE_DEVICE_TABLE(pnp, gemtek_pnp_devices);
+#endif
+
 static struct radio_isa_driver gemtek_driver = {
 	.driver = {
 		.match		= radio_isa_match,
@@ -291,6 +303,14 @@ static struct radio_isa_driver gemtek_driver = {
 			.name	= "radio-gemtek",
 		},
 	},
+#ifdef CONFIG_PNP
+	.pnp_driver = {
+		.name		= "radio-gemtek",
+		.id_table	= gemtek_pnp_devices,
+		.probe		= radio_isa_pnp_probe,
+		.remove		= radio_isa_pnp_remove,
+	},
+#endif
 	.io_params = io,
 	.radio_nr_params = radio_nr,
 	.io_ports = gemtek_ioports,
@@ -304,12 +324,18 @@ static struct radio_isa_driver gemtek_driver = {
 static int __init gemtek_init(void)
 {
 	gemtek_driver.probe = probe;
+#ifdef CONFIG_PNP
+	pnp_register_driver(&gemtek_driver.pnp_driver);
+#endif
 	return isa_register_driver(&gemtek_driver.driver, GEMTEK_MAX);
 }
 
 static void __exit gemtek_exit(void)
 {
 	hardmute = 1;	/* Turn off PLL */
+#ifdef CONFIG_PNP
+	pnp_unregister_driver(&gemtek_driver.pnp_driver);
+#endif
 	isa_unregister_driver(&gemtek_driver.driver);
 }
 


-- 
Ondrej Zary
