Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4h7U021357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/35] [media] az6007: CodingStyle cleanup
Date: Sat, 21 Jan 2012 14:04:09 -0200
Message-Id: <1327161877-16784-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-7-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make checkpatch.pl happy

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |  239 ++++++++++++++++++------------------
 1 files changed, 120 insertions(+), 119 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 1fc174b..a709cec 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -14,23 +14,24 @@
 
 /* debug */
 int dvb_usb_az6007_debug;
-module_param_named(debug,dvb_usb_az6007_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+module_param_named(debug, dvb_usb_az6007_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))."
+		 DVB_USB_DEBUG_STATUS);
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct az6007_device_state {
-	struct dvb_ca_en50221 ca;
-	struct mutex ca_mutex;
-	u8 power_state;
+	struct			dvb_ca_en50221 ca;
+	struct			mutex ca_mutex;
+	u8			power_state;
 
 	/* Due to DRX-K - probably need changes */
-	int (*gate_ctrl)(struct dvb_frontend *, int);
-	struct semaphore      pll_mutex;
+	int			(*gate_ctrl) (struct dvb_frontend *, int);
+	struct			semaphore pll_mutex;
 	bool			dont_attach_fe1;
 };
 
-struct drxk_config terratec_h7_drxk = {
+static struct drxk_config terratec_h7_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 0,
@@ -43,7 +44,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct az6007_device_state *st;
 	int status;
 
-	info("%s: %s", __func__, enable? "enable" : "disable" );
+	info("%s: %s", __func__, enable ? "enable" : "disable");
 
 	if (!adap)
 		return -EINVAL;
@@ -53,7 +54,6 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	if (!st)
 		return -EINVAL;
 
-
 	if (enable) {
 #if 0
 		down(&st->pll_mutex);
@@ -68,30 +68,31 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return status;
 }
 
-struct mt2063_config az6007_mt2063_config = {
+static struct mt2063_config az6007_mt2063_config = {
 	.tuner_address = 0x60,
 	.refclock = 36125000,
 };
 
 /* check for mutex FIXME */
-int az6007_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
+static int az6007_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
 {
 	int ret = -1;
 
-		ret = usb_control_msg(d->udev,
-			usb_rcvctrlpipe(d->udev,0),
-			req,
-			USB_TYPE_VENDOR | USB_DIR_IN,
-			value,index,b,blen,
-			5000);
+	ret = usb_control_msg(d->udev,
+			      usb_rcvctrlpipe(d->udev, 0),
+			      req,
+			      USB_TYPE_VENDOR | USB_DIR_IN,
+			      value, index, b, blen, 5000);
 
 	if (ret < 0) {
 		warn("usb in operation failed. (%d)", ret);
 		return -EIO;
 	}
 
-	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
-	debug_dump(b,blen,deb_xfer);
+	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
+		 index);
+	debug_dump(b, blen, deb_xfer);
 
 	return ret;
 }
@@ -101,21 +102,23 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 {
 	int ret;
 
-	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
-	debug_dump(b,blen,deb_xfer);
+	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
+		 index);
+	debug_dump(b, blen, deb_xfer);
 
 	if (blen > 64) {
-		printk(KERN_ERR "az6007: doesn't suport I2C transactions longer than 64 bytes\n");
+		printk(KERN_ERR
+		       "az6007: doesn't suport I2C transactions longer than 64 bytes\n");
 		return -EOPNOTSUPP;
 	}
 
-	if ((ret = usb_control_msg(d->udev,
-			usb_sndctrlpipe(d->udev,0),
-			req,
-			USB_TYPE_VENDOR | USB_DIR_OUT,
-			value,index,b,blen,
-			5000)) != blen) {
-		warn("usb out operation failed. (%d)",ret);
+	ret = usb_control_msg(d->udev,
+			      usb_sndctrlpipe(d->udev, 0),
+			      req,
+			      USB_TYPE_VENDOR | USB_DIR_OUT,
+			      value, index, b, blen, 5000);
+	if (ret != blen) {
+		warn("usb out operation failed. (%d)", ret);
 		return -EIO;
 	}
 
@@ -128,25 +131,24 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-struct rc_map_table rc_map_az6007_table[] = {
-	{ 0x0001, KEY_1 },
-	{ 0x0002, KEY_2 },
+static struct rc_map_table rc_map_az6007_table[] = {
+	{0x0001, KEY_1},
+	{0x0002, KEY_2},
 };
 
 /* remote control stuff (does not work with my box) */
-static int az6007_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 {
 	return 0;
 #if 0
 	u8 key[10];
 	int i;
 
-/* remove the following return to enabled remote querying */
-
+	/* remove the following return to enabled remote querying */
 
-	az6007_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
+	az6007_usb_in_op(d, READ_REMOTE_REQ, 0, 0, key, 10);
 
-	deb_rc("remote query key: %x %d\n",key[1],key[1]);
+	deb_rc("remote query key: %x %d\n", key[1], key[1]);
 
 	if (key[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
@@ -171,7 +173,7 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 }
 */
 
-static int az6007_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
+static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
 	az6007_usb_in_op(d, 0xb7, 6, 0, &mac[0], 6);
 	return 0;
@@ -190,12 +192,12 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	req = 0xBC;
 	value = 1;		/* power on */
 	index = 3;
-	blen =0;
+	blen = 0;
 
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_poweron failed!!!");
-		 return -EIO;
+		return -EIO;
 	}
 
 	msleep_interruptible(200);
@@ -203,12 +205,12 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	req = 0xBC;
 	value = 0;		/* power off */
 	index = 3;
-	blen =0;
+	blen = 0;
 
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_poweron failed!!!");
-		 return -EIO;
+		return -EIO;
 	}
 
 	msleep_interruptible(200);
@@ -216,12 +218,12 @@ static int az6007_frontend_poweron(struct dvb_usb_adapter *adap)
 	req = 0xBC;
 	value = 1;		/* power on */
 	index = 3;
-	blen =0;
+	blen = 0;
 
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_poweron failed!!!");
-		 return -EIO;
+		return -EIO;
 	}
 	info("az6007_frontend_poweron: OK");
 
@@ -238,37 +240,37 @@ static int az6007_frontend_reset(struct dvb_usb_adapter *adap)
 
 	info("az6007_frontend_reset adap=%p adap->dev=%p", adap, adap->dev);
 
-	//reset demodulator
+	/* reset demodulator */
 	req = 0xC0;
-	value = 1;//high
+	value = 1;		/* high */
 	index = 3;
-	blen =0;
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	blen = 0;
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_reset failed 1 !!!");
-		   return -EIO;
+		return -EIO;
 	}
 
 	req = 0xC0;
-	value = 0;//low
+	value = 0;		/* low */
 	index = 3;
-	blen =0;
+	blen = 0;
 	msleep_interruptible(200);
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_reset failed 2 !!!");
-		   return -EIO;
+		return -EIO;
 	}
 	msleep_interruptible(200);
 	req = 0xC0;
