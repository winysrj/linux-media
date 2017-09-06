Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbdIFINo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:13:44 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFINndPLk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:13:43 +0200
Date: Wed, 6 Sep 2017 10:13:33 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 08/10] media: rc: gpio-ir-recv: use KBUILD_MODNAME
Message-ID: <20170906081333.6bvg6mrcddohr5fv@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There already is standard macro providing driver name, use it.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/gpio-ir-recv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 68278109f460..92a060f776d5 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -23,7 +23,6 @@
 #include <media/rc-core.h>
 #include <linux/platform_data/media/gpio-ir-recv.h>
 
-#define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
 #define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
 
 struct gpio_rc_dev {
@@ -155,7 +154,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.product = 0x0001;
 	rcdev->input_id.version = 0x0100;
 	rcdev->dev.parent = dev;
-	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
+	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->min_timeout = 1;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
 	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
@@ -236,7 +235,7 @@ static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
 	.remove = gpio_ir_recv_remove,
 	.driver = {
-		.name   = GPIO_IR_DRIVER_NAME,
+		.name   = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
 #ifdef CONFIG_PM
 		.pm	= &gpio_ir_recv_pm_ops,
-- 
2.11.0
