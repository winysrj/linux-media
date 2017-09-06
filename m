Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdIFIK2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:10:28 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFIK1U9Wm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:10:27 +0200
Date: Wed, 6 Sep 2017 10:10:14 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 03/10] media: rc: gpio-ir-recv: use devm_rc_allocate_device
Message-ID: <20170906081014.jmw256c4q344isql@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_rc_allocate_device simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index fd5742b23447..0e0b6988c08e 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -143,7 +143,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (!gpio_dev)
 		return -ENOMEM;
 
-	rcdev = rc_allocate_device(RC_DRIVER_IR_RAW);
+	rcdev = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
 	if (!rcdev)
 		return -ENOMEM;
 
@@ -174,7 +174,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
-		goto err_gpio_request;
+		return rc;
 	rc  = gpio_direction_input(pdata->gpio_nr);
 	if (rc < 0)
 		goto err_gpio_direction_input;
@@ -202,8 +202,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 err_register_rc_device:
 err_gpio_direction_input:
 	gpio_free(pdata->gpio_nr);
-err_gpio_request:
-	rc_free_device(rcdev);
 	return rc;
 }
 
-- 
2.11.0