-	value = 1;//high
+	value = 1;		/* high */
 	index = 3;
-	blen =0;
+	blen = 0;
 
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-	{
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0) {
 		err("az6007_frontend_reset failed 3 !!!");
-		   return -EIO;
+		return -EIO;
 	}
 
 	msleep_interruptible(200);
@@ -285,18 +287,17 @@ static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 	u16 value;
 	u16 index;
 	int blen;
-	//TS through
+	/* TS through */
 	req = 0xBC;
 	value = onoff;
 	index = 0;
-	blen =0;
+	blen = 0;
 
 	ret = usb_control_msg(interface_to_usbdev(intf),
-		usb_rcvctrlpipe(interface_to_usbdev(intf),0),
-		req,
-		USB_TYPE_VENDOR | USB_DIR_OUT,
-		value,index,NULL,blen,
-		2000);
+			      usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
+			      req,
+			      USB_TYPE_VENDOR | USB_DIR_OUT,
+			      value, index, NULL, blen, 2000);
 
 	if (ret < 0) {
 		warn("usb in operation failed. (%d)", ret);
@@ -304,27 +305,28 @@ static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 	} else
 		ret = 0;
 
-
-	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
+	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
+		 index);
 
 	return ret;
 }
 
-static int az6007_frontend_tsbypass(struct dvb_usb_adapter *adap,int onoff)
+static int az6007_frontend_tsbypass(struct dvb_usb_adapter *adap, int onoff)
 {
 	int ret;
 	u8 req;
 	u16 value;
 	u16 index;
 	int blen;
-	//TS through
+	/* TS through */
 	req = 0xC7;
 	value = onoff;
 	index = 0;
-	blen =0;
+	blen = 0;
 
-	if((ret = az6007_usb_out_op(adap->dev,req,value,index,NULL,blen)) != 0)
-		   return -EIO;
+	ret = az6007_usb_out_op(adap->dev, req, value, index, NULL, blen);
+	if (ret != 0)
+		return -EIO;
 	return 0;
 }
 
