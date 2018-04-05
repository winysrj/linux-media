Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35304 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbeDEU36 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2 15/19] omap2: omapfb: allow building it with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:42 -0400
Message-Id: <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver builds cleanly with COMPILE_TEST, and it is
needed in order to allow building drivers/media omap2
driver.

So, change the logic there to allow building it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/video/fbdev/omap2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/Kconfig b/drivers/video/fbdev/omap2/Kconfig
index 0921c4de8407..82008699d253 100644
--- a/drivers/video/fbdev/omap2/Kconfig
+++ b/drivers/video/fbdev/omap2/Kconfig
@@ -1,4 +1,4 @@
-if ARCH_OMAP2PLUS
+if ARCH_OMAP2PLUS || COMPILE_TEST
 
 source "drivers/video/fbdev/omap2/omapfb/Kconfig"
 
-- 
2.14.3
