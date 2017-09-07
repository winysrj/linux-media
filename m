Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdIGXhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:46 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23994825AbdIGXf1MhSik (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:35:27 +0200
Date: Fri, 8 Sep 2017 01:35:22 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 02/10] media: rc: gpio-ir-recv: use devm_kzalloc
Message-ID: <20170907233522.rvwapouclvmg344g@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_kzalloc simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 741a68c192ce..8f5e3a84a95e 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -118,15 +118,13 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (pdata->gpio_nr < 0)
 		return -EINVAL;
 
-	gpio_dev = kzalloc(sizeof(struct gpio_rc_dev), GFP_KERNEL);
+	gpio_dev = devm_kzalloc(dev, sizeof(struct gpio_rc_dev), GFP_KERNEL);
 	if (!gpio_dev)
 		return -ENOMEM;
 
 	rcdev = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!rcdev) {
-		rc = -ENOMEM;
-		goto err_allocate_device;
-	}
+	if (!rcdev)
+		return -ENOMEM;
 
 	rcdev->priv = gpio_dev;
 	rcdev->device_name = GPIO_IR_DEVICE_NAME;
@@ -182,8 +180,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	gpio_free(pdata->gpio_nr);
 err_gpio_request:
 	rc_free_device(rcdev);
-err_allocate_device:
-	kfree(gpio_dev);
 	return rc;
 }
 
@@ -194,7 +190,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	rc_unregister_device(gpio_dev->rcdev);
 	gpio_free(gpio_dev->gpio_nr);
-	kfree(gpio_dev);
 	return 0;
 }
 
-- 
2.11.0
