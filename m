Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48593 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754265AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 04/25] [media] em28xx: mark printk continuation lines as such
Date: Fri, 14 Oct 2016 14:45:42 -0300
Message-Id: <ce7e7bb7ccbb306930d7c3582a1e3af6d945b181.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has a lot of printk continuation lines for
debugging purposes. Since commit 563873318d32
("Merge branch 'printk-cleanups"), this won't work as expected
anymore. So, let's add KERN_CONT to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index a73e853e876e..06bee2d67273 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -102,7 +102,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
 		if (reg_debug)
-			printk(" failed!\n");
+			printk(KERN_CONT " failed!\n");
 		mutex_unlock(&dev->ctrl_urb_lock);
 		return usb_translate_errors(ret);
 	}
@@ -115,10 +115,10 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	if (reg_debug) {
 		int byte;
 
-		printk("<<<");
+		printk(KERN_CONT "<<<");
 		for (byte = 0; byte < len; byte++)
-			printk(" %02x", (unsigned char)buf[byte]);
-		printk("\n");
+			printk(KERN_CONT " %02x", (unsigned char)buf[byte]);
+		printk(KERN_CONT "\n");
 	}
 
 	return ret;
@@ -174,8 +174,8 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			len & 0xff, len >> 8);
 
 		for (byte = 0; byte < len; byte++)
-			printk(" %02x", (unsigned char)buf[byte]);
-		printk("\n");
+			printk(KERN_CONT " %02x", (unsigned char)buf[byte]);
+		printk(KERN_CONT "\n");
 	}
 
 	mutex_lock(&dev->ctrl_urb_lock);
-- 
2.7.4


