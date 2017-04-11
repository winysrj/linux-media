Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35066 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbdDKGHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 02:07:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id l44so4279926wrc.2
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 23:07:38 -0700 (PDT)
Subject: [PATCH 5/5] media: rc: meson-ir: change irq name to to of node name
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, Kevin Hilman <khilman@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Message-ID: <aff59e48-c030-3e80-fca5-969e41f7d758@gmail.com>
Date: Tue, 11 Apr 2017 08:07:17 +0200
MIME-Version: 1.0
In-Reply-To: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch the interrupt description to the default which is the of node
name. This is more in line with the interrupt descriptions in
other meson drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/meson-ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 246da2db..471251b3 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -155,7 +155,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, "ir-meson", ir);
+	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, NULL, ir);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		return ret;
-- 
2.12.2
