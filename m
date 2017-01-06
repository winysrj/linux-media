Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49425 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032226AbdAFMtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6/9] [media] rc: auto load encoder if necessary
Date: Fri,  6 Jan 2017 12:49:09 +0000
Message-Id: <6f0d2a381c324cb67f7a24a483333692d53555ac.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
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
index c183b70..337b9ce 100644
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
index 49f1b14..a1e89a8 100644
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
index b135365..bfc43e9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1036,7 +1036,7 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 	return count;
 }
 
-static void ir_raw_load_modules(u64 *protocols)
+void ir_raw_load_modules(u64 *protocols)
 {
 	u64 available;
 	int i, ret;
-- 
2.9.3

