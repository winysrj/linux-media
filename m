Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdIFIJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:09:02 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990889AbdIFIJA518q4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:09:00 +0200
Date: Wed, 6 Sep 2017 10:08:54 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 01/10] media: rc: gpio-ir-recv: use helper vaiable to acess
 device info
Message-ID: <20170906080854.xanrfwmywy6w4irj@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using explicit struct device variable makes code a bit more readable.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index b4f773b9dc1d..2f6233186ce9 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -116,18 +116,18 @@ static void flush_timer(unsigned long arg)
 
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct gpio_rc_dev *gpio_dev;
 	struct rc_dev *rcdev;
-	const struct gpio_ir_recv_platform_data *pdata =
-					pdev->dev.platform_data;
+	const struct gpio_ir_recv_platform_data *pdata = dev->platform_data;
 	int rc;
 
 	if (pdev->dev.of_node) {
 		struct gpio_ir_recv_platform_data *dtpdata =
-			devm_kzalloc(&pdev->dev, sizeof(*dtpdata), GFP_KERNEL);
+			devm_kzalloc(dev, sizeof(*dtpdata), GFP_KERNEL);
 		if (!dtpdata)
 			return -ENOMEM;
-		rc = gpio_ir_recv_get_devtree_pdata(&pdev->dev, dtpdata);
+		rc = gpio_ir_recv_get_devtree_pdata(dev, dtpdata);
 		if (rc)
 			return rc;
 		pdata = dtpdata;
@@ -156,7 +156,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.vendor = 0x0001;
 	rcdev->input_id.product = 0x0001;
 	rcdev->input_id.version = 0x0100;
-	rcdev->dev.parent = &pdev->dev;
+	rcdev->dev.parent = dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
 	rcdev->min_timeout = 1;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
@@ -183,7 +183,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rc = rc_register_device(rcdev);
 	if (rc < 0) {
-		dev_err(&pdev->dev, "failed to register rc device\n");
+		dev_err(dev, "failed to register rc device\n");
 		goto err_register_rc_device;
 	}
 
-- 
2.11.0
