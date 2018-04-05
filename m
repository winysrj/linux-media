Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33590 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbeDERy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 15/16] media: omapfb_dss.h: add stubs to build with COMPILE_TEST
Date: Thu,  5 Apr 2018 13:54:15 -0400
Message-Id: <d3517e25c2b37d3d5f2f61630048a184ce701c58.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add stubs for omapfb_dss.h, in the case it is included by
some driver when CONFIG_FB_OMAP2 is not defined.

That allows building such driver(s) with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/video/omapfb_dss.h | 54 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/video/omapfb_dss.h b/include/video/omapfb_dss.h
index 1d38901d599d..e9775144ff3b 100644
--- a/include/video/omapfb_dss.h
+++ b/include/video/omapfb_dss.h
@@ -774,6 +774,12 @@ struct omap_dss_driver {
 		const struct hdmi_avi_infoframe *avi);
 };
 
+#define for_each_dss_dev(d) while ((d = omap_dss_get_next_device(d)) != NULL)
+
+typedef void (*omap_dispc_isr_t) (void *arg, u32 mask);
+
+#ifdef CONFIG_FB_OMAP2
+
 enum omapdss_version omapdss_get_version(void);
 bool omapdss_is_initialized(void);
 
@@ -785,7 +791,6 @@ void omapdss_unregister_display(struct omap_dss_device *dssdev);
 
 struct omap_dss_device *omap_dss_get_device(struct omap_dss_device *dssdev);
 void omap_dss_put_device(struct omap_dss_device *dssdev);
-#define for_each_dss_dev(d) while ((d = omap_dss_get_next_device(d)) != NULL)
 struct omap_dss_device *omap_dss_get_next_device(struct omap_dss_device *from);
 struct omap_dss_device *omap_dss_find_device(void *data,
 		int (*match)(struct omap_dss_device *dssdev, void *data));
@@ -826,7 +831,6 @@ int omapdss_default_get_recommended_bpp(struct omap_dss_device *dssdev);
 void omapdss_default_get_timings(struct omap_dss_device *dssdev,
 		struct omap_video_timings *timings);
 
-typedef void (*omap_dispc_isr_t) (void *arg, u32 mask);
 int omap_dispc_register_isr(omap_dispc_isr_t isr, void *arg, u32 mask);
 int omap_dispc_unregister_isr(omap_dispc_isr_t isr, void *arg, u32 mask);
 
@@ -856,5 +860,51 @@ omapdss_of_get_first_endpoint(const struct device_node *parent);
 
 struct omap_dss_device *
 omapdss_of_find_source_for_first_ep(struct device_node *node);
+#else
+
+static inline enum omapdss_version omapdss_get_version(void)
+{ return OMAPDSS_VER_UNKNOWN; };
+
+static inline bool omapdss_is_initialized(void)
+{ return false; };
+
+static inline int omap_dispc_register_isr(omap_dispc_isr_t isr,
+					  void *arg, u32 mask)
+{ return 0; };
+
+static inline int omap_dispc_unregister_isr(omap_dispc_isr_t isr,
+					    void *arg, u32 mask)
+{ return 0; };
+
+static inline struct omap_dss_device
+*omap_dss_get_device(struct omap_dss_device *dssdev)
+{ return NULL; };
+
+static inline struct omap_dss_device
+*omap_dss_get_next_device(struct omap_dss_device *from)
+{return NULL; };
+
+static inline void omap_dss_put_device(struct omap_dss_device *dssdev) {};
+
+static inline int omapdss_compat_init(void)
+{ return 0; };
+
+static inline void omapdss_compat_uninit(void) {};
+
+static inline int omap_dss_get_num_overlay_managers(void)
+{ return 0; };
+
+static inline struct omap_overlay_manager *omap_dss_get_overlay_manager(int num)
+{ return NULL; };
+
+static inline int omap_dss_get_num_overlays(void)
+{ return 0; };
+
+static inline struct omap_overlay *omap_dss_get_overlay(int num)
+{ return NULL; };
+
+
+#endif /* FB_OMAP2 */
+
 
 #endif /* __OMAPFB_DSS_H */
-- 
2.14.3
