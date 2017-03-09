Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44067 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdCIUI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 15:08:28 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 1/3] [media] platform: compile VIDEO_CODA with COMPILE_TEST
Date: Thu,  9 Mar 2017 17:08:16 -0300
Message-Id: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, IMX_VDOA and VIDEO_CODA only builds on ARCH_MXC.

That prevented me to build-test the driver, causing a bad patch
to be applied, and to see other warnings on this driver.

Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c9106e105bab..6d0bba271a8d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -151,7 +151,7 @@ if V4L_MEM2MEM_DRIVERS
 
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
-	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
+	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
 	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.9.3
