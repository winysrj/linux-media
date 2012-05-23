Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44266 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab2EWJyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:49 -0400
Subject: [PATCH 35/43] rc-ir-raw: atomic reads of protocols
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:04 +0200
Message-ID: <20120523094504.14474.54852.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use atomic reads to avoid having to take a mutex when getting
the bitmask of supported protocols.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    2 +-
 drivers/media/rc/rc-ir-raw.c    |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b0e1686..54af19a 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -25,7 +25,7 @@
 struct ir_raw_handler {
 	struct list_head list;
 
-	u64 protocols; /* which are handled by this handler */
+	unsigned protocols; /* which are handled by this handler */
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
 
 	/* These two should only be used by the lirc decoder */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 42769b4..88a2932 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -29,7 +29,7 @@ static LIST_HEAD(ir_raw_client_list);
 static LIST_HEAD(ir_raw_handler_list);
 
 /* protocols supported by the currently loaded decoders */
-static u64 available_protocols;
+static atomic_t available_protocols = ATOMIC_INIT(0);
 
 static int ir_raw_event_thread(void *data)
 {
@@ -211,11 +211,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 static u64
 ir_raw_get_allowed_protocols(struct rc_dev *dev)
 {
-	u64 protocols;
-	mutex_lock(&ir_raw_mutex);
-	protocols = available_protocols;
-	mutex_unlock(&ir_raw_mutex);
-	return protocols;
+	return atomic_read(&available_protocols);
 }
 
 /*
@@ -305,7 +301,7 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
-	available_protocols |= ir_raw_handler->protocols;
+	atomic_set_mask(ir_raw_handler->protocols, &available_protocols);
 	mutex_unlock(&ir_raw_mutex);
 	synchronize_rcu();
 
@@ -322,7 +318,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	if (ir_raw_handler->raw_unregister)
 		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->dev);
-	available_protocols &= ~ir_raw_handler->protocols;
+	atomic_clear_mask(ir_raw_handler->protocols, &available_protocols);
 	mutex_unlock(&ir_raw_mutex);
 	synchronize_rcu();
 }

