Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbdIFINJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:13:09 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFINIfUof4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:13:08 +0200
Date: Wed, 6 Sep 2017 10:12:58 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 07/10] media: rc: gpio-ir-recv: use devm_request_irq
Message-ID: <20170906081258.lqsziexg2cpstcb5@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_request_irq simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 1d84085f1021..68278109f460 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -185,24 +185,16 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gpio_dev);
 
-	rc = request_irq(gpio_to_irq(pdata->gpio_nr),
+	return devm_request_irq(dev, gpio_to_irq(pdata->gpio_nr),
 				gpio_ir_recv_irq,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
-					"gpio-ir-recv-irq", gpio_dev);
-	if (rc < 0)
-		goto err_request_irq;
-
-	return 0;
-
-err_request_irq:
-	return rc;
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"gpio-ir-recv-irq", gpio_dev);
 }
 
 static int gpio_ir_recv_remove(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
 
-	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	del_timer_sync(&gpio_dev->flush_timer);
 	return 0;
 }
-- 
2.11.0
