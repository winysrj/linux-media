Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab1DLUXe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 16:23:34 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3CKNY7L018135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 16:23:34 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] [media] rc/nuvoton-cir: only warn about unknown chips
Date: Tue, 12 Apr 2011 16:23:21 -0400
Message-Id: <1302639802-22723-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1302639802-22723-1-git-send-email-jarod@redhat.com>
References: <1302639802-22723-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are additional chip IDs that report a PNP ID of NTN0530, which we
were refusing to load on. Instead, lets just warn if we encounter an
unknown chip, as there's a chance it will work just fine.

Also, expand the list of known hardware to include both an earlier and a
later generation chip that this driver should function with. Douglas has
an older w83667hg variant, that with a touch more work, will be
supported by this driver, and Lutz has a newer w83677hg variant that
works without any further modifications to the driver.

Reported-by: Douglas Clowes <dclowes1@optusnet.com.au>
Reported-by: Lutz Sammer <johns98@gmx.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c |   40 ++++++++++++++++++++++++++++++++--------
 drivers/media/rc/nuvoton-cir.h |   10 +++++++---
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index d4d6449..bc5c1e2 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -37,8 +37,6 @@
 
 #include "nuvoton-cir.h"
 
-static char *chip_id = "w836x7hg";
-
 /* write val to config reg */
 static inline void nvt_cr_write(struct nvt_dev *nvt, u8 val, u8 reg)
 {
@@ -233,6 +231,8 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	unsigned long flags;
 	u8 chip_major, chip_minor;
 	int ret = 0;
+	char chip_id[12];
+	bool chip_unknown = false;
 
 	nvt_efm_enable(nvt);
 
@@ -246,15 +246,39 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	}
 
 	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
-	nvt_dbg("%s: chip id: 0x%02x 0x%02x", chip_id, chip_major, chip_minor);
 
-	if (chip_major != CHIP_ID_HIGH ||
-	    (chip_minor != CHIP_ID_LOW && chip_minor != CHIP_ID_LOW2)) {
-		nvt_pr(KERN_ERR, "%s: unsupported chip, id: 0x%02x 0x%02x",
-		       chip_id, chip_major, chip_minor);
-		ret = -ENODEV;
+	/* these are the known working chip revisions... */
+	switch (chip_major) {
+	case CHIP_ID_HIGH_667:
+		strcpy(chip_id, "w83667hg\0");
+		if (chip_minor != CHIP_ID_LOW_667)
+			chip_unknown = true;
+		break;
+	case CHIP_ID_HIGH_677B:
+		strcpy(chip_id, "w83677hg\0");
+		if (chip_minor != CHIP_ID_LOW_677B2 &&
+		    chip_minor != CHIP_ID_LOW_677B3)
+			chip_unknown = true;
+		break;
+	case CHIP_ID_HIGH_677C:
+		strcpy(chip_id, "w83677hg-c\0");
+		if (chip_minor != CHIP_ID_LOW_677C)
+			chip_unknown = true;
+		break;
+	default:
+		strcpy(chip_id, "w836x7hg\0");
+		chip_unknown = true;
+		break;
 	}
 
+	/* warn, but still let the driver load, if we don't know this chip */
+	if (chip_unknown)
+		nvt_pr(KERN_WARNING, "%s: unknown chip, id: 0x%02x 0x%02x, "
+		       "it may not work...", chip_id, chip_major, chip_minor);
+	else
+		nvt_dbg("%s: chip id: 0x%02x 0x%02x",
+			chip_id, chip_major, chip_minor);
+
 	nvt_efm_disable(nvt);
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 048135e..cc8cee3 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -330,9 +330,13 @@ struct nvt_dev {
 #define EFER_EFM_DISABLE	0xaa
 
 /* Chip IDs found in CR_CHIP_ID_{HI,LO} */
-#define CHIP_ID_HIGH		0xb4
-#define CHIP_ID_LOW		0x72
-#define CHIP_ID_LOW2		0x73
+#define CHIP_ID_HIGH_667	0xa5
+#define CHIP_ID_HIGH_677B	0xb4
+#define CHIP_ID_HIGH_677C	0xc3
+#define CHIP_ID_LOW_667		0x13
+#define CHIP_ID_LOW_677B2	0x72
+#define CHIP_ID_LOW_677B3	0x73
+#define CHIP_ID_LOW_677C	0x33
 
 /* Config regs we need to care about */
 #define CR_SOFTWARE_RESET	0x02
-- 
1.7.1

