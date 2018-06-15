Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:38179
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965662AbeFOKQB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:16:01 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>, Crt Mori <cmo@melexis.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 07/11] media: rtl2830: switch to i2c_lock_segment
Date: Fri, 15 Jun 2018 12:15:02 +0200
Message-Id: <20180615101506.8012-8-peda@axentia.se>
In-Reply-To: <20180615101506.8012-1-peda@axentia.se>
References: <20180615101506.8012-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Locking the root adapter for __i2c_transfer will deadlock if the
device sits behind a mux-locked I2C mux. Switch to the finer-grained
i2c_lock_segment. If the device does not sit behind a mux-locked mux,
the two locking variants are equivalent.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2830.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 7bbfe11d11ed..85a8a9c4d020 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -24,9 +24,9 @@ static int rtl2830_bulk_write(struct i2c_client *client, unsigned int reg,
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_segment(client->adapter);
 	ret = regmap_bulk_write(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_segment(client->adapter);
 	return ret;
 }
 
@@ -36,9 +36,9 @@ static int rtl2830_update_bits(struct i2c_client *client, unsigned int reg,
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_segment(client->adapter);
 	ret = regmap_update_bits(dev->regmap, reg, mask, val);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_segment(client->adapter);
 	return ret;
 }
 
@@ -48,9 +48,9 @@ static int rtl2830_bulk_read(struct i2c_client *client, unsigned int reg,
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_segment(client->adapter);
 	ret = regmap_bulk_read(dev->regmap, reg, val, val_count);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_segment(client->adapter);
 	return ret;
 }
 
-- 
2.11.0
