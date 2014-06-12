Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 07/26] imx-drm: currently only IPUv3 is supported, make it mandatory
Date: Thu, 12 Jun 2014 19:06:21 +0200
Message-Id: <1402592800-2925-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As long as only IPUv3 is supported in imx-drm, hide the separate
DRM_IMX_IPUV3 option and make DRM_IMX depend on IMX_IPUV3_CORE.

Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 82fb758..ab31848 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -6,6 +6,7 @@ config DRM_IMX
 	select DRM_GEM_CMA_HELPER
 	select DRM_KMS_CMA_HELPER
 	depends on DRM && (ARCH_MXC || ARCH_MULTIPLATFORM)
+	depends on IMX_IPUV3_CORE
 	help
 	  enable i.MX graphics support
 
@@ -40,11 +41,11 @@ config DRM_IMX_LDB
 	  found on i.MX53 and i.MX6 processors.
 
 config DRM_IMX_IPUV3
-	tristate "DRM Support for i.MX IPUv3"
+	tristate
 	depends on DRM_IMX
 	depends on IMX_IPUV3_CORE
-	help
-	  Choose this if you have a i.MX5 or i.MX6 processor.
+	default y if DRM_IMX=y
+	default m if DRM_IMX=m
 
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
-- 
2.0.0.rc2

