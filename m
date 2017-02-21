Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33789 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753175AbdBUUnu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:50 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 16/19] [media] rc: auto load encoder if necessary
Date: Tue, 21 Feb 2017 20:43:40 +0000
Message-Id: <1bdd4e2b92f0c4aa33f9ca69de17875fd06ffedd.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When sending scancodes, load the encoder if we need it.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-core-priv.h | 1 +
 drivers/media/rc/rc-ir-raw.c    | 2 ++
 drivers/media/rc/rc-main.c      | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 1b53409..db0d2e0 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -294,6 +294,7 @@ int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
+void ir_raw_load_modules(u64 *protocols);
 void ir_raw_init(void);
 
 /*
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 9ffa5a9..65531c5 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -470,6 +470,8 @@ int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
 	int ret = -EINVAL;
 	u64 mask = 1ULL << protocol;
 
+	ir_raw_load_modules(&mask);
+
 	mutex_lock(&ir_raw_handler_lock);
 	list_for_each_entry(handler, &ir_raw_handler_list, list) {
 		if (handler->protocols & mask && handler->encode) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index de533b5..68888f3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1039,7 +1039,7 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 	return count;
 }
 
-static void ir_raw_load_modules(u64 *protocols)
+void ir_raw_load_modules(u64 *protocols)
 {
 	u64 available;
 	int i, ret;
-- 
2.9.3
