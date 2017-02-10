Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33647 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdBJWlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 17:41:40 -0500
From: Ran Algawi <ran.algawi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: bcm2048: Fixed an error
Date: Sat, 11 Feb 2017 00:41:29 +0200
Message-Id: <1486766489-8279-1-git-send-email-ran.algawi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed an error where the system was given a code in the form of decimal
instead of octal.

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

