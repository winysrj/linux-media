Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33600 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176018AbdDYHkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 03:40:55 -0400
Received: by mail-wr0-f174.google.com with SMTP id w50so80444662wrc.0
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 00:40:55 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: khilman@baylibre.com, carlo@caione.org, mchehab@kernel.org
Cc: Jonas Karlman <jonas@kwiboo.se>, linux-amlogic@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH] media: rc: meson-ir: store raw event without processing
Date: Tue, 25 Apr 2017 09:40:48 +0200
Message-Id: <1493106048-19860-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jonas Karlman <jonas@kwiboo.se>

This patch fixes meson-it driver by storing event without processing
to avoid losing key pressed events when system is loaded and events
are occurring too fast.

This issue was reported at [1]

[1] https://github.com/LibreELEC/linux-amlogic/pull/42

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/rc/meson-ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 5576dbd..42ae2ec 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -97,7 +97,7 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 
 	rawir.pulse = !!(readl(ir->reg + IR_DEC_STATUS) & STATUS_IR_DEC_IN);
 
-	ir_raw_event_store_with_filter(ir->rc, &rawir);
+	ir_raw_event_store(ir->rc, &rawir);
 	ir_raw_event_handle(ir->rc);
 
 	spin_unlock(&ir->lock);
-- 
1.9.1
