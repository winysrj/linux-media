Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33656 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbcGGGSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 02:18:40 -0400
Received: by mail-wm0-f67.google.com with SMTP id n127so532788wme.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 23:17:54 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] rc: nuvoton: fix hang if chip is configured for alternative
 EFM IO address
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
Message-ID: <8333c965-61a1-f991-5a72-1cf993b9443b@gmail.com>
Date: Thu, 7 Jul 2016 08:17:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a system configures the Nuvoton chip to use the alternative
EFM IO address (CR_EFIR2) then after probing the primary EFM IO
address (CR_EFIR) this region is not released.

If a driver for another function of the Nuvoton Super I/O
chip uses the same probing mechanism then it will hang if
loaded after the nuvoton-cir driver.
This was reported for the nct6775 hwmon driver.

Fix this by properly releasing the region after probing CR_EFIR.
This regression was introduced with kernel 4.6 so cc it to stable.

Reported-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Antti Seppälä <a.seppala@gmail.com>
Cc: <stable@vger.kernel.org> # 4.6.x-
---
 drivers/media/rc/nuvoton-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 99b303b..e8ceb0e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -401,6 +401,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	/* Check if we're wired for the alternate EFER setup */
 	nvt->chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
 	if (nvt->chip_major == 0xff) {
+		nvt_efm_disable(nvt);
 		nvt->cr_efir = CR_EFIR2;
 		nvt->cr_efdr = CR_EFDR2;
 		nvt_efm_enable(nvt);
-- 
2.9.0

