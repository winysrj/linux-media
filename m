Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34463 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbbL3Qqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:54 -0500
Received: by mail-wm0-f52.google.com with SMTP id u188so44570139wmu.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:54 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 10/16] media: rc: nuvoton-cir: improve nvt_hw_detect
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568409B1.2060109@gmail.com>
Date: Wed, 30 Dec 2015 17:43:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for the case that no Nuvoton chip is found on either EFM port.
Also move the position of nvt_efm_disable to reduce the time the
EFM ports are locked.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 17 +++++++++++++----
 drivers/media/rc/nuvoton-cir.h |  3 ++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 91f8fda..cf6ccb3 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -291,7 +291,7 @@ static inline const char *nvt_find_chip(struct nvt_dev *nvt, int id)
 
 
 /* detect hardware features */
-static void nvt_hw_detect(struct nvt_dev *nvt)
+static int nvt_hw_detect(struct nvt_dev *nvt)
 {
 	const char *chip_name;
 	int chip_id;
@@ -306,10 +306,17 @@ static void nvt_hw_detect(struct nvt_dev *nvt)
 		nvt_efm_enable(nvt);
 		nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
 	}
-
 	nvt->chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
 
+	nvt_efm_disable(nvt);
+
 	chip_id = nvt->chip_major << 8 | nvt->chip_minor;
+	if (chip_id == NVT_INVALID) {
+		dev_err(&nvt->pdev->dev,
+			"No device found on either EFM port\n");
+		return -ENODEV;
+	}
+
 	chip_name = nvt_find_chip(nvt, chip_id);
 
 	/* warn, but still let the driver load, if we don't know this chip */
@@ -322,7 +329,7 @@ static void nvt_hw_detect(struct nvt_dev *nvt)
 			 "found %s or compatible: chip id: 0x%02x 0x%02x",
 			 chip_name, nvt->chip_major, nvt->chip_minor);
 
-	nvt_efm_disable(nvt);
+	return 0;
 }
 
 static void nvt_cir_ldev_init(struct nvt_dev *nvt)
@@ -1053,7 +1060,9 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	init_waitqueue_head(&nvt->tx.queue);
 
-	nvt_hw_detect(nvt);
+	ret = nvt_hw_detect(nvt);
+	if (ret)
+		goto exit_free_dev_rdev;
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	nvt_efm_enable(nvt);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 6a3de08..48c09c7 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -68,7 +68,8 @@ enum nvt_chip_ver {
 	NVT_W83667HG	= 0xa510,
 	NVT_6775F	= 0xb470,
 	NVT_6776F	= 0xc330,
-	NVT_6779D	= 0xc560
+	NVT_6779D	= 0xc560,
+	NVT_INVALID	= 0xffff,
 };
 
 struct nvt_chip {
-- 
2.6.4


