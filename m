Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4ifO003094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/35] [media] az6007: Change the az6007 read/write routine parameter
Date: Sat, 21 Jan 2012 14:04:17 -0200
Message-Id: <1327161877-16784-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-15-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use usb_device for those routines, as it allows using them on
all places. While there, rename to better express the meaning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   56 ++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 03e318d..f098e47 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -96,13 +96,13 @@ static struct mt2063_config az6007_mt2063_config = {
 };
 
 /* check for mutex FIXME */
-static int az6007_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
+static int az6007_read(struct usb_device *udev, u8 req, u16 value,
 			    u16 index, u8 *b, int blen)
 {
 	int ret = -1;
 
-	ret = usb_control_msg(d->udev,
-			      usb_rcvctrlpipe(d->udev, 0),
+	ret = usb_control_msg(udev,
+			      usb_rcvctrlpipe(udev, 0),
 			      req,
 			      USB_TYPE_VENDOR | USB_DIR_IN,
 			      value, index, b, blen, 5000);
@@ -119,7 +119,7 @@ static int az6007_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
 	return ret;
 }
 
-static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
+static int az6007_write(struct usb_device *udev, u8 req, u16 value,
 			     u16 index, u8 *b, int blen)
 {
 	int ret;
@@ -134,8 +134,8 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 		return -EOPNOTSUPP;
 	}
 
-	ret = usb_control_msg(d->udev,
-			      usb_sndctrlpipe(d->udev, 0),
+	ret = usb_control_msg(udev,
+			      usb_sndctrlpipe(udev, 0),
 			      req,
 			      USB_TYPE_VENDOR | USB_DIR_OUT,
 			      value, index, b, blen, 5000);
@@ -168,7 +168,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 
 	/* remove the following return to enabled remote querying */
 
-	az6007_usb_in_op(d, READ_REMOTE_REQ, 0, 0, key, 10);
+	az6007_read(d->udev, READ_REMOTE_REQ, 0, 0, key, 10);
 
 	deb_rc("remote query key: %x %d\n", key[1], key[1]);
 
@@ -191,13 +191,13 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	u8 v = onoff;
-	return az6007_usb_out_op(d,0xBC,v,3,NULL,1);
+	return az6007_write(d->udev,0xBC,v,3,NULL,1);
 }
 */
 
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
-	az6007_usb_in_op(d, 0xb7, 6, 0, &mac[0], 6);
+	az6007_read(d->udev, 0xb7, 6, 0, &mac[0], 6);
 	return 0;
 }
 
@@ -212,19 +212,19 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	deb_info("az6007_frontend_poweron adap=%p adap->dev=%p\n",
 		 adap, adap->dev);
 
-	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 0, 2, NULL, 0);
+	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 0, 2, NULL, 0);
 	msleep(150);
-	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
 	msleep(100);
-	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 3, NULL, 0);
+	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 3, NULL, 0);
 	msleep(100);
-	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
+	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 1, 4, NULL, 0);
 	msleep(100);
-	az6007_usb_out_op(d, FX2_SCON1 /* 0xc0 */, 0, 3, NULL, 0);
+	az6007_write(d->udev, FX2_SCON1 /* 0xc0 */, 0, 3, NULL, 0);
 	msleep (10);
-	az6007_usb_out_op(d, FX2_SCON1 /* 0xc0 */, 1, 3, NULL, 0);
+	az6007_write(d->udev, FX2_SCON1 /* 0xc0 */, 1, 3, NULL, 0);
 	msleep (10);
-	az6007_usb_out_op(d, AZ6007_POWER /* 0xbc */, 0, 0, NULL, 0);
+	az6007_write(d->udev, AZ6007_POWER /* 0xbc */, 0, 0, NULL, 0);
 
 	deb_info("az6007_frontend_poweron: OK\n");
 
@@ -246,7 +246,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	value = 1;		/* high */
 	index = 3;
 	blen = 0;
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
 	if (ret != 0) {
 		err("az6007_frontend_reset failed 1 !!!");
 		return -EIO;
@@ -257,7 +257,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	index = 3;
 	blen = 0;
 	msleep_interruptible(200);
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
 	if (ret != 0) {
 		err("az6007_frontend_reset failed 2 !!!");
 		return -EIO;
@@ -268,7 +268,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	index = 3;
 	blen = 0;
 
-	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	ret = az6007_write(adap->dev->udev, req, value, index, NULL, blen);
 	if (ret != 0) {
 		err("az6007_frontend_reset failed 3 !!!");
 		return -EIO;
@@ -377,15 +377,15 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	info("Sending poweron sequence");
 
-	az6007_usb_out_op(d, AZ6007_TS_THROUGH /* 0xc7 */, 0, 0, NULL, 0);
+	az6007_write(d->udev, AZ6007_TS_THROUGH /* 0xc7 */, 0, 0, NULL, 0);
 
 #if 0
 	// Seems to be a poweroff sequence
-	az6007_usb_out_op(d, 0xbc, 1, 3, NULL, 0);
-	az6007_usb_out_op(d, 0xbc, 1, 4, NULL, 0);
-	az6007_usb_out_op(d, 0xc0, 0, 3, NULL, 0);
-	az6007_usb_out_op(d, 0xc0, 1, 3, NULL, 0);
-	az6007_usb_out_op(d, 0xbc, 0, 1, NULL, 0);
+	az6007_write(d->udev, 0xbc, 1, 3, NULL, 0);
+	az6007_write(d->udev, 0xbc, 1, 4, NULL, 0);
+	az6007_write(d->udev, 0xc0, 0, 3, NULL, 0);
+	az6007_write(d->udev, 0xc0, 1, 3, NULL, 0);
+	az6007_write(d->udev, 0xbc, 0, 1, NULL, 0);
 #endif
 	return 0;
 }
@@ -434,7 +434,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
-			ret = az6007_usb_in_op(d, req, value, index, data,
+			ret = az6007_read(d->udev, req, value, index, data,
 					       length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
@@ -465,7 +465,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 				if (dvb_usb_az6007_debug & 2)
 					printk(KERN_CONT "0x%02x ", data[j]);
 			}
-			ret =  az6007_usb_out_op(d, req, value, index, data,
+			ret =  az6007_write(d->udev, req, value, index, data,
 						 length);
 		} else {
 			/* read bytes */
@@ -478,7 +478,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = az6007_usb_in_op(d, req, value, index, data,
+			ret = az6007_read(d->udev, req, value, index, data,
 					       length);
 			for (j = 0; j < len; j++) {
 				msgs[i].buf[j] = data[j + 5];
-- 
1.7.8

