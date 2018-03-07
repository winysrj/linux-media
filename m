Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37235 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753949AbeCGOxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 09:53:06 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: Kconfig: fix DVB dependencies
Date: Wed,  7 Mar 2018 09:53:01 -0500
Message-Id: <2402a22295edff3dd899573949a272424b87af31.1520434378.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If I2C is present and it is module, the DVB core should also
be a module, otherwise build will now fail with:

  drivers/media/dvb-core/dvbdev.o: In function `dvb_module_probe':
     drivers/media/dvb-core/dvbdev.c:965: undefined reference to `i2c_new_device'
     drivers/media/dvb-core/dvbdev.c:972: undefined reference to `i2c_unregister_device'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 372c074bb1b9..29609661cf3d 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -141,6 +141,7 @@ config DVB_CORE
 	tristate
 	depends on MEDIA_SUPPORT
 	depends on MEDIA_DIGITAL_TV_SUPPORT
+	depends on (I2C || I2C=n)
 	default y
 	select CRC32
 
-- 
2.14.3
