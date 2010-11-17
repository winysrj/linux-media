Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935196Ab0KQTZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:25:51 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJPpf0004771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:25:51 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xS007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:25:38 -0500
Date: Wed, 17 Nov 2010 17:08:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/10] [media] Rename all public generic RC functions from
 ir_ to rc_
Message-ID: <20101117170827.3a23850e@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those functions are not InfraRed specific. So, rename them to properly
reflect it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index e9cacf6..2d8b404 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -531,7 +531,7 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	ir_keydown(ir->dev, data, 0);
+	rc_keydown(ir->dev, data, 0);
 }
 
 /* work handler */
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 8b9ab30..bc2a6e4 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1041,13 +1041,13 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 				priv->rc_keycode = buf[12] << 16 |
 					buf[13] << 8 | buf[14];
 			}
-			ir_keydown(d->rc_dev, priv->rc_keycode, 0);
+			rc_keydown(d->rc_dev, priv->rc_keycode, 0);
 		} else {
 			priv->rc_keycode = 0; /* clear just for sure */
 		}
 	} else if (priv->rc_repeat != buf[6] || buf[0]) {
 		deb_rc("%s: key repeated\n", __func__);
-		ir_keydown(d->rc_dev, priv->rc_keycode, 0);
+		rc_keydown(d->rc_dev, priv->rc_keycode, 0);
 	} else {
 		deb_rc("%s: no key press\n", __func__);
 	}
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index c6e4ba5..5e12488 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -394,7 +394,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 
 	if (ircode[0]) {
 		deb_rc("%s: key pressed %02x\n", __func__, ircode[1]);
-		ir_keydown(d->rc_dev, 0x08 << 8 | ircode[1], 0);
+		rc_keydown(d->rc_dev, 0x08 << 8 | ircode[1], 0);
 	}
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 3b58f45..1dd119e 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -600,7 +600,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	ir_keydown(d->rc_dev, keycode, toggle);
+	rc_keydown(d->rc_dev, keycode, toggle);
 
 resubmit:
 	/* Clean the buffer before we requeue */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index be167f2..9ac920d 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -520,13 +520,13 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 			d->last_event = keycode;
 		}
 
-		ir_keydown(d->rc_dev, keycode, 0);
+		rc_keydown(d->rc_dev, keycode, 0);
 		break;
 	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
 		keycode = key[3-2] << 8 | key[3-3];
 		toggle = key[3-1];
-		ir_keydown(d->rc_dev, keycode, toggle);
+		rc_keydown(d->rc_dev, keycode, toggle);
 
 		break;
 	}
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index f0c0308..1455c23 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -198,7 +198,7 @@ static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
 	deb_info(1, "INT Key Keypress =%04x", keypress);
 
 	if (keypress > 0)
-		ir_keydown(d->rc_dev, keypress, 0);
+		rc_keydown(d->rc_dev, keypress, 0);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 32caa9b..8ae67c1 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -159,7 +159,7 @@ static void msp430_ir_interrupt(unsigned long data)
 	    budget_ci->ir.rc5_device != (command & 0x1f))
 		return;
 
-	ir_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
+	rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b6ba3c7..d67573e 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1146,14 +1146,14 @@ static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 scancode)
 	bool is_release_code = false;
 
 	/* Look for the initial press of a button */
-	keycode = ir_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
 	ictx->rc_toggle = 0x0;
 	ictx->rc_scancode = scancode;
 
 	/* Look for the release of a button */
 	if (keycode == KEY_RESERVED) {
 		release = scancode & ~0x4000;
-		keycode = ir_g_keycode_from_table(ictx->rdev, release);
+		keycode = rc_g_keycode_from_table(ictx->rdev, release);
 		if (keycode != KEY_RESERVED)
 			is_release_code = true;
 	}
@@ -1182,7 +1182,7 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
 		scancode = scancode | MCE_KEY_MASK | MCE_TOGGLE_BIT;
 
 	ictx->rc_scancode = scancode;
-	keycode = ir_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
 
 	/* not used in mce mode, but make sure we know its false */
 	ictx->release_code = false;
