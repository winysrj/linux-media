Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47378 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbeDYPEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 11:04:25 -0400
From: Colin King <colin.king@canonical.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: smiapp: fix timeout checking in smiapp_read_nvm
Date: Wed, 25 Apr 2018 16:04:21 +0100
Message-Id: <20180425150421.30184-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The current code decrements the timeout counter i and the end of
each loop i is incremented, so the check for timeout will always
be false and hence the timeout mechanism is just a dead code path.
Potentially, if the RD_READY bit is not set, we could end up in
an infinite loop.

Fix this so the timeout starts from 1000 and decrements to zero,
if at the end of the loop i is zero we have a timeout condition.

Detected by CoverityScan, CID#1324008 ("Logically dead code")

Fixes: ccfc97bdb5ae ("[media] smiapp: Add driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3b7ace395ee6..e1f8208581aa 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1001,7 +1001,7 @@ static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 		if (rval)
 			goto out;
 
-		for (i = 0; i < 1000; i++) {
+		for (i = 1000; i > 0; i--) {
 			rval = smiapp_read(
 				sensor,
 				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_STATUS, &s);
@@ -1012,11 +1012,10 @@ static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 			if (s & SMIAPP_DATA_TRANSFER_IF_1_STATUS_RD_READY)
 				break;
 
-			if (--i == 0) {
-				rval = -ETIMEDOUT;
-				goto out;
-			}
-
+		}
+		if (!i) {
+			rval = -ETIMEDOUT;
+			goto out;
 		}
 
 		for (i = 0; i < SMIAPP_NVM_PAGE_SIZE; i++) {
-- 
2.17.0
