Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1EYV2n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 17:28:43 -0400
Received: by wwa36 with SMTP id 36so80073wwa.1
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 14:28:42 -0700 (PDT)
Subject: [PATCH] v1.88 DM04/QQBOX Move remote to use rc_core dvb-usb-remote.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 22:28:29 +0100
Message-ID: <1306358909.2012.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

driver to use dvb-usb-remote.
The remote(s) generates 24 bit NEC codes, lme2510 keymaps redefined.
 
Other minor fixes
fix le warning.
make sure frontend is detached on firmware change.  

applied to v1.86
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c   |  107 +++++++++++----------------
 drivers/media/rc/keymaps/rc-lme2510.c |  134 ++++++++++++++++----------------
 2 files changed, 110 insertions(+), 131 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index f36f471..37b1469 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -207,17 +207,6 @@ static int lme2510_stream_restart(struct dvb_usb_device *d)
 			rbuff, sizeof(rbuff));
 	return ret;
 }
-static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u32 keypress)
-{
-	struct dvb_usb_device *d = adap->dev;
-
-	deb_info(1, "INT Key Keypress =%04x", keypress);
-
-	if (keypress > 0)
-		rc_keydown(d->rc_dev, keypress, 0);
-
-	return 0;
-}
 
 static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
 {
@@ -256,6 +245,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 	struct lme2510_state *st = adap->dev->priv;
 	static u8 *ibuf, *rbuf;
 	int i = 0, offset;
+	u32 key;
 
 	switch (lme_urb->status) {
 	case 0:
@@ -282,10 +272,16 @@ static void lme2510_int_response(struct urb *lme_urb)
 
 		switch (ibuf[0]) {
 		case 0xaa:
-			debug_data_snipet(1, "INT Remote data snipet in", ibuf);
-			lme2510_remote_keypress(adap,
-				(u32)(ibuf[2] << 24) + (ibuf[3] << 16) +
-				(ibuf[4] << 8) + ibuf[5]);
+			debug_data_snipet(1, "INT Remote data snipet", ibuf);
+			if ((ibuf[4] + ibuf[5]) == 0xff) {
+				key = ibuf[5];
+				key += (ibuf[3] > 0)
+					? (ibuf[3] ^ 0xff) << 8 : 0;
+				key += (ibuf[2] ^ 0xff) << 16;
+				deb_info(1, "INT Key =%08x", key);
+				if (adap->dev->rc_dev != NULL)
+					rc_keydown(adap->dev->rc_dev, key, 0);
+			}
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {
@@ -691,45 +687,6 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-static int lme2510_int_service(struct dvb_usb_adapter *adap)
-{
-	struct dvb_usb_device *d = adap->dev;
-	struct rc_dev *rc;
-	int ret;
-
-	info("STA Configuring Remote");
-
-	rc = rc_allocate_device();
-	if (!rc)
-		return -ENOMEM;
-
-	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
-	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
-
-	rc->input_name = "LME2510 Remote Control";
-	rc->input_phys = d->rc_phys;
-	rc->map_name = RC_MAP_LME2510;
-	rc->driver_name = "LME 2510";
-	usb_to_input_id(d->udev, &rc->input_id);
-
-	ret = rc_register_device(rc);
-	if (ret) {
-		rc_free_device(rc);
-		return ret;
-	}
-	d->rc_dev = rc;
-
-	/* Start the Interrupt */
-	ret = lme2510_int_read(adap);
-	if (ret < 0) {
-		rc_unregister_device(rc);
-		info("INT Unable to start Interrupt Service");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
 static u8 check_sum(u8 *p, u8 len)
 {
 	u8 sum = 0;
@@ -831,7 +788,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 
 	cold_fw = !cold;
 
-	if (udev->descriptor.idProduct == 0x1122) {
+	if (le16_to_cpu(udev->descriptor.idProduct) == 0x1122) {
 		switch (dvb_usb_lme2510_firmware) {
 		default:
 			dvb_usb_lme2510_firmware = TUNER_S0194;
@@ -1053,8 +1010,11 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 
 
 end:	if (ret) {
-		kfree(adap->fe);
-		adap->fe = NULL;
+		if (adap->fe) {
+			dvb_frontend_detach(adap->fe);
+			adap->fe = NULL;
+		}
+		adap->dev->props.rc.core.rc_codes = NULL;
 		return -ENODEV;
 	}
 
@@ -1097,8 +1057,12 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
-	/* Start the Interrupt & Remote*/
-	ret = lme2510_int_service(adap);
+	/* Start the Interrupt*/
+	ret = lme2510_int_read(adap);
+	if (ret < 0) {
+		info("INT Unable to start Interrupt Service");
+		return -ENODEV;
+	}
 
 	return ret;
 }
@@ -1204,6 +1168,12 @@ static struct dvb_usb_device_properties lme2510_properties = {
 			}
 		}
 	},
+	.rc.core = {
+		.protocol	= RC_TYPE_NEC,
+		.module_name	= "LME2510 Remote Control",
+		.allowed_protos	= RC_TYPE_NEC,
+		.rc_codes	= RC_MAP_LME2510,
+	},
 	.power_ctrl       = lme2510_powerup,
 	.identify_state   = lme2510_identify_state,
 	.i2c_algo         = &lme2510_i2c_algo,
@@ -1246,6 +1216,12 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 			}
 		}
 	},
+	.rc.core = {
+		.protocol	= RC_TYPE_NEC,
+		.module_name	= "LME2510 Remote Control",
+		.allowed_protos	= RC_TYPE_NEC,
+		.rc_codes	= RC_MAP_LME2510,
+	},
 	.power_ctrl       = lme2510_powerup,
 	.identify_state   = lme2510_identify_state,
 	.i2c_algo         = &lme2510_i2c_algo,
@@ -1269,19 +1245,21 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 		adap->feedcount = 0;
 	}
 
-	if (st->lme_urb != NULL) {
+	if (st->usb_buffer != NULL) {
 		st->i2c_talk_onoff = 1;
 		st->signal_lock = 0;
 		st->signal_level = 0;
 		st->signal_sn = 0;
 		buffer = st->usb_buffer;
+	}
+
+	if (st->lme_urb != NULL) {
 		usb_kill_urb(st->lme_urb);
 		usb_free_coherent(d->udev, 5000, st->buffer,
 				  st->lme_urb->transfer_dma);
 		info("Interrupt Service Stopped");
-		rc_unregister_device(d->rc_dev);
-		info("Remote Stopped");
 	}
+
 	return buffer;
 }
 
@@ -1293,7 +1271,8 @@ static void lme2510_exit(struct usb_interface *intf)
 	if (d != NULL) {
 		usb_buffer = lme2510_exit_int(d);
 		dvb_usb_device_exit(intf);
-		kfree(usb_buffer);
+		if (usb_buffer != NULL)
+			kfree(usb_buffer);
 	}
 }
 
@@ -1327,5 +1306,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.86");
+MODULE_VERSION("1.88");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index afae14f..129d3f9 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -14,81 +14,81 @@
 
 static struct rc_map_table lme2510_rc[] = {
 	/* Type 1 - 26 buttons */
-	{ 0xef12ba45, KEY_0 },
-	{ 0xef12a05f, KEY_1 },
-	{ 0xef12af50, KEY_2 },
-	{ 0xef12a25d, KEY_3 },
-	{ 0xef12be41, KEY_4 },
-	{ 0xef12f50a, KEY_5 },
-	{ 0xef12bd42, KEY_6 },
-	{ 0xef12b847, KEY_7 },
-	{ 0xef12b649, KEY_8 },
-	{ 0xef12fa05, KEY_9 },
-	{ 0xef12bc43, KEY_POWER },
-	{ 0xef12b946, KEY_SUBTITLE },
-	{ 0xef12f906, KEY_PAUSE },
-	{ 0xef12fc03, KEY_MEDIA_REPEAT},
-	{ 0xef12fd02, KEY_PAUSE },
-	{ 0xef12a15e, KEY_VOLUMEUP },
-	{ 0xef12a35c, KEY_VOLUMEDOWN },
-	{ 0xef12f609, KEY_CHANNELUP },
-	{ 0xef12e51a, KEY_CHANNELDOWN },
-	{ 0xef12e11e, KEY_PLAY },
-	{ 0xef12e41b, KEY_ZOOM },
-	{ 0xef12a659, KEY_MUTE },
-	{ 0xef12a55a, KEY_TV },
-	{ 0xef12e718, KEY_RECORD },
-	{ 0xef12f807, KEY_EPG },
-	{ 0xef12fe01, KEY_STOP },
+	{ 0x10ed45, KEY_0 },
+	{ 0x10ed5f, KEY_1 },
+	{ 0x10ed50, KEY_2 },
+	{ 0x10ed5d, KEY_3 },
+	{ 0x10ed41, KEY_4 },
+	{ 0x10ed0a, KEY_5 },
+	{ 0x10ed42, KEY_6 },
+	{ 0x10ed47, KEY_7 },
+	{ 0x10ed49, KEY_8 },
+	{ 0x10ed05, KEY_9 },
+	{ 0x10ed43, KEY_POWER },
+	{ 0x10ed46, KEY_SUBTITLE },
+	{ 0x10ed06, KEY_PAUSE },
+	{ 0x10ed03, KEY_MEDIA_REPEAT},
+	{ 0x10ed02, KEY_PAUSE },
+	{ 0x10ed5e, KEY_VOLUMEUP },
+	{ 0x10ed5c, KEY_VOLUMEDOWN },
+	{ 0x10ed09, KEY_CHANNELUP },
+	{ 0x10ed1a, KEY_CHANNELDOWN },
+	{ 0x10ed1e, KEY_PLAY },
+	{ 0x10ed1b, KEY_ZOOM },
+	{ 0x10ed59, KEY_MUTE },
+	{ 0x10ed5a, KEY_TV },
+	{ 0x10ed18, KEY_RECORD },
+	{ 0x10ed07, KEY_EPG },
+	{ 0x10ed01, KEY_STOP },
 	/* Type 2 - 20 buttons */
-	{ 0xff40ea15, KEY_0 },
-	{ 0xff40f708, KEY_1 },
-	{ 0xff40f609, KEY_2 },
-	{ 0xff40f50a, KEY_3 },
-	{ 0xff40f30c, KEY_4 },
-	{ 0xff40f20d, KEY_5 },
-	{ 0xff40f10e, KEY_6 },
-	{ 0xff40ef10, KEY_7 },
-	{ 0xff40ee11, KEY_8 },
-	{ 0xff40ed12, KEY_9 },
-	{ 0xff40ff00, KEY_POWER },
-	{ 0xff40fb04, KEY_MEDIA_REPEAT}, /* Recall */
-	{ 0xff40e51a, KEY_PAUSE }, /* Timeshift */
-	{ 0xff40fd02, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
-	{ 0xff40f906, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
-	{ 0xff40fe01, KEY_CHANNELUP },
-	{ 0xff40fa05, KEY_CHANNELDOWN },
-	{ 0xff40eb14, KEY_ZOOM },
-	{ 0xff40e718, KEY_RECORD },
-	{ 0xff40e916, KEY_STOP },
+	{ 0xbf15, KEY_0 },
+	{ 0xbf08, KEY_1 },
+	{ 0xbf09, KEY_2 },
+	{ 0xbf0a, KEY_3 },
+	{ 0xbf0c, KEY_4 },
+	{ 0xbf0d, KEY_5 },
+	{ 0xbf0e, KEY_6 },
+	{ 0xbf10, KEY_7 },
+	{ 0xbf11, KEY_8 },
+	{ 0xbf12, KEY_9 },
+	{ 0xbf00, KEY_POWER },
+	{ 0xbf04, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0xbf1a, KEY_PAUSE }, /* Timeshift */
+	{ 0xbf02, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0xbf06, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
+	{ 0xbf01, KEY_CHANNELUP },
+	{ 0xbf05, KEY_CHANNELDOWN },
+	{ 0xbf14, KEY_ZOOM },
+	{ 0xbf18, KEY_RECORD },
+	{ 0xbf16, KEY_STOP },
 	/* Type 3 - 20 buttons */
-	{ 0xff00e31c, KEY_0 },
-	{ 0xff00f807, KEY_1 },
-	{ 0xff00ea15, KEY_2 },
-	{ 0xff00f609, KEY_3 },
-	{ 0xff00e916, KEY_4 },
-	{ 0xff00e619, KEY_5 },
-	{ 0xff00f20d, KEY_6 },
-	{ 0xff00f30c, KEY_7 },
-	{ 0xff00e718, KEY_8 },
-	{ 0xff00a15e, KEY_9 },
-	{ 0xff00ba45, KEY_POWER },
-	{ 0xff00bb44, KEY_MEDIA_REPEAT}, /* Recall */
-	{ 0xff00b54a, KEY_PAUSE }, /* Timeshift */
-	{ 0xff00b847, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
-	{ 0xff00bc43, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
-	{ 0xff00b946, KEY_CHANNELUP },
-	{ 0xff00bf40, KEY_CHANNELDOWN },
-	{ 0xff00f708, KEY_ZOOM },
-	{ 0xff00bd42, KEY_RECORD },
-	{ 0xff00a55a, KEY_STOP },
+	{ 0x1c, KEY_0 },
+	{ 0x07, KEY_1 },
+	{ 0x15, KEY_2 },
+	{ 0x09, KEY_3 },
+	{ 0x16, KEY_4 },
+	{ 0x19, KEY_5 },
+	{ 0x0d, KEY_6 },
+	{ 0x0c, KEY_7 },
+	{ 0x18, KEY_8 },
+	{ 0x5e, KEY_9 },
+	{ 0x45, KEY_POWER },
+	{ 0x44, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0x4a, KEY_PAUSE }, /* Timeshift */
+	{ 0x47, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0x43, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
+	{ 0x46, KEY_CHANNELUP },
+	{ 0x40, KEY_CHANNELDOWN },
+	{ 0x08, KEY_ZOOM },
+	{ 0x42, KEY_RECORD },
+	{ 0x5a, KEY_STOP },
 };
 
 static struct rc_map_list lme2510_map = {
 	.map = {
 		.scan    = lme2510_rc,
 		.size    = ARRAY_SIZE(lme2510_rc),
-		.rc_type = RC_TYPE_UNKNOWN,
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_LME2510,
 	}
 };
-- 
1.7.4.1


