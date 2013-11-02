Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 08/29] cx18: disable compilation on frv arch
Date: Sat,  2 Nov 2013 11:31:16 -0200
Message-Id: <1383399097-11615-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver produces a lot of errors on this arch:
	In file included from drivers/media/pci/cx18/cx18-driver.c:26:0:
	/drivers/media/pci/cx18/cx18-io.h: In function 'cx18_raw_readl':
	drivers/media/pci/cx18/cx18-io.h:40:2: warning: passing argument 1 of '__builtin_read32' discards 'const' qualifier from pointer target type [enabled by default]
	arch/frv/include/asm/mb-regs.h:24:15: note: expected 'volatile void *' but argument is of type 'const void *'
	...
While this is not fixed, just disable it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx18/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx18/Kconfig b/drivers/media/pci/cx18/Kconfig
index c675b83c43a9..10e6bc72c460 100644
--- a/drivers/media/pci/cx18/Kconfig
+++ b/drivers/media/pci/cx18/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C
+	depends on !FRV
 	select I2C_ALGOBIT
 	select VIDEOBUF_VMALLOC
 	depends on RC_CORE
-- 
1.8.3.1

