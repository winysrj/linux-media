Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35702 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdBLVpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 16:45:41 -0500
From: Ran Algawi <ran.algawi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: bcm2048: Fixed coding style issue.
Date: Sun, 12 Feb 2017 23:45:32 +0200
Message-Id: <1486935932-2146-1-git-send-email-ran.algawi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a coding style issue, where an octal value was needed insted of decimal.

Signed-off-by: Ran Algawi <ran.algawi@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 37bd439..d605c41 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -300,7 +300,7 @@ struct bcm2048_device {
 };
 
 static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0000);
 MODULE_PARM_DESC(radio_nr,
 		 "Minor number for radio device (-1 ==> auto assign)");
 
-- 
2.7.4
