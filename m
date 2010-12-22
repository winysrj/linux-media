Return-path: <mchehab@gaivota>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52180 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0LVI5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 03:57:43 -0500
Received: by eyg5 with SMTP id 5so2523768eyg.2
        for <linux-media@vger.kernel.org>; Wed, 22 Dec 2010 00:57:41 -0800 (PST)
Date: Wed, 22 Dec 2010 17:57:46 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Rework and fix IR
Message-ID: <20101222175746.37ae077b@glory.local>
In-Reply-To: <20101221223645.GD29880@redhat.com>
References: <4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
	<20101220144103.0bcaca1d@glory.local>
	<20101221223645.GD29880@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/i9FdV2pCSJA4Wt=salWbwm8"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--MP_/i9FdV2pCSJA4Wt=salWbwm8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

This patch didn't kill Stefan's remotes and just for upload my good part of code.
1. Add some code for show IR activity
2. Add filter for IR remotes
3. Split remotes to different types.
4. Fix stop interrupt pipe when isoc pipe started.

When we decide general way of IR I'll add support our remotes.
For our customers I'll made custom temporary patch without this part.

diff --git a/drivers/staging/tm6000/TODO b/drivers/staging/tm6000/TODO
index 34780fc..135d0ea 100644
--- a/drivers/staging/tm6000/TODO
+++ b/drivers/staging/tm6000/TODO
@@ -1,4 +1,6 @@
 There a few things to do before putting this driver in production:
+	- IR NEC with tm5600/6000 TV cards
+	- IR RC5 with tm5600/6000/6010 TV cards
 	- CodingStyle;
 	- Fix audio;
 	- Fix some panic/OOPS conditions.
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1c9374a..2e525a6 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -328,6 +328,47 @@ struct usb_device_id tm6000_id_table[] = {
 	{ },
 };
 
+/* Control power led for show some activity */
+void tm6000_flash_led(struct tm6000_core *dev, u8 state)
+{
+	/* Power LED unconfigured */
+	if (!dev->gpio.power_led)
+		return;
+
+	/* ON Power LED */
+	if (state) {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		}
+	}
+	/* OFF Power LED */
+	else {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		}
+	}
+}
+
 /* Tuner callback to provide the proper gpio changes needed for xc5000 */
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
 {
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index e02ea67..21e7da4 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -37,6 +37,10 @@ static unsigned int enable_ir = 1;
 module_param(enable_ir, int, 0644);
 MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
+/* number of 50ms for ON-OFF-ON power led */
+/* show IR activity */
+#define PWLED_OFF 2
+
 #undef dprintk
 
 #define dprintk(fmt, arg...) \
@@ -59,6 +63,9 @@ struct tm6000_IR {
 	struct delayed_work	work;
 	u8			wait:1;
 	u8			key:1;
+	u8			pwled:1;
+	u8			pwledcnt;
+	u16			key_addr;
 	struct urb		*int_urb;
 	u8			*urb_data;
 
@@ -89,26 +96,49 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	u8 buf[10];
 	int rc;
 
-	/* hack */
-	buf[0] = 0xff;
-	buf[1] = 0xff;
-	buf[2] = 0xf2;
-	buf[3] = 0x2b;
-	buf[4] = 0x20;
-	buf[5] = 0x35;
-	buf[6] = 0x60;
-	buf[7] = 0x04;
-	buf[8] = 0xc0;
-	buf[9] = 0x08;
-
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
-		USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
-	msleep(100);
-
-	if (rc < 0) {
-		printk(KERN_INFO "IR configuration failed");
-		return rc;
+	switch (ir->rc_type) {
+	case RC_TYPE_NEC:
+		/* Setup IR decoder for NEC standard 12MHz system clock */
+		/* IR_LEADER_CNT = 0.9ms             */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER1, 0xaa);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER0, 0x30);
+		/* IR_PULSE_CNT = 0.7ms              */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT1, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0xd0);
+		/* Remote WAKEUP = enable */
+		tm6000_set_reg(dev, TM6010_REQ07_RE5_REMOTE_WAKEUP, 0xfe);
+		/* IR_WKUP_SEL = Low byte in decoded IR data */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0xff);
+		/* IR_WKU_ADD code */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_ADD, 0xff);
+		tm6000_flash_led(dev, 0);
+		msleep(100);
+		tm6000_flash_led(dev, 1);
+		break;
+	default:
+		/* hack */
+		buf[0] = 0xff;
+		buf[1] = 0xff;
+		buf[2] = 0xf2;
+		buf[3] = 0x2b;
+		buf[4] = 0x20;
+		buf[5] = 0x35;
+		buf[6] = 0x60;
+		buf[7] = 0x04;
+		buf[8] = 0xc0;
+		buf[9] = 0x08;
+
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
+		msleep(100);
+
+		if (rc < 0) {
+			printk(KERN_INFO "IR configuration failed");
+			return rc;
+		}
+		break;
 	}
