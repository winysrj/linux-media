Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37816 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdEHAJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 20:09:47 -0400
From: Colin King <colin.king@canonical.com>
To: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] pvrusb2: remove redundant check on cnt > 8
Date: Sun,  7 May 2017 19:33:05 +0100
Message-Id: <20170507183305.25350-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The 2nd check of cnt > 8 is redundant as cnt is already checked
and thresholded to a maximum of 8 a few statements earlier.
Remove this redundant 2nd check.

Detected by CoverityScan, CID#114281 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index f727b54a53c6..20a52b785fff 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -488,7 +488,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 			if ((ret > 0) || !(msgs[idx].flags & I2C_M_RD)) {
 				if (cnt > 8) cnt = 8;
 				printk(KERN_CONT " [");
-				for (offs = 0; offs < (cnt>8?8:cnt); offs++) {
+				for (offs = 0; offs < cnt; offs++) {
 					if (offs) printk(KERN_CONT " ");
 					printk(KERN_CONT "%02x",msgs[idx].buf[offs]);
 				}
-- 
2.11.0
