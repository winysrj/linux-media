Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:33463
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753038AbaGWJ5H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:57:07 -0400
From: Sonic Zhang <sonic.adi@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
CC: <linux-media@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/3] media: blackfin: ppi: Pass device pointer to request peripheral pins
Date: Wed, 23 Jul 2014 17:57:14 +0800
Message-ID: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

if the pinctrl driver is enabled.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 2 +-
 drivers/media/platform/blackfin/ppi.c          | 8 +++++---
 include/media/blackfin/ppi.h                   | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 16e4b1c..2759cb6 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -939,7 +939,7 @@ static int bcap_probe(struct platform_device *pdev)
 
 	bcap_dev->cfg = config;
 
-	bcap_dev->ppi = ppi_create_instance(config->ppi_info);
+	bcap_dev->ppi = ppi_create_instance(pdev, config->ppi_info);
 	if (!bcap_dev->ppi) {
 		v4l2_err(pdev->dev.driver, "Unable to create ppi\n");
 		ret = -ENODEV;
diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 15e9c2b..90c4a93 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -19,6 +19,7 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/platform_device.h>
 
 #include <asm/bfin_ppi.h>
 #include <asm/blackfin.h>
@@ -307,7 +308,8 @@ static void ppi_update_addr(struct ppi_if *ppi, unsigned long addr)
 	set_dma_start_addr(ppi->info->dma_ch, addr);
 }
 
-struct ppi_if *ppi_create_instance(const struct ppi_info *info)
+struct ppi_if *ppi_create_instance(struct platform_device *pdev,
+			const struct ppi_info *info)
 {
 	struct ppi_if *ppi;
 
@@ -315,14 +317,14 @@ struct ppi_if *ppi_create_instance(const struct ppi_info *info)
 		return NULL;
 
 	if (peripheral_request_list(info->pin_req, KBUILD_MODNAME)) {
-		pr_err("request peripheral failed\n");
+		dev_err(&pdev->dev, "request peripheral failed\n");
 		return NULL;
 	}
 
 	ppi = kzalloc(sizeof(*ppi), GFP_KERNEL);
 	if (!ppi) {
 		peripheral_free_list(info->pin_req);
-		pr_err("unable to allocate memory for ppi handle\n");
+		dev_err(&pdev->dev, "unable to allocate memory for ppi handle\n");
 		return NULL;
 	}
 	ppi->ops = &ppi_ops;
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
index d0697f4..61a283f 100644
--- a/include/media/blackfin/ppi.h
+++ b/include/media/blackfin/ppi.h
@@ -91,6 +91,7 @@ struct ppi_if {
 	void *priv;
 };
 
-struct ppi_if *ppi_create_instance(const struct ppi_info *info);
+struct ppi_if *ppi_create_instance(struct platform_device *pdev,
+			const struct ppi_info *info);
 void ppi_delete_instance(struct ppi_if *ppi);
 #endif
-- 
1.8.2.3

