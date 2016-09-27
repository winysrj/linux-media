Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36505 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbcI0Ts4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 15:48:56 -0400
Received: by mail-wm0-f68.google.com with SMTP id b184so2710115wma.3
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2016 12:48:55 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] rc: ir-raw: change type of available_protocols to atomic64_t
Message-ID: <368a90c9-a1ff-3f2d-609e-c255c486e406@gmail.com>
Date: Tue, 27 Sep 2016 21:48:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing available_protocols to atomic64_t allows to get rid of the
mutex protecting access to the variable. This helps to simplify
the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-ir-raw.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 205ecc6..1c42a9f 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -26,8 +26,7 @@ static LIST_HEAD(ir_raw_client_list);
 /* Used to handle IR raw handler extensions */
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
-static DEFINE_MUTEX(available_protocols_lock);
-static u64 available_protocols;
+static atomic64_t available_protocols = ATOMIC64_INIT(0);
 
 static int ir_raw_event_thread(void *data)
 {
@@ -234,11 +233,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 u64
 ir_raw_get_allowed_protocols(void)
 {
-	u64 protocols;
-	mutex_lock(&available_protocols_lock);
-	protocols = available_protocols;
-	mutex_unlock(&available_protocols_lock);
-	return protocols;
+	return atomic64_read(&available_protocols);
 }
 
 static int change_protocol(struct rc_dev *dev, u64 *rc_type)
@@ -331,9 +326,7 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
-	mutex_lock(&available_protocols_lock);
-	available_protocols |= ir_raw_handler->protocols;
-	mutex_unlock(&available_protocols_lock);
+	atomic64_or(ir_raw_handler->protocols, &available_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -352,9 +345,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 		if (ir_raw_handler->raw_unregister)
 			ir_raw_handler->raw_unregister(raw->dev);
 	}
-	mutex_lock(&available_protocols_lock);
-	available_protocols &= ~protocols;
-	mutex_unlock(&available_protocols_lock);
+	atomic64_andnot(protocols, &available_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
-- 
2.9.3

