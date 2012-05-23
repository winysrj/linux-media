Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44248 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2EWJtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:49:50 -0400
Subject: [PATCH 03/43] rc-core: don't throw away protocol information
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:16 +0200
Message-ID: <20120523094216.14474.31428.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting and getting keycodes in the input subsystem used to be done via
the EVIOC[GS]KEYCODE ioctl and "unsigned int[2]" (one int for scancode
and one for the keycode).

The interface has now been extended to use the EVIOC[GS]KEYCODE_V2 ioctl
which uses the following struct:

struct input_keymap_entry {
	__u8  flags;
	__u8  len;
	__u16 index;
	__u32 keycode;
	__u8  scancode[32];
};

(scancode can of course be even bigger, thanks to the len member).

This patch changes how the "input_keymap_entry" struct is interpreted
by rc-core by casting it to "rc_keymap_entry":

struct rc_scancode {
	__u16 protocol;
	__u16 reserved[3];
	__u64 scancode;
}

struct rc_keymap_entry {
	__u8  flags;
	__u8  len;
	__u16 index;
	__u32 keycode;
	union {
		struct rc_scancode rc;
		__u8 raw[32];
	};
};

The u64 scancode member is large enough for all current protocols and it
would be possible to extend it in the future should it be necessary for
some exotic protocol.

The main advantage with this change is that the protocol is made explicit,
which means that we're not throwing away data (the protocol type) and that
it'll be easier to support multiple protocols with one decoder (think rc5
and rc5-streamzap).

Further patches will also add the ability to communicate the protocol to
userspace.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dm1105/dm1105.c           |    3 
 drivers/media/dvb/dvb-usb/af9015.c          |    4 
 drivers/media/dvb/dvb-usb/af9035.c          |    2 
 drivers/media/dvb/dvb-usb/anysee.c          |    2 
 drivers/media/dvb/dvb-usb/az6007.c          |   25 ++-
 drivers/media/dvb/dvb-usb/dib0700_core.c    |    2 
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   10 +
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 
 drivers/media/dvb/dvb-usb/it913x.c          |   19 +-
 drivers/media/dvb/dvb-usb/lmedm04.c         |    3 
 drivers/media/dvb/dvb-usb/pctv452e.c        |   11 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c        |   17 +-
 drivers/media/dvb/dvb-usb/ttusb2.c          |    2 
 drivers/media/dvb/ttpci/budget-ci.c         |    7 -
 drivers/media/rc/ati_remote.c               |   13 +
 drivers/media/rc/imon.c                     |   10 +
 drivers/media/rc/ir-jvc-decoder.c           |    4 
 drivers/media/rc/ir-lirc-codec.c            |    2 
 drivers/media/rc/ir-mce_kbd-decoder.c       |    2 
 drivers/media/rc/ir-nec-decoder.c           |    4 
 drivers/media/rc/ir-raw.c                   |    2 
 drivers/media/rc/ir-rc5-decoder.c           |   23 +--
 drivers/media/rc/ir-rc5-sz-decoder.c        |    4 
 drivers/media/rc/ir-rc6-decoder.c           |   48 +++---
 drivers/media/rc/ir-sanyo-decoder.c         |    4 
 drivers/media/rc/ir-sony-decoder.c          |   26 +--
 drivers/media/rc/rc-core-priv.h             |    1 
 drivers/media/rc/rc-main.c                  |  235 +++++++++++++++++++--------
 drivers/media/video/bt8xx/bttv-input.c      |   15 +-
 drivers/media/video/cx88/cx88-input.c       |   10 +
 drivers/media/video/em28xx/em28xx-cards.c   |   15 ++
 drivers/media/video/em28xx/em28xx-input.c   |   34 ++--
 drivers/media/video/em28xx/em28xx.h         |    1 
 drivers/media/video/ir-kbd-i2c.c            |   12 +
 drivers/media/video/saa7134/saa7134-input.c |    6 -
 drivers/media/video/tm6000/tm6000-cards.c   |    2 
 drivers/media/video/tm6000/tm6000-input.c   |   61 ++++---
 include/media/rc-core.h                     |   28 +++
 include/media/rc-map.h                      |   17 ++
 39 files changed, 434 insertions(+), 254 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index a609b3a..04a02ba 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -677,7 +677,8 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	rc_keydown(ir->dev, data, 0);
+	/* Yes, UNKNOWN because we don't generate a full NEC scancode (yet?) */
+	rc_keydown(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 }
 
 /* work handler */
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 5395c6a..bd47e68 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1046,7 +1046,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	if ((priv->rc_repeat != buf[6] || buf[0]) &&
 					!memcmp(&buf[12], priv->rc_last, 4)) {
 		deb_rc("%s: key repeated\n", __func__);
-		rc_keydown(d->rc_dev, priv->rc_keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
 		priv->rc_repeat = buf[6];
 		return ret;
 	}
@@ -1077,7 +1077,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 			priv->rc_keycode = buf[12] << 24 | buf[13] << 16 |
 					buf[14] << 8 | buf[15];
 		}
-		rc_keydown(d->rc_dev, priv->rc_keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
 	} else {
 		deb_rc("%s: no key press\n", __func__);
 		/* Invalidate last keypress */
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index d7c7c17..c000feb 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -325,7 +325,7 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 		key = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
 	}
 
-	rc_keydown(d->rc_dev, key, 0);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
 
 err:
 	/* ignore errors */
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index f510f91..6053670 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -1058,7 +1058,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 
 	if (ircode[0]) {
 		deb_rc("%s: key pressed %02x\n", __func__, ircode[1]);
-		rc_keydown(d->rc_dev, 0x08 << 8 | ircode[1], 0);
+		rc_keydown(d->rc_dev, RC_TYPE_OTHER, 0x08 << 8 | ircode[1], 0);
 	}
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 102114e..1e26863 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -197,24 +197,27 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d->priv;
-	unsigned code = 0;
+	u64 code;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
 	if (st->data[1] == 0x44)
 		return 0;
 
-	if ((st->data[1] ^ st->data[2]) == 0xff)
-		code = st->data[1];
-	else
-		code = st->data[1] << 8 | st->data[2];
-
-	if ((st->data[3] ^ st->data[4]) == 0xff)
-		code = code << 8 | st->data[3];
-	else
-		code = code << 16 | st->data[3] << 8 | st->data[4];
+	if ((st->data[3] ^ st->data[4]) == 0xff) {
+		if ((st->data[1] ^ st->data[2]) == 0xff)
+			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
+		else
+			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
+						st->data[3]);
+	} else {
+		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
+					 st->data[2] << 16 |
+					 st->data[3] << 8  |
+					 st->data[4]);
+	}
 
