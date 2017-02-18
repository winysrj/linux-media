Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35088 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdBRDxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 22:53:16 -0500
From: Man Choy <manchoyy@gmail.com>
To: bhumirks@gmail.com
Cc: Man Choy <manchoyy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bcm2048: Fix checkpatch checks
Date: Sat, 18 Feb 2017 11:52:37 +0800
Message-Id: <1487389982-26131-1-git-send-email-manchoyy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix following checks:

CHECK: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
+       BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);

CHECK: spaces preferred around that '+' (ctx:VxV)
+       BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
                     ^

CHECK: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
+       BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);

CHECK: spaces preferred around that '+' (ctx:VxV)
+       BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
                     ^
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 37bd439..d5ee279 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1534,7 +1534,7 @@ static int bcm2048_parse_rt_match_c(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return 0;
 
-	BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
+	WARN_ON((index + 2) >= BCM2048_MAX_RDS_RT);
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 		BCM2048_RDS_BLOCK_C) {
@@ -1557,7 +1557,7 @@ static void bcm2048_parse_rt_match_d(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return;
 
-	BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
+	WARN_ON((index + 4) >= BCM2048_MAX_RDS_RT);
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 	    BCM2048_RDS_BLOCK_D)
-- 
2.7.4
