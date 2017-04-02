Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34733 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdDBToI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Apr 2017 15:44:08 -0400
Received: by mail-wr0-f196.google.com with SMTP id w43so28304680wrb.1
        for <linux-media@vger.kernel.org>; Sun, 02 Apr 2017 12:44:07 -0700 (PDT)
From: Valerio Genovese <valerio.click@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: i2c: removed unnecessary white space before comma in memset()
Date: Sun,  2 Apr 2017 21:43:46 +0200
Message-Id: <1491162226-14827-1-git-send-email-valerio.click@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed extra space before comma in memset() as a part of
checkpatch.pl fix-up.

Signed-off-by: Valerio Genovese <valerio.click@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index add8b90..1ec616a 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -54,7 +54,7 @@ static int gc0310_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
-- 
2.7.4