+
 	return 0;
 }
 
@@ -143,10 +173,21 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		return 0;
 
 	if (&dev->int_in) {
-		if (ir->rc_type == RC_TYPE_RC5)
+		switch (ir->rc_type) {
+		case RC_TYPE_RC5:
 			poll_result->rc_data = ir->urb_data[0];
-		else
-			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
+			break;
+		case RC_TYPE_NEC:
+			if (ir->urb_data[1] == ((ir->key_addr >> 8) & 0xff)) {
+				poll_result->rc_data = ir->urb_data[0]
+							| ir->urb_data[1] << 8;
+			}
+			break;
+		default:
+			poll_result->rc_data = ir->urb_data[0]
+					| ir->urb_data[1] << 8;
+			break;
+		}
 	} else {
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
 		msleep(10);
@@ -186,6 +227,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 
 static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 {
+	struct tm6000_core *dev = ir->dev;
 	int result;
 	struct tm6000_ir_poll_result poll_result;
 
@@ -198,9 +240,21 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 
 	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
+	if (ir->pwled) {
+		if (ir->pwledcnt >= PWLED_OFF) {
+			ir->pwled = 0;
+			ir->pwledcnt = 0;
+			tm6000_flash_led(dev, 1);
+		} else
+			ir->pwledcnt += 1;
+	}
+
 	if (ir->key) {
 		rc_keydown(ir->rc, poll_result.rc_data, 0);
 		ir->key = 0;
+		ir->pwled = 1;
+		ir->pwledcnt = 0;
+		tm6000_flash_led(dev, 0);
 	}
 	return;
 }
@@ -234,19 +288,80 @@ int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct tm6000_IR *ir = rc->priv;
 
+	if (!ir)
+		return 0;
+
+	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
+		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
+
 	ir->get_key = default_polling_getkey;
+	ir->rc_type = rc_type;
 
 	tm6000_ir_config(ir);
 	/* TODO */
 	return 0;
 }
 
+int tm6000_ir_int_start(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+	int pipe, size;
+	int err = -ENOMEM;
+
+
+	if (!ir)
+		return -ENODEV;
+
+	ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+
+	pipe = usb_rcvintpipe(dev->udev,
+		dev->int_in.endp->desc.bEndpointAddress
+		& USB_ENDPOINT_NUMBER_MASK);
+
+	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+	dprintk("IR max size: %d\n", size);
+
+	ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
+	if (ir->int_urb->transfer_buffer == NULL) {
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
+	usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
+		ir->int_urb->transfer_buffer, size,
+		tm6000_ir_urb_received, dev,
+		dev->int_in.endp->desc.bInterval);
+	err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+	if (err) {
+		kfree(ir->int_urb->transfer_buffer);
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	ir->urb_data = kzalloc(size, GFP_KERNEL);
+
+	return 0;
+}
+
+void tm6000_ir_int_stop(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	if (!ir)
+		return;
+
+	usb_kill_urb(ir->int_urb);
+	kfree(ir->int_urb->transfer_buffer);
+	usb_free_urb(ir->int_urb);
+	ir->int_urb = NULL;
+	kfree(ir->urb_data);
+	ir->urb_data = NULL;
+}
+
 int tm6000_ir_init(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
-	int pipe, size;
 
 	if (!enable_ir)
 		return -ENODEV;
@@ -276,6 +391,9 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc->driver_type = RC_DRIVER_SCANCODE;
 
 	ir->polling = 50;
+	ir->pwled = 0;
+	ir->pwledcnt = 0;
+
 
 	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
 						dev->name);
@@ -298,32 +416,10 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	if (&dev->int_in) {
 		dprintk("IR over int\n");
 
-		ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-
-		pipe = usb_rcvintpipe(dev->udev,
-			dev->int_in.endp->desc.bEndpointAddress
-			& USB_ENDPOINT_NUMBER_MASK);
+		err = tm6000_ir_int_start(dev);
 
-		size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
-		dprintk("IR max size: %d\n", size);
-
-		ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
-		if (ir->int_urb->transfer_buffer == NULL) {
-			usb_free_urb(ir->int_urb);
-			goto out;
-		}
-		dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
-		usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
-			ir->int_urb->transfer_buffer, size,
-			tm6000_ir_urb_received, dev,
-			dev->int_in.endp->desc.bInterval);
-		err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
-		if (err) {
-			kfree(ir->int_urb->transfer_buffer);
-			usb_free_urb(ir->int_urb);
+		if (err)
 			goto out;
-		}
-		ir->urb_data = kzalloc(size, GFP_KERNEL);
 	}
 
 	/* ir register */
