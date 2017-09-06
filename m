Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdIFIMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:12:32 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990889AbdIFIM2KhiM4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:12:28 +0200
Date: Wed, 6 Sep 2017 10:12:19 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 06/10] media: rc: gpio-ir-recv: do not allow threaded
 interrupt handler
Message-ID: <20170906081219.3bcjpxfidakcpujb@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Requesting any context irq is not actually great idea since threaded
interrupt handler is run at too unpredictable time which turns
timing information wrong. Fix it by requesting regular interrupt.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index c78a7eaa5a1d..1d84085f1021 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -185,7 +185,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gpio_dev);
 
-	rc = request_any_context_irq(gpio_to_irq(pdata->gpio_nr),
+	rc = request_irq(gpio_to_irq(pdata->gpio_nr),
 				gpio_ir_recv_irq,
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 					"gpio-ir-recv-irq", gpio_dev);
-- 
2.11.0
