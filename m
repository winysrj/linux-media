Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:48526 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668AbbDWSJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 14:09:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] [media] v4l: VIDEOBUF2_DMA_SG should depend on HAS_DMA
Date: Thu, 23 Apr 2015 20:09:06 +0200
Message-Id: <1429812547-9640-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1429812547-9640-1-git-send-email-geert@linux-m68k.org>
References: <1429812547-9640-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    ERROR: "dma_unmap_sg" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!
    ERROR: "dma_map_sg" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!
    ERROR: "dma_sync_sg_for_cpu" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!

VIDEOBUF2_DMA_SG cannot be enabled manually by the user, it's always
selected automatically by drivers that need it. Several of those drivers
already have an explicit dependency on HAS_DMA.

Make VIDEOBUF2_DMA_SG depend on HAS_DMA. This makes it easier to find
drivers that select VIDEOBUF2_DMA_SG without depending on HAS_DMA, as
Kconfig will give a warning.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/v4l2-core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index ba7e21a73023b9ae..f7a01a72eb9e09e3 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -89,7 +89,7 @@ config VIDEOBUF2_VMALLOC
 
 config VIDEOBUF2_DMA_SG
 	tristate
-	#depends on HAS_DMA
+	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 
-- 
1.9.1

