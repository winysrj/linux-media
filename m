Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53267 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbcKTN3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Nov 2016 08:29:51 -0500
Date: Sun, 20 Nov 2016 13:29:48 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161120132948.GA23247@gofer.mess.org>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118220107.GA3510@shambles.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 19, 2016 at 09:01:10AM +1100, Vincent McIntyre wrote:
> On Fri, Nov 18, 2016 at 05:40:34PM +0000, Sean Young wrote:
> > >  
> > > So are you saying that the hex codes in the rc_map_dvico_mce_table
> > > struct are invalid (at least in some cases)?
> > 
> > Most likely the remote produces IR in a standard protocol (e.g. rc5, rc6). 
> > If we first get the keymap right then the remote can be used with any 
> > IR receiver that can deal with its protocol; conversely, if we know 
> > what protocol the IR receiver can receive, and we make it produce the 
> > scancodes in the right format, it can then be used with any remote that 
> > uses the protocol it understands.
> > 
> > So at the moment we don't know what protocol it is, and even if it is 
> > rc5 then some bit shifting might be needed to make it into a proper
> > rc5 scancode (both driver and keymap).
> > 
> > > How can I tell what protocol is in use?
> > > 0x00010001 doesn't mean much to me; I did search the linux source
> > > for the code but didn't find any helpful matches.
> > 
> > At the moment it's not easy to determine what protocol an remote uses;
> > I would like to change that but for now, the following is probably
> > the easiest way.
> > 
> > cd /sys/class/rc/rc1 # replace rc1 with your receiver
> > for i in $(<protocols); do echo +$i > protocols; done
> > echo 3 > /sys/module/rc_core/parameters/debug
> > journal -f -k
>  
> Ah. Here we have a problem. The device (/dev/input/event15)
> doesn't have a corresponding rcX node, see ir-keytable output below.
> I had it explained to me like this:

As I said you would need to use a raw IR receiver which has rc-core support
to determine the protocol, so never mind. Please can you try this patch:

I don't have the hardware to test this so your input would be appreciated.


Sean

From: Sean Young <sean@mess.org>
Subject: [PATCH] [media] cxusb: port to rc-core

The d680_dmb keymap has some new new mappings.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/Makefile            |   3 +
 drivers/media/rc/keymaps/rc-d680-dmb.c       |  75 +++++++
 drivers/media/rc/keymaps/rc-dvico-mce.c      |  85 ++++++++
 drivers/media/rc/keymaps/rc-dvico-portable.c |  76 +++++++
 drivers/media/usb/dvb-usb/cxusb.c            | 298 ++++++---------------------
 include/media/rc-map.h                       |   3 +
 6 files changed, 308 insertions(+), 232 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-d680-dmb.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-mce.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-portable.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index d7b13fa..11d5d5a 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-cec.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
+			rc-d680-dmb.o \
 			rc-delock-61959.o \
 			rc-dib0700-nec.o \
 			rc-dib0700-rc5.o \
@@ -31,6 +32,8 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dntv-live-dvbt-pro.o \
 			rc-dtt200u.o \
 			rc-dvbsky.o \
+			rc-dvico-mce.o \
+			rc-dvico-portable.o \
 			rc-em-terratec.o \
 			rc-encore-enltv2.o \
 			rc-encore-enltv.o \
