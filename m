Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTUMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 16:12:06 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/5] [media] enable COMPILE_TEST for OMAP2 vout
Date: Wed, 20 Aug 2014 15:11:56 -0500
Message-Id: <1408565517-22034-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
References: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
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
index e5269da91906..72a02e913c3a 100644
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