@@ -373,8 +375,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	/* Hack - needed due to drxk */
 	adap->fe2->tuner_priv = adap->fe->tuner_priv;
 	memcpy(&adap->fe2->ops.tuner_ops,
-	       &adap->fe->ops.tuner_ops,
-	       sizeof(adap->fe->ops.tuner_ops));
+	       &adap->fe->ops.tuner_ops, sizeof(adap->fe->ops.tuner_ops));
 	return 0;
 
 out_free:
@@ -388,14 +389,14 @@ out_free:
 
 static struct dvb_usb_device_properties az6007_properties;
 
-static void
-az6007_usb_disconnect(struct usb_interface *intf)
+static void az6007_usb_disconnect(struct usb_interface *intf)
 {
-	dvb_usb_device_exit (intf);
+	dvb_usb_device_exit(intf);
 }
 
 /* I2C */
-static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int num)
+static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
+			   int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i, j, len;
@@ -430,7 +431,8 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
-			ret = az6007_usb_in_op(d,req,value,index,data,length);
+			ret = az6007_usb_in_op(d, req, value, index, data,
+					       length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
 					msgs[i + 1].buf[j] = data[j + 5];
@@ -454,16 +456,14 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
 			if (dvb_usb_az6007_debug & 2)
-				printk(KERN_CONT
-				       "(0x%02x) ", msgs[i].buf[0]);
-			for (j = 0; j < len; j++)
-			{
+				printk(KERN_CONT "(0x%02x) ", msgs[i].buf[0]);
+			for (j = 0; j < len; j++) {
 				data[j] = msgs[i].buf[j + 1];
 				if (dvb_usb_az6007_debug & 2)
-					printk(KERN_CONT
-					       "0x%02x ", data[j]);
+					printk(KERN_CONT "0x%02x ", data[j]);
 			}
-			ret = az6007_usb_out_op(d,req,value,index,data,length);
+			ret =  az6007_usb_out_op(d, req, value, index, data,
+						 length);
 		} else {
 			/* read bytes */
 			if (dvb_usb_az6007_debug & 2)
@@ -475,9 +475,9 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msgs[],int nu
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = az6007_usb_in_op(d,req,value,index,data,length);
-			for (j = 0; j < len; j++)
-			{
+			ret = az6007_usb_in_op(d, req, value, index, data,
+					       length);
+			for (j = 0; j < len; j++) {
 				msgs[i].buf[j] = data[j + 5];
 				if (dvb_usb_az6007_debug & 2)
 					printk(KERN_CONT
@@ -499,25 +499,26 @@ err:
 	return num;
 }
 
-
 static u32 az6007_i2c_func(struct i2c_adapter *adapter)
 {
 	return I2C_FUNC_I2C;
 }
 
 static struct i2c_algorithm az6007_i2c_algo = {
-	.master_xfer   = az6007_i2c_xfer,
+	.master_xfer = az6007_i2c_xfer,
 	.functionality = az6007_i2c_func,
 };
 
-int az6007_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
-			struct dvb_usb_device_description **desc, int *cold)
+int az6007_identify_state(struct usb_device *udev,
+			  struct dvb_usb_device_properties *props,
+			  struct dvb_usb_device_description **desc, int *cold)
 {
 	u8 b[16];
-	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
-		0xb7, USB_TYPE_VENDOR | USB_DIR_IN, 6, 0, b, 6, USB_CTRL_GET_TIMEOUT);
+	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+				  0xb7, USB_TYPE_VENDOR | USB_DIR_IN, 6, 0, b,
+				  6, USB_CTRL_GET_TIMEOUT);
 
-	info("FW GET_VERSION length: %d",ret);
+	info("FW GET_VERSION length: %d", ret);
 
 	*cold = ret <= 0;
 
@@ -526,7 +527,7 @@ int az6007_identify_state(struct usb_device *udev, struct dvb_usb_device_propert
 }
 
 static int az6007_usb_probe(struct usb_interface *intf,
-		const struct usb_device_id *id)
+			    const struct usb_device_id *id)
 {
 	az6007_led_on_off(intf, 0);
 
@@ -534,10 +535,10 @@ static int az6007_usb_probe(struct usb_interface *intf,
 				   THIS_MODULE, NULL, adapter_nr);
 }
 
-static struct usb_device_id az6007_usb_table [] = {
-	    { USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007) },
-	    { USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7) },
-	    { 0 },
+static struct usb_device_id az6007_usb_table[] = {
+	{USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007)},
+	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7)},
+	{0},
 };
 
 MODULE_DEVICE_TABLE(usb, az6007_usb_table);
