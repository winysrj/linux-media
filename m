Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4j7P003103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 28/35] [media] az6007: Driver cleanup
Date: Sat, 21 Jan 2012 14:04:30 -0200
Message-Id: <1327161877-16784-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-28-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove commented test code, remove unused poweroff stuff, and
fix the copyright data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   56 ++++++++---------------------------
 1 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index f0e4c01..534d326 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -7,8 +7,9 @@
  *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
  * The original driver's license is GPL, as declared with MODULE_LICENSE()
  *
- *  Driver modifiyed by Mauro Carvalho Chehab <mchehab@redhat.com> in order
- * 	to work with upstream drxk driver, and to fix some bugs.
+ * Copyright (c) 2010-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	Driver modified by in order to work with upstream drxk driver, and
+ *	tons of bugs got fixed.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -58,7 +59,6 @@ struct az6007_device_state {
 
 	/* Due to DRX-K - probably need changes */
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
-	struct			semaphore pll_mutex;
 	bool			tuner_attached;
 
 	unsigned char		data[4096];
@@ -94,17 +94,11 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	if (!st)
 		return -EINVAL;
 
-	if (enable) {
-#if 0
-		down(&st->pll_mutex);
-#endif
+	if (enable)
 		status = st->gate_ctrl(fe, 1);
-	} else {
-#if 0
+	else
 		status = st->gate_ctrl(fe, 0);
-#endif
-		up(&st->pll_mutex);
-	}
+
 	return status;
 }
 
@@ -221,14 +215,6 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	return 0;
 }
 
-#if 0
-int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
-{
-	u8 v = onoff;
-	return az6007_write(d->udev, AZ6007_POWER, v , 3, NULL, 1);
-}
-#endif
-
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
 	int ret;
@@ -246,6 +232,7 @@ static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	int ret;
+
 	/* TS through */
 	ret = az6007_write(udev, AZ6007_POWER, onoff, 0, NULL, 0);
 	if (ret < 0)
@@ -257,8 +244,6 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct az6007_device_state *st = adap->dev->priv;
 
-	BUG_ON(!st);
-
 	deb_info("attaching demod drxk");
 
 	adap->fe_adap[0].fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
@@ -267,8 +252,6 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 		return -EINVAL;
 
 	adap->fe_adap[0].fe->sec_priv = adap;
-	/* FIXME: do we need a pll semaphore? */
-	sema_init(&st->pll_mutex, 1);
 	st->gate_ctrl = adap->fe_adap[0].fe->ops.i2c_gate_ctrl;
 	adap->fe_adap[0].fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 
@@ -282,9 +265,8 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 	if (st->tuner_attached)
 		return 0;
 
-	st->tuner_attached = true;
-
 	deb_info("attaching tuner mt2063");
+
 	/* Attach mt2063 to DVB-C frontend */
 	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
 		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 1);
@@ -296,6 +278,8 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
 		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 0);
 
+	st->tuner_attached = true;
+
 	return 0;
 }
 
@@ -355,25 +339,9 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 	az6007_write(udev, AZ6007_POWER, 0, 0, NULL, 0);
 	az6007_write(udev, AZ6007_TS_THROUGH, 0, 0, NULL, 0);
 
-#if 0
-	// Seems to be a poweroff sequence
-	az6007_write(udev, 0xbc, 1, 3, NULL, 0);
-	az6007_write(udev, 0xbc, 1, 4, NULL, 0);
-	az6007_write(udev, 0xc0, 0, 3, NULL, 0);
-	az6007_write(udev, 0xc0, 1, 3, NULL, 0);
-	az6007_write(udev, 0xbc, 0, 1, NULL, 0);
-#endif
-
 	return 0;
 }
 
-static struct dvb_usb_device_properties az6007_properties;
-
-static void az6007_usb_disconnect(struct usb_interface *intf)
-{
-	dvb_usb_device_exit(intf);
-}
-
 /* I2C */
 static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			   int num)
@@ -513,6 +481,8 @@ int az6007_identify_state(struct usb_device *udev,
 	return 0;
 }
 
+static struct dvb_usb_device_properties az6007_properties;
+
 static int az6007_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
@@ -589,7 +559,6 @@ static struct usb_driver az6007_usb_driver = {
 	.name		= "dvb_usb_az6007",
 	.probe		= az6007_usb_probe,
 	.disconnect = dvb_usb_device_exit,
-	/* .disconnect	= az6007_usb_disconnect, */
 	.id_table	= az6007_usb_table,
 };
 
@@ -619,6 +588,7 @@ module_init(az6007_usb_module_init);
 module_exit(az6007_usb_module_exit);
 
 MODULE_AUTHOR("Henry Wang <Henry.wang@AzureWave.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("Driver for AzureWave 6007 DVB-C/T USB2.0 and clones");
 MODULE_VERSION("1.1");
 MODULE_LICENSE("GPL");
-- 
1.7.8

