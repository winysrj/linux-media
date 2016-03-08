Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39469 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbcCHBEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 20:04:04 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v2] media: sh_mobile_ceu_camera: Remove dependency on SUPERH
Date: Tue,  8 Mar 2016 10:03:58 +0900
Message-Id: <1457399038-14573-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A dependency on ARCH_SHMOBILE seems to be the best option for
sh_mobile_ceu_camera:

* For Super H based SoCs: sh_mobile_ceu is used on SH_AP325RXA, SH_ECOVEC,
  SH_KFR2R09, SH_MIGOR, and SH_7724_SOLUTION_ENGINE which depend on
  CPU_SUBTYPE_SH7722, CPU_SUBTYPE_SH7723, or CPU_SUBTYPE_SH7724 which all
  select ARCH_SHMOBILE.

* For ARM Based SoCs: Since the removal of legacy (non-multiplatform)
  support this driver has not been used by any Renesas ARM based SoCs.
  The Renesas ARM based SoCs currently select ARCH_SHMOBILE, however,
  it is planned that this will no longer be the case.

This is part of an ongoing process to migrate from ARCH_SHMOBILE to
ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.

Thanks to Geert Uytterhoeven for analysis and portions of the
change log text.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

--
Based on media-tree/next

v2
* Break out of a (slightly) larger patch
* Re-work to drop SUPERH dependency rather than replacing
  ARCH_SHMOBILE with ARCH_RENESAS.
---
 drivers/media/platform/soc_camera/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 08db3b040bbe..83029a4854ae 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -45,7 +45,7 @@ config VIDEO_SH_MOBILE_CSI2
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
-	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
-- 
2.1.4