@@ -352,12 +448,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	rc_unregister_device(ir->rc);
 
 	if (ir->int_urb) {
-		usb_kill_urb(ir->int_urb);
-		kfree(ir->int_urb->transfer_buffer);
-		usb_free_urb(ir->int_urb);
-		ir->int_urb = NULL;
-		kfree(ir->urb_data);
-		ir->urb_data = NULL;
+		tm6000_ir_int_stop(dev);
 	}
 
 	kfree(ir);
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c5690b2..b06701b 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -545,11 +545,16 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	/* De-allocates all pending stuff */
 	tm6000_uninit_isoc(dev);
+	/* Stop interrupt USB pipe */
+	tm6000_ir_int_stop(dev);
 
 	usb_set_interface(dev->udev,
 			  dev->isoc_in.bInterfaceNumber,
 			  dev->isoc_in.bAlternateSetting);
 
+	/* Start interrupt USB pipe */
+	tm6000_ir_int_start(dev);
+
 	pipe = usb_rcvisocpipe(dev->udev,
 			       dev->isoc_in.endp->desc.bEndpointAddress &
 			       USB_ENDPOINT_NUMBER_MASK);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 46017b6..bf11eee 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -266,6 +266,7 @@ struct tm6000_fh {
 int tm6000_tuner_callback(void *ptr, int component, int command, int arg);
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg);
 int tm6000_cards_setup(struct tm6000_core *dev);
+void tm6000_flash_led(struct tm6000_core *dev, u8 state);
 
 /* In tm6000-core.c */
 
@@ -332,6 +333,8 @@ int tm6000_queue_init(struct tm6000_core *dev);
 int tm6000_ir_init(struct tm6000_core *dev);
 int tm6000_ir_fini(struct tm6000_core *dev);
 void tm6000_ir_wait(struct tm6000_core *dev, u8 state);
+int tm6000_ir_int_start(struct tm6000_core *dev);
+void tm6000_ir_int_stop(struct tm6000_core *dev);
 
 /* Debug stuff */
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/i9FdV2pCSJA4Wt=salWbwm8
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_ir.patch

diff --git a/drivers/staging/tm6000/TODO b/drivers/staging/tm6000/TODO
index 34780fc..135d0ea 100644
--- a/drivers/staging/tm6000/TODO
+++ b/drivers/staging/tm6000/TODO
@@ -1,4 +1,6 @@
 There a few things to do before putting this driver in production:
+	- IR NEC with tm5600/6000 TV cards
+	- IR RC5 with tm5600/6000/6010 TV cards
 	- CodingStyle;
 	- Fix audio;
 	- Fix some panic/OOPS conditions.
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1c9374a..2e525a6 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -328,6 +328,47 @@ struct usb_device_id tm6000_id_table[] = {
 	{ },
 };
 
