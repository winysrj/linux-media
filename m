Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36415 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbbEUJ3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:29:44 -0400
Received: by wgbgq6 with SMTP id gq6so79316786wgb.3
        for <linux-media@vger.kernel.org>; Thu, 21 May 2015 02:29:43 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH] b2c2: Mismatch in config ifdefs for SkystarS2
Date: Thu, 21 May 2015 10:29:23 +0100
Message-Id: <1432200563-3281-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compilation warning issued by kbuild test robot:
>> drivers/media/common/b2c2/flexcop-fe-tuner.c:31:12: warning: 'flexcop_fe_request_firmware' defined but not used [-Wunused-function]
    static int flexcop_fe_request_firmware(struct dvb_frontend *fe,

This patch fixes a mismatch in Kconfig define checks. One had a
check for just CX24120, the other is checking for both CX24120
and ISL6421.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index 2426062..a8d562f 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -27,7 +27,7 @@
 #define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
 	(defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
 
-#if FE_SUPPORTED(BCM3510) || FE_SUPPORTED(CX24120)
+#if FE_SUPPORTED(BCM3510) || (FE_SUPPORTED(CX24120) && FE_SUPPORTED(ISL6421))
 static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
 	const struct firmware **fw, char *name)
 {
-- 
2.1.0