-	rc_keydown(d->rc_dev, code, st->data[5]);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 192d805..f57c3f8 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -744,7 +744,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	rc_keydown(d->rc_dev, keycode, toggle);
+	rc_keydown(d->rc_dev, d->props.rc.core.protocol, keycode, toggle);
 
 resubmit:
 	/* Clean the buffer before we requeue */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 1179842..b1b94f7 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -489,7 +489,7 @@ static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 {
 	u8 key[4];
-	u32 keycode;
+	u64 keycode;
 	u8 toggle;
 	int i;
 	struct dib0700_state *st = d->priv;
@@ -524,17 +524,17 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 		    (key[3] == 0xff))
 			keycode = d->last_event;
 		else {
-			keycode = key[3-2] << 8 | key[3-3];
+			keycode = RC_SCANCODE_NEC(key[3-2], key[3-3]);
 			d->last_event = keycode;
 		}
 
-		rc_keydown(d->rc_dev, keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, keycode, 0);
 		break;
 	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
-		keycode = key[3-2] << 8 | key[3-3];
+		keycode = RC_SCANCODE_RC5(key[3-2], key[3-3]);
 		toggle = key[3-1];
-		rc_keydown(d->rc_dev, keycode, toggle);
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, keycode, toggle);
 
 		break;
 	}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 99f9440..ed886ae 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -449,7 +449,7 @@ struct dvb_usb_device {
 	struct input_dev *input_dev;
 	char rc_phys[64];
 	struct delayed_work rc_query_work;
-	u32 last_event;
+	u64 last_event;
 	int last_state;
 
 	struct module *owner;
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index e54f3dc..2c3c400 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -381,7 +381,12 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 {
 	u8 ibuf[4];
 	int ret;
-	u32 key;
+	u16 device, command;
+	u64 scancode;
+
+	if (!d->rc_dev)
+		return 0;
+
 	/* Avoid conflict with frontends*/
 	mutex_lock(&d->i2c_mutex);
 
@@ -389,12 +394,12 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 		0, 0, &ibuf[0], sizeof(ibuf));
 
 	if ((ibuf[2] + ibuf[3]) == 0xff) {
-		key = ibuf[2];
-		key += ibuf[0] << 16;
-		key += ibuf[1] << 8;
-		deb_info(1, "NEC Extended Key =%08x", key);
-		if (d->rc_dev != NULL)
-			rc_keydown(d->rc_dev, key, 0);
+		command = ibuf[2];
+		device = (ibuf[0] << 8) | ibuf[1];
+		scancode = RC_SCANCODE_NECX(device, command);
+		deb_info(1, "NEC Extended Key = 0x%08llx",
+			 (unsigned long long)scancode);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
 	}
 
 	mutex_unlock(&d->i2c_mutex);
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 8ff161e..4280e07 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -284,7 +284,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 				key += (ibuf[2] ^ 0xff) << 16;
 				deb_info(1, "INT Key =%08x", key);
 				if (adap->dev->rc_dev != NULL)
-					rc_keydown(adap->dev->rc_dev, key, 0);
+					rc_keydown(adap->dev->rc_dev,
+						   RC_TYPE_UNKNOWN, key, 0);
 			}
 			break;
 		case 0xbb:
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-usb/pctv452e.c
index 6eefd4e..a64fa5d 100644
--- a/drivers/media/dvb/dvb-usb/pctv452e.c
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -96,7 +96,7 @@ struct pctv452e_state {
 
 	u8 c;	   /* transaction counter, wraps around...  */
 	u8 initialized; /* set to 1 if 0x15 has been sent */
-	u16 last_rc_key;
+	u64 last_scancode;
 };
 
 static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
@@ -566,15 +566,14 @@ static int pctv452e_rc_query(struct dvb_usb_device *d)
 
 	if ((rx[3] == 9) &&  (rx[12] & 0x01)) {
 		/* got a "press" event */
-		state->last_rc_key = (rx[7] << 8) | rx[6];
+		state->last_scancode = RC_SCANCODE_RC5(rx[7], rx[6]);
 		if (debug > 2)
 			info("%s: cmd=0x%02x sys=0x%02x\n",
 				__func__, rx[6], rx[7]);
-
-		rc_keydown(d->rc_dev, state->last_rc_key, 0);
-	} else if (state->last_rc_key) {
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, state->last_scancode, 0);
+	} else if (state->last_scancode) {
 		rc_keyup(d->rc_dev);
-		state->last_rc_key = 0;
+		state->last_scancode = 0;
 	}
 
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 1abd247..b2749d8 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -639,7 +639,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	int ret, i;
 	struct rtl28xxu_priv *priv = d->priv;
 	u8 buf[5];
-	u32 rc_code;
+	u64 rc_code;
 	struct rtl28xxu_reg_val rc_nec_tab[] = {
 		{ 0x3033, 0x80 },
 		{ 0x3020, 0x43 },
@@ -676,19 +676,22 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		if (buf[2] == (u8) ~buf[3]) {
 			if (buf[0] == (u8) ~buf[1]) {
 				/* NEC standard (16 bit) */
-				rc_code = buf[0] << 8 | buf[2];
+				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
 			} else {
 				/* NEC extended (24 bit) */
-				rc_code = buf[0] << 16 |
-						buf[1] << 8 | buf[2];
+				rc_code = RC_SCANCODE_NECX(buf[0] << 8 |
+							   buf[1],
+							   buf[2]);
 			}
 		} else {
 			/* NEC full (32 bit) */
-			rc_code = buf[0] << 24 | buf[1] << 16 |
-					buf[2] << 8 | buf[3];
+			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 |
+						    buf[1] << 16 |
+						    buf[2] << 8  |
+						    buf[3]);
 		}
 
