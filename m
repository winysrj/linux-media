Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2ITGq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 02:46:58 -0400
Received: by pbbrr13 with SMTP id rr13so4370522pbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 23:46:58 -0700 (PDT)
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 13/34] dma: ipu: rename mach/ipu.h to include/linux/dma/ipu-dma.h
Date: Thu, 20 Sep 2012 14:45:26 +0800
Message-Id: <1348123547-31082-14-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header ipu.h really belongs to dma subsystem rather than imx
platform.  Rename it to ipu-dma.h and put it into include/linux/dma/.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-media@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
---
 drivers/dma/ipu/ipu_idmac.c                        |    3 +--
 drivers/dma/ipu/ipu_irq.c                          |    3 +--
 drivers/media/video/mx3_camera.c                   |    2 +-
 drivers/video/mx3fb.c                              |    2 +-
 .../mach/ipu.h => include/linux/dma/ipu-dma.h      |    6 +++---
 5 files changed, 7 insertions(+), 9 deletions(-)
 rename arch/arm/mach-imx/include/mach/ipu.h => include/linux/dma/ipu-dma.h (97%)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index c7573e5..6585537 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -22,8 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
-
-#include <mach/ipu.h>
+#include <linux/dma/ipu-dma.h>
 
 #include "../dmaengine.h"
 #include "ipu_intern.h"
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index fa95bcc..a5ee37d 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -15,8 +15,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/module.h>
-
-#include <mach/ipu.h>
+#include <linux/dma/ipu-dma.h>
 
 #include "ipu_intern.h"
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 1481b0d..892cba5 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/dma/ipu-dma.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -24,7 +25,6 @@
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 
-#include <mach/ipu.h>
 #include <linux/platform_data/camera-mx3.h>
 #include <linux/platform_data/dma-imx.h>
 
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index d738108..3b63ad8 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -26,10 +26,10 @@
 #include <linux/console.h>
 #include <linux/clk.h>
 #include <linux/mutex.h>
+#include <linux/dma/ipu-dma.h>
 
 #include <linux/platform_data/dma-imx.h>
 #include <mach/hardware.h>
-#include <mach/ipu.h>
 #include <linux/platform_data/video-mx3fb.h>
 
 #include <asm/io.h>
diff --git a/arch/arm/mach-imx/include/mach/ipu.h b/include/linux/dma/ipu-dma.h
similarity index 97%
rename from arch/arm/mach-imx/include/mach/ipu.h
rename to include/linux/dma/ipu-dma.h
index 539e559..1803111 100644
--- a/arch/arm/mach-imx/include/mach/ipu.h
+++ b/include/linux/dma/ipu-dma.h
@@ -9,8 +9,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef _IPU_H_
-#define _IPU_H_
+#ifndef __LINUX_DMA_IPU_DMA_H
+#define __LINUX_DMA_IPU_DMA_H
 
 #include <linux/types.h>
 #include <linux/dmaengine.h>
@@ -174,4 +174,4 @@ struct idmac_channel {
 #define to_tx_desc(tx) container_of(tx, struct idmac_tx_desc, txd)
 #define to_idmac_chan(c) container_of(c, struct idmac_channel, dma_chan)
 
-#endif
+#endif /* __LINUX_DMA_IPU_DMA_H */
-- 
1.7.9.5

