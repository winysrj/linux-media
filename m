Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36936 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbKPTyC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:02 -0500
Received: by wmww144 with SMTP id w144so135105307wmw.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:01 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/8] media: rc: fix decoder module unloading
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A33DC.90809@gmail.com>
Date: Mon, 16 Nov 2015 20:51:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, if a decoder module is unloadad, the respective protocol
is still shown as enabled (if it was enabled before).
Fix this by resetting the respective protocol bits if a decoder
module is unloaded.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-ir-raw.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index ad26052..5cfb61f 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -246,6 +246,14 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 	return 0;
 }
 
+static void ir_raw_disable_protocols(struct rc_dev *dev, u64 protocols)
+{
+	mutex_lock(&dev->lock);
+	dev->enabled_protocols &= ~protocols;
+	dev->enabled_wakeup_protocols &= ~protocols;
+	mutex_unlock(&dev->lock);
+}
+
 /*
  * Used to (un)register raw event clients
  */
@@ -337,13 +345,16 @@ EXPORT_SYMBOL(ir_raw_handler_register);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 {
 	struct ir_raw_event_ctrl *raw;
+	u64 protocols = ir_raw_handler->protocols;
 
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir_raw_handler->list);
-	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
+	list_for_each_entry(raw, &ir_raw_client_list, list) {
+		ir_raw_disable_protocols(raw->dev, protocols);
+		if (ir_raw_handler->raw_unregister)
 			ir_raw_handler->raw_unregister(raw->dev);
-	available_protocols &= ~ir_raw_handler->protocols;
+	}
+	available_protocols &= ~protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
-- 
2.6.2

