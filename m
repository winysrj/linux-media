Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36686 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920AbbJ2VXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:45 -0400
Received: by wmec75 with SMTP id c75so33076364wme.1
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:44 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 9/9] media: rc: nuvoton-cir: switch chip detection message to
 info level
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328E4A.9040200@gmail.com>
Date: Thu, 29 Oct 2015 22:23:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch the info about the detected chip type from debug to info level
as it might be useful not only for debugging purposes.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 1ba9c99..18adf58 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -278,8 +278,9 @@ static void nvt_hw_detect(struct nvt_dev *nvt)
 			 "unknown chip, id: 0x%02x 0x%02x, it may not work...",
 			 nvt->chip_major, nvt->chip_minor);
 	else
-		nvt_dbg("found %s or compatible: chip id: 0x%02x 0x%02x",
-			chip_name, nvt->chip_major, nvt->chip_minor);
+		dev_info(&nvt->pdev->dev,
+			 "found %s or compatible: chip id: 0x%02x 0x%02x",
+			 chip_name, nvt->chip_major, nvt->chip_minor);
 
 	nvt_efm_disable(nvt);
 }
-- 
2.6.2


