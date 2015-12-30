Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35624 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbbL3Qq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:56 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so42403497wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:56 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 12/16] media: rc: nuvoton-cir: remove unneeded call to
 nvt_set_cir_iren
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568409DD.6060009@gmail.com>
Date: Wed, 30 Dec 2015 17:44:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling nvt_set_cir_iren separately is not needed as this is done
by nvt_cir_regs_init.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index e01fdc8..252804d 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1201,9 +1201,6 @@ static int nvt_resume(struct pnp_dev *pdev)
 
 	nvt_dbg("%s called", __func__);
 
-	/* open interrupt */
-	nvt_set_cir_iren(nvt);
-
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
-- 
2.6.4


