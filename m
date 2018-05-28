Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51853 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932514AbeE1P57 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 11:57:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: marvel-ccic: mmp: select VIDEOBUF2_VMALLOC/DMA_CONTIG
Date: Mon, 28 May 2018 17:57:00 +0200
Message-Id: <20180528155750.2932996-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testing randconfig builds after the return of the mmp ccic driver shows
a link error in some configurations:

drivers/media/platform/marvell-ccic/mcam-core.o: In function `mccic_register':
mcam-core.c:(.text+0x2e48): undefined reference to `vb2_dma_contig_memops'

A closer look at the mcam-core.c file reveals that we need to select
both VIDEOBUF2_DMA_CONTIG and VIDEOBUF2_VMALLOC, as already do for
VIDEO_CAFE_CCIC.

Fixes: 0a9c643c8faa ("media: marvel-ccic: re-enable mmp-driver build")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/marvell-ccic/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 21dacef7c2fc..13cc6f2159d3 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -18,6 +18,8 @@ config VIDEO_MMP_CAMERA
 	depends on ARCH_MMP || COMPILE_TEST
 	select VIDEO_OV7670
 	select I2C_GPIO
+	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
-- 
2.9.0
