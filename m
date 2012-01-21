Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4j6h017803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 29/35] [media] az6007: Protect read/write calls with a mutex
Date: Sat, 21 Jan 2012 14:04:31 -0200
Message-Id: <1327161877-16784-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-29-git-send-email-mchehab@redhat.com>
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
 <1327161877-16784-28-git-send-email-mchehab@redhat.com>
 <1327161877-16784-29-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will avoid interference with CI and IR I/O operations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  122 ++++++++++++++++++------------------
 1 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 534d326..6177332 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -53,17 +53,11 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define AZ6007_READ_IR		0xb4
 
 struct az6007_device_state {
-	struct			dvb_ca_en50221 ca;
-	struct			mutex ca_mutex;
-	unsigned		warm : 1;
-
-	/* Due to DRX-K - probably need changes */
+	struct mutex		mutex;
+	struct dvb_ca_en50221	ca;
+	unsigned		warm:1;
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
-	bool			tuner_attached;
-
 	unsigned char		data[4096];
-
-	struct usb_data_stream *stream;
 };
 
 static struct drxk_config terratec_h7_drxk = {
@@ -107,8 +101,7 @@ static struct mt2063_config az6007_mt2063_config = {
 	.refclock = 36125000,
 };
 
-/* check for mutex FIXME */
-static int az6007_read(struct usb_device *udev, u8 req, u16 value,
+static int __az6007_read(struct usb_device *udev, u8 req, u16 value,
 			    u16 index, u8 *b, int blen)
 {
 	int ret;
@@ -130,7 +123,23 @@ static int az6007_read(struct usb_device *udev, u8 req, u16 value,
 	return ret;
 }
 
-static int az6007_write(struct usb_device *udev, u8 req, u16 value,
+static int az6007_read(struct dvb_usb_device *d, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
+{
+	struct az6007_device_state *st = d->priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&st->mutex) < 0)
+		return -EAGAIN;
+
+	ret = __az6007_read(d->udev, req, value, index, b, blen);
+
+	mutex_unlock(&st->mutex);
+
+	return ret;
+}
+
+static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 			     u16 index, u8 *b, int blen)
 {
 	int ret;
@@ -158,11 +167,29 @@ static int az6007_write(struct usb_device *udev, u8 req, u16 value,
 	return 0;
 }
 
+static int az6007_write(struct dvb_usb_device *d, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
+{
+	struct az6007_device_state *st = d->priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&st->mutex) < 0)
+		return -EAGAIN;
+
+	ret = __az6007_write(d->udev, req, value, index, b, blen);
+
+	mutex_unlock(&st->mutex);
+
+	return ret;
+}
+
 static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
+	struct dvb_usb_device *d = adap->dev;
+
 	deb_info("%s: %s", __func__, onoff ? "enable" : "disable");
 
-	return az6007_write(adap->dev->udev, 0xbc, onoff, 0, NULL, 0);
+	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
 }
 
 /* keys for the enclosed remote control */
@@ -185,7 +212,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	 */
 	return 0;
 
-	az6007_read(d->udev, AZ6007_READ_IR, 0, 0, key, 10);
+	az6007_read(d, AZ6007_READ_IR, 0, 0, key, 10);
 
 	if (key[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
@@ -218,7 +245,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
 	int ret;
-	ret = az6007_read(d->udev, AZ6007_READ_DATA, 6, 0, mac, 6);
+	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, mac, 6);
 
 	if (ret > 0)
 		deb_info("%s: mac is %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -228,18 +255,6 @@ static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 	return ret;
 }
 
-static int az6007_led_on_off(struct usb_interface *intf, int onoff)
-{
-	struct usb_device *udev = interface_to_usbdev(intf);
-	int ret;
-
-	/* TS through */
-	ret = az6007_write(udev, AZ6007_POWER, onoff, 0, NULL, 0);
-	if (ret < 0)
-		err("%s failed with error %d", __func__, ret);
-	return ret;
-}
-
 static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct az6007_device_state *st = adap->dev->priv;
@@ -260,11 +275,6 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	struct az6007_device_state *st = adap->dev->priv;
-
-	if (st->tuner_attached)
-		return 0;
-
 	deb_info("attaching tuner mt2063");
 
 	/* Attach mt2063 to DVB-C frontend */
@@ -278,53 +288,45 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
 		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 0);
 
-	st->tuner_attached = true;
-
 	return 0;
 }
 
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	struct az6007_device_state *st = d->priv;
-	struct usb_device *udev = d->udev;
 	int ret;
 
 	deb_info("%s()\n", __func__);
 
 	if (!st->warm) {
-		u8 data[6];
+		mutex_init(&st->mutex);
 
-		az6007_read(udev, FX2_OED, 1, 0, data, 1); /* {0x01} */
-		az6007_read(udev, AZ6007_READ_DATA, 0, 8160, data, 1); /* {0x20} */
-		az6007_read(udev, AZ6007_READ_DATA, 0, 0, data, 5); /* {0x00, 0x00, 0x00, 0x00, 0x0a} */
-		az6007_read(udev, AZ6007_READ_DATA, 0, 4080, data, 6); /* {0x00, 0x08, 0x00, 0x0c, 0x22, 0x38} */
-
-		ret = az6007_write(udev, AZ6007_POWER, 0, 2, NULL, 0);
+		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
 		if (ret < 0)
 			return ret;
 		msleep(60);
-		ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+		ret = az6007_write(d, AZ6007_POWER, 1, 4, NULL, 0);
 		if (ret < 0)
 			return ret;
 		msleep(100);
-		ret = az6007_write(udev, AZ6007_POWER, 1, 3, NULL, 0);
+		ret = az6007_write(d, AZ6007_POWER, 1, 3, NULL, 0);
 		if (ret < 0)
 			return ret;
 		msleep(20);
-		ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+		ret = az6007_write(d, AZ6007_POWER, 1, 4, NULL, 0);
 		if (ret < 0)
 			return ret;
 
 		msleep(400);
-		ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
+		ret = az6007_write(d, FX2_SCON1, 0, 3, NULL, 0);
 		if (ret < 0)
 			return ret;
 		msleep (150);
-		ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
+		ret = az6007_write(d, FX2_SCON1, 1, 3, NULL, 0);
 		if (ret < 0)
 			return ret;
 		msleep (430);
-		ret = az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
+		ret = az6007_write(d, AZ6007_POWER, 0, 0, NULL, 0);
 		if (ret < 0)
 			return ret;
 
@@ -336,8 +338,8 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 	if (!onoff)
 		return 0;
 
-	az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
-	az6007_write(udev, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
+	az6007_write(d, AZ6007_POWER, 0, 0, NULL, 0);
+	az6007_write(d, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
 
 	return 0;
 }
@@ -355,7 +357,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	int length;
 	u8 req, addr;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+	if (mutex_lock_interruptible(&st->mutex) < 0)
 		return -EAGAIN;
 
 	for (i = 0; i < num; i++) {
@@ -379,7 +381,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
-			ret = az6007_read(d->udev, req, value, index, st->data,
+			ret = __az6007_read(d->udev, req, value, index, st->data,
 					       length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
@@ -410,7 +412,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 				if (dvb_usb_az6007_debug & 2)
 					printk(KERN_CONT "0x%02x ", st->data[j]);
 			}
-			ret =  az6007_write(d->udev, req, value, index, st->data,
+			ret =  __az6007_write(d->udev, req, value, index, st->data,
 						 length);
 		} else {
 			/* read bytes */
@@ -423,7 +425,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = az6007_read(d->udev, req, value, index, st->data,
+			ret = __az6007_read(d->udev, req, value, index, st->data,
 					       length);
 			for (j = 0; j < len; j++) {
 				msgs[i].buf[j] = st->data[j + 5];
@@ -438,7 +440,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			goto err;
 	}
 err:
-	mutex_unlock(&d->i2c_mutex);
+	mutex_unlock(&st->mutex);
 
 	if (ret < 0) {
 		info("%s ERROR: %i", __func__, ret);
@@ -465,16 +467,16 @@ int az6007_identify_state(struct usb_device *udev,
 	u8 mac[6];
 
 	/* Try to read the mac address */
-	ret = az6007_read(udev, AZ6007_READ_DATA, 6, 0, mac, 6);
+	ret = __az6007_read(udev, AZ6007_READ_DATA, 6, 0, mac, 6);
 	if (ret == 6)
 		*cold = 0;
 	else
 		*cold = 1;
 
 	if (*cold) {
-		az6007_write(udev, 0x09, 1, 0, NULL, 0);
-		az6007_write(udev, 0x00, 0, 0, NULL, 0);
-		az6007_write(udev, 0x00, 0, 0, NULL, 0);
+		__az6007_write(udev, 0x09, 1, 0, NULL, 0);
+		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
+		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
 	}
 
 	deb_info("Device is on %s state\n", *cold? "warm" : "cold");
@@ -486,7 +488,7 @@ static struct dvb_usb_device_properties az6007_properties;
 static int az6007_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
-	az6007_led_on_off(intf, 0);
+	struct usb_device *udev = interface_to_usbdev(intf);
 
 	return dvb_usb_device_init(intf, &az6007_properties,
 				   THIS_MODULE, NULL, adapter_nr);
-- 
1.7.8

