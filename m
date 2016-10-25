Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36391 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbcJYTYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 15:24:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id c78so1922429wme.3
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 12:24:14 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/5] media: rc: nuvoton: eliminate member pdev from struct
 nvt_dev
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <924ec6d5-32b0-6de1-691f-9a907bfd6e90@gmail.com>
Date: Tue, 25 Oct 2016 21:23:37 +0200
MIME-Version: 1.0
In-Reply-To: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Member pdev of struct nvt_dev is needed only to access &pdev->dev.
We can get rid of this it by using rdev->dev.parent instead
(both point to the same struct device).

Setting rdev->dev.parent can be removed from the probe function
as this is done by devm_rc_allocate_device now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 27 ++++++++++++++-------------
 drivers/media/rc/nuvoton-cir.h |  1 -
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 37fce7b..a583066 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -48,6 +48,11 @@ static const struct nvt_chip nvt_chips[] = {
 	{ "NCT6779D", NVT_6779D },
 };
 
+static inline struct device *nvt_get_dev(const struct nvt_dev *nvt)
+{
+	return nvt->rdev->dev.parent;
+}
+
 static inline bool is_w83667hg(struct nvt_dev *nvt)
 {
 	return nvt->chip_ver == NVT_W83667HG;
@@ -385,6 +390,7 @@ static inline const char *nvt_find_chip(struct nvt_dev *nvt, int id)
 /* detect hardware features */
 static int nvt_hw_detect(struct nvt_dev *nvt)
 {
+	struct device *dev = nvt_get_dev(nvt);
 	const char *chip_name;
 	int chip_id;
 
@@ -405,8 +411,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 
 	chip_id = nvt->chip_major << 8 | nvt->chip_minor;
 	if (chip_id == NVT_INVALID) {
-		dev_err(&nvt->pdev->dev,
-			"No device found on either EFM port\n");
+		dev_err(dev, "No device found on either EFM port\n");
 		return -ENODEV;
 	}
 
@@ -414,12 +419,11 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 
 	/* warn, but still let the driver load, if we don't know this chip */
 	if (!chip_name)
-		dev_warn(&nvt->pdev->dev,
+		dev_warn(dev,
 			 "unknown chip, id: 0x%02x 0x%02x, it may not work...",
 			 nvt->chip_major, nvt->chip_minor);
 	else
-		dev_info(&nvt->pdev->dev,
-			 "found %s or compatible: chip id: 0x%02x 0x%02x",
+		dev_info(dev, "found %s or compatible: chip id: 0x%02x 0x%02x",
 			 chip_name, nvt->chip_major, nvt->chip_minor);
 
 	return 0;
@@ -616,7 +620,7 @@ static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
 	duration *= SAMPLE_PERIOD;
 
 	if (!count || !duration) {
-		dev_notice(&nvt->pdev->dev,
+		dev_notice(nvt_get_dev(nvt),
 			   "Unable to determine carrier! (c:%u, d:%u)",
 			   count, duration);
 		return 0;
@@ -781,7 +785,7 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
 {
-	dev_warn(&nvt->pdev->dev, "RX FIFO overrun detected, flushing data!");
+	dev_warn(nvt_get_dev(nvt), "RX FIFO overrun detected, flushing data!");
 
 	nvt->pkts = 0;
 	nvt_clear_cir_fifo(nvt);
@@ -976,9 +980,10 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 		return -ENOMEM;
 
 	/* input device for IR remote (and tx) */
-	rdev = devm_rc_allocate_device(&pdev->dev);
-	if (!rdev)
+	nvt->rdev = devm_rc_allocate_device(&pdev->dev);
+	if (!nvt->rdev)
 		return -ENOMEM;
+	rdev = nvt->rdev;
 
 	/* activate pnp device */
 	ret = pnp_activate_dev(pdev);
@@ -1017,7 +1022,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	spin_lock_init(&nvt->tx.lock);
 
 	pnp_set_drvdata(pdev, nvt);
-	nvt->pdev = pdev;
 
 	init_waitqueue_head(&nvt->tx.queue);
 
@@ -1050,7 +1054,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->input_id.vendor = PCI_VENDOR_ID_WINBOND2;
 	rdev->input_id.product = nvt->chip_major;
 	rdev->input_id.version = nvt->chip_minor;
-	rdev->dev.parent = &pdev->dev;
 	rdev->driver_name = NVT_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
 	rdev->timeout = MS_TO_NS(100);
@@ -1062,8 +1065,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* tx bits */
 	rdev->tx_resolution = XYZ;
 #endif
-	nvt->rdev = rdev;
-
 	ret = devm_rc_register_device(&pdev->dev, rdev);
 	if (ret)
 		return ret;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index acf735f..77102a9 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -78,7 +78,6 @@ struct nvt_chip {
 };
 
 struct nvt_dev {
-	struct pnp_dev *pdev;
 	struct rc_dev *rdev;
 
 	spinlock_t nvt_lock;
-- 
2.10.1


