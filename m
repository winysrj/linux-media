Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0122.outbound.protection.outlook.com ([104.47.2.122]:4422
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965553AbeFOKPo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:15:44 -0400
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
Subject: [PATCH 02/11] tpm/tpm_i2c_infineon: switch to i2c_lock_segment
Date: Fri, 15 Jun 2018 12:14:57 +0200
Message-Id: <20180615101506.8012-3-peda@axentia.se>
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
 drivers/char/tpm/tpm_i2c_infineon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 6116cd05e228..b2889405b4fa 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -117,7 +117,7 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 	/* Lock the adapter for the duration of the whole sequence. */
 	if (!tpm_dev.client->adapter->algo->master_xfer)
 		return -EOPNOTSUPP;
-	i2c_lock_adapter(tpm_dev.client->adapter);
+	i2c_lock_segment(tpm_dev.client->adapter);
 
 	if (tpm_dev.chip_type == SLB9645) {
 		/* use a combined read for newer chips
@@ -192,7 +192,7 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 	}
 
 out:
-	i2c_unlock_adapter(tpm_dev.client->adapter);
+	i2c_unlock_segment(tpm_dev.client->adapter);
 	/* take care of 'guard time' */
 	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
 
@@ -224,7 +224,7 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 
 	if (!tpm_dev.client->adapter->algo->master_xfer)
 		return -EOPNOTSUPP;
-	i2c_lock_adapter(tpm_dev.client->adapter);
+	i2c_lock_segment(tpm_dev.client->adapter);
 
 	/* prepend the 'register address' to the buffer */
 	tpm_dev.buf[0] = addr;
@@ -243,7 +243,7 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 		usleep_range(sleep_low, sleep_hi);
 	}
 
-	i2c_unlock_adapter(tpm_dev.client->adapter);
+	i2c_unlock_segment(tpm_dev.client->adapter);
 	/* take care of 'guard time' */
 	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
 
-- 
2.11.0
