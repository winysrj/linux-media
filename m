Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4hoH017781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/35] [media] az6007: Remove some dead code that doesn't seem to be needed
Date: Sat, 21 Jan 2012 14:04:08 -0200
Message-Id: <1327161877-16784-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-6-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   79 +++++++----------------------------
 1 files changed, 16 insertions(+), 63 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index ed376b8..1fc174b 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -17,17 +17,8 @@ int dvb_usb_az6007_debug;
 module_param_named(debug,dvb_usb_az6007_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
 
-
-static int az6007_type =0;
-module_param(az6007_type, int, 0644);
-MODULE_PARM_DESC(az6007_type, "select delivery mode (0=DVB-T, 1=DVB-T");
-
-//module_param_named(type, 6007_type, int, 0644);
-//MODULE_PARM_DESC(type, "select delivery mode (0=DVB-T, 1=DVB-C)");
-
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-
 struct az6007_device_state {
 	struct dvb_ca_en50221 ca;
 	struct mutex ca_mutex;
@@ -110,57 +101,22 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 {
 	int ret;
 
-#if 0
-	int i=0, cyc=0, rem=0;
-	cyc = blen/64;
-	rem = blen%64;
-#endif
-
 	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
 	debug_dump(b,blen,deb_xfer);
 
-
-#if 0
-	if (blen>64)
-	{
-		for (i=0; i<cyc; i++)
-		{
-			if ((ret = usb_control_msg(d->udev,
-				usb_sndctrlpipe(d->udev,0),
-				req,
-				USB_TYPE_VENDOR | USB_DIR_OUT,
-				value,index+i*64,b+i*64,64,
-				5000)) != 64) {
-				warn("usb out operation failed. (%d)",ret);
-				return -EIO;
-			}
-		}
-
-		if (rem>0)
-		{
-			if ((ret = usb_control_msg(d->udev,
-				usb_sndctrlpipe(d->udev,0),
-				req,
-				USB_TYPE_VENDOR | USB_DIR_OUT,
-				value,index+cyc*64,b+cyc*64,rem,
-				5000)) != rem) {
-				warn("usb out operation failed. (%d)",ret);
-				return -EIO;
-			}
-		}
+	if (blen > 64) {
+		printk(KERN_ERR "az6007: doesn't suport I2C transactions longer than 64 bytes\n");
+		return -EOPNOTSUPP;
 	}
-	else
-#endif
-	{
-		if ((ret = usb_control_msg(d->udev,
-				usb_sndctrlpipe(d->udev,0),
-				req,
-				USB_TYPE_VENDOR | USB_DIR_OUT,
-				value,index,b,blen,
-				5000)) != blen) {
-			warn("usb out operation failed. (%d)",ret);
-			return -EIO;
-		}
+
+	if ((ret = usb_control_msg(d->udev,
+			usb_sndctrlpipe(d->udev,0),
+			req,
+			USB_TYPE_VENDOR | USB_DIR_OUT,
+			value,index,b,blen,
+			5000)) != blen) {
+		warn("usb out operation failed. (%d)",ret);
+		return -EIO;
 	}
 
 	return 0;
@@ -232,7 +188,7 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	info("az6007_frontend_poweron adap=%p adap->dev=%p", adap, adap->dev);
 
 	req = 0xBC;
-	value = 1;//power on
+	value = 1;		/* power on */
 	index = 3;
 	blen =0;
 
@@ -245,7 +201,7 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	msleep_interruptible(200);
 
 	req = 0xBC;
-	value = 0;//power on
+	value = 0;		/* power off */
 	index = 3;
 	blen =0;
 
@@ -258,7 +214,7 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	msleep_interruptible(200);
 
 	req = 0xBC;
-	value = 1;//power on
+	value = 1;		/* power on */
 	index = 3;
 	blen =0;
 
@@ -552,9 +508,6 @@ static u32 az6007_i2c_func(struct i2c_adapter *adapter)
 static struct i2c_algorithm az6007_i2c_algo = {
 	.master_xfer   = az6007_i2c_xfer,
 	.functionality = az6007_i2c_func,
-#ifdef NEED_ALGO_CONTROL
-	.algo_control = dummy_algo_control,
-#endif
 };
 
 int az6007_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
@@ -678,5 +631,5 @@ module_exit(az6007_usb_module_exit);
 
 MODULE_AUTHOR("Henry Wang <Henry.wang@AzureWave.com>");
 MODULE_DESCRIPTION("Driver for AzureWave 6007 DVB-C/T USB2.0 and clones");
-MODULE_VERSION("1.0");
+MODULE_VERSION("1.1");
 MODULE_LICENSE("GPL");
-- 
1.7.8

