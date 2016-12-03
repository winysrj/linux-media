Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:34110 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750900AbcLCHCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2016 02:02:12 -0500
From: Shilpa Puttegowda <shilpapri@gmail.com>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, Shilpa P <shilpapri@gmail.com>
Subject: [PATCH] staging: Replaced BUG_ON with warnings
Date: Sat,  3 Dec 2016 12:32:01 +0530
Message-Id: <1480748521-8738-1-git-send-email-shilpapri@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shilpa P <shilpapri@gmail.com>

Don't crash the Kernel for driver errors

Signed-off-by: Shilpa P <shilpapri@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 4d9bd02..05f5918 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1538,7 +1538,11 @@ static int bcm2048_parse_rt_match_c(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return 0;
 
-	BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
+	if ((index + 2) >= BCM2048_MAX_RDS_RT) {
+		dev_err(&bdev->client->dev,
+			"Incorrect index = %d\n", index);
+		return 0;
+	}
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 		BCM2048_RDS_BLOCK_C) {
@@ -1561,7 +1565,11 @@ static void bcm2048_parse_rt_match_d(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return;
 
-	BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
+	if ((index + 4) >= BCM2048_MAX_RDS_RT) {
+		dev_err(&bdev->client->dev,
+			"Incorrect index = %d\n", index);
+		return;
+	}
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 	    BCM2048_RDS_BLOCK_D)
-- 
1.9.1

