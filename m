Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64161 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaFRV2W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 17:28:22 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] media: saa7134: remove if based on uninitialized variable
Date: Wed, 18 Jun 2014 23:28:10 +0200
Message-Id: <1403126890-28049-1-git-send-email-xypron.glpk@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Variable b is not initialized.
Only with a small chance it has random value 0xFF.
Remove if statement based on this value.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/media/pci/saa7134/saa7134-input.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 6f43126..1c56f2ab 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -132,10 +132,6 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (0x40000 & ~gpio)
 		return 0; /* No button press */
 
-	/* No button press - only before first key pressed */
-	if (b == 0xFF)
-		return 0;
-
 	/* poll IR chip */
 	/* weak up the IR chip */
 	b = 0;
-- 
2.0.0

