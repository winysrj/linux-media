Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46861 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab0GUOmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:42:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v2 11/12] omap34xxcam: Register the ISP platform device during omap34xxcam probe
Date: Wed, 21 Jul 2010 16:41:58 +0200
Message-Id: <1279723318-28943-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to properly clean up all resources allocated by the isp-mod
driver, the ISP platform device needs to be unregistered when the
omap34xxcam driver is unloaded.

Move the ISP platform device registration from omap_init_camera to
omap34xxcam_probe. This fixes many memory leaks when unloading and
reloading the omap34xxcam driver.

Platform device registration should be moved back to omap_init_camera
when (if) the omap34xxcam and isp-mod drivers will be merged.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-omap2/devices.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index ae465ce..61e5136 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -144,17 +144,28 @@ static struct resource omap3isp_resources[] = {
 	}
 };
 
+static void omap3isp_release(struct device *dev)
+{
+	/* Zero the device structure to avoid re-initialization complaints from
+	 * kobject when the device will be re-registered.
+	 */
+	memset(dev, 0, sizeof(*dev));
+	dev->release = omap3isp_release;
+}
+
 struct platform_device omap3isp_device = {
 	.name		= "omap3isp",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(omap3isp_resources),
 	.resource	= omap3isp_resources,
+	.dev = {
+		.release	= omap3isp_release,
+	},
 };
 EXPORT_SYMBOL_GPL(omap3isp_device);
 
 static inline void omap_init_camera(void)
 {
-	platform_device_register(&omap3isp_device);
 }
 #else
 static inline void omap_init_camera(void)
-- 
1.7.1

