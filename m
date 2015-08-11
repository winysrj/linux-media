Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbbHKTnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 15:43:25 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] c8sectpfe: Allow compiling it with COMPILE_TEST
Date: Tue, 11 Aug 2015 16:41:46 -0300
Message-Id: <1439322106-6966-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While it won't work, it is good to allow it to build with
COMPILE_TEST, as we can check if other patches would break
compilation for this driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/sti/c8sectpfe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index d1bfd4c646ae..a7227d2ab6cc 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -1,6 +1,6 @@
 config DVB_C8SECTPFE
 	tristate "STMicroelectronics C8SECTPFE DVB support"
-	depends on DVB_CORE && I2C && (ARCH_STI || ARCH_MULTIPLATFORM)
+	depends on DVB_CORE && I2C && (ARCH_STI || ARCH_MULTIPLATFORM || COMPILE_TEST)
 	select LIBELF_32
 	select FW_LOADER
 	select FW_LOADER_USER_HELPER_FALLBACK
-- 
2.4.3

