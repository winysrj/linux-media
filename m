Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3HXN4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 09:56:14 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] cx88: fix build when VP3054=m and CX88_DVB=y
Date: Sat, 24 Aug 2013 07:55:26 -0300
Message-Id: <1377341726-24306-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Jim Davis <jim.epost@gmail.com>:

randconfig build error with next-20130813, in drivers/media/pci/cx88,
when:
	CONFIG_VIDEO_CX88=y
	CONFIG_VIDEO_CX88_BLACKBIRD=m
	CONFIG_VIDEO_CX88_DVB=y
	CONFIG_VIDEO_CX88_VP3054=m
	CONFIG_VIDEO_CX88_MPEG=y

  LD      init/built-in.o
drivers/built-in.o: In function `cx8802_dvb_remove':
cx88-dvb.c:(.text+0x3a9914): undefined reference to `vp3054_i2c_remove'
drivers/built-in.o: In function `cx8802_dvb_probe':
cx88-dvb.c:(.text+0x3a9c4b): undefined reference to `vp3054_i2c_probe'
make: *** [vmlinux] Error 1

That happens because the vp3054 symbols aren't available builtin.
So, make it builtin, if CX88_DVB=y, or module otherwise, if this
support is selected.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx88/Kconfig | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index bb05eca..a63a9ad 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -72,9 +72,9 @@ config VIDEO_CX88_DVB
 	  To compile this driver as a module, choose M here: the
 	  module will be called cx88-dvb.
 
-config VIDEO_CX88_VP3054
-	tristate "VP-3054 Secondary I2C Bus Support"
-	default m
+config VIDEO_CX88_ENABLE_VP3054
+	bool "VP-3054 Secondary I2C Bus Support"
+	default y
 	depends on VIDEO_CX88_DVB && DVB_MT352
 	---help---
 	  This adds DVB-T support for cards based on the
@@ -82,6 +82,11 @@ config VIDEO_CX88_VP3054
 	  which also require support for the VP-3054
 	  Secondary I2C bus, such at DNTV Live! DVB-T Pro.
 
+config VIDEO_CX88_VP3054
+	tristate
+	depends on VIDEO_CX88_DVB && VIDEO_CX88_ENABLE_VP3054
+	default y
+
 config VIDEO_CX88_MPEG
 	tristate
 	depends on VIDEO_CX88_DVB || VIDEO_CX88_BLACKBIRD
-- 
1.8.3.1

