Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4iZX021367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/35] [media] az6007: Simplify the read/write logic
Date: Sat, 21 Jan 2012 14:04:18 -0200
Message-Id: <1327161877-16784-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-16-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces no functional changes. It basically defines
a macro for each different req found at the driver, and cleans the
code to use them, making easier to understand the code.

With regards to the IR handling code, although the original code
doesn't define what's the request, it is clear, from the USB logs,
that 0xc5 is for IR polling.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  185 +++++++++++++++++-------------------
 1 files changed, 87 insertions(+), 98 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index f098e47..8add81a 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -40,6 +40,17 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))."
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+/* Known requests (Cypress FX2 firmware + az6007 "private" ones*/
+
+#define FX2_OED			0xb5
+#define AZ6007_READ_DATA	0xb7
+#define AZ6007_I2C_RD		0xb9
+#define AZ6007_POWER		0xbc
+#define AZ6007_I2C_WR		0xbd
+#define FX2_SCON1		0xc0
+#define AZ6007_TS_THROUGH	0xc7
+#define AZ6007_READ_IR		0xc5
+
 struct az6007_device_state {
 	struct			dvb_ca_en50221 ca;
 	struct			mutex ca_mutex;
@@ -168,7 +179,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 
 	/* remove the following return to enabled remote querying */
 
-	az6007_read(d->udev, READ_REMOTE_REQ, 0, 0, key, 10);
+	az6007_read(d->udev, AZ6007_READ_IR, 0, 0, key, 10);
 
 	deb_rc("remote query key: %x %d\n", key[1], key[1]);
 
@@ -187,127 +198,104 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 #endif
 }
 
-/*
+#if 0
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	u8 v = onoff;
-	return az6007_write(d->udev,0xBC,v,3,NULL,1);
+	return az6007_write(d->udev, AZ6007_POWER, v , 3, NULL, 1);
 }
-*/
+#endif
 
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
-	az6007_read(d->udev, 0xb7, 6, 0, &mac[0], 6);
-	return 0;
-}
+	int ret;
+	ret = az6007_read(d->udev, AZ6007_READ_DATA, 6, 0, mac, 6);
 
-#define AZ6007_POWER	0xbc
-#define FX2_SCON1		0xc0
-#define AZ6007_TS_THROUGH	0xc7
+	if (ret > 0)
+		deb_info("%s: mac is %02x:%02x:%02x:%02x:%02x:%02x\n",
+			 __func__, mac[0], mac[1], mac[2],
+			 mac[3], mac[4], mac[5]);
+
+	return ret;
+}
 
 static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 {
-	struct dvb_usb_device *d = adap->dev;
+	int ret;
+	struct usb_device *udev = adap->dev->udev;
 
-	deb_info("az6007_frontend_poweron adap=%p adap->dev=%p\n",
-		 adap, adap->dev);
+	deb_info("%s: adap=%p adap->dev=%p\n", __func__, adap, adap->dev);
 
-	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 0, 2, NULL, 0);
+	ret = az6007_write(udev, AZ6007_POWER, 0, 2, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep(150);
-	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep(100);
-	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 3, NULL, 0);
+	ret = az6007_write(udev, AZ6007_POWER, 1, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep(100);
-	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	ret = az6007_write(udev, AZ6007_POWER, 1, 4, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep(100);
-	az6007_write(d->udev, FX2_SCON1 /* 0xc0 */, 0, 3, NULL, 0);
+	ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep (10);
-	az6007_write(d->udev, FX2_SCON1 /* 0xc0 */, 1, 3, NULL, 0);
+	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
 	msleep (10);
-	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 0, 0, NULL, 0);
+	ret = az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
 
-	deb_info("az6007_frontend_poweron: OK\n");
+error:
+	if (ret < 0)
+		err("%s failed with error %d", __func__, ret);
 
-	return 0;
+	return ret;
 }
 
 static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 {
+	struct usb_device *udev = adap->dev->udev;
 	int ret;
-	u8 req;
-	u16 value;
-	u16 index;
-	int blen;
 
 	deb_info("az6007_frontend_reset adap=%p adap->dev=%p\n", adap, adap->dev);
 
 	/* reset demodulator */
-	req = 0xC0;
-	value = 1;		/* high */
-	index = 3;
-	blen = 0;
-	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_reset failed 1 !!!");
-		return -EIO;
-	}
+	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
+	msleep(200);
+	ret = az6007_write(udev, FX2_SCON1, 0, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
+	msleep(200);
+	ret = az6007_write(udev, FX2_SCON1, 1, 3, NULL, 0);
+	if (ret < 0)
+		goto error;
+	msleep(200);
+
+error:
+	if (ret < 0)
+		err("%s failed with error %d", __func__, ret);
 
-	req = 0xC0;
-	value = 0;		/* low */
-	index = 3;
-	blen = 0;
-	msleep_interruptible(200);
-	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_reset failed 2 !!!");
-		return -EIO;
-	}
-	msleep_interruptible(200);
-	req = 0xC0;
-	value = 1;		/* high */
-	index = 3;
-	blen = 0;
-
-	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
-	if (ret != 0) {
-		err("az6007_frontend_reset failed 3 !!!");
-		return -EIO;
-	}
-
-	msleep_interruptible(200);
-
-	deb_info("reset az6007 frontend\n");
-
-	return 0;
+	return ret;
 }
 
 static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 {
-	int ret = -1;
-	u8 req;
-	u16 value;
-	u16 index;
-	int blen;
-	/* TS through */
-	req = 0xBC;
-	value = onoff;
-	index = 0;
-	blen = 0;
-
-	ret = usb_control_msg(interface_to_usbdev(intf),
-			      usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
-			      req,
-			      USB_TYPE_VENDOR | USB_DIR_OUT,
-			      value, index, NULL, blen, 2000);
-
-	if (ret < 0) {
-		warn("usb in operation failed. (%d)", ret);
-		ret = -EIO;
-	} else
-		ret = 0;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int ret;
 
-	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
-		 index);
+	/* TS through */
+	ret = az6007_write(udev, AZ6007_POWER, onoff, 0, NULL, 0);
+	if (ret < 0)
+		err("%s failed with error %d", __func__, ret);
 
 	return ret;
 }
