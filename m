Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:38179
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936247AbeFOKQI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:16:08 -0400
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
Subject: [PATCH 09/11] media: tda18271: switch to i2c_lock_segment
Date: Fri, 15 Jun 2018 12:15:04 +0200
Message-Id: <20180615101506.8012-10-peda@axentia.se>
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
 drivers/media/tuners/tda18271-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 7e81cd887c13..93cce2bcd601 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -225,7 +225,7 @@ static int __tda18271_write_regs(struct dvb_frontend *fe, int idx, int len,
 	 */
 	if (lock_i2c) {
 		tda18271_i2c_gate_ctrl(fe, 1);
-		i2c_lock_adapter(priv->i2c_props.adap);
+		i2c_lock_segment(priv->i2c_props.adap);
 	}
 	while (len) {
 		if (max > len)
@@ -246,7 +246,7 @@ static int __tda18271_write_regs(struct dvb_frontend *fe, int idx, int len,
 		len -= max;
 	}
 	if (lock_i2c) {
-		i2c_unlock_adapter(priv->i2c_props.adap);
+		i2c_unlock_segment(priv->i2c_props.adap);
 		tda18271_i2c_gate_ctrl(fe, 0);
 	}
 
@@ -300,7 +300,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	 * as those could cause bad things
 	 */
 	tda18271_i2c_gate_ctrl(fe, 1);
-	i2c_lock_adapter(priv->i2c_props.adap);
+	i2c_lock_segment(priv->i2c_props.adap);
 
 	/* initialize registers */
 	switch (priv->id) {
@@ -516,7 +516,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	/* synchronize */
 	__tda18271_write_regs(fe, R_EP1, 1, false);
 
-	i2c_unlock_adapter(priv->i2c_props.adap);
+	i2c_unlock_segment(priv->i2c_props.adap);
 	tda18271_i2c_gate_ctrl(fe, 0);
 
 	return 0;
-- 
2.11.0