@@ -545,7 +546,6 @@ MODULE_DEVICE_TABLE(usb, az6007_usb_table);
 static struct dvb_usb_device_properties az6007_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = CYPRESS_FX2,
-	//.download_firmware = az6007_download_firmware,
 	.firmware            = "dvb-usb-az6007-03.fw",
 	.no_reconnect        = 1,
 
@@ -553,8 +553,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.num_adapters = 1,
 	.adapter = {
 		{
-			//.caps             = DVB_USB_ADAP_RECEIVES_204_BYTE_TS,
-
+			/* .caps             = DVB_USB_ADAP_RECEIVES_204_BYTE_TS, */
 			.streaming_ctrl   = az6007_streaming_ctrl,
 			.frontend_attach  = az6007_frontend_attach,
 
@@ -572,7 +571,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 			.size_of_priv     = sizeof(struct az6007_device_state),
 		}
 	},
-	//.power_ctrl       = az6007_power_ctrl,
+	/* .power_ctrl       = az6007_power_ctrl, */
 	.read_mac_address = az6007_read_mac_addr,
 
 	.rc.legacy = {
@@ -600,10 +599,10 @@ static struct dvb_usb_device_properties az6007_properties = {
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver az6007_usb_driver = {
 	.name		= "dvb_usb_az6007",
-	.probe 		= az6007_usb_probe,
+	.probe		= az6007_usb_probe,
 	.disconnect = dvb_usb_device_exit,
-	//.disconnect 	= az6007_usb_disconnect,
-	.id_table 	= az6007_usb_table,
+	/* .disconnect	= az6007_usb_disconnect, */
+	.id_table	= az6007_usb_table,
 };
 
 /* module stuff */
@@ -611,8 +610,10 @@ static int __init az6007_usb_module_init(void)
 {
 	int result;
 	info("az6007 usb module init");
-	if ((result = usb_register(&az6007_usb_driver))) {
-		err("usb_register failed. (%d)",result);
+
+	result = usb_register(&az6007_usb_driver);
+	if (result) {
+		err("usb_register failed. (%d)", result);
 		return result;
 	}
 
-- 
1.7.8

