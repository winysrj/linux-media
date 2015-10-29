Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32971 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbbJ2VXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:39 -0400
Received: by wijp11 with SMTP id p11so298574285wij.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:38 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4/9] media: rc: nuvoton-cir: improve chip detection
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328DE2.9060201@gmail.com>
Date: Thu, 29 Oct 2015 22:21:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the chip detection code more similar to the one used for the
same chips in watchdog/w83627hf_wdt.c and hwmon/w83627ehf.c.

Apart from better maintainability we gain
- unified naming of chips (e.g. 677C -> NCT6776F)
- driver works with all revisions of the chips
  (least 4 bits of id are masked)

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 81 +++++++++++++++++++++---------------------
 drivers/media/rc/nuvoton-cir.h | 24 ++++++++-----
 2 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index a382e17..c5c238b 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -39,6 +39,17 @@
 
 #include "nuvoton-cir.h"
 
+static const struct nvt_chip nvt_chips[] = {
+	{ "w83667hg", NVT_W83667HG },
+	{ "NCT6775F", NVT_6775F },
+	{ "NCT6776F", NVT_6776F },
+};
+
+static inline bool is_w83667hg(struct nvt_dev *nvt)
+{
+	return nvt->chip_ver == NVT_W83667HG;
+}
+
 /* write val to config reg */
 static inline void nvt_cr_write(struct nvt_dev *nvt, u8 val, u8 reg)
 {
@@ -224,63 +235,53 @@ static void cir_wake_dump_regs(struct nvt_dev *nvt)
 	pr_cont("\n");
 }
 
+static inline const char *nvt_find_chip(struct nvt_dev *nvt, int id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nvt_chips); i++)
+		if ((id & SIO_ID_MASK) == nvt_chips[i].chip_ver) {
+			nvt->chip_ver = nvt_chips[i].chip_ver;
+			return nvt_chips[i].name;
+		}
+
+	return NULL;
+}
+
+
 /* detect hardware features */
 static int nvt_hw_detect(struct nvt_dev *nvt)
 {
-	u8 chip_major, chip_minor;
-	char chip_id[12];
-	bool chip_unknown = false;
+	const char *chip_name;
+	int chip_id;
 
 	nvt_efm_enable(nvt);
 
 	/* Check if we're wired for the alternate EFER setup */
-	chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
-	if (chip_major == 0xff) {
+	nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
+	if (nvt->chip_major == 0xff) {
 		nvt->cr_efir = CR_EFIR2;
 		nvt->cr_efdr = CR_EFDR2;
 		nvt_efm_enable(nvt);
-		chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
+		nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
 	}
 
-	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
-
-	/* these are the known working chip revisions... */
-	switch (chip_major) {
-	case CHIP_ID_HIGH_667:
-		strcpy(chip_id, "w83667hg\0");
-		if (chip_minor != CHIP_ID_LOW_667)
-			chip_unknown = true;
-		break;
-	case CHIP_ID_HIGH_677B:
-		strcpy(chip_id, "w83677hg\0");
-		if (chip_minor != CHIP_ID_LOW_677B2 &&
-		    chip_minor != CHIP_ID_LOW_677B3)
-			chip_unknown = true;
-		break;
-	case CHIP_ID_HIGH_677C:
-		strcpy(chip_id, "w83677hg-c\0");
-		if (chip_minor != CHIP_ID_LOW_677C)
-			chip_unknown = true;
-		break;
-	default:
-		strcpy(chip_id, "w836x7hg\0");
-		chip_unknown = true;
-		break;
-	}
+	nvt->chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
+
+	chip_id = nvt->chip_major << 8 | nvt->chip_minor;
+	chip_name = nvt_find_chip(nvt, chip_id);
 
 	/* warn, but still let the driver load, if we don't know this chip */
-	if (chip_unknown)
-		nvt_pr(KERN_WARNING, "%s: unknown chip, id: 0x%02x 0x%02x, "
-		       "it may not work...", chip_id, chip_major, chip_minor);
+	if (!chip_name)
+		nvt_pr(KERN_WARNING,
+		       "unknown chip, id: 0x%02x 0x%02x, it may not work...",
+		       nvt->chip_major, nvt->chip_minor);
 	else
-		nvt_dbg("%s: chip id: 0x%02x 0x%02x",
-			chip_id, chip_major, chip_minor);
+		nvt_dbg("found %s or compatible: chip id: 0x%02x 0x%02x",
+			chip_name, nvt->chip_major, nvt->chip_minor);
 
 	nvt_efm_disable(nvt);
 
-	nvt->chip_major = chip_major;
-	nvt->chip_minor = chip_minor;
-
 	return 0;
 }
 
@@ -288,7 +289,7 @@ static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 {
 	u8 val, psreg, psmask, psval;
 
-	if (nvt->chip_major == CHIP_ID_HIGH_667) {
+	if (is_w83667hg(nvt)) {
 		psreg = CR_MULTIFUNC_PIN_SEL;
 		psmask = MULTIFUNC_PIN_SEL_MASK;
 		psval = MULTIFUNC_ENABLE_CIR | MULTIFUNC_ENABLE_CIRWB;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index e1cf23c..81b5a09 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -64,6 +64,20 @@ static int debug;
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
 
+#define SIO_ID_MASK 0xfff0
+
+enum nvt_chip_ver {
+	NVT_UNKNOWN	= 0,
+	NVT_W83667HG	= 0xa510,
+	NVT_6775F	= 0xb470,
+	NVT_6776F	= 0xc330
+};
+
+struct nvt_chip {
+	const char *name;
+	enum nvt_chip_ver chip_ver;
+};
+
 struct nvt_dev {
 	struct pnp_dev *pdev;
 	struct rc_dev *rdev;
@@ -93,6 +107,7 @@ struct nvt_dev {
 	int cir_irq;
 	int cir_wake_irq;
 
+	enum nvt_chip_ver chip_ver;
 	/* hardware id */
 	u8 chip_major;
 	u8 chip_minor;
@@ -326,15 +341,6 @@ struct nvt_dev {
 #define EFER_EFM_ENABLE		0x87
 #define EFER_EFM_DISABLE	0xaa
 
-/* Chip IDs found in CR_CHIP_ID_{HI,LO} */
-#define CHIP_ID_HIGH_667	0xa5
-#define CHIP_ID_HIGH_677B	0xb4
-#define CHIP_ID_HIGH_677C	0xc3
-#define CHIP_ID_LOW_667		0x13
-#define CHIP_ID_LOW_677B2	0x72
-#define CHIP_ID_LOW_677B3	0x73
-#define CHIP_ID_LOW_677C	0x33
-
 /* Config regs we need to care about */
 #define CR_SOFTWARE_RESET	0x02
 #define CR_LOGICAL_DEV_SEL	0x07
-- 
2.6.2


