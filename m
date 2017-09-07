Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdIGXhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:47 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23994828AbdIGXgQH7rkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:36:16 +0200
Date: Fri, 8 Sep 2017 01:36:11 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 03/10] media: rc: gpio-ir-recv: use devm_rc_allocate_device
Message-ID: <20170907233611.p37c3hwsuoq2r73k@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of devm_rc_allocate_device simplifies error unwinding.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 8f5e3a84a95e..ee191f26efb4 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -122,7 +122,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (!gpio_dev)
 		return -ENOMEM;
 
-	rcdev = rc_allocate_device(RC_DRIVER_IR_RAW);
+	rcdev = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
 	if (!rcdev)
 		return -ENOMEM;
 
@@ -150,7 +150,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
-		goto err_gpio_request;
+		return rc;
 	rc  = gpio_direction_input(pdata->gpio_nr);
 	if (rc < 0)
 		goto err_gpio_direction_input;
@@ -178,8 +178,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 err_register_rc_device:
 err_gpio_direction_input:
 	gpio_free(pdata->gpio_nr);
-err_gpio_request:
-	rc_free_device(rcdev);
 	return rc;
 }
 
-- 
2.11.0
