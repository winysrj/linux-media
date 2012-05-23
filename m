Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44285 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301Ab2EWJyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:55 -0400
Subject: [PATCH 24/43] rc-core: leave the internals of rc_dev alone
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:06 +0200
Message-ID: <20120523094406.14474.46093.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
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
	parts shouldn't affect funcationality

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ati_remote.c               |    3 ---
 drivers/media/rc/ir-nec-decoder.c           |   10 +++-------
 drivers/media/rc/ir-raw.c                   |    4 +---
 drivers/media/rc/ir-sanyo-decoder.c         |   10 +++-------
 drivers/media/video/cx231xx/cx231xx-input.c |    7 +++----
 drivers/media/video/tm6000/tm6000-input.c   |    4 ----
 6 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 229f742..f10af75 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -918,9 +918,6 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	if (err)
 		goto fail3;
 
-	/* use our delay for rc_dev */
-	ati_remote->rdev->input_dev->rep[REP_DELAY] = repeat_delay;
-
 	/* Set up and register mouse input device */
 	if (mouse) {
 		input_dev = input_allocate_device();
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 1033f30..c92b229 100644
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
index 7729abe..6ef1510 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -114,20 +114,18 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
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
index a95c869..17ee339 100644
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
 
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 0f7b424..25385d9 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -30,9 +30,9 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 	int	rc;
 	u8	cmd, scancode;
 
-	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
+	dev_dbg(&ir->rc->dev, "cmd %02x, scan = %02x\n", cmd, scancode);
 
-		/* poll IR chip */
+	/* poll IR chip */
 	rc = i2c_master_recv(ir->c, &cmd, 1);
 	if (rc < 0)
 		return rc;
@@ -56,8 +56,7 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 		 ((cmd & 0x40) ? 0x02 : 0) |
 		 ((cmd & 0x80) ? 0x01 : 0);
 
-	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
-		cmd, scancode);
+	dev_dbg(&ir->rc->dev, "cmd %02x, scan = %02x\n", cmd, scancode);
 
 	*ir_key = scancode;
 	*ir_raw = scancode;
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 6fc0a71..4f6995f 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -63,7 +63,6 @@ struct tm6000_IR {
 	u8			wait:1;
 	u8			pwled:2;
 	u8			submit_urb:1;
-	u16			key_addr;
 	struct urb		*int_urb;
 
 	/* IR device properties */
@@ -321,9 +320,6 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 
 	dprintk(2, "%s\n",__func__);
 
-	if ((rc->rc_map.scan) && (rc_type == RC_BIT_NEC))
-		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
-
 	ir->rc_type = rc_type;
 
 	tm6000_ir_config(ir);

