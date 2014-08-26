Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 30/35] [media] enable COMPILE_TEST for ti-vbe
Date: Tue, 26 Aug 2014 18:55:06 -0300
Message-Id: <1409090111-8290-31-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allowing COMPILE_TEST here is trivial, but there's one missing
header to be added:

drivers/media/platform/ti-vpe/vpe.c: In function ‘vpe_probe’:
drivers/media/platform/ti-vpe/vpe.c:2266:56: error: ‘SZ_32K’ undeclared (first use in this function)
  dev->base = devm_ioremap(&pdev->dev, dev->res->start, SZ_32K);
                                                        ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/Kconfig      | 3 ++-
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 66566c920fe9..6d0a0df6d818 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -223,7 +223,8 @@ config VIDEO_RENESAS_VSP1
 
 config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_DRA7XX
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on SOC_DRA7XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 972f43f69206..773b1fbf3269 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/log2.h>
+#include <linux/sizes.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
-- 
1.9.3

