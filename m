Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45674 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbeDEU3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 16/19] media: omap: allow building it with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:43 -0400
Message-Id: <01d225b90acc34463a59ad06e16461824e72e1dd.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have stubs for omap FB driver, let it build with
COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index e8e2db181a7a..27343376f557 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -1,15 +1,15 @@
 config VIDEO_OMAP2_VOUT_VRFB
 	bool
+	default y
+	depends on VIDEO_OMAP2_VOUT && (OMAP2_VRFB || COMPILE_TEST)
 
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
-	depends on MMU
-	depends on ARCH_OMAP2 || ARCH_OMAP3
-	depends on FB_OMAP2
+	depends on MMU && FB_OMAP2
+	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
-	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	select FRAME_VECTOR
 	default n
 	---help---
-- 
2.14.3
