Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab1K3RIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:08:34 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUH8YJB003154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 12:08:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/5] [media] tm6000: rewrite IR support
Date: Wed, 30 Nov 2011 15:08:22 -0200
Message-Id: <1322672904-17340-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322672904-17340-2-git-send-email-mchehab@redhat.com>
References: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
 <1322672904-17340-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR support were broken on my tests with HVR-900H. Also,
there were several issues on the current implementation.
This patch is a major rewrite of the IR support for this
	- Improve debug messages;
	- Don't do polling for interrrupt based IR;
	- Add proper support for RC-5 protocol;
	- Always provide 16 bits for NEC and RC-5;
	- Fix polling code;
	- Split polling functions from URB Interrupt ones;
	- Don't hardcode the XTAL reference for tm6000 IR;
	- If a URB submit fails, retries after 100ms;
	- etc.

Tested on Hauppauge HVR-900H, with RC-5 and NEC remotes.

Issues on IR handling, on this device:
	- Repeat events aren't detected (neither on NEC or RC-5);
	- NEC codes are always provided with 16 bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-core.c  |    2 +-
 drivers/media/video/tm6000/tm6000-input.c |  412 +++++++++++++++--------------
 2 files changed, 218 insertions(+), 196 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
index 6c1fdb5..fa37b5f 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -541,7 +541,7 @@ static struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ07_RDE_IR_PULSE_CNT1, 0x20 },
 	{ TM6010_REQ07_RDF_IR_PULSE_CNT0, 0xd0 },
 	{ REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
-	{ TM6010_REQ07_RD8_IR, 0x2f },
+	{ TM6010_REQ07_RD8_IR, 0x0f },
 
 	/* set remote wakeup key:any key wakeup */
 	{ TM6010_REQ07_RE5_REMOTE_WAKEUP,  0xfe },
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 8b07b72..6eaf770 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -31,22 +31,25 @@
 
 static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
-MODULE_PARM_DESC(ir_debug, "enable debug message [IR]");
+MODULE_PARM_DESC(ir_debug, "debug message level");
 
 static unsigned int enable_ir = 1;
 module_param(enable_ir, int, 0644);
 MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
-/* number of 50ms for ON-OFF-ON power led */
-/* show IR activity */
-#define PWLED_OFF 2
+static unsigned int ir_clock_mhz = 12;
+module_param(ir_clock_mhz, int, 0644);
+MODULE_PARM_DESC(enable_ir, "ir clock, in MHz");
+
+#define URB_SUBMIT_DELAY	100	/* ms - Delay to submit an URB request on retrial and init */
+#define URB_INT_LED_DELAY	100	/* ms - Delay to turn led on again on int mode */
 
 #undef dprintk
 
-#define dprintk(fmt, arg...) \
-	if (ir_debug) { \
+#define dprintk(level, fmt, arg...) do {\
+	if (ir_debug >= level) \
 		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
-	}
+	} while (0)
 
 struct tm6000_ir_poll_result {
 	u16 rc_data;
@@ -62,20 +65,15 @@ struct tm6000_IR {
 	int			polling;
 	struct delayed_work	work;
 	u8			wait:1;
-	u8			key:1;
-	u8			pwled:1;
-	u8			pwledcnt;
+	u8			pwled:2;
+	u8			submit_urb:1;
 	u16			key_addr;
 	struct urb		*int_urb;
-	u8			*urb_data;
-
-	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
 
 	/* IR device properties */
 	u64			rc_type;
 };
 
-
 void tm6000_ir_wait(struct tm6000_core *dev, u8 state)
 {
 	struct tm6000_IR *ir = dev->ir;
@@ -83,62 +81,84 @@ void tm6000_ir_wait(struct tm6000_core *dev, u8 state)
 	if (!dev->ir)
 		return;
 
+	dprintk(2, "%s: %i\n",__func__, ir->wait);
+
 	if (state)
 		ir->wait = 1;
 	else
 		ir->wait = 0;
 }
 
-
 static int tm6000_ir_config(struct tm6000_IR *ir)
 {
 	struct tm6000_core *dev = ir->dev;
-	u8 buf[10];
-	int rc;
+	u32 pulse = 0, leader = 0;
+
+	dprintk(2, "%s\n",__func__);
+
+	/*
+	 * The IR decoder supports RC-5 or NEC, with a configurable timing.
+	 * The timing configuration there is not that accurate, as it uses
+	 * approximate values. The NEC spec mentions a 562.5 unit period,
+	 * and RC-5 uses a 888.8 period.
+	 * Currently, driver assumes a clock provided by a 12 MHz XTAL, but
+	 * a modprobe parameter can adjust it.
+	 * Adjustments are required for other timings.
+	 * It seems that the 900ms timing for NEC is used to detect a RC-5
+	 * IR, in order to discard such decoding
+	 */
 
 	switch (ir->rc_type) {
 	case RC_TYPE_NEC:
-		/* Setup IR decoder for NEC standard 12MHz system clock */
-		/* IR_LEADER_CNT = 0.9ms             */
-		tm6000_set_reg(dev, TM6010_REQ07_RDC_IR_LEADER1, 0xaa);
-		tm6000_set_reg(dev, TM6010_REQ07_RDD_IR_LEADER0, 0x30);
-		/* IR_PULSE_CNT = 0.7ms              */
-		tm6000_set_reg(dev, TM6010_REQ07_RDE_IR_PULSE_CNT1, 0x20);
-		tm6000_set_reg(dev, TM6010_REQ07_RDF_IR_PULSE_CNT0, 0xd0);
-		/* Remote WAKEUP = enable */
-		tm6000_set_reg(dev, TM6010_REQ07_RE5_REMOTE_WAKEUP, 0xfe);
-		/* IR_WKUP_SEL = Low byte in decoded IR data */
-		tm6000_set_reg(dev, TM6010_REQ07_RDA_IR_WAKEUP_SEL, 0xff);
-		/* IR_WKU_ADD code */
-		tm6000_set_reg(dev, TM6010_REQ07_RDB_IR_WAKEUP_ADD, 0xff);
-		tm6000_flash_led(dev, 0);
-		msleep(100);
-		tm6000_flash_led(dev, 1);
+		leader = 900;	/* ms */
+		pulse  = 700;	/* ms - the actual value would be 562 */
 		break;
 	default:
-		/* hack */
-		buf[0] = 0xff;
-		buf[1] = 0xff;
-		buf[2] = 0xf2;
-		buf[3] = 0x2b;
-		buf[4] = 0x20;
-		buf[5] = 0x35;
-		buf[6] = 0x60;
-		buf[7] = 0x04;
-		buf[8] = 0xc0;
-		buf[9] = 0x08;
-
-		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
-			USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
-		msleep(100);
-
-		if (rc < 0) {
-			printk(KERN_INFO "IR configuration failed");
-			return rc;
-		}
+	case RC_TYPE_RC5:
+		leader = 900;	/* ms - from the NEC decoding */
+		pulse  = 1780;	/* ms - The actual value would be 1776 */
 		break;
 	}
 
+	pulse = ir_clock_mhz * pulse;
+	leader = ir_clock_mhz * leader;
+	if (ir->rc_type == RC_TYPE_NEC)
+		leader = leader | 0x8000;
+
+	dprintk(2, "%s: %s, %d MHz, leader = 0x%04x, pulse = 0x%06x \n",
+		__func__,
+		(ir->rc_type == RC_TYPE_NEC) ? "NEC" : "RC-5",
+		ir_clock_mhz, leader, pulse);
+
+	/* Remote WAKEUP = enable, normal mode, from IR decoder output */
+	tm6000_set_reg(dev, TM6010_REQ07_RE5_REMOTE_WAKEUP, 0xfe);
+
+	/* Enable IR reception on non-busrt mode */
+	tm6000_set_reg(dev, TM6010_REQ07_RD8_IR, 0x2f);
+
+	/* IR_WKUP_SEL = Low byte in decoded IR data */
+	tm6000_set_reg(dev, TM6010_REQ07_RDA_IR_WAKEUP_SEL, 0xff);
+	/* IR_WKU_ADD code */
+	tm6000_set_reg(dev, TM6010_REQ07_RDB_IR_WAKEUP_ADD, 0xff);
+
+	tm6000_set_reg(dev, TM6010_REQ07_RDC_IR_LEADER1, leader >> 8);
+	tm6000_set_reg(dev, TM6010_REQ07_RDD_IR_LEADER0, leader);
+
+	tm6000_set_reg(dev, TM6010_REQ07_RDE_IR_PULSE_CNT1, pulse >> 8);
+	tm6000_set_reg(dev, TM6010_REQ07_RDF_IR_PULSE_CNT0, pulse);
+
+	if (!ir->polling)
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
+	else
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
+	msleep(10);
+
+	/* Shows that IR is working via the LED */
+	tm6000_flash_led(dev, 0);
+	msleep(100);
+	tm6000_flash_led(dev, 1);
+	ir->pwled = 1;
+
 	return 0;
 }
 
@@ -146,143 +166,124 @@ static void tm6000_ir_urb_received(struct urb *urb)
 {
 	struct tm6000_core *dev = urb->context;
 	struct tm6000_IR *ir = dev->ir;
+	struct tm6000_ir_poll_result poll_result;
+	char *buf;
 	int rc;
 
-	if (urb->status != 0)
-		printk(KERN_INFO "not ready\n");
-	else if (urb->actual_length > 0) {
-		memcpy(ir->urb_data, urb->transfer_buffer, urb->actual_length);
+	dprintk(2, "%s\n",__func__);
+	if (urb->status < 0 || urb->actual_length <= 0) {
+		printk(KERN_INFO "tm6000: IR URB failure: status: %i, length %i\n",
+		       urb->status, urb->actual_length);
+		ir->submit_urb = 1;
+		schedule_delayed_work(&ir->work, msecs_to_jiffies(URB_SUBMIT_DELAY));
+		return;
+	}
+	buf = urb->transfer_buffer;
 
-		dprintk("data %02x %02x %02x %02x\n", ir->urb_data[0],
-			ir->urb_data[1], ir->urb_data[2], ir->urb_data[3]);
+	if (ir_debug)
+		print_hex_dump(KERN_DEBUG, "tm6000: IR data: ",
+			       DUMP_PREFIX_OFFSET,16, 1,
+			       buf, urb->actual_length, false);
 
-		ir->key = 1;
-	}
+	poll_result.rc_data = buf[0];
+	if (urb->actual_length > 1)
+		poll_result.rc_data |= buf[1] << 8;
+
+	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
+	rc_keydown(ir->rc, poll_result.rc_data, 0);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	/*
+	 * Flash the led. We can't do it here, as it is running on IRQ context.
+	 * So, use the scheduler to do it, in a few ms.
+	 */
+	ir->pwled = 2;
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(10));
 }
 
