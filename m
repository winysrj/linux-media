Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35643 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbeDUJt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 05:49:58 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: rc: only register protocol for rc device if enabled
Date: Sat, 21 Apr 2018 10:49:56 +0100
Message-Id: <20180421094957.25387-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The raw_register function exists to create input devices associated with
that IR protocol.

If the mce_kbd module is loaded, then every rc device will have mce_kbd
input devices, even if the protocol is not enabled. Change this to call
the register function to when the protocol is enabled.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index cac015df4b2f..26ec296263a7 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -236,6 +236,19 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_proto)
 	struct ir_raw_handler *handler;
 	u32 timeout = 0;
 
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (!(dev->enabled_protocols & handler->protocols) &&
+		    (*rc_proto & handler->protocols) && handler->raw_register)
+			handler->raw_register(dev);
+
+		if ((dev->enabled_protocols & handler->protocols) &&
+		    !(*rc_proto & handler->protocols) &&
+		    handler->raw_unregister)
+			handler->raw_unregister(dev);
+	}
+	mutex_unlock(&ir_raw_handler_lock);
+
 	if (!dev->max_timeout)
 		return 0;
 
@@ -607,7 +620,6 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 
 int ir_raw_event_register(struct rc_dev *dev)
 {
-	struct ir_raw_handler *handler;
 	struct task_struct *thread;
 
 	thread = kthread_run(ir_raw_event_thread, dev->raw, "rc%u", dev->minor);
@@ -618,9 +630,6 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&dev->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_register)
-			handler->raw_register(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -648,7 +657,8 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&dev->raw->list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_unregister)
+		if (handler->raw_unregister &&
+		    (handler->protocols & dev->enabled_protocols))
 			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
@@ -661,13 +671,8 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 {
-	struct ir_raw_event_ctrl *raw;
-
 	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->dev);
 	atomic64_or(ir_raw_handler->protocols, &available_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
 
@@ -683,9 +688,10 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir_raw_handler->list);
 	list_for_each_entry(raw, &ir_raw_client_list, list) {
-		ir_raw_disable_protocols(raw->dev, protocols);
-		if (ir_raw_handler->raw_unregister)
+		if (ir_raw_handler->raw_unregister &&
+		    (raw->dev->enabled_protocols & protocols))
 			ir_raw_handler->raw_unregister(raw->dev);
+		ir_raw_disable_protocols(raw->dev, protocols);
 	}
 	atomic64_andnot(protocols, &available_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
-- 
2.14.3
