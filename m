Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2CIMPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:15:49 -0500
Received: by ghrr11 with SMTP id r11so782184ghr.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 04:15:48 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de,
	javier.martin@vista-silicon.com, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] video: Kconfig: Select VIDEOBUF2_DMA_CONTIG for VIDEO_MX2 
Date: Fri,  9 Mar 2012 09:15:38 -0300
Message-Id: <1331295338-21065-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build error:

LD      .tmp_vmlinux1
drivers/built-in.o: In function `mx2_camera_init_videobuf':
clkdev.c:(.text+0xcfaf4): undefined reference to `vb2_dma_contig_memops'
drivers/built-in.o: In function `mx2_camera_probe':
clkdev.c:(.devinit.text+0x5734): undefined reference to `vb2_dma_contig_init_ctx'
clkdev.c:(.devinit.text+0x5778): undefined reference to `vb2_dma_contig_cleanup_ctx'
drivers/built-in.o: In function `mx2_camera_remove':
clkdev.c:(.devexit.text+0x89c): undefined reference to `vb2_dma_contig_cleanup_ctx'

commit c6a41e3271 ([media] media i.MX27 camera: migrate driver to videobuf2)
missed to select VIDEOBUF2_DMA_CONTIG in Kconfig.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6158073..5c728ec 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1087,7 +1087,7 @@ config VIDEO_MX2_HOSTSUPPORT
 config VIDEO_MX2
 	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_MX2_HOSTSUPPORT
 	---help---
 	  This is a v4l2 driver for the i.MX27 and the i.MX25 Camera Sensor
-- 
1.7.1

