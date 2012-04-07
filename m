Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41634 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752375Ab2DGRrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 13:47:05 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: add remote control support
Date: Sat, 7 Apr 2012 19:24:44 +0200
Cc: linux-media@vger.kernel.org,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>,
	Gianluca Gennari <gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204071924.44679.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9035: support remote controls. Currently, for remotes using the NEC protocol,
the map of the TERRATEC_CINERGY_XS remote is loaded, for RC6 the map of
RC_MAP_RC6_MCE.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/dvb-usb/af9035.c |   72 +++++++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/af9035.h |    3 +
 2 files changed, 75 insertions(+)

diff -Nupr a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
--- a/drivers/media/dvb/dvb-usb/af9035.c	2012-04-07 15:59:56.000000000 +0200
+++ b/drivers/media/dvb/dvb-usb/af9035.c	2012-04-07 19:17:55.044874329 +0200
@@ -313,6 +313,41 @@ static struct i2c_algorithm af9035_i2c_a
 	.functionality = af9035_i2c_functionality,
 };
 
+#define AF9035_POLL 250
+static int af9035_rc_query(struct dvb_usb_device *d)
+{
+	unsigned int key;
+	unsigned char b[4];
+	int ret;
+	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, b };
+
+	if (!af9035_config.raw_ir)
+		return 0;
+
+	ret = af9035_ctrl_msg(d->udev, &req);
+	if (ret < 0)
+		goto err;
+
+	if ((b[2] + b[3]) == 0xff) {
+		if ((b[0] + b[1]) == 0xff) {
+			/* NEC */
+			key = b[0] << 8 | b[2];
+		} else {
+			/* ext. NEC */
+			key = b[0] << 16 | b[1] << 8 | b[2];
+		}
+	} else {
+		key = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
+	}
+
+	if (d->rc_dev != NULL)
+		rc_keydown(d->rc_dev, key, 0);
+
+err:
+	/* ignore errors */
+	return 0;
+}
+
 static int af9035_init(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -627,6 +662,34 @@ static int af9035_read_mac_address(struc
 	for (i = 0; i < af9035_properties[0].num_adapters; i++)
 		af9035_af9033_config[i].clock = clock_lut[tmp];
 
+	ret = af9035_rd_reg(d, EEPROM_IR_MODE, &tmp);
+	if (ret < 0)
+		goto err;
+	pr_debug("%s: ir_mode=%02x\n", __func__, tmp);
+	af9035_config.raw_ir = tmp == 5;
+
+	if (af9035_config.raw_ir) {
+		ret = af9035_rd_reg(d, EEPROM_IR_TYPE, &tmp);
+		if (ret < 0)
+			goto err;
+		pr_debug("%s: ir_type=%02x\n", __func__, tmp);
+
+		switch (tmp) {
+		case 0: /* NEC */
+		default:
+			af9035_config.ir_rc6 = false;
+			d->props.rc.core.protocol = RC_TYPE_NEC;
+			d->props.rc.core.rc_codes =
+				RC_MAP_NEC_TERRATEC_CINERGY_XS;
+			break;
+		case 1: /* RC6 */
+			af9035_config.ir_rc6 = true;
+			d->props.rc.core.protocol = RC_TYPE_RC6;
+			d->props.rc.core.rc_codes = RC_MAP_RC6_MCE;
+			break;
+		}
+	}
+
 	return 0;
 
 err:
@@ -1003,6 +1066,15 @@ static struct dvb_usb_device_properties
 
 		.i2c_algo = &af9035_i2c_algo,
 
+		.rc.core = {
+			.protocol       = RC_TYPE_NEC,
+			.module_name    = "af9035",
+			.rc_query       = af9035_rc_query,
+			.rc_interval    = AF9035_POLL,
+			.allowed_protos = RC_TYPE_NEC | RC_TYPE_RC6,
+			.rc_codes       = RC_MAP_EMPTY, /* may be changed in
+						   af9035_read_mac_address */
+		},
 		.num_device_descs = 5,
 		.devices = {
 			{
diff -Nupr a/drivers/media/dvb/dvb-usb/af9035.h b/drivers/media/dvb/dvb-usb/af9035.h
--- a/drivers/media/dvb/dvb-usb/af9035.h	2012-04-07 15:58:43.000000000 +0200
+++ b/drivers/media/dvb/dvb-usb/af9035.h	2012-04-07 17:35:08.517840044 +0200
@@ -49,6 +49,8 @@ struct usb_req {
 
 struct config {
 	bool dual_mode;
+	bool raw_ir;
+	bool ir_rc6;
 	bool hw_not_supported;
 };
 
@@ -96,6 +98,7 @@ u32 clock_lut_it9135[] = {
 #define CMD_MEM_WR                  0x01
 #define CMD_I2C_RD                  0x02
 #define CMD_I2C_WR                  0x03
+#define CMD_IR_GET                  0x18
 #define CMD_FW_DL                   0x21
 #define CMD_FW_QUERYINFO            0x22
 #define CMD_FW_BOOT                 0x23

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
