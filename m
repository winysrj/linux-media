Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33805 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbbJ2VXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:44 -0400
Received: by wmff134 with SMTP id f134so32384682wmf.1
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:43 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 8/9] media: rc: nuvoton-cir: replace nvt_pr with dev_
 functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328E35.20708@gmail.com>
Date: Thu, 29 Oct 2015 22:23:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace nvt_pr with the respective dev_ functions thus slightly
simplifying the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 15 ++++++++-------
 drivers/media/rc/nuvoton-cir.h |  3 ---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ee1b14e..1ba9c99 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -274,9 +274,9 @@ static void nvt_hw_detect(struct nvt_dev *nvt)
 
 	/* warn, but still let the driver load, if we don't know this chip */
 	if (!chip_name)
-		nvt_pr(KERN_WARNING,
-		       "unknown chip, id: 0x%02x 0x%02x, it may not work...",
-		       nvt->chip_major, nvt->chip_minor);
+		dev_warn(&nvt->pdev->dev,
+			 "unknown chip, id: 0x%02x 0x%02x, it may not work...",
+			 nvt->chip_major, nvt->chip_minor);
 	else
 		nvt_dbg("found %s or compatible: chip id: 0x%02x 0x%02x",
 			chip_name, nvt->chip_major, nvt->chip_minor);
@@ -482,8 +482,9 @@ static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
 	duration *= SAMPLE_PERIOD;
 
 	if (!count || !duration) {
-		nvt_pr(KERN_NOTICE, "Unable to determine carrier! (c:%u, d:%u)",
-		       count, duration);
+		dev_notice(&nvt->pdev->dev,
+			   "Unable to determine carrier! (c:%u, d:%u)",
+			   count, duration);
 		return 0;
 	}
 
@@ -658,7 +659,7 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
 {
-	nvt_pr(KERN_WARNING, "RX FIFO overrun detected, flushing data!");
+	dev_warn(&nvt->pdev->dev, "RX FIFO overrun detected, flushing data!");
 
 	nvt->pkts = 0;
 	nvt_clear_cir_fifo(nvt);
@@ -1087,7 +1088,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	device_init_wakeup(&pdev->dev, true);
 
-	nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
+	dev_notice(&pdev->dev, "driver has been successfully loaded\n");
 	if (debug) {
 		cir_dump_regs(nvt);
 		cir_wake_dump_regs(nvt);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index c96a9d3..0ad15d3 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -35,9 +35,6 @@
 static int debug;
 
 
-#define nvt_pr(level, text, ...) \
-	printk(level KBUILD_MODNAME ": " text, ## __VA_ARGS__)
-
 #define nvt_dbg(text, ...) \
 	if (debug) \
 		printk(KERN_DEBUG \
-- 
2.6.2


