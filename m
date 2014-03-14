Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33854 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaCNXGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:06:55 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so2744811wgh.20
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:06:54 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 1/9] rc: ir-raw: Add scancode encoder callback
Date: Fri, 14 Mar 2014 23:04:11 +0000
Message-Id: <1394838259-14260-2-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a callback to raw ir handlers for encoding and modulating a scancode
to a set of raw events. This could be used for transmit, or for
converting a wakeup scancode filter to a form that is more suitable for
raw hardware wake up filters.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
Changes in v2:
 - Alter encode API to return -ENOBUFS when there isn't enough buffer
   space. When this occurs all buffer contents must have been written
   with the partial encoding of the scancode. This is to allow drivers
   such as nuvoton-cir to provide a shorter buffer and still get a
   useful partial encoding for the wakeup pattern.
---
 drivers/media/rc/ir-raw.c       | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h |  2 ++
 include/media/rc-core.h         |  3 +++
 3 files changed, 43 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 763c9d1..01adc10 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -240,6 +240,44 @@ ir_raw_get_allowed_protocols(void)
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
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid, or if no
+ *		compatible encoder was found.
+ */
+int ir_raw_encode_scancode(u64 protocols,
+			   const struct rc_scancode_filter *scancode,
+			   struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_handler *handler;
+	int ret = -EINVAL;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (handler->protocols & protocols && handler->encode) {
+			ret = handler->encode(protocols, scancode, events, max);
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
+
 /*
  * Used to (un)register raw event clients
  */
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index da536c9..8afb971 100644
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
index 0b9f890..8c64f9e 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -275,6 +275,9 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
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

