Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdIFILs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:11:48 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990889AbdIFILrw9yL4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:11:47 +0200
Date: Wed, 6 Sep 2017 10:11:28 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 05/10] media: rc: gpio-ir-recv: use devm_rc_register_device
Message-ID: <20170906081128.wpbxpgt3qajxqtow@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_rc_register_device simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 4b71f7ae9132..c78a7eaa5a1d 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -177,10 +177,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (rc < 0)
 		return rc;
 
-	rc = rc_register_device(rcdev);
+	rc = devm_rc_register_device(dev, rcdev);
 	if (rc < 0) {
 		dev_err(dev, "failed to register rc device\n");
-		goto err_register_rc_device;
+		return rc;
 	}
 
 	platform_set_drvdata(pdev, gpio_dev);
@@ -195,9 +195,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	return 0;
 
 err_request_irq:
-	rc_unregister_device(rcdev);
-	rcdev = NULL;
-err_register_rc_device:
 	return rc;
 }
 
@@ -207,7 +204,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	del_timer_sync(&gpio_dev->flush_timer);
-	rc_unregister_device(gpio_dev->rcdev);
 	return 0;
 }
 
-- 
2.11.0
