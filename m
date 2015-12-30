Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:32833 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbL3Qqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:46 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so71488769wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:45 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 03/16] media: rc: nuvoton-cir: simplify nvt_cir_tx_inactive
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408CD.7070009@gmail.com>
Date: Wed, 30 Dec 2015 17:39:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify nvt_cir_tx_inactive.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 2539d4f..f661eff 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -742,16 +742,13 @@ static void nvt_cir_log_irqs(u8 status, u8 iren)
 static bool nvt_cir_tx_inactive(struct nvt_dev *nvt)
 {
 	unsigned long flags;
-	bool tx_inactive;
 	u8 tx_state;
 
 	spin_lock_irqsave(&nvt->tx.lock, flags);
 	tx_state = nvt->tx.tx_state;
 	spin_unlock_irqrestore(&nvt->tx.lock, flags);
 
-	tx_inactive = (tx_state == ST_TX_NONE);
-
-	return tx_inactive;
+	return tx_state == ST_TX_NONE;
 }
 
 /* interrupt service routine for incoming and outgoing CIR data */
-- 
2.6.4


