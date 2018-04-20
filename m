Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51855 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753499AbeDTRm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 13:42:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/7] media: omap2: allow building it with COMPILE_TEST && DRM_OMAP
Date: Fri, 20 Apr 2018 13:42:52 -0400
Message-Id: <85d08ef6577cf0c87e197901dc7236a3ceb114f5.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that FB_OMAP has stubs, the omap2 media drivers can be
built on ARM with COMPILE_TEST && DRM_OMAP.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index 27343376f557..a414bcbb9b08 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -5,7 +5,8 @@ config VIDEO_OMAP2_VOUT_VRFB
 
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
-	depends on MMU && FB_OMAP2
+	depends on MMU
+	depends on FB_OMAP2 || COMPILE_TEST
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-- 
2.14.3
