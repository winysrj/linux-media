Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdIGXhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:48 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23994834AbdIGXexdgEGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:34:53 +0200
Date: Fri, 8 Sep 2017 01:34:35 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 01/10] media: rc: gpio-ir-recv: use helper vaiable to
 acess device info
Message-ID: <20170907233435.sw4dr6k6x7svmdbt@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using explicit struct device variable makes code a bit more readable.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 7248b3662285..741a68c192ce 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -95,18 +95,18 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 
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
@@ -135,7 +135,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.vendor = 0x0001;
 	rcdev->input_id.product = 0x0001;
 	rcdev->input_id.version = 0x0100;
-	rcdev->dev.parent = &pdev->dev;
+	rcdev->dev.parent = dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
 	rcdev->min_timeout = 1;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
@@ -159,7 +159,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rc = rc_register_device(rcdev);
 	if (rc < 0) {
-		dev_err(&pdev->dev, "failed to register rc device\n");
+		dev_err(dev, "failed to register rc device (%d)\n", rc);
 		goto err_register_rc_device;
 	}
 
-- 
2.11.0
