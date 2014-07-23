Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbaGWP3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/8] [media] coda: move coda driver into its own directory
Date: Wed, 23 Jul 2014 17:28:38 +0200
Message-Id: <1406129325-10771-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda driver has grown significantly and will continue to grow.
Move the coda driver into its own directory so it can be split.
Rename coda.h to coda_regs.h as it contains the register defines.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/Makefile                       | 2 +-
 drivers/media/platform/coda/Makefile                  | 3 +++
 drivers/media/platform/{coda.c => coda/coda-common.c} | 2 +-
 drivers/media/platform/{coda.h => coda/coda_regs.h}   | 0
 4 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/coda/Makefile
 rename drivers/media/platform/{coda.c => coda/coda-common.c} (99%)
 rename drivers/media/platform/{coda.h => coda/coda_regs.h} (100%)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..4ac4c91 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
 
 obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
-obj-$(CONFIG_VIDEO_CODA) 		+= coda.o
+obj-$(CONFIG_VIDEO_CODA) 		+= coda/
 
 obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
new file mode 100644
index 0000000..13d9ad6
--- /dev/null
+++ b/drivers/media/platform/coda/Makefile
@@ -0,0 +1,3 @@
+coda-objs := coda-common.o
+
+obj-$(CONFIG_VIDEO_CODA) += coda.o
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda/coda-common.c
similarity index 99%
rename from drivers/media/platform/coda.c
rename to drivers/media/platform/coda/coda-common.c
index 3edbef6..1f68201 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -38,7 +38,7 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "coda.h"
+#include "coda_regs.h"
 
 #define CODA_NAME		"coda"
 
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda/coda_regs.h
similarity index 100%
rename from drivers/media/platform/coda.h
rename to drivers/media/platform/coda/coda_regs.h
-- 
2.0.1

