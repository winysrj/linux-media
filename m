Return-path: <linux-media-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:52740 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbcETPIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2016 11:08:37 -0400
Date: Fri, 20 May 2016 16:08:35 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Convert Wideview WT220 DVB USB driver to rc-core
Message-ID: <20160520150835.GE15983@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(I don't know if this sort of patch is welcome, but if it is I have a
couple of other USB DVB sticks I will convert over as well. My main
motivation was to be able to easily use a better remote than the mini
one that comes with these devices.)

This patch converts the dtt200u DVB USB driver over to the rc-core
infrastructure for its handling of IR remotes. This device can receive
generic NEC / NEC Extended signals and the switch to the newer core
enables the easy use of tools such as ir-keytable to modify the active
key map.

Signed-off-by: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index fbbd3bb..3bc5714 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
+			rc-dtt200u.o \
 			rc-dvbsky.o \
 			rc-em-terratec.o \
 			rc-encore-enltv2.o \
diff --git a/drivers/media/rc/keymaps/rc-dtt200u.c b/drivers/media/rc/keymaps/rc-dtt200u.c
new file mode 100644
index 0000000..25650e9
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dtt200u.c
@@ -0,0 +1,59 @@
+/* Keytable for Wideview WT-220U.
+ *
+ * Copyright (c) 2016 Jonathan McDowell <noodles@earth.li>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+/* key list for the tiny remote control (Yakumo, don't know about the others) */
+static struct rc_map_table dtt200u_table[] = {
+	{ 0x8001, KEY_MUTE },
+	{ 0x8002, KEY_CHANNELDOWN },
+	{ 0x8003, KEY_VOLUMEDOWN },
+	{ 0x8004, KEY_1 },
+	{ 0x8005, KEY_2 },
+	{ 0x8006, KEY_3 },
+	{ 0x8007, KEY_4 },
+	{ 0x8008, KEY_5 },
+	{ 0x8009, KEY_6 },
+	{ 0x800a, KEY_7 },
+	{ 0x800c, KEY_ZOOM },
+	{ 0x800d, KEY_0 },
+	{ 0x800e, KEY_SELECT },
+	{ 0x8012, KEY_POWER },
+	{ 0x801a, KEY_CHANNELUP },
+	{ 0x801b, KEY_8 },
+	{ 0x801e, KEY_VOLUMEUP },
+	{ 0x801f, KEY_9 },
+};
+
+static struct rc_map_list dtt200u_map = {
+	.map = {
+		.scan    = dtt200u_table,
+		.size    = ARRAY_SIZE(dtt200u_table),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_DTT200U,
+	}
+};
+
+static int __init init_rc_map_dtt200u(void)
+{
+	return rc_map_register(&dtt200u_map);
+}
+
+static void __exit exit_rc_map_dtt200u(void)
+{
+	rc_map_unregister(&dtt200u_map);
+}
+
+module_init(init_rc_map_dtt200u)
+module_exit(exit_rc_map_dtt200u)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index ca3b69a..be633ec 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -55,36 +55,36 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	return dvb_usb_generic_write(adap->dev, b_pid, 4);
 }
 
-/* remote control */
-/* key list for the tiny remote control (Yakumo, don't know about the others) */
-static struct rc_map_table rc_map_dtt200u_table[] = {
-	{ 0x8001, KEY_MUTE },
-	{ 0x8002, KEY_CHANNELDOWN },
-	{ 0x8003, KEY_VOLUMEDOWN },
-	{ 0x8004, KEY_1 },
-	{ 0x8005, KEY_2 },
-	{ 0x8006, KEY_3 },
-	{ 0x8007, KEY_4 },
-	{ 0x8008, KEY_5 },
-	{ 0x8009, KEY_6 },
-	{ 0x800a, KEY_7 },
-	{ 0x800c, KEY_ZOOM },
-	{ 0x800d, KEY_0 },
-	{ 0x800e, KEY_SELECT },
-	{ 0x8012, KEY_POWER },
-	{ 0x801a, KEY_CHANNELUP },
-	{ 0x801b, KEY_8 },
-	{ 0x801e, KEY_VOLUMEUP },
-	{ 0x801f, KEY_9 },
-};
-
-static int dtt200u_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static int dtt200u_rc_query(struct dvb_usb_device *d)
 {
 	u8 key[5],cmd = GET_RC_CODE;
+	u32 scancode;
+
 	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
-	dvb_usb_nec_rc_key_to_event(d,key,event,state);
+	if (key[0] == 1) {
+		scancode = key[1];
+		if ((u8) ~key[1] != key[2]) {
+			/* Extended NEC */
+			scancode = scancode << 8;
+			scancode |= key[2];
+		}
+		scancode = scancode << 8;
+		scancode |= key[3];
+
+		/* Check command checksum is ok */
+		if ((u8) ~key[3] == key[4])
+			rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
+		else
+			rc_keyup(d->rc_dev);
+	} else if (key[0] == 2) {
+		rc_repeat(d->rc_dev);
+	} else {
+		rc_keyup(d->rc_dev);
+	}
+
 	if (key[0] != 0)
 		deb_info("key: %*ph\n", 5, key);
+
 	return 0;
 }
 
@@ -164,11 +164,11 @@ static struct dvb_usb_device_properties dtt200u_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc.legacy = {
+	.rc.core = {
 		.rc_interval     = 300,
-		.rc_map_table    = rc_map_dtt200u_table,
-		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
+		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
+		.allowed_protos  = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -214,11 +214,11 @@ static struct dvb_usb_device_properties wt220u_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc.legacy = {
+	.rc.core = {
 		.rc_interval     = 300,
-		.rc_map_table      = rc_map_dtt200u_table,
-		.rc_map_size = ARRAY_SIZE(rc_map_dtt200u_table),
+		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
+		.allowed_protos  = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -264,11 +264,11 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc.legacy = {
+	.rc.core = {
 		.rc_interval     = 300,
-		.rc_map_table    = rc_map_dtt200u_table,
-		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
+		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
+		.allowed_protos  = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -314,11 +314,11 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc.legacy = {
+	.rc.core = {
 		.rc_interval     = 300,
-		.rc_map_table    = rc_map_dtt200u_table,
-		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
+		.rc_codes        = RC_MAP_DTT200U,
 		.rc_query        = dtt200u_rc_query,
+		.allowed_protos  = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7844e98..595f7cf 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -133,6 +133,7 @@ void rc_map_init(void);
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
+#define RC_MAP_DTT200U                   "rc-dtt200u"
 #define RC_MAP_DVBSKY                    "rc-dvbsky"
 #define RC_MAP_EMPTY                     "rc-empty"
 #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
-----

J.

-- 
I'm a *daemon*! Demons are evil. Daemons are not!
This .sig brought to you by the letter S and the number  6
Product of the Republic of HuggieTag
