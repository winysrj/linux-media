Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47711 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbeELKzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 06:55:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] media: rc: drivers should produce alternate pulse and space timing events
Date: Sat, 12 May 2018 11:55:29 +0100
Message-Id: <20180512105531.30482-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report an error if this is not the case or any problem with the generated
raw events.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 2e50104ae138..49c56da9bc67 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -22,16 +22,27 @@ static int ir_raw_event_thread(void *data)
 {
 	struct ir_raw_event ev;
 	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+	struct ir_raw_event_ctrl *raw = data;
+	struct rc_dev *dev = raw->dev;
 
 	while (1) {
 		mutex_lock(&ir_raw_handler_lock);
 		while (kfifo_out(&raw->kfifo, &ev, 1)) {
+			if (is_timing_event(ev)) {
+				if (ev.duration == 0)
+					dev_err(&dev->dev, "nonsensical timing event of duration 0");
+				if (is_timing_event(raw->prev_ev) &&
+				    !is_transition(&ev, &raw->prev_ev))
+					dev_err(&dev->dev, "two consecutive events of type %s",
+						TO_STR(ev.pulse));
+				if (raw->prev_ev.reset && ev.pulse == 0)
+					dev_err(&dev->dev, "timing event after reset should be pulse");
+			}
 			list_for_each_entry(handler, &ir_raw_handler_list, list)
-				if (raw->dev->enabled_protocols &
+				if (dev->enabled_protocols &
 				    handler->protocols || !handler->protocols)
-					handler->decode(raw->dev, ev);
-			ir_lirc_raw_event(raw->dev, ev);
+					handler->decode(dev, ev);
+			ir_lirc_raw_event(dev, ev);
 			raw->prev_ev = ev;
 		}
 		mutex_unlock(&ir_raw_handler_lock);
-- 
2.17.0
