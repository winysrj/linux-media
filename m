Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3KENDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:52 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 29/29] [media] cx18: disable compilation on frv arch
Date: Tue,  5 Nov 2013 08:01:42 -0200
Message-Id: <1383645702-30636-30-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
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

NOTE: I'll likely remove this patch from the final series, as this should
be fixed inside gcc code.

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

