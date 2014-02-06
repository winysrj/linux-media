Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63848 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbaBFT77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 14:59:59 -0500
Received: by mail-wi0-f169.google.com with SMTP id e4so190284wiv.4
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 11:59:57 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 1/4] rc: ir-raw: add scancode encoder callback
Date: Thu,  6 Feb 2014 19:59:20 +0000
Message-Id: <1391716763-2689-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a callback to raw ir handlers for encoding and modulating a scancode
to a set of raw events. This could be used for transmit, or for
converting a wakeup scancode filter to a form that is more suitable for
raw hardware wake up filters.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/media/rc/ir-raw.c       | 37 +++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h |  2 ++
 include/media/rc-core.h         |  3 +++
 3 files changed, 42 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 79a9cb6..9aea407 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -240,6 +240,43 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+/**
+ * ir_raw_encode_scancode() - Encode a scancode as raw events
+ *
+ * @protocols:		permitted protocols
+ * @scancode:		scancode filter describing a single scancode
+ * @events:		array of raw events to write into
+ * @max:		max number of raw events
+ *
+ * Attempts to encode the scancode as raw events.
+ *
+ * Returns -EINVAL if the scancode is ambiguous or invalid, or there isn't
+ * enough space in the array to fit the encoding.
+ *
+ * Returns -ENOTSUPP if no compatible encoder is found.
+ */
+int ir_raw_encode_scancode(u64 protocols,
+			   const struct rc_scancode_filter *scancode,
+			   struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_handler *handler;
+	int ret = -ENOTSUPP;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (handler->protocols & protocols && handler->encode) {
+			ret = handler->encode(protocols, scancode, events, max);
+			if (ret >= 0)
+				break;
+		}
+	}
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ir_raw_encode_scancode);
+
+
 /*
  * Used to (un)register raw event clients
  */
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index dc3b0b7..dfbaad0 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -25,6 +25,8 @@ struct ir_raw_handler {
 
 	u64 protocols; /* which are handled by this handler */
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
+	int (*encode)(u64 protocols, const struct rc_scancode_filter *scancode,
+		      struct ir_raw_event *events, unsigned int max);
 
 	/* These two should only be used by the lirc decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 4a72176..7bd66be 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -234,6 +234,9 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
+int ir_raw_encode_scancode(u64 protocols,
+			   const struct rc_scancode_filter *scancode,
+			   struct ir_raw_event *events, unsigned int max);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-- 
1.8.3.2

