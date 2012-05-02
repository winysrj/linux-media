Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48018 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab2EBPQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:16:06 -0400
Received: by qcsd1 with SMTP id d1so570915qcs.35
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:16:04 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v3 03/10] OMAP4: Add base addresses for ISS
Date: Wed,  2 May 2012 10:15:42 -0500
Message-Id: <1335971749-21258-4-git-send-email-saaguirre@ti.com>
In-Reply-To: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NOTE: This isn't the whole list of features that the
ISS supports, but the only ones supported at the moment.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index e433603..2b8cf73 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -19,6 +19,8 @@
 #include <linux/of.h>
 #include <linux/platform_data/omap4-keypad.h>
 
+#include <media/omap4iss.h>
+
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <asm/mach-types.h>
@@ -236,6 +238,36 @@ int omap3_init_camera(struct isp_platform_data *pdata)
 
 #endif
 
+int omap4_init_camera(struct iss_platform_data *pdata, struct omap_board_data *bdata)
+{
+	struct platform_device *pdev;
+	struct omap_hwmod *oh;
+	struct iss_platform_data *omap4iss_pdata;
+	const char *oh_name = "iss";
+	const char *name = "omap4iss";
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("Could not look up %s\n", oh_name);
+		return -ENODEV;
+	}
+
+	omap4iss_pdata = pdata;
+
+	pdev = omap_device_build(name, -1, oh, omap4iss_pdata,
+			sizeof(struct iss_platform_data), NULL, 0, 0);
+
+	if (IS_ERR(pdev)) {
+		WARN(1, "Can't build omap_device for %s:%s.\n",
+						name, oh->name);
+		return PTR_ERR(pdev);
+	}
+
+	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
+
+	return 0;
+}
+
 static inline void omap_init_camera(void)
 {
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
-- 
1.7.5.4

