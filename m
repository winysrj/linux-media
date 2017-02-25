Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58719 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdBYLwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:52:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 16/19] [media] rc: auto load encoder if necessary
Date: Sat, 25 Feb 2017 11:51:31 +0000
Message-Id: <cb8ba767b4b5c36024420c65145e9cf6b4888679.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
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
index 5624300..3306ce1 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -274,6 +274,7 @@ int ir_raw_event_register(struct rc_dev *dev);
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
