Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47772 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2FNSAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 14:00:02 -0400
Received: by ghrr11 with SMTP id r11so1614168ghr.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 11:00:01 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 4/8] [RESEND] saa7164: Variable set but not used
Date: Thu, 14 Jun 2012 14:58:12 -0300
Message-Id: <1339696716-14373-4-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function saa7164_api_i2c_read variable regval was set but not used.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/saa7164/saa7164-api.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index 8a98ab6..c8799fd 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -1367,7 +1367,6 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 	struct saa7164_dev *dev = bus->dev;
 	u16 len = 0;
 	int unitid;
-	u32 regval;
 	u8 buf[256];
 	int ret;
 
@@ -1376,19 +1375,6 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 	if (reglen > 4)
 		return -EIO;
 
-	if (reglen == 1)
-		regval = *(reg);
-	else
-	if (reglen == 2)
-		regval = ((*(reg) << 8) || *(reg+1));
-	else
-	if (reglen == 3)
-		regval = ((*(reg) << 16) | (*(reg+1) << 8) | *(reg+2));
-	else
-	if (reglen == 4)
-		regval = ((*(reg) << 24) | (*(reg+1) << 16) |
-			(*(reg+2) << 8) | *(reg+3));
-
 	/* Prepare the send buffer */
 	/* Bytes 00-03 source register length
 	 *       04-07 source bytes to read
-- 
1.7.10.2

