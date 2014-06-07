Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56548 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaFGV5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:48 -0400
Received: by mail-pd0-f181.google.com with SMTP id z10so3819629pdj.12
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:47 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 43/43] ARM: imx_v6_v7_defconfig: Enable video4linux drivers
Date: Sat,  7 Jun 2014 14:56:45 -0700
Message-Id: <1402178205-22697-44-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable imx6 staging v4l2 drivers as modules. For video capture on
the SabreAuto, the ADV7180 video decoder also requires the
i2c-mux-gpio and the max7310 port expander.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/configs/imx_v6_v7_defconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 09e9743..cd1099d 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -148,6 +148,7 @@ CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_MXC_RNGA=y
 # CONFIG_I2C_COMPAT is not set
 CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_MUX_GPIO=m
 # CONFIG_I2C_HELPER_AUTO is not set
 CONFIG_I2C_ALGOPCF=m
 CONFIG_I2C_ALGOPCA=m
@@ -156,6 +157,7 @@ CONFIG_SPI=y
 CONFIG_SPI_IMX=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_MC9S08DZ60=y
+CONFIG_GPIO_PCA953X=m
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_IMX2_WDT=y
@@ -238,6 +240,8 @@ CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_MXS_DMA=y
 CONFIG_STAGING=y
+CONFIG_STAGING_MEDIA=y
+CONFIG_VIDEO_IMX6=m
 CONFIG_DRM_IMX=y
 CONFIG_DRM_IMX_FB_HELPER=y
 CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
-- 
1.7.9.5

