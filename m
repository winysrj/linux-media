Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39461 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbcCHBEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 20:04:00 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v2] media: rcar_vin: Use ARCH_RENESAS
Date: Tue,  8 Mar 2016 10:03:55 +0900
Message-Id: <1457399035-14527-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.

This is part of an ongoing process to migrate from ARCH_SHMOBILE to
ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

---
Based on media-tree/next

v2
* Break out of a (slightly) larger patch
---
 drivers/media/platform/soc_camera/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 355298989dd8..08db3b040bbe 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -28,7 +28,7 @@ config VIDEO_PXA27x
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) support"
 	depends on VIDEO_DEV && SOC_CAMERA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
-- 
2.1.4

