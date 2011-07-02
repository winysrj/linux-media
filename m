Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3204 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1GBJQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 05:16:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Missing 'select VIDEOBUF2_DMA_CONTIG'
Date: Sat, 2 Jul 2011 11:16:44 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021116.44556.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jon,

I get this error when compiling the latest for_v3.1 media_tree:

Kernel: arch/x86/boot/bzImage is ready  (#400)
ERROR: "vb2_dma_contig_init_ctx" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
ERROR: "vb2_dma_contig_cleanup_ctx" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
ERROR: "vb2_dma_contig_memops" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

I think this is missing:

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index 22314a0..68ff5d6 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_CAFE_CCIC
 	depends on PCI && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-

Can you confirm this?

Regards,

	Hans
