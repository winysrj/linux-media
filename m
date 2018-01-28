Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53649 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbeA1SAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Jan 2018 13:00:37 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: prev_ev is dead code, every call is a new edge
Date: Sun, 28 Jan 2018 18:00:35 +0000
Message-Id: <20180128180035.20879-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The raw kfifo should never contain successive pulse events or space
events. If it did occur, The IR decoders would not be able to deal
with this anyway. There is no need to check that a raw timing event
is a transition: it always is.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 6 ------
 drivers/media/rc/ir-rc5-decoder.c     | 3 ---
 drivers/media/rc/ir-rc6-decoder.c     | 9 +--------
 drivers/media/rc/rc-core-priv.h       | 6 ------
 drivers/media/rc/rc-ir-raw.c          | 1 -
 5 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 2c3df02e05ff..fb318bdd6193 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -262,9 +262,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_HEADER_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		decrease_duration(&ev, MCIR2_BIT_END);
 
 		if (data->count != MCIR2_HEADER_NBITS) {
@@ -301,9 +298,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_BODY_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == data->wanted_bits)
 			data->state = STATE_FINISHED;
 		else
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 11a28f8772da..dd41d389f8d2 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -88,9 +88,6 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == CHECK_RC5X_NBITS)
 			data->state = STATE_CHECK_RC5X;
 		else
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 55bb19bbd4e9..3e3659c0875c 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -145,9 +145,6 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_HEADER_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == RC6_HEADER_NBITS)
 			data->state = STATE_TOGGLE_START;
 		else
@@ -165,8 +162,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_TOGGLE_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev) ||
-		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
+		if (!geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
 			break;
 
 		if (!(data->header & RC6_STARTBIT_MASK)) {
@@ -210,9 +206,6 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		break;
 
 	case STATE_BODY_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == data->wanted_bits)
 			data->state = STATE_FINISHED;
 		else
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 458e9eb2d6a9..96a941aa2581 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -54,7 +54,6 @@ struct ir_raw_event_ctrl {
 	struct timer_list edge_handle;
 
 	/* raw decoder state follows */
-	struct ir_raw_event prev_ev;
 	struct ir_raw_event this_ev;
 	struct nec_dec {
 		int state;
@@ -130,11 +129,6 @@ static inline bool eq_margin(unsigned d1, unsigned d2, unsigned margin)
 	return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
 }
 
-static inline bool is_transition(struct ir_raw_event *x, struct ir_raw_event *y)
-{
-	return x->pulse != y->pulse;
-}
-
 static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
 {
 	if (duration > ev->duration)
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 18504870b9f0..ea96df49f176 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -32,7 +32,6 @@ static int ir_raw_event_thread(void *data)
 				    handler->protocols || !handler->protocols)
 					handler->decode(raw->dev, ev);
 			ir_lirc_raw_event(raw->dev, ev);
-			raw->prev_ev = ev;
 		}
 		mutex_unlock(&ir_raw_handler_lock);
 
-- 
2.14.3
