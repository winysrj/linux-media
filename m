Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52574 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbbGTTRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:17:04 -0400
Subject: [PATCH 7/7] [PATCH FIXES] Revert "[media] rc: rc-ir-raw: Add
 scancode encoder callback"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:17:01 +0200
Message-ID: <20150720191701.24633.44979.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 9869da5bacc5c9b865a183bd36c04be76cdd325d.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    2 --
 drivers/media/rc/rc-ir-raw.c    |   37 -------------------------------------
 include/media/rc-core.h         |    3 ---
 3 files changed, 42 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 122c25f..b68d4f76 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -25,8 +25,6 @@ struct ir_raw_handler {
 
 	u64 protocols; /* which are handled by this handler */
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
-	int (*encode)(u64 protocols, const struct rc_scancode_filter *scancode,
-		      struct ir_raw_event *events, unsigned int max);
 
 	/* These two should only be used by the lirc decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index f426f16..ad26052 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -246,43 +246,6 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 	return 0;
 }
 
-/**
- * ir_raw_encode_scancode() - Encode a scancode as raw events
- *
- * @protocols:		permitted protocols
- * @scancode:		scancode filter describing a single scancode
- * @events:		array of raw events to write into
- * @max:		max number of raw events
- *
- * Attempts to encode the scancode as raw events.
- *
- * Returns:	The number of events written.
- *		-ENOBUFS if there isn't enough space in the array to fit the
- *		encoding. In this case all @max events will have been written.
- *		-EINVAL if the scancode is ambiguous or invalid, or if no
- *		compatible encoder was found.
- */
-int ir_raw_encode_scancode(u64 protocols,
-			   const struct rc_scancode_filter *scancode,
-			   struct ir_raw_event *events, unsigned int max)
-{
-	struct ir_raw_handler *handler;
-	int ret = -EINVAL;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_for_each_entry(handler, &ir_raw_handler_list, list) {
-		if (handler->protocols & protocols && handler->encode) {
-			ret = handler->encode(protocols, scancode, events, max);
-			if (ret >= 0 || ret == -ENOBUFS)
-				break;
-		}
-	}
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(ir_raw_encode_scancode);
-
 /*
  * Used to (un)register raw event clients
  */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 93713ca..eea27ee 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -250,9 +250,6 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-int ir_raw_encode_scancode(u64 protocols,
-			   const struct rc_scancode_filter *scancode,
-			   struct ir_raw_event *events, unsigned int max);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {

