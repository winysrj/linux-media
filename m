Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34794 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753131AbeDFPd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 11:33:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 2/2] media: omapfb: relax compilation if COMPILE_TEST
Date: Fri,  6 Apr 2018 11:33:20 -0400
Message-Id: <c318fd1c9f79995c6c2e4e82ca99ff494b2afb7b.1523028795.git.mchehab@s-opensource.com>
In-Reply-To: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com>
References: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com>
In-Reply-To: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com>
References: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dependency of DRM_OMAP = n can be relaxed for just
compilation test.

This allows building the omap3isp driver with allyesconfig
on ARM.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/video/fbdev/omap2/omapfb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/Kconfig b/drivers/video/fbdev/omap2/omapfb/Kconfig
index e6226aeed17e..e42794a5e26c 100644
--- a/drivers/video/fbdev/omap2/omapfb/Kconfig
+++ b/drivers/video/fbdev/omap2/omapfb/Kconfig
@@ -4,7 +4,7 @@ config OMAP2_VRFB
 menuconfig FB_OMAP2
         tristate "OMAP2+ frame buffer support"
         depends on FB
-        depends on DRM_OMAP = n
+        depends on DRM_OMAP = n || COMPILE_TEST
 
         select FB_OMAP2_DSS
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
-- 
2.14.3
