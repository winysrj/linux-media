Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34569 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbcERUaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 16:30:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id n129so15833309wmn.1
        for <linux-media@vger.kernel.org>; Wed, 18 May 2016 13:30:20 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: decrease size of raw event fifo
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
Date: Wed, 18 May 2016 22:29:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This chip has a 32 byte HW FIFO only. Therefore the default fifo size
of 512 raw events is not needed and can be significantly decreased.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 99b303b..e98c955 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1186,6 +1186,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->raw_fifo_size = RX_BUF_LEN;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
-- 
2.8.2