-static int default_polling_getkey(struct tm6000_IR *ir,
-				struct tm6000_ir_poll_result *poll_result)
+static void tm6000_ir_handle_key(struct work_struct *work)
 {
+	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
 	struct tm6000_core *dev = ir->dev;
+	struct tm6000_ir_poll_result poll_result;
 	int rc;
 	u8 buf[2];
 
-	if (ir->wait && !&dev->int_in)
-		return 0;
-
-	if (&dev->int_in) {
-		switch (ir->rc_type) {
-		case RC_TYPE_RC5:
-			poll_result->rc_data = ir->urb_data[0];
-			break;
-		case RC_TYPE_NEC:
-			switch (dev->model) {
-			case 10:
-			case 11:
-			case 14:
-			case 15:
-				if (ir->urb_data[1] ==
-					((ir->key_addr >> 8) & 0xff)) {
-					poll_result->rc_data =
-					ir->urb_data[0]
-					| ir->urb_data[1] << 8;
-				}
-				break;
-			default:
-				poll_result->rc_data = ir->urb_data[0]
-					| ir->urb_data[1] << 8;
-			}
-			break;
-		default:
-			poll_result->rc_data = ir->urb_data[0]
-					| ir->urb_data[1] << 8;
-			break;
-		}
-	} else {
-		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
-		msleep(10);
-		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
-		msleep(10);
-
-		if (ir->rc_type == RC_TYPE_RC5) {
-			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
-				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				REQ_02_GET_IR_CODE, 0, 0, buf, 1);
-
-			msleep(10);
-
-			dprintk("read data=%02x\n", buf[0]);
-			if (rc < 0)
-				return rc;
+	if (ir->wait)
+		return;
 
-			poll_result->rc_data = buf[0];
-		} else {
-			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
-				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				REQ_02_GET_IR_CODE, 0, 0, buf, 2);
+	dprintk(3, "%s\n",__func__);
 
-			msleep(10);
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN |
+		USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		REQ_02_GET_IR_CODE, 0, 0, buf, 2);
+	if (rc < 0)
+		return;
 
