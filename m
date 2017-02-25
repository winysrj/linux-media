Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59141 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdBYMWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:22:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 05/19] [media] gpio-ir: do not allow a timeout of 0
Date: Sat, 25 Feb 2017 11:51:20 +0000
Message-Id: <fa5fd97c187d9e2998859c0ee720c1484d6c9b3b.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the documentation, a timeout of 0 turns off timeouts,
which is not the case.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/gpio-ir-recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 4a4895e..b4f773b 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -158,7 +158,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.version = 0x0100;
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
-	rcdev->min_timeout = 0;
+	rcdev->min_timeout = 1;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
 	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	if (pdata->allowed_protos)
-- 
2.9.3
