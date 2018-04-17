Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41385 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbeDQKUZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 06:20:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/5] media: omap3isp: Enable driver compilation on ARM with COMPILE_TEST
Date: Tue, 17 Apr 2018 06:20:12 -0400
Message-Id: <0439e38ed2046f219bf931fb05fde7da423b5cf6.1523960171.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523960171.git.mchehab@s-opensource.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523960171.git.mchehab@s-opensource.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The omap3isp driver can't be compiled on non-ARM platforms but has no
compile-time dependency on OMAP. It however requires common clock
framework support, which isn't provided by all ARM platforms.

Drop the OMAP dependency when COMPILE_TEST is set and add ARM and
COMMON_CLK dependencies.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 91b0c7324afb..1ee915b794c0 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -62,7 +62,10 @@ config VIDEO_MUX
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on ARCH_OMAP3 || COMPILE_TEST
+	depends on ARM
+	depends on COMMON_CLK
 	depends on HAS_DMA && OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
-- 
2.14.3
