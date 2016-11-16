Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49721 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753859AbcKPQnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:17 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 14/35] [media] ttusb_dec: use KERNEL_CONT where needed
Date: Wed, 16 Nov 2016 14:42:46 -0200
Message-Id: <700eaaeefec25ead60c1bba255fcf7ee242b7ff7.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 559c823a4fe8..fc0219f1b7df 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -329,7 +329,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 				  int param_length, const u8 params[],
 				  int *result_length, u8 cmd_result[])
 {
-	int result, actual_len, i;
+	int result, actual_len;
 	u8 *b;
 
 	dprintk("%s\n", __func__);
@@ -353,10 +353,8 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 		memcpy(&b[4], params, param_length);
 
 	if (debug) {
-		printk("%s: command: ", __func__);
-		for (i = 0; i < param_length + 4; i++)
-			printk("0x%02X ", b[i]);
-		printk("\n");
+		printk(KERN_DEBUG "%s: command: %*ph\n",
+		       __func__, param_length, b);
 	}
 
 	result = usb_bulk_msg(dec->udev, dec->command_pipe, b,
@@ -381,10 +379,8 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 		return result;
 	} else {
 		if (debug) {
-			printk("%s: result: ", __func__);
-			for (i = 0; i < actual_len; i++)
-				printk("0x%02X ", b[i]);
-			printk("\n");
+			printk(KERN_DEBUG "%s: result: %*ph\n",
+			       __func__, actual_len, b);
 		}
 
 		if (result_length)
-- 
2.7.4


