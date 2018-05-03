Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:56430 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751050AbeECOoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:44:19 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2] saa7164: Fix driver name in debug output
Date: Thu,  3 May 2018 09:44:11 -0500
Message-Id: <1525358651-27127-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This issue was reported by a user who downloaded a corrupt saa7164
firmware, then went looking for a valid xc5000 firmware to fix the
error displayed...but the device in question has no xc5000, thus after
much effort, the wild goose chase eventually led to a support call.

The xc5000 has nothing to do with saa7164 (as far as I can tell),
so replace the string with saa7164 as well as give a meaningful
hint on the firmware mismatch.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Since v1:
- Appease the 0-day bot, fix print format related kernel warnings.

 drivers/media/pci/saa7164/saa7164-fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index ef49064..ee65ea8 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -426,7 +426,8 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 			__func__, fw->size);
 
 		if (fw->size != fwlength) {
-			printk(KERN_ERR "xc5000: firmware incorrect size\n");
+			printk(KERN_ERR "saa7164: firmware incorrect size %ld != %u\n",
+				fw->size, fwlength);
 			ret = -ENOMEM;
 			goto out;
 		}
-- 
2.7.4
