Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37562 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeKGPyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 10:54:35 -0500
From: Nathan Chancellor <natechancellor@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] media: imx214: Remove unnecessary self assignment in for loop
Date: Tue,  6 Nov 2018 23:24:50 -0700
Message-Id: <20181107062450.5511-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clang warns when a variable is assigned to itself:

drivers/media/i2c/imx214.c:695:13: error: explicitly assigning value of
variable of type 'const struct reg_8 *' to itself
[-Werror,-Wself-assign]
        for (table = table; table->addr != IMX214_TABLE_END ; table++) {
             ~~~~~ ^ ~~~~~
1 error generated.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/media/i2c/imx214.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index 284b9b49ebde..ec3d1b855f62 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -692,7 +692,7 @@ static int imx214_write_table(struct imx214 *imx214,
 	int i;
 	int ret;
 
-	for (table = table; table->addr != IMX214_TABLE_END ; table++) {
+	for (; table->addr != IMX214_TABLE_END ; table++) {
 		if (table->addr == IMX214_TABLE_WAIT_MS) {
 			usleep_range(table->val * 1000,
 				     table->val * 1000 + 500);
-- 
2.19.1
