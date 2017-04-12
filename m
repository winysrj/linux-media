Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36103 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754634AbdDLTfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 15:35:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id q125so8538298wmd.3
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 12:35:15 -0700 (PDT)
Subject: [PATCH v2 4/5] media: rc: meson-ir: use readl_relaxed in the
 interrupt handler
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <d5c18dbb-e86a-6b1c-1410-d6cc92dce711@gmail.com>
Message-ID: <f44115e8-63de-2d8a-4864-1dff7e5b7a01@gmail.com>
Date: Wed, 12 Apr 2017 21:33:57 +0200
MIME-Version: 1.0
In-Reply-To: <d5c18dbb-e86a-6b1c-1410-d6cc92dce711@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need the memory barriers here and an interrupt handler should
be as fast as possible. Therefore switch to readl_relaxed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
---
v2:
- added R-b
---
 drivers/media/rc/meson-ir.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index cf8943d2..1c72593d 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -83,16 +83,17 @@ static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
 static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 {
 	struct meson_ir *ir = dev_id;
-	u32 duration;
+	u32 duration, status;
 	DEFINE_IR_RAW_EVENT(rawir);
 
 	spin_lock(&ir->lock);
 
-	duration = readl(ir->reg + IR_DEC_REG1);
+	duration = readl_relaxed(ir->reg + IR_DEC_REG1);
 	duration = FIELD_GET(REG1_TIME_IV_MASK, duration);
 	rawir.duration = US_TO_NS(duration * MESON_TRATE);
 
-	rawir.pulse = !!(readl(ir->reg + IR_DEC_STATUS) & STATUS_IR_DEC_IN);
+	status = readl_relaxed(ir->reg + IR_DEC_STATUS);
+	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
 
 	ir_raw_event_store_with_filter(ir->rc, &rawir);
 	ir_raw_event_handle(ir->rc);
-- 
2.12.2
