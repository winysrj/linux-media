Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:58391 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLONzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 08:55:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RESEND] [media] VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG
Date: Mon, 15 Dec 2014 14:55:37 +0100
Message-Id: <1418651737-10016-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If VIDEO_CAFE_CCIC=y, but VIDEOBUF2_DMA_SG=m:

drivers/built-in.o: In function `mcam_v4l_open':
mcam-core.c:(.text+0x1c2e81): undefined reference to `vb2_dma_sg_memops'
mcam-core.c:(.text+0x1c2eb0): undefined reference to `vb2_dma_sg_init_ctx'
drivers/built-in.o: In function `mcam_v4l_release':
mcam-core.c:(.text+0x1c34bf): undefined reference to `vb2_dma_sg_cleanup_ctx'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is a resend of a patch from 2013-09-30. It's still valid.

 drivers/media/platform/marvell-ccic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 6265d36adcebcb89..3d166568bd6955bd 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_CAFE_CCIC
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
-- 
1.9.1

