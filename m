Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4g5X017769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/35] [media] az6007: Fix compilation troubles at az6007
Date: Sat, 21 Jan 2012 14:04:04 -0200
Message-Id: <1327161877-16784-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-2-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some changes are needed, in order to make az6007 compile with the
upstream tree. Most of the changes are due to the upstream drxk
module.

Even allowing its compilation, the driver is not working yet.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    2 +-
 drivers/media/dvb/dvb-usb/az6007.c   |  174 ++++++++++++++++++++--------------
 2 files changed, 104 insertions(+), 72 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index c89af3c..7bbf25d 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -350,7 +350,7 @@ static int MT2063_Sleep(struct dvb_frontend *fe)
 	/*
 	 *  ToDo:  Add code here to implement a OS blocking
 	 */
-	msleep(10);
+	msleep(100);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index cd5dd4c..5873759 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -8,6 +8,10 @@
 #include "mt2063.h"
 #include "dvb_ca_en50221.h"
 
+/* HACK: Should be moved to the right place */
+#define USB_PID_AZUREWAVE_6007		0xccd
+#define USB_PID_TERRATEC_H7		0x10b4
+
 /* debug */
 int dvb_usb_az6007_debug;
 module_param_named(debug,dvb_usb_az6007_debug, int, 0644);
@@ -28,30 +32,39 @@ struct az6007_device_state {
 	struct dvb_ca_en50221 ca;
 	struct mutex ca_mutex;
 	u8 power_state;
-};
 
-struct drxk3913_config az6007_drxk3913_config_DVBT = {	
-	.demod_address = 0x52,
-	.min_delay_ms = 100,
-	.standard	= MTTUNEA_DVBT,
-	.set_tuner = mt2063_setTune,
-	.tuner_getlocked = mt2063_lockStatus,
-	.tuner_MT2063_Open = tuner_MT2063_Open,
-	.tuner_MT2063_SoftwareShutdown = tuner_MT2063_SoftwareShutdown,
-	.tuner_MT2063_ClearPowerMaskBits = tuner_MT2063_ClearPowerMaskBits,
+	/* Due to DRX-K - probably need changes */
+	int (*gate_ctrl)(struct dvb_frontend *, int);
+	struct semaphore      pll_mutex;
+	bool			dont_attach_fe1;
 };
 
-struct drxk3913_config az6007_drxk3913_config_DVBC = {	
-	.demod_address = 0x52,
-	.min_delay_ms = 100,
-	.standard	= MTTUNEA_DVBC,
-	.set_tuner = mt2063_setTune,
-	.tuner_getlocked = mt2063_lockStatus,
-	.tuner_MT2063_Open = tuner_MT2063_Open,
-	.tuner_MT2063_SoftwareShutdown = tuner_MT2063_SoftwareShutdown,
-	.tuner_MT2063_ClearPowerMaskBits = tuner_MT2063_ClearPowerMaskBits,
+struct drxk_config terratec_h7_drxk = {
+	.adr = 0x29,
+	.single_master = 1,
+	.no_i2c_bridge = 1,
+	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
+static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct dvb_usb_adapter *adap = fe->sec_priv;
+	struct az6007_device_state *st = adap->priv;
+	int status;
+
+	if (!adap || !st)
+		return -EINVAL;
+
+	if (enable) {
+		down(&st->pll_mutex);
+		status = st->gate_ctrl(fe, 1);
+	} else {
+		status = st->gate_ctrl(fe, 0);
+		up(&st->pll_mutex);
+	}
+	return status;
+}
+
 struct mt2063_config az6007_mt2063_config = {
 	.tuner_address = 0xc0,
 	.refclock = 36125000,
@@ -87,7 +100,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 {
 	int ret;
 
-#if 0	
+#if 0
 	int i=0, cyc=0, rem=0;
 	cyc = blen/64;
 	rem = blen%64;
@@ -96,7 +109,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
 	debug_dump(b,blen,deb_xfer);
 
-	
+
 #if 0
 	if (blen>64)
 	{
@@ -110,7 +123,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 				5000)) != 64) {
 				warn("usb out operation failed. (%d)",ret);
 				return -EIO;
-			}	
+			}
 		}
 
 		if (rem>0)
