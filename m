Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4jFp021383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 27/35] [media] az6007: code cleanups and fixes
Date: Sat, 21 Jan 2012 14:04:29 -0200
Message-Id: <1327161877-16784-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-27-git-send-email-mchehab@redhat.com>
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
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
 <1327161877-16784-27-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several changes were needed to make az6007 to work, producing
the same commands as the original driver. This patch does
that.

While here, be less verbose when debug is not enabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  148 ++++++++++++++++++++----------------
 1 files changed, 83 insertions(+), 65 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 81fdc90..f0e4c01 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -54,12 +54,16 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 struct az6007_device_state {
 	struct			dvb_ca_en50221 ca;
 	struct			mutex ca_mutex;
-	u8			power_state;
+	unsigned		warm : 1;
 
 	/* Due to DRX-K - probably need changes */
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
 	struct			semaphore pll_mutex;
 	bool			tuner_attached;
+
+	unsigned char		data[4096];
+
+	struct usb_data_stream *stream;
 };
 
 static struct drxk_config terratec_h7_drxk = {
@@ -71,7 +75,7 @@ static struct drxk_config terratec_h7_drxk = {
 	.no_i2c_bridge = false,
 	.chunk_size = 64,
 	.mpeg_out_clk_strength = 0x02,
-	.microcode_name = "dvb-usb-terratec-h7-az6007.fw",
+	.microcode_name = "dvb-usb-terratec-h7-drxk.fw",
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
@@ -162,7 +166,9 @@ static int az6007_write(struct usb_device *udev, u8 req, u16 value,
 
 static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	return 0;
+	deb_info("%s: %s", __func__, onoff ? "enable" : "disable");
+
+	return az6007_write(adap->dev->udev, 0xbc, onoff, 0, NULL, 0);
 }
 
 /* keys for the enclosed remote control */
@@ -236,46 +242,6 @@ static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 	return ret;
 }
 
-static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
-{
-	int ret;
-	struct usb_device *udev = adap->dev->udev;
-
-	deb_info("%s: adap=%p adap->dev=%p\n", __func__, adap, adap->dev);
-
-	ret = az6007_write(udev, AZ6007_POWER, 0, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(150);
-	ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(100);
-	ret = az6007_write(udev, AZ6007_POWER, 1, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(100);
-	ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(100);
-	ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep (10);
-	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep (10);
-	ret = az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
-
-error:
-	if (ret < 0)
-		err("%s failed with error %d", __func__, ret);
-
-	return ret;
-}
-
 static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -293,9 +259,8 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 
 	BUG_ON(!st);
 
-	az6007_frontend_poweron(adap);
+	deb_info("attaching demod drxk");
 
-	info("attaching demod drxk");
 	adap->fe_adap[0].fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
 					 &adap->dev->i2c_adap);
 	if (!adap->fe_adap[0].fe)
@@ -319,11 +284,11 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 
 	st->tuner_attached = true;
 
-	info("attaching tuner mt2063");
+	deb_info("attaching tuner mt2063");
 	/* Attach mt2063 to DVB-C frontend */
 	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
 		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 1);
-	if (!dvb_attach(mt2063_attach, adap->fe_adap[0].fe, 
+	if (!dvb_attach(mt2063_attach, adap->fe_adap[0].fe,
 			&az6007_mt2063_config,
 			&adap->dev->i2c_adap))
 		return -EINVAL;
@@ -336,22 +301,69 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	if (!onoff)
-		return 0;
+	struct az6007_device_state *st = d->priv;
+	struct usb_device *udev = d->udev;
+	int ret;
+
+	deb_info("%s()\n", __func__);
+
+	if (!st->warm) {
+		u8 data[6];
+
+		az6007_read(udev, FX2_OED, 1, 0, data, 1); /* {0x01} */
+		az6007_read(udev, AZ6007_READ_DATA, 0, 8160, data, 1); /* {0x20} */
+		az6007_read(udev, AZ6007_READ_DATA, 0, 0, data, 5); /* {0x00, 0x00, 0x00, 0x00, 0x0a} */
+		az6007_read(udev, AZ6007_READ_DATA, 0, 4080, data, 6); /* {0x00, 0x08, 0x00, 0x0c, 0x22, 0x38} */
+
+		ret = az6007_write(udev, AZ6007_POWER, 0, 2, NULL, 0);
+		if (ret < 0)
+			return ret;
+		msleep(60);
+		ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+		if (ret < 0)
+			return ret;
+		msleep(100);
+		ret = az6007_write(udev, AZ6007_POWER, 1, 3, NULL, 0);
+		if (ret < 0)
+			return ret;
+		msleep(20);
+		ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+		if (ret < 0)
+			return ret;
+
+		msleep(400);
+		ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
+		if (ret < 0)
+			return ret;
+		msleep (150);
+		ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
+		if (ret < 0)
+			return ret;
+		msleep (430);
+		ret = az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
+		if (ret < 0)
+			return ret;
 
+		st->warm = true;
 
-	info("Sending poweron sequence");
+		return 0;
+	}
 
-	az6007_write(d->udev, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
+	if (!onoff)
+		return 0;
+
+	az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
+	az6007_write(udev, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
 
 #if 0
 	// Seems to be a poweroff sequence
-	az6007_write(d->udev, 0xbc, 1, 3, NULL, 0);
-	az6007_write(d->udev, 0xbc, 1, 4, NULL, 0);
-	az6007_write(d->udev, 0xc0, 0, 3, NULL, 0);
-	az6007_write(d->udev, 0xc0, 1, 3, NULL, 0);
-	az6007_write(d->udev, 0xbc, 0, 1, NULL, 0);
+	az6007_write(udev, 0xbc, 1, 3, NULL, 0);
+	az6007_write(udev, 0xbc, 1, 4, NULL, 0);
+	az6007_write(udev, 0xc0, 0, 3, NULL, 0);
+	az6007_write(udev, 0xc0, 1, 3, NULL, 0);
+	az6007_write(udev, 0xbc, 0, 1, NULL, 0);
 #endif
+
 	return 0;
 }
 
@@ -367,13 +379,13 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			   int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct az6007_device_state *st = d->priv;
 	int i, j, len;
 	int ret = 0;
 	u16 index;
 	u16 value;
 	int length;
 	u8 req, addr;
-	u8 data[512];
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -399,11 +411,11 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
-			ret = az6007_read(d->udev, req, value, index, data,
+			ret = az6007_read(d->udev, req, value, index, st->data,
 					       length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
-					msgs[i + 1].buf[j] = data[j + 5];
+					msgs[i + 1].buf[j] = st->data[j + 5];
 					if (dvb_usb_az6007_debug & 2)
 						printk(KERN_CONT
 						       "0x%02x ",
@@ -426,11 +438,11 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			if (dvb_usb_az6007_debug & 2)
 				printk(KERN_CONT "(0x%02x) ", msgs[i].buf[0]);
 			for (j = 0; j < len; j++) {
-				data[j] = msgs[i].buf[j + 1];
+				st->data[j] = msgs[i].buf[j + 1];
 				if (dvb_usb_az6007_debug & 2)
-					printk(KERN_CONT "0x%02x ", data[j]);
+					printk(KERN_CONT "0x%02x ", st->data[j]);
 			}
-			ret =  az6007_write(d->udev, req, value, index, data,
+			ret =  az6007_write(d->udev, req, value, index, st->data,
 						 length);
 		} else {
 			/* read bytes */
@@ -443,13 +455,13 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = az6007_read(d->udev, req, value, index, data,
+			ret = az6007_read(d->udev, req, value, index, st->data,
 					       length);
 			for (j = 0; j < len; j++) {
-				msgs[i].buf[j] = data[j + 5];
+				msgs[i].buf[j] = st->data[j + 5];
 				if (dvb_usb_az6007_debug & 2)
 					printk(KERN_CONT
-					       "0x%02x ", data[j + 5]);
+					       "0x%02x ", st->data[j + 5]);
 			}
 		}
 		if (dvb_usb_az6007_debug & 2)
@@ -491,6 +503,12 @@ int az6007_identify_state(struct usb_device *udev,
 	else
 		*cold = 1;
 
+	if (*cold) {
+		az6007_write(udev, 0x09, 1, 0, NULL, 0);
+		az6007_write(udev, 0x00, 0, 0, NULL, 0);
+		az6007_write(udev, 0x00, 0, 0, NULL, 0);
+	}
+
 	deb_info("Device is on %s state\n", *cold? "warm" : "cold");
 	return 0;
 }
-- 
1.7.8

