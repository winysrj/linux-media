Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38122 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbL3Qqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:49 -0500
Received: by mail-wm0-f53.google.com with SMTP id b14so55521201wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:49 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 07/16] media: rc: nuvoton-cir: fix setting ioport base address
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5684095D.8030001@gmail.com>
Date: Wed, 30 Dec 2015 17:42:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least on Zotac CI321 ACPI provides an ioport range for the wake up part
but accessing these ioports has no effect.
Instead the ioport base address is set to another value already
(0xa20 in my case) and accessing this ioport range works.

Therefore set a new ioport base address only if the current ioport base
address is 0 (register reset default).

The need to use the existing base address instead of trying to set
an own one doesn't seem to be limited to this specific device as other
drivers like hwmon/nct6775 do it the same way.

This change was successfully tested on the mentioned device.
And the change should be generic enough to not break the driver for
other chips (however due to lack of appropriate hardware I wasn't
able to test this).

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index f624851..342e21d 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -161,6 +161,22 @@ static u8 nvt_cir_wake_reg_read(struct nvt_dev *nvt, u8 offset)
 	return val;
 }
 
+/* don't override io address if one is set already */
+static void nvt_set_ioaddr(struct nvt_dev *nvt, unsigned long *ioaddr)
+{
+	unsigned long old_addr;
+
+	old_addr = nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8;
+	old_addr |= nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO);
+
+	if (old_addr)
+		*ioaddr = old_addr;
+	else {
+		nvt_cr_write(nvt, *ioaddr >> 8, CR_CIR_BASE_ADDR_HI);
+		nvt_cr_write(nvt, *ioaddr & 0xff, CR_CIR_BASE_ADDR_LO);
+	}
+}
+
 /* dump current cir register contents */
 static void cir_dump_regs(struct nvt_dev *nvt)
 {
@@ -333,8 +349,7 @@ static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
 	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
 
-	nvt_cr_write(nvt, nvt->cir_addr >> 8, CR_CIR_BASE_ADDR_HI);
-	nvt_cr_write(nvt, nvt->cir_addr & 0xff, CR_CIR_BASE_ADDR_LO);
+	nvt_set_ioaddr(nvt, &nvt->cir_addr);
 
 	nvt_cr_write(nvt, nvt->cir_irq, CR_CIR_IRQ_RSRC);
 
@@ -358,8 +373,7 @@ static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
 	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
 
-	nvt_cr_write(nvt, nvt->cir_wake_addr >> 8, CR_CIR_BASE_ADDR_HI);
-	nvt_cr_write(nvt, nvt->cir_wake_addr & 0xff, CR_CIR_BASE_ADDR_LO);
+	nvt_set_ioaddr(nvt, &nvt->cir_wake_addr);
 
 	nvt_cr_write(nvt, nvt->cir_wake_irq, CR_CIR_IRQ_RSRC);
 
-- 
2.6.4


