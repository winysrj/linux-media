Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51529 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbeELKzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 06:55:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] media: rc: decoders do not need to check for transitions
Date: Sat, 12 May 2018 11:55:30 +0100
Message-Id: <20180512105531.30482-2-sean@mess.org>
In-Reply-To: <20180512105531.30482-1-sean@mess.org>
References: <20180512105531.30482-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers should never produce consecutive pulse or space raw events. Should
that occur, we would have bigger problems than this code is trying to
guard against.

Note that we already log an error should a driver misbehave.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c |  6 ------
 drivers/media/rc/ir-rc5-decoder.c     |  3 ---
 drivers/media/rc/ir-rc6-decoder.c     | 10 ----------
 3 files changed, 19 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 9574c3dd90f2..64ea42927669 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -274,9 +274,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_HEADER_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		decrease_duration(&ev, MCIR2_BIT_END);
 
 		if (data->count != MCIR2_HEADER_NBITS) {
@@ -313,9 +310,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_BODY_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == data->wanted_bits)
 			data->state = STATE_FINISHED;
 		else
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index cbfaadbee8fa..63624654a71e 100644
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
index 66e07109f6fc..68487ce9f79b 100644
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
@@ -165,10 +162,6 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 
 	case STATE_TOGGLE_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev) ||
-		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
-			break;
-
 		if (!(data->header & RC6_STARTBIT_MASK)) {
 			dev_dbg(&dev->dev, "RC6 invalid start bit\n");
 			break;
@@ -210,9 +203,6 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		break;
 
 	case STATE_BODY_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
 		if (data->count == data->wanted_bits)
 			data->state = STATE_FINISHED;
 		else
-- 
2.17.0
