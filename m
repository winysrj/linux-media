Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34194 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbcGFXL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:11:26 -0400
Received: by mail-pf0-f194.google.com with SMTP id 66so107986pfy.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:11:25 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 28/28] ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
Date: Wed,  6 Jul 2016 16:11:17 -0700
Message-Id: <1467846677-13265-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846677-13265-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846677-13265-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable imx v4l2 staging drivers. For video capture on
the SabreAuto, the ADV7180 video decoder also requires the
i2c-mux-gpio and the max7310 port expander.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 21339ce..8b1590a 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -327,6 +327,8 @@ CONFIG_FSL_EDMA=y
 CONFIG_IMX_SDMA=y
 CONFIG_MXS_DMA=y
 CONFIG_STAGING=y
+CONFIG_STAGING_MEDIA=y
+CONFIG_VIDEO_IMX=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_IIO=y
 CONFIG_VF610_ADC=y
-- 
1.9.1

