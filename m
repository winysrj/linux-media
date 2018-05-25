Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936185AbeEYP0s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:26:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] media: omap2: fix compile-testing with FB_OMAP2=m
Date: Fri, 25 May 2018 17:25:12 +0200
Message-Id: <20180525152523.2821369-5-arnd@arndb.de>
In-Reply-To: <20180525152523.2821369-1-arnd@arndb.de>
References: <20180525152523.2821369-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compile-testing with FB_OMAP2=m results in a link error:

drivers/media/platform/omap/omap_vout.o: In function `vidioc_streamoff':
omap_vout.c:(.text+0x1028): undefined reference to `omap_dispc_unregister_isr'
drivers/media/platform/omap/omap_vout.o: In function `omap_vout_release':
omap_vout.c:(.text+0x1330): undefined reference to `omap_dispc_unregister_isr'
drivers/media/platform/omap/omap_vout.o: In function `vidioc_streamon':
omap_vout.c:(.text+0x2dd4): undefined reference to `omap_dispc_register_isr'
drivers/media/platform/omap/omap_vout.o: In function `omap_vout_remove':

In order to enable compile-testing but still keep the correct dependency,
this changes the Kconfig logic so we only allow CONFIG_COMPILE_TEST
building when FB_OMAP is completely disabled, or have use the old
dependency on FB_OMAP to ensure VIDEO_OMAP2_VOUT is also a loadable
module when FB_OMAP2 is.

Fixes: d8555fd2f452 ("media: omap2: allow building it with COMPILE_TEST && DRM_OMAP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index a414bcbb9b08..d827b6c285a6 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_OMAP2_VOUT_VRFB
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on MMU
-	depends on FB_OMAP2 || COMPILE_TEST
+	depends on FB_OMAP2 || (COMPILE_TEST && FB_OMAP2=n)
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-- 
2.9.0