@@ -1564,9 +1564,9 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 	if (ktype != IMON_KEY_PANEL) {
 		if (press_type == 0)
-			ir_keyup(ictx->rdev);
+			rc_keyup(ictx->rdev);
 		else {
-			ir_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
+			rc_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index cfe0e70..09c143f 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -139,12 +139,12 @@ again:
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
 			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
-			ir_keydown(dev, scancode, data->toggle);
+			rc_keydown(dev, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
 			IR_dprintk(1, "JVC repeat\n");
-			ir_repeat(dev);
+			rc_repeat(dev);
 		} else {
 			IR_dprintk(1, "JVC invalid repeat msg\n");
 			break;
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 8ff157a..235d774 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -88,7 +88,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			ir_repeat(dev);
+			rc_repeat(dev);
 			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
 			return 0;
@@ -114,7 +114,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			geq_margin(ev.duration,
 			NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
 				IR_dprintk(1, "Repeat last key\n");
-				ir_repeat(dev);
+				rc_repeat(dev);
 				data->state = STATE_INACTIVE;
 				return 0;
 
@@ -178,7 +178,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		ir_keydown(dev, scancode, 0);
+		rc_keydown(dev, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index dae6f9a..779ab0d 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -150,7 +150,7 @@ again:
 				   scancode, toggle);
 		}
 
-		ir_keydown(dev, scancode, toggle);
+		rc_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index d8a53c0..5586bf2 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -114,7 +114,7 @@ again:
 		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
 			   scancode, toggle);
 
-		ir_keydown(dev, scancode, toggle);
+		rc_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 2435bbd..88d9487 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -242,7 +242,7 @@ again:
 			goto out;
 		}
 
-		ir_keydown(dev, scancode, toggle);
+		rc_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 3138520..5292b89 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -143,7 +143,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = device << 16 | subdevice << 8 | function;
 		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
-		ir_keydown(dev, scancode, 0);
+		rc_keydown(dev, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d91b62c..11e2703 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -481,7 +481,7 @@ out:
 }
 
 /**
- * ir_g_keycode_from_table() - gets the keycode that corresponds to a scancode
+ * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode to look for
  * @return:	the corresponding keycode, or KEY_RESERVED
@@ -490,7 +490,7 @@ out:
  * keycode. Normally it should not be used since drivers should have no
  * interest in keycodes.
  */
-u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
+u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 {
 	struct ir_scancode_table *rc_tab = &dev->rc_tab;
 	unsigned int keycode;
@@ -511,7 +511,7 @@ u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 
 	return keycode;
 }
-EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
+EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
 
 /**
  * ir_do_keyup() - internal function to signal the release of a keypress
@@ -532,13 +532,13 @@ static void ir_do_keyup(struct rc_dev *dev)
 }
 
 /**
- * ir_keyup() - signals the release of a keypress
+ * rc_keyup() - signals the release of a keypress
  * @dev:	the struct rc_dev descriptor of the device
  *
  * This routine is used to signal that a key has been released on the
  * remote control.
  */
-void ir_keyup(struct rc_dev *dev)
+void rc_keyup(struct rc_dev *dev)
 {
 	unsigned long flags;
 
@@ -546,7 +546,7 @@ void ir_keyup(struct rc_dev *dev)
 	ir_do_keyup(dev);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
-EXPORT_SYMBOL_GPL(ir_keyup);
+EXPORT_SYMBOL_GPL(rc_keyup);
 
 /**
  * ir_timer_keyup() - generates a keyup event after a timeout
@@ -577,14 +577,14 @@ static void ir_timer_keyup(unsigned long cookie)
 }
 
 /**
- * ir_repeat() - signals that a key is still pressed
+ * rc_repeat() - signals that a key is still pressed
  * @dev:	the struct rc_dev descriptor of the device
  *
  * This routine is used by IR decoders when a repeat message which does
  * not include the necessary bits to reproduce the scancode has been
  * received.
  */
-void ir_repeat(struct rc_dev *dev)
+void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
 
@@ -601,7 +601,7 @@ void ir_repeat(struct rc_dev *dev)
 out:
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
-EXPORT_SYMBOL_GPL(ir_repeat);
+EXPORT_SYMBOL_GPL(rc_repeat);
 
 /**
  * ir_do_keydown() - internal function to process a keypress
@@ -643,7 +643,7 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 }
 
 /**
- * ir_keydown() - generates input event for a key press
+ * rc_keydown() - generates input event for a key press
  * @dev:	the struct rc_dev descriptor of the device
  * @scancode:   the scancode that we're seeking
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
@@ -652,10 +652,10 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, scancode, keycode, toggle);
@@ -666,10 +666,10 @@ void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle)
 	}
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
-EXPORT_SYMBOL_GPL(ir_keydown);
+EXPORT_SYMBOL_GPL(rc_keydown);
 
 /**
- * ir_keydown_notimeout() - generates input event for a key press without
+ * rc_keydown_notimeout() - generates input event for a key press without
  *                          an automatic keyup event at a later time
  * @dev:	the struct rc_dev descriptor of the device
  * @scancode:   the scancode that we're seeking
@@ -677,18 +677,18 @@ EXPORT_SYMBOL_GPL(ir_keydown);
  *              support toggle values, this should be set to zero)
  *
  * This routine is used to signal that a key has been pressed on the
- * remote control. The driver must manually call ir_keyup() at a later stage.
+ * remote control. The driver must manually call rc_keyup() at a later stage.
  */
-void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, scancode, keycode, toggle);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
-EXPORT_SYMBOL_GPL(ir_keydown_notimeout);
+EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
 static int ir_open(struct input_dev *idev)
 {
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index e4df7f8..773ee6a 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -70,14 +70,14 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown && (gpio & ir->mask_keydown)) ||
 	    (ir->mask_keyup   && !(gpio & ir->mask_keyup))) {
-		ir_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 
-		ir_keyup(ir->dev);
+		rc_keyup(ir->dev);
 	}
 }
 
