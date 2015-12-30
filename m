Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38038 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbL3Qqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:43 -0500
Received: by mail-wm0-f53.google.com with SMTP id b14so55517975wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:43 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 02/16] media: rc: nuvoton-cir: simplify nvt_select_logical_
 dev
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408C6.3040508@gmail.com>
Date: Wed, 30 Dec 2015 17:39:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use nvt_cr_write to simplify nvt_select_logical_ dev.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 62c82c5..2539d4f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -107,8 +107,7 @@ static inline void nvt_efm_disable(struct nvt_dev *nvt)
  */
 static inline void nvt_select_logical_dev(struct nvt_dev *nvt, u8 ldev)
 {
-	outb(CR_LOGICAL_DEV_SEL, nvt->cr_efir);
-	outb(ldev, nvt->cr_efdr);
+	nvt_cr_write(nvt, ldev, CR_LOGICAL_DEV_SEL);
 }
 
 /* write val to cir config register */
-- 
2.6.4


