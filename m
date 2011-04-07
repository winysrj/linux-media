Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36415 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1DGIuw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 04:50:52 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of VIDEOBUF_DMA_CONTIG
Date: Thu,  7 Apr 2011 10:50:43 +0200
Message-Id: <1302166243-650-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since commit

	379fa5d ([media] V4L: mx3_camera: convert to videobuf2)

mx3_camera uses videobuf2, but that commit didn't upgrade the select
resulting in the following build failure:

	drivers/built-in.o: In function `mx3_camera_init_videobuf':
	clkdev.c:(.text+0x86580): undefined reference to `vb2_dma_contig_memops'
	drivers/built-in.o: In function `mx3_camera_probe':
	clkdev.c:(.devinit.text+0x3548): undefined reference to `vb2_dma_contig_init_ctx'
	clkdev.c:(.devinit.text+0x3578): undefined reference to `vb2_dma_contig_cleanup_ctx'
	drivers/built-in.o: In function `mx3_camera_remove':
	clkdev.c:(.devexit.text+0x674): undefined reference to `vb2_dma_contig_cleanup_ctx'
	make[2]: *** [.tmp_vmlinux1] Error 1
	make[1]: *** [sub-make] Error 2
	make: *** [all] Error 2

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

does someone has a hint how to fix gcc not to believe the undefined
references to be in clkdev.c?

Best regards
Uwe

 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4498b94..00f51dd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -875,7 +875,7 @@ config MX3_VIDEO
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	select MX3_VIDEO
 	---help---
 	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
-- 
1.7.2.3

