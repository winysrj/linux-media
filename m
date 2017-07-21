Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50301 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbdGUQU6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:20:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] v4l: omap_vout: vrfb: include linux/slab.h
Date: Fri, 21 Jul 2017 18:20:23 +0200
Message-Id: <20170721162050.3339076-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this header, we get a build error in some configurations:

drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_setup_vrfb_bufs':
drivers/media/platform/omap/omap_vout_vrfb.c:143:26: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]

Fixes: 6a1560ecaa8c ("media: v4l: omap_vout: vrfb: Convert to dmaengine")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index fed28b6bbbc0..123c2b26a933 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
-- 
2.9.0
