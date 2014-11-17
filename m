Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:14971 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaKQMSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:06 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>,
	James Hogan <james.hogan@imgtec.com>, <stable@vger.kernel.org>
Subject: [REVIEW PATCH FOR v3.18 1/5] img-ir/hw: Always read data to clear buffer
Date: Mon, 17 Nov 2014 12:17:45 +0000
Message-ID: <1416226669-2983-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
References: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>

A problem was found on Polaris where if the unit it booted via the power
button on the infrared remote then the next button press on the remote
would return the key code used to power on the unit.

The sequence is:
 - The polaris powered off but with the powerdown controller (PDC) block
   still powered.
 - Press power key on remote, IR block receives the key.
 - Kernel starts, IR code is in IMG_IR_DATA_x but neither IMG_IR_RXDVAL
   or IMG_IR_RXDVALD2 are set.
 - Wait any amount of time.
 - Press any key.
 - IMG_IR_RXDVAL or IMG_IR_RXDVALD2 is set but IMG_IR_DATA_x is
   unchanged since the powerup key data was never read.

This is worked around by always reading the IMG_IR_DATA_x in
img_ir_set_decoder(), rather than only when the IMG_IR_RXDVAL or
IMG_IR_RXDVALD2 bit is set.

Signed-off-by: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: <stable@vger.kernel.org> # v3.15+
---
 drivers/media/rc/img-ir/img-ir-hw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index ec49f94425fc..9db065344b41 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -541,10 +541,12 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	if (ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)) {
 		ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
 		img_ir_write(priv, IMG_IR_STATUS, ir_status);
-		img_ir_read(priv, IMG_IR_DATA_LW);
-		img_ir_read(priv, IMG_IR_DATA_UP);
 	}
 
+	/* always read data to clear buffer if IR wakes the device */
+	img_ir_read(priv, IMG_IR_DATA_LW);
+	img_ir_read(priv, IMG_IR_DATA_UP);
+
 	/* stop the end timer and switch back to normal mode */
 	del_timer_sync(&hw->end_timer);
 	hw->mode = IMG_IR_M_NORMAL;
-- 
2.0.4

