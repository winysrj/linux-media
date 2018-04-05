Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33590 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbeDERyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 16/16] media: omap: allow building it with COMPILE_TEST
Date: Thu,  5 Apr 2018 13:54:16 -0400
Message-Id: <debd2bac93a5a1cb58232d50e9d4127e547839d7.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have stubs for omap FB driver, let it build with
COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index e8e2db181a7a..e6b486c5ddfc 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -4,11 +4,11 @@ config VIDEO_OMAP2_VOUT_VRFB
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on MMU
-	depends on ARCH_OMAP2 || ARCH_OMAP3
-	depends on FB_OMAP2
+	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
+	depends on FB_OMAP2 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
+	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	select FRAME_VECTOR
 	default n
-- 
2.14.3
