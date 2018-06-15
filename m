Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0122.outbound.protection.outlook.com ([104.47.2.122]:4422
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936200AbeFOKPk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:15:40 -0400
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
Subject: [PATCH 01/11] i2c: add helpers for locking the I2C segment
Date: Fri, 15 Jun 2018 12:14:56 +0200
Message-Id: <20180615101506.8012-2-peda@axentia.se>
In-Reply-To: <20180615101506.8012-1-peda@axentia.se>
References: <20180615101506.8012-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is what almost all drivers want to do. By only advertising
i2c_lock_adapter, they are tricked into locking the root adapter
which is too big of a hammer in most cases.

While at it, convert all open-coded locking of the I2C segment.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-core-base.c  |  6 +++---
 drivers/i2c/i2c-core-smbus.c |  4 ++--
 include/linux/i2c.h          | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 1ba40bb2b966..3eb09dc20573 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1932,16 +1932,16 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 #endif
 
 		if (in_atomic() || irqs_disabled()) {
-			ret = i2c_trylock_bus(adap, I2C_LOCK_SEGMENT);
+			ret = i2c_trylock_segment(adap);
 			if (!ret)
 				/* I2C activity is ongoing. */
 				return -EAGAIN;
 		} else {
-			i2c_lock_bus(adap, I2C_LOCK_SEGMENT);
+			i2c_lock_segment(adap);
 		}
 
 		ret = __i2c_transfer(adap, msgs, num);
-		i2c_unlock_bus(adap, I2C_LOCK_SEGMENT);
+		i2c_unlock_segment(adap);
 
 		return ret;
 	} else {
diff --git a/drivers/i2c/i2c-core-smbus.c b/drivers/i2c/i2c-core-smbus.c
index b5aec33002c3..8a820fdef3e0 100644
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -537,7 +537,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_CLIENT_SCCB;
 
 	if (adapter->algo->smbus_xfer) {
-		i2c_lock_bus(adapter, I2C_LOCK_SEGMENT);
+		i2c_lock_segment(adapter);
 
 		/* Retry automatically on arbitration loss */
 		orig_jiffies = jiffies;
@@ -551,7 +551,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 				       orig_jiffies + adapter->timeout))
 				break;
 		}
-		i2c_unlock_bus(adapter, I2C_LOCK_SEGMENT);
+		i2c_unlock_segment(adapter);
 
 		if (res != -EOPNOTSUPP || !adapter->algo->master_xfer)
 			goto trace;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 44ad14e016b5..c9080d49e988 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -768,6 +768,24 @@ i2c_unlock_adapter(struct i2c_adapter *adapter)
 	i2c_unlock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
 }
 
+static inline void
+i2c_lock_segment(struct i2c_adapter *adapter)
+{
+	i2c_lock_bus(adapter, I2C_LOCK_SEGMENT);
+}
+
+static inline int
+i2c_trylock_segment(struct i2c_adapter *adapter)
+{
+	return i2c_trylock_bus(adapter, I2C_LOCK_SEGMENT);
+}
+
+static inline void
+i2c_unlock_segment(struct i2c_adapter *adapter)
+{
+	i2c_unlock_bus(adapter, I2C_LOCK_SEGMENT);
+}
+
 /*flags for the client struct: */
 #define I2C_CLIENT_PEC		0x04	/* Use Packet Error Checking */
 #define I2C_CLIENT_TEN		0x10	/* we have a ten bit chip address */
-- 
2.11.0
