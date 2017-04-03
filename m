Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0124.outbound.protection.outlook.com ([104.47.0.124]:19181
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752351AbdDCIhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:37:50 -0400
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
Subject: [PATCH 9/9] [media] cx231xx: stop double error reporting
Date: Mon, 3 Apr 2017 10:38:38 +0200
Message-ID: <1491208718-32068-10-git-send-email-peda@axentia.se>
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_mux_add_adapter already logs a message on failure.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 35e9acfe63d3..dff514e147da 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -576,17 +576,10 @@ int cx231xx_i2c_mux_create(struct cx231xx *dev)
 
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 {
-	int rc;
-
-	rc = i2c_mux_add_adapter(dev->muxc,
-				 0,
-				 mux_no /* chan_id */,
-				 0 /* class */);
-	if (rc)
-		dev_warn(dev->dev,
-			 "i2c mux %d register FAILED\n", mux_no);
-
-	return rc;
+	return i2c_mux_add_adapter(dev->muxc,
+				   0,
+				   mux_no /* chan_id */,
+				   0 /* class */);
 }
 
 void cx231xx_i2c_mux_unregister(struct cx231xx *dev)
-- 
2.1.4
