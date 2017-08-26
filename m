Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41503 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751925AbdHZIbX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:31:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] media: rc: use ktime accessor functions
Date: Sat, 26 Aug 2017 09:31:20 +0100
Message-Id: <20170826083122.25812-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Prefer using accessor functions so we are not dependent on the ktime_t
type.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index f495709e28fb..503bc425a187 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -106,7 +106,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 		return -EINVAL;
 
 	now = ktime_get();
-	ev.duration = ktime_sub(now, dev->raw->last_event);
+	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
 	ev.pulse = !pulse;
 
 	rc = ir_raw_event_store(dev, &ev);
@@ -474,18 +474,19 @@ EXPORT_SYMBOL(ir_raw_encode_scancode);
 static void edge_handle(unsigned long arg)
 {
 	struct rc_dev *dev = (struct rc_dev *)arg;
-	ktime_t interval = ktime_get() - dev->raw->last_event;
+	ktime_t interval = ktime_sub(ktime_get(), dev->raw->last_event);
 
-	if (interval >= dev->timeout) {
+	if (ktime_to_ns(interval) >= dev->timeout) {
 		DEFINE_IR_RAW_EVENT(ev);
 
 		ev.timeout = true;
-		ev.duration = interval;
+		ev.duration = ktime_to_ns(interval);
 
 		ir_raw_event_store(dev, &ev);
 	} else {
 		mod_timer(&dev->raw->edge_handle,
-			  jiffies + nsecs_to_jiffies(dev->timeout - interval));
+			  jiffies + nsecs_to_jiffies(dev->timeout -
+						     ktime_to_ns(interval)));
 	}
 
 	ir_raw_event_handle(dev);
-- 
2.13.5
