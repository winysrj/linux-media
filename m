Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0BWJ1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 04:27:25 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V6 2/2] OMAP2/3: Add V4L2 DSS driver support in device.c
Date: Tue, 23 Feb 2010 14:57:19 +0530
Message-Id: <1266917239-7094-3-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/plat-omap/devices.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 30b5db7..64f2a3a 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -357,6 +357,34 @@ static void omap_init_wdt(void)
 static inline void omap_init_wdt(void) {}
 #endif

+/*---------------------------------------------------------------------------*/
+
+#if defined(CONFIG_VIDEO_OMAP2_VOUT) || \
+	defined(CONFIG_VIDEO_OMAP2_VOUT_MODULE)
+#if defined (CONFIG_FB_OMAP2) || defined (CONFIG_FB_OMAP2_MODULE)
+static struct resource omap_vout_resource[3 - CONFIG_FB_OMAP2_NUM_FBS] = {
+};
+#else
+static struct resource omap_vout_resource[2] = {
+};
+#endif
+
+static struct platform_device omap_vout_device = {
+	.name		= "omap_vout",
+	.num_resources	= ARRAY_SIZE(omap_vout_resource),
+	.resource 	= &omap_vout_resource[0],
+	.id		= -1,
+};
+static void omap_init_vout(void)
+{
+	(void) platform_device_register(&omap_vout_device);
+}
+#else
+static inline void omap_init_vout(void) {}
+#endif
+
+/*---------------------------------------------------------------------------*/
+
 /*
  * This gets called after board-specific INIT_MACHINE, and initializes most
  * on-chip peripherals accessible on this board (except for few like USB):
@@ -387,6 +415,7 @@ static int __init omap_init_devices(void)
 	omap_init_rng();
 	omap_init_uwire();
 	omap_init_wdt();
+	omap_init_vout();
 	return 0;
 }
 arch_initcall(omap_init_devices);
--
1.6.2.4