-		rc_keydown(d->rc_dev, rc_code, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
 		ret = rtl2831_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index c5be462..ad57689 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -440,7 +440,7 @@ static int tt3650_rc_query(struct dvb_usb_device *d)
 		/* got a "press" event */
 		st->last_rc_key = (rx[3] << 8) | rx[2];
 		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
-		rc_keydown(d->rc_dev, st->last_rc_key, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, st->last_rc_key, 0);
 	} else if (st->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		st->last_rc_key = 0;
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 98e5241..2ee6b57 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -161,14 +161,15 @@ static void msp430_ir_interrupt(unsigned long data)
 		return;
 
 	if (budget_ci->ir.full_rc5) {
-		rc_keydown(dev,
-			   budget_ci->ir.rc5_device <<8 | budget_ci->ir.ir_key,
+		rc_keydown(dev, RC_TYPE_RC5,
+			   RC_SCANCODE_RC5(budget_ci->ir.rc5_device,
+					   budget_ci->ir.ir_key),
 			   (command & 0x20) ? 1 : 0);
 		return;
 	}
 
 	/* FIXME: We should generate complete scancodes for all devices */
-	rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
+	rc_keydown(dev, RC_TYPE_UNKNOWN, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index dfeabd7..229f742 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -541,6 +541,7 @@ static void ati_remote_input_report(struct urb *urb)
 		 * set, assume this is a scrollwheel up/down event.
 		 */
 		wheel_keycode = rc_g_keycode_from_table(ati_remote->rdev,
+							RC_TYPE_OTHER,
 							scancode & 0x78);
 
 		if (wheel_keycode == KEY_RESERVED) {
@@ -609,12 +610,12 @@ static void ati_remote_input_report(struct urb *urb)
 
 			while (count--) {
 				/*
-				* We don't use the rc-core repeat handling yet as
-				* it would cause ghost repeats which would be a
-				* regression for this driver.
-				*/
-				rc_keydown_notimeout(ati_remote->rdev, scancode,
-						     data[2]);
+				 * We don't use the rc-core repeat handling yet as
+				 * it would cause ghost repeats which would be a
+				 * regression for this driver.
+				 */
+				rc_keydown_notimeout(ati_remote->rdev, RC_TYPE_OTHER,
+						     scancode, data[2]);
 				rc_keyup(ati_remote->rdev);
 			}
 			return;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 24eb493..d98778b 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1162,14 +1162,15 @@ static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 scancode)
 	bool is_release_code = false;
 
 	/* Look for the initial press of a button */
-	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
 	ictx->rc_toggle = 0x0;
 	ictx->rc_scancode = scancode;
 
 	/* Look for the release of a button */
 	if (keycode == KEY_RESERVED) {
 		release = scancode & ~0x4000;
-		keycode = rc_g_keycode_from_table(ictx->rdev, release);
+		keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type,
+						  release);
 		if (keycode != KEY_RESERVED)
 			is_release_code = true;
 	}
@@ -1198,7 +1199,7 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
 		scancode = scancode | MCE_KEY_MASK | MCE_TOGGLE_BIT;
 
 	ictx->rc_scancode = scancode;
-	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
 
 	/* not used in mce mode, but make sure we know its false */
 	ictx->release_code = false;
@@ -1580,7 +1581,8 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		if (press_type == 0)
 			rc_keyup(ictx->rdev);
 		else {
-			rc_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
+			rc_keydown(ictx->rdev, ictx->rc_type,
+				   ictx->rc_scancode, ictx->rc_toggle);
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 69edffb..30bcf18 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_JVC))
+	if (!(dev->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -140,7 +140,7 @@ again:
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
 			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
-			rc_keydown(dev, scancode, data->toggle);
+			rc_keydown(dev, RC_TYPE_JVC, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 439879c..1490a8b 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_LIRC))
+	if (!(dev->enabled_protocols & RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 33fafa4..9f3c9b5 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_MCE_KBD))
+	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index dc21a67..535e6e2 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_NEC))
+	if (!(dev->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -189,7 +189,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index a820251..6b3c9e5 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -259,7 +259,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	dev->raw->enabled_protocols = ~0;
+	dev->enabled_protocols = ~0;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 5b4d1dd..ddbf9bf 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -51,8 +51,9 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
 	u32 scancode;
+	enum rc_type protocol;
 
-	if (!(dev->raw->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -128,38 +129,30 @@ again:
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!(dev->raw->enabled_protocols & RC_BIT_RC5X)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
 			xdata    = (data->bits & 0x0003F) >> 0;
 			command  = (data->bits & 0x00FC0) >> 6;
 			system   = (data->bits & 0x1F000) >> 12;
 			toggle   = (data->bits & 0x20000) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
-
-			IR_dprintk(1, "RC5X scancode 0x%06x (toggle: %u)\n",
-				   scancode, toggle);
-
+			protocol = RC_TYPE_RC5X;
 		} else {
 			/* RC5 */
 			u8 command, system;
-			if (!(dev->raw->enabled_protocols & RC_BIT_RC5)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
 			command  = (data->bits & 0x0003F) >> 0;
 			system   = (data->bits & 0x007C0) >> 6;
 			toggle   = (data->bits & 0x00800) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 8 | command;
+			protocol = RC_TYPE_RC5;
+		}
 
-			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
+		if (dev->enabled_protocols & (1 << protocol)) {
+			IR_dprintk(1, "RC5(x) scancode 0x%06x (toggle: %u)\n",
 				   scancode, toggle);
+			rc_keydown(dev, protocol, scancode, toggle);
 		}
 
-		rc_keydown(dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index fd807a8..8681b96 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,7 +48,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_RC5_SZ))
+	if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -115,7 +115,7 @@ again:
 		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
 			   scancode, toggle);
 
-		rc_keydown(dev, scancode, toggle);
+		rc_keydown(dev, RC_TYPE_RC5_SZ, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index e19072f..571107e 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -88,8 +88,9 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc6_dec *data = &dev->raw->rc6;
 	u32 scancode;
 	u8 toggle;
+	enum rc_type protocol;
 
-	if (!(dev->raw->enabled_protocols &
+	if (!(dev->enabled_protocols &
 	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
 	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 		return 0;
@@ -231,36 +232,45 @@ again:
 
 		switch (rc6_mode(data)) {
 		case RC6_MODE_0:
+			protocol = RC_TYPE_RC6_0;
 			scancode = data->body;
 			toggle = data->toggle;
-			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
-				   scancode, toggle);
 			break;
-		case RC6_MODE_6A:
-			if (data->count > CHAR_BIT * sizeof data->body) {
-				IR_dprintk(1, "RC6 too many (%u) data bits\n",
-					data->count);
-				goto out;
-			}
 
+		case RC6_MODE_6A:
 			scancode = data->body;
-			if (data->count == RC6_6A_32_NBITS &&
-					(scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
-				/* MCE RC */
-				toggle = (scancode & RC6_6A_MCE_TOGGLE_MASK) ? 1 : 0;
-				scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
-			} else {
-				toggle = 0;
+			toggle = 0;
+			switch (data->count) {
+			case 20:
+				protocol = RC_TYPE_RC6_6A_20;
+				break;
+			case 24:
+				protocol = RC_TYPE_RC6_6A_24;
+				break;
+			case 32:
+				protocol = RC_TYPE_RC6_6A_32;
+				if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
+					/* MCE RC */
+					toggle = (scancode & RC6_6A_MCE_TOGGLE_MASK) ? 1 : 0;
+					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
+					protocol = RC_TYPE_RC6_MCE;
+				}
+				break;
+			default:
+				IR_dprintk(1, "RC6 invalid number of data bits (%u)\n",
+					   data->count);
+				goto out;
 			}
-			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
-				   scancode, toggle);
 			break;
+
 		default:
 			IR_dprintk(1, "RC6 unknown mode\n");
 			goto out;
 		}
 
-		rc_keydown(dev, scancode, toggle);
+		IR_dprintk(1, "RC6(%u), scancode 0x%08x (toggle: %u)\n",
+			   protocol, scancode, toggle);
+		rc_keydown(dev, protocol, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 7e69a3b..a95c869 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_SANYO))
+	if (!(dev->enabled_protocols & RC_BIT_SANYO))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -167,7 +167,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = address << 8 | command;
 		IR_dprintk(1, "SANYO scancode: 0x%06x\n", scancode);
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, RC_TYPE_SANYO, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index fb91434..f360e40 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -44,8 +44,9 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct sony_dec *data = &dev->raw->sony;
 	u32 scancode;
 	u8 device, subdevice, function;
+	enum rc_type protocol;
 
-	if (!(dev->raw->enabled_protocols &
+	if (!(dev->enabled_protocols &
 	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
@@ -124,40 +125,33 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY12)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
+			protocol  = RC_TYPE_SONY12;
 			break;
 		case 15:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY15)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFE);
+			protocol  = RC_TYPE_SONY15;
 			break;
 		case 20:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY20)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
+			protocol  = RC_TYPE_SONY20;
 			break;
 		default:
 			IR_dprintk(1, "Sony invalid bitcount %u\n", data->count);
 			goto out;
 		}
 
-		scancode = device << 16 | subdevice << 8 | function;
-		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
-		rc_keydown(dev, scancode, 0);
+		if (dev->enabled_protocols & (1 << protocol)) {
+			scancode = device << 16 | subdevice << 8 | function;
+			IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
+			rc_keydown(dev, protocol, scancode, 0);
+		}
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 96f0a8b..4de2d47 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -39,7 +39,6 @@ struct ir_raw_event_ctrl {
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-	u64				enabled_protocols; /* enabled raw protocol decoders */
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3455a9e..4adaa87 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -96,7 +96,7 @@ EXPORT_SYMBOL_GPL(rc_map_unregister);
 
 
 static struct rc_map_table empty[] = {
-	{ 0x2a, KEY_COFFEE },
+	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
 };
 
 static struct rc_map_list empty_map = {
@@ -112,7 +112,6 @@ static struct rc_map_list empty_map = {
  * ir_create_table() - initializes a scancode table
  * @rc_map:	the rc_map to initialize
  * @name:	name to assign to the table
- * @rc_type:	ir type to assign to the new table
  * @size:	initial size of the table
  * @return:	zero on success or a negative error code
  *
@@ -120,10 +119,9 @@ static struct rc_map_list empty_map = {
  * memory to hold at least the specified number of elements.
  */
 static int ir_create_table(struct rc_map *rc_map,
-			   const char *name, u64 rc_type, size_t size)
+			   const char *name, size_t size)
 {
 	rc_map->name = name;
-	rc_map->rc_type = rc_type;
 	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
 	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
 	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
@@ -218,16 +216,20 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 
 	/* Did the user wish to remove the mapping? */
 	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
-		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-			   index, rc_map->scan[index].scancode);
+		IR_dprintk(1, "#%d: Deleting proto 0x%04x, scan 0x%08llx\n",
+			   index, rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode);
 		rc_map->len--;
 		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
 			(rc_map->len - index) * sizeof(struct rc_map_table));
 	} else {
-		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
+		IR_dprintk(1, "#%d: %s proto 0x%04x, scan 0x%08llx "
+			   "with key 0x%04x\n",
 			   index,
 			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
-			   rc_map->scan[index].scancode, new_keycode);
+			   rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode,
+			   new_keycode);
 		rc_map->scan[index].keycode = new_keycode;
 		__set_bit(new_keycode, dev->input_dev->keybit);
 	}
@@ -254,9 +256,9 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
  * ir_establish_scancode() - set a keycode in the scancode->keycode table
  * @dev:	the struct rc_dev device descriptor
  * @rc_map:	scancode table to be searched
- * @scancode:	the desired scancode
- * @resize:	controls whether we allowed to resize the table to
- *		accommodate not yet present scancodes
+ * @entry:	the entry to be added to the table
+ * @resize:	controls whether we are allowed to resize the table to
+ *		accomodate not yet present scancodes
  * @return:	index of the mapping containing scancode in question
  *		or -1U in case of failure.
  *
@@ -266,7 +268,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
  */
 static unsigned int ir_establish_scancode(struct rc_dev *dev,
 					  struct rc_map *rc_map,
-					  unsigned int scancode,
+					  struct rc_map_table *entry,
 					  bool resize)
 {
 	unsigned int i;
@@ -280,16 +282,27 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 	 * indicate the valid bits of the scancodes.
 	 */
 	if (dev->scanmask)
-		scancode &= dev->scanmask;
+		entry->scancode &= dev->scanmask;
 
-	/* First check if we already have a mapping for this ir command */
+	/*
+	 * First check if we already have a mapping for this command.
+	 * Note that the keytable is sorted first on protocol and second
+	 * on scancode (lowest to highest).
+	 */
 	for (i = 0; i < rc_map->len; i++) {
-		if (rc_map->scan[i].scancode == scancode)
-			return i;
+		if (rc_map->scan[i].protocol < entry->protocol)
+			continue;
 
-		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_map->scan[i].scancode >= scancode)
+		if (rc_map->scan[i].protocol > entry->protocol)
 			break;
+
+		if (rc_map->scan[i].scancode < entry->scancode)
+			continue;
+
+		if (rc_map->scan[i].scancode > entry->scancode)
+			break;
+
+		return i;
 	}
 
 	/* No previous mapping found, we might need to grow the table */
@@ -302,7 +315,8 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 	if (i < rc_map->len)
 		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
 			(rc_map->len - i) * sizeof(struct rc_map_table));
-	rc_map->scan[i].scancode = scancode;
+	rc_map->scan[i].scancode = entry->scancode;
+	rc_map->scan[i].protocol = entry->protocol;
 	rc_map->scan[i].keycode = KEY_RESERVED;
 	rc_map->len++;
 
@@ -325,10 +339,12 @@ static int ir_setkeycode(struct input_dev *idev,
 	struct rc_dev *rdev = input_get_drvdata(idev);
 	struct rc_map *rc_map = &rdev->rc_map;
 	unsigned int index;
-	unsigned int scancode;
+	struct rc_map_table entry;
 	int retval = 0;
 	unsigned long flags;
 
+	entry.keycode = ke->keycode;
+
 	spin_lock_irqsave(&rc_map->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
@@ -337,19 +353,52 @@ static int ir_setkeycode(struct input_dev *idev,
 			retval = -EINVAL;
 			goto out;
 		}
-	} else {
+	} else if (ke->len == sizeof(int)) {
+		/* Legacy EVIOCSKEYCODE ioctl */
+		u32 scancode;
 		retval = input_scancode_to_scalar(ke, &scancode);
 		if (retval)
 			goto out;
+		entry.scancode = scancode;
+
+		/* Some heuristics to guess the correct protocol */
+		if (hweight64(rdev->enabled_protocols) == 1)
+			entry.protocol = rdev->enabled_protocols;
+		else if (hweight64(rdev->allowed_protos) == 1)
+			entry.protocol = rdev->allowed_protos;
+		else if (rc_map->len > 0)
+			entry.protocol = rc_map->scan[0].protocol;
+		else
+			entry.protocol = RC_TYPE_OTHER;
+
+		index = ir_establish_scancode(rdev, rc_map, &entry, true);
+		if (index >= rc_map->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCSKEYCODE_V2 ioctl */
+		const struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
+		entry.protocol = rke->rc.protocol;
+		entry.scancode = rke->rc.scancode;
 
-		index = ir_establish_scancode(rdev, rc_map, scancode, true);
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_establish_scancode(rdev, rc_map, &entry, true);
 		if (index >= rc_map->len) {
 			retval = -ENOMEM;
 			goto out;
 		}
+	} else {
+		retval = -EINVAL;
+		goto out;
 	}
 
-	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
+	if (retval == 0)
+		*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
 
 out:
 	spin_unlock_irqrestore(&rc_map->lock, flags);
@@ -369,11 +418,11 @@ static int ir_setkeytable(struct rc_dev *dev,
 			  const struct rc_map *from)
 {
 	struct rc_map *rc_map = &dev->rc_map;
+	struct rc_map_table entry;
 	unsigned int i, index;
 	int rc;
 
-	rc = ir_create_table(rc_map, from->name,
-			     from->rc_type, from->size);
+	rc = ir_create_table(rc_map, from->name, from->size);
 	if (rc)
 		return rc;
 
@@ -381,15 +430,15 @@ static int ir_setkeytable(struct rc_dev *dev,
 		   rc_map->size, rc_map->alloc);
 
 	for (i = 0; i < from->size; i++) {
-		index = ir_establish_scancode(dev, rc_map,
-					      from->scan[i].scancode, false);
+		entry.protocol = from->scan[i].protocol;
+		entry.scancode = from->scan[i].scancode;
+		index = ir_establish_scancode(dev, rc_map, &entry, false);
 		if (index >= rc_map->len) {
 			rc = -ENOMEM;
 			break;
 		}
 
-		ir_update_mapping(dev, rc_map, index,
-				  from->scan[i].keycode);
+		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
 	}
 
 	if (rc)
@@ -401,6 +450,7 @@ static int ir_setkeytable(struct rc_dev *dev,
 /**
  * ir_lookup_by_scancode() - locate mapping by scancode
  * @rc_map:	the struct rc_map to search
+ * @protocol:	protocol to look for in the table
  * @scancode:	scancode to look for in the table
  * @return:	index in the table, -1U if not found
  *
@@ -408,17 +458,24 @@ static int ir_setkeytable(struct rc_dev *dev,
  * given scancode.
  */
 static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
-					  unsigned int scancode)
+					  u16 protocol, u64 scancode)
 {
 	int start = 0;
 	int end = rc_map->len - 1;
 	int mid;
+	struct rc_map_table *m;
 
 	while (start <= end) {
 		mid = (start + end) / 2;
-		if (rc_map->scan[mid].scancode < scancode)
+		m = &rc_map->scan[mid];
+
+		if (m->protocol < protocol)
 			start = mid + 1;
-		else if (rc_map->scan[mid].scancode > scancode)
+		else if (m->protocol > protocol)
+			end = mid - 1;
+		else if (m->scancode < scancode)
+			start = mid + 1;
+		else if (m->scancode > scancode)
 			end = mid - 1;
 		else
 			return mid;
@@ -439,33 +496,66 @@ static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 static int ir_getkeycode(struct input_dev *idev,
 			 struct input_keymap_entry *ke)
 {
+	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
 	struct rc_dev *rdev = input_get_drvdata(idev);
 	struct rc_map *rc_map = &rdev->rc_map;
 	struct rc_map_table *entry;
 	unsigned long flags;
 	unsigned int index;
-	unsigned int scancode;
 	int retval;
 
 	spin_lock_irqsave(&rc_map->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
-	} else {
+	} else if (ke->len == sizeof(int)) {
+		/* Legacy EVIOCGKEYCODE ioctl */
+		u32 scancode;
+		u16 protocol;
+
 		retval = input_scancode_to_scalar(ke, &scancode);
 		if (retval)
 			goto out;
 
-		index = ir_lookup_by_scancode(rc_map, scancode);
+		/* Some heuristics to guess the correct protocol */
+		if (hweight64(rdev->enabled_protocols) == 1)
+			protocol = rdev->enabled_protocols;
+		else if (hweight64(rdev->allowed_protos) == 1)
+			protocol = rdev->allowed_protos;
+		else if (rc_map->len > 0)
+			protocol = rc_map->scan[0].protocol;
+		else
+			protocol = RC_TYPE_OTHER;
+
+		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCGKEYCODE_V2 ioctl */
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_lookup_by_scancode(rc_map,
+					      rke->rc.protocol, rke->rc.scancode);
+
+	} else {
+		retval = -EINVAL;
+		goto out;
 	}
 
 	if (index < rc_map->len) {
 		entry = &rc_map->scan[index];
-
 		ke->index = index;
 		ke->keycode = entry->keycode;
-		ke->len = sizeof(entry->scancode);
-		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+		if (ke->len == sizeof(int)) {
+			u32 scancode = entry->scancode;
+			memcpy(ke->scancode, &scancode, sizeof(scancode));
+		} else {
+			ke->len = sizeof(struct rc_scancode);
+			rke->rc.protocol = entry->protocol;
+			rke->rc.scancode = entry->scancode;
+		}
 
 	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
 		/*
@@ -490,6 +580,7 @@ out:
 /**
  * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol to look for
  * @scancode:	the scancode to look for
  * @return:	the corresponding keycode, or KEY_RESERVED
  *
@@ -497,7 +588,8 @@ out:
  * keycode. Normally it should not be used since drivers should have no
  * interest in keycodes.
  */
-u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
+u32 rc_g_keycode_from_table(struct rc_dev *dev,
+			    enum rc_type protocol, u64 scancode)
 {
 	struct rc_map *rc_map = &dev->rc_map;
 	unsigned int keycode;
@@ -506,15 +598,16 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 
 	spin_lock_irqsave(&rc_map->lock, flags);
 
-	index = ir_lookup_by_scancode(rc_map, scancode);
+	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
 	keycode = index < rc_map->len ?
 			rc_map->scan[index].keycode : KEY_RESERVED;
 
 	spin_unlock_irqrestore(&rc_map->lock, flags);
 
 	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->input_name, scancode, keycode);
+		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
+			   dev->input_name, protocol,
+			   (unsigned long long)scancode, keycode);
 
 	return keycode;
 }
@@ -616,6 +709,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 /**
  * ir_do_keydown() - internal function to process a keypress
  * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol of the keypress
  * @scancode:   the scancode of the keypress
  * @keycode:    the keycode of the keypress
  * @toggle:     the toggle value of the keypress
@@ -623,10 +717,11 @@ EXPORT_SYMBOL_GPL(rc_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct rc_dev *dev, int scancode,
-			  u32 keycode, u8 toggle)
+static void ir_do_keydown(struct rc_dev *dev, u16 protocol,
+			  u64 scancode, u32 keycode, u8 toggle)
 {
 	bool new_event = !dev->keypressed ||
+			 dev->last_protocol != protocol ||
 			 dev->last_scancode != scancode ||
 			 dev->last_toggle != toggle;
 
@@ -638,36 +733,39 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
 		dev->keypressed = true;
+		dev->last_protocol = protocol;
 		dev->last_scancode = scancode;
 		dev->last_toggle = toggle;
 		dev->last_keycode = keycode;
 
 		IR_dprintk(1, "%s: key down event, "
-			   "key 0x%04x, scancode 0x%04x\n",
-			   dev->input_name, keycode, scancode);
+			   "key 0x%04x, protocol 0x%04x, scancode 0x%08llx\n",
+			   dev->input_name, keycode, protocol,
+			   (long long unsigned)scancode);
 		input_report_key(dev->input_dev, keycode, 1);
 	}
-
 	input_sync(dev->input_dev);
 }
 
 /**
  * rc_keydown() - generates input event for a key press
  * @dev:	the struct rc_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
+ * @protocol:	the protocol for the keypress
+ * @scancode:   the scancode for the keypress
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
  *
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol,
+		u64 scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
 		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
@@ -681,6 +779,7 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * rc_keydown_notimeout() - generates input event for a key press without
  *                          an automatic keyup event at a later time
  * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol for the keypress
  * @scancode:   the scancode that we're seeking
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
@@ -688,13 +787,14 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * This routine is used to signal that a key has been pressed on the
  * remote control. The driver must manually call rc_keyup() at a later stage.
  */
-void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
+			  u64 scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
@@ -794,13 +894,11 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = dev->rc_map.rc_type;
+	enabled = dev->enabled_protocols;
+	if (dev->driver_type == RC_DRIVER_SCANCODE)
 		allowed = dev->allowed_protos;
-	} else {
-		enabled = dev->raw->enabled_protocols;
+	else
 		allowed = ir_raw_get_allowed_protocols();
-	}
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
@@ -855,7 +953,6 @@ static ssize_t store_protocols(struct device *device,
 	u64 type;
 	u64 mask;
 	int rc, i, count = 0;
-	unsigned long flags;
 	ssize_t ret;
 
 	/* Device is being removed */
@@ -864,16 +961,14 @@ static ssize_t store_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		type = dev->rc_map.rc_type;
-	else if (dev->raw)
-		type = dev->raw->enabled_protocols;
-	else {
+	if (dev->driver_type != RC_DRIVER_SCANCODE && !dev->raw) {
 		IR_dprintk(1, "Protocol switching not supported\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
+	type = dev->enabled_protocols;
+
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
 			break;
@@ -929,13 +1024,7 @@ static ssize_t store_protocols(struct device *device,
 		}
 	}
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&dev->rc_map.lock, flags);
-		dev->rc_map.rc_type = type;
-		spin_unlock_irqrestore(&dev->rc_map.lock, flags);
-	} else {
-		dev->raw->enabled_protocols = type;
-	}
+	dev->enabled_protocols = type;
 
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
@@ -1135,7 +1224,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	if (dev->change_protocol) {
-		rc = dev->change_protocol(dev, rc_map->rc_type);
+		rc = dev->change_protocol(dev, dev->enabled_protocols);
 		if (rc < 0)
 			goto out_raw;
 	}
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index ef4c7cd..210568f 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -73,12 +73,12 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown && (gpio & ir->mask_keydown)) ||
 	    (ir->mask_keyup   && !(gpio & ir->mask_keyup))) {
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 
 		rc_keyup(ir->dev);
 	}
@@ -103,7 +103,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		if (keyup)
 			rc_keyup(ir->dev);
 	} else {
@@ -117,7 +117,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 		if (keyup)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -235,10 +235,9 @@ static void bttv_rc5_timer_end(unsigned long data)
 			u32 toggle = RC5_TOGGLE(rc5);
 			u32 instr = RC5_INSTR(rc5);
 
-			/* Good code */
-			rc_keydown(ir->dev, instr, toggle);
-			dprintk("instruction %x, toggle %x\n",
-				instr, toggle);
+			/* Good code - UNKNOWN, while using legacy code */
+			rc_keydown(ir->dev, RC_TYPE_UNKNOWN, instr, toggle);
+			dprintk("instruction %x, toggle %x\n", instr, toggle);
 		}
 	}
 }
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index f29e18c..b1922f0 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -130,25 +130,27 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		rc_keydown(ir->dev, data, 0);
+		rc_keydown(ir->dev, ir->dev->allowed_protos, data, 0);
 
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, ir->dev->allowed_protos,
+					     data, 0);
 		else
 			rc_keyup(ir->dev);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, ir->dev->allowed_protos,
+					     data, 0);
 		else
 			rc_keyup(ir->dev);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, ir->dev->allowed_protos, data, 0);
 		rc_keyup(ir->dev);
 	}
 }
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 20a7e24..f1b059d 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -756,6 +756,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_TNF_5335MF,
 		.tda9887_conf = TDA9887_PRESENT,
 		.ir_codes     = RC_MAP_GADMEI_RM008Z,
