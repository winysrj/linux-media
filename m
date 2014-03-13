Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49138 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaCMRTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 13:19:05 -0400
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH 12/12] ARM: imx_v6_v7_defconfig: Add more drm drivers.
Date: Thu, 13 Mar 2014 18:17:33 +0100
Message-Id: <1394731053-6118-12-git-send-email-denis@eukrea.com>
In-Reply-To: <1394731053-6118-1-git-send-email-denis@eukrea.com>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRM_PANEL_SIMPLE is needed by the eukrea
mbimxsd51's displays.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
- New patch, splitting it would be overkill.
---
 arch/arm/configs/imx_v6_v7_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 09e9743..0316926 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -183,6 +183,7 @@ CONFIG_V4L_MEM2MEM_DRIVERS=y
 CONFIG_VIDEO_CODA=y
 CONFIG_SOC_CAMERA_OV2640=y
 CONFIG_DRM=y
+CONFIG_DRM_PANEL_SIMPLE=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
@@ -245,6 +246,7 @@ CONFIG_DRM_IMX_TVE=y
 CONFIG_DRM_IMX_LDB=y
 CONFIG_DRM_IMX_IPUV3_CORE=y
 CONFIG_DRM_IMX_IPUV3=y
+CONFIG_DRM_IMX_HDMI=y
 CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_PWM=y
-- 
1.7.9.5

