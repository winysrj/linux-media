Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0104.outbound.protection.outlook.com ([104.47.0.104]:28716
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752343AbdDCIhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:37:47 -0400
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
Subject: [PATCH 8/9] iio: gyro: mpu3050: stop double error reporting
Date: Mon, 3 Apr 2017 10:38:37 +0200
Message-ID: <1491208718-32068-9-git-send-email-peda@axentia.se>
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_mux_add_adapter already logs a message on failure.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/iio/gyro/mpu3050-i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/gyro/mpu3050-i2c.c b/drivers/iio/gyro/mpu3050-i2c.c
index 06007200bf49..93f08b304a63 100644
--- a/drivers/iio/gyro/mpu3050-i2c.c
+++ b/drivers/iio/gyro/mpu3050-i2c.c
@@ -70,9 +70,8 @@ static int mpu3050_i2c_probe(struct i2c_client *client,
 		dev_err(&client->dev, "failed to allocate I2C mux\n");
 	else {
 		mpu3050->i2cmux->priv = mpu3050;
-		ret = i2c_mux_add_adapter(mpu3050->i2cmux, 0, 0, 0);
-		if (ret)
-			dev_err(&client->dev, "failed to add I2C mux\n");
+		/* Ignore failure, not critical */
+		i2c_mux_add_adapter(mpu3050->i2cmux, 0, 0, 0);
 	}
 
 	return 0;
-- 
2.1.4
