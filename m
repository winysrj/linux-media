Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48623 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 22/25] [media] flexcop-i2c: mark printk continuation lines as such
Date: Fri, 14 Oct 2016 14:46:00 -0300
Message-Id: <39002b3c6e3aa873614da7b0617f0001020ab5ef.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has printk continuation lines for debugging purposes.

Since commit 563873318d32 ("Merge branch 'printk-cleanups'"),
this won't work as expected anymore. So, let's add KERN_CONT to
those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/b2c2/flexcop-i2c.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-i2c.c b/drivers/media/common/b2c2/flexcop-i2c.c
index 965d5eb33752..e41cd23f8e45 100644
--- a/drivers/media/common/b2c2/flexcop-i2c.c
+++ b/drivers/media/common/b2c2/flexcop-i2c.c
@@ -124,10 +124,10 @@ int flexcop_i2c_request(struct flexcop_i2c_adapter *i2c,
 #ifdef DUMP_I2C_MESSAGES
 	printk(KERN_DEBUG "%d ", i2c->port);
 	if (op == FC_READ)
-		printk("rd(");
+		printk(KERN_CONT "rd(");
 	else
-		printk("wr(");
-	printk("%02x): %02x ", chipaddr, addr);
+		printk(KERN_CONT "wr(");
+	printk(KERN_CONT "%02x): %02x ", chipaddr, addr);
 #endif
 
 	/* in that case addr is the only value ->
@@ -151,7 +151,7 @@ int flexcop_i2c_request(struct flexcop_i2c_adapter *i2c,
 
 #ifdef DUMP_I2C_MESSAGES
 		for (i = 0; i < bytes_to_transfer; i++)
-			printk("%02x ", buf[i]);
+			printk(KERN_CONT "%02x ", buf[i]);
 #endif
 
 		if (ret < 0)
@@ -163,7 +163,7 @@ int flexcop_i2c_request(struct flexcop_i2c_adapter *i2c,
 	}
 
 #ifdef DUMP_I2C_MESSAGES
-	printk("\n");
+	printk(KERN_CONT "\n");
 #endif
 
 	return 0;
-- 
2.7.4


