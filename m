Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab0KQTNa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:13:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJDUur029725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:13:30 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xJ007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:13:08 -0500
Date: Wed, 17 Nov 2010 17:08:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/10] [media] rc: Rename remote controller type to rc_type
 instead of ir_type
Message-ID: <20101117170829.4156c752@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

for i in `find drivers/staging -type f -name *.[ch]` `find include/media -type f -name *.[ch]` `find drivers/media -type f -name *.[ch]`; do sed s,IR_TYPE,RC_TYPE,g <$i >a && mv a $i; done
for i in `find drivers/staging -type f -name *.[ch]` `find include/media -type f -name *.[ch]` `find drivers/media -type f -name *.[ch]`; do sed s,ir_type,rc_type,g <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index bc2a6e4..8671ca3 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1344,11 +1344,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = IR_TYPE_NEC,
+			.protocol         = RC_TYPE_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1472,11 +1472,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = IR_TYPE_NEC,
+			.protocol         = RC_TYPE_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1584,11 +1584,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = IR_TYPE_NEC,
+			.protocol         = RC_TYPE_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 5e12488..6b402e9 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -476,7 +476,7 @@ static struct dvb_usb_device_properties anysee_properties = {
 
 	.rc.core = {
 		.rc_codes         = RC_MAP_ANYSEE,
-		.protocol         = IR_TYPE_OTHER,
+		.protocol         = RC_TYPE_OTHER,
 		.module_name      = "anysee",
 		.rc_query         = anysee_rc_query,
 		.rc_interval      = 250,  /* windows driver uses 500ms */
diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index 1e7d780..3537d65 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -60,7 +60,7 @@ extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold);
-extern int dib0700_change_protocol(struct rc_dev *dev, u64 ir_type);
+extern int dib0700_change_protocol(struct rc_dev *dev, u64 rc_type);
 
 extern int dib0700_device_count;
 extern int dvb_usb_dib0700_ir_proto;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 1dd119e..8ca48f7 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -471,7 +471,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return dib0700_ctrl_wr(adap->dev, b, 4);
 }
 
-int dib0700_change_protocol(struct rc_dev *rc, u64 ir_type)
+int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct dvb_usb_device *d = rc->priv;
 	struct dib0700_state *st = d->priv;
@@ -479,11 +479,11 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 ir_type)
 	int new_proto, ret;
 
 	/* Set the IR mode */
-	if (ir_type == IR_TYPE_RC5)
+	if (rc_type == RC_TYPE_RC5)
 		new_proto = 1;
-	else if (ir_type == IR_TYPE_NEC)
+	else if (rc_type == RC_TYPE_NEC)
 		new_proto = 0;
-	else if (ir_type == IR_TYPE_RC6) {
+	else if (rc_type == RC_TYPE_RC6) {
 		if (st->fw_version < 0x10200)
 			return -EINVAL;
 
@@ -499,7 +499,7 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 ir_type)
 		return ret;
 	}
 
-	d->props.rc.core.protocol = ir_type;
+	d->props.rc.core.protocol = rc_type;
 
 	return ret;
 }
@@ -562,7 +562,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
-	case IR_TYPE_NEC:
+	case RC_TYPE_NEC:
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 9ac920d..defd839 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -510,7 +510,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 
 	d->last_event = 0;
 	switch (d->props.rc.core.protocol) {
-	case IR_TYPE_NEC:
+	case RC_TYPE_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
 		    (key[3] == 0xff))
