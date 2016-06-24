Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36112 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcFXFk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id c82so2174028wme.3
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:26 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 8/9] media: rc: nuvoton: remove unneeded check in
 nvt_get_rx_ir_data
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <73a053e4-6f2c-2d02-c23c-95bc3da00077@gmail.com>
Date: Fri, 24 Jun 2016 07:39:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the logical device is disabled then it can not generate interrupts.
Therefore this check is not needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 180f589..7a6f6c4 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -806,9 +806,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 	/* Get count of how many bytes to read from RX FIFO */
 	fifocount = nvt_cir_reg_read(nvt, CIR_RXFCONT);
-	/* if we get 0xff, probably means the logical dev is disabled */
-	if (fifocount == 0xff)
-		return;
 
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
 
-- 
2.9.0

