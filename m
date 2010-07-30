Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab0G3LjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:06 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 03/13] IR: replace spinlock with mutex.
Date: Fri, 30 Jul 2010 14:38:43 +0300
Message-Id: <1280489933-20865-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some handlers (lirc for example) allocates memory on initialization,
doing so in atomic context is cumbersome.
Fixes warning about sleeping function in atomic context.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-raw-event.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 51f65da..9d5c029 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/workqueue.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/sched.h>
 #include "ir-core-priv.h"
 
@@ -24,7 +24,7 @@
 static LIST_HEAD(ir_raw_client_list);
 
 /* Used to handle IR raw handler extensions */
-static DEFINE_SPINLOCK(ir_raw_handler_lock);
+static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static u64 available_protocols;
 
@@ -41,10 +41,10 @@ static void ir_raw_event_work(struct work_struct *work)
 		container_of(work, struct ir_raw_event_ctrl, rx_work);
 
 	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
-		spin_lock(&ir_raw_handler_lock);
+		mutex_lock(&ir_raw_handler_lock);
 		list_for_each_entry(handler, &ir_raw_handler_list, list)
 			handler->decode(raw->input_dev, ev);
-		spin_unlock(&ir_raw_handler_lock);
+		mutex_unlock(&ir_raw_handler_lock);
 		raw->prev_ev = ev;
 	}
 }
@@ -150,9 +150,9 @@ u64
 ir_raw_get_allowed_protocols()
 {
 	u64 protocols;
-	spin_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_handler_lock);
 	protocols = available_protocols;
-	spin_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_handler_lock);
 	return protocols;
 }
 
@@ -180,12 +180,12 @@ int ir_raw_event_register(struct input_dev *input_dev)
 		return rc;
 	}
 
-	spin_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&ir->raw->list, &ir_raw_client_list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_register)
 			handler->raw_register(ir->raw->input_dev);
-	spin_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
 }
@@ -200,12 +200,12 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 
 	cancel_work_sync(&ir->raw->rx_work);
 
-	spin_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir->raw->list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
 			handler->raw_unregister(ir->raw->input_dev);
-	spin_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_handler_lock);
 
 	kfifo_free(&ir->raw->kfifo);
 	kfree(ir->raw);
@@ -220,13 +220,13 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 {
 	struct ir_raw_event_ctrl *raw;
 
-	spin_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->input_dev);
 	available_protocols |= ir_raw_handler->protocols;
-	spin_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
 }
@@ -236,13 +236,13 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 {
 	struct ir_raw_event_ctrl *raw;
 
-	spin_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir_raw_handler->list);
 	if (ir_raw_handler->raw_unregister)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->input_dev);
 	available_protocols &= ~ir_raw_handler->protocols;
-	spin_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
 
-- 
1.7.0.4

