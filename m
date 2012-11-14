Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:20803 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422855Ab2KNNEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 08:04:54 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@infradead.org>
CC: <kernel@pengutronix.de>, <p.zabel@pengutronix.de>,
	<javier.martin@vista-silicon.com>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] coda: Fix build due to iram.h rename
Date: Wed, 14 Nov 2012 11:04:42 -0200
Message-ID: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
location of iram.h, which causes the following build error when building the coda
driver:

drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
drivers/media/platform/coda.c: In function 'coda_probe':
drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
drivers/media/platform/coda.c: In function 'coda_remove':
drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free

Since the content of iram.h is not imx specific, move it to include/linux/iram.h
instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/mach-imx/iram_alloc.c              |    3 +--
 drivers/media/platform/coda.c               |    2 +-
 {arch/arm/mach-imx => include/linux}/iram.h |    0
 3 files changed, 2 insertions(+), 3 deletions(-)
 rename {arch/arm/mach-imx => include/linux}/iram.h (100%)

diff --git a/arch/arm/mach-imx/iram_alloc.c b/arch/arm/mach-imx/iram_alloc.c
index 6c80424..11e067f 100644
--- a/arch/arm/mach-imx/iram_alloc.c
+++ b/arch/arm/mach-imx/iram_alloc.c
@@ -22,8 +22,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/genalloc.h>
-
-#include "iram.h"
+#include <linux/iram.h>
 
 static unsigned long iram_phys_base;
 static void __iomem *iram_virt_base;
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index cd04ae2..5c66162 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -23,8 +23,8 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
+#include <linux/iram.h>
 
-#include <mach/iram.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/arch/arm/mach-imx/iram.h b/include/linux/iram.h
similarity index 100%
rename from arch/arm/mach-imx/iram.h
rename to include/linux/iram.h
-- 
1.7.9.5


