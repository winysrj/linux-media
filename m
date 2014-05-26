Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaEZNRh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 09:17:37 -0400
Date: Mon, 26 May 2014 15:17:32 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] [media] V4L2: soc_camera: Add run-time dependencies to
 sh_mobile drivers
Message-ID: <20140526151732.2d93a7df@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh_mobile_ceu_camera and sh_mobile_csi2 drivers are only useful on
SuperH and shmobile unless build testing.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-3.15-rc7.orig/drivers/media/platform/soc_camera/Kconfig	2014-05-26 11:20:33.068949368 +0200
+++ linux-3.15-rc7/drivers/media/platform/soc_camera/Kconfig	2014-05-26 14:55:00.964804110 +0200
@@ -56,12 +56,14 @@ config VIDEO_RCAR_VIN
 config VIDEO_SH_MOBILE_CSI2
 	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	---help---
 	  This is a v4l2 driver for the SuperH MIPI CSI-2 Interface
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---


-- 
Jean Delvare
SUSE L3 Support
