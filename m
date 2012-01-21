Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4gW5017771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/35] [media] az6007: Fix it to allow loading it without crash
Date: Sat, 21 Jan 2012 14:04:05 -0200
Message-Id: <1327161877-16784-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-3-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some fixes to allow frontend attachment. The patch is not
complete yet, as just the frontend 0 is initialized. So, more
changes will be needed, including some changes at dvb-usb core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  190 ++++++++++++++++++-----------------
 1 files changed, 98 insertions(+), 92 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 5873759..6a21f92 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -49,12 +49,20 @@ struct drxk_config terratec_h7_drxk = {
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct dvb_usb_adapter *adap = fe->sec_priv;
-	struct az6007_device_state *st = adap->priv;
+	struct az6007_device_state *st;
 	int status;
 
-	if (!adap || !st)
+	info("%s", __func__);
+
+	if (!adap)
+		return -EINVAL;
+
+	st = adap->priv;
+
+	if (!st)
 		return -EINVAL;
 
+
 	if (enable) {
 		down(&st->pll_mutex);
 		status = st->gate_ctrl(fe, 1);
@@ -66,7 +74,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 struct mt2063_config az6007_mt2063_config = {
-	.tuner_address = 0xc0,
+	.tuner_address = 0x60,
 	.refclock = 36125000,
 };
 
@@ -84,10 +92,8 @@ int az6007_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 
 	if (ret < 0) {
 		warn("usb in operation failed. (%d)", ret);
-		ret = -EIO;
-	} else
-		ret = 0;
-
+		return -EIO;
+	}
 
 	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
 	debug_dump(b,blen,deb_xfer);
@@ -219,7 +225,7 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	u16 index;
 	int blen;
 
-	info("az6007_frontend_poweron adap=%p adap->dev=%p\n", adap, adap->dev);
+	info("az6007_frontend_poweron adap=%p adap->dev=%p", adap, adap->dev);
 
 	req = 0xBC;
 	value = 1;//power on
@@ -257,7 +263,8 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 		err("az6007_frontend_poweron failed!!!");
 		 return -EIO;
 	}
-	info("az6007_frontend_poweron\n");
+	info("az6007_frontend_poweron: OK");
+
 	return 0;
 }
 
@@ -269,7 +276,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	u16 index;
 	int blen;
 
-	info("az6007_frontend_reset adap=%p adap->dev=%p\n", adap, adap->dev);
+	info("az6007_frontend_reset adap=%p adap->dev=%p", adap, adap->dev);
 
 	//reset demodulator
 	req = 0xC0;
@@ -306,7 +313,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 
 	msleep_interruptible(200);
 
-	info("reset az6007 frontend\n");
+	info("reset az6007 frontend");
 
 	return 0;
 }
@@ -367,10 +374,12 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 
 	int result;
 
+	BUG_ON(!st);
+
 	az6007_frontend_poweron(adap);
 	az6007_frontend_reset(adap);
 
-	info("az6007_frontend_attach\n");
+	info("az6007_frontend_attach: drxk");
 
 	adap->fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
 			      &adap->dev->i2c_adap, &adap->fe2);
@@ -379,6 +388,8 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 		goto out_free;
 	}
 
+	info("Setting hacks");
+
 	/* FIXME: do we need a pll semaphore? */
 	adap->fe->sec_priv = adap;
 	sema_init(&st->pll_mutex, 1);
@@ -386,6 +397,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	adap->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 	adap->fe2->id = 1;
 
+	info("az6007_frontend_attach: mt2063");
 	/* Attach mt2063 to DVB-C frontend */
 	if (adap->fe->ops.i2c_gate_ctrl)
 		adap->fe->ops.i2c_gate_ctrl(adap->fe, 1);
@@ -423,100 +435,95 @@ az6007_usb_disconnect(struct usb_interface *intf)
 }
 
 /* I2C */
-static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)
+static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int j=0,len=0;
-	int ret=0;
+	int i, j, len;
+	int ret = 0;
 	u16 index;
 	u16 value;
 	int length;
