Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:38179
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965689AbeFOKQL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:16:11 -0400
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
Subject: [PATCH 10/11] mfd: 88pm860x-i2c: switch to i2c_lock_segment
Date: Fri, 15 Jun 2018 12:15:05 +0200
Message-Id: <20180615101506.8012-11-peda@axentia.se>
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
 drivers/mfd/88pm860x-i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index 84e313107233..8e54fc2dc29c 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -146,14 +146,14 @@ int pm860x_page_reg_write(struct i2c_client *i2c, int reg,
 	unsigned char zero;
 	int ret;
 
-	i2c_lock_adapter(i2c->adapter);
+	i2c_lock_segment(i2c->adapter);
 	read_device(i2c, 0xFA, 0, &zero);
 	read_device(i2c, 0xFB, 0, &zero);
 	read_device(i2c, 0xFF, 0, &zero);
 	ret = write_device(i2c, reg, 1, &data);
 	read_device(i2c, 0xFE, 0, &zero);
 	read_device(i2c, 0xFC, 0, &zero);
-	i2c_unlock_adapter(i2c->adapter);
+	i2c_unlock_segment(i2c->adapter);
 	return ret;
 }
 EXPORT_SYMBOL(pm860x_page_reg_write);
@@ -164,14 +164,14 @@ int pm860x_page_bulk_read(struct i2c_client *i2c, int reg,
 	unsigned char zero = 0;
 	int ret;
 
-	i2c_lock_adapter(i2c->adapter);
+	i2c_lock_segment(i2c->adapter);
 	read_device(i2c, 0xfa, 0, &zero);
 	read_device(i2c, 0xfb, 0, &zero);
 	read_device(i2c, 0xff, 0, &zero);
 	ret = read_device(i2c, reg, count, buf);
 	read_device(i2c, 0xFE, 0, &zero);
 	read_device(i2c, 0xFC, 0, &zero);
-	i2c_unlock_adapter(i2c->adapter);
+	i2c_unlock_segment(i2c->adapter);
 	return ret;
 }
 EXPORT_SYMBOL(pm860x_page_bulk_read);
-- 
2.11.0