+/* Control power led for show some activity */
+void tm6000_flash_led(struct tm6000_core *dev, u8 state)
+{
+	/* Power LED unconfigured */
+	if (!dev->gpio.power_led)
+		return;
+
+	/* ON Power LED */
+	if (state) {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		}
+	}
+	/* OFF Power LED */
+	else {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			break;
+		}
+	}
+}
+
 /* Tuner callback to provide the proper gpio changes needed for xc5000 */
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
 {
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index e02ea67..21e7da4 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -37,6 +37,10 @@ static unsigned int enable_ir = 1;
 module_param(enable_ir, int, 0644);
 MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
+/* number of 50ms for ON-OFF-ON power led */
+/* show IR activity */
+#define PWLED_OFF 2
+
 #undef dprintk
 
 #define dprintk(fmt, arg...) \
@@ -59,6 +63,9 @@ struct tm6000_IR {
 	struct delayed_work	work;
 	u8			wait:1;
 	u8			key:1;
+	u8			pwled:1;
+	u8			pwledcnt;
+	u16			key_addr;
 	struct urb		*int_urb;
 	u8			*urb_data;
 
@@ -89,26 +96,49 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	u8 buf[10];
 	int rc;
 
-	/* hack */
-	buf[0] = 0xff;
-	buf[1] = 0xff;
-	buf[2] = 0xf2;
-	buf[3] = 0x2b;
-	buf[4] = 0x20;
-	buf[5] = 0x35;
-	buf[6] = 0x60;
-	buf[7] = 0x04;
-	buf[8] = 0xc0;
-	buf[9] = 0x08;
-
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
-		USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
-	msleep(100);
-
-	if (rc < 0) {
-		printk(KERN_INFO "IR configuration failed");
-		return rc;
+	switch (ir->rc_type) {
+	case RC_TYPE_NEC:
+		/* Setup IR decoder for NEC standard 12MHz system clock */
+		/* IR_LEADER_CNT = 0.9ms             */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER1, 0xaa);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER0, 0x30);
+		/* IR_PULSE_CNT = 0.7ms              */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT1, 0x20);
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0xd0);
+		/* Remote WAKEUP = enable */
+		tm6000_set_reg(dev, TM6010_REQ07_RE5_REMOTE_WAKEUP, 0xfe);
+		/* IR_WKUP_SEL = Low byte in decoded IR data */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0xff);
+		/* IR_WKU_ADD code */
+		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_ADD, 0xff);
+		tm6000_flash_led(dev, 0);
+		msleep(100);
+		tm6000_flash_led(dev, 1);
+		break;
+	default:
+		/* hack */
+		buf[0] = 0xff;
+		buf[1] = 0xff;
+		buf[2] = 0xf2;
+		buf[3] = 0x2b;
+		buf[4] = 0x20;
+		buf[5] = 0x35;
+		buf[6] = 0x60;
+		buf[7] = 0x04;
+		buf[8] = 0xc0;
+		buf[9] = 0x08;
+
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
+		msleep(100);
+
+		if (rc < 0) {
+			printk(KERN_INFO "IR configuration failed");
+			return rc;
+		}
+		break;
 	}
+
 	return 0;
 }
 
@@ -143,10 +173,21 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		return 0;
 
 	if (&dev->int_in) {
-		if (ir->rc_type == RC_TYPE_RC5)
+		switch (ir->rc_type) {
+		case RC_TYPE_RC5:
 			poll_result->rc_data = ir->urb_data[0];
-		else
-			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
+			break;
+		case RC_TYPE_NEC:
+			if (ir->urb_data[1] == ((ir->key_addr >> 8) & 0xff)) {
+				poll_result->rc_data = ir->urb_data[0]
+							| ir->urb_data[1] << 8;
+			}
+			break;
+		default:
+			poll_result->rc_data = ir->urb_data[0]
+					| ir->urb_data[1] << 8;
+			break;
+		}
 	} else {
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
 		msleep(10);
@@ -186,6 +227,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 
 static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 {
+	struct tm6000_core *dev = ir->dev;
 	int result;
 	struct tm6000_ir_poll_result poll_result;
 
@@ -198,9 +240,21 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 
 	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
+	if (ir->pwled) {
+		if (ir->pwledcnt >= PWLED_OFF) {
+			ir->pwled = 0;
+			ir->pwledcnt = 0;
+			tm6000_flash_led(dev, 1);
+		} else
+			ir->pwledcnt += 1;
+	}
+
 	if (ir->key) {
 		rc_keydown(ir->rc, poll_result.rc_data, 0);
 		ir->key = 0;
+		ir->pwled = 1;
+		ir->pwledcnt = 0;
+		tm6000_flash_led(dev, 0);
 	}
 	return;
 }
@@ -234,19 +288,80 @@ int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct tm6000_IR *ir = rc->priv;
 
+	if (!ir)
+		return 0;
+
+	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
+		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
+
 	ir->get_key = default_polling_getkey;
+	ir->rc_type = rc_type;
 
 	tm6000_ir_config(ir);
 	/* TODO */
 	return 0;
 }
 
