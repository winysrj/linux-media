Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35510 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754221AbeDTIOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 04:14:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Henrik Mau <Henrik.Mau@linn.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-gpio: use GPIOD_OUT_HIGH_OPEN_DRAIN
Message-ID: <ab9afd71-41a5-520b-399a-8cbacda56223@xs4all.nl>
Date: Fri, 20 Apr 2018 10:13:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver needs a pull up output GPIO, but devm_gpiod_get() is called
with GPIOD_IN. This apparently works fine for the RPi3 where the DT
correctly specifies a pull up GPIO, but on the i.MX6 it also needs to
be specified with devm_gpiod_get().

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Reported-by: Henrik Mau <Henrik.Mau@linn.co.uk>
---
 drivers/media/platform/cec-gpio/cec-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/cec-gpio/cec-gpio.c b/drivers/media/platform/cec-gpio/cec-gpio.c
index f1f28cf5c751..69f8242209c2 100644
--- a/drivers/media/platform/cec-gpio/cec-gpio.c
+++ b/drivers/media/platform/cec-gpio/cec-gpio.c
@@ -158,7 +158,7 @@ static int cec_gpio_probe(struct platform_device *pdev)

 	cec->dev = dev;

-	cec->cec_gpio = devm_gpiod_get(dev, "cec", GPIOD_IN);
+	cec->cec_gpio = devm_gpiod_get(dev, "cec", GPIOD_OUT_HIGH_OPEN_DRAIN);
 	if (IS_ERR(cec->cec_gpio))
 		return PTR_ERR(cec->cec_gpio);
 	cec->cec_irq = gpiod_to_irq(cec->cec_gpio);
-- 
2.14.1
