Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4hmb003090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/35] [media] az6007: make driver less verbose
Date: Sat, 21 Jan 2012 14:04:13 -0200
Message-Id: <1327161877-16784-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-11-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 780a480..bb597c6 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -62,9 +62,9 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct dvb_usb_adapter *adap = fe->sec_priv;
 	struct az6007_device_state *st;
-	int status;
+	int status = 0;
 
-	info("%s: %s", __func__, enable ? "enable" : "disable");
+	deb_info("%s: %s\n", __func__, enable ? "enable" : "disable");
 
 	if (!adap)
 		return -EINVAL;
@@ -127,8 +127,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 	debug_dump(b, blen, deb_xfer);
 
 	if (blen > 64) {
-		printk(KERN_ERR
-		       "az6007: doesn't suport I2C transactions longer than 64 bytes\n");
+		err("az6007: doesn't suport I2C transactions longer than 64 bytes\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -138,7 +137,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			      USB_TYPE_VENDOR | USB_DIR_OUT,
 			      value, index, b, blen, 5000);
 	if (ret != blen) {
-		warn("usb out operation failed. (%d)", ret);
+		err("usb out operation failed. (%d)", ret);
 		return -EIO;
 	}
 
@@ -207,7 +206,8 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	u16 index;
 	int blen;
 
-	info("az6007_frontend_poweron adap=%p adap->dev=%p", adap, adap->dev);
+	deb_info("az6007_frontend_poweron adap=%p adap->dev=%p\n",
+		 adap, adap->dev);
 
 	req = 0xBC;
 	value = 1;		/* power on */
@@ -245,7 +245,7 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 		err("az6007_frontend_poweron failed!!!");
 		return -EIO;
 	}
-	info("az6007_frontend_poweron: OK");
+	deb_info("az6007_frontend_poweron: OK\n");
 
 	return 0;
 }
@@ -258,7 +258,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	u16 index;
 	int blen;
 
-	info("az6007_frontend_reset adap=%p adap->dev=%p", adap, adap->dev);
+	deb_info("az6007_frontend_reset adap=%p adap->dev=%p\n", adap, adap->dev);
 
 	/* reset demodulator */
 	req = 0xC0;
@@ -295,7 +295,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 
 	msleep_interruptible(200);
 
-	info("reset az6007 frontend");
+	deb_info("reset az6007 frontend\n");
 
 	return 0;
 }
@@ -361,8 +361,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	az6007_frontend_poweron(adap);
 	az6007_frontend_reset(adap);
 
-	info("az6007_frontend_attach: drxk");
-
+	info("az6007: attaching demod drxk");
 	adap->fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
 			      &adap->dev->i2c_adap, &adap->fe2);
 	if (!adap->fe) {
@@ -370,7 +369,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 		goto out_free;
 	}
 
-	info("Setting hacks");
+	deb_info("Setting hacks\n");
 
 	/* FIXME: do we need a pll semaphore? */
 	adap->fe->sec_priv = adap;
@@ -379,7 +378,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	adap->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 	adap->fe2->id = 1;
 
-	info("az6007_frontend_attach: mt2063");
+	info("az6007: attaching tuner mt2063");
 	/* Attach mt2063 to DVB-C frontend */
 	if (adap->fe->ops.i2c_gate_ctrl)
 		adap->fe->ops.i2c_gate_ctrl(adap->fe, 1);
@@ -513,7 +512,7 @@ err:
 	mutex_unlock(&d->i2c_mutex);
 
 	if (ret < 0) {
-		info("%s ERROR: %i\n", __func__, ret);
+		info("%s ERROR: %i", __func__, ret);
 		return ret;
 	}
 	return num;
@@ -538,11 +537,11 @@ int az6007_identify_state(struct usb_device *udev,
 				  0xb7, USB_TYPE_VENDOR | USB_DIR_IN, 6, 0, b,
 				  6, USB_CTRL_GET_TIMEOUT);
 
-	info("FW GET_VERSION length: %d", ret);
+	deb_info("FW GET_VERSION length: %d\n", ret);
 
 	*cold = ret <= 0;
 
-	info("cold: %d", *cold);
+	deb_info("cold: %d\n", *cold);
 	return 0;
 }
 
@@ -629,7 +628,7 @@ static struct usb_driver az6007_usb_driver = {
 static int __init az6007_usb_module_init(void)
 {
 	int result;
-	info("az6007 usb module init");
+	deb_info("az6007 usb module init\n");
 
 	result = usb_register(&az6007_usb_driver);
 	if (result) {
@@ -643,7 +642,7 @@ static int __init az6007_usb_module_init(void)
 static void __exit az6007_usb_module_exit(void)
 {
 	/* deregister this driver from the USB subsystem */
-	info("az6007 usb module exit");
+	deb_info("az6007 usb module exit\n");
 	usb_deregister(&az6007_usb_driver);
 }
 
-- 
1.7.8

