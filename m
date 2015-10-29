Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32979 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbbJ2VXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:40 -0400
Received: by wijp11 with SMTP id p11so298574526wij.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:39 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5/9] media: rc: nuvoton-cir: make nvt_hw_detect void
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328DF8.1050007@gmail.com>
Date: Thu, 29 Oct 2015 22:22:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nvt_hw_detect always returns 0, therefore make it return void.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c5c238b..df4b9cb 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -250,7 +250,7 @@ static inline const char *nvt_find_chip(struct nvt_dev *nvt, int id)
 
 
 /* detect hardware features */
-static int nvt_hw_detect(struct nvt_dev *nvt)
+static void nvt_hw_detect(struct nvt_dev *nvt)
 {
 	const char *chip_name;
 	int chip_id;
@@ -281,8 +281,6 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 			chip_name, nvt->chip_major, nvt->chip_minor);
 
 	nvt_efm_disable(nvt);
-
-	return 0;
 }
 
 static void nvt_cir_ldev_init(struct nvt_dev *nvt)
@@ -1024,9 +1022,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	init_waitqueue_head(&nvt->tx.queue);
 
-	ret = nvt_hw_detect(nvt);
-	if (ret)
-		goto exit_free_dev_rdev;
+	nvt_hw_detect(nvt);
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	nvt_efm_enable(nvt);
-- 
2.6.2


