Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0104.outbound.protection.outlook.com ([104.47.0.104]:28716
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752217AbdDCIh3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:37:29 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: [PATCH 3/9] i2c: mux: gpio: stop double error reporting
Date: Mon, 3 Apr 2017 10:38:32 +0200
Message-ID: <1491208718-32068-4-git-send-email-peda@axentia.se>
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_mux_add_adapter already logs a message on failure.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 655684d621a4..1a9973ede443 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -245,10 +245,8 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
 		ret = i2c_mux_add_adapter(muxc, nr, mux->data.values[i], class);
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
+		if (ret)
 			goto add_adapter_failed;
-		}
 	}
 
 	dev_info(&pdev->dev, "%d port mux on %s adapter\n",
-- 
2.1.4
