Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:44569 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbbANCnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 21:43:01 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <devicetree@vger.kernel.org>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
	<galak@codeaurora.org>, <rob@landley.net>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<voice.shen@atmel.com>, <g.liakhovetski@gmx.de>,
	<laurent.pinchart@ideasonboard.com>, <linux-media@vger.kernel.org>,
	<plagnioj@jcrosoft.com>, <alexandre.belloni@free-electrons.com>,
	<boris.brezillon@free-electrons.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 8/8] ARM: at91: sama5: enable atmel-isi and ov2640 in defconfig
Date: Wed, 14 Jan 2015 10:41:55 +0800
Message-ID: <1421203315-27619-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1421203315-27619-1-git-send-email-josh.wu@atmel.com>
References: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
 <1421203315-27619-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/sama5_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index b58fb32..92f1d71 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -139,6 +139,12 @@ CONFIG_POWER_RESET=y
 CONFIG_SSB=m
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_ACT8865=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_V4L_PLATFORM_DRIVERS=y
+CONFIG_SOC_CAMERA=y
+CONFIG_SOC_CAMERA_OV2640=y
+CONFIG_VIDEO_ATMEL_ISI=y
 CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-- 
1.9.1

