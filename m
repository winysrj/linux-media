Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f228.google.com ([209.85.217.228]:34654 "EHLO
	mail-gx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0BDCCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 21:02:11 -0500
Received: by gxk28 with SMTP id 28so1926437gxk.9
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 18:02:10 -0800 (PST)
Date: Thu, 4 Feb 2010 11:01:44 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: yuasa@linux-mips.org, linux-media@vger.kernel.org
Subject: [PATCH] fix memory leak media IR keytable
Message-Id: <20100204110144.70046143.yuasa@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/media/IR/ir-keytable.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index b521ed9..44501d9 100644
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
1.6.6.1

