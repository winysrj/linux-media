Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdIGXij (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:38:39 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23993950AbdIGXiiW5O7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:38:38 +0200
Date: Fri, 8 Sep 2017 01:38:20 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 07/10] media: rc: gpio-ir-recv: use devm_request_irq
Message-ID: <20170907233820.nfve3zfuiu2bhwvu@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_request_irq simplifies error unwinding and as
free_irq was the last user of driver remove function,
remove it too.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 110276d49495..1d115f8531ba 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -161,25 +161,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
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
-}
-
-static int gpio_ir_recv_remove(struct platform_device *pdev)
-{
-	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
-
-	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
-	return 0;
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"gpio-ir-recv-irq", gpio_dev);
 }
 
 #ifdef CONFIG_PM
@@ -217,7 +202,6 @@ static const struct dev_pm_ops gpio_ir_recv_pm_ops = {
 
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
-	.remove = gpio_ir_recv_remove,
 	.driver = {
 		.name   = GPIO_IR_DRIVER_NAME,
 		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
-- 
2.11.0
