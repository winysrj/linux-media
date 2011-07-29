Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 56/59] ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
Date: Fri, 29 Jul 2011 12:56:56 +0200
Message-Id: <1311937019-29914-57-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh_mobile_ceu_camera driver has been converted to use the V4L2
subdevice .[gs]_mbus_config() operations, therefore we don't need
SOCAM_* flags for the soc_camera_platform driver anymore. Remove
them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/mach-shmobile/board-mackerel.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 409606b..8f1e8fa 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1211,9 +1211,6 @@ static struct soc_camera_platform_info camera_info = {
 		.width = 640,
 		.height = 480,
 	},
-	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
-	SOCAM_DATA_ACTIVE_HIGH,
 	.mbus_param = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 	V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 	V4L2_MBUS_DATA_ACTIVE_HIGH,
-- 
1.7.2.5

