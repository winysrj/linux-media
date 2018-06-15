Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:38179
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965713AbeFOKQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:16:14 -0400
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
Subject: [PATCH 11/11] i2c: rename i2c_lock_adapter to i2c_lock_root
Date: Fri, 15 Jun 2018 12:15:06 +0200
Message-Id: <20180615101506.8012-12-peda@axentia.se>
In-Reply-To: <20180615101506.8012-1-peda@axentia.se>
References: <20180615101506.8012-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i2c_lock_adapter name is ambiguous since it is unclear if it
refers to the root adapter or the adapter you name in the argument.
The natural interpretation is the adapter you name in the argument,
but there are historical reasons for that not being the case; it
in fact locks the root adapter. Rename the function to indicate
what is really going on. Also rename i2c_unlock_adapter, of course.

This patch was generated with

  grep -rlI --exclude-dir=.git 'i2c_\(un\)\?lock_adapter' \
    | xargs sed -i 's/i2c_\(un\)\?lock_adapter/i2c_\1lock_root/g'

followed by some minor white-space touch-up.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/busses/i2c-brcmstb.c   |  8 ++++----
 drivers/i2c/busses/i2c-davinci.c   |  4 ++--
 drivers/i2c/busses/i2c-gpio.c      | 12 ++++++------
 drivers/i2c/busses/i2c-s3c2410.c   |  4 ++--
 drivers/i2c/busses/i2c-sprd.c      |  8 ++++----
 drivers/i2c/busses/i2c-tegra.c     |  8 ++++----
 drivers/i2c/i2c-core-slave.c       |  8 ++++----
 drivers/iio/temperature/mlx90614.c |  4 ++--
 include/linux/i2c.h                |  4 ++--
 9 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
index 78792b4d6437..c42e14d4a127 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -689,9 +689,9 @@ static int brcmstb_i2c_suspend(struct device *dev)
 {
 	struct brcmstb_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
-	i2c_lock_adapter(&i2c_dev->adapter);
+	i2c_lock_root(&i2c_dev->adapter);
 	i2c_dev->is_suspended = true;
-	i2c_unlock_adapter(&i2c_dev->adapter);
+	i2c_unlock_root(&i2c_dev->adapter);
 
 	return 0;
 }