@@ -377,7 +365,7 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	info("Sending poweron sequence");
 
-	az6007_write(d->udev, AZ6007_TS_THROUGH /* 0xc7 */, 0, 0, NULL, 0);
+	az6007_write(d->udev, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
 
 #if 0
 	// Seems to be a poweroff sequence
@@ -429,7 +417,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 				printk(KERN_DEBUG
 				       "az6007 I2C xfer write+read addr=0x%x len=%d/%d: ",
 				       addr, msgs[i].len, msgs[i + 1].len);
-			req = 0xb9;
+			req = AZ6007_I2C_RD;
 			index = msgs[i].buf[0];
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
@@ -453,7 +441,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 				printk(KERN_DEBUG
 				       "az6007 I2C xfer write addr=0x%x len=%d: ",
 				       addr, msgs[i].len);
-			req = 0xbd;
+			req = AZ6007_I2C_WR;
 			index = msgs[i].buf[0];
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
@@ -473,7 +461,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 				printk(KERN_DEBUG
 				       "az6007 I2C xfer read addr=0x%x len=%d: ",
 				       addr, msgs[i].len);
-			req = 0xb9;
+			req = AZ6007_I2C_RD;
 			index = msgs[i].buf[0];
 			value = addr;
 			length = msgs[i].len + 6;
@@ -516,16 +504,17 @@ int az6007_identify_state(struct usb_device *udev,
 			  struct dvb_usb_device_properties *props,
 			  struct dvb_usb_device_description **desc, int *cold)
 {
-	u8 b[16];
-	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-				  0xb7, USB_TYPE_VENDOR | USB_DIR_IN, 6, 0, b,
-				  6, USB_CTRL_GET_TIMEOUT);
-
-	deb_info("FW GET_VERSION length: %d\n", ret);
+	int ret;
+	u8 mac[6];
 
-	*cold = ret <= 0;
+	/* Try to read the mac address */
+	ret = az6007_read(udev, AZ6007_READ_DATA, 6, 0, mac, 6);
+	if (ret == 6)
+		*cold = 0;
+	else
+		*cold = 1;
 
-	deb_info("cold: %d\n", *cold);
+	deb_info("Device is on %s state\n", *cold? "warm" : "cold");
 	return 0;
 }
 
-- 
1.7.8

