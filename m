Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3HXNAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 09:00:16 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] sms: fix randconfig building error
Date: Sat, 24 Aug 2013 06:59:37 -0300
Message-Id: <1377338377-17410-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Jim Davis <jim.epost@gmail.com>,
building with:
	CONFIG_USB=m
	CONFIG_SMS_USB_DRV=m
	CONFIG_SMS_SDIO_DRV=y
	CONFIG_SMS_SIANO_MDTV=y
	CONFIG_SMS_SIANO_DEBUGFS=y

causes a build error:

	drivers/built-in.o: In function `smsdvb_debugfs_register':
	/home/jim/linux/drivers/media/common/siano/smsdvb-debugfs.c:537:
	undefined reference to `usb_debug_root'
	make: *** [vmlinux] Error 1

That happens because the siano-mdtv is builtin, while USB is a
module. As it makes not much sense to have sms-usb compiled as 'm'
and sms-sdio compiled as 'y' (or vice-versa), only allow enabling
debugfs if both are either 'y' or 'm'.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/common/siano/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index f3f5ec4..f953d33 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -23,6 +23,8 @@ config SMS_SIANO_DEBUGFS
 	depends on SMS_SIANO_MDTV
 	depends on DEBUG_FS
 	depends on SMS_USB_DRV
+	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
+
 	---help---
 	  Choose Y to enable visualizing a dump of the frontend
 	  statistics response packets via debugfs. Currently, works
-- 
1.8.3.1