@@ -127,7 +140,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 		}
 	}
 	else
-#endif		
+#endif
 	{
 		if ((ret = usb_control_msg(d->udev,
 				usb_sndctrlpipe(d->udev,0),
@@ -139,7 +152,7 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			return -EIO;
 		}
 	}
-	
+
 	return 0;
 }
 
@@ -149,9 +162,9 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-static struct dvb_usb_rc_key az6007_rc_keys[] = {
-	{ 0x00, 0x01, KEY_1 },
-	{ 0x00, 0x02, KEY_2 },
+struct rc_map_table rc_map_az6007_table[] = {
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
 };
 
 /* remote control stuff (does not work with my box) */
@@ -163,7 +176,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	int i;
 
 /* remove the following return to enabled remote querying */
-	
+
 
 	az6007_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
 
@@ -257,7 +270,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 	int blen;
 
 	info("az6007_frontend_reset adap=%p adap->dev=%p\n", adap, adap->dev);
-	
+
 	//reset demodulator
 	req = 0xC0;
 	value = 1;//high
@@ -268,7 +281,7 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 		err("az6007_frontend_reset failed 1 !!!");
 		   return -EIO;
 	}
-	
+
 	req = 0xC0;
 	value = 0;//low
 	index = 3;
@@ -290,11 +303,11 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 		err("az6007_frontend_reset failed 3 !!!");
 		   return -EIO;
 	}
-	
+
 	msleep_interruptible(200);
-	
+
 	info("reset az6007 frontend\n");
-	
+
 	return 0;
 }
 
@@ -350,38 +363,55 @@ static int az6007_frontend_tsbypass(struct dvb_usb_adapter *adap,int onoff)
 
 static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct az6007_device_state *st = adap->priv;
+
+	int result;
+
 	az6007_frontend_poweron(adap);
 	az6007_frontend_reset(adap);
 
 	info("az6007_frontend_attach\n");
 
-	if (az6007_type == 0)
-	{
-		info("az6007_drxk3913_config_DVBT\n");
-		adap->fe = drxk3913_attach(&az6007_drxk3913_config_DVBT, &adap->dev->i2c_adap);
+	adap->fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
+			      &adap->dev->i2c_adap, &adap->fe2);
+	if (!adap->fe) {
+		result = -EINVAL;
+		goto out_free;
 	}
-	else
-	{
-		info("az6007_drxk3913_config_DVBC\n");
-		adap->fe = drxk3913_attach(&az6007_drxk3913_config_DVBC, &adap->dev->i2c_adap);
-	}
-	if (adap->fe) {		
-		if (mt2063_attach(adap->fe, &az6007_mt2063_config, &adap->dev->i2c_adap)) {
-			info("found STB6100 DVB-C/DVB-T frontend @0x%02x\n",az6007_mt2063_config.tuner_address);
-			
-			//vp6027_ci_init(adap);
-		} else {
-			adap->fe = NULL;
-		}
-	}
-	else
-	{
-		adap->fe = NULL;	
-		err("no front-end attached\n");
+
+	/* FIXME: do we need a pll semaphore? */
+	adap->fe->sec_priv = adap;
+	sema_init(&st->pll_mutex, 1);
+	st->gate_ctrl = adap->fe->ops.i2c_gate_ctrl;
+	adap->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	adap->fe2->id = 1;
+
+	/* Attach mt2063 to DVB-C frontend */
+	if (adap->fe->ops.i2c_gate_ctrl)
+		adap->fe->ops.i2c_gate_ctrl(adap->fe, 1);
+	if (!dvb_attach(mt2063_attach, adap->fe, &az6007_mt2063_config,
+			&adap->dev->i2c_adap)) {
+		result = -EINVAL;
+
+		goto out_free;
 	}
-	//az6007_frontend_tsbypass(adap,0);
-	
+	if (adap->fe->ops.i2c_gate_ctrl)
+		adap->fe->ops.i2c_gate_ctrl(adap->fe, 0);
+
+	/* Hack - needed due to drxk */
+	adap->fe2->tuner_priv = adap->fe->tuner_priv;
+	memcpy(&adap->fe2->ops.tuner_ops,
+	       &adap->fe->ops.tuner_ops,
+	       sizeof(adap->fe->ops.tuner_ops));
 	return 0;
+
+out_free:
+	if (adap->fe)
+		dvb_frontend_detach(adap->fe);
+	adap->fe = NULL;
+	adap->fe2 = NULL;
+
+	return result;
 }
 
 static struct dvb_usb_device_properties az6007_properties;
