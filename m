Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33103 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbbJ2VXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:37 -0400
Received: by wmeg8 with SMTP id g8so32456783wme.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:36 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/9] media: rc: nuvoton-cir: remove unneeded lock
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328D57.5000304@gmail.com>
Date: Thu, 29 Oct 2015 22:19:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

chip_major / chip_minor are accessed sequentially in probe only.
Therefore no lock is needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 3d9a4cf..4d8e12f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -227,7 +227,6 @@ static void cir_wake_dump_regs(struct nvt_dev *nvt)
 /* detect hardware features */
 static int nvt_hw_detect(struct nvt_dev *nvt)
 {
-	unsigned long flags;
 	u8 chip_major, chip_minor;
 	char chip_id[12];
 	bool chip_unknown = false;
@@ -279,10 +278,8 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 
 	nvt_efm_disable(nvt);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
 	nvt->chip_major = chip_major;
 	nvt->chip_minor = chip_minor;
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	return 0;
 }
-- 
2.6.2