diff --git a/drivers/media/rc/keymaps/rc-d680-dmb.c b/drivers/media/rc/keymaps/rc-d680-dmb.c
new file mode 100644
index 0000000..bb5745d
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-d680-dmb.c
@@ -0,0 +1,75 @@
+/*
+ * keymap imported from cxusb.c
+ *
+ * Copyright (C) 2016 Sean Young
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table rc_map_d680_dmb_table[] = {
+	{ 0x0038, KEY_SWITCHVIDEOMODE },	/* TV/AV */
+	{ 0x080c, KEY_ZOOM },
+	{ 0x0800, KEY_0 },
+	{ 0x0001, KEY_1 },
+	{ 0x0802, KEY_2 },
+	{ 0x0003, KEY_3 },
+	{ 0x0804, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0806, KEY_6 },
+	{ 0x0007, KEY_7 },
+	{ 0x0808, KEY_8 },
+	{ 0x0009, KEY_9 },
+	{ 0x000a, KEY_MUTE },
+	{ 0x0829, KEY_BACK },
+	{ 0x0012, KEY_CHANNELUP },
+	{ 0x0813, KEY_CHANNELDOWN },
+	{ 0x002b, KEY_VOLUMEUP },
+	{ 0x082c, KEY_VOLUMEDOWN },
+	{ 0x0020, KEY_UP },
+	{ 0x0821, KEY_DOWN },
+	{ 0x0011, KEY_LEFT },
+	{ 0x0810, KEY_RIGHT },
+	{ 0x000d, KEY_OK },
+	{ 0x081f, KEY_RECORD },
+	{ 0x0017, KEY_PLAYPAUSE },
+	{ 0x0816, KEY_PLAYPAUSE },
+	{ 0x000b, KEY_STOP },
+	{ 0x0827, KEY_FASTFORWARD },
+	{ 0x0026, KEY_REWIND },
+	{ 0x081e, KEY_UNKNOWN },    /* Time Shift */
+	{ 0x000e, KEY_UNKNOWN },    /* Snapshot */
+	{ 0x082d, KEY_UNKNOWN },    /* Mouse Cursor */
+	{ 0x000f, KEY_UNKNOWN },    /* Minimize/Maximize */
+	{ 0x0814, KEY_SHUFFLE },    /* Shuffle */
+	{ 0x0025, KEY_POWER },
+};
+
+static struct rc_map_list d680_dmb_map = {
+	.map = {
+		.scan    = rc_map_d680_dmb_table,
+		.size    = ARRAY_SIZE(rc_map_d680_dmb_table),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_D680_DMB,
+	}
+};
+
+static int __init init_rc_map_d680_dmb(void)
+{
+	return rc_map_register(&d680_dmb_map);
+}
+
+static void __exit exit_rc_map_d680_dmb(void)
+{
+	rc_map_unregister(&d680_dmb_map);
+}
+
+module_init(init_rc_map_d680_dmb)
+module_exit(exit_rc_map_d680_dmb)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dvico-mce.c b/drivers/media/rc/keymaps/rc-dvico-mce.c
new file mode 100644
index 0000000..e5f098c
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dvico-mce.c
@@ -0,0 +1,85 @@
+/*
+ * keymap imported from cxusb.c
+ *
+ * Copyright (C) 2016 Sean Young
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table rc_map_dvico_mce_table[] = {
+	{ 0xfe02, KEY_TV },
+	{ 0xfe0e, KEY_MP3 },
+	{ 0xfe1a, KEY_DVD },
+	{ 0xfe1e, KEY_FAVORITES },
+	{ 0xfe16, KEY_SETUP },
+	{ 0xfe46, KEY_POWER2 },
+	{ 0xfe0a, KEY_EPG },
+	{ 0xfe49, KEY_BACK },
+	{ 0xfe4d, KEY_MENU },
+	{ 0xfe51, KEY_UP },
+	{ 0xfe5b, KEY_LEFT },
+	{ 0xfe5f, KEY_RIGHT },
+	{ 0xfe53, KEY_DOWN },
+	{ 0xfe5e, KEY_OK },
+	{ 0xfe59, KEY_INFO },
+	{ 0xfe55, KEY_TAB },
+	{ 0xfe0f, KEY_PREVIOUSSONG },/* Replay */
+	{ 0xfe12, KEY_NEXTSONG },	/* Skip */
+	{ 0xfe42, KEY_ENTER	 },	/* Windows/Start */
+	{ 0xfe15, KEY_VOLUMEUP },
+	{ 0xfe05, KEY_VOLUMEDOWN },
+	{ 0xfe11, KEY_CHANNELUP },
+	{ 0xfe09, KEY_CHANNELDOWN },
+	{ 0xfe52, KEY_CAMERA },
+	{ 0xfe5a, KEY_TUNER },	/* Live */
+	{ 0xfe19, KEY_OPEN },
+	{ 0xfe0b, KEY_1 },
+	{ 0xfe17, KEY_2 },
+	{ 0xfe1b, KEY_3 },
+	{ 0xfe07, KEY_4 },
+	{ 0xfe50, KEY_5 },
+	{ 0xfe54, KEY_6 },
+	{ 0xfe48, KEY_7 },
+	{ 0xfe4c, KEY_8 },
+	{ 0xfe58, KEY_9 },
+	{ 0xfe13, KEY_ANGLE },	/* Aspect */
+	{ 0xfe03, KEY_0 },
+	{ 0xfe1f, KEY_ZOOM },
+	{ 0xfe43, KEY_REWIND },
+	{ 0xfe47, KEY_PLAYPAUSE },
+	{ 0xfe4f, KEY_FASTFORWARD },
+	{ 0xfe57, KEY_MUTE },
+	{ 0xfe0d, KEY_STOP },
+	{ 0xfe01, KEY_RECORD },
+	{ 0xfe4e, KEY_POWER },
+};
+
+static struct rc_map_list dvico_mce_map = {
+	.map = {
+		.scan    = rc_map_dvico_mce_table,
+		.size    = ARRAY_SIZE(rc_map_dvico_mce_table),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_DVICO_MCE,
+	}
+};
+
+static int __init init_rc_map_dvico_mce(void)
+{
+	return rc_map_register(&dvico_mce_map);
+}
+
+static void __exit exit_rc_map_dvico_mce(void)
+{
+	rc_map_unregister(&dvico_mce_map);
+}
+
+module_init(init_rc_map_dvico_mce)
+module_exit(exit_rc_map_dvico_mce)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dvico-portable.c b/drivers/media/rc/keymaps/rc-dvico-portable.c
new file mode 100644
index 0000000..94ceeee
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dvico-portable.c
@@ -0,0 +1,76 @@
+/*
+ * keymap imported from cxusb.c
+ *
+ * Copyright (C) 2016 Sean Young
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table rc_map_dvico_portable_table[] = {
+	{ 0xfc02, KEY_SETUP },       /* Profile */
+	{ 0xfc43, KEY_POWER2 },
+	{ 0xfc06, KEY_EPG },
+	{ 0xfc5a, KEY_BACK },
+	{ 0xfc05, KEY_MENU },
+	{ 0xfc47, KEY_INFO },
+	{ 0xfc01, KEY_TAB },
+	{ 0xfc42, KEY_PREVIOUSSONG },/* Replay */
+	{ 0xfc49, KEY_VOLUMEUP },
+	{ 0xfc09, KEY_VOLUMEDOWN },
+	{ 0xfc54, KEY_CHANNELUP },
+	{ 0xfc0b, KEY_CHANNELDOWN },
+	{ 0xfc16, KEY_CAMERA },
+	{ 0xfc40, KEY_TUNER },	/* ATV/DTV */
+	{ 0xfc45, KEY_OPEN },
+	{ 0xfc19, KEY_1 },
+	{ 0xfc18, KEY_2 },
+	{ 0xfc1b, KEY_3 },
+	{ 0xfc1a, KEY_4 },
+	{ 0xfc58, KEY_5 },
+	{ 0xfc59, KEY_6 },
+	{ 0xfc15, KEY_7 },
+	{ 0xfc14, KEY_8 },
+	{ 0xfc17, KEY_9 },
+	{ 0xfc44, KEY_ANGLE },	/* Aspect */
+	{ 0xfc55, KEY_0 },
+	{ 0xfc07, KEY_ZOOM },
+	{ 0xfc0a, KEY_REWIND },
+	{ 0xfc08, KEY_PLAYPAUSE },
+	{ 0xfc4b, KEY_FASTFORWARD },
+	{ 0xfc5b, KEY_MUTE },
+	{ 0xfc04, KEY_STOP },
+	{ 0xfc56, KEY_RECORD },
+	{ 0xfc57, KEY_POWER },
+	{ 0xfc41, KEY_UNKNOWN },    /* INPUT */
+	{ 0xfc00, KEY_UNKNOWN },    /* HD */
+};
+
+static struct rc_map_list dvico_portable_map = {
+	.map = {
+		.scan    = rc_map_dvico_portable_table,
+		.size    = ARRAY_SIZE(rc_map_dvico_portable_table),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_DVICO_PORTABLE,
+	}
+};
+
+static int __init init_rc_map_dvico_portable(void)
+{
+	return rc_map_register(&dvico_portable_map);
+}
+
+static void __exit exit_rc_map_dvico_portable(void)
+{
+	rc_map_unregister(&dvico_portable_map);
+}
+
+module_init(init_rc_map_dvico_portable)
+module_exit(exit_rc_map_dvico_portable)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 9b8771e..29d89c4 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -450,209 +450,43 @@ static int cxusb_d680_dmb_streaming_ctrl(
 	}
 }
 
