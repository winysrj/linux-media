Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbcKXQZ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 11:25:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] b2c2: use IS_REACHABLE() instead of open-coding it
Date: Thu, 24 Nov 2016 17:25:38 +0100
Message-Id: <20161124162549.3787200-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FE_SUPPORTED() macro is basically the same as IS_REACHABLE, except
that it causes a warning with gcc-7:

common/b2c2/flexcop-fe-tuner.c:30:1: error: this use of "defined" may not be portable [-Werror=expansion-to-defined]
common/b2c2/flexcop-fe-tuner.c:30:1: error: this use of "defined" may not be portable [-Werror=expansion-to-defined]
common/b2c2/flexcop-fe-tuner.c:30:1: error: this use of "defined" may not be portable [-Werror=expansion-to-defined]

Using IS_REACHABLE() to define it avoids the warning.

Fixes: 3785bc170f79 ("[media] b2c2: break it into common/pci/usb directories")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index f5956402fc69..5f10151ecec9 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -24,8 +24,7 @@
 
 /* Can we use the specified front-end?  Remember that if we are compiled
  * into the kernel we can't call code that's in modules.  */
-#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
-	(defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
+#define FE_SUPPORTED(fe) IS_REACHABLE(CONFIG_DVB_ ## fe)
 
 #if FE_SUPPORTED(BCM3510) || (FE_SUPPORTED(CX24120) && FE_SUPPORTED(ISL6421))
 static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
-- 
2.9.0