+		.ir_protocol  = RC_BIT_UNKNOWN,
 		.decoder      = EM28XX_SAA711X,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
@@ -993,6 +994,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
 		.ir_codes     = RC_MAP_HAUPPAUGE,
+		.ir_protocol  = RC_BIT_RC5,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1020,6 +1022,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900R2_digital,
 		.ir_codes     = RC_MAP_HAUPPAUGE,
+		.ir_protocol  = RC_BIT_RC5,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1046,6 +1049,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
 		.ir_codes       = RC_MAP_HAUPPAUGE,
+		.ir_protocol    = RC_BIT_RC5,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1072,6 +1076,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
 		.ir_codes       = RC_MAP_HAUPPAUGE,
+		.ir_protocol    = RC_BIT_RC5,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1098,6 +1103,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
 		.ir_codes       = RC_MAP_PINNACLE_PCTV_HD,
+		.ir_protocol    = RC_BIT_UNKNOWN,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1124,6 +1130,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
 		.ir_codes       = RC_MAP_ATI_TV_WONDER_HD_600,
+		.ir_protocol    = RC_BIT_UNKNOWN,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1150,6 +1157,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb        = 1,
 		.dvb_gpio       = default_digital,
 		.ir_codes       = RC_MAP_TERRATEC_CINERGY_XS,
