Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753892AbcKPQnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:20 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 12/35] [media] wl128x: use KERNEL_CONT where needed
Date: Wed, 16 Nov 2016 14:42:44 -0200
Message-Id: <ab9f63269b6e510731569c617bd70c9afd6627fe.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERNEL_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 6f254e80ffa6..4be07656fbc0 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -212,14 +212,14 @@ inline void dump_tx_skb_data(struct sk_buff *skb)
 
 	len_org = skb->len - FM_CMD_MSG_HDR_SIZE;
 	if (len_org > 0) {
-		printk("\n   data(%d): ", cmd_hdr->dlen);
+		printk(KERN_CONT "\n   data(%d): ", cmd_hdr->dlen);
 		len = min(len_org, 14);
 		for (index = 0; index < len; index++)
-			printk("%x ",
+			printk(KERN_CONT "%x ",
 			       skb->data[FM_CMD_MSG_HDR_SIZE + index]);
-		printk("%s", (len_org > 14) ? ".." : "");
+		printk(KERN_CONT "%s", (len_org > 14) ? ".." : "");
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
  /* To dump incoming FM Channel-8 packets */
@@ -237,14 +237,14 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
 
 	len_org = skb->len - FM_EVT_MSG_HDR_SIZE;
 	if (len_org > 0) {
-		printk("\n   data(%d): ", evt_hdr->dlen);
+		printk(KERN_CONT "\n   data(%d): ", evt_hdr->dlen);
 		len = min(len_org, 14);
 		for (index = 0; index < len; index++)
-			printk("%x ",
+			printk(KERN_CONT "%x ",
 			       skb->data[FM_EVT_MSG_HDR_SIZE + index]);
-		printk("%s", (len_org > 14) ? ".." : "");
+		printk(KERN_CONT "%s", (len_org > 14) ? ".." : "");
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 #endif
 
-- 
2.7.4


