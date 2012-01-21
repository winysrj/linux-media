Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4iut017785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/35] [media] az6007: Fix some init sequences and use the right firmwares
Date: Sat, 21 Jan 2012 14:04:16 -0200
Message-Id: <1327161877-16784-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-14-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  105 +++++++++++++++---------------------
 1 files changed, 43 insertions(+), 62 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 87dff93..03e318d 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -56,7 +56,8 @@ static struct drxk_config terratec_h7_drxk = {
 	.single_master = 1,
 	.no_i2c_bridge = 0,
 	.max_size = 64,
-//	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
+	.microcode_name = "dvb-usb-terratec-h7-drxk.fw",
+	.parallel_ts = 1,
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
@@ -200,53 +201,31 @@ static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 	return 0;
 }
 
+#define AZ6007_POWER	0xbc
+#define FX2_SCON1		0xc0
+#define AZ6007_TS_THROUGH	0xc7
+
 static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 {
-	int ret;
-	u8 req;
-	u16 value;
-	u16 index;
-	int blen;
+	struct dvb_usb_device *d = adap->dev;
 
 	deb_info("az6007_frontend_poweron adap=%p adap->dev=%p\n",
 		 adap, adap->dev);
 
-	req = 0xBC;
-	value = 1;		/* power on */
-	index = 3;
-	blen = 0;
-
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_poweron failed!!!");
-		return -EIO;
-	}
-
-	msleep_interruptible(200);
-
-	req = 0xBC;
-	value = 0;		/* power off */
-	index = 3;
-	blen = 0;
-
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_poweron failed!!!");
-		return -EIO;
-	}
-
-	msleep_interruptible(200);
-
-	req = 0xBC;
-	value = 1;		/* power on */
-	index = 3;
-	blen = 0;
+	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 0, 2, NULL, 0);
+	msleep(150);
+	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	msleep(100);
+	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 3, NULL, 0);
+	msleep(100);
+	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	msleep(100);
+	az6007_usb_out_op(d, FX2_SCON1 /* 0xc0 */, 0, 3, NULL, 0);
+	msleep (10);
+	az6007_usb_out_op(d, FX2_SCON1 /* 0xc0 */, 1, 3, NULL, 0);
+	msleep (10);
+	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 0, 0, NULL, 0);
 
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_poweron failed!!!");
-		return -EIO;
-	}
 	deb_info("az6007_frontend_poweron: OK\n");
 
 	return 0;
@@ -333,25 +312,6 @@ static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 	return ret;
 }
 
-static int az6007_frontend_tsbypass(struct dvb_usb_adapter *adap, int onoff)
-{
-	int ret;
-	u8 req;
-	u16 value;
-	u16 index;
-	int blen;
-	/* TS through */
-	req = 0xC7;
-	value = onoff;
-	index = 0;
-	blen = 0;
-
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
-	if (ret != 0)
-		return -EIO;
-	return 0;
-}
-
 static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct az6007_device_state *st = adap->priv;
@@ -409,6 +369,27 @@ out_free:
 	return result;
 }
 
+int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	if (!onoff)
+		return 0;
+
+
+	info("Sending poweron sequence");
+
+	az6007_usb_out_op(d, AZ6007_TS_THROUGH /* 0xc7 */, 0, 0, NULL, 0);
+
+#if 0
+	// Seems to be a poweroff sequence
+	az6007_usb_out_op(d, 0xbc, 1, 3, NULL, 0);
+	az6007_usb_out_op(d, 0xbc, 1, 4, NULL, 0);
+	az6007_usb_out_op(d, 0xc0, 0, 3, NULL, 0);
+	az6007_usb_out_op(d, 0xc0, 1, 3, NULL, 0);
+	az6007_usb_out_op(d, 0xbc, 0, 1, NULL, 0);
+#endif
+	return 0;
+}
+
 static struct dvb_usb_device_properties az6007_properties;
 
 static void az6007_usb_disconnect(struct usb_interface *intf)
@@ -568,7 +549,7 @@ MODULE_DEVICE_TABLE(usb, az6007_usb_table);
 static struct dvb_usb_device_properties az6007_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = CYPRESS_FX2,
-	.firmware            = "dvb-usb-az6007-03.fw",
+	.firmware            = "dvb-usb-terratec-h7-az6007.fw",
 	.no_reconnect        = 1,
 
 	.identify_state		= az6007_identify_state,
@@ -592,7 +573,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 			.size_of_priv     = sizeof(struct az6007_device_state),
 		}
 	},
-	/* .power_ctrl       = az6007_power_ctrl, */
+	.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
 
 	.rc.legacy = {
-- 
1.7.8