@@ -100,9 +100,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		ir_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, data, 0);
 		if (keyup)
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 	} else {
 		if ((ir->last_gpio & 1 << 31) == keyup)
 			return;
@@ -112,9 +112,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			(gpio & ir->mask_keyup) ? " up" : "down");
 
 		if (keyup)
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 		else
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -232,7 +232,7 @@ void bttv_rc5_timer_end(unsigned long data)
 			u32 instr = RC5_INSTR(rc5);
 
 			/* Good code */
-			ir_keydown(ir->dev, instr, toggle);
+			rc_keydown(ir->dev, instr, toggle);
 			dprintk(KERN_INFO DEVNAME ":"
 				" instruction %x, toggle %x\n",
 				instr, toggle);
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index a730338..cfeba4c 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -123,26 +123,26 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		ir_keydown(ir->dev, data, 0);
+		rc_keydown(ir->dev, data, 0);
 
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 		else
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 		else
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		ir_keydown_notimeout(ir->dev, data, 0);
-		ir_keyup(ir->dev);
+		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keyup(ir->dev);
 	}
 }
 
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index b7d3999..e32eb38 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -297,12 +297,12 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 			poll_result.toggle_bit, poll_result.read_count,
 			poll_result.rc_address, poll_result.rc_data[0]);
 		if (ir->full_code)
-			ir_keydown(ir->rc,
+			rc_keydown(ir->rc,
 				   poll_result.rc_address << 8 |
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
 		else
-			ir_keydown(ir->rc,
+			rc_keydown(ir->rc,
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
 
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 83662a4..c77ea53 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -252,7 +252,7 @@ static void ir_key_poll(struct IR_i2c *ir)
 	}
 
 	if (rc)
-		ir_keydown(ir->rc, ir_key, 0);
+		rc_keydown(ir->rc, ir_key, 0);
 }
 
 static void ir_work(struct work_struct *work)
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 900e798..cd39aea 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -89,25 +89,25 @@ static int build_key(struct saa7134_dev *dev)
 	switch (dev->board) {
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
 		if (data == ir->mask_keycode)
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 		else
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, data, 0);
 		} else {
-			ir_keyup(ir->dev);
+			rc_keyup(ir->dev);
 		}
 	}
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_keydown_notimeout(ir->dev, data, 0);
-			ir_keyup(ir->dev);
+			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keyup(ir->dev);
 		}
 	}
 
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 58e93d0..02b9829 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -199,7 +199,7 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
 	if (ir->key) {
-		ir_keydown(ir->rc, poll_result.rc_data, 0);
+		rc_keydown(ir->rc, poll_result.rc_data, 0);
 		ir->key = 0;
 	}
 	return;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index eedb2f0..170581b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -13,8 +13,8 @@
  *  GNU General Public License for more details.
  */
 
-#ifndef _IR_CORE
-#define _IR_CORE
+#ifndef _RC_CORE
+#define _RC_CORE
 
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
@@ -120,6 +120,32 @@ struct rc_dev {
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
 };
 
+#define to_rc_dev(d) container_of(d, struct rc_dev, dev)
+
+/*
+ * From rc-main.c
+ * Those functions can be used on any type of Remote Controller. They
+ * basically creates an input_dev and properly reports the device as a
+ * Remote Controller, at sys/class/rc.
+ */
+
+struct rc_dev *rc_allocate_device(void);
+void rc_free_device(struct rc_dev *dev);
+int rc_register_device(struct rc_dev *dev);
+void rc_unregister_device(struct rc_dev *dev);
+
+void rc_repeat(struct rc_dev *dev);
+void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
+void rc_keyup(struct rc_dev *dev);
+u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
+
+/*
+ * From rc-raw.c
+ * The Raw interface is specific to InfraRed. It may be a good idea to
+ * split it later into a separate header.
+ */
+
 enum raw_event_type {
 	IR_SPACE        = (1 << 0),
 	IR_PULSE        = (1 << 1),
@@ -127,16 +153,6 @@ enum raw_event_type {
 	IR_STOP_EVENT   = (1 << 3),
 };
 
-#define to_rc_dev(d) container_of(d, struct rc_dev, dev)
-
-
-void ir_repeat(struct rc_dev *dev);
-void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle);
-void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
-void ir_keyup(struct rc_dev *dev);
-u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
-
-/* From ir-raw-event.c */
 struct ir_raw_event {
 	union {
 		u32             duration;
@@ -168,11 +184,6 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 
 #define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
 
-struct rc_dev *rc_allocate_device(void);
-void rc_free_device(struct rc_dev *dev);
-int rc_register_device(struct rc_dev *dev);
-void rc_unregister_device(struct rc_dev *dev);
-
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
@@ -189,7 +200,6 @@ static inline void ir_raw_event_reset(struct rc_dev *dev)
 	ir_raw_event_handle(dev);
 }
 
-
 /* extract mask bits out of data and pack them into the result */
 static inline u32 ir_extract_bits(u32 data, u32 mask)
 {
@@ -207,5 +217,4 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 	return value;
 }
 
-
-#endif /* _IR_CORE */
+#endif /* _RC_CORE */
-- 
1.7.1


