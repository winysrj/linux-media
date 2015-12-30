Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36040 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbL3Qqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:42 -0500
Received: by mail-wm0-f51.google.com with SMTP id l65so64876820wmf.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:42 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 01/16] media: rc: nuvoton-cir: use request_muxed_region for
 accessing EFM registers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408BA.6030500@gmail.com>
Date: Wed, 30 Dec 2015 17:39:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two EFM ioports are accessed by drivers for other parts of the Nuvoton
Super-IO chips too. Therefore access to these ioports needs to be
protected by using request_muxed_region (like it's implemented e.g. in
hwmon/nct6775 already).

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 081435c..62c82c5 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -80,17 +80,24 @@ static inline void nvt_clear_reg_bit(struct nvt_dev *nvt, u8 val, u8 reg)
 }
 
 /* enter extended function mode */
-static inline void nvt_efm_enable(struct nvt_dev *nvt)
+static inline int nvt_efm_enable(struct nvt_dev *nvt)
 {
+	if (!request_muxed_region(nvt->cr_efir, 2, NVT_DRIVER_NAME))
+		return -EBUSY;
+
 	/* Enabling Extended Function Mode explicitly requires writing 2x */
 	outb(EFER_EFM_ENABLE, nvt->cr_efir);
 	outb(EFER_EFM_ENABLE, nvt->cr_efir);
+
+	return 0;
 }
 
 /* exit extended function mode */
 static inline void nvt_efm_disable(struct nvt_dev *nvt)
 {
 	outb(EFER_EFM_DISABLE, nvt->cr_efir);
+
+	release_region(nvt->cr_efir, 2);
 }
 
 /*
-- 
2.6.4


