Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37679 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbL3Qqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:51 -0500
Received: by mail-wm0-f51.google.com with SMTP id f206so84211898wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:50 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 08/16] media: rc: nuvoton-cir: remove unneeded EFM operation
 in nvt_cir_isr
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56840990.9050403@gmail.com>
Date: Wed, 30 Dec 2015 17:42:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Selecting the logical device in the interrupt handler is not needed
as no configuration register is accessed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 342e21d..91f8fda 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -800,10 +800,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 
 	nvt_dbg_verbose("%s firing", __func__);
 
-	nvt_efm_enable(nvt);
-	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_efm_disable(nvt);
-
 	/*
 	 * Get IR Status register contents. Write 1 to ack/clear
 	 *
-- 
2.6.4


