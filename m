Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:54:10 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712s99q007979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:09 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwG027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:53:57 -0400
Date: Sat, 31 Jul 2010 23:54:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/7] V4L/DVB: dvb-usb: prepare drivers for using rc-core
Message-ID: <20100731235404.0bf29a3d@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a big patch, yet trivial. It just move the RC properties
to a separate struct, in order to prepare the dvb-usb drivers to
use rc-core. There's no change on the behavior of the drivers.

With this change, it is possible to have both legacy and rc-core
based code inside the dvb-usb-remote, allowing a gradual migration
to rc-core, driver per driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 5580383..a5c3637 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -146,10 +146,12 @@ static struct dvb_usb_device_properties a800_properties = {
 	.power_ctrl       = a800_power_ctrl,
 	.identify_state   = a800_identify_state,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_a800_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_a800_table),
-	.rc_query         = a800_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_a800_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_a800_table),
+		.rc_query         = a800_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index 9856463..8ecba88 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -1025,10 +1025,12 @@ static struct dvb_usb_device_properties af9005_properties = {
 
 	.i2c_algo = &af9005_i2c_algo,
 
-	.rc_interval = 200,
-	.rc_key_map = NULL,
-	.rc_key_map_size = 0,
-	.rc_query = af9005_rc_query,
+	.rc.legacy = {
+		.rc_interval = 200,
+		.rc_key_map = NULL,
+		.rc_key_map_size = 0,
+		.rc_query = af9005_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint          = 2,
 	.generic_bulk_ctrl_endpoint_response = 1,
@@ -1072,10 +1074,10 @@ static int __init af9005_usb_module_init(void)
 	rc_keys_size = symbol_request(ir_codes_af9005_table_size);
 	if (rc_decode == NULL || rc_keys == NULL || rc_keys_size == NULL) {
 		err("af9005_rc_decode function not found, disabling remote");
-		af9005_properties.rc_query = NULL;
+		af9005_properties.rc.legacy.rc_query = NULL;
 	} else {
-		af9005_properties.rc_key_map = rc_keys;
-		af9005_properties.rc_key_map_size = *rc_keys_size;
+		af9005_properties.rc.legacy.rc_key_map = rc_keys;
+		af9005_properties.rc.legacy.rc_key_map_size = *rc_keys_size;
 	}
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index c63134c..ea1ed3b 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -847,8 +847,8 @@ static void af9015_set_remote_config(struct usb_device *udev,
 	}
 
 	if (table) {
-		props->rc_key_map = table->rc_key_map;
-		props->rc_key_map_size = table->rc_key_map_size;
+		props->rc.legacy.rc_key_map = table->rc_key_map;
+		props->rc.legacy.rc_key_map_size = table->rc_key_map_size;
 		af9015_config.ir_table = table->ir_table;
 		af9015_config.ir_table_size = table->ir_table_size;
 	}
@@ -878,8 +878,8 @@ static int af9015_read_config(struct usb_device *udev)
 	deb_info("%s: IR mode:%d\n", __func__, val);
 	for (i = 0; i < af9015_properties_count; i++) {
 		if (val == AF9015_IR_MODE_DISABLED) {
-			af9015_properties[i].rc_key_map = NULL;
-			af9015_properties[i].rc_key_map_size  = 0;
+			af9015_properties[i].rc.legacy.rc_key_map = NULL;
+			af9015_properties[i].rc.legacy.rc_key_map_size  = 0;
 		} else
 			af9015_set_remote_config(udev, &af9015_properties[i]);
 	}
@@ -1063,7 +1063,7 @@ static int af9015_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 buf[8];
 	struct req_t req = {GET_IR_CODE, 0, 0, 0, 0, sizeof(buf), buf};
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	int i, ret;
 
 	memset(buf, 0, sizeof(buf));
@@ -1075,7 +1075,7 @@ static int af9015_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (!buf[1] && rc5_custom(&keymap[i]) == buf[0] &&
 		    rc5_data(&keymap[i]) == buf[2]) {
 			*event = keymap[i].keycode;
@@ -1354,8 +1354,10 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 
 		.identify_state = af9015_identify_state,
 
-		.rc_query         = af9015_rc_query,
-		.rc_interval      = 150,
+		.rc.legacy = {
+			.rc_query         = af9015_rc_query,
+			.rc_interval      = 150,
+		},
 
 		.i2c_algo = &af9015_i2c_algo,
 
@@ -1461,8 +1463,10 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 
 		.identify_state = af9015_identify_state,
 
-		.rc_query         = af9015_rc_query,
-		.rc_interval      = 150,
+		.rc.legacy = {
+			.rc_query         = af9015_rc_query,
+			.rc_interval      = 150,
+		},
 
 		.i2c_algo = &af9015_i2c_algo,
 
@@ -1568,8 +1572,10 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 
 		.identify_state = af9015_identify_state,
 
-		.rc_query         = af9015_rc_query,
-		.rc_interval      = 150,
+		.rc.legacy = {
+			.rc_query         = af9015_rc_query,
+			.rc_interval      = 150,
+		},
 
 		.i2c_algo = &af9015_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 3e39e8f..4685259 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -377,7 +377,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 buf[] = {CMD_GET_IR_CODE};
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	u8 ircode[2];
 	int i, ret;
 
@@ -388,7 +388,7 @@ static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[0] &&
 		    rc5_data(&keymap[i]) == ircode[1]) {
 			*event = keymap[i].keycode;
@@ -520,10 +520,12 @@ static struct dvb_usb_device_properties anysee_properties = {
 		}
 	},
 
-	.rc_key_map       = ir_codes_anysee_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_anysee_table),
-	.rc_query         = anysee_rc_query,
-	.rc_interval      = 200,  /* windows driver uses 500ms */
+	.rc.legacy = {
+		.rc_key_map       = ir_codes_anysee_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_anysee_table),
+		.rc_query         = anysee_rc_query,
+		.rc_interval      = 200,  /* windows driver uses 500ms */
+	},
 
 	.i2c_algo         = &anysee_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 03d9bfe..62c5828 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -1125,10 +1125,13 @@ static struct dvb_usb_device_properties az6027_properties = {
 	.power_ctrl       = az6027_power_ctrl,
 	.read_mac_address = az6027_read_mac_addr,
  */
-	.rc_key_map       = ir_codes_az6027_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_az6027_table),
-	.rc_interval      = 400,
-	.rc_query         = az6027_rc_query,
+	.rc.legacy = {
+		.rc_key_map       = ir_codes_az6027_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_az6027_table),
+		.rc_interval      = 400,
+		.rc_query         = az6027_rc_query,
+	},
+
 	.i2c_algo         = &az6027_i2c_algo,
 
 	.num_device_descs = 5,
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 806d781..4f5aa83 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -217,10 +217,12 @@ static struct dvb_usb_device_properties cinergyt2_properties = {
 
 	.power_ctrl       = cinergyt2_power_ctrl,
 
-	.rc_interval      = 50,
-	.rc_key_map       = ir_codes_cinergyt2_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_cinergyt2_table),
-	.rc_query         = cinergyt2_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 50,
+		.rc_key_map       = ir_codes_cinergyt2_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_cinergyt2_table),
+		.rc_query         = cinergyt2_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 1,
 
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 22fc0a9..cd9f362 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -385,7 +385,7 @@ static int cxusb_d680_dmb_streaming_ctrl(
 
 static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	u8 ircode[4];
 	int i;
 
@@ -394,7 +394,7 @@ static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[2] &&
 		    rc5_data(&keymap[i]) == ircode[3]) {
 			*event = keymap[i].keycode;
@@ -410,7 +410,7 @@ static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 				    int *state)
 {
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	u8 ircode[4];
 	int i;
 	struct i2c_msg msg = { .addr = 0x6b, .flags = I2C_M_RD,
@@ -422,7 +422,7 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 	if (cxusb_i2c_xfer(&d->i2c_adap, &msg, 1) != 1)
 		return 0;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[1] &&
 		    rc5_data(&keymap[i]) == ircode[2]) {
 			*event = keymap[i].keycode;
@@ -438,7 +438,7 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 		int *state)
 {
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	u8 ircode[2];
 	int i;
 
@@ -448,7 +448,7 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	if (cxusb_ctrl_msg(d, 0x10, NULL, 0, ircode, 2) < 0)
 		return 0;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[0] &&
 		    rc5_data(&keymap[i]) == ircode[1]) {
 			*event = keymap[i].keycode;
@@ -923,7 +923,7 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
 		return -EIO;
 
 	/* try to determine if there is no IR decoder on the I2C bus */
-	for (i = 0; adap->dev->props.rc_key_map != NULL && i < 5; i++) {
+	for (i = 0; adap->dev->props.rc.legacy.rc_key_map != NULL && i < 5; i++) {
 		msleep(20);
 		if (cxusb_i2c_xfer(&adap->dev->i2c_adap, &msg, 1) != 1)
 			goto no_IR;
@@ -931,7 +931,7 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
 			continue;
 		if (ircode[2] + ircode[3] != 0xff) {
 no_IR:
-			adap->dev->props.rc_key_map = NULL;
+			adap->dev->props.rc.legacy.rc_key_map = NULL;
 			info("No IR receiver detected on this device.");
 			break;
 		}
@@ -1451,10 +1451,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_portable_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_portable_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -1502,10 +1504,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc_interval      = 150,
-	.rc_key_map       = ir_codes_dvico_mce_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 150,
+		.rc_key_map       = ir_codes_dvico_mce_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -1561,10 +1565,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_portable_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_portable_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 	.num_device_descs = 1,
@@ -1611,10 +1617,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 
 	.i2c_algo         = &cxusb_i2c_algo,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_portable_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_portable_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -1660,10 +1668,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_mce_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
-	.rc_query         = cxusb_bluebird2_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_mce_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
+		.rc_query         = cxusb_bluebird2_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
@@ -1708,10 +1718,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_portable_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
-	.rc_query         = cxusb_bluebird2_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_portable_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
+		.rc_query         = cxusb_bluebird2_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
@@ -1758,10 +1770,12 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_portable_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_portable_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
@@ -1849,10 +1863,12 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_dvico_mce_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
-	.rc_query         = cxusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_dvico_mce_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
+		.rc_query         = cxusb_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
@@ -1897,10 +1913,12 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_d680_dmb_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
-	.rc_query         = cxusb_d680_dmb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_d680_dmb_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
+		.rc_query         = cxusb_d680_dmb_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
@@ -1946,10 +1964,12 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_d680_dmb_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
-	.rc_query         = cxusb_d680_dmb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_d680_dmb_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
+		.rc_query         = cxusb_d680_dmb_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index f761897..527b1e6 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -510,7 +510,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		return;
 	}
 
-	keymap = d->props.rc_key_map;
+	keymap = d->props.rc.legacy.rc_key_map;
 	st = d->priv;
 	buf = (u8 *)purb->transfer_buffer;
 
@@ -571,7 +571,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 poll_reply.system, poll_reply.data, poll_reply.not_data);
 
 	/* Find the key in the map */
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == (poll_reply.system & 0xff) &&
 		    rc5_data(&keymap[i]) == poll_reply.data) {
 			event = keymap[i].keycode;
@@ -640,7 +640,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	int ret;
 	int i;
 
-	if (d->props.rc_key_map == NULL)
+	if (d->props.rc.legacy.rc_key_map == NULL)
 		return 0;
 
 	/* Set the IR mode */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 0c9adbb..2ae74ba 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -477,7 +477,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 key[4];
 	int i;
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	struct dib0700_state *st = d->priv;
 
 	*event = 0;
@@ -517,7 +517,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			}
 			return 0;
 		}
