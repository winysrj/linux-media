Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293Ab2BNSyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 13:54:19 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1EIsJFN007237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 13:54:19 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] fintek-cir: add support for newer chip version
Date: Tue, 14 Feb 2012 16:54:13 -0200
Message-Id: <1329245653-27896-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Jarod Wilson <jarod@redhat.com>
Reviewed-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/fintek-cir.c |   26 ++++++++++++++++++--------
 drivers/media/rc/fintek-cir.h |    4 +++-
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 7f7079b..392d4be 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -117,7 +117,7 @@ static u8 fintek_cir_reg_read(struct fintek_dev *fintek, u8 offset)
 static void cir_dump_regs(struct fintek_dev *fintek)
 {
 	fintek_config_mode_enable(fintek);
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 
 	pr_reg("%s: Dump CIR logical device registers:\n", FINTEK_DRIVER_NAME);
 	pr_reg(" * CR CIR BASE ADDR: 0x%x\n",
@@ -143,7 +143,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 	u8 chip_major, chip_minor;
 	u8 vendor_major, vendor_minor;
 	u8 portsel, ir_class;
-	u16 vendor;
+	u16 vendor, chip;
 	int ret = 0;
 
 	fintek_config_mode_enable(fintek);
@@ -176,6 +176,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 
 	chip_major = fintek_cr_read(fintek, GCR_CHIP_ID_HI);
 	chip_minor = fintek_cr_read(fintek, GCR_CHIP_ID_LO);
+	chip  = chip_major << 8 | chip_minor;
 
 	vendor_major = fintek_cr_read(fintek, GCR_VENDOR_ID_HI);
 	vendor_minor = fintek_cr_read(fintek, GCR_VENDOR_ID_LO);
@@ -192,6 +193,15 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 	fintek->chip_major  = chip_major;
 	fintek->chip_minor  = chip_minor;
 	fintek->chip_vendor = vendor;
+
+	/*
+	 * Newer reviews of this chipset uses port 8 instead of 5
+	 */
+	if ((chip != 0x0408) || (chip != 0x0804))
+		fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV2;
+	else
+		fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV1;
+
 	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
 
 	return ret;
@@ -200,7 +210,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 static void fintek_cir_ldev_init(struct fintek_dev *fintek)
 {
 	/* Select CIR logical device and enable */
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
 
 	/* Write allocated CIR address and IRQ information to hardware */
@@ -381,7 +391,7 @@ static irqreturn_t fintek_cir_isr(int irq, void *data)
 	fit_dbg_verbose("%s firing", __func__);
 
 	fintek_config_mode_enable(fintek);
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_config_mode_disable(fintek);
 
 	/*
@@ -422,7 +432,7 @@ static void fintek_enable_cir(struct fintek_dev *fintek)
 	fintek_config_mode_enable(fintek);
 
 	/* enable the CIR logical device */
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
 
 	fintek_config_mode_disable(fintek);
@@ -439,7 +449,7 @@ static void fintek_disable_cir(struct fintek_dev *fintek)
 	fintek_config_mode_enable(fintek);
 
 	/* disable the CIR logical device */
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_cr_write(fintek, LOGICAL_DEV_DISABLE, CIR_CR_DEV_EN);
 
 	fintek_config_mode_disable(fintek);
@@ -611,7 +621,7 @@ static int fintek_suspend(struct pnp_dev *pdev, pm_message_t state)
 	fintek_config_mode_enable(fintek);
 
 	/* disable cir logical dev */
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_cr_write(fintek, LOGICAL_DEV_DISABLE, CIR_CR_DEV_EN);
 
 	fintek_config_mode_disable(fintek);
@@ -634,7 +644,7 @@ static int fintek_resume(struct pnp_dev *pdev)
 
 	/* Enable CIR logical device */
 	fintek_config_mode_enable(fintek);
-	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
 
 	fintek_config_mode_disable(fintek);
diff --git a/drivers/media/rc/fintek-cir.h b/drivers/media/rc/fintek-cir.h
index 1b10b20..82516a1 100644
--- a/drivers/media/rc/fintek-cir.h
+++ b/drivers/media/rc/fintek-cir.h
@@ -88,6 +88,7 @@ struct fintek_dev {
 	u8 chip_major;
 	u8 chip_minor;
 	u16 chip_vendor;
+	u8 logical_dev_cir;
 
 	/* hardware features */
 	bool hw_learning_capable;
@@ -172,7 +173,8 @@ struct fintek_dev {
 #define LOGICAL_DEV_ENABLE	0x01
 
 /* Logical device number of the CIR function */
-#define LOGICAL_DEV_CIR		0x05
+#define LOGICAL_DEV_CIR_REV1	0x05
+#define LOGICAL_DEV_CIR_REV2	0x08
 
 /* CIR Logical Device (LDN 0x08) config registers */
 #define CIR_CR_COMMAND_INDEX	0x04
-- 
1.7.8

