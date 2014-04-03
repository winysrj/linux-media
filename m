Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40323 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaDCXdt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:49 -0400
Subject: [PATCH 30/49] rc-core: leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:47 +0200
Message-ID: <20140403233347.27099.542.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several drivers poke around in the internals of rc_dev, try to
fix them up in preparation for the next round of patches.

drivers/media/rc/ati_remote.c:
	Removing the REP_DELAY setting on the input device should not
	change how to driver works (as it does a keydown/keyup and has
	no real repeat handling).

drivers/media/rc/img-ir/img-ir-hw.c
	Changing the protocol does not imply that the keymap changes.

drivers/media/rc/ir-nec-decoder.c
	Obvious fix, leave repeat handling to rc-core

drivers/media/rc/ir-raw.c
	Replaced the REP_DELAY value with a static value, which makes more
	sense anyway. Why should the time before automatic repeat handling
	kicks in define the drivers idea of "a long time"?

drivers/media/rc/ir-sanyo-decoder.c
	Obvious fix, leave repeat handling to rc-core

drivers/media/video/cx231xx/cx231xx-input.c
	Just some debug statements to change

drivers/media/video/tm6000/tm6000-input.c
	Not sure what the driver is trying to do, however, IR
	handling seems incomplete ATM so deleting the offending
	parts shouldn't affect functionality

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ati_remote.c             |    3 ---
 drivers/media/rc/img-ir/img-ir-hw.c       |    4 ----
 drivers/media/rc/ir-nec-decoder.c         |   10 +++-------
 drivers/media/rc/ir-raw.c                 |    4 +---
 drivers/media/rc/ir-sanyo-decoder.c       |   10 +++-------
 drivers/media/usb/cx231xx/cx231xx-input.c |    5 ++---
 drivers/media/usb/tm6000/tm6000-input.c   |    4 ----
 7 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 3ada4dc..6ef5716 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -932,9 +932,6 @@ static int ati_remote_probe(struct usb_interface *interface,
 	if (err)
 		goto exit_kill_urbs;
 
-	/* use our delay for rc_dev */
-	ati_remote->rdev->input_dev->rep[REP_DELAY] = repeat_delay;
-
 	/* Set up and register mouse input device */
 	if (mouse) {
 		input_dev = input_allocate_device();
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 9fc41780..3bb6a32 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -666,10 +666,6 @@ static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
 {
 	struct rc_dev *rdev = priv->hw.rdev;
 
-	spin_lock_irq(&rdev->rc_map.lock);
-	rdev->rc_map.rc_type = __ffs64(proto);
-	spin_unlock_irq(&rdev->rc_map.lock);
-
 	mutex_lock(&rdev->lock);
 	rdev->enabled_protocols = proto;
 	rdev->allowed_wakeup_protocols = proto;
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 1683aaa..861fd86 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -89,13 +89,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "Repeat last key\n");
-				data->state = STATE_TRAILER_PULSE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "Repeat last key\n");
+			data->state = STATE_TRAILER_PULSE;
 			return 0;
 		}
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index af23f4d..aa2503d 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -109,20 +109,18 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	s64			delta; /* ns */
 	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
-	int			delay;
 
 	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
-	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
 
 	/* Check for a long duration since last event or if we're
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	if (delta > delay || !dev->raw->last_type)
+	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
 		ev.duration = delta;
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index ad1dc6a..9f97648 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -112,13 +112,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "SANYO discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "SANYO repeat last key\n");
-				data->state = STATE_INACTIVE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "SANYO repeat last key\n");
+			data->state = STATE_INACTIVE;
 			return 0;
 		}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 05f0434..5480fb1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -31,7 +31,7 @@ static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
 	int	rc;
 	u8	cmd, scancode;
 
-	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
+	dev_dbg(&ir->rc->dev, "%s\n", __func__);
 
 		/* poll IR chip */
 	rc = i2c_master_recv(ir->c, &cmd, 1);
@@ -49,8 +49,7 @@ static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
 
 	scancode = bitrev8(cmd);
 
-	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
-		cmd, scancode);
+	dev_dbg(&ir->rc->dev, "cmd %02x, scan = %02x\n", cmd, scancode);
 
 	*protocol = RC_TYPE_OTHER;
 	*pscancode = scancode;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 26b2ebb..7c9b58d 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -67,7 +67,6 @@ struct tm6000_IR {
 	u8			wait:1;
 	u8			pwled:2;
 	u8			submit_urb:1;
-	u16			key_addr;
 	struct urb		*int_urb;
 
 	/* IR device properties */
@@ -325,9 +324,6 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 
 	dprintk(2, "%s\n",__func__);
 
-	if ((rc->rc_map.scan) && (*rc_type == RC_BIT_NEC))
-		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
-
 	ir->rc_type = *rc_type;
 
 	tm6000_ir_config(ir);

