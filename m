Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab1DMTKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 15:10:48 -0400
Date: Wed, 13 Apr 2011 15:10:43 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Douglas Clowes <dclowes1@optusnet.com.au>
Subject: [PATCH 2/2 v2] [media] rc/nuvoton-cir: enable CIR on w83667hg chip
 variant
Message-ID: <20110413191043.GA23183@redhat.com>
References: <1302639802-22723-1-git-send-email-jarod@redhat.com>
 <1302639802-22723-3-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302639802-22723-3-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks to some excellent investigative work by Douglas Clowes, it was
uncovered that the older w83667hg Nuvoton chip functions with this
driver after actually enabling the CIR function via its multi-function
chip config register. The CIR and CIR wide-band sensor enable bits are
just in a different place on this hardware, so we only poke register
0x27 on 677 hardware now, and we poke register 0x2c on the 667 now.

Reported-by: Douglas Clowes <dclowes1@optusnet.com.au>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c |   22 ++++++++++++++++------
 drivers/media/rc/nuvoton-cir.h |    7 +++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index bc5c1e2..5d93384 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -291,13 +291,23 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 
 static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 {
-	u8 val;
+	u8 val, psreg, psmask, psval;
+
+	if (nvt->chip_major == CHIP_ID_HIGH_667) {
+		psreg  = CR_MULTIFUNC_PIN_SEL;
+		psmask = MULTIFUNC_PIN_SEL_MASK;
+		psval  = MULTIFUNC_ENABLE_CIR | MULTIFUNC_ENABLE_CIRWB;
+	} else {
+		psreg  = CR_OUTPUT_PIN_SEL;
+		psmask = OUTPUT_PIN_SEL_MASK;
+		psval  = OUTPUT_ENABLE_CIR | OUTPUT_ENABLE_CIRWB;
+	}
 
-	/* output pin selection (Pin95=CIRRX, Pin96=CIRTX1, WB enabled */
-	val = nvt_cr_read(nvt, CR_OUTPUT_PIN_SEL);
-	val &= OUTPUT_PIN_SEL_MASK;
-	val |= (OUTPUT_ENABLE_CIR | OUTPUT_ENABLE_CIRWB);
-	nvt_cr_write(nvt, val, CR_OUTPUT_PIN_SEL);
+	/* output pin selection: enable CIR, with WB sensor enabled */
+	val = nvt_cr_read(nvt, psreg);
+	val &= psmask;
+	val |= psval;
+	nvt_cr_write(nvt, val, psreg);
 
 	/* Select CIR logical device and enable */
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index cc8cee3..379795d 100644
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
@@ -368,10 +369,16 @@ struct nvt_dev {
 #define CIR_INTR_MOUSE_IRQ_BIT	0x80
 #define PME_INTR_CIR_PASS_BIT	0x08
 
+/* w83677hg CIR pin config */
 #define OUTPUT_PIN_SEL_MASK	0xbc
 #define OUTPUT_ENABLE_CIR	0x01 /* Pin95=CIRRX, Pin96=CIRTX1 */
 #define OUTPUT_ENABLE_CIRWB	0x40 /* enable wide-band sensor */
 
+/* w83667hg CIR pin config */
+#define MULTIFUNC_PIN_SEL_MASK	0x1f
+#define MULTIFUNC_ENABLE_CIR	0x80 /* Pin75=CIRRX, Pin76=CIRTX1 */
+#define MULTIFUNC_ENABLE_CIRWB	0x20 /* enable wide-band sensor */
+
 /* MCE CIR signal length, related on sample period */
 
 /* MCE CIR controller signal length: about 43ms
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