-			dprintk("read data=%04x\n", buf[0] | buf[1] << 8);
-			if (rc < 0)
-				return rc;
+	if (rc > 1)
+		poll_result.rc_data = buf[0] | buf[1] << 8;
+	else
+		poll_result.rc_data = buf[0];
 
-			poll_result->rc_data = buf[0] | buf[1] << 8;
+	/* Check if something was read */
+	if ((poll_result.rc_data & 0xff) == 0xff) {
+		if (!ir->pwled) {
+			tm6000_flash_led(dev, 1);
+			ir->pwled = 1;
 		}
-		if ((poll_result->rc_data & 0x00ff) != 0xff)
-			ir->key = 1;
+		return;
 	}
-	return 0;
+
+	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
+	rc_keydown(ir->rc, poll_result.rc_data, 0);
+	tm6000_flash_led(dev, 0);
+	ir->pwled = 0;
+
+	/* Re-schedule polling */
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
-static void tm6000_ir_handle_key(struct tm6000_IR *ir)
+static void tm6000_ir_int_work(struct work_struct *work)
 {
+	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
 	struct tm6000_core *dev = ir->dev;
-	int result;
-	struct tm6000_ir_poll_result poll_result;
+	int rc;
 
-	/* read the registers containing the IR status */
-	result = ir->get_key(ir, &poll_result);
-	if (result < 0) {
-		printk(KERN_INFO "ir->get_key() failed %d\n", result);
-		return;
-	}
+	dprintk(3, "%s, submit_urb = %d, pwled = %d\n",__func__, ir->submit_urb,
+		ir->pwled);
 
-	if (ir->pwled) {
-		if (ir->pwledcnt >= PWLED_OFF) {
-			ir->pwled = 0;
-			ir->pwledcnt = 0;
-			tm6000_flash_led(dev, 1);
-		} else
-			ir->pwledcnt += 1;
+	if (ir->submit_urb) {
+		dprintk(3, "Resubmit urb\n");
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
+
+		rc = usb_submit_urb(ir->int_urb, GFP_ATOMIC);
+		if (rc < 0) {
+			printk(KERN_ERR "tm6000: Can't submit an IR interrupt. Error %i\n",
+			       rc);
+			/* Retry in 100 ms */
+			schedule_delayed_work(&ir->work, msecs_to_jiffies(URB_SUBMIT_DELAY));
+			return;
+		}
+		ir->submit_urb = 0;
 	}
 
-	if (ir->key) {
-		dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
-		rc_keydown(ir->rc, poll_result.rc_data, 0);
-		ir->key = 0;
-		ir->pwled = 1;
-		ir->pwledcnt = 0;
+	/* Led is enabled only if USB submit doesn't fail */
+	if (ir->pwled == 2) {
 		tm6000_flash_led(dev, 0);
+		ir->pwled = 0;
+		schedule_delayed_work(&ir->work, msecs_to_jiffies(URB_INT_LED_DELAY));
+	} else if (!ir->pwled) {
+		tm6000_flash_led(dev, 1);
+		ir->pwled = 1;
 	}
-	return;
-}
-
-static void tm6000_ir_work(struct work_struct *work)
-{
-	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
-
-	tm6000_ir_handle_key(ir);
-	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
 static int tm6000_ir_start(struct rc_dev *rc)
 {
 	struct tm6000_IR *ir = rc->priv;
 
-	INIT_DELAYED_WORK(&ir->work, tm6000_ir_work);
+	dprintk(2, "%s\n",__func__);
+
 	schedule_delayed_work(&ir->work, 0);
 
 	return 0;
@@ -292,6 +293,8 @@ static void tm6000_ir_stop(struct rc_dev *rc)
 {
 	struct tm6000_IR *ir = rc->priv;
 
+	dprintk(2, "%s\n",__func__);
+
 	cancel_delayed_work_sync(&ir->work);
 }
 
@@ -302,10 +305,11 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 	if (!ir)
 		return 0;
 
+	dprintk(2, "%s\n",__func__);
+
 	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
 		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
 
-	ir->get_key = default_polling_getkey;
 	ir->rc_type = rc_type;
 
 	tm6000_ir_config(ir);
@@ -313,17 +317,19 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 	return 0;
 }
 
-int tm6000_ir_int_start(struct tm6000_core *dev)
+static int __tm6000_ir_int_start(struct rc_dev *rc)
 {
-	struct tm6000_IR *ir = dev->ir;
+	struct tm6000_IR *ir = rc->priv;
+	struct tm6000_core *dev = ir->dev;
 	int pipe, size;
 	int err = -ENOMEM;
 
-
 	if (!ir)
 		return -ENODEV;
 
-	ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+	dprintk(2, "%s\n",__func__);
+
+	ir->int_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!ir->int_urb)
 		return -ENOMEM;
 
@@ -332,42 +338,53 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
 		& USB_ENDPOINT_NUMBER_MASK);
 
 	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
-	dprintk("IR max size: %d\n", size);
+	dprintk(1, "IR max size: %d\n", size);
 
-	ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
+	ir->int_urb->transfer_buffer = kzalloc(size, GFP_ATOMIC);
 	if (ir->int_urb->transfer_buffer == NULL) {
 		usb_free_urb(ir->int_urb);
 		return err;
 	}
-	dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
+	dprintk(1, "int interval: %d\n", dev->int_in.endp->desc.bInterval);
+
 	usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
 		ir->int_urb->transfer_buffer, size,
 		tm6000_ir_urb_received, dev,
 		dev->int_in.endp->desc.bInterval);
-	err = usb_submit_urb(ir->int_urb, GFP_ATOMIC);
-	if (err) {
-		kfree(ir->int_urb->transfer_buffer);
-		usb_free_urb(ir->int_urb);
-		return err;
-	}
-	ir->urb_data = kzalloc(size, GFP_KERNEL);
+
+	ir->submit_urb = 1;
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(URB_SUBMIT_DELAY));
 
 	return 0;
 }
 
