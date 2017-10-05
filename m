Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([216.205.24.107]:21281 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751330AbdJEOzj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 10:55:39 -0400
Subject: [PATCH v7 3/3] media: rc: Add tango keymap
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
To: Sean Young <sean@mess.org>
CC: linux-media <linux-media@vger.kernel.org>,
        Mans Rullgard <mans@mansr.com>, Mason <slash.tmp@free.fr>
References: <a98feda2-fd9e-004b-a139-789193ca4995@sigmadesigns.com>
Message-ID: <13b59e8a-d276-d19a-7f07-70a2423526ab@sigmadesigns.com>
Date: Thu, 5 Oct 2017 16:54:11 +0200
MIME-Version: 1.0
In-Reply-To: <a98feda2-fd9e-004b-a139-789193ca4995@sigmadesigns.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a keymap for the Sigma Designs Vantage (dev board) remote control.

Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
---
 drivers/media/rc/keymaps/Makefile   |  1 +
 drivers/media/rc/keymaps/rc-tango.c | 84 +++++++++++++++++++++++++++++++++++++
 drivers/media/rc/tango-ir.c         |  2 +-
 include/media/rc-map.h              |  1 +
 4 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/rc/keymaps/rc-tango.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index af6496d709fb..3c1e31321e21 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-reddo.o \
 			rc-snapstream-firefly.o \
 			rc-streamzap.o \
+			rc-tango.o \
 			rc-tbs-nec.o \
 			rc-technisat-ts35.o \
 			rc-technisat-usb2.o \
diff --git a/drivers/media/rc/keymaps/rc-tango.c b/drivers/media/rc/keymaps/rc-tango.c
new file mode 100644
index 000000000000..c76651695959
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-tango.c
@@ -0,0 +1,84 @@
+#include <linux/module.h>
+#include <media/rc-map.h>
+
+static struct rc_map_table tango_table[] = {
+	{ 0x4cb4a, KEY_POWER },
+	{ 0x4cb48, KEY_FILE },
+	{ 0x4cb0f, KEY_SETUP },
+	{ 0x4cb4d, KEY_SUSPEND },
+	{ 0x4cb4e, KEY_VOLUMEUP },
+	{ 0x4cb44, KEY_EJECTCD },
+	{ 0x4cb13, KEY_TV },
+	{ 0x4cb51, KEY_MUTE },
+	{ 0x4cb52, KEY_VOLUMEDOWN },
+
+	{ 0x4cb41, KEY_1 },
+	{ 0x4cb03, KEY_2 },
+	{ 0x4cb42, KEY_3 },
+	{ 0x4cb45, KEY_4 },
+	{ 0x4cb07, KEY_5 },
+	{ 0x4cb46, KEY_6 },
+	{ 0x4cb55, KEY_7 },
+	{ 0x4cb17, KEY_8 },
+	{ 0x4cb56, KEY_9 },
+	{ 0x4cb1b, KEY_0 },
+	{ 0x4cb59, KEY_DELETE },
+	{ 0x4cb5a, KEY_CAPSLOCK },
+
+	{ 0x4cb47, KEY_BACK },
+	{ 0x4cb05, KEY_SWITCHVIDEOMODE },
+	{ 0x4cb06, KEY_UP },
+	{ 0x4cb43, KEY_LEFT },
+	{ 0x4cb01, KEY_RIGHT },
+	{ 0x4cb0a, KEY_DOWN },
+	{ 0x4cb02, KEY_ENTER },
+	{ 0x4cb4b, KEY_INFO },
+	{ 0x4cb09, KEY_HOME },
+
+	{ 0x4cb53, KEY_MENU },
+	{ 0x4cb12, KEY_PREVIOUS },
+	{ 0x4cb50, KEY_PLAY },
+	{ 0x4cb11, KEY_NEXT },
+	{ 0x4cb4f, KEY_TITLE },
+	{ 0x4cb0e, KEY_REWIND },
+	{ 0x4cb4c, KEY_STOP },
+	{ 0x4cb0d, KEY_FORWARD },
+	{ 0x4cb57, KEY_MEDIA_REPEAT },
+	{ 0x4cb16, KEY_ANGLE },
+	{ 0x4cb54, KEY_PAUSE },
+	{ 0x4cb15, KEY_SLOW },
+	{ 0x4cb5b, KEY_TIME },
+	{ 0x4cb1a, KEY_AUDIO },
+	{ 0x4cb58, KEY_SUBTITLE },
+	{ 0x4cb19, KEY_ZOOM },
+
+	{ 0x4cb5f, KEY_RED },
+	{ 0x4cb1e, KEY_GREEN },
+	{ 0x4cb5c, KEY_YELLOW },
+	{ 0x4cb1d, KEY_BLUE },
+};
+
+static struct rc_map_list tango_map = {
+	.map = {
+		.scan = tango_table,
+		.size = ARRAY_SIZE(tango_table),
+		.rc_proto = RC_PROTO_NEC,
+		.name = RC_MAP_TANGO,
+	}
+};
+
+static int __init init_rc_map_tango(void)
+{
+	return rc_map_register(&tango_map);
+}
+
+static void __exit exit_rc_map_tango(void)
+{
+	rc_map_unregister(&tango_map);
+}
+
+module_init(init_rc_map_tango)
+module_exit(exit_rc_map_tango)
+
+MODULE_AUTHOR("Sigma Designs");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/tango-ir.c b/drivers/media/rc/tango-ir.c
index 1bd4e3412a29..d5a1eb6fa855 100644
--- a/drivers/media/rc/tango-ir.c
+++ b/drivers/media/rc/tango-ir.c
@@ -155,7 +155,7 @@ static int tango_change_protocol(struct rc_dev *dev, u64 *rc_type)
 
 static int tango_ir_probe(struct platform_device *pdev)
 {
-	const char *map_name = RC_MAP_EMPTY;
+	const char *map_name = RC_MAP_TANGO;
 	struct device *dev = &pdev->dev;
 	struct rc_dev *rc;
 	struct tango_ir *ir;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 2a160e6e823c..1d8e6bdb9b35 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -323,6 +323,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
 #define RC_MAP_SU3000                    "rc-su3000"
 #define RC_MAP_ZX_IRDEC                  "rc-zx-irdec"
+#define RC_MAP_TANGO                     "rc-tango"
 
 /*
  * Please, do not just append newer Remote Controller names at the end.
-- 
2.14.2