@@ -1924,9 +1924,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -1958,9 +1958,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2017,9 +2017,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2059,9 +2059,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2135,9 +2135,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2179,9 +2179,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2247,9 +2247,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2294,9 +2294,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2363,9 +2363,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2399,9 +2399,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2467,9 +2467,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2511,9 +2511,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2560,9 +2560,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2597,9 +2597,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = IR_TYPE_RC5 |
-					    IR_TYPE_RC6 |
-					    IR_TYPE_NEC,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	},
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 18828cb..95b1603 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -190,7 +190,7 @@ struct dvb_rc {
 	char *rc_codes;
 	u64 protocol;
 	u64 allowed_protos;
-	int (*change_protocol)(struct rc_dev *dev, u64 ir_type);
+	int (*change_protocol)(struct rc_dev *dev, u64 rc_type);
 	char *module_name;
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index e030b18..cf5f8ca 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -99,7 +99,7 @@ static struct rc_keymap ir_mantis_map = {
 	.map = {
 		.scan = mantis_ir_table,
 		.size = ARRAY_SIZE(mantis_ir_table),
-		.ir_type = IR_TYPE_UNKNOWN,
+		.rc_type = RC_TYPE_UNKNOWN,
 		.name = RC_MAP_MANTIS,
 	}
 };
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index ebd7305..37bc5c4 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protos = IR_TYPE_ALL;
+	dev->allowed_protos = RC_TYPE_ALL;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 1ace458..80b3c31 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1052,7 +1052,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = IR_TYPE_ALL;
+	rdev->allowed_protos = RC_TYPE_ALL;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index d67573e..de9dc0e 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -131,7 +131,7 @@ struct imon_context {
 	u32 last_keycode;		/* last reported input keycode */
 	u32 rc_scancode;		/* the computed remote scancode */
 	u8 rc_toggle;			/* the computed remote toggle bit */
-	u64 ir_type;			/* iMON or MCE (RC6) IR protocol? */
+	u64 rc_type;			/* iMON or MCE (RC6) IR protocol? */
 	bool release_code;		/* some keys send a release code */
 
 	u8 display_type;		/* store the display type */
@@ -983,7 +983,7 @@ static void imon_touch_display_timeout(unsigned long data)
  * really just RC-6), but only one or the other at a time, as the signals
  * are decoded onboard the receiver.
  */
-static int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
+static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	int retval;
 	struct imon_context *ictx = rc->priv;
@@ -992,18 +992,18 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (ir_type && !(ir_type & rc->allowed_protos))
+	if (rc_type && !(rc_type & rc->allowed_protos))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
-	switch (ir_type) {
-	case IR_TYPE_RC6:
+	switch (rc_type) {
+	case RC_TYPE_RC6:
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
 		pad_mouse = false;
 		break;
-	case IR_TYPE_UNKNOWN:
-	case IR_TYPE_OTHER:
+	case RC_TYPE_UNKNOWN:
+	case RC_TYPE_OTHER:
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
 		if (pad_stabilize && !nomouse)
 			pad_mouse = true;
@@ -1012,7 +1012,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 			pad_mouse = false;
 		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		ir_type = IR_TYPE_OTHER;
+		rc_type = RC_TYPE_OTHER;
 		break;
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
@@ -1024,7 +1024,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 			pad_mouse = false;
 		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		ir_type = IR_TYPE_OTHER;
+		rc_type = RC_TYPE_OTHER;
 		break;
 	}
 
@@ -1034,7 +1034,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
 	if (retval)
 		goto out;
 
-	ictx->ir_type = ir_type;
+	ictx->rc_type = rc_type;
 	ictx->pad_mouse = pad_mouse;
 
 out:
@@ -1306,7 +1306,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->ir_type == IR_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1373,7 +1373,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->ir_type == IR_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1495,7 +1495,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		kc = imon_panel_key_lookup(scancode);
 	} else {
 		scancode = be32_to_cpu(*((u32 *)buf));
-		if (ictx->ir_type == IR_TYPE_RC6) {
+		if (ictx->rc_type == RC_TYPE_RC6) {
 			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
@@ -1709,7 +1709,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = IR_TYPE_OTHER;
+	u64 allowed_protos = RC_TYPE_OTHER;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -1738,13 +1738,13 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x9e:
 		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		allowed_protos = IR_TYPE_RC6;
+		allowed_protos = RC_TYPE_RC6;
 		break;
 	/* iMON LCD, MCE IR */
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		allowed_protos = IR_TYPE_RC6;
+		allowed_protos = RC_TYPE_RC6;
 		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, "
@@ -1757,7 +1757,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 
 	ictx->display_type = detected_display_type;
 	ictx->rdev->allowed_protos = allowed_protos;
-	ictx->ir_type = allowed_protos;
+	ictx->rc_type = allowed_protos;
 }
 
 static void imon_set_display_type(struct imon_context *ictx)
@@ -1836,10 +1836,10 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6; /* iMON PAD or MCE */
+	rdev->allowed_protos = RC_TYPE_OTHER | RC_TYPE_RC6; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
-	if (ictx->ir_type == IR_TYPE_RC6)
+	if (ictx->rc_type == RC_TYPE_RC6)
 		rdev->map_name = RC_MAP_IMON_MCE;
 	else
 		rdev->map_name = RC_MAP_IMON_PAD;
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 09c143f..624449a 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -46,7 +46,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->raw->enabled_protocols & IR_TYPE_JVC))
+	if (!(dev->raw->enabled_protocols & RC_TYPE_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -173,7 +173,7 @@ out:
 }
 
 static struct ir_raw_handler jvc_handler = {
-	.protocols	= IR_TYPE_JVC,
+	.protocols	= RC_TYPE_JVC,
 	.decode		= ir_jvc_decode,
 };
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index f9086c5..1e87ee8 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -34,7 +34,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->raw->enabled_protocols & IR_TYPE_LIRC))
+	if (!(dev->raw->enabled_protocols & RC_TYPE_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
@@ -373,7 +373,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 }
 
 static struct ir_raw_handler lirc_handler = {
-	.protocols	= IR_TYPE_LIRC,
+	.protocols	= RC_TYPE_LIRC,
 	.decode		= ir_lirc_decode,
 	.raw_register	= ir_lirc_register,
 	.raw_unregister	= ir_lirc_unregister,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 235d774..5d15c31 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -50,7 +50,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, not_address, command, not_command;
 
-	if (!(dev->raw->enabled_protocols & IR_TYPE_NEC))
+	if (!(dev->raw->enabled_protocols & RC_TYPE_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -190,7 +190,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= IR_TYPE_NEC,
+	.protocols	= RC_TYPE_NEC,
 	.decode		= ir_nec_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 779ab0d..ebdba55 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -51,7 +51,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & IR_TYPE_RC5))
+        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
                 return 0;
 
 	if (!is_timing_event(ev)) {
@@ -163,7 +163,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= IR_TYPE_RC5,
+	.protocols	= RC_TYPE_RC5,
 	.decode		= ir_rc5_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 5586bf2..90aa886 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -47,7 +47,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & IR_TYPE_RC5_SZ))
+        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5_SZ))
                 return 0;
 
 	if (!is_timing_event(ev)) {
@@ -127,7 +127,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_sz_handler = {
-	.protocols	= IR_TYPE_RC5_SZ,
+	.protocols	= RC_TYPE_RC5_SZ,
 	.decode		= ir_rc5_sz_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 88d9487..755dafa 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -81,7 +81,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 toggle;
 
-	if (!(dev->raw->enabled_protocols & IR_TYPE_RC6))
+	if (!(dev->raw->enabled_protocols & RC_TYPE_RC6))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -255,7 +255,7 @@ out:
 }
 
 static struct ir_raw_handler rc6_handler = {
-	.protocols	= IR_TYPE_RC6,
+	.protocols	= RC_TYPE_RC6,
 	.decode		= ir_rc6_decode,
 };
 
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 5292b89..a92de80 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -44,7 +44,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->raw->enabled_protocols & IR_TYPE_SONY))
+	if (!(dev->raw->enabled_protocols & RC_TYPE_SONY))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -156,7 +156,7 @@ out:
 }
 
 static struct ir_raw_handler sony_handler = {
-	.protocols	= IR_TYPE_SONY,
+	.protocols	= RC_TYPE_SONY,
 	.decode		= ir_sony_decode,
 };
 
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index b172831..0ea0aee 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -67,7 +67,7 @@ static struct rc_keymap adstech_dvb_t_pci_map = {
 	.map = {
 		.scan    = adstech_dvb_t_pci,
 		.size    = ARRAY_SIZE(adstech_dvb_t_pci),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ADSTECH_DVB_T_PCI,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index ddfee7f..b0ec1c8 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -46,7 +46,7 @@ static struct rc_keymap alink_dtu_m_map = {
 	.map = {
 		.scan    = alink_dtu_m,
 		.size    = ARRAY_SIZE(alink_dtu_m),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_ALINK_DTU_M,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index 30d7049..9bfe60e 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -71,7 +71,7 @@ static struct rc_keymap anysee_map = {
 	.map = {
 		.scan    = anysee,
 		.size    = ARRAY_SIZE(anysee),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_ANYSEE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 0ef2b56..a32840d 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -58,7 +58,7 @@ static struct rc_keymap apac_viewcomp_map = {
 	.map = {
 		.scan    = apac_viewcomp,
 		.size    = ARRAY_SIZE(apac_viewcomp),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_APAC_VIEWCOMP,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 2996e0a..f86bfb7 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -69,7 +69,7 @@ static struct rc_keymap asus_pc39_map = {
 	.map = {
 		.scan    = asus_pc39,
 		.size    = ARRAY_SIZE(asus_pc39),
-		.ir_type = IR_TYPE_RC5,
+		.rc_type = RC_TYPE_RC5,
 		.name    = RC_MAP_ASUS_PC39,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 8edfd29..0cefe1c 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -47,7 +47,7 @@ static struct rc_keymap ati_tv_wonder_hd_600_map = {
 	.map = {
 		.scan    = ati_tv_wonder_hd_600,
 		.size    = ARRAY_SIZE(ati_tv_wonder_hd_600),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ATI_TV_WONDER_HD_600,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index 12f0435..43525c8 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -53,7 +53,7 @@ static struct rc_keymap avermedia_a16d_map = {
 	.map = {
 		.scan    = avermedia_a16d,
 		.size    = ARRAY_SIZE(avermedia_a16d),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_A16D,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index 2a945b0..2d528ca 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -75,7 +75,7 @@ static struct rc_keymap avermedia_cardbus_map = {
 	.map = {
 		.scan    = avermedia_cardbus,
 		.size    = ARRAY_SIZE(avermedia_cardbus),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_CARDBUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index 39dde62..e45b67f 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -56,7 +56,7 @@ static struct rc_keymap avermedia_dvbt_map = {
 	.map = {
 		.scan    = avermedia_dvbt,
 		.size    = ARRAY_SIZE(avermedia_dvbt),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_DVBT,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index e4471fb..d5622c5 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -125,7 +125,7 @@ static struct rc_keymap avermedia_m135a_map = {
 	.map = {
 		.scan    = avermedia_m135a,
 		.size    = ARRAY_SIZE(avermedia_m135a),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_AVERMEDIA_M135A,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index cf8d457..b0e10be 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -73,7 +73,7 @@ static struct rc_keymap avermedia_m733a_rm_k6_map = {
 	.map = {
 		.scan    = avermedia_m733a_rm_k6,
 		.size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_AVERMEDIA_M733A_RM_K6,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 9ee6090..3348466 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -57,7 +57,7 @@ static struct rc_keymap avermedia_rm_ks_map = {
 	.map = {
 		.scan    = avermedia_rm_ks,
 		.size    = ARRAY_SIZE(avermedia_rm_ks),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_AVERMEDIA_RM_KS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index 21effd5..cfde54e 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -64,7 +64,7 @@ static struct rc_keymap avermedia_map = {
 	.map = {
 		.scan    = avermedia,
 		.size    = ARRAY_SIZE(avermedia),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 971c59d..ae58663 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -63,7 +63,7 @@ static struct rc_keymap avertv_303_map = {
 	.map = {
 		.scan    = avertv_303,
 		.size    = ARRAY_SIZE(avertv_303),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERTV_303,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index e087614..579fafe 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -80,7 +80,7 @@ static struct rc_keymap azurewave_ad_tu700_map = {
 	.map = {
 		.scan    = azurewave_ad_tu700,
 		.size    = ARRAY_SIZE(azurewave_ad_tu700),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_AZUREWAVE_AD_TU700,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 9f56c98..6abb712 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -86,7 +86,7 @@ static struct rc_keymap behold_columbus_map = {
 	.map = {
 		.scan    = behold_columbus,
 		.size    = ARRAY_SIZE(behold_columbus),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_BEHOLD_COLUMBUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index abc140b..5694185 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -119,7 +119,7 @@ static struct rc_keymap behold_map = {
 	.map = {
 		.scan    = behold,
 		.size    = ARRAY_SIZE(behold),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_BEHOLD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 64c2ac9..99f7323 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -70,7 +70,7 @@ static struct rc_keymap budget_ci_old_map = {
 	.map = {
 		.scan    = budget_ci_old,
 		.size    = ARRAY_SIZE(budget_ci_old),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_BUDGET_CI_OLD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 074f2c2..b504ddd 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -62,7 +62,7 @@ static struct rc_keymap cinergy_1400_map = {
 	.map = {
 		.scan    = cinergy_1400,
 		.size    = ARRAY_SIZE(cinergy_1400),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_CINERGY_1400,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index cf84c3d..8bf02f1 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -56,7 +56,7 @@ static struct rc_keymap cinergy_map = {
 	.map = {
 		.scan    = cinergy,
 		.size    = ARRAY_SIZE(cinergy),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_CINERGY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index ae18320..47d5476 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -102,7 +102,7 @@ static struct rc_keymap dib0700_nec_map = {
 	.map = {
 		.scan    = dib0700_nec_table,
 		.size    = ARRAY_SIZE(dib0700_nec_table),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_DIB0700_NEC_TABLE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 4a4797c..1d09921 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -213,7 +213,7 @@ static struct rc_keymap dib0700_rc5_map = {
 	.map = {
 		.scan    = dib0700_rc5_table,
 		.size    = ARRAY_SIZE(dib0700_rc5_table),
-		.ir_type = IR_TYPE_RC5,
+		.rc_type = RC_TYPE_RC5,
 		.name    = RC_MAP_DIB0700_RC5_TABLE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index 63e469e..8ae726b 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -76,7 +76,7 @@ static struct rc_keymap digitalnow_tinytwin_map = {
 	.map = {
 		.scan    = digitalnow_tinytwin,
 		.size    = ARRAY_SIZE(digitalnow_tinytwin),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_DIGITALNOW_TINYTWIN,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index 5dece78..206469f 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -60,7 +60,7 @@ static struct rc_keymap digittrade_map = {
 	.map = {
 		.scan    = digittrade,
 		.size    = ARRAY_SIZE(digittrade),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_DIGITTRADE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 90684d0..ba6fb0b 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -54,7 +54,7 @@ static struct rc_keymap dm1105_nec_map = {
 	.map = {
 		.scan    = dm1105_nec,
 		.size    = ARRAY_SIZE(dm1105_nec),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DM1105_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 8a4027a..b703937 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -56,7 +56,7 @@ static struct rc_keymap dntv_live_dvb_t_map = {
 	.map = {
 		.scan    = dntv_live_dvb_t,
 		.size    = ARRAY_SIZE(dntv_live_dvb_t),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DNTV_LIVE_DVB_T,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 6f4d607..b0126b2 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -75,7 +75,7 @@ static struct rc_keymap dntv_live_dvbt_pro_map = {
 	.map = {
 		.scan    = dntv_live_dvbt_pro,
 		.size    = ARRAY_SIZE(dntv_live_dvbt_pro),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DNTV_LIVE_DVBT_PRO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 3130c9c..57bcd55 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -47,7 +47,7 @@ static struct rc_keymap em_terratec_map = {
 	.map = {
 		.scan    = em_terratec,
 		.size    = ARRAY_SIZE(em_terratec),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EM_TERRATEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 4b81696..97e01f4 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -59,7 +59,7 @@ static struct rc_keymap encore_enltv_fm53_map = {
 	.map = {
 		.scan    = encore_enltv_fm53,
 		.size    = ARRAY_SIZE(encore_enltv_fm53),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV_FM53,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index 9fabffd..d3030cf 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -90,7 +90,7 @@ static struct rc_keymap encore_enltv_map = {
 	.map = {
 		.scan    = encore_enltv,
 		.size    = ARRAY_SIZE(encore_enltv),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index efefd51..1871b32 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -68,7 +68,7 @@ static struct rc_keymap encore_enltv2_map = {
 	.map = {
 		.scan    = encore_enltv2,
 		.size    = ARRAY_SIZE(encore_enltv2),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV2,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index 3f3fb13..192d7f8 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -39,7 +39,7 @@ static struct rc_keymap evga_indtube_map = {
 	.map = {
 		.scan    = evga_indtube,
 		.size    = ARRAY_SIZE(evga_indtube),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EVGA_INDTUBE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 660907a..fe3ab5e 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -74,7 +74,7 @@ static struct rc_keymap eztv_map = {
 	.map = {
 		.scan    = eztv,
 		.size    = ARRAY_SIZE(eztv),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EZTV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index a173c81..f48249e 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -55,7 +55,7 @@ static struct rc_keymap flydvb_map = {
 	.map = {
 		.scan    = flydvb,
 		.size    = ARRAY_SIZE(flydvb),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FLYDVB,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index 9c73043..59713fb 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -48,7 +48,7 @@ static struct rc_keymap flyvideo_map = {
 	.map = {
 		.scan    = flyvideo,
 		.size    = ARRAY_SIZE(flyvideo),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FLYVIDEO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index cdb1038..e69458d 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -76,7 +76,7 @@ static struct rc_keymap fusionhdtv_mce_map = {
 	.map = {
 		.scan    = fusionhdtv_mce,
 		.size    = ARRAY_SIZE(fusionhdtv_mce),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FUSIONHDTV_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index c16c0d1..13587b8 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -59,7 +59,7 @@ static struct rc_keymap gadmei_rm008z_map = {
 	.map = {
 		.scan    = gadmei_rm008z,
 		.size    = ARRAY_SIZE(gadmei_rm008z),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GADMEI_RM008Z,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index 89f8e38..2304bf6 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -62,7 +62,7 @@ static struct rc_keymap genius_tvgo_a11mce_map = {
 	.map = {
 		.scan    = genius_tvgo_a11mce,
 		.size    = ARRAY_SIZE(genius_tvgo_a11mce),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GENIUS_TVGO_A11MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 52f025b..b5be7bf 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -57,7 +57,7 @@ static struct rc_keymap gotview7135_map = {
 	.map = {
 		.scan    = gotview7135,
 		.size    = ARRAY_SIZE(gotview7135),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GOTVIEW7135,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
index c6f8cd7..c60f845 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge-new.c
@@ -78,7 +78,7 @@ static struct rc_keymap hauppauge_new_map = {
 	.map = {
 		.scan    = hauppauge_new,
 		.size    = ARRAY_SIZE(hauppauge_new),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_HAUPPAUGE_NEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index e49f350..4ce902f 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -120,7 +120,7 @@ static struct rc_keymap imon_mce_map = {
 		.scan    = imon_mce,
 		.size    = ARRAY_SIZE(imon_mce),
 		/* its RC6, but w/a hardware decoder */
-		.ir_type = IR_TYPE_RC6,
+		.rc_type = RC_TYPE_RC6,
 		.name    = RC_MAP_IMON_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index bc4db72..6d4633a 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -134,7 +134,7 @@ static struct rc_keymap imon_pad_map = {
 		.scan    = imon_pad,
 		.size    = ARRAY_SIZE(imon_pad),
 		/* actual protocol details unknown, hardware decoder */
-		.ir_type = IR_TYPE_OTHER,
+		.rc_type = RC_TYPE_OTHER,
 		.name    = RC_MAP_IMON_PAD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index ef66002..c5208f1 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -66,7 +66,7 @@ static struct rc_keymap iodata_bctv7e_map = {
 	.map = {
 		.scan    = iodata_bctv7e,
 		.size    = ARRAY_SIZE(iodata_bctv7e),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_IODATA_BCTV7E,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 4c7883b..1b6da7f 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -65,7 +65,7 @@ static struct rc_keymap kaiomy_map = {
 	.map = {
 		.scan    = kaiomy,
 		.size    = ARRAY_SIZE(kaiomy),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_KAIOMY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index 618c817..3418e07 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -61,7 +61,7 @@ static struct rc_keymap kworld_315u_map = {
 	.map = {
 		.scan    = kworld_315u,
 		.size    = ARRAY_SIZE(kworld_315u),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_KWORLD_315U,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 366732f..4d681eb 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -77,7 +77,7 @@ static struct rc_keymap kworld_plus_tv_analog_map = {
 	.map = {
 		.scan    = kworld_plus_tv_analog,
 		.size    = ARRAY_SIZE(kworld_plus_tv_analog),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_KWORLD_PLUS_TV_ANALOG,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index 7521315..ebdd122 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -77,7 +77,7 @@ static struct rc_keymap leadtek_y04g0051_map = {
 	.map = {
 		.scan    = leadtek_y04g0051,
 		.size    = ARRAY_SIZE(leadtek_y04g0051),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_LEADTEK_Y04G0051,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index 9c8577d..6d8a641 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -19,7 +19,7 @@ static struct rc_keymap lirc_map = {
 	.map = {
 		.scan    = lirc,
 		.size    = ARRAY_SIZE(lirc),
-		.ir_type = IR_TYPE_LIRC,
+		.rc_type = RC_TYPE_LIRC,
 		.name    = RC_MAP_LIRC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 40dcf0b..ca7e2ac 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -46,7 +46,7 @@ static struct rc_keymap lme2510_map = {
 	.map = {
 		.scan    = lme2510_rc,
 		.size    = ARRAY_SIZE(lme2510_rc),
-		.ir_type = IR_TYPE_UNKNOWN,
+		.rc_type = RC_TYPE_UNKNOWN,
 		.name    = RC_MAP_LME2510,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index 0f590b3..056cf52 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -112,7 +112,7 @@ static struct rc_keymap manli_map = {
 	.map = {
 		.scan    = manli,
 		.size    = ARRAY_SIZE(manli),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MANLI,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index 67237fb..3a14d31 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -45,7 +45,7 @@ static struct rc_keymap msi_digivox_ii_map = {
 	.map = {
 		.scan    = msi_digivox_ii,
 		.size    = ARRAY_SIZE(msi_digivox_ii),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_MSI_DIGIVOX_II,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index 882056e..16c5b0a 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -63,7 +63,7 @@ static struct rc_keymap msi_digivox_iii_map = {
 	.map = {
 		.scan    = msi_digivox_iii,
 		.size    = ARRAY_SIZE(msi_digivox_iii),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_MSI_DIGIVOX_III,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index eb8e42c..d4c9102 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -101,7 +101,7 @@ static struct rc_keymap msi_tvanywhere_plus_map = {
 	.map = {
 		.scan    = msi_tvanywhere_plus,
 		.size    = ARRAY_SIZE(msi_tvanywhere_plus),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MSI_TVANYWHERE_PLUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index ef41185..aec064c 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -47,7 +47,7 @@ static struct rc_keymap msi_tvanywhere_map = {
 	.map = {
 		.scan    = msi_tvanywhere,
 		.size    = ARRAY_SIZE(msi_tvanywhere),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MSI_TVANYWHERE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index ccc50eb..2c44b90 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -74,7 +74,7 @@ static struct rc_keymap nebula_map = {
 	.map = {
 		.scan    = nebula,
 		.size    = ARRAY_SIZE(nebula),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NEBULA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index e1b54d2..929084b 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -83,7 +83,7 @@ static struct rc_keymap nec_terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = nec_terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(nec_terratec_cinergy_xs),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index e5849a6..7fe7746 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -63,7 +63,7 @@ static struct rc_keymap norwood_map = {
 	.map = {
 		.scan    = norwood,
 		.size    = ARRAY_SIZE(norwood),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NORWOOD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index b9ece1e..a9cbcde 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -58,7 +58,7 @@ static struct rc_keymap npgtech_map = {
 	.map = {
 		.scan    = npgtech,
 		.size    = ARRAY_SIZE(npgtech),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NPGTECH,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 4129bb4..68b33b3 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -58,7 +58,7 @@ static struct rc_keymap pctv_sedna_map = {
 	.map = {
 		.scan    = pctv_sedna,
 		.size    = ARRAY_SIZE(pctv_sedna),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PCTV_SEDNA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index 326e023..364ccde 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -72,7 +72,7 @@ static struct rc_keymap pinnacle_color_map = {
 	.map = {
 		.scan    = pinnacle_color,
 		.size    = ARRAY_SIZE(pinnacle_color),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_COLOR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 14cb772..993eff7 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -67,7 +67,7 @@ static struct rc_keymap pinnacle_grey_map = {
 	.map = {
 		.scan    = pinnacle_grey,
 		.size    = ARRAY_SIZE(pinnacle_grey),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_GREY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index 835bf4e..56e6a7e 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -51,7 +51,7 @@ static struct rc_keymap pinnacle_pctv_hd_map = {
 	.map = {
 		.scan    = pinnacle_pctv_hd,
 		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_PCTV_HD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 5a735d5..84f89eb 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -61,7 +61,7 @@ static struct rc_keymap pixelview_map = {
 	.map = {
 		.scan    = pixelview_mk12,
 		.size    = ARRAY_SIZE(pixelview_mk12),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_PIXELVIEW_MK12,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index 7bbbbf5..703f86b 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -61,7 +61,7 @@ static struct rc_keymap pixelview_new_map = {
 	.map = {
 		.scan    = pixelview_new,
 		.size    = ARRAY_SIZE(pixelview_new),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PIXELVIEW_NEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 82ff12e..5a50aa7 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -60,7 +60,7 @@ static struct rc_keymap pixelview_map = {
 	.map = {
 		.scan    = pixelview,
 		.size    = ARRAY_SIZE(pixelview),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PIXELVIEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index 7cef819..4eec437 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -59,7 +59,7 @@ static struct rc_keymap powercolor_real_angel_map = {
 	.map = {
 		.scan    = powercolor_real_angel,
 		.size    = ARRAY_SIZE(powercolor_real_angel),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_POWERCOLOR_REAL_ANGEL,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index 22e92d3..802c58a 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -47,7 +47,7 @@ static struct rc_keymap proteus_2309_map = {
 	.map = {
 		.scan    = proteus_2309,
 		.size    = ARRAY_SIZE(proteus_2309),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PROTEUS_2309,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 4e20fc2..f3e9709 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -59,7 +59,7 @@ static struct rc_keymap purpletv_map = {
 	.map = {
 		.scan    = purpletv,
 		.size    = ARRAY_SIZE(purpletv),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PURPLETV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 36679e7..e301ff0 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -56,7 +56,7 @@ static struct rc_keymap pv951_map = {
 	.map = {
 		.scan    = pv951,
 		.size    = ARRAY_SIZE(pv951),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PV951,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index cc6b8f5..91bcab8 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -81,7 +81,7 @@ static struct rc_keymap rc5_hauppauge_new_map = {
 	.map = {
 		.scan    = rc5_hauppauge_new,
 		.size    = ARRAY_SIZE(rc5_hauppauge_new),
-		.ir_type = IR_TYPE_RC5,
+		.rc_type = RC_TYPE_RC5,
 		.name    = RC_MAP_RC5_HAUPPAUGE_NEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-rc5-tv.c b/drivers/media/rc/keymaps/rc-rc5-tv.c
index 73cce2f..cda2a2f 100644
--- a/drivers/media/rc/keymaps/rc-rc5-tv.c
+++ b/drivers/media/rc/keymaps/rc-rc5-tv.c
@@ -59,7 +59,7 @@ static struct rc_keymap rc5_tv_map = {
 	.map = {
 		.scan    = rc5_tv,
 		.size    = ARRAY_SIZE(rc5_tv),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_RC5_TV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 6da955d..f926477 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -91,7 +91,7 @@ static struct rc_keymap rc6_mce_map = {
 	.map = {
 		.scan    = rc6_mce,
 		.size    = ARRAY_SIZE(rc6_mce),
-		.ir_type = IR_TYPE_RC6,
+		.rc_type = RC_TYPE_RC6,
 		.name    = RC_MAP_RC6_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index ab1a6d2..6781426 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -56,7 +56,7 @@ static struct rc_keymap real_audio_220_32_keys_map = {
 	.map = {
 		.scan    = real_audio_220_32_keys,
 		.size    = ARRAY_SIZE(real_audio_220_32_keys),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_REAL_AUDIO_220_32_KEYS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index df32013..bafe5b8 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -60,7 +60,7 @@ static struct rc_keymap streamzap_map = {
 	.map = {
 		.scan    = streamzap,
 		.size    = ARRAY_SIZE(streamzap),
-		.ir_type = IR_TYPE_RC5_SZ,
+		.rc_type = RC_TYPE_RC5_SZ,
 		.name    = RC_MAP_STREAMZAP,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 3309631..4ef4f81 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -51,7 +51,7 @@ static struct rc_keymap tbs_nec_map = {
 	.map = {
 		.scan    = tbs_nec,
 		.size    = ARRAY_SIZE(tbs_nec),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TBS_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 5326a0b..4064a32 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -70,7 +70,7 @@ static struct rc_keymap terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(terratec_cinergy_xs),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TERRATEC_CINERGY_XS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 10dee4c..c23caf7 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -57,7 +57,7 @@ static struct rc_keymap terratec_slim_map = {
 	.map = {
 		.scan    = terratec_slim,
 		.size    = ARRAY_SIZE(terratec_slim),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_TERRATEC_SLIM,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index e30d411..eabfb70 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -66,7 +66,7 @@ static struct rc_keymap tevii_nec_map = {
 	.map = {
 		.scan    = tevii_nec,
 		.size    = ARRAY_SIZE(tevii_nec),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TEVII_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index fd19857..cd39b3d 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -63,7 +63,7 @@ static struct rc_keymap total_media_in_hand_map = {
 	.map = {
 		.scan    = total_media_in_hand,
 		.size    = ARRAY_SIZE(total_media_in_hand),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_TOTAL_MEDIA_IN_HAND,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index 91092ca..31d6c6c 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -58,7 +58,7 @@ static struct rc_keymap trekstor_map = {
 	.map = {
 		.scan    = trekstor,
 		.size    = ARRAY_SIZE(trekstor),
-		.ir_type = IR_TYPE_NEC,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_TREKSTOR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index bc88de0..45a0608 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -60,7 +60,7 @@ static struct rc_keymap tt_1500_map = {
 	.map = {
 		.scan    = tt_1500,
 		.size    = ARRAY_SIZE(tt_1500),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TT_1500,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 0b5d356..b5def53 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -65,7 +65,7 @@ static struct rc_keymap twinhan_vp1027_map = {
 	.map = {
 		.scan    = twinhan_vp1027,
 		.size    = ARRAY_SIZE(twinhan_vp1027),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TWINHAN_VP1027_DVBS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 4df7fcd..7c422b4 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -63,7 +63,7 @@ static struct rc_keymap videomate_s350_map = {
 	.map = {
 		.scan    = videomate_s350,
 		.size    = ARRAY_SIZE(videomate_s350),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_VIDEOMATE_S350,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 776b0a6..4d31b47 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -65,7 +65,7 @@ static struct rc_keymap videomate_tv_pvr_map = {
 	.map = {
 		.scan    = videomate_tv_pvr,
 		.size    = ARRAY_SIZE(videomate_tv_pvr),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_VIDEOMATE_TV_PVR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 9d2d550..ade3c14 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -60,7 +60,7 @@ static struct rc_keymap winfast_usbii_deluxe_map = {
 	.map = {
 		.scan    = winfast_usbii_deluxe,
 		.size    = ARRAY_SIZE(winfast_usbii_deluxe),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_WINFAST_USBII_DELUXE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 0e90a3b..502b5f5 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -80,7 +80,7 @@ static struct rc_keymap winfast_map = {
 	.map = {
 		.scan    = winfast,
 		.size    = ARRAY_SIZE(winfast),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_WINFAST,
 	}
 };
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 057e6c6..ef9bddc 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1055,7 +1055,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->input_phys = ir->phys;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = IR_TYPE_ALL;
+	rc->allowed_protos = RC_TYPE_ALL;
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index bf3f58f..7fca6d1 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1060,7 +1060,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = IR_TYPE_ALL;
+	rdev->allowed_protos = RC_TYPE_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 11e2703..f3244eb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -102,7 +102,7 @@ static struct rc_keymap empty_map = {
 	.map = {
 		.scan    = empty,
 		.size    = ARRAY_SIZE(empty),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EMPTY,
 	}
 };
@@ -111,7 +111,7 @@ static struct rc_keymap empty_map = {
  * ir_create_table() - initializes a scancode table
  * @rc_tab:	the ir_scancode_table to initialize
  * @name:	name to assign to the table
- * @ir_type:	ir type to assign to the new table
+ * @rc_type:	ir type to assign to the new table
  * @size:	initial size of the table
  * @return:	zero on success or a negative error code
  *
@@ -119,10 +119,10 @@ static struct rc_keymap empty_map = {
  * memory to hold at least the specified number of elements.
  */
 static int ir_create_table(struct ir_scancode_table *rc_tab,
-			   const char *name, u64 ir_type, size_t size)
+			   const char *name, u64 rc_type, size_t size)
 {
 	rc_tab->name = name;
-	rc_tab->ir_type = ir_type;
+	rc_tab->rc_type = rc_type;
 	rc_tab->alloc = roundup_pow_of_two(size * sizeof(struct ir_scancode));
 	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
 	rc_tab->scan = kmalloc(rc_tab->alloc, GFP_KERNEL);
@@ -372,7 +372,7 @@ static int ir_setkeytable(struct rc_dev *dev,
 	int rc;
 
 	rc = ir_create_table(rc_tab, from->name,
-			     from->ir_type, from->size);
+			     from->rc_type, from->size);
 	if (rc)
 		return rc;
 
@@ -719,14 +719,14 @@ static struct {
 	u64	type;
 	char	*name;
 } proto_names[] = {
-	{ IR_TYPE_UNKNOWN,	"unknown"	},
-	{ IR_TYPE_RC5,		"rc-5"		},
-	{ IR_TYPE_NEC,		"nec"		},
-	{ IR_TYPE_RC6,		"rc-6"		},
-	{ IR_TYPE_JVC,		"jvc"		},
-	{ IR_TYPE_SONY,		"sony"		},
-	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
-	{ IR_TYPE_LIRC,		"lirc"		},
+	{ RC_TYPE_UNKNOWN,	"unknown"	},
+	{ RC_TYPE_RC5,		"rc-5"		},
+	{ RC_TYPE_NEC,		"nec"		},
+	{ RC_TYPE_RC6,		"rc-6"		},
+	{ RC_TYPE_JVC,		"jvc"		},
+	{ RC_TYPE_SONY,		"sony"		},
+	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
+	{ RC_TYPE_LIRC,		"lirc"		},
 };
 
 #define PROTO_NONE	"none"
@@ -755,7 +755,7 @@ static ssize_t show_protocols(struct device *device,
 		return -EINVAL;
 
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = dev->rc_tab.ir_type;
+		enabled = dev->rc_tab.rc_type;
 		allowed = dev->allowed_protos;
 	} else {
 		enabled = dev->raw->enabled_protocols;
@@ -813,7 +813,7 @@ static ssize_t store_protocols(struct device *device,
 		return -EINVAL;
 
 	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		type = dev->rc_tab.ir_type;
+		type = dev->rc_tab.rc_type;
 	else if (dev->raw)
 		type = dev->raw->enabled_protocols;
 	else {
@@ -881,7 +881,7 @@ static ssize_t store_protocols(struct device *device,
 
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		spin_lock_irqsave(&dev->rc_tab.lock, flags);
-		dev->rc_tab.ir_type = type;
+		dev->rc_tab.rc_type = type;
 		spin_unlock_irqrestore(&dev->rc_tab.lock, flags);
 	} else {
 		dev->raw->enabled_protocols = type;
@@ -1052,7 +1052,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	if (dev->change_protocol) {
-		rc = dev->change_protocol(dev, rc_tab->ir_type);
+		rc = dev->change_protocol(dev, rc_tab->rc_type);
 		if (rc < 0)
 			goto out_raw;
 	}
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index f72d670..53733e1 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -320,7 +320,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->input_phys = sz->phys;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = IR_TYPE_ALL;
+	rdev->allowed_protos = RC_TYPE_ALL;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index a09caf8..678cf8c 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -98,7 +98,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = IR_TYPE_RC5;
+		init_data->type = RC_TYPE_RC5;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 1d043ed..c236a4e 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -84,7 +84,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
 	dev->init_data.rc_dev->scanmask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
-	dev->init_data.type = IR_TYPE_NEC;
+	dev->init_data.type = RC_TYPE_NEC;
 	info.addr = 0x30;
 
 	/* Load and bind ir-kbd-i2c */
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index e824ba6..0b0d066 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -264,14 +264,14 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = IR_TYPE_ALL;
+		allowed_protos = RC_TYPE_ALL;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_RC5_HAUPPAUGE_NEW;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = IR_TYPE_ALL;
+		allowed_protos = RC_TYPE_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index cfeba4c..4a3bf54 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -241,7 +241,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	struct cx88_IR *ir;
 	struct rc_dev *dev;
 	char *ir_codes = NULL;
-	u64 ir_type = IR_TYPE_OTHER;
+	u64 rc_type = RC_TYPE_OTHER;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
 				 * used with a full-code IR table
@@ -404,7 +404,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
-		ir_type          = IR_TYPE_NEC;
+		rc_type          = RC_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	}
@@ -457,7 +457,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
 	} else {
 		dev->driver_type = RC_DRIVER_SCANCODE;
-		dev->allowed_protos = ir_type;
+		dev->allowed_protos = rc_type;
 	}
 
 	ir->core = core;
@@ -557,7 +557,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
-			core->init_data.type = IR_TYPE_RC5;
+			core->init_data.type = RC_TYPE_RC5;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index e32eb38..29cc744 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -343,7 +343,7 @@ static void em28xx_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 ir_type)
+int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 {
 	int rc = 0;
 	struct em28xx_IR *ir = rc_dev->priv;
@@ -352,14 +352,14 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 ir_type)
 
 	/* Adjust xclk based o IR table for RC5/NEC tables */
 
-	if (ir_type == IR_TYPE_RC5) {
+	if (rc_type == RC_TYPE_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-	} else if (ir_type == IR_TYPE_NEC) {
+	} else if (rc_type == RC_TYPE_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC;
 		ir->full_code = 1;
-	} else if (ir_type != IR_TYPE_UNKNOWN)
+	} else if (rc_type != RC_TYPE_UNKNOWN)
 		rc = -EINVAL;
 
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
@@ -408,14 +408,14 @@ int em28xx_ir_init(struct em28xx *dev)
 	 * em2874 supports more protocols. For now, let's just announce
 	 * the two protocols that were already tested
 	 */
-	rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
 	rc->priv = ir;
 	rc->change_protocol = em28xx_ir_change_protocol;
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
 	/* By default, keep protocol field untouched */
-	err = em28xx_ir_change_protocol(rc, IR_TYPE_UNKNOWN);
+	err = em28xx_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index c77ea53..dd54c3d 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -269,7 +269,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 ir_type = IR_TYPE_UNKNOWN;
+	u64 rc_type = RC_TYPE_UNKNOWN;
 	struct IR_i2c *ir;
 	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
@@ -288,7 +288,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x64:
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
-		ir_type     = IR_TYPE_OTHER;
+		rc_type     = RC_TYPE_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x18:
@@ -296,7 +296,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
-		ir_type     = IR_TYPE_RC5;
+		rc_type     = RC_TYPE_RC5;
 		if (hauppauge == 1) {
 			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
 		} else {
@@ -306,19 +306,19 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
-		ir_type     = IR_TYPE_OTHER;
+		rc_type     = RC_TYPE_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		ir_type     = IR_TYPE_RC5;
+		rc_type     = RC_TYPE_RC5;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-		ir_type     = IR_TYPE_OTHER;
+		rc_type     = RC_TYPE_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	}
@@ -333,7 +333,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		name = init_data->name;
 		if (init_data->type)
-			ir_type = init_data->type;
+			rc_type = init_data->type;
 
 		if (init_data->polling_interval)
 			ir->polling_interval = init_data->polling_interval;
@@ -378,7 +378,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir->rc = rc;
 
 	/* Make sure we are all setup before going on */
-	if (!name || !ir->get_key || !ir_type || !ir_codes) {
+	if (!name || !ir->get_key || !rc_type || !ir_codes) {
 		dprintk(1, ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;
@@ -405,7 +405,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * Initialize the other fields of rc_dev
 	 */
 	rc->map_name       = ir->ir_codes;
-	rc->allowed_protos = ir_type;
+	rc->allowed_protos = rc_type;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 9e8039a..6656ac8 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -172,7 +172,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
-		init_data->type = IR_TYPE_OTHER;
+		init_data->type = RC_TYPE_OTHER;
 		init_data->name = "AVerMedia AVerTV card";
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
@@ -180,14 +180,14 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		/* Default to old black remote */
 		init_data->ir_codes = RC_MAP_RC5_TV;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type = IR_TYPE_RC5;
+		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = IR_TYPE_RC5;
+		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	}
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index cd39aea..f3f4aff 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -909,7 +909,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = IR_TYPE_NEC;
+		dev->init_data.type = RC_TYPE_NEC;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 02b9829..e02ea67 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -65,7 +65,7 @@ struct tm6000_IR {
 	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
 
 	/* IR device properties */
-	u64			ir_type;
+	u64			rc_type;
 };
 
 
@@ -143,7 +143,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		return 0;
 
 	if (&dev->int_in) {
-		if (ir->ir_type == IR_TYPE_RC5)
+		if (ir->rc_type == RC_TYPE_RC5)
 			poll_result->rc_data = ir->urb_data[0];
 		else
 			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
@@ -153,7 +153,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
 		msleep(10);
 
-		if (ir->ir_type == IR_TYPE_RC5) {
+		if (ir->rc_type == RC_TYPE_RC5) {
 			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
 				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				REQ_02_GET_IR_CODE, 0, 0, buf, 1);
@@ -230,7 +230,7 @@ static void tm6000_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-int tm6000_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
+int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct tm6000_IR *ir = rc->priv;
 
@@ -268,7 +268,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input einrichten */
-	rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
 	rc->open = tm6000_ir_start;
@@ -283,7 +283,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	tm6000_ir_change_protocol(rc, IR_TYPE_UNKNOWN);
+	tm6000_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
 
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index f22b359..768aa77 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -37,7 +37,7 @@ enum ir_kbd_get_key_fn {
 struct IR_i2c_init_data {
 	char			*ir_codes;
 	const char		*name;
-	u64			type; /* IR_TYPE_RC5, etc */
+	u64			type; /* RC_TYPE_RC5, etc */
 	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
 
 	/*
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 170581b..4254325 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -45,7 +45,7 @@ enum rc_driver_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software 
  * @idle: used to keep track of RX state
- * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
+ * @allowed_protos: bitmask with the supported RC_TYPE_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
@@ -107,7 +107,7 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
-	int				(*change_protocol)(struct rc_dev *dev, u64 ir_type);
+	int				(*change_protocol)(struct rc_dev *dev, u64 rc_type);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
 	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e0f17ed..c53351e 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -11,19 +11,19 @@
 
 #include <linux/input.h>
 
-#define IR_TYPE_UNKNOWN	0
-#define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define IR_TYPE_NEC	(1  << 1)
-#define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
-#define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
-#define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
-#define IR_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
-#define IR_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
-#define IR_TYPE_OTHER	(1u << 31)
+#define RC_TYPE_UNKNOWN	0
+#define RC_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
+#define RC_TYPE_NEC	(1  << 1)
+#define RC_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
+#define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
+#define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
+#define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
+#define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
+#define RC_TYPE_OTHER	(1u << 31)
 
-#define IR_TYPE_ALL (IR_TYPE_RC5 | IR_TYPE_NEC  | IR_TYPE_RC6  | \
-		     IR_TYPE_JVC | IR_TYPE_SONY | IR_TYPE_LIRC | \
-		     IR_TYPE_RC5_SZ | IR_TYPE_OTHER)
+#define RC_TYPE_ALL (RC_TYPE_RC5 | RC_TYPE_NEC  | RC_TYPE_RC6  | \
+		     RC_TYPE_JVC | RC_TYPE_SONY | RC_TYPE_LIRC | \
+		     RC_TYPE_RC5_SZ | RC_TYPE_OTHER)
 
 struct ir_scancode {
 	u32	scancode;
@@ -35,7 +35,7 @@ struct ir_scancode_table {
 	unsigned int		size;	/* Max number of entries */
 	unsigned int		len;	/* Used number of entries */
 	unsigned int		alloc;	/* Size of *scan in bytes */
-	u64			ir_type;
+	u64			rc_type;
 	const char		*name;
 	spinlock_t		lock;
 };
-- 
1.7.1