+		.ir_protocol	= RC_BIT_NEC,
 		.xclk           = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1512,6 +1520,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb	= 1,
 		.dvb_gpio	= em2882_kworld_315u_digital,
 		.ir_codes	= RC_MAP_KWORLD_315U,
+		.ir_protocol    = RC_BIT_NEC,
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
 		/* Analog mode - still not ready */
@@ -1643,6 +1652,7 @@ struct em28xx_board em28xx_boards[] = {
 		.dvb_gpio     = kworld_330u_digital,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
 		.ir_codes     = RC_MAP_KWORLD_315U,
+		.ir_protocol  = RC_BIT_NEC,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1666,6 +1676,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
 		.ir_codes     = RC_MAP_TERRATEC_CINERGY_XS,
+		.ir_protocol  = RC_BIT_NEC,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1759,6 +1770,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_TVP5150,
 		.tuner_gpio   = default_tuner_gpio,
 		.ir_codes     = RC_MAP_KAIOMY,
+		.ir_protocol  = RC_BIT_UNKNOWN,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1875,6 +1887,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = evga_indtube_digital,
 		.ir_codes     = RC_MAP_EVGA_INDTUBE,
+		.ir_protocol  = RC_BIT_UNKNOWN,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -2663,7 +2676,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 	return -1;
 }
 