+int tm6000_ir_int_start(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+	int pipe, size;
+	int err = -ENOMEM;
+
+
+	if (!ir)
+		return -ENODEV;
+
+	ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+
+	pipe = usb_rcvintpipe(dev->udev,
+		dev->int_in.endp->desc.bEndpointAddress
+		& USB_ENDPOINT_NUMBER_MASK);
+
+	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+	dprintk("IR max size: %d\n", size);
+
+	ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
+	if (ir->int_urb->transfer_buffer == NULL) {
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
+	usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
+		ir->int_urb->transfer_buffer, size,
+		tm6000_ir_urb_received, dev,
+		dev->int_in.endp->desc.bInterval);
+	err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+	if (err) {
+		kfree(ir->int_urb->transfer_buffer);
+		usb_free_urb(ir->int_urb);
+		return err;
+	}
+	ir->urb_data = kzalloc(size, GFP_KERNEL);
+
+	return 0;
+}
+
+void tm6000_ir_int_stop(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	if (!ir)
+		return;
+
+	usb_kill_urb(ir->int_urb);
+	kfree(ir->int_urb->transfer_buffer);
+	usb_free_urb(ir->int_urb);
+	ir->int_urb = NULL;
+	kfree(ir->urb_data);
+	ir->urb_data = NULL;
+}
+
 int tm6000_ir_init(struct tm6000_core *dev)
 {
 	struct tm6000_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
-	int pipe, size;
 
 	if (!enable_ir)
 		return -ENODEV;
@@ -276,6 +391,9 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc->driver_type = RC_DRIVER_SCANCODE;
 
 	ir->polling = 50;
+	ir->pwled = 0;
+	ir->pwledcnt = 0;
+
 
 	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
 						dev->name);
@@ -298,32 +416,10 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	if (&dev->int_in) {
 		dprintk("IR over int\n");
 
-		ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-
-		pipe = usb_rcvintpipe(dev->udev,
-			dev->int_in.endp->desc.bEndpointAddress
-			& USB_ENDPOINT_NUMBER_MASK);
+		err = tm6000_ir_int_start(dev);
 
-		size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
-		dprintk("IR max size: %d\n", size);
-
-		ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
-		if (ir->int_urb->transfer_buffer == NULL) {
-			usb_free_urb(ir->int_urb);
-			goto out;
-		}
-		dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
-		usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
-			ir->int_urb->transfer_buffer, size,
-			tm6000_ir_urb_received, dev,
-			dev->int_in.endp->desc.bInterval);
-		err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
-		if (err) {
-			kfree(ir->int_urb->transfer_buffer);
-			usb_free_urb(ir->int_urb);
+		if (err)
 			goto out;
-		}
-		ir->urb_data = kzalloc(size, GFP_KERNEL);
 	}
 
 	/* ir register */
@@ -352,12 +448,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	rc_unregister_device(ir->rc);
 
 	if (ir->int_urb) {
-		usb_kill_urb(ir->int_urb);
-		kfree(ir->int_urb->transfer_buffer);
-		usb_free_urb(ir->int_urb);
-		ir->int_urb = NULL;
-		kfree(ir->urb_data);
-		ir->urb_data = NULL;
+		tm6000_ir_int_stop(dev);
 	}
 
 	kfree(ir);
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c5690b2..b06701b 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -545,11 +545,16 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	/* De-allocates all pending stuff */
 	tm6000_uninit_isoc(dev);
+	/* Stop interrupt USB pipe */
+	tm6000_ir_int_stop(dev);
 
 	usb_set_interface(dev->udev,
 			  dev->isoc_in.bInterfaceNumber,
 			  dev->isoc_in.bAlternateSetting);
 
+	/* Start interrupt USB pipe */
+	tm6000_ir_int_start(dev);
+
 	pipe = usb_rcvisocpipe(dev->udev,
 			       dev->isoc_in.endp->desc.bEndpointAddress &
 			       USB_ENDPOINT_NUMBER_MASK);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 46017b6..bf11eee 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -266,6 +266,7 @@ struct tm6000_fh {
 int tm6000_tuner_callback(void *ptr, int component, int command, int arg);
 int tm6000_xc5000_callback(void *ptr, int component, int command, int arg);
 int tm6000_cards_setup(struct tm6000_core *dev);
+void tm6000_flash_led(struct tm6000_core *dev, u8 state);
 
 /* In tm6000-core.c */
 
@@ -332,6 +333,8 @@ int tm6000_queue_init(struct tm6000_core *dev);
 int tm6000_ir_init(struct tm6000_core *dev);
 int tm6000_ir_fini(struct tm6000_core *dev);
 void tm6000_ir_wait(struct tm6000_core *dev, u8 state);
+int tm6000_ir_int_start(struct tm6000_core *dev);
+void tm6000_ir_int_stop(struct tm6000_core *dev);
 
 /* Debug stuff */
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/i9FdV2pCSJA4Wt=salWbwm8--
