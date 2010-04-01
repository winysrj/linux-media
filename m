Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47177 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0DAJ6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 05:58:21 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, mchehab@redhat.com,
	linux-omap@vger.kernel.org, tony@atomide.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/2] OMAP2/3: Add V4L2 DSS driver support in device.c
Date: Thu,  1 Apr 2010 15:28:00 +0530
Message-Id: <1270115880-21404-3-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-omap2/devices.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 18ad931..7aaffe7 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -763,6 +763,33 @@ static inline void omap_hdq_init(void)
 static inline void omap_hdq_init(void) {}
 #endif
 
+/*---------------------------------------------------------------------------*/
+
+#if defined(CONFIG_VIDEO_OMAP2_VOUT) || \
+	defined(CONFIG_VIDEO_OMAP2_VOUT_MODULE)
+#if defined(CONFIG_FB_OMAP2) || defined(CONFIG_FB_OMAP2_MODULE)
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
+	if (platform_device_register(&omap_vout_device) < 0)
+		printk(KERN_ERR "Unable to register OMAP-VOUT device\n");
+}
+#else
+static inline void omap_init_vout(void) {}
+#endif
+
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
@@ -777,6 +804,7 @@ static int __init omap2_init_devices(void)
 	omap_hdq_init();
 	omap_init_sti();
 	omap_init_sha1_md5();
+	omap_init_vout();
 
 	return 0;
 }
-- 
1.6.2.4