-static void em28xx_card_setup(struct em28xx *dev)
+void em28xx_card_setup(struct em28xx *dev)
 {
 	/*
 	 * If the device can be a webcam, seek for a sensor.
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 55808a9..a8c67d8 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -70,7 +70,6 @@ struct em28xx_IR {
 	/* poll external decoder */
 	int polling;
 	struct delayed_work work;
-	unsigned int full_code:1;
 	unsigned int last_readcount;
 
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
@@ -297,15 +296,25 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 		dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
 			poll_result.toggle_bit, poll_result.read_count,
 			poll_result.rc_address, poll_result.rc_data[0]);
-		if (ir->full_code)
-			rc_keydown(ir->rc,
-				   poll_result.rc_address << 8 |
-				   poll_result.rc_data[0],
+		switch (ir->rc->enabled_protocols) {
+		case RC_BIT_RC5:
+			rc_keydown(ir->rc, RC_TYPE_RC5,
+				   RC_SCANCODE_RC5(poll_result.rc_address,
+						   poll_result.rc_data[0]),
 				   poll_result.toggle_bit);
-		else
-			rc_keydown(ir->rc,
+			break;
+		case RC_BIT_NEC:
+			rc_keydown(ir->rc, RC_TYPE_NEC,
+				   RC_SCANCODE_NEC(poll_result.rc_address,
+						   poll_result.rc_data[0]),
+				   poll_result.toggle_bit);
+			break;
+		default:
+			rc_keydown(ir->rc, RC_TYPE_UNKNOWN,
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
+			break;
+		}
 
 		if (ir->dev->chip_id == CHIP_ID_EM2874 ||
 		    ir->dev->chip_id == CHIP_ID_EM2884)
@@ -354,13 +363,11 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 
 	/* Adjust xclk based o IR table for RC5/NEC tables */
 
-	if (rc_type == RC_BIT_RC5) {
+	if (rc_type == RC_BIT_RC5)
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
-		ir->full_code = 1;
-	} else if (rc_type == RC_BIT_NEC) {
+	else if (rc_type == RC_BIT_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC;
-		ir->full_code = 1;
 	} else if (rc_type != RC_BIT_UNKNOWN)
 		rc = -EINVAL;
 
@@ -550,8 +557,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
-	/* By default, keep protocol field untouched */
-	err = em28xx_ir_change_protocol(rc, RC_BIT_UNKNOWN);
+	/* Set default protocol */
+	rc->enabled_protocols = dev->board.ir_protocol;
+	err = em28xx_ir_change_protocol(rc, dev->board.ir_protocol);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 8757523..745a24c 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -413,6 +413,7 @@ struct em28xx_board {
 	struct em28xx_input       input[MAX_EM28XX_INPUT];
 	struct em28xx_input	  radio;
 	char			  *ir_codes;
+	u64			  ir_protocol; /* default protocol */
 };
 
 struct em28xx_eeprom {
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 08ae067..86c53fa 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -108,7 +108,7 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 		start, range, toggle, dev, code);
 
 	/* return key */
-	*ir_key = (dev << 8) | code;
+	*ir_key = RC_SCANCODE_RC5(dev, code);
 	*ir_raw = ircode;
 	return 1;
 }
@@ -258,7 +258,14 @@ static int ir_key_poll(struct IR_i2c *ir)
 
 	if (rc) {
 		dprintk(1, "%s: keycode = 0x%04x\n", __func__, ir_key);
-		rc_keydown(ir->rc, ir_key, 0);
+		switch (ir->rc->enabled_protocols) {
+		case RC_BIT_RC5:
+			rc_keydown(ir->rc, RC_TYPE_RC5, ir_key, 0);
+			break;
+		default:
+			rc_keydown(ir->rc, RC_TYPE_UNKNOWN, ir_key, 0);
+			break;
+		}
 	}
 	return 0;
 }
@@ -423,6 +430,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	rc->map_name       = ir->ir_codes;
 	rc->allowed_protos = rc_type;
+	rc->enabled_protocols = rc_type;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 6ad49c6..6b5fc7f 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -83,14 +83,14 @@ static int build_key(struct saa7134_dev *dev)
 		if (data == ir->mask_keycode)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		} else {
 			rc_keyup(ir->dev);
 		}
@@ -98,7 +98,7 @@ static int build_key(struct saa7134_dev *dev)
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 			rc_keyup(ir->dev);
 		}
 	}
