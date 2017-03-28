Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35272 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdC1FPM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 01:15:12 -0400
Received: by mail-pg0-f66.google.com with SMTP id g2so18369498pge.2
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 22:15:11 -0700 (PDT)
From: vaibhavddit@gmail.com
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, Vaibhav Kothari <vaibhavddit@gmail.com>
Subject: [PATCH] staging: media: atomisp: i2c: removed unnecessary white space before comma in memset()
Date: Tue, 28 Mar 2017 10:44:44 +0530
Message-Id: <1490678084-12740-1-git-send-email-vaibhavddit@gmail.com>
In-Reply-To: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
References: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gc2235.c

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