-		for (i=0;i<d->props.rc_key_map_size; i++) {
+		for (i=0;i<d->props.rc.legacy.rc_key_map_size; i++) {
 			if (rc5_custom(&keymap[i]) == key[3-2] &&
 			    rc5_data(&keymap[i]) == key[3-3]) {
 				st->rc_counter = 0;
@@ -531,7 +531,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	}
 	default: {
 		/* RC-5 protocol changes toggle bit on new keypress */
-		for (i = 0; i < d->props.rc_key_map_size; i++) {
+		for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 			if (rc5_custom(&keymap[i]) == key[3-2] &&
 			    rc5_data(&keymap[i]) == key[3-3]) {
 				if (d->last_event == keymap[i].keycode &&
@@ -2168,10 +2168,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
@@ -2197,10 +2199,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
@@ -2251,11 +2255,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
-
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
@@ -2288,10 +2293,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
@@ -2358,11 +2365,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
-
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
@@ -2397,11 +2405,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
-
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
@@ -2463,10 +2472,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
@@ -2525,10 +2537,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
@@ -2554,10 +2569,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
@@ -2615,10 +2632,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
@@ -2653,11 +2672,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
-
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 2,
 		.adapter = {
@@ -2697,10 +2717,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
@@ -2728,10 +2750,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = ir_codes_dib0700_table,
-		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-		.rc_query         = dib0700_rc_query
+		.rc.legacy = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_key_map       = ir_codes_dib0700_table,
+			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
+			.rc_query         = dib0700_rc_query
+		},
 	},
 };
 
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index eb2e6f0..8e3c0d2 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -211,10 +211,12 @@ static struct dvb_usb_device_properties dibusb1_1_properties = {
 
 	.power_ctrl       = dibusb_power_ctrl,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_dibusb_table,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
-	.rc_query         = dibusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_dibusb_table,
+		.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
+		.rc_query         = dibusb_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
@@ -295,10 +297,12 @@ static struct dvb_usb_device_properties dibusb1_1_an2235_properties = {
 	},
 	.power_ctrl       = dibusb_power_ctrl,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_dibusb_table,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
-	.rc_query         = dibusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_dibusb_table,
+		.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
+		.rc_query         = dibusb_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
@@ -359,10 +363,12 @@ static struct dvb_usb_device_properties dibusb2_0b_properties = {
 	},
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_dibusb_table,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
-	.rc_query         = dibusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_dibusb_table,
+		.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
+		.rc_query         = dibusb_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
@@ -416,10 +422,12 @@ static struct dvb_usb_device_properties artec_t1_usb2_properties = {
 	},
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_dibusb_table,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
-	.rc_query         = dibusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_dibusb_table,
+		.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
+		.rc_query         = dibusb_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
index 588308e..1cbc41c 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
@@ -81,10 +81,12 @@ static struct dvb_usb_device_properties dibusb_mc_properties = {
 	},
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
-	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = ir_codes_dibusb_table,
-	.rc_key_map_size  = 111, /* FIXME */
-	.rc_query         = dibusb_rc_query,
+	.rc.legacy = {
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = ir_codes_dibusb_table,
+		.rc_key_map_size  = 111, /* FIXME */
+		.rc_query         = dibusb_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 73f14a2..13d006b 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -237,10 +237,10 @@ static int digitv_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	/* if something is inside the buffer, simulate key press */
 	if (key[1] != 0)
 	{
-		  for (i = 0; i < d->props.rc_key_map_size; i++) {
-			if (rc5_custom(&d->props.rc_key_map[i]) == key[1] &&
-			    rc5_data(&d->props.rc_key_map[i]) == key[2]) {
-				*event = d->props.rc_key_map[i].keycode;
+		  for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
+			if (rc5_custom(&d->props.rc.legacy.rc_key_map[i]) == key[1] &&
+			    rc5_data(&d->props.rc.legacy.rc_key_map[i]) == key[2]) {
+				*event = d->props.rc.legacy.rc_key_map[i].keycode;
 				*state = REMOTE_KEY_PRESSED;
 				return 0;
 			}
@@ -310,10 +310,12 @@ static struct dvb_usb_device_properties digitv_properties = {
 	},
 	.identify_state   = digitv_identify_state,
 
-	.rc_interval      = 1000,
-	.rc_key_map       = ir_codes_digitv_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_digitv_table),
-	.rc_query         = digitv_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 1000,
+		.rc_key_map       = ir_codes_digitv_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_digitv_table),
+		.rc_query         = digitv_rc_query,
+	},
 
 	.i2c_algo         = &digitv_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index c0de0c0..ca495e0 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -161,10 +161,12 @@ static struct dvb_usb_device_properties dtt200u_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc_interval     = 300,
-	.rc_key_map      = ir_codes_dtt200u_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
-	.rc_query        = dtt200u_rc_query,
+	.rc.legacy = {
+		.rc_interval     = 300,
+		.rc_key_map      = ir_codes_dtt200u_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
+		.rc_query        = dtt200u_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -206,10 +208,12 @@ static struct dvb_usb_device_properties wt220u_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc_interval     = 300,
-	.rc_key_map      = ir_codes_dtt200u_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
-	.rc_query        = dtt200u_rc_query,
+	.rc.legacy = {
+		.rc_interval     = 300,
+		.rc_key_map      = ir_codes_dtt200u_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
+		.rc_query        = dtt200u_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -251,10 +255,12 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc_interval     = 300,
-	.rc_key_map      = ir_codes_dtt200u_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
-	.rc_query        = dtt200u_rc_query,
+	.rc.legacy = {
+		.rc_interval     = 300,
+		.rc_key_map      = ir_codes_dtt200u_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
+		.rc_query        = dtt200u_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
@@ -296,10 +302,12 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
 	},
 	.power_ctrl      = dtt200u_power_ctrl,
 
-	.rc_interval     = 300,
-	.rc_key_map      = ir_codes_dtt200u_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
-	.rc_query        = dtt200u_rc_query,
+	.rc.legacy = {
+		.rc_interval     = 300,
+		.rc_key_map      = ir_codes_dtt200u_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
+		.rc_query        = dtt200u_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index e210f2f..7951076 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -13,11 +13,11 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	int i;
 
 	/* See if we can match the raw key code. */
-	for (i = 0; i < d->props.rc_key_map_size; i++)
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
 		if (keymap[i].scancode == scancode) {
 			*keycode = keymap[i].keycode;
 			return 0;
@@ -28,7 +28,7 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 	 * otherwise, input core won't let dvb_usb_setkeycode
 	 * to work
 	 */
-	for (i = 0; i < d->props.rc_key_map_size; i++)
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
 		if (keymap[i].keycode == KEY_RESERVED ||
 		    keymap[i].keycode == KEY_UNKNOWN) {
 			*keycode = KEY_RESERVED;
@@ -43,18 +43,18 @@ static int dvb_usb_setkeycode(struct input_dev *dev,
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	int i;
 
 	/* Search if it is replacing an existing keycode */
-	for (i = 0; i < d->props.rc_key_map_size; i++)
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
 		if (keymap[i].scancode == scancode) {
 			keymap[i].keycode = keycode;
 			return 0;
 		}
 
 	/* Search if is there a clean entry. If so, use it */
-	for (i = 0; i < d->props.rc_key_map_size; i++)
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
 		if (keymap[i].keycode == KEY_RESERVED ||
 		    keymap[i].keycode == KEY_UNKNOWN) {
 			keymap[i].scancode = scancode;
@@ -92,7 +92,7 @@ static void dvb_usb_read_remote_control(struct work_struct *work)
 	if (dvb_usb_disable_rc_polling)
 		return;
 
-	if (d->props.rc_query(d,&event,&state)) {
+	if (d->props.rc.legacy.rc_query(d,&event,&state)) {
 		err("error while querying for an remote control event.");
 		goto schedule;
 	}
@@ -151,7 +151,7 @@ static void dvb_usb_read_remote_control(struct work_struct *work)
 */
 
 schedule:
-	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc_interval));
+	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc.legacy.rc_interval));
 }
 
 int dvb_usb_remote_init(struct dvb_usb_device *d)
@@ -160,8 +160,8 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 	int i;
 	int err;
 
-	if (d->props.rc_key_map == NULL ||
-		d->props.rc_query == NULL ||
+	if (d->props.rc.legacy.rc_key_map == NULL ||
+		d->props.rc.legacy.rc_query == NULL ||
 		dvb_usb_disable_rc_polling)
 		return 0;
 
@@ -181,20 +181,20 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 	input_dev->setkeycode = dvb_usb_setkeycode;
 
 	/* set the bits for the keys */
-	deb_rc("key map size: %d\n", d->props.rc_key_map_size);
-	for (i = 0; i < d->props.rc_key_map_size; i++) {
+	deb_rc("key map size: %d\n", d->props.rc.legacy.rc_key_map_size);
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
 		deb_rc("setting bit for event %d item %d\n",
-			d->props.rc_key_map[i].keycode, i);
-		set_bit(d->props.rc_key_map[i].keycode, input_dev->keybit);
+			d->props.rc.legacy.rc_key_map[i].keycode, i);
+		set_bit(d->props.rc.legacy.rc_key_map[i].keycode, input_dev->keybit);
 	}
 
 	/* Start the remote-control polling. */
-	if (d->props.rc_interval < 40)
-		d->props.rc_interval = 100; /* default */
+	if (d->props.rc.legacy.rc_interval < 40)
+		d->props.rc.legacy.rc_interval = 100; /* default */
 
 	/* setting these two values to non-zero, we have to manage key repeats */
-	input_dev->rep[REP_PERIOD] = d->props.rc_interval;
-	input_dev->rep[REP_DELAY]  = d->props.rc_interval + 150;
+	input_dev->rep[REP_PERIOD] = d->props.rc.legacy.rc_interval;
+	input_dev->rep[REP_DELAY]  = d->props.rc.legacy.rc_interval + 150;
 
 	input_set_drvdata(input_dev, d);
 
@@ -208,8 +208,8 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 
 	INIT_DELAYED_WORK(&d->rc_query_work, dvb_usb_read_remote_control);
 
-	info("schedule remote query interval to %d msecs.", d->props.rc_interval);
-	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc_interval));
+	info("schedule remote query interval to %d msecs.", d->props.rc.legacy.rc_interval);
+	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc.legacy.rc_interval));
 
 	d->state |= DVB_USB_STATE_REMOTE;
 
@@ -234,7 +234,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 		u8 keybuf[5], u32 *event, int *state)
 {
 	int i;
-	struct ir_scancode *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 	switch (keybuf[0]) {
@@ -247,7 +247,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 				break;
 			}
 			/* See if we can match the raw key code. */
-			for (i = 0; i < d->props.rc_key_map_size; i++)
+			for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
 				if (rc5_custom(&keymap[i]) == keybuf[1] &&
 					rc5_data(&keymap[i]) == keybuf[3]) {
 					*event = keymap[i].keycode;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 832bbfd..76f9724 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -158,6 +158,25 @@ struct dvb_usb_adapter_properties {
 };
 
 /**
+ * struct dvb_rc_legacy - old properties of remote controller
+ * @rc_key_map: a hard-wired array of struct ir_scancode (NULL to disable
+ *  remote control handling).
+ * @rc_key_map_size: number of items in @rc_key_map.
+ * @rc_query: called to query an event event.
+ * @rc_interval: time in ms between two queries.
+ */
+struct dvb_rc_legacy {
+/* remote control properties */
+#define REMOTE_NO_KEY_PRESSED      0x00
+#define REMOTE_KEY_PRESSED         0x01
+#define REMOTE_KEY_REPEAT          0x02
+	struct ir_scancode  *rc_key_map;
+	int rc_key_map_size;
+	int (*rc_query) (struct dvb_usb_device *, u32 *, int *);
+	int rc_interval;
+};
+
+/**
  * struct dvb_usb_device_properties - properties of a dvb-usb-device
  * @usb_ctrl: which USB device-side controller is in use. Needed for firmware
  *  download.
@@ -175,11 +194,7 @@ struct dvb_usb_adapter_properties {
  * @identify_state: called to determine the state (cold or warm), when it
  *  is not distinguishable by the USB IDs.
  *
- * @rc_key_map: a hard-wired array of struct ir_scancode (NULL to disable
- *  remote control handling).
- * @rc_key_map_size: number of items in @rc_key_map.
- * @rc_query: called to query an event event.
- * @rc_interval: time in ms between two queries.
+ * @rc: remote controller properties
  *
  * @i2c_algo: i2c_algorithm if the device has I2CoverUSB.
  *
@@ -223,14 +238,9 @@ struct dvb_usb_device_properties {
 	int (*identify_state)   (struct usb_device *, struct dvb_usb_device_properties *,
 			struct dvb_usb_device_description **, int *);
 
-/* remote control properties */
-#define REMOTE_NO_KEY_PRESSED      0x00
-#define REMOTE_KEY_PRESSED         0x01
-#define REMOTE_KEY_REPEAT          0x02
-	struct ir_scancode  *rc_key_map;
-	int rc_key_map_size;
-	int (*rc_query) (struct dvb_usb_device *, u32 *, int *);
-	int rc_interval;
+	union {
+		struct dvb_rc_legacy legacy;
+	} rc;
 
 	struct i2c_algorithm *i2c_algo;
 
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 2528e06..774df88 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1075,8 +1075,8 @@ static struct ir_codes_dvb_usb_table_table keys_tables[] = {
 
 static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	struct ir_scancode *keymap = d->props.rc_key_map;
-	int keymap_size = d->props.rc_key_map_size;
+	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
+	int keymap_size = d->props.rc.legacy.rc_key_map_size;
 	u8 key[2];
 	struct i2c_msg msg = {
 		.addr = DW2102_RC_QUERY,
@@ -1185,13 +1185,13 @@ static int dw2102_load_firmware(struct usb_device *dev,
 		/* init registers */
 		switch (dev->descriptor.idProduct) {
 		case USB_PID_PROF_1100:
-			s6x0_properties.rc_key_map = ir_codes_tbs_table;
-			s6x0_properties.rc_key_map_size =
+			s6x0_properties.rc.legacy.rc_key_map = ir_codes_tbs_table;
+			s6x0_properties.rc.legacy.rc_key_map_size =
 					ARRAY_SIZE(ir_codes_tbs_table);
 			break;
 		case USB_PID_TEVII_S650:
-			dw2104_properties.rc_key_map = ir_codes_tevii_table;
-			dw2104_properties.rc_key_map_size =
+			dw2104_properties.rc.legacy.rc_key_map = ir_codes_tevii_table;
+			dw2104_properties.rc.legacy.rc_key_map_size =
 					ARRAY_SIZE(ir_codes_tevii_table);
 		case USB_PID_DW2104:
 			reset = 1;
@@ -1255,10 +1255,13 @@ static struct dvb_usb_device_properties dw2102_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw2102_serit_i2c_algo,
-	.rc_key_map = ir_codes_dw210x_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
-	.rc_interval = 150,
-	.rc_query = dw2102_rc_query,
+
+	.rc.legacy = {
+		.rc_key_map = ir_codes_dw210x_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
+		.rc_interval = 150,
+		.rc_query = dw2102_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x81,
 	/* parameter for the MPEG2-data transfer */
@@ -1306,10 +1309,12 @@ static struct dvb_usb_device_properties dw2104_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw2104_i2c_algo,
-	.rc_key_map = ir_codes_dw210x_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
-	.rc_interval = 150,
-	.rc_query = dw2102_rc_query,
+	.rc.legacy = {
+		.rc_key_map = ir_codes_dw210x_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
+		.rc_interval = 150,
+		.rc_query = dw2102_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x81,
 	/* parameter for the MPEG2-data transfer */
@@ -1353,10 +1358,12 @@ static struct dvb_usb_device_properties dw3101_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw3101_i2c_algo,
-	.rc_key_map = ir_codes_dw210x_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
-	.rc_interval = 150,
-	.rc_query = dw2102_rc_query,
+	.rc.legacy = {
+		.rc_key_map = ir_codes_dw210x_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
+		.rc_interval = 150,
+		.rc_query = dw2102_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x81,
 	/* parameter for the MPEG2-data transfer */
@@ -1396,10 +1403,12 @@ static struct dvb_usb_device_properties s6x0_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &s6x0_i2c_algo,
-	.rc_key_map = ir_codes_tevii_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_tevii_table),
-	.rc_interval = 150,
-	.rc_query = dw2102_rc_query,
+	.rc.legacy = {
+		.rc_key_map = ir_codes_tevii_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_tevii_table),
+		.rc_interval = 150,
+		.rc_query = dw2102_rc_query,
+	},
 
 	.generic_bulk_ctrl_endpoint = 0x81,
 	.num_adapters = 1,
@@ -1459,8 +1468,8 @@ static int dw2102_probe(struct usb_interface *intf,
 	/* fill only different fields */
 	p7500->firmware = "dvb-usb-p7500.fw";
 	p7500->devices[0] = d7500;
-	p7500->rc_key_map = ir_codes_tbs_table;
-	p7500->rc_key_map_size = ARRAY_SIZE(ir_codes_tbs_table);
+	p7500->rc.legacy.rc_key_map = ir_codes_tbs_table;
+	p7500->rc.legacy.rc_key_map_size = ARRAY_SIZE(ir_codes_tbs_table);
 	p7500->adapter->frontend_attach = prof_7500_frontend_attach;
 
 	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index 1e1cb6b..bdef1a1 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -69,7 +69,7 @@ static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 	int adap_enabled[M9206_MAX_ADAPTERS] = { 0 };
 
 	/* Remote controller init. */
-	if (d->props.rc_query) {
+	if (d->props.rc.legacy.rc_query) {
 		deb("Initialising remote control\n");
 		while (rc_seq->address) {
 			if ((ret = m920x_write(d->udev, M9206_CORE,
@@ -142,9 +142,9 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY, rc_state + 1, 1)) != 0)
 		goto unlock;
 
-	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (rc5_data(&d->props.rc_key_map[i]) == rc_state[1]) {
-			*event = d->props.rc_key_map[i].keycode;
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
+		if (rc5_data(&d->props.rc.legacy.rc_key_map[i]) == rc_state[1]) {
+			*event = d->props.rc.legacy.rc_key_map[i].keycode;
 
 			switch(rc_state[0]) {
 			case 0x80:
@@ -784,10 +784,12 @@ static struct dvb_usb_device_properties megasky_properties = {
 	.firmware = "dvb-usb-megasky-02.fw",
 	.download_firmware = m920x_firmware_download,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_megasky_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_megasky_table),
-	.rc_query         = m920x_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_megasky_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_megasky_table),
+		.rc_query         = m920x_rc_query,
+	},
 
 	.size_of_priv     = sizeof(struct m920x_state),
 
@@ -885,10 +887,12 @@ static struct dvb_usb_device_properties tvwalkertwin_properties = {
 	.firmware = "dvb-usb-tvwalkert.fw",
 	.download_firmware = m920x_firmware_download,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_tvwalkertwin_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_tvwalkertwin_table),
-	.rc_query         = m920x_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_tvwalkertwin_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_tvwalkertwin_table),
+		.rc_query         = m920x_rc_query,
+	},
 
 	.size_of_priv     = sizeof(struct m920x_state),
 
@@ -992,10 +996,12 @@ static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
 	.usb_ctrl = DEVICE_SPECIFIC,
 	.download_firmware = NULL,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_pinnacle310e_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_pinnacle310e_table),
-	.rc_query         = m920x_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_pinnacle310e_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_pinnacle310e_table),
+		.rc_query         = m920x_rc_query,
+	},
 
 	.size_of_priv     = sizeof(struct m920x_state),
 
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index b48e217..181f36a 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -195,10 +195,12 @@ static struct dvb_usb_device_properties nova_t_properties = {
 	.power_ctrl       = dibusb2_0_power_ctrl,
 	.read_mac_address = nova_t_read_mac_address,
 
-	.rc_interval      = 100,
-	.rc_key_map       = ir_codes_haupp_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_haupp_table),
-	.rc_query         = nova_t_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_key_map       = ir_codes_haupp_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_haupp_table),
+		.rc_query         = nova_t_rc_query,
+	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 6a2f9e2..6b22ec6 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -498,10 +498,12 @@ static struct dvb_usb_device_properties opera1_properties = {
 	.power_ctrl = opera1_power_ctrl,
 	.i2c_algo = &opera1_i2c_algo,
 
-	.rc_key_map = ir_codes_opera1_table,
-	.rc_key_map_size = ARRAY_SIZE(ir_codes_opera1_table),
-	.rc_interval = 200,
-	.rc_query = opera1_rc_query,
+	.rc.legacy = {
+		.rc_key_map = ir_codes_opera1_table,
+		.rc_key_map_size = ARRAY_SIZE(ir_codes_opera1_table),
+		.rc_interval = 200,
+		.rc_query = opera1_rc_query,
+	},
 	.read_mac_address = opera1_read_mac_address,
 	.generic_bulk_ctrl_endpoint = 0x00,
 	/* parameter for the MPEG2-data transfer */
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 7ea57a4..5c9f327 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -283,10 +283,12 @@ static struct dvb_usb_device_properties vp702x_properties = {
 	},
 	.read_mac_address = vp702x_read_mac_addr,
 
-	.rc_key_map       = ir_codes_vp702x_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp702x_table),
-	.rc_interval      = 400,
-	.rc_query         = vp702x_rc_query,
+	.rc.legacy = {
+		.rc_key_map       = ir_codes_vp702x_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp702x_table),
+		.rc_interval      = 400,
+		.rc_query         = vp702x_rc_query,
+	},
 
 	.num_device_descs = 1,
 	.devices = {
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 30663a8..f13791c 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -259,10 +259,12 @@ static struct dvb_usb_device_properties vp7045_properties = {
 	.power_ctrl       = vp7045_power_ctrl,
 	.read_mac_address = vp7045_read_mac_addr,
 
-	.rc_interval      = 400,
-	.rc_key_map       = ir_codes_vp7045_table,
-	.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp7045_table),
-	.rc_query         = vp7045_rc_query,
+	.rc.legacy = {
+		.rc_interval      = 400,
+		.rc_key_map       = ir_codes_vp7045_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp7045_table),
+		.rc_query         = vp7045_rc_query,
+	},
 
 	.num_device_descs = 2,
 	.devices = {
-- 
1.7.1