-void tm6000_ir_int_stop(struct tm6000_core *dev)
+static void __tm6000_ir_int_stop(struct rc_dev *rc)
 {
-	struct tm6000_IR *ir = dev->ir;
+	struct tm6000_IR *ir = rc->priv;
 
-	if (!ir)
+	if (!ir || !ir->int_urb)
 		return;
 
+	dprintk(2, "%s\n",__func__);
+
 	usb_kill_urb(ir->int_urb);
 	kfree(ir->int_urb->transfer_buffer);
 	usb_free_urb(ir->int_urb);
 	ir->int_urb = NULL;
-	kfree(ir->urb_data);
-	ir->urb_data = NULL;
+}
+
+int tm6000_ir_int_start(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	return __tm6000_ir_int_start(ir->rc);
+}
+
+void tm6000_ir_int_stop(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	__tm6000_ir_int_stop(ir->rc);
 }
 
 int tm6000_ir_init(struct tm6000_core *dev)
@@ -385,7 +402,9 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	if (!dev->ir_codes)
 		return 0;
 
-	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+	dprintk(2, "%s\n",__func__);
+
+	ir = kzalloc(sizeof(*ir), GFP_ATOMIC);
 	rc = rc_allocate_device();
 	if (!ir || !rc)
 		goto out;
