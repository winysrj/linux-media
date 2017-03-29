Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35271 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbdC2ENI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 00:13:08 -0400
Received: by mail-pf0-f196.google.com with SMTP id n11so362056pfg.2
        for <linux-media@vger.kernel.org>; Tue, 28 Mar 2017 21:13:07 -0700 (PDT)
From: vaibhavddit@gmail.com
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, Vaibhav Kothari <vaibhavddit@gmail.com>
Subject: [PATCH 1/2] staging: media: atomisp: i2c: removed unnecessary white space before comma in memset()
Date: Wed, 29 Mar 2017 09:43:21 +0530
Message-Id: <1490760801-28939-1-git-send-email-vaibhavddit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Kothari <vaibhavddit@gmail.com>

Removed extra space before comma in memset() as a part of
checkpatch.pl fix-up.

Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 9b41023..50f4317 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -55,7 +55,7 @@ static int gc2235_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
-- 
1.9.1
