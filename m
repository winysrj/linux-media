Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44272 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2EWJyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:50 -0400
Subject: [PATCH 31/43] rc-core: allow empty keymaps
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:43 +0200
Message-ID: <20120523094443.14474.15945.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the RC_MAP_EMPTY hack and instead allow for empty keymaps.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/af9015.c         |    4 ----
 drivers/media/dvb/dvb-usb/af9035.c         |    1 -
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    4 +---
 drivers/media/dvb/dvb-usb/rtl28xxu.c       |    2 --
 drivers/media/rc/gpio-ir-recv.c            |    1 -
 drivers/media/rc/rc-keytable.c             |   13 ++++---------
 drivers/media/rc/rc-loopback.c             |    1 -
 drivers/media/rc/rc-main.c                 |   17 +----------------
 drivers/media/video/cx88/cx88-input.c      |    6 ------
 drivers/media/video/ir-kbd-i2c.c           |    4 +---
 drivers/media/video/ivtv/ivtv-i2c.c        |    2 +-
 include/media/rc-map.h                     |    1 -
 12 files changed, 8 insertions(+), 48 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 4733044..b82e235 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -809,10 +809,6 @@ static void af9015_set_remote_config(struct usb_device *udev,
 		}
 	}
 
-	/* finally load "empty" just for leaving IR receiver enabled */
-	if (!props->rc.core.rc_codes)
-		props->rc.core.rc_codes = RC_MAP_EMPTY;
-
 	return;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index 42094e1..62714ad 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -1061,7 +1061,6 @@ static struct dvb_usb_device_properties af9035_properties[] = {
 			.rc_query       = NULL,
 			.rc_interval    = AF9035_POLL,
 			.allowed_protos = RC_TYPE_UNKNOWN,
-			.rc_codes       = RC_MAP_EMPTY,
 		},
 		.num_device_descs = 5,
 		.devices = {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 41bacff..909e95c 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -313,10 +313,8 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 
 	if (d->props.rc.legacy.rc_map_table && d->props.rc.legacy.rc_query)
 		d->props.rc.mode = DVB_RC_LEGACY;
-	else if (d->props.rc.core.rc_codes)
-		d->props.rc.mode = DVB_RC_CORE;
 	else
-		return 0;
+		d->props.rc.mode = DVB_RC_CORE;
 
 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
 	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 9dbde0a..8d67bc6 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -819,7 +819,6 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 			.rc_query       = rtl2831u_rc_query,
 			.rc_interval    = 400,
 			.allowed_protos = RC_BIT_NEC,
-			.rc_codes       = RC_MAP_EMPTY,
 		},
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
@@ -881,7 +880,6 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 			.rc_query       = rtl2832u_rc_query,
 			.rc_interval    = 400,
 			.allowed_protos = RC_BIT_NEC,
-			.rc_codes       = RC_MAP_EMPTY,
 		},
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 478b2e9..3ee7455 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -87,7 +87,6 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
-	rcdev->map_name = RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
 	gpio_dev->gpio_nr = pdata->gpio_nr;
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index d6e68d0..d5b1d88 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -54,6 +54,9 @@ struct rc_map *rc_map_get(const char *name)
 
 	struct rc_map_list *map;
 
+	if (!name)
+		return NULL;
+
 	map = seek_rc_map(name);
 #ifdef MODULE
 	if (!map) {
@@ -777,7 +780,6 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 {
 	struct rc_keytable *kt;
 	struct input_dev *idev = NULL;
-	struct rc_map *rc_map = NULL;
 	int error;
 
 	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
@@ -802,14 +804,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 	input_set_drvdata(idev, kt);
 	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
 
-	if (map_name)
-		rc_map = rc_map_get(map_name);
-	if (!rc_map)
-		rc_map = rc_map_get(RC_MAP_EMPTY);
-	if (!rc_map || !rc_map->scan || rc_map->size == 0)
-		goto out;
-
-	error = rc_keytable_init(kt, rc_map);
+	error = rc_keytable_init(kt, rc_map_get(map_name));
 	if (error)
 		goto out;
 
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index de9a75e..af64d15 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -218,7 +218,6 @@ static int __init loop_init(void)
 	rc->input_id.bustype	= BUS_VIRTUAL;
 	rc->input_id.version	= 1;
 	rc->driver_name		= DRIVER_NAME;
-	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
 	rc->allowed_protos	= RC_BIT_ALL;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a9c7226..4edaffb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -543,7 +543,7 @@ int rc_register_device(struct rc_dev *dev)
 	int rc;
 	unsigned int i;
 
-	if (!dev || !dev->map_name)
+	if (!dev)
 		return -EINVAL;
 
 	rc = mutex_lock_interruptible(&rc_dev_table_mutex);
@@ -1119,19 +1119,6 @@ static const struct file_operations rc_fops = {
 #endif
 };
 
-static struct rc_map_table empty[] = {
-	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
-};
-
-static struct rc_map_list empty_map = {
-	.map = {
-		.scan    = empty,
-		.size    = ARRAY_SIZE(empty),
-		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
-		.name    = RC_MAP_EMPTY,
-	}
-};
-
 static int __init rc_core_init(void)
 {
 	int ret;
@@ -1151,7 +1138,6 @@ static int __init rc_core_init(void)
 		goto chrdev;
 	}
 
-	rc_map_register(&empty_map);
 	return 0;
 
 chrdev:
@@ -1164,7 +1150,6 @@ static void __exit rc_core_exit(void)
 {
 	class_unregister(&rc_class);
 	unregister_chrdev(rc_major, "rc");
-rc_map_unregister(&empty_map);
 }
 
 subsys_initcall(rc_core_init);
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index b1922f0..2962ef7 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -423,11 +423,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	}
 
-	if (!ir_codes) {
-		err = -ENODEV;
-		goto err_out_free;
-	}
-
 	/*
 	 * The usage of mask_keycode were very convenient, due to several
 	 * reasons. Among others, the scancode tables were using the scancode
@@ -596,7 +591,6 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
 		core->init_data.type = RC_BIT_UNKNOWN;
 		core->init_data.get_key = get_key_pvr2000;
-		core->init_data.ir_codes = RC_MAP_EMPTY;
 		break;
 	}
 
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 86c53fa..3e0fa74 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -311,7 +311,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
 		rc_type     = RC_BIT_OTHER;
-		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x18:
 	case 0x1f:
@@ -325,7 +324,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
 		rc_type     = RC_BIT_OTHER;
-		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
@@ -402,7 +400,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir->rc = rc;
 
 	/* Make sure we are all setup before going on */
-	if (!name || !ir->get_key || !rc_type || !ir_codes) {
+	if (!name || !ir->get_key || !rc_type) {
 		dprintk(1, ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 46e262b..5b95586 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -221,7 +221,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->get_key = get_key_adaptec;
 		init_data->name = itv->card_name;
 		/* FIXME: The protocol and RC_MAP needs to be corrected */
-		init_data->ir_codes = RC_MAP_EMPTY;
+		/* init_data->ir_codes = RC_MAP_? */
 		init_data->type = RC_BIT_UNKNOWN;
 		break;
 	}
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5737c65..183d45c 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -135,7 +135,6 @@ void rc_map_init(void);
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
-#define RC_MAP_EMPTY                     "rc-empty"
 #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
 #define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
 #define RC_MAP_ENCORE_ENLTV_FM53         "rc-encore-enltv-fm53"

