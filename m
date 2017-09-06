Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdIFILG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:11:06 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFILF2dwd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:11:05 +0200
Date: Wed, 6 Sep 2017 10:10:52 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 04/10] media: rc: gpio-ir-recv: use devm_gpio_request_one
Message-ID: <20170906081052.s775qbiwzj3ndlgj@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_gpio_request_one simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 0e0b6988c08e..4b71f7ae9132 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -172,12 +172,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	setup_timer(&gpio_dev->flush_timer, flush_timer,
 		    (unsigned long)gpio_dev);
 
-	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
+	rc = devm_gpio_request_one(dev, pdata->gpio_nr, GPIOF_DIR_IN,
+					"gpio-ir-recv");
 	if (rc < 0)
 		return rc;
-	rc  = gpio_direction_input(pdata->gpio_nr);
-	if (rc < 0)
-		goto err_gpio_direction_input;
 
 	rc = rc_register_device(rcdev);
 	if (rc < 0) {
@@ -200,8 +198,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rc_unregister_device(rcdev);
 	rcdev = NULL;
 err_register_rc_device:
-err_gpio_direction_input:
-	gpio_free(pdata->gpio_nr);
 	return rc;
 }
 
@@ -212,7 +208,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	del_timer_sync(&gpio_dev->flush_timer);
 	rc_unregister_device(gpio_dev->rcdev);
-	gpio_free(gpio_dev->gpio_nr);
 	return 0;
 }
 
-- 
2.11.0
