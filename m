Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab0HAN1k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 09:27:40 -0400
Date: Sun, 1 Aug 2010 10:27:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: patrick.boettcher@desy.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] V4L/DVB: dib0700: properly implement IR change_protocol
Message-ID: <20100801102745.3d768450@pedra>
In-Reply-To: <cover.1280669072.git.mchehab@redhat.com>
References: <cover.1280669072.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements change_protocol callback. With this change,
there's no need for an extra modprobe parameter to specify the
protocol. When a table is loaded (either from in-kernel rc-map
tables or via ir-keytable program), the driver will automatically
change the protocol, in order to work with the given table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index 83fc24a..c2c9d23 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -60,6 +60,7 @@ extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold);
+extern int dib0700_change_protocol(void *priv, u64 ir_type);
 
 extern int dib0700_device_count;
 extern int dvb_usb_dib0700_ir_proto;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index a05d955..d73a688 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -13,10 +13,6 @@ int dvb_usb_dib0700_debug;
 module_param_named(debug,dvb_usb_dib0700_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,2=fw,4=fwdata,8=data (or-able))." DVB_USB_DEBUG_STATUS);
 
-int dvb_usb_dib0700_ir_proto = 1;
-module_param(dvb_usb_dib0700_ir_proto, int, 0644);
-MODULE_PARM_DESC(dvb_usb_dib0700_ir_proto, "set ir protocol (0=NEC, 1=RC5 (default), 2=RC6).");
-
 static int nb_packet_buffer_size = 21;
 module_param(nb_packet_buffer_size, int, 0644);
 MODULE_PARM_DESC(nb_packet_buffer_size,
@@ -475,6 +471,39 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return dib0700_ctrl_wr(adap->dev, b, 4);
 }
 
+int dib0700_change_protocol(void *priv, u64 ir_type)
+{
+	struct dvb_usb_device *d = priv;
+	struct dib0700_state *st = d->priv;
+	u8 rc_setup[3] = { REQUEST_SET_RC, 0, 0 };
+	int new_proto, ret;
+
+	/* Set the IR mode */
+	if (ir_type == IR_TYPE_RC5)
+		new_proto = 1;
+	else if (ir_type == IR_TYPE_NEC)
+		new_proto = 0;
+	else if (ir_type == IR_TYPE_RC6) {
+		if (st->fw_version < 0x10200)
+			return -EINVAL;
+
+		new_proto = 2;
+	} else
+		return -EINVAL;
+
+	rc_setup[1] = new_proto;
+
+	ret = dib0700_ctrl_wr(d, rc_setup, sizeof(rc_setup));
+	if (ret < 0) {
+		err("ir protocol setup failed");
+		return ret;
+	}
+
+	d->props.rc.core.protocol = new_proto;
+
+	return ret;
+}
+
 /* Number of keypresses to ignore before start repeating */
 #define RC_REPEAT_DELAY_V1_20 10
 
@@ -524,9 +553,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	deb_data("IR raw %02X %02X %02X %02X %02X %02X (len %d)\n", buf[0],
 		 buf[1], buf[2], buf[3], buf[4], buf[5], purb->actual_length);
 
-	switch (dvb_usb_dib0700_ir_proto) {
-	case 0:
-		/* NEC Protocol */
+	switch (d->props.rc.core.protocol) {
+	case IR_TYPE_NEC:
 		poll_reply.data_state = 0;
 		poll_reply.system     = buf[2];
 		poll_reply.data       = buf[4];
@@ -543,6 +571,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		break;
 	default:
 		/* RC5 Protocol */
+		/* TODO: need to check the mapping for RC6 */
 		poll_reply.report_id  = buf[0];
 		poll_reply.data_state = buf[1];
 		poll_reply.system     = (buf[2] << 8) | buf[3];
@@ -580,18 +609,10 @@ resubmit:
 int dib0700_rc_setup(struct dvb_usb_device *d)
 {
 	struct dib0700_state *st = d->priv;
-	u8 rc_setup[3] = { REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0 };
 	struct urb *purb;
 	int ret;
-	int i;
-
-	/* Set the IR mode */
-	i = dib0700_ctrl_wr(d, rc_setup, sizeof(rc_setup));
-	if (i < 0) {
-		err("ir protocol setup failed");
-		return i;
-	}
 
+	/* Poll-based. Don't initialize bulk mode */
 	if (st->fw_version < 0x10200)
 		return 0;
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index ee2a84b..f634d2e 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -486,8 +486,6 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 	int i;
 	struct dib0700_state *st = d->priv;
 
-printk("%s\n", __func__);
-
 	if (st->fw_version >= 0x10200) {
 		/* For 1.20 firmware , We need to keep the RC polling
 		   callback so we can reuse the input device setup in
@@ -511,8 +509,8 @@ printk("%s\n", __func__);
 	dib0700_rc_setup(d); /* reset ir sensor data to prevent false events */
 
 	d->last_event = 0;
-	switch (dvb_usb_dib0700_ir_proto) {
-	case 0:
+	switch (d->props.rc.core.protocol) {
+	case IR_TYPE_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
 		    (key[3] == 0xff))
@@ -1873,7 +1871,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -1903,7 +1907,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -1958,7 +1968,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -1996,7 +2012,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2068,7 +2090,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2108,7 +2136,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2172,7 +2206,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2215,7 +2255,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2280,7 +2326,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2312,7 +2364,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2376,7 +2434,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2416,7 +2480,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 2,
@@ -2461,7 +2531,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2494,7 +2570,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
-			.rc_query         = dib0700_rc_query_old_firmware
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.rc_props = {
+				.allowed_protos = IR_TYPE_RC5 |
+						  IR_TYPE_RC6 |
+						  IR_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+			},
 		},
 	},
 };
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index bcfbf9a..34f7b3b 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -179,6 +179,7 @@ struct dvb_rc_legacy {
 /**
  * struct dvb_rc properties of remote controller, using rc-core
  * @rc_codes: name of rc codes table
+ * @protocol: type of protocol(s) currently used by the driver
  * @rc_query: called to query an event event.
  * @rc_interval: time in ms between two queries.
  * @rc_props: remote controller properties
@@ -186,6 +187,7 @@ struct dvb_rc_legacy {
  */
 struct dvb_rc {
 	char *rc_codes;
+	u64 protocol;
 	char *module_name;
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
-- 
1.7.1


