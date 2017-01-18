Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54926 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdARPq7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 10:46:59 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] saa7164: "first image" should be "second image" in error message
Date: Wed, 18 Jan 2017 15:10:57 +0000
Message-Id: <20170118151057.16325-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The error message when the second image is not available is incorrect,
replace "first image" with "second image".

Fixes CoverityScan CID#1077508 ("Copy-paste error")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/saa7164/saa7164-fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index 7f077a8..c384a94 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -309,7 +309,7 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 					break;
 				}
 				if (err_flags & SAA_DEVICE_NO_IMAGE) {
-					printk(KERN_ERR "%s() no first image\n",
+					printk(KERN_ERR "%s() no second image\n",
 						__func__);
 					break;
 				}
-- 
2.10.2

