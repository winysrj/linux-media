Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab0DFSSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:22 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IILGm008585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:22 -0400
Date: Tue, 6 Apr 2010 15:18:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/26] V4L/DVB: rename all *_rc_keys to ir_codes_*_nec_table
Message-ID: <20100406151803.2a998204@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several DVB drivers use a different name convention. As we're moving
the keytables, we need to use the same convention on all places.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 6247239..b6cbb1d 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -37,7 +37,7 @@ static int a800_identify_state(struct usb_device *udev, struct dvb_usb_device_pr
 	return 0;
 }
 
-static struct dvb_usb_rc_key a800_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_a800_table[] = {
 	{ 0x0201, KEY_PROG1 },       /* SOURCE */
 	{ 0x0200, KEY_POWER },       /* POWER */
 	{ 0x0205, KEY_1 },           /* 1 */
@@ -147,8 +147,8 @@ static struct dvb_usb_device_properties a800_properties = {
 	.identify_state   = a800_identify_state,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = a800_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(a800_rc_keys),
+	.rc_key_map       = ir_codes_a800_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_a800_table),
 	.rc_query         = a800_rc_query,
 
 	.i2c_algo         = &dibusb_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/af9005-remote.c b/drivers/media/dvb/dvb-usb/af9005-remote.c
index f4379c6..b41fa87 100644
--- a/drivers/media/dvb/dvb-usb/af9005-remote.c
+++ b/drivers/media/dvb/dvb-usb/af9005-remote.c
@@ -33,7 +33,7 @@ MODULE_PARM_DESC(debug,
 
 #define deb_decode(args...)   dprintk(dvb_usb_af9005_remote_debug,0x01,args)
 
-struct dvb_usb_rc_key af9005_rc_keys[] = {
+struct dvb_usb_rc_key ir_codes_af9005_table[] = {
 
 	{0x01b7, KEY_POWER},
 	{0x01a7, KEY_VOLUMEUP},
@@ -74,7 +74,7 @@ struct dvb_usb_rc_key af9005_rc_keys[] = {
 	{0x00d5, KEY_GOTO},	/* marked jump on the remote */
 };
 
-int af9005_rc_keys_size = ARRAY_SIZE(af9005_rc_keys);
+int ir_codes_af9005_table_size = ARRAY_SIZE(ir_codes_af9005_table);
 
 static int repeatable_keys[] = {
 	KEY_VOLUMEUP,
@@ -130,10 +130,10 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 				deb_decode("code != inverted code\n");
 				return 0;
 			}
-			for (i = 0; i < af9005_rc_keys_size; i++) {
-				if (rc5_custom(&af9005_rc_keys[i]) == cust
-				    && rc5_data(&af9005_rc_keys[i]) == dat) {
-					*event = af9005_rc_keys[i].event;
+			for (i = 0; i < ir_codes_af9005_table_size; i++) {
+				if (rc5_custom(&ir_codes_af9005_table[i]) == cust
+				    && rc5_data(&ir_codes_af9005_table[i]) == dat) {
+					*event = ir_codes_af9005_table[i].event;
 					*state = REMOTE_KEY_PRESSED;
 					deb_decode
 					    ("key pressed, event %x\n", *event);
@@ -146,8 +146,8 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 	return 0;
 }
 
-EXPORT_SYMBOL(af9005_rc_keys);
-EXPORT_SYMBOL(af9005_rc_keys_size);
+EXPORT_SYMBOL(ir_codes_af9005_table);
+EXPORT_SYMBOL(ir_codes_af9005_table_size);
 EXPORT_SYMBOL(af9005_rc_decode);
 
 MODULE_AUTHOR("Luca Olivetti <luca@ventoso.org>");
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index ca5a0a4..cfd6107 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -1109,8 +1109,8 @@ static int __init af9005_usb_module_init(void)
 		return result;
 	}
 	rc_decode = symbol_request(af9005_rc_decode);
-	rc_keys = symbol_request(af9005_rc_keys);
-	rc_keys_size = symbol_request(af9005_rc_keys_size);
+	rc_keys = symbol_request(ir_codes_af9005_table);
+	rc_keys_size = symbol_request(ir_codes_af9005_table_size);
 	if (rc_decode == NULL || rc_keys == NULL || rc_keys_size == NULL) {
 		err("af9005_rc_decode function not found, disabling remote");
 		af9005_properties.rc_query = NULL;
@@ -1128,9 +1128,9 @@ static void __exit af9005_usb_module_exit(void)
 	if (rc_decode != NULL)
 		symbol_put(af9005_rc_decode);
 	if (rc_keys != NULL)
-		symbol_put(af9005_rc_keys);
+		symbol_put(ir_codes_af9005_table);
 	if (rc_keys_size != NULL)
-		symbol_put(af9005_rc_keys_size);
+		symbol_put(ir_codes_af9005_table_size);
 	/* deregister this driver from the USB subsystem */
 	usb_deregister(&af9005_usb_driver);
 }
diff --git a/drivers/media/dvb/dvb-usb/af9005.h b/drivers/media/dvb/dvb-usb/af9005.h
index 0bc48a0..088e708 100644
--- a/drivers/media/dvb/dvb-usb/af9005.h
+++ b/drivers/media/dvb/dvb-usb/af9005.h
@@ -3490,7 +3490,7 @@ extern u8 regmask[8];
 /* remote control decoder */
 extern int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len,
 			    u32 * event, int *state);
-extern struct dvb_usb_rc_key af9005_rc_keys[];
-extern int af9005_rc_keys_size;
+extern struct dvb_usb_rc_key ir_codes_af9005_table[];
+extern int ir_codes_af9005_table_size;
 
 #endif
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index c0c999b..1580997 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -751,19 +751,19 @@ static const struct af9015_setup *af9015_setup_match(unsigned int id,
 
 static const struct af9015_setup af9015_setup_modparam[] = {
 	{ AF9015_REMOTE_A_LINK_DTU_M,
-		af9015_rc_keys_a_link, ARRAY_SIZE(af9015_rc_keys_a_link),
+		ir_codes_af9015_table_a_link, ARRAY_SIZE(ir_codes_af9015_table_a_link),
 		af9015_ir_table_a_link, ARRAY_SIZE(af9015_ir_table_a_link) },
 	{ AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
-		af9015_rc_keys_msi, ARRAY_SIZE(af9015_rc_keys_msi),
+		ir_codes_af9015_table_msi, ARRAY_SIZE(ir_codes_af9015_table_msi),
 		af9015_ir_table_msi, ARRAY_SIZE(af9015_ir_table_msi) },
 	{ AF9015_REMOTE_MYGICTV_U718,
-		af9015_rc_keys_mygictv, ARRAY_SIZE(af9015_rc_keys_mygictv),
+		ir_codes_af9015_table_mygictv, ARRAY_SIZE(ir_codes_af9015_table_mygictv),
 		af9015_ir_table_mygictv, ARRAY_SIZE(af9015_ir_table_mygictv) },
 	{ AF9015_REMOTE_DIGITTRADE_DVB_T,
-		af9015_rc_keys_digittrade, ARRAY_SIZE(af9015_rc_keys_digittrade),
+		ir_codes_af9015_table_digittrade, ARRAY_SIZE(ir_codes_af9015_table_digittrade),
 		af9015_ir_table_digittrade, ARRAY_SIZE(af9015_ir_table_digittrade) },
 	{ AF9015_REMOTE_AVERMEDIA_KS,
-		af9015_rc_keys_avermedia, ARRAY_SIZE(af9015_rc_keys_avermedia),
+		ir_codes_af9015_table_avermedia, ARRAY_SIZE(ir_codes_af9015_table_avermedia),
 		af9015_ir_table_avermedia_ks, ARRAY_SIZE(af9015_ir_table_avermedia_ks) },
 	{ }
 };
@@ -771,32 +771,32 @@ static const struct af9015_setup af9015_setup_modparam[] = {
 /* don't add new entries here anymore, use hashes instead */
 static const struct af9015_setup af9015_setup_usbids[] = {
 	{ USB_VID_LEADTEK,
-		af9015_rc_keys_leadtek, ARRAY_SIZE(af9015_rc_keys_leadtek),
+		ir_codes_af9015_table_leadtek, ARRAY_SIZE(ir_codes_af9015_table_leadtek),
 		af9015_ir_table_leadtek, ARRAY_SIZE(af9015_ir_table_leadtek) },
 	{ USB_VID_VISIONPLUS,
-		af9015_rc_keys_twinhan, ARRAY_SIZE(af9015_rc_keys_twinhan),
+		ir_codes_af9015_table_twinhan, ARRAY_SIZE(ir_codes_af9015_table_twinhan),
 		af9015_ir_table_twinhan, ARRAY_SIZE(af9015_ir_table_twinhan) },
 	{ USB_VID_KWORLD_2, /* TODO: use correct rc keys */
-		af9015_rc_keys_twinhan, ARRAY_SIZE(af9015_rc_keys_twinhan),
+		ir_codes_af9015_table_twinhan, ARRAY_SIZE(ir_codes_af9015_table_twinhan),
 		af9015_ir_table_kworld, ARRAY_SIZE(af9015_ir_table_kworld) },
 	{ USB_VID_AVERMEDIA,
-		af9015_rc_keys_avermedia, ARRAY_SIZE(af9015_rc_keys_avermedia),
+		ir_codes_af9015_table_avermedia, ARRAY_SIZE(ir_codes_af9015_table_avermedia),
 		af9015_ir_table_avermedia, ARRAY_SIZE(af9015_ir_table_avermedia) },
 	{ USB_VID_MSI_2,
-		af9015_rc_keys_msi_digivox_iii, ARRAY_SIZE(af9015_rc_keys_msi_digivox_iii),
+		ir_codes_af9015_table_msi_digivox_iii, ARRAY_SIZE(ir_codes_af9015_table_msi_digivox_iii),
 		af9015_ir_table_msi_digivox_iii, ARRAY_SIZE(af9015_ir_table_msi_digivox_iii) },
 	{ }
 };
 
 static const struct af9015_setup af9015_setup_hashes[] = {
 	{ 0xb8feb708,
-		af9015_rc_keys_msi, ARRAY_SIZE(af9015_rc_keys_msi),
+		ir_codes_af9015_table_msi, ARRAY_SIZE(ir_codes_af9015_table_msi),
 		af9015_ir_table_msi, ARRAY_SIZE(af9015_ir_table_msi) },
 	{ 0xa3703d00,
-		af9015_rc_keys_a_link, ARRAY_SIZE(af9015_rc_keys_a_link),
+		ir_codes_af9015_table_a_link, ARRAY_SIZE(ir_codes_af9015_table_a_link),
 		af9015_ir_table_a_link, ARRAY_SIZE(af9015_ir_table_a_link) },
 	{ 0x9b7dc64e,
-		af9015_rc_keys_mygictv, ARRAY_SIZE(af9015_rc_keys_mygictv),
+		ir_codes_af9015_table_mygictv, ARRAY_SIZE(ir_codes_af9015_table_mygictv),
 		af9015_ir_table_mygictv, ARRAY_SIZE(af9015_ir_table_mygictv) },
 	{ }
 };
@@ -835,8 +835,8 @@ static void af9015_set_remote_config(struct usb_device *udev,
 			} else if (udev->descriptor.idProduct ==
 				cpu_to_le16(USB_PID_TREKSTOR_DVBT)) {
 				table = &(const struct af9015_setup){ 0,
-					af9015_rc_keys_trekstor,
-					ARRAY_SIZE(af9015_rc_keys_trekstor),
+					ir_codes_af9015_table_trekstor,
+					ARRAY_SIZE(ir_codes_af9015_table_trekstor),
 					af9015_ir_table_trekstor,
 					ARRAY_SIZE(af9015_ir_table_trekstor)
 				};
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index ef36b18..63b2a49 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -123,7 +123,7 @@ enum af9015_remote {
 
 /* LeadTek - Y04G0051 */
 /* Leadtek WinFast DTV Dongle Gold */
-static struct dvb_usb_rc_key af9015_rc_keys_leadtek[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_leadtek[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -227,7 +227,7 @@ static u8 af9015_ir_table_leadtek[] = {
 };
 
 /* TwinHan AzureWave AD-TU700(704J) */
-static struct dvb_usb_rc_key af9015_rc_keys_twinhan[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_twinhan[] = {
 	{ 0x053f, KEY_POWER },
 	{ 0x0019, KEY_FAVORITES },    /* Favorite List */
 	{ 0x0004, KEY_TEXT },         /* Teletext */
@@ -338,7 +338,7 @@ static u8 af9015_ir_table_twinhan[] = {
 };
 
 /* A-Link DTU(m) */
-static struct dvb_usb_rc_key af9015_rc_keys_a_link[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_a_link[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -381,7 +381,7 @@ static u8 af9015_ir_table_a_link[] = {
 };
 
 /* MSI DIGIVOX mini II V3.0 */
-static struct dvb_usb_rc_key af9015_rc_keys_msi[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_msi[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -424,7 +424,7 @@ static u8 af9015_ir_table_msi[] = {
 };
 
 /* MYGICTV U718 */
-static struct dvb_usb_rc_key af9015_rc_keys_mygictv[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_mygictv[] = {
 	{ 0x003d, KEY_SWITCHVIDEOMODE },
 					  /* TV / AV */
 	{ 0x0545, KEY_POWER },
@@ -550,7 +550,7 @@ static u8 af9015_ir_table_kworld[] = {
 };
 
 /* AverMedia Volar X */
-static struct dvb_usb_rc_key af9015_rc_keys_avermedia[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_avermedia[] = {
 	{ 0x053d, KEY_PROG1 },       /* SOURCE */
 	{ 0x0512, KEY_POWER },       /* POWER */
 	{ 0x051e, KEY_1 },           /* 1 */
@@ -656,7 +656,7 @@ static u8 af9015_ir_table_avermedia_ks[] = {
 };
 
 /* Digittrade DVB-T USB Stick */
-static struct dvb_usb_rc_key af9015_rc_keys_digittrade[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_digittrade[] = {
 	{ 0x010f, KEY_LAST },	/* RETURN */
 	{ 0x0517, KEY_TEXT },	/* TELETEXT */
 	{ 0x0108, KEY_EPG },	/* EPG */
@@ -719,7 +719,7 @@ static u8 af9015_ir_table_digittrade[] = {
 };
 
 /* TREKSTOR DVB-T USB Stick */
-static struct dvb_usb_rc_key af9015_rc_keys_trekstor[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_trekstor[] = {
 	{ 0x0704, KEY_AGAIN },		/* Home */
 	{ 0x0705, KEY_MUTE },		/* Mute */
 	{ 0x0706, KEY_UP },			/* Up */
@@ -782,7 +782,7 @@ static u8 af9015_ir_table_trekstor[] = {
 };
 
 /* MSI DIGIVOX mini III */
-static struct dvb_usb_rc_key af9015_rc_keys_msi_digivox_iii[] = {
+static struct dvb_usb_rc_key ir_codes_af9015_table_msi_digivox_iii[] = {
 	{ 0x0713, KEY_POWER },       /* [red power button] */
 	{ 0x073b, KEY_VIDEO },       /* Source */
 	{ 0x073e, KEY_ZOOM },        /* Zoom */
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index bb69f37..faca1ad 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -399,7 +399,7 @@ static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
-static struct dvb_usb_rc_key anysee_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_anysee_table[] = {
 	{ 0x0100, KEY_0 },
 	{ 0x0101, KEY_1 },
 	{ 0x0102, KEY_2 },
@@ -518,8 +518,8 @@ static struct dvb_usb_device_properties anysee_properties = {
 		}
 	},
 
-	.rc_key_map       = anysee_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(anysee_rc_keys),
+	.rc_key_map       = ir_codes_anysee_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_anysee_table),
 	.rc_query         = anysee_rc_query,
 	.rc_interval      = 200,  /* windows driver uses 500ms */
 
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 30ea3ef..8934788 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -386,7 +386,7 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-static struct dvb_usb_rc_key az6027_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_az6027_table[] = {
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
 };
@@ -1096,8 +1096,8 @@ static struct dvb_usb_device_properties az6027_properties = {
 	.power_ctrl       = az6027_power_ctrl,
 	.read_mac_address = az6027_read_mac_addr,
  */
-	.rc_key_map       = az6027_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(az6027_rc_keys),
+	.rc_key_map       = ir_codes_az6027_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_az6027_table),
 	.rc_interval      = 400,
 	.rc_query         = az6027_rc_query,
 	.i2c_algo         = &az6027_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index e37ac4d..5a9c14b 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -84,7 +84,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key cinergyt2_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_cinergyt2_table[] = {
 	{ 0x0401, KEY_POWER },
 	{ 0x0402, KEY_1 },
 	{ 0x0403, KEY_2 },
@@ -218,8 +218,8 @@ static struct dvb_usb_device_properties cinergyt2_properties = {
 	.power_ctrl       = cinergyt2_power_ctrl,
 
 	.rc_interval      = 50,
-	.rc_key_map       = cinergyt2_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(cinergyt2_rc_keys),
+	.rc_key_map       = ir_codes_cinergyt2_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_cinergyt2_table),
 	.rc_query         = cinergyt2_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 1,
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index a7b8405..60de386 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -460,7 +460,7 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	return 0;
 }
 
-static struct dvb_usb_rc_key dvico_mce_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_dvico_mce_table[] = {
 	{ 0xfe02, KEY_TV },
 	{ 0xfe0e, KEY_MP3 },
 	{ 0xfe1a, KEY_DVD },
@@ -508,7 +508,7 @@ static struct dvb_usb_rc_key dvico_mce_rc_keys[] = {
 	{ 0xfe4e, KEY_POWER },
 };
 
-static struct dvb_usb_rc_key dvico_portable_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_dvico_portable_table[] = {
 	{ 0xfc02, KEY_SETUP },       /* Profile */
 	{ 0xfc43, KEY_POWER2 },
 	{ 0xfc06, KEY_EPG },
@@ -547,7 +547,7 @@ static struct dvb_usb_rc_key dvico_portable_rc_keys[] = {
 	{ 0xfc00, KEY_UNKNOWN },    /* HD */
 };
 
-static struct dvb_usb_rc_key d680_dmb_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_d680_dmb_table[] = {
 	{ 0x0038, KEY_UNKNOWN },	/* TV/AV */
 	{ 0x080c, KEY_ZOOM },
 	{ 0x0800, KEY_0 },
@@ -1448,8 +1448,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 	.i2c_algo         = &cxusb_i2c_algo,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_portable_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_portable_rc_keys),
+	.rc_key_map       = ir_codes_dvico_portable_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
 	.rc_query         = cxusb_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1499,8 +1499,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 	.i2c_algo         = &cxusb_i2c_algo,
 
 	.rc_interval      = 150,
-	.rc_key_map       = dvico_mce_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_mce_rc_keys),
+	.rc_key_map       = ir_codes_dvico_mce_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
 	.rc_query         = cxusb_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1558,8 +1558,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 	.i2c_algo         = &cxusb_i2c_algo,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_portable_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_portable_rc_keys),
+	.rc_key_map       = ir_codes_dvico_portable_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
 	.rc_query         = cxusb_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1608,8 +1608,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 	.i2c_algo         = &cxusb_i2c_algo,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_portable_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_portable_rc_keys),
+	.rc_key_map       = ir_codes_dvico_portable_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
 	.rc_query         = cxusb_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1657,8 +1657,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_mce_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_mce_rc_keys),
+	.rc_key_map       = ir_codes_dvico_mce_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
 	.rc_query         = cxusb_bluebird2_rc_query,
 
 	.num_device_descs = 1,
@@ -1705,8 +1705,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_portable_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_portable_rc_keys),
+	.rc_key_map       = ir_codes_dvico_portable_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
 	.rc_query         = cxusb_bluebird2_rc_query,
 
 	.num_device_descs = 1,
@@ -1755,8 +1755,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_portable_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_portable_rc_keys),
+	.rc_key_map       = ir_codes_dvico_portable_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_portable_table),
 	.rc_query         = cxusb_rc_query,
 
 	.num_device_descs = 1,
@@ -1846,8 +1846,8 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = dvico_mce_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(dvico_mce_rc_keys),
+	.rc_key_map       = ir_codes_dvico_mce_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_dvico_mce_table),
 	.rc_query         = cxusb_rc_query,
 
 	.num_device_descs = 1,
@@ -1894,8 +1894,8 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = d680_dmb_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(d680_dmb_rc_keys),
+	.rc_key_map       = ir_codes_d680_dmb_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
 	.rc_query         = cxusb_d680_dmb_rc_query,
 
 	.num_device_descs = 1,
@@ -1943,8 +1943,8 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 
 	.rc_interval      = 100,
-	.rc_key_map       = d680_dmb_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(d680_dmb_rc_keys),
+	.rc_key_map       = ir_codes_d680_dmb_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_d680_dmb_table),
 	.rc_query         = cxusb_d680_dmb_rc_query,
 
 	.num_device_descs = 1,
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 34eab05..2deca21 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -562,7 +562,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
-static struct dvb_usb_rc_key dib0700_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_dib0700_table[] = {
 	/* Key codes for the tiny Pinnacle remote*/
 	{ 0x0700, KEY_MUTE },
 	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
@@ -2131,8 +2131,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2160,8 +2160,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2214,8 +2214,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2251,8 +2251,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2321,8 +2321,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2360,8 +2360,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2422,8 +2422,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2484,8 +2484,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2513,8 +2513,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2574,8 +2574,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2612,8 +2612,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2656,8 +2656,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2687,8 +2687,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = ir_codes_dib0700_table,
+		.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
 		.rc_query         = dib0700_rc_query
 	},
 };
diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/dvb/dvb-usb/dibusb-common.c
index 9143b56..bc08bc0 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-common.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-common.c
@@ -327,7 +327,7 @@ EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);
 /*
  * common remote control stuff
  */
-struct dvb_usb_rc_key dibusb_rc_keys[] = {
+struct dvb_usb_rc_key ir_codes_dibusb_table[] = {
 	/* Key codes for the little Artec T1/Twinhan/HAMA/ remote. */
 	{ 0x0016, KEY_POWER },
 	{ 0x0010, KEY_MUTE },
@@ -456,7 +456,7 @@ struct dvb_usb_rc_key dibusb_rc_keys[] = {
 	{ 0x804e, KEY_ENTER },
 	{ 0x804f, KEY_VOLUMEDOWN },
 };
-EXPORT_SYMBOL(dibusb_rc_keys);
+EXPORT_SYMBOL(ir_codes_dibusb_table);
 
 int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index 5c0126d..eb2e6f0 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -212,7 +212,7 @@ static struct dvb_usb_device_properties dibusb1_1_properties = {
 	.power_ctrl       = dibusb_power_ctrl,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = dibusb_rc_keys,
+	.rc_key_map       = ir_codes_dibusb_table,
 	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
 	.rc_query         = dibusb_rc_query,
 
@@ -296,7 +296,7 @@ static struct dvb_usb_device_properties dibusb1_1_an2235_properties = {
 	.power_ctrl       = dibusb_power_ctrl,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = dibusb_rc_keys,
+	.rc_key_map       = ir_codes_dibusb_table,
 	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
 	.rc_query         = dibusb_rc_query,
 
@@ -360,7 +360,7 @@ static struct dvb_usb_device_properties dibusb2_0b_properties = {
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = dibusb_rc_keys,
+	.rc_key_map       = ir_codes_dibusb_table,
 	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
 	.rc_query         = dibusb_rc_query,
 
@@ -417,7 +417,7 @@ static struct dvb_usb_device_properties artec_t1_usb2_properties = {
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = dibusb_rc_keys,
+	.rc_key_map       = ir_codes_dibusb_table,
 	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
 	.rc_query         = dibusb_rc_query,
 
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
index a05b9f8..588308e 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
@@ -82,7 +82,7 @@ static struct dvb_usb_device_properties dibusb_mc_properties = {
 	.power_ctrl       = dibusb2_0_power_ctrl,
 
 	.rc_interval      = DEFAULT_RC_INTERVAL,
-	.rc_key_map       = dibusb_rc_keys,
+	.rc_key_map       = ir_codes_dibusb_table,
 	.rc_key_map_size  = 111, /* FIXME */
 	.rc_query         = dibusb_rc_query,
 
diff --git a/drivers/media/dvb/dvb-usb/dibusb.h b/drivers/media/dvb/dvb-usb/dibusb.h
index 8e847aa..3d50ac5 100644
--- a/drivers/media/dvb/dvb-usb/dibusb.h
+++ b/drivers/media/dvb/dvb-usb/dibusb.h
@@ -124,7 +124,7 @@ extern int dibusb2_0_power_ctrl(struct dvb_usb_device *, int);
 #define DEFAULT_RC_INTERVAL 150
 //#define DEFAULT_RC_INTERVAL 100000
 
-extern struct dvb_usb_rc_key dibusb_rc_keys[];
+extern struct dvb_usb_rc_key ir_codes_dibusb_table[];
 extern int dibusb_rc_query(struct dvb_usb_device *, u32 *, int *);
 extern int dibusb_read_eeprom_byte(struct dvb_usb_device *, u8, u8 *);
 
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 955147d..e826077 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -161,7 +161,7 @@ static int digitv_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key digitv_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_digitv_table[] = {
 	{ 0x5f55, KEY_0 },
 	{ 0x6f55, KEY_1 },
 	{ 0x9f55, KEY_2 },
@@ -311,8 +311,8 @@ static struct dvb_usb_device_properties digitv_properties = {
 	.identify_state   = digitv_identify_state,
 
 	.rc_interval      = 1000,
-	.rc_key_map       = digitv_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(digitv_rc_keys),
+	.rc_key_map       = ir_codes_digitv_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_digitv_table),
 	.rc_query         = digitv_rc_query,
 
 	.i2c_algo         = &digitv_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index a1b12b0..f57e590 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -57,7 +57,7 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 
 /* remote control */
 /* key list for the tiny remote control (Yakumo, don't know about the others) */
-static struct dvb_usb_rc_key dtt200u_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_dtt200u_table[] = {
 	{ 0x8001, KEY_MUTE },
 	{ 0x8002, KEY_CHANNELDOWN },
 	{ 0x8003, KEY_VOLUMEDOWN },
@@ -162,8 +162,8 @@ static struct dvb_usb_device_properties dtt200u_properties = {
 	.power_ctrl      = dtt200u_power_ctrl,
 
 	.rc_interval     = 300,
-	.rc_key_map      = dtt200u_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dtt200u_rc_keys),
+	.rc_key_map      = ir_codes_dtt200u_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
 	.rc_query        = dtt200u_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -207,8 +207,8 @@ static struct dvb_usb_device_properties wt220u_properties = {
 	.power_ctrl      = dtt200u_power_ctrl,
 
 	.rc_interval     = 300,
-	.rc_key_map      = dtt200u_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dtt200u_rc_keys),
+	.rc_key_map      = ir_codes_dtt200u_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
 	.rc_query        = dtt200u_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -252,8 +252,8 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
 	.power_ctrl      = dtt200u_power_ctrl,
 
 	.rc_interval     = 300,
-	.rc_key_map      = dtt200u_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dtt200u_rc_keys),
+	.rc_key_map      = ir_codes_dtt200u_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
 	.rc_query        = dtt200u_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -297,8 +297,8 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
 	.power_ctrl      = dtt200u_power_ctrl,
 
 	.rc_interval     = 300,
-	.rc_key_map      = dtt200u_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dtt200u_rc_keys),
+	.rc_key_map      = ir_codes_dtt200u_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dtt200u_table),
 	.rc_query        = dtt200u_rc_query,
 
 	.generic_bulk_ctrl_endpoint = 0x01,
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index accc655..e8fb853 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -73,7 +73,7 @@
 		"Please see linux/Documentation/dvb/ for more details " \
 		"on firmware-problems."
 
-struct dvb_usb_rc_keys_table {
+struct ir_codes_dvb_usb_table_table {
 	struct dvb_usb_rc_key *rc_keys;
 	int rc_keys_size;
 };
@@ -948,7 +948,7 @@ static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key dw210x_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_dw210x_table[] = {
 	{ 0xf80a, KEY_Q },		/*power*/
 	{ 0xf80c, KEY_M },		/*mute*/
 	{ 0xf811, KEY_1 },
@@ -982,7 +982,7 @@ static struct dvb_usb_rc_key dw210x_rc_keys[] = {
 	{ 0xf81b, KEY_B },		/*recall*/
 };
 
-static struct dvb_usb_rc_key tevii_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_tevii_table[] = {
 	{ 0xf80a, KEY_POWER },
 	{ 0xf80c, KEY_MUTE },
 	{ 0xf811, KEY_1 },
@@ -1032,7 +1032,7 @@ static struct dvb_usb_rc_key tevii_rc_keys[] = {
 	{ 0xf858, KEY_SWITCHVIDEOMODE },
 };
 
-static struct dvb_usb_rc_key tbs_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_tbs_table[] = {
 	{ 0xf884, KEY_POWER },
 	{ 0xf894, KEY_MUTE },
 	{ 0xf887, KEY_1 },
@@ -1067,10 +1067,10 @@ static struct dvb_usb_rc_key tbs_rc_keys[] = {
 	{ 0xf89b, KEY_MODE }
 };
 
-static struct dvb_usb_rc_keys_table keys_tables[] = {
-	{ dw210x_rc_keys, ARRAY_SIZE(dw210x_rc_keys) },
-	{ tevii_rc_keys, ARRAY_SIZE(tevii_rc_keys) },
-	{ tbs_rc_keys, ARRAY_SIZE(tbs_rc_keys) },
+static struct ir_codes_dvb_usb_table_table keys_tables[] = {
+	{ ir_codes_dw210x_table, ARRAY_SIZE(ir_codes_dw210x_table) },
+	{ ir_codes_tevii_table, ARRAY_SIZE(ir_codes_tevii_table) },
+	{ ir_codes_tbs_table, ARRAY_SIZE(ir_codes_tbs_table) },
 };
 
 static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
@@ -1185,14 +1185,14 @@ static int dw2102_load_firmware(struct usb_device *dev,
 		/* init registers */
 		switch (dev->descriptor.idProduct) {
 		case USB_PID_PROF_1100:
-			s6x0_properties.rc_key_map = tbs_rc_keys;
+			s6x0_properties.rc_key_map = ir_codes_tbs_table;
 			s6x0_properties.rc_key_map_size =
-					ARRAY_SIZE(tbs_rc_keys);
+					ARRAY_SIZE(ir_codes_tbs_table);
 			break;
 		case USB_PID_TEVII_S650:
-			dw2104_properties.rc_key_map = tevii_rc_keys;
+			dw2104_properties.rc_key_map = ir_codes_tevii_table;
 			dw2104_properties.rc_key_map_size =
-					ARRAY_SIZE(tevii_rc_keys);
+					ARRAY_SIZE(ir_codes_tevii_table);
 		case USB_PID_DW2104:
 			reset = 1;
 			dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
@@ -1255,8 +1255,8 @@ static struct dvb_usb_device_properties dw2102_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw2102_serit_i2c_algo,
-	.rc_key_map = dw210x_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dw210x_rc_keys),
+	.rc_key_map = ir_codes_dw210x_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -1306,8 +1306,8 @@ static struct dvb_usb_device_properties dw2104_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw2104_i2c_algo,
-	.rc_key_map = dw210x_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dw210x_rc_keys),
+	.rc_key_map = ir_codes_dw210x_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -1353,8 +1353,8 @@ static struct dvb_usb_device_properties dw3101_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw3101_i2c_algo,
-	.rc_key_map = dw210x_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dw210x_rc_keys),
+	.rc_key_map = ir_codes_dw210x_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_dw210x_table),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -1396,8 +1396,8 @@ static struct dvb_usb_device_properties s6x0_properties = {
 	.no_reconnect = 1,
 
 	.i2c_algo = &s6x0_i2c_algo,
-	.rc_key_map = tevii_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(tevii_rc_keys),
+	.rc_key_map = ir_codes_tevii_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_tevii_table),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -1459,8 +1459,8 @@ static int dw2102_probe(struct usb_interface *intf,
 	/* fill only different fields */
 	p7500->firmware = "dvb-usb-p7500.fw";
 	p7500->devices[0] = d7500;
-	p7500->rc_key_map = tbs_rc_keys;
-	p7500->rc_key_map_size = ARRAY_SIZE(tbs_rc_keys);
+	p7500->rc_key_map = ir_codes_tbs_table;
+	p7500->rc_key_map_size = ARRAY_SIZE(ir_codes_tbs_table);
 	p7500->adapter->frontend_attach = prof_7500_frontend_attach;
 
 	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index 737ffa3..c211fef 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -589,7 +589,7 @@ static struct m920x_inits pinnacle310e_init[] = {
 };
 
 /* ir keymaps */
-static struct dvb_usb_rc_key megasky_rc_keys [] = {
+static struct dvb_usb_rc_key ir_codes_megasky_table [] = {
 	{ 0x0012, KEY_POWER },
 	{ 0x001e, KEY_CYCLEWINDOWS }, /* min/max */
 	{ 0x0002, KEY_CHANNELUP },
@@ -608,7 +608,7 @@ static struct dvb_usb_rc_key megasky_rc_keys [] = {
 	{ 0x000e, KEY_COFFEE }, /* "MTS" */
 };
 
-static struct dvb_usb_rc_key tvwalkertwin_rc_keys [] = {
+static struct dvb_usb_rc_key ir_codes_tvwalkertwin_table [] = {
 	{ 0x0001, KEY_ZOOM }, /* Full Screen */
 	{ 0x0002, KEY_CAMERA }, /* snapshot */
 	{ 0x0003, KEY_MUTE },
@@ -628,7 +628,7 @@ static struct dvb_usb_rc_key tvwalkertwin_rc_keys [] = {
 	{ 0x001e, KEY_VOLUMEUP },
 };
 
-static struct dvb_usb_rc_key pinnacle310e_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_pinnacle310e_table[] = {
 	{ 0x16, KEY_POWER },
 	{ 0x17, KEY_FAVORITES },
 	{ 0x0f, KEY_TEXT },
@@ -785,8 +785,8 @@ static struct dvb_usb_device_properties megasky_properties = {
 	.download_firmware = m920x_firmware_download,
 
 	.rc_interval      = 100,
-	.rc_key_map       = megasky_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(megasky_rc_keys),
+	.rc_key_map       = ir_codes_megasky_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_megasky_table),
 	.rc_query         = m920x_rc_query,
 
 	.size_of_priv     = sizeof(struct m920x_state),
@@ -886,8 +886,8 @@ static struct dvb_usb_device_properties tvwalkertwin_properties = {
 	.download_firmware = m920x_firmware_download,
 
 	.rc_interval      = 100,
-	.rc_key_map       = tvwalkertwin_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(tvwalkertwin_rc_keys),
+	.rc_key_map       = ir_codes_tvwalkertwin_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_tvwalkertwin_table),
 	.rc_query         = m920x_rc_query,
 
 	.size_of_priv     = sizeof(struct m920x_state),
@@ -993,8 +993,8 @@ static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
 	.download_firmware = NULL,
 
 	.rc_interval      = 100,
-	.rc_key_map       = pinnacle310e_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(pinnacle310e_rc_keys),
+	.rc_key_map       = ir_codes_pinnacle310e_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_pinnacle310e_table),
 	.rc_query         = m920x_rc_query,
 
 	.size_of_priv     = sizeof(struct m920x_state),
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index b41d66e..d195a58 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -21,7 +21,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define deb_ee(args...) dprintk(debug,0x02,args)
 
 /* Hauppauge NOVA-T USB2 keys */
-static struct dvb_usb_rc_key haupp_rc_keys [] = {
+static struct dvb_usb_rc_key ir_codes_haupp_table [] = {
 	{ 0x1e00, KEY_0 },
 	{ 0x1e01, KEY_1 },
 	{ 0x1e02, KEY_2 },
@@ -91,14 +91,14 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 			deb_rc("raw key code 0x%02x, 0x%02x, 0x%02x to c: %02x d: %02x toggle: %d\n",key[1],key[2],key[3],custom,data,toggle);
 
-			for (i = 0; i < ARRAY_SIZE(haupp_rc_keys); i++) {
-				if (rc5_data(&haupp_rc_keys[i]) == data &&
-					rc5_custom(&haupp_rc_keys[i]) == custom) {
+			for (i = 0; i < ARRAY_SIZE(ir_codes_haupp_table); i++) {
+				if (rc5_data(&ir_codes_haupp_table[i]) == data &&
+					rc5_custom(&ir_codes_haupp_table[i]) == custom) {
 
-					deb_rc("c: %x, d: %x\n", rc5_data(&haupp_rc_keys[i]),
-								 rc5_custom(&haupp_rc_keys[i]));
+					deb_rc("c: %x, d: %x\n", rc5_data(&ir_codes_haupp_table[i]),
+								 rc5_custom(&ir_codes_haupp_table[i]));
 
-					*event = haupp_rc_keys[i].event;
+					*event = ir_codes_haupp_table[i].event;
 					*state = REMOTE_KEY_PRESSED;
 					if (st->old_toggle == toggle) {
 						if (st->last_repeat_count++ < 2)
@@ -196,8 +196,8 @@ static struct dvb_usb_device_properties nova_t_properties = {
 	.read_mac_address = nova_t_read_mac_address,
 
 	.rc_interval      = 100,
-	.rc_key_map       = haupp_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(haupp_rc_keys),
+	.rc_key_map       = ir_codes_haupp_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_haupp_table),
 	.rc_query         = nova_t_rc_query,
 
 	.i2c_algo         = &dibusb_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 8305576..dfb81ff 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -35,7 +35,7 @@
 struct opera1_state {
 	u32 last_key_pressed;
 };
-struct opera_rc_keys {
+struct ir_codes_opera_table {
 	u32 keycode;
 	u32 event;
 };
@@ -331,7 +331,7 @@ static int opera1_pid_filter_control(struct dvb_usb_adapter *adap, int onoff)
 	return 0;
 }
 
-static struct dvb_usb_rc_key opera1_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_opera1_table[] = {
 	{0x5fa0, KEY_1},
 	{0x51af, KEY_2},
 	{0x5da2, KEY_3},
@@ -404,12 +404,12 @@ static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
 
 		send_key = (send_key & 0xffff) | 0x0100;
 
-		for (i = 0; i < ARRAY_SIZE(opera1_rc_keys); i++) {
-			if (rc5_scan(&opera1_rc_keys[i]) == (send_key & 0xffff)) {
+		for (i = 0; i < ARRAY_SIZE(ir_codes_opera1_table); i++) {
+			if (rc5_scan(&ir_codes_opera1_table[i]) == (send_key & 0xffff)) {
 				*state = REMOTE_KEY_PRESSED;
-				*event = opera1_rc_keys[i].event;
+				*event = ir_codes_opera1_table[i].event;
 				opst->last_key_pressed =
-					opera1_rc_keys[i].event;
+					ir_codes_opera1_table[i].event;
 				break;
 			}
 			opst->last_key_pressed = 0;
@@ -498,8 +498,8 @@ static struct dvb_usb_device_properties opera1_properties = {
 	.power_ctrl = opera1_power_ctrl,
 	.i2c_algo = &opera1_i2c_algo,
 
-	.rc_key_map = opera1_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(opera1_rc_keys),
+	.rc_key_map = ir_codes_opera1_table,
+	.rc_key_map_size = ARRAY_SIZE(ir_codes_opera1_table),
 	.rc_interval = 200,
 	.rc_query = opera1_rc_query,
 	.read_mac_address = opera1_read_mac_address,
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index ef4e37d..4d33245 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -174,7 +174,7 @@ static int vp702x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-static struct dvb_usb_rc_key vp702x_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_vp702x_table[] = {
 	{ 0x0001, KEY_1 },
 	{ 0x0002, KEY_2 },
 };
@@ -197,10 +197,10 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		return 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(vp702x_rc_keys); i++)
-		if (rc5_custom(&vp702x_rc_keys[i]) == key[1]) {
+	for (i = 0; i < ARRAY_SIZE(ir_codes_vp702x_table); i++)
+		if (rc5_custom(&ir_codes_vp702x_table[i]) == key[1]) {
 			*state = REMOTE_KEY_PRESSED;
-			*event = vp702x_rc_keys[i].event;
+			*event = ir_codes_vp702x_table[i].event;
 			break;
 		}
 	return 0;
@@ -283,8 +283,8 @@ static struct dvb_usb_device_properties vp702x_properties = {
 	},
 	.read_mac_address = vp702x_read_mac_addr,
 
-	.rc_key_map       = vp702x_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(vp702x_rc_keys),
+	.rc_key_map       = ir_codes_vp702x_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp702x_table),
 	.rc_interval      = 400,
 	.rc_query         = vp702x_rc_query,
 
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index a59faa2..036893f 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -99,7 +99,7 @@ static int vp7045_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 /* The keymapping struct. Somehow this should be loaded to the driver, but
  * currently it is hardcoded. */
-static struct dvb_usb_rc_key vp7045_rc_keys[] = {
+static struct dvb_usb_rc_key ir_codes_vp7045_table[] = {
 	{ 0x0016, KEY_POWER },
 	{ 0x0010, KEY_MUTE },
 	{ 0x0003, KEY_1 },
@@ -165,10 +165,10 @@ static int vp7045_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		return 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(vp7045_rc_keys); i++)
-		if (rc5_data(&vp7045_rc_keys[i]) == key) {
+	for (i = 0; i < ARRAY_SIZE(ir_codes_vp7045_table); i++)
+		if (rc5_data(&ir_codes_vp7045_table[i]) == key) {
 			*state = REMOTE_KEY_PRESSED;
-			*event = vp7045_rc_keys[i].event;
+			*event = ir_codes_vp7045_table[i].event;
 			break;
 		}
 	return 0;
@@ -260,8 +260,8 @@ static struct dvb_usb_device_properties vp7045_properties = {
 	.read_mac_address = vp7045_read_mac_addr,
 
 	.rc_interval      = 400,
-	.rc_key_map       = vp7045_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(vp7045_rc_keys),
+	.rc_key_map       = ir_codes_vp7045_table,
+	.rc_key_map_size  = ARRAY_SIZE(ir_codes_vp7045_table),
 	.rc_query         = vp7045_rc_query,
 
 	.num_device_descs = 2,
-- 
1.6.6.1


