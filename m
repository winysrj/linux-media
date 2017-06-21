Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:49624 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdFUWLC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 18:11:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rainshadow-cec: avoid -Wmaybe-uninitialized warning again
Date: Thu, 22 Jun 2017 00:10:32 +0200
Message-Id: <20170621221047.128705-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back in April I created a patch to address a false-positive warning:

drivers/media/usb/rainshadow-cec/rainshadow-cec.c: In function 'rain_irq_work_handler':
drivers/media/usb/rainshadow-cec/rainshadow-cec.c:171:31: error: 'data' may be used uninitialized in this function [-Werror=maybe-uninitialized]

My patch was totally wrong and introduced a real bug, and Colin Ian King thankfully
noticed it now and fixed my mistake. Unfortunately, fixing the actual uninitialized
data in this case brought back the original bogus warning.

This is a new version of the patch, which simplifies the code to the point where
gcc notices the behavior is correct.

Fixes: ca33784ba494 ("[media] rainshadow-cec: ensure exit_loop is intialized")
Fixes: ea6a69defd3311 ("[media] rainshadow-cec: avoid -Wmaybe-uninitialized warning")
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index ad468efc4399..7bc28bb92c35 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -119,21 +119,19 @@ static void rain_irq_work_handler(struct work_struct *work)
 
 	while (true) {
 		unsigned long flags;
-		bool exit_loop = false;
 		char data;
 
 		spin_lock_irqsave(&rain->buf_lock, flags);
-		if (rain->buf_len) {
-			data = rain->buf[rain->buf_rd_idx];
-			rain->buf_len--;
-			rain->buf_rd_idx = (rain->buf_rd_idx + 1) & 0xff;
-		} else {
-			exit_loop = true;
+		if (!rain->buf_len) {
+			spin_unlock_irqrestore(&rain->buf_lock, flags);
+			break;
 		}
-		spin_unlock_irqrestore(&rain->buf_lock, flags);
 
-		if (exit_loop)
-			break;
+		data = rain->buf[rain->buf_rd_idx];
+		rain->buf_len--;
+		rain->buf_rd_idx = (rain->buf_rd_idx + 1) & 0xff;
+
+		spin_unlock_irqrestore(&rain->buf_lock, flags);
 
 		if (!rain->cmd_started && data != '?')
 			continue;
-- 
2.9.0
