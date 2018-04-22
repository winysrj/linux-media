Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54156 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbeDVK2p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 06:28:45 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/3] v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS
Date: Sun, 22 Apr 2018 13:28:47 +0300
Message-Id: <20180422102849.2481-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Geert Uytterhoeven <geert+renesas@glider.be>

The Renesas Fine Display Processor driver is used on Renesas R-Car SoCs
only.  Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce
ARCH_RENESAS") is ARCH_RENESAS a more appropriate platform dependency
than the legacy ARCH_SHMOBILE, hence use the former.

This will allow to drop ARCH_SHMOBILE on ARM and ARM64 in the near
future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7a1cf8a1b01..621d63b2001d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -396,7 +396,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
Regards,

Laurent Pinchart
