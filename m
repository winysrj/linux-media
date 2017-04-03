Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0104.outbound.protection.outlook.com ([104.47.0.104]:28716
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752270AbdDCIhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:37:37 -0400
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
Subject: [PATCH 6/9] i2c: mux: pinctrl: stop double error reporting
Date: Mon, 3 Apr 2017 10:38:35 +0200
Message-ID: <1491208718-32068-7-git-send-email-peda@axentia.se>
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_mux_add_adapter already logs a message on failure.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 35bb775e1b74..7c0c264b07bc 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -245,10 +245,8 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 				(mux->pdata->base_bus_num + i) : 0;
 
 		ret = i2c_mux_add_adapter(muxc, bus, i, 0);
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
+		if (ret)
 			goto err_del_adapter;
-		}
 	}
 
 	return 0;
-- 
2.1.4
