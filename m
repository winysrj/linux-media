Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34661 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbcIDGnI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 02:43:08 -0400
Received: by mail-pf0-f175.google.com with SMTP id p64so55169275pfb.1
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 23:42:01 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn
Subject: [PATCH] staging: media: omap4iss: mark omap4iss_flush() static
Date: Sun,  4 Sep 2016 14:41:41 +0800
Message-Id: <1472971301-4650-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/staging/media/omap4iss/iss.c:64:6: warning: no previous prototype for 'omap4iss_flush' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
so this patch marks this function with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/staging/media/omap4iss/iss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 6ceb4eb..e27c7a9 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -61,7 +61,7 @@ static void iss_print_status(struct iss_device *iss)
  * See this link for reference:
  *   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08149.html
  */
-void omap4iss_flush(struct iss_device *iss)
+static void omap4iss_flush(struct iss_device *iss)
 {
 	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION, 0);
 	iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);
-- 
2.7.4

