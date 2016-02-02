Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:60087 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbcBBPst (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 10:48:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] msp3400: use IS_ENABLED check instead of #if
Date: Tue,  2 Feb 2016 16:47:58 +0100
Message-Id: <1454428087-3852112-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent patch broke the msp3400 driver when CONFIG_MEDIA_CONTROLLER
is not set:

drivers/media/i2c/msp3400-driver.h:107:5: error: "CONFIG_MEDIA_CONTROLLER" is not defined [-Werror=undef]

It was clearly a typo, and this patch changes the
"#if CONFIG_MEDIA_CONTROLLER" to a working IS_ENABLED() check.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: fb4932821731 ("[media] msp3400: initialize MC data")
---
 drivers/media/i2c/msp3400-driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
index f0bb37dc9013..a8702aca187a 100644
--- a/drivers/media/i2c/msp3400-driver.h
+++ b/drivers/media/i2c/msp3400-driver.h
@@ -104,7 +104,7 @@ struct msp_state {
 	unsigned int         restart:1;
 	unsigned int         watch_stereo:1;
 
-#if CONFIG_MEDIA_CONTROLLER
+#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
 	struct media_pad pads[IF_AUD_DEC_PAD_NUM_PADS];
 #endif
 };
-- 
2.7.0

