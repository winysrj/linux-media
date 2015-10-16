Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:60105 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbbJPU1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 16:27:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: [PATCH] [media] sh-vou: clarify videobuf2 dependency
Date: Fri, 16 Oct 2015 22:27:29 +0200
Message-ID: <9667468.98avsAXYlo@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh-vou driver has been converted from videobuf to videobuf2, but
the Kconfig file still lists VIDEOBUF_DMA_CONTIG as a dependency.
Consequently we can build the driver without VIDEOBUF2_DMA_CONTIG
and get a link error:

drivers/built-in.o: In function `sh_vou_probe':
vf610-ocotp.c:(.text+0x2dbf5c): undefined reference to `vb2_dma_contig_init_ctx'
vf610-ocotp.c:(.text+0x2dc0b4): undefined reference to `vb2_dma_contig_cleanup_ctx'
vf610-ocotp.c:(.text+0x2dc144): undefined reference to `vb2_dma_contig_memops'
drivers/built-in.o: In function `sh_vou_remove':
vf610-ocotp.c:(.text+0x2dc190): undefined reference to `vb2_dma_contig_cleanup_ctx'

This changes the dependency to VIDEOBUF2_DMA_CONTIG instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 57af3ad59d95 ("[media] sh-vou: convert to vb2")
---
Found on ARM randconfig tests

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f88a6cfb7086..3ddf72f2d844 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -38,7 +38,7 @@ config VIDEO_SH_VOU
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on VIDEO_DEV && I2C && HAS_DMA
 	depends on ARCH_SHMOBILE || COMPILE_TEST
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Support for the Video Output Unit (VOU) on SuperH SoCs.
 

