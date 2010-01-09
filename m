Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54680 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0AIQvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 11:51:20 -0500
Received: by fxm25 with SMTP id 25so13439978fxm.21
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 08:51:18 -0800 (PST)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] V4L/DVB: ir: fix memory leak
Date: Sat,  9 Jan 2010 19:51:14 +0300
Message-Id: <1263055874-31427-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free ir_dev before exit.
Found by cppcheck.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/media/IR/ir-keytable.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index bff7a53..684918e 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -422,8 +422,10 @@ int ir_input_register(struct input_dev *input_dev,
 	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
 	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
 				    sizeof(struct ir_scancode), GFP_KERNEL);
-	if (!ir_dev->rc_tab.scan)
+	if (!ir_dev->rc_tab.scan) {
+		kfree(ir_dev);
 		return -ENOMEM;
+	}
 
 	IR_dprintk(1, "Allocated space for %d keycode entries (%zd bytes)\n",
 		ir_dev->rc_tab.size,
-- 
1.6.6

