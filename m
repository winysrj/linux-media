Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44298 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbcCCBwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 20:52:31 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] media: sh_mobile_ceu_camera, rcar_vin: Use ARCH_RENESAS
Date: Thu,  3 Mar 2016 10:52:15 +0900
Message-Id: <1456969935-31879-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.

This is part of an ongoing process to migrate from ARCH_SHMOBILE to
ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/media/platform/soc_camera/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

 Based on media-tree/master

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f2776cd415ca..20ad48458cff 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -36,7 +36,7 @@ config VIDEO_PXA27x
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) support"
 	depends on VIDEO_DEV && SOC_CAMERA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
@@ -53,7 +53,7 @@ config VIDEO_SH_MOBILE_CSI2
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
-	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
+	depends on ARCH_RENESAS || SUPERH || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
-- 
2.1.4

