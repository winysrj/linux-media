Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54300 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaFGV5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:01 -0400
Received: by mail-pd0-f179.google.com with SMTP id fp1so3840915pdb.38
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:00 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 01/43] imx-drm: ipu-v3: Move imx-ipu-v3.h to include/linux/platform_data/
Date: Sat,  7 Jun 2014 14:56:03 -0700
Message-Id: <1402178205-22697-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In subsequent patches, the video capture units will be added (csi, smfc,
ic, irt). So the IPU prototypes are no longer needed only by imx-drm,
so we need to export them to a common include path.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/imx-hdmi.c                 |    2 +-
 drivers/staging/imx-drm/imx-tve.c                  |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h           |    2 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    2 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |    2 +-
 .../linux/platform_data}/imx-ipu-v3.h              |    9 +++++----
 11 files changed, 15 insertions(+), 14 deletions(-)
 rename {drivers/staging/imx-drm/ipu-v3 => include/linux/platform_data}/imx-ipu-v3.h (99%)

diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index d47dedd..f0710a4 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -28,7 +28,7 @@
 #include <drm/drm_edid.h>
 #include <drm/drm_encoder_slave.h>
 
-#include "ipu-v3/imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "imx-hdmi.h"
 #include "imx-drm.h"
 
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a23f4f7..8b91588 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -31,7 +31,7 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_crtc_helper.h>
 
-#include "ipu-v3/imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "imx-drm.h"
 
 #define TVE_COM_CONF_REG	0x00
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index ca85d3d..2aca7dd 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -31,7 +31,7 @@
 
 #include <drm/drm_fourcc.h>
 
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
 static inline u32 ipu_cm_read(struct ipu_soc *ipu, unsigned offset)
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index d5de8bb..e86010b 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -21,7 +21,7 @@
 #include <linux/io.h>
 
 #include "../imx-drm.h"
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
 #define DC_MAP_CONF_PTR(n)	(0x108 + ((n) & ~0x1) * 2)
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 82a9eba..1e54c00 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -20,7 +20,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
 struct ipu_di {
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
index 4521301..3c24111 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
@@ -17,7 +17,7 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
 #define DMFC_RD_CHAN		0x0000
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 58f87c8..27d9a81 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -19,7 +19,7 @@
 #include <linux/io.h>
 #include <linux/err.h>
 
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
 #define DP_SYNC 0
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 4df0050..40211f6 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -22,7 +22,7 @@ struct ipu_soc;
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 
-#include "imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 
 #define IPUV3_CHANNEL_CSI0			 0
 #define IPUV3_CHANNEL_CSI1			 1
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index c48f640..9b707aa 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -30,7 +30,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 
-#include "ipu-v3/imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "imx-drm.h"
 #include "ipuv3-plane.h"
 
diff --git a/drivers/staging/imx-drm/ipuv3-plane.c b/drivers/staging/imx-drm/ipuv3-plane.c
index 27a8d73..e9e4e7a 100644
--- a/drivers/staging/imx-drm/ipuv3-plane.c
+++ b/drivers/staging/imx-drm/ipuv3-plane.c
@@ -17,7 +17,7 @@
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_gem_cma_helper.h>
 
-#include "ipu-v3/imx-ipu-v3.h"
+#include <linux/platform_data/imx-ipu-v3.h>
 #include "ipuv3-plane.h"
 
 #define to_ipu_plane(x)	container_of(x, struct ipu_plane, base)
diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
similarity index 99%
rename from drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
rename to include/linux/platform_data/imx-ipu-v3.h
index c4d14ea..c083a2a 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -9,8 +9,8 @@
  * http://www.gnu.org/copyleft/lgpl.html
  */
 
-#ifndef __DRM_IPU_H__
-#define __DRM_IPU_H__
+#ifndef __IMX_IPU_H__
+#define __IMX_IPU_H__
 
 #include <linux/types.h>
 #include <linux/videodev2.h>
@@ -230,7 +230,8 @@ struct ipu_ch_param {
 	struct ipu_cpmem_word word[2];
 };
 
-void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base, u32 wbs, u32 v);
+void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base,
+			      u32 wbs, u32 v);
 u32 ipu_ch_param_read_field(struct ipu_ch_param __iomem *base, u32 wbs);
 struct ipu_ch_param __iomem *ipu_get_cpmem(struct ipuv3_channel *channel);
 void ipu_ch_param_dump(struct ipu_ch_param __iomem *p);
@@ -323,4 +324,4 @@ struct ipu_client_platformdata {
 	int dma[2];
 };
 
-#endif /* __DRM_IPU_H__ */
+#endif /* __IMX_IPU_H__ */
-- 
1.7.9.5