@@ -403,7 +433,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num
 	int length;
 	u8 req;
 	u8 data[512];
-	
+
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
 	if (num > 2)
@@ -442,7 +472,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num
 			//printk("Tuner Tuner ReadDATA len=%d ", len);
 			for (j=0; j<len; j++)
 			{
-				msg[1].buf[j] = data[j+5];	
+				msg[1].buf[j] = data[j+5];
 				//printk("data[%d]=%02x ", j, data[j+5]);
 			}
 			//printk("\n");
@@ -458,13 +488,13 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num
 			value = msg[0].addr | (1<<8);
 			length = msg[0].len - 1;
 			len = msg[0].len - 1;
-			//printk("Demodulator WriteDATA len=%d ", len);			
+			//printk("Demodulator WriteDATA len=%d ", len);
 			for(j=0;j<len;j++)
 			{
 				data[j] = msg[0].buf[j+1];
 				//printk("data[%d]=%02x ", j, data[j]);
 			}
-			//printk("\n");			
+			//printk("\n");
 			ret = az6007_usb_out_op(d,req,value,index,data,length);
 		}
 		else //read
@@ -479,7 +509,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num
 			//printk("Demodulator ReadDATA len=%d ", len);
 			for (j=0; j<len; j++)
 			{
-				msg[0].buf[j] = data[j+5];	
+				msg[0].buf[j] = data[j+5];
 				//printk("data[%d]=%02x ", j, data[j+5]);
 			}
 			//printk("\n");
@@ -521,10 +551,10 @@ int az6007_identify_state(struct usb_device *udev, struct dvb_usb_device_propert
 static int az6007_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	az6007_led_on_off(intf, 0);	
-		
+	az6007_led_on_off(intf, 0);
+
 	return dvb_usb_device_init(intf, &az6007_properties,
-				   THIS_MODULE, NULL, adapter_nr);	
+				   THIS_MODULE, NULL, adapter_nr);
 }
 
 static struct usb_device_id az6007_usb_table [] = {
@@ -569,10 +599,12 @@ static struct dvb_usb_device_properties az6007_properties = {
 	//.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
 
-	.rc_key_map       = az6007_rc_keys,
-	.rc_key_map_size  = ARRAY_SIZE(az6007_rc_keys),
-	.rc_interval      = 400,
-	.rc_query         = az6007_rc_query,
+	.rc.legacy = {
+		.rc_map_table  = rc_map_az6007_table,
+		.rc_map_size  = ARRAY_SIZE(rc_map_az6007_table),
+		.rc_interval      = 400,
+		.rc_query         = az6007_rc_query,
+	},
 	.i2c_algo         = &az6007_i2c_algo,
 
 	.num_device_descs = 2,
@@ -585,10 +617,10 @@ static struct dvb_usb_device_properties az6007_properties = {
 		  .cold_ids = { &az6007_usb_table[1], NULL },
 		  .warm_ids = { NULL },
 		},
- 		{ NULL },
+		{ NULL },
 	}
 };
-  
+
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver az6007_usb_driver = {
 	.name		= "dvb_usb_az6007",
-- 
1.7.8

