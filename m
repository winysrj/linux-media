Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab1DLUXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 16:23:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3CKNa1L006844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 16:23:36 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/2] [media] rc/nuvoton-cir: enable CIR on w83667hg chip variant
Date: Tue, 12 Apr 2011 16:23:22 -0400
Message-Id: <1302639802-22723-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1302639802-22723-1-git-send-email-jarod@redhat.com>
References: <1302639802-22723-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks to some excellent investigative work by Douglas Clowes, it was
uncovered that the older w83667hg Nuvoton chip functions with this
driver after actually enabling the CIR function via its multi-function
chip config register. The already-supported w83677hg hardware has CIR
enabled out of the box, and the relevant bits of register 0x2c have a
completely different meaning, so we only poke them on the 667.

Reported-by: Douglas Clowes <dclowes1@optusnet.com.au>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c |   11 +++++++++++
 drivers/media/rc/nuvoton-cir.h |    3 +++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index bc5c1e2..4ebda1c 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -299,6 +299,17 @@ static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 	val |= (OUTPUT_ENABLE_CIR | OUTPUT_ENABLE_CIRWB);
 	nvt_cr_write(nvt, val, CR_OUTPUT_PIN_SEL);
 
+	/*
+	 * multifunction pin selection, on w83677hg, these are fan headers
+	 * config bits we don't need to touch, but on w83667hg, the two high
+	 * bits must be set to 10 to enable the CIR function
+	 */
+	val = nvt_cr_read(nvt, CR_MULTIFUNC_PIN_SEL);
+	val &= MULTIFUNC_PIN_SEL_MASK;
+	val |= MULTIFUNC_ENABLE_CIR;
+	if (nvt->chip_major == CHIP_ID_HIGH_667)
+		nvt_cr_write(nvt, val, CR_MULTIFUNC_PIN_SEL);
+
 	/* Select CIR logical device and enable */
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
 	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index cc8cee3..41b3545 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -345,6 +345,7 @@ struct nvt_dev {
 #define CR_CHIP_ID_LO		0x21
 #define CR_DEV_POWER_DOWN	0x22 /* bit 2 is CIR power, default power on */
 #define CR_OUTPUT_PIN_SEL	0x27
+#define CR_MULTIFUNC_PIN_SEL	0x2c
 #define CR_LOGICAL_DEV_EN	0x30 /* valid for all logical devices */
 /* next three regs valid for both the CIR and CIR_WAKE logical devices */
 #define CR_CIR_BASE_ADDR_HI	0x60
@@ -369,8 +370,10 @@ struct nvt_dev {
 #define PME_INTR_CIR_PASS_BIT	0x08
 
 #define OUTPUT_PIN_SEL_MASK	0xbc
+#define MULTIFUNC_PIN_SEL_MASK	0xbf
 #define OUTPUT_ENABLE_CIR	0x01 /* Pin95=CIRRX, Pin96=CIRTX1 */
 #define OUTPUT_ENABLE_CIRWB	0x40 /* enable wide-band sensor */
+#define MULTIFUNC_ENABLE_CIR	0x80 /* Pin75 and Pin76 on w83667hg */
 
 /* MCE CIR signal length, related on sample period */
 
-- 
1.7.1

