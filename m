Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 32/35] [media] enable COMPILE_TEST for OMAP2 vout
Date: Tue, 26 Aug 2014 18:55:08 -0300
Message-Id: <1409090111-8290-33-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need anything special to enable COMPILE_TEST for
this driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/Makefile     | 2 +-
 drivers/media/platform/omap/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 4ac4c91b4415..b598b3bb2645 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -49,6 +49,6 @@ obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
 obj-y	+= davinci/
 
-obj-$(CONFIG_ARCH_OMAP)	+= omap/
+obj-y	+= omap/
 
 ccflags-y += -I$(srctree)/drivers/media/i2c
diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index 37ad446b35b3..2253bf102ed9 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_OMAP2_VOUT_VRFB
 
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
-	depends on ARCH_OMAP2 || ARCH_OMAP3
+	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS if HAS_IOMEM && ARCH_OMAP2PLUS
-- 
1.9.3