-static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static int cxusb_rc_query(struct dvb_usb_device *d)
 {
-	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
 	u8 ircode[4];
-	int i;
 
 	cxusb_ctrl_msg(d, CMD_GET_IR_CODE, NULL, 0, ircode, 4);
 
-	*event = 0;
-	*state = REMOTE_NO_KEY_PRESSED;
-
-	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == ircode[2] &&
-		    rc5_data(&keymap[i]) == ircode[3]) {
-			*event = keymap[i].keycode;
-			*state = REMOTE_KEY_PRESSED;
-
-			return 0;
-		}
-	}
-
+	rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
+				RC_SCANCODE_RC5(ircode[2], ircode[3]), 0);
 	return 0;
 }
 
-static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
-				    int *state)
+static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d)
 {
-	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
 	u8 ircode[4];
-	int i;
 	struct i2c_msg msg = { .addr = 0x6b, .flags = I2C_M_RD,
 			       .buf = ircode, .len = 4 };
 
-	*event = 0;
-	*state = REMOTE_NO_KEY_PRESSED;
-
 	if (cxusb_i2c_xfer(&d->i2c_adap, &msg, 1) != 1)
 		return 0;
 
-	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == ircode[1] &&
-		    rc5_data(&keymap[i]) == ircode[2]) {
-			*event = keymap[i].keycode;
-			*state = REMOTE_KEY_PRESSED;
-
-			return 0;
-		}
-	}
-
+	rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
+				RC_SCANCODE_RC5(ircode[1], ircode[2]), 0);
 	return 0;
 }
 
