Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdIGXhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:50 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23994827AbdIGXgo0aHXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:36:44 +0200
Date: Fri, 8 Sep 2017 01:36:39 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 04/10] media: rc: gpio-ir-recv: use devm_gpio_request_one
Message-ID: <20170907233639.5y3gsa633nix7mox@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_gpio_request_one simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index ee191f26efb4..5ce97b3612d6 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -148,12 +148,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	gpio_dev->gpio_nr = pdata->gpio_nr;
 	gpio_dev->active_low = pdata->active_low;
 
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
@@ -176,8 +174,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rc_unregister_device(rcdev);
 	rcdev = NULL;
 err_register_rc_device:
-err_gpio_direction_input:
-	gpio_free(pdata->gpio_nr);
 	return rc;
 }
 
@@ -187,7 +183,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	rc_unregister_device(gpio_dev->rcdev);
-	gpio_free(gpio_dev->gpio_nr);
 	return 0;
 }
 
-- 
2.11.0