-	u8 req;
+	u8 req, addr;
 	u8 data[512];
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
-	if (num > 2)
-		warn("more than 2 i2c messages at a time is not handled yet. TODO.");
 
-
-	if (msg[0].addr == 0xc0) //MT2063
-	{
-		if (msg[0].flags != I2C_M_RD) //write
-		{
-			//printk("Tuner Tuner Write DevAddr=%02x  RegAddr=%d\n", msg[0].addr, msg[0].buf[0]);
-			req = 0xBD;
-			index = msg[0].buf[0];
-			value = msg[0].addr | (1<<8);
-			length = msg[0].len - 1;
-			len = msg[0].len - 1;
-			//printk("Tuner Tuner WriteDATA len=%d ", len);
-			for(j=0;j<len;j++)
-			{
-				data[j] = msg[0].buf[j+1];
-				//printk("data[%d]=%02x ", j, data[j]);
-			}
-			//printk("\n");
-			ret = az6007_usb_out_op(d,req,value,index,data,length);
-			//ret = az6007_usb_out_op(d,req,value,index,&(msg[0].buf[1]),length);
-		}
-		else //read
-		{
-			//printk("Tuner Tuner Read DevAddr=%02x RegAddr=%02x\n", msg[0].addr, msg[0].buf[0]);
-			req = 0xB9;
-			index = msg[0].buf[0];
-			value = msg[0].addr + (1 << 8);
-			length = msg[1].len + 6;
+	for (i = 0; i < num; i++) {
+		addr = msgs[i].addr << 1;
+
+		if (((i + 1) < num)
+		    && (msgs[i].len == 1)
+		    && (!msgs[i].flags & I2C_M_RD)
+		    && (msgs[i + 1].flags & I2C_M_RD)
+		    && (msgs[i].addr == msgs[i + 1].addr)) {
+			/*
+			 * A write + read xfer for the same address, where
+			 * the first xfer has just 1 byte length.
+			 * Need to join both into one operation
+			 */
+			printk("az6007 I2C xfer write+read addr=0x%x len=%d/%d: ",
+				addr, msgs[i].len, msgs[i + 1].len);
+			req = 0xb9;
+			index = 0;
+			value = addr;
+			for (j = 0; j < msgs[i].len; j++)
+				data[j] = msgs[i].buf[j];
+			length = 6 + msgs[i + 1].len;
+			len = msgs[i + 1].len;
 			ret = az6007_usb_in_op(d,req,value,index,data,length);
-			len = msg[1].len;
-			//printk("Tuner Tuner ReadDATA len=%d ", len);
-			for (j=0; j<len; j++)
-			{
-				msg[1].buf[j] = data[j+5];
-				//printk("data[%d]=%02x ", j, data[j+5]);
-			}
-			//printk("\n");
-		}
-	}
-	else
-	{	//Demodulator
-		if (msg[0].flags != I2C_M_RD) //write
-		{
-			//printk("Demodulator Write DevAddr=%02x  RegAddr=%d\n", msg[0].addr, msg[0].buf[0]);
-			req = 0xBD;
-			index = msg[0].buf[0];
-			value = msg[0].addr | (1<<8);
-			length = msg[0].len - 1;
-			len = msg[0].len - 1;
-			//printk("Demodulator WriteDATA len=%d ", len);
-			for(j=0;j<len;j++)
+			if (ret >= len) {
+				for (j = 0; j < len; j++) {
+					msgs[i + 1].buf[j] = data[j + 5];
+					printk("0x%02x ", msgs[i + 1].buf[j]);
+				}
+			} else
+				ret = -EIO;
+			i++;
+		} else if (!(msgs[i].flags & I2C_M_RD)) {
+			/* write bytes */
+//			printk("az6007 I2C xfer write addr=0x%x len=%d: ",
+//				 addr, msgs[i].len);
+			req = 0xbd;
+			index = msgs[i].buf[0];
+			value = addr | (1 << 8);
+			length = msgs[i].len - 1;
+			len = msgs[i].len - 1;
+//			printk("(0x%02x) ", msgs[i].buf[0]);
+			for (j = 0; j < len; j++)
 			{
-				data[j] = msg[0].buf[j+1];
-				//printk("data[%d]=%02x ", j, data[j]);
+				data[j] = msgs[i].buf[j + 1];
+//				printk("0x%02x ", data[j]);
 			}
-			//printk("\n");
 			ret = az6007_usb_out_op(d,req,value,index,data,length);
-		}
-		else //read
-		{
-			//printk("Demodulator Read DevAddr=%02x RegAddr=%02x\n", msg[0].addr, msg[0].buf[0]);
-			req = 0xB9;
-			index = 0;
-			value = msg[0].addr + (0 << 8);
-			length = msg[0].len + 6;
+		} else {
+			/* read bytes */
+//			printk("az6007 I2C xfer read addr=0x%x len=%d: ",
+//				 addr, msgs[i].len);
+			req = 0xb9;
+			index = msgs[i].buf[0];
+			value = addr;
+			length = msgs[i].len + 6;
+			len = msgs[i].len;
 			ret = az6007_usb_in_op(d,req,value,index,data,length);
-			len = msg[0].len;
-			//printk("Demodulator ReadDATA len=%d ", len);
-			for (j=0; j<len; j++)
+			for (j = 0; j < len; j++)
 			{
-				msg[0].buf[j] = data[j+5];
-				//printk("data[%d]=%02x ", j, data[j+5]);
+				msgs[i].buf[j] = data[j + 5];
+//				printk("0x%02x ", data[j + 5]);
 			}
-			//printk("\n");
 		}
+//		printk("\n");
+		if (ret < 0)
+			goto err;
 	}
+err:
 	mutex_unlock(&d->i2c_mutex);
-	return ret;
+
+	if (ret < 0) {
+		info("%s ERROR: %i\n", __func__, ret);
+		return ret;
+	}
+	return num;
 }
 
 
@@ -540,11 +547,11 @@ int az6007_identify_state(struct usb_device *udev, struct dvb_usb_device_propert
 	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
 		0xb7, USB_TYPE_VENDOR | USB_DIR_IN, 6, 0, b, 6, USB_CTRL_GET_TIMEOUT);
 
-	info("FW GET_VERSION length: %d\n",ret);
+	info("FW GET_VERSION length: %d",ret);
 
 	*cold = ret <= 0;
 
-	info("cold: %d\n", *cold);
+	info("cold: %d", *cold);
 	return 0;
 }
 
