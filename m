Return-path: <linux-media-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:55100 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbeERKv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 06:51:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] [media] v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS
Date: Fri, 18 May 2018 12:51:23 +0200
Message-Id: <1526640683-32570-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Renesas Fine Display Processor driver is used on Renesas R-Car SoCs
only.  Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce
ARCH_RENESAS") is ARCH_RENESAS a more appropriate platform dependency
than the legacy ARCH_SHMOBILE, hence use the former.

This will allow to drop ARCH_SHMOBILE on ARM and ARM64 in the near
future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
---
v2:
  - Add Acked-by, Reviewed-by.
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 840475e3a6b87ac1..a0fe7b127412d3e1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -397,7 +397,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
2.7.4