-static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
-		int *state)
+static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d)
 {
-	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
 	u8 ircode[2];
-	int i;
-
-	*event = 0;
-	*state = REMOTE_NO_KEY_PRESSED;
 
 	if (cxusb_ctrl_msg(d, 0x10, NULL, 0, ircode, 2) < 0)
 		return 0;
 
-	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == ircode[0] &&
-		    rc5_data(&keymap[i]) == ircode[1]) {
-			*event = keymap[i].keycode;
-			*state = REMOTE_KEY_PRESSED;
-
-			return 0;
-		}
-	}
-
+	rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
+				RC_SCANCODE_RC5(ircode[0], ircode[1]), 0);
 	return 0;
 }
 
-static struct rc_map_table rc_map_dvico_mce_table[] = {
-	{ 0xfe02, KEY_TV },
-	{ 0xfe0e, KEY_MP3 },
-	{ 0xfe1a, KEY_DVD },
-	{ 0xfe1e, KEY_FAVORITES },
-	{ 0xfe16, KEY_SETUP },
-	{ 0xfe46, KEY_POWER2 },
-	{ 0xfe0a, KEY_EPG },
-	{ 0xfe49, KEY_BACK },
-	{ 0xfe4d, KEY_MENU },
-	{ 0xfe51, KEY_UP },
-	{ 0xfe5b, KEY_LEFT },
-	{ 0xfe5f, KEY_RIGHT },
-	{ 0xfe53, KEY_DOWN },
-	{ 0xfe5e, KEY_OK },
-	{ 0xfe59, KEY_INFO },
-	{ 0xfe55, KEY_TAB },
-	{ 0xfe0f, KEY_PREVIOUSSONG },/* Replay */
-	{ 0xfe12, KEY_NEXTSONG },	/* Skip */
-	{ 0xfe42, KEY_ENTER	 },	/* Windows/Start */
-	{ 0xfe15, KEY_VOLUMEUP },
-	{ 0xfe05, KEY_VOLUMEDOWN },
-	{ 0xfe11, KEY_CHANNELUP },
-	{ 0xfe09, KEY_CHANNELDOWN },
-	{ 0xfe52, KEY_CAMERA },
-	{ 0xfe5a, KEY_TUNER },	/* Live */
-	{ 0xfe19, KEY_OPEN },
-	{ 0xfe0b, KEY_1 },
-	{ 0xfe17, KEY_2 },
-	{ 0xfe1b, KEY_3 },
-	{ 0xfe07, KEY_4 },
-	{ 0xfe50, KEY_5 },
-	{ 0xfe54, KEY_6 },
-	{ 0xfe48, KEY_7 },
-	{ 0xfe4c, KEY_8 },
-	{ 0xfe58, KEY_9 },
-	{ 0xfe13, KEY_ANGLE },	/* Aspect */
-	{ 0xfe03, KEY_0 },
-	{ 0xfe1f, KEY_ZOOM },
-	{ 0xfe43, KEY_REWIND },
-	{ 0xfe47, KEY_PLAYPAUSE },
-	{ 0xfe4f, KEY_FASTFORWARD },
-	{ 0xfe57, KEY_MUTE },
-	{ 0xfe0d, KEY_STOP },
-	{ 0xfe01, KEY_RECORD },
-	{ 0xfe4e, KEY_POWER },
-};
-
-static struct rc_map_table rc_map_dvico_portable_table[] = {
-	{ 0xfc02, KEY_SETUP },       /* Profile */
-	{ 0xfc43, KEY_POWER2 },
-	{ 0xfc06, KEY_EPG },
-	{ 0xfc5a, KEY_BACK },
-	{ 0xfc05, KEY_MENU },
-	{ 0xfc47, KEY_INFO },
-	{ 0xfc01, KEY_TAB },
-	{ 0xfc42, KEY_PREVIOUSSONG },/* Replay */
-	{ 0xfc49, KEY_VOLUMEUP },
-	{ 0xfc09, KEY_VOLUMEDOWN },
-	{ 0xfc54, KEY_CHANNELUP },
-	{ 0xfc0b, KEY_CHANNELDOWN },
-	{ 0xfc16, KEY_CAMERA },
-	{ 0xfc40, KEY_TUNER },	/* ATV/DTV */
-	{ 0xfc45, KEY_OPEN },
-	{ 0xfc19, KEY_1 },
-	{ 0xfc18, KEY_2 },
-	{ 0xfc1b, KEY_3 },
-	{ 0xfc1a, KEY_4 },
-	{ 0xfc58, KEY_5 },
-	{ 0xfc59, KEY_6 },
-	{ 0xfc15, KEY_7 },
-	{ 0xfc14, KEY_8 },
-	{ 0xfc17, KEY_9 },
-	{ 0xfc44, KEY_ANGLE },	/* Aspect */
-	{ 0xfc55, KEY_0 },
-	{ 0xfc07, KEY_ZOOM },
-	{ 0xfc0a, KEY_REWIND },
-	{ 0xfc08, KEY_PLAYPAUSE },
-	{ 0xfc4b, KEY_FASTFORWARD },
-	{ 0xfc5b, KEY_MUTE },
-	{ 0xfc04, KEY_STOP },
-	{ 0xfc56, KEY_RECORD },
-	{ 0xfc57, KEY_POWER },
-	{ 0xfc41, KEY_UNKNOWN },    /* INPUT */
-	{ 0xfc00, KEY_UNKNOWN },    /* HD */
-};
-
-static struct rc_map_table rc_map_d680_dmb_table[] = {
-	{ 0x0038, KEY_UNKNOWN },	/* TV/AV */
-	{ 0x080c, KEY_ZOOM },
-	{ 0x0800, KEY_0 },
-	{ 0x0001, KEY_1 },
-	{ 0x0802, KEY_2 },
-	{ 0x0003, KEY_3 },
-	{ 0x0804, KEY_4 },
-	{ 0x0005, KEY_5 },
-	{ 0x0806, KEY_6 },
-	{ 0x0007, KEY_7 },
-	{ 0x0808, KEY_8 },
-	{ 0x0009, KEY_9 },
-	{ 0x000a, KEY_MUTE },
-	{ 0x0829, KEY_BACK },
-	{ 0x0012, KEY_CHANNELUP },
-	{ 0x0813, KEY_CHANNELDOWN },
-	{ 0x002b, KEY_VOLUMEUP },
-	{ 0x082c, KEY_VOLUMEDOWN },
-	{ 0x0020, KEY_UP },
-	{ 0x0821, KEY_DOWN },
-	{ 0x0011, KEY_LEFT },
-	{ 0x0810, KEY_RIGHT },
-	{ 0x000d, KEY_OK },
-	{ 0x081f, KEY_RECORD },
-	{ 0x0017, KEY_PLAYPAUSE },
-	{ 0x0816, KEY_PLAYPAUSE },
-	{ 0x000b, KEY_STOP },
-	{ 0x0827, KEY_FASTFORWARD },
-	{ 0x0026, KEY_REWIND },
-	{ 0x081e, KEY_UNKNOWN },    /* Time Shift */
-	{ 0x000e, KEY_UNKNOWN },    /* Snapshot */
-	{ 0x082d, KEY_UNKNOWN },    /* Mouse Cursor */
-	{ 0x000f, KEY_UNKNOWN },    /* Minimize/Maximize */
-	{ 0x0814, KEY_UNKNOWN },    /* Shuffle */
-	{ 0x0025, KEY_POWER },
-};
-
 static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
 {
 	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
@@ -1000,7 +834,7 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
 		return -EIO;
 
 	/* try to determine if there is no IR decoder on the I2C bus */
-	for (i = 0; adap->dev->props.rc.legacy.rc_map_table != NULL && i < 5; i++) {
+	for (i = 0; adap->dev->props.rc.core.rc_codes != NULL && i < 5; i++) {
 		msleep(20);
 		if (cxusb_i2c_xfer(&adap->dev->i2c_adap, &msg, 1) != 1)
 			goto no_IR;
@@ -1008,7 +842,7 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
 			continue;
 		if (ircode[2] + ircode[3] != 0xff) {
 no_IR:
-			adap->dev->props.rc.legacy.rc_map_table = NULL;
+			adap->dev->props.rc.core.rc_codes = NULL;
 			info("No IR receiver detected on this device.");
 			break;
 		}
@@ -1720,11 +1554,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_portable_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_PORTABLE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1776,11 +1610,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc.legacy = {
-		.rc_interval      = 150,
-		.rc_map_table     = rc_map_dvico_mce_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_MCE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1840,11 +1674,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_portable_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_PORTABLE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1895,11 +1729,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_portable_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_PORTABLE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1949,11 +1783,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_mce_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
-		.rc_query         = cxusb_bluebird2_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_MCE,
+		.rc_query	= cxusb_bluebird2_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2002,11 +1836,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_portable_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_query         = cxusb_bluebird2_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_PORTABLE,
+		.rc_query       = cxusb_bluebird2_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2057,11 +1891,11 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_portable_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_PORTABLE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2155,11 +1989,11 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_dvico_mce_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
-		.rc_query         = cxusb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_DVICO_MCE,
+		.rc_query	= cxusb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2208,11 +2042,11 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_d680_dmb_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
-		.rc_query         = cxusb_d680_dmb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_D680_DMB,
+		.rc_query       = cxusb_d680_dmb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2262,11 +2096,11 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_d680_dmb_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
-		.rc_query         = cxusb_d680_dmb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_D680_DMB,
+		.rc_query       = cxusb_d680_dmb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
@@ -2315,11 +2149,11 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc.legacy = {
-		.rc_interval      = 100,
-		.rc_map_table     = rc_map_d680_dmb_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
-		.rc_query         = cxusb_d680_dmb_rc_query,
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_D680_DMB,
+		.rc_query       = cxusb_d680_dmb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.num_device_descs = 1,
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e1cc14c..82feb2d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -198,6 +198,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_CEC                       "rc-cec"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
+#define RC_MAP_D680_DMB                  "rc-d680-dmb"
 #define RC_MAP_DELOCK_61959              "rc-delock-61959"
 #define RC_MAP_DIB0700_NEC_TABLE         "rc-dib0700-nec"
 #define RC_MAP_DIB0700_RC5_TABLE         "rc-dib0700-rc5"
@@ -208,6 +209,8 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
 #define RC_MAP_DTT200U                   "rc-dtt200u"
 #define RC_MAP_DVBSKY                    "rc-dvbsky"
+#define RC_MAP_DVICO_MCE		 "rc-dvico-mce"
+#define RC_MAP_DVICO_PORTABLE		 "rc-dvico-portable"
 #define RC_MAP_EMPTY                     "rc-empty"
 #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
 #define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
-- 
2.7.4