@@ -700,10 +700,10 @@ static int brcmstb_i2c_resume(struct device *dev)
 {
 	struct brcmstb_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
-	i2c_lock_adapter(&i2c_dev->adapter);
+	i2c_lock_root(&i2c_dev->adapter);
 	brcmstb_i2c_set_bsc_reg_defaults(i2c_dev);
 	i2c_dev->is_suspended = false;
-	i2c_unlock_adapter(&i2c_dev->adapter);
+	i2c_unlock_root(&i2c_dev->adapter);
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 75d6ab177055..9139d8da29ae 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -714,14 +714,14 @@ static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
 
 	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
 
-	i2c_lock_adapter(&dev->adapter);
+	i2c_lock_root(&dev->adapter);
 	if (val == CPUFREQ_PRECHANGE) {
 		davinci_i2c_reset_ctrl(dev, 0);
 	} else if (val == CPUFREQ_POSTCHANGE) {
 		i2c_davinci_calc_clk_dividers(dev);
 		davinci_i2c_reset_ctrl(dev, 1);
 	}
-	i2c_unlock_adapter(&dev->adapter);
+	i2c_unlock_root(&dev->adapter);
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index 58abb3eced58..6983968735ca 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -82,18 +82,18 @@ static int fops_##wire##_get(void *data, u64 *val)	\
 {							\
 	struct i2c_gpio_private_data *priv = data;	\
 							\
-	i2c_lock_adapter(&priv->adap);			\
+	i2c_lock_root(&priv->adap);			\
 	*val = get##wire(&priv->bit_data);		\
-	i2c_unlock_adapter(&priv->adap);		\
+	i2c_unlock_root(&priv->adap);			\
 	return 0;					\
 }							\
 static int fops_##wire##_set(void *data, u64 val)	\
 {							\
 	struct i2c_gpio_private_data *priv = data;	\
 							\
-	i2c_lock_adapter(&priv->adap);			\
+	i2c_lock_root(&priv->adap);			\
 	set##wire(&priv->bit_data, val);		\
-	i2c_unlock_adapter(&priv->adap);		\
+	i2c_unlock_root(&priv->adap);			\
 	return 0;					\
 }							\
 DEFINE_DEBUGFS_ATTRIBUTE(fops_##wire, fops_##wire##_get, fops_##wire##_set, "%llu\n")
@@ -113,7 +113,7 @@ static int fops_incomplete_transfer_set(void *data, u64 addr)
 	/* ADDR (7 bit) + RD (1 bit) + SDA hi (1 bit) */
 	pattern = (addr << 2) | 3;
 
-	i2c_lock_adapter(&priv->adap);
+	i2c_lock_root(&priv->adap);
 
 	/* START condition */
 	setsda(bit_data, 0);
@@ -129,7 +129,7 @@ static int fops_incomplete_transfer_set(void *data, u64 addr)
 		udelay(bit_data->udelay);
 	}
 
-	i2c_unlock_adapter(&priv->adap);
+	i2c_unlock_root(&priv->adap);
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 5d97510ee48b..6e8f8d2e847c 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -921,9 +921,9 @@ static int s3c24xx_i2c_cpufreq_transition(struct notifier_block *nb,
 
 	if ((val == CPUFREQ_POSTCHANGE && delta_f < 0) ||
 	    (val == CPUFREQ_PRECHANGE && delta_f > 0)) {
-		i2c_lock_adapter(&i2c->adap);
+		i2c_lock_root(&i2c->adap);
 		ret = s3c24xx_i2c_clockrate(i2c, &got);
-		i2c_unlock_adapter(&i2c->adap);
+		i2c_unlock_root(&i2c->adap);
 
 		if (ret < 0)
 			dev_err(i2c->dev, "cannot find frequency (%d)\n", ret);
diff --git a/drivers/i2c/busses/i2c-sprd.c b/drivers/i2c/busses/i2c-sprd.c
index 4053259bccb8..58a4a263984f 100644
--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -590,9 +590,9 @@ static int __maybe_unused sprd_i2c_suspend_noirq(struct device *pdev)
 {
 	struct sprd_i2c *i2c_dev = dev_get_drvdata(pdev);
 
-	i2c_lock_adapter(&i2c_dev->adap);
+	i2c_lock_root(&i2c_dev->adap);
 	i2c_dev->is_suspended = true;
-	i2c_unlock_adapter(&i2c_dev->adap);
+	i2c_unlock_root(&i2c_dev->adap);
 
 	return pm_runtime_force_suspend(pdev);
 }
@@ -601,9 +601,9 @@ static int __maybe_unused sprd_i2c_resume_noirq(struct device *pdev)
 {
 	struct sprd_i2c *i2c_dev = dev_get_drvdata(pdev);
 
-	i2c_lock_adapter(&i2c_dev->adap);
+	i2c_lock_root(&i2c_dev->adap);
 	i2c_dev->is_suspended = false;
-	i2c_unlock_adapter(&i2c_dev->adap);
+	i2c_unlock_root(&i2c_dev->adap);
 
 	return pm_runtime_force_resume(pdev);
 }
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 60292d243e24..1f2ed0dfbbaf 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1055,9 +1055,9 @@ static int tegra_i2c_suspend(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 
-	i2c_lock_adapter(&i2c_dev->adapter);
+	i2c_lock_root(&i2c_dev->adapter);
 	i2c_dev->is_suspended = true;
-	i2c_unlock_adapter(&i2c_dev->adapter);
+	i2c_unlock_root(&i2c_dev->adapter);
 
 	return 0;
 }
@@ -1067,13 +1067,13 @@ static int tegra_i2c_resume(struct device *dev)
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 	int ret;
 
-	i2c_lock_adapter(&i2c_dev->adapter);
+	i2c_lock_root(&i2c_dev->adapter);
 
 	ret = tegra_i2c_init(i2c_dev);
 	if (!ret)
 		i2c_dev->is_suspended = false;
 
-	i2c_unlock_adapter(&i2c_dev->adapter);
+	i2c_unlock_root(&i2c_dev->adapter);
 
 	return ret;
 }
diff --git a/drivers/i2c/i2c-core-slave.c b/drivers/i2c/i2c-core-slave.c
index 4a78c65e9971..fd68678f31c2 100644
--- a/drivers/i2c/i2c-core-slave.c
+++ b/drivers/i2c/i2c-core-slave.c
@@ -47,9 +47,9 @@ int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
 
 	client->slave_cb = slave_cb;
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_root(client->adapter);
 	ret = client->adapter->algo->reg_slave(client);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_root(client->adapter);
 
 	if (ret) {
 		client->slave_cb = NULL;
@@ -69,9 +69,9 @@ int i2c_slave_unregister(struct i2c_client *client)
 		return -EOPNOTSUPP;
 	}
 
-	i2c_lock_adapter(client->adapter);
+	i2c_lock_root(client->adapter);
 	ret = client->adapter->algo->unreg_slave(client);
-	i2c_unlock_adapter(client->adapter);
+	i2c_unlock_root(client->adapter);
 
 	if (ret == 0)
 		client->slave_cb = NULL;
diff --git a/drivers/iio/temperature/mlx90614.c b/drivers/iio/temperature/mlx90614.c
index d619e8634a00..15e7b2c3e7d7 100644
--- a/drivers/iio/temperature/mlx90614.c
+++ b/drivers/iio/temperature/mlx90614.c
@@ -433,11 +433,11 @@ static int mlx90614_wakeup(struct mlx90614_data *data)
 
 	dev_dbg(&data->client->dev, "Requesting wake-up");
 
-	i2c_lock_adapter(data->client->adapter);
+	i2c_lock_root(data->client->adapter);
 	gpiod_direction_output(data->wakeup_gpio, 0);
 	msleep(MLX90614_TIMING_WAKEUP);
 	gpiod_direction_input(data->wakeup_gpio);
-	i2c_unlock_adapter(data->client->adapter);
+	i2c_unlock_root(data->client->adapter);
 
 	data->ready_timestamp = jiffies +
 			msecs_to_jiffies(MLX90614_TIMING_STARTUP);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index c9080d49e988..40db4b0accb8 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -757,13 +757,13 @@ i2c_unlock_bus(struct i2c_adapter *adapter, unsigned int flags)
 }
 
 static inline void
-i2c_lock_adapter(struct i2c_adapter *adapter)
+i2c_lock_root(struct i2c_adapter *adapter)
 {
 	i2c_lock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
 }
 
 static inline void
-i2c_unlock_adapter(struct i2c_adapter *adapter)
+i2c_unlock_root(struct i2c_adapter *adapter)
 {
 	i2c_unlock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
 }
-- 
2.11.0
