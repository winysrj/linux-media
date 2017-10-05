Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60679 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbdJEIp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:28 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 03/25] media: rc: auto load encoder if necessary
Date: Thu,  5 Oct 2017 09:45:05 +0100
Message-Id: <00e99c0231ae00b710f5d95657b9fbd5e58ef876.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
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
index 3cf09408df6c..d29b1b1ef4b7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -271,6 +271,7 @@ void ir_raw_event_free(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
+void ir_raw_load_modules(u64 *protocols);
 void ir_raw_init(void);
 
 /*
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 0814e08a280b..b84201cb012a 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -457,6 +457,8 @@ int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 	int ret = -EINVAL;
 	u64 mask = 1ULL << protocol;
 
+	ir_raw_load_modules(&mask);
+
 	mutex_lock(&ir_raw_handler_lock);
 	list_for_each_entry(handler, &ir_raw_handler_list, list) {
 		if (handler->protocols & mask && handler->encode) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cb78e5702bef..62102b3ef5aa 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1081,7 +1081,7 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 	return count;
 }
 
-static void ir_raw_load_modules(u64 *protocols)
+void ir_raw_load_modules(u64 *protocols)
 {
 	u64 available;
 	int i, ret;
-- 
2.13.6
