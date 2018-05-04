Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64169 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751630AbeEDUtr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 16:49:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, tomi.valkeinen@ti.com,
        linux-omap@vger.kernel.org
Subject: [PATCH] media: include/video/omapfb_dss.h: use IS_ENABLED()
Date: Fri,  4 May 2018 16:49:32 -0400
Message-Id: <8d55f45b6aa36f5c758d191825f14cd31723b371.1525466956.git.mchehab+samsung@kernel.org>
In-Reply-To: <201805050150.CmagcMOg%fengguang.wu@intel.com>
References: <201805050150.CmagcMOg%fengguang.wu@intel.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just checking for ifdefs cause build issues as reported by
kernel test:

config: openrisc-allmodconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)

All errors (new ones prefixed by >>):

   drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_init_connections':
>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:8: error: implicit declaration of function 'omapdss_find_mgr_from_display' [-Werror=implicit-function-declaration]
     mgr = omapdss_find_mgr_from_display(def_dssdev);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     mgr = omapdss_find_mgr_from_display(def_dssdev);
         ^
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_find_default_display':
>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:13: error: implicit declaration of function 'omapdss_get_default_display_name' [-Werror=implicit-function-declaration]
     def_name = omapdss_get_default_display_name();
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:11: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     def_name = omapdss_get_default_display_name();
              ^

So, use IS_ENABLED() instead.

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: tomi.valkeinen@ti.com
Cc: linux-omap@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Fixes: 771f7be87ff9 ("media: omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 include/video/omapfb_dss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/video/omapfb_dss.h b/include/video/omapfb_dss.h
index e9775144ff3b..12755d8d9b4f 100644
--- a/include/video/omapfb_dss.h
+++ b/include/video/omapfb_dss.h
@@ -778,7 +778,7 @@ struct omap_dss_driver {
 
 typedef void (*omap_dispc_isr_t) (void *arg, u32 mask);
 
-#ifdef CONFIG_FB_OMAP2
+#if IS_ENABLED(CONFIG_FB_OMAP2)
 
 enum omapdss_version omapdss_get_version(void);
 bool omapdss_is_initialized(void);
-- 
2.17.0