diff --git a/drivers/media/video/tm6000/tm6000-cards.c b/drivers/media/video/tm6000/tm6000-cards.c
index 034659b..e45c047 100644
--- a/drivers/media/video/tm6000/tm6000-cards.c
+++ b/drivers/media/video/tm6000/tm6000-cards.c
@@ -85,6 +85,7 @@ struct tm6000_board {
 	struct tm6000_input	rinput;
 
 	char		*ir_codes;
+	u64		ir_protocol;
 };
 
 static struct tm6000_board tm6000_boards[] = {
@@ -481,6 +482,7 @@ static struct tm6000_board tm6000_boards[] = {
 			.ir		= TM6010_GPIO_0,
 		},
 		.ir_codes = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+		.ir_protocol = RC_BIT_UNKNOWN,
 		.vinput = { {
 			.type	= TM6000_INPUT_TV,
 			.vmux	= TM6000_VMUX_VIDEO_B,
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 8ce028f..6fc0a71 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -51,10 +51,6 @@ MODULE_PARM_DESC(enable_ir, "ir clock, in MHz");
 		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
 	} while (0)
 
-struct tm6000_ir_poll_result {
-	u16 rc_data;
-};
-
 struct tm6000_IR {
 	struct tm6000_core	*dev;
 	struct rc_dev		*rc;
@@ -162,12 +158,43 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	return 0;
 }
 
+static void tm6000_ir_keydown(struct tm6000_IR *ir,
+			      const char *buf, unsigned int len)
+{
+	u8 device, command;
+	u64 scancode;
+	enum rc_type protocol;
+
+	if (len < 1)
+		return;
+
+	command = buf[0];
+	device = (len > 1 ? buf[1] : 0x0);
+	switch (ir->rc_type) {
+	case RC_BIT_RC5:
+		protocol = RC_TYPE_RC5;
+		scancode = RC_SCANCODE_RC5(device, command);
+		break;
+	case RC_BIT_NEC:
+		protocol = RC_TYPE_NEC;
+		scancode = RC_SCANCODE_NEC(device, command);
+		break;
+	default:
+		protocol = RC_TYPE_OTHER;
+		scancode = RC_SCANCODE_OTHER(device << 8 | command);
+		break;
+	}
+
+	dprintk(1, "%s, protocol: 0x%04x, scancode: 0x%08llx\n",
+		__func__, protocol, (unsigned long long)scancode);
+	rc_keydown(ir->rc, protocol, scancode, 0);
+}
+
 static void tm6000_ir_urb_received(struct urb *urb)
 {
 	struct tm6000_core *dev = urb->context;
 	struct tm6000_IR *ir = dev->ir;
-	struct tm6000_ir_poll_result poll_result;
-	char *buf;
+	int rc;
 
 	dprintk(2, "%s\n",__func__);
 	if (urb->status < 0 || urb->actual_length <= 0) {
@@ -177,19 +204,14 @@ static void tm6000_ir_urb_received(struct urb *urb)
 		schedule_delayed_work(&ir->work, msecs_to_jiffies(URB_SUBMIT_DELAY));
 		return;
 	}
-	buf = urb->transfer_buffer;
 
 	if (ir_debug)
 		print_hex_dump(KERN_DEBUG, "tm6000: IR data: ",
 			       DUMP_PREFIX_OFFSET,16, 1,
-			       buf, urb->actual_length, false);
-
-	poll_result.rc_data = buf[0];
-	if (urb->actual_length > 1)
-		poll_result.rc_data |= buf[1] << 8;
+			       urb->transfer_buffer, urb->actual_length,
+			       false);
 
-	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
-	rc_keydown(ir->rc, poll_result.rc_data, 0);
+	tm6000_ir_keydown(ir, urb->transfer_buffer, urb->actual_length);
 
 	usb_submit_urb(urb, GFP_ATOMIC);
 	/*
@@ -204,7 +226,6 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 {
 	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
 	struct tm6000_core *dev = ir->dev;
-	struct tm6000_ir_poll_result poll_result;
 	int rc;
 	u8 buf[2];
 
@@ -219,13 +240,8 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 	if (rc < 0)
 		return;
 
-	if (rc > 1)
-		poll_result.rc_data = buf[0] | buf[1] << 8;
-	else
-		poll_result.rc_data = buf[0];
-
 	/* Check if something was read */
-	if ((poll_result.rc_data & 0xff) == 0xff) {
+	if ((buf[0] & 0xff) == 0xff) {
 		if (!ir->pwled) {
 			tm6000_flash_led(dev, 1);
 			ir->pwled = 1;
@@ -233,8 +249,7 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 		return;
 	}
 
-	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
-	rc_keydown(ir->rc, poll_result.rc_data, 0);
+	tm6000_ir_keydown(ir, buf, rc);
 	tm6000_flash_led(dev, 0);
 	ir->pwled = 0;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 58f12da..0045292 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -34,6 +34,24 @@ enum rc_driver_type {
 	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
 };
 
+/* This is used for the input EVIOC[SG]KEYCODE_V2 ioctls */
+struct rc_scancode {
+	__u16 protocol;
+	__u16 reserved[3];
+	__u64 scancode;
+};
+
+struct rc_keymap_entry {
+	__u8  flags;
+	__u8  len;
+	__u16 index;
+	__u32 keycode;
+	union {
+		struct rc_scancode rc;
+		__u8 raw[32];
+	};
+};
+
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
@@ -99,6 +117,7 @@ struct rc_dev {
 	enum rc_driver_type		driver_type;
 	bool				idle;
 	u64				allowed_protos;
+	u64				enabled_protocols;
 	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;
@@ -106,7 +125,8 @@ struct rc_dev {
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
 	u32				last_keycode;
-	u32				last_scancode;
+	enum rc_type			last_protocol;
+	u64				last_scancode;
 	u8				last_toggle;
 	u32				timeout;
 	u32				min_timeout;
@@ -141,10 +161,10 @@ int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
 void rc_keyup(struct rc_dev *dev);
-u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
+u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
 
 /*
  * From rc-raw.c
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 909c2ed..48af876 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -60,9 +60,20 @@ enum rc_type {
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)
 
+#define RC_SCANCODE_UNKNOWN(x) (x)
+#define RC_SCANCODE_OTHER(x) (x)
+#define RC_SCANCODE_NEC(addr, cmd) (((addr) << 8) | (cmd))
+#define RC_SCANCODE_NECX(addr, cmd) (((addr) << 8) | (cmd))
+#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
+#define RC_SCANCODE_RC5(sys, cmd) (((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC5_SZ(sys, cmd) (((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC6_0(sys, cmd) (((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC6_6A(vendor, sys, cmd) (((vendor) << 16) | ((sys) << 8) | (cmd))
+
 struct rc_map_table {
-	u32	scancode;
-	u32	keycode;
+	u64		scancode;
+	u32		keycode;
+	enum rc_type	protocol;
 };
 
 struct rc_map {
@@ -70,7 +81,7 @@ struct rc_map {
 	unsigned int		size;	/* Max number of entries */
 	unsigned int		len;	/* Used number of entries */
 	unsigned int		alloc;	/* Size of *scan in bytes */
-	enum rc_type		rc_type;
+	enum rc_type		rc_type; /* For in-kernel keymaps */
 	const char		*name;
 	spinlock_t		lock;
 };

