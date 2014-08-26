Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 29/35] [media] enable COMPILE_TEST for MX2 eMMa-PrP driver
Date: Tue, 26 Aug 2014 18:55:05 -0300
Message-Id: <1409090111-8290-30-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By allowing compilation on all archs, we can use static
analysis tools to test this driver.

In order to do that, replace asm/sizes.h by its generic
name (linux/sizes.h), with should keep doing the right
thing.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/Kconfig       | 3 ++-
 drivers/media/platform/mx2_emmaprp.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 6d86646d9743..66566c920fe9 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -185,7 +185,8 @@ config VIDEO_SAMSUNG_S5P_MFC
 
 config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
-	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_IMX27
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on SOC_IMX27 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index fa8f7cabe364..4971ff21f82b 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-dma-contig.h>
-#include <asm/sizes.h>
+#include <linux/sizes.h>
 
 #define EMMAPRP_MODULE_NAME "mem2mem-emmaprp"
 
-- 
1.9.3

