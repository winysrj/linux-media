Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38623 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936026AbcLOMuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:12 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v6 06/18] [media] rc: rc-ir-raw: Add scancode encoder callback
Date: Thu, 15 Dec 2016 12:49:59 +0000
Message-Id: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add a callback to raw ir handlers for encoding and modulating a scancode
to a set of raw events. This could be used for transmit, or for
converting a wakeup scancode to a form that is more suitable for raw
hardware wake up filters.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |  2 ++
 drivers/media/rc/rc-ir-raw.c    | 37 +++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h         |  2 ++
 3 files changed, 41 insertions(+)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 585d5e5..d8be011 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -28,6 +28,8 @@ struct ir_raw_handler {
 
 	u64 protocols; /* which are handled by this handler */
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
+	int (*encode)(enum rc_type protocol, u32 scancode,
+		      struct ir_raw_event *events, unsigned int max);
 
 	/* These two should only be used by the lirc decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 171bdba..1dd067f 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -249,6 +249,43 @@ static void ir_raw_disable_protocols(struct rc_dev *dev, u64 protocols)
 	mutex_unlock(&dev->lock);
 }
 
+/**
+ * ir_raw_encode_scancode() - Encode a scancode as raw events
+ *
+ * @protocol:		protocol
+ * @scancode:		scancode filter describing a single scancode
+ * @events:		array of raw events to write into
+ * @max:		max number of raw events
+ *
+ * Attempts to encode the scancode as raw events.
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid, or if no
+ *		compatible encoder was found.
+ */
+int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
+			   struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_handler *handler;
+	int ret = -EINVAL;
+	u64 mask = 1ULL << protocol;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (handler->protocols & mask && handler->encode) {
+			ret = handler->encode(protocol, scancode, events, max);
+			if (ret >= 0 || ret == -ENOBUFS)
+				break;
+		}
+	}
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ir_raw_encode_scancode);
+
 /*
  * Used to (un)register raw event clients
  */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index af40093..62d69b1 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -306,6 +306,8 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
+int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
+			   struct ir_raw_event *events, unsigned int max);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-- 
2.9.3

