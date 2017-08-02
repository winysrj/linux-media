Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50395 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752756AbdHBIyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 8/9] omapdrm: hdmi4: hook up the HDMI CEC support
Date: Wed,  2 Aug 2017 10:54:07 +0200
Message-Id: <20170802085408.16204-9-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hook up the HDMI CEC support in the hdmi4 driver.

It add the CEC irq handler, the CEC (un)init calls and tells the CEC
implementation when the physical address changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/Kconfig  |  8 ++++++++
 drivers/gpu/drm/omapdrm/dss/Makefile |  1 +
 drivers/gpu/drm/omapdrm/dss/hdmi4.c  | 23 ++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/Kconfig b/drivers/gpu/drm/omapdrm/dss/Kconfig
index 8b87d5cf45fc..f24ebf7f61dd 100644
--- a/drivers/gpu/drm/omapdrm/dss/Kconfig
+++ b/drivers/gpu/drm/omapdrm/dss/Kconfig
@@ -65,6 +65,14 @@ config OMAP4_DSS_HDMI
 	help
 	  HDMI support for OMAP4 based SoCs.
 
+config OMAP4_DSS_HDMI_CEC
+	bool "Enable HDMI CEC support for OMAP4"
+	depends on OMAP4_DSS_HDMI
+	select CEC_CORE
+	default y
+	---help---
+	  When selected the HDMI transmitter will support the CEC feature.
+
 config OMAP5_DSS_HDMI
 	bool "HDMI support for OMAP5"
 	default n
diff --git a/drivers/gpu/drm/omapdrm/dss/Makefile b/drivers/gpu/drm/omapdrm/dss/Makefile
index 688195e448c5..6a3a116512f3 100644
--- a/drivers/gpu/drm/omapdrm/dss/Makefile
+++ b/drivers/gpu/drm/omapdrm/dss/Makefile
@@ -14,5 +14,6 @@ omapdss-$(CONFIG_OMAP2_DSS_DSI) += dsi.o
 omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) += hdmi_common.o hdmi_wp.o hdmi_pll.o \
 	hdmi_phy.o
 omapdss-$(CONFIG_OMAP4_DSS_HDMI) += hdmi4.o hdmi4_core.o
+omapdss-$(CONFIG_OMAP4_DSS_HDMI_CEC) += hdmi4_cec.o
 omapdss-$(CONFIG_OMAP5_DSS_HDMI) += hdmi5.o hdmi5_core.o
 ccflags-$(CONFIG_OMAP2_DSS_DEBUG) += -DDEBUG
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index 166aa4df7688..e535010218e6 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -36,9 +36,11 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <sound/omap-hdmi-audio.h>
+#include <media/cec.h>
 
 #include "omapdss.h"
 #include "hdmi4_core.h"
+#include "hdmi4_cec.h"
 #include "dss.h"
 #include "dss_features.h"
 #include "hdmi.h"
@@ -97,6 +99,13 @@ static irqreturn_t hdmi_irq_handler(int irq, void *data)
 	} else if (irqstatus & HDMI_IRQ_LINK_DISCONNECT) {
 		hdmi_wp_set_phy_pwr(wp, HDMI_PHYPWRCMD_LDOON);
 	}
+	if (irqstatus & HDMI_IRQ_CORE) {
+		u32 intr4 = hdmi_read_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4);
+
+		hdmi_write_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4, intr4);
+		if (intr4 & 8)
+			hdmi4_cec_irq(&hdmi->core);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -393,6 +402,8 @@ static void hdmi_display_disable(struct omap_dss_device *dssdev)
 
 	DSSDBG("Enter hdmi_display_disable\n");
 
+	hdmi4_cec_set_phys_addr(&hdmi.core, CEC_PHYS_ADDR_INVALID);
+
 	mutex_lock(&hdmi.lock);
 
 	spin_lock_irqsave(&hdmi.audio_playing_lock, flags);
@@ -493,7 +504,11 @@ static int hdmi_read_edid(struct omap_dss_device *dssdev,
 	}
 
 	r = read_edid(edid, len);
-
+	if (r >= 256)
+		hdmi4_cec_set_phys_addr(&hdmi.core,
+					cec_get_edid_phys_addr(edid, r, NULL));
+	else
+		hdmi4_cec_set_phys_addr(&hdmi.core, CEC_PHYS_ADDR_INVALID);
 	if (need_enable)
 		hdmi4_core_disable(dssdev);
 
@@ -727,6 +742,10 @@ static int hdmi4_bind(struct device *dev, struct device *master, void *data)
 	if (r)
 		goto err;
 
+	r = hdmi4_cec_init(pdev, &hdmi.core, &hdmi.wp);
+	if (r)
+		goto err;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		DSSERR("platform_get_irq failed\n");
@@ -771,6 +790,8 @@ static void hdmi4_unbind(struct device *dev, struct device *master, void *data)
 
 	hdmi_uninit_output(pdev);
 
+	hdmi4_cec_uninit(&hdmi.core);
+
 	hdmi_pll_uninit(&hdmi.pll);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.13.2