@@ -572,7 +579,6 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.firmware            = "dvb-usb-az6007-03.fw",
 	.no_reconnect        = 1,
 
-	.size_of_priv     = sizeof(struct az6007_device_state),
 	.identify_state		= az6007_identify_state,
 	.num_adapters = 1,
 	.adapter = {
@@ -593,7 +599,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 					}
 				}
 			},
-			.size_of_priv     = 0,//sizeof(struct az6007_state),
+			.size_of_priv     = sizeof(struct az6007_device_state),
 		}
 	},
 	//.power_ctrl       = az6007_power_ctrl,
@@ -634,7 +640,7 @@ static struct usb_driver az6007_usb_driver = {
 static int __init az6007_usb_module_init(void)
 {
 	int result;
-	info("henry :: az6007 usb module init");
+	info("az6007 usb module init");
 	if ((result = usb_register(&az6007_usb_driver))) {
 		err("usb_register failed. (%d)",result);
 		return result;
@@ -646,7 +652,7 @@ static int __init az6007_usb_module_init(void)
 static void __exit az6007_usb_module_exit(void)
 {
 	/* deregister this driver from the USB subsystem */
-	info("henry :: az6007 usb module exit");
+	info("az6007 usb module exit");
 	usb_deregister(&az6007_usb_driver);
 }
 
-- 
1.7.8

