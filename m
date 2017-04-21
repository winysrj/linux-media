Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62924 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038039AbdDUKvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 06:51:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rainshadow-cec: avoid -Wmaybe-uninitialized warning
Date: Fri, 21 Apr 2017 12:51:21 +0200
Message-Id: <20170421105139.875425-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The barrier implied by spin_unlock() in rain_irq_work_handler makes it hard
for gcc to figure out the state of the variables, leading to a false-positive
warning:

drivers/media/usb/rainshadow-cec/rainshadow-cec.c: In function 'rain_irq_work_handler':
drivers/media/usb/rainshadow-cec/rainshadow-cec.c:171:31: error: 'data' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Slightly rearranging the code makes it easier for the compiler to see that the
code is correct, and gets rid of the warning.

Fixes: 0f314f6c2e77 ("[media] rainshadow-cec: new RainShadow Tech HDMI CEC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index dc1f64f904cd..9ddd6a99f066 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -123,11 +123,12 @@ static void rain_irq_work_handler(struct work_struct *work)
 		char data;
 
 		spin_lock_irqsave(&rain->buf_lock, flags);
-		exit_loop = rain->buf_len == 0;
 		if (rain->buf_len) {
 			data = rain->buf[rain->buf_rd_idx];
 			rain->buf_len--;
 			rain->buf_rd_idx = (rain->buf_rd_idx + 1) & 0xff;
+		} else {
+			exit_loop = true;
 		}
 		spin_unlock_irqrestore(&rain->buf_lock, flags);
 
-- 
2.9.0