@@ -395,19 +414,22 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	dev->ir = ir;
 	ir->rc = rc;
 
-	/* input einrichten */
+	/* input setup */
 	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
-	rc->open = tm6000_ir_start;
-	rc->close = tm6000_ir_stop;
+	if (&dev->int_in) {
+		rc->open    = __tm6000_ir_int_start;
+		rc->close   = __tm6000_ir_int_stop;
+		INIT_DELAYED_WORK(&ir->work, tm6000_ir_int_work);
+	} else {
+		rc->open  = tm6000_ir_start;
+		rc->close = tm6000_ir_stop;
+		ir->polling = 50;
+		INIT_DELAYED_WORK(&ir->work, tm6000_ir_handle_key);
+	}
 	rc->driver_type = RC_DRIVER_SCANCODE;
 
-	ir->polling = 50;
-	ir->pwled = 0;
-	ir->pwledcnt = 0;
-
-
 	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
 						dev->name);
 
@@ -426,15 +448,6 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc->driver_name = "tm6000";
 	rc->dev.parent = &dev->udev->dev;
 
-	if (&dev->int_in) {
-		dprintk("IR over int\n");
-
-		err = tm6000_ir_int_start(dev);
-
-		if (err)
-			goto out;
-	}
-
 	/* ir register */
 	err = rc_register_device(rc);
 	if (err)
@@ -458,10 +471,19 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	if (!ir)
 		return 0;
 
+	dprintk(2, "%s\n",__func__);
+
 	rc_unregister_device(ir->rc);
 
-	if (ir->int_urb)
-		tm6000_ir_int_stop(dev);
+	if (!ir->polling)
+		__tm6000_ir_int_stop(ir->rc);
+
+	tm6000_ir_stop(ir->rc);
+
+	/* Turn off the led */
+	tm6000_flash_led(dev, 0);
+	ir->pwled = 0;
+
 
 	kfree(ir);
 	dev->ir = NULL;
-- 
1.7.7.3

