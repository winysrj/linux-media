Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaEWIuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 04:50:55 -0400
Date: Fri, 23 May 2014 10:50:50 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-media@vger.kernel.org
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] V4L2: soc_camera: add run-time dependencies to
 R-Car VIN driver
Message-ID: <20140523105050.632a9cd2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car Video Input driver is only useful on shmobile unless build
testing.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.15-rc6.orig/drivers/media/platform/soc_camera/Kconfig	2014-05-23 10:35:06.650728184 +0200
+++ linux-3.15-rc6/drivers/media/platform/soc_camera/Kconfig	2014-05-23 10:36:36.373633190 +0200
@@ -47,6 +47,7 @@ config VIDEO_PXA27x
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) support"
 	depends on VIDEO_DEV && SOC_CAMERA
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---


-- 
Jean Delvare
SUSE L3 Support
