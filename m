Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdIGXhv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:51 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23994831AbdIGXhL7fR0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:37:11 +0200
Date: Fri, 8 Sep 2017 01:37:07 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 05/10] media: rc: gpio-ir-recv: use devm_rc_register_device
Message-ID: <20170907233707.gbewwrw2nvjbnbgh@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_rc_register_device simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5ce97b3612d6..733e4ed35078 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -153,10 +153,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (rc < 0)
 		return rc;
 
-	rc = rc_register_device(rcdev);
+	rc = devm_rc_register_device(dev, rcdev);
 	if (rc < 0) {
 		dev_err(dev, "failed to register rc device (%d)\n", rc);
-		goto err_register_rc_device;
+		return rc;
 	}
 
 	platform_set_drvdata(pdev, gpio_dev);
@@ -171,9 +171,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	return 0;
 
 err_request_irq:
-	rc_unregister_device(rcdev);
-	rcdev = NULL;
-err_register_rc_device:
 	return rc;
 }
 
@@ -182,7 +179,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
-	rc_unregister_device(gpio_dev->rcdev);
 	return 0;
 }
 
-- 
2.11.0
