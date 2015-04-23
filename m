Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:34112 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030699AbbDWSJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 14:09:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] Input: TOUCHSCREEN_SUR40 should depend on HAS_DMA
Date: Thu, 23 Apr 2015 20:09:07 +0200
Message-Id: <1429812547-9640-3-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1429812547-9640-1-git-send-email-geert@linux-m68k.org>
References: <1429812547-9640-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (TOUCHSCREEN_SUR40 && VIDEO_TW68 && VIDEO_CX23885 && VIDEO_CX25821 && VIDEO_CX88 && VIDEO_SAA7134) selects VIDEOBUF2_DMA_SG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    ERROR: "dma_unmap_sg" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!
    ERROR: "dma_map_sg" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!
    ERROR: "dma_sync_sg_for_cpu" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!

TOUCHSCREEN_SUR40 selects VIDEOBUF2_DMA_SG, which bypasses its
dependency on HAS_DMA.  Make TOUCHSCREEN_SUR40 depend on HAS_DMA to fix
this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/touchscreen/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index b0a94cdd96add5c9..4591389108f0057b 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -979,8 +979,7 @@ config TOUCHSCREEN_SUN4I
 
 config TOUCHSCREEN_SUR40
 	tristate "Samsung SUR40 (Surface 2.0/PixelSense) touchscreen"
-	depends on USB
-	depends on MEDIA_USB_SUPPORT
+	depends on USB && MEDIA_USB_SUPPORT && HAS_DMA
 	select INPUT_POLLDEV
 	select VIDEOBUF2_DMA_SG
 	help
-- 
1.9.1

