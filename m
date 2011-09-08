Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40589 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1IHNiW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Sep 2011 09:38:22 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <mchehab@infradead.org>,
	<linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<g.liakhovetski@gmx.de>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 8/8] omap2plus_defconfig: Enable tvp514x video decoder support
Date: Thu, 8 Sep 2011 19:08:06 +0530
Message-ID: <1315489086-16413-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables multimedia driver, media controller api,
v4l2-subdev-api, and tvp514x video decoder support
in omap2plus_defconfig.

Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index d5f00d7..10474d4 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -133,6 +133,16 @@ CONFIG_TWL4030_WATCHDOG=y
 CONFIG_REGULATOR_TWL4030=y
 CONFIG_REGULATOR_TPS65023=y
 CONFIG_REGULATOR_TPS6507X=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CONTROLLER=y
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L2_COMMON=y
+CONFIG_VIDEO_ALLOW_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2_SUBDEV_API=y
+CONFIG_VIDEO_MEDIA=y
+CONFIG_VIDEO_TVP514X=y
+CONFIG_VIDEO_OMAP3=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_MODE_HELPERS=y
-- 
1.7.0.4

