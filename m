Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39347 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeGPQQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:16:15 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH -next v4 1/3] regmap: add SCCB support
Date: Tue, 17 Jul 2018 00:47:48 +0900
Message-Id: <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds Serial Camera Control Bus (SCCB) support for regmap API that
is intended to be used by some of Omnivision sensor drivers.

The ov772x and ov9650 drivers are going to use this SCCB regmap API.

The ov772x driver was previously only worked with the i2c controller
drivers that support I2C_FUNC_PROTOCOL_MANGLING, because the ov772x
device doesn't support repeated starts.  After commit 0b964d183cbf
("media: ov772x: allow i2c controllers without
I2C_FUNC_PROTOCOL_MANGLING"), reading ov772x register is replaced with
issuing two separated i2c messages in order to avoid repeated start.
Using this SCCB regmap hides the implementation detail.

The ov9650 driver also issues two separated i2c messages to read the
registers as the device doesn't support repeated start.  So it can
make use of this SCCB regmap.

Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Rosin <peda@axentia.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/base/regmap/Kconfig       |   4 ++
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-sccb.c | 128 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |  35 +++++++++++
 4 files changed, 168 insertions(+)
 create mode 100644 drivers/base/regmap/regmap-sccb.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index aff34c0..6ad5ef4 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -45,3 +45,7 @@ config REGMAP_IRQ
 config REGMAP_SOUNDWIRE
 	tristate
 	depends on SOUNDWIRE_BUS
+
+config REGMAP_SCCB
+	tristate
+	depends on I2C
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 5ed0023..f5b4e88 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_REGMAP_MMIO) += regmap-mmio.o
 obj-$(CONFIG_REGMAP_IRQ) += regmap-irq.o
 obj-$(CONFIG_REGMAP_W1) += regmap-w1.o
 obj-$(CONFIG_REGMAP_SOUNDWIRE) += regmap-sdw.o
+obj-$(CONFIG_REGMAP_SCCB) += regmap-sccb.o
diff --git a/drivers/base/regmap/regmap-sccb.c b/drivers/base/regmap/regmap-sccb.c
new file mode 100644
index 0000000..b6eb876
--- /dev/null
+++ b/drivers/base/regmap/regmap-sccb.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+// Register map access API - SCCB support
+
+#include <linux/regmap.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+#include "internal.h"
+
+/**
+ * sccb_is_available - Check if the adapter supports SCCB protocol
+ * @adap: I2C adapter
+ *
+ * Return true if the I2C adapter is capable of using SCCB helper functions,
+ * false otherwise.
+ */
+static bool sccb_is_available(struct i2c_adapter *adap)
+{
+	u32 needed_funcs = I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA;
+
+	/*
+	 * If we ever want support for hardware doing SCCB natively, we will
+	 * introduce a sccb_xfer() callback to struct i2c_algorithm and check
+	 * for it here.
+	 */
+
+	return (i2c_get_functionality(adap) & needed_funcs) == needed_funcs;
+}
+
+/**
+ * regmap_sccb_read - Read data from SCCB slave device
+ * @context: Device that will be interacted wit
+ * @reg: Register to be read from
+ * @val: Pointer to store read value
+ *
+ * This executes the 2-phase write transmission cycle that is followed by a
+ * 2-phase read transmission cycle, returning negative errno else zero on
+ * success.
+ */
+static int regmap_sccb_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+	int ret;
+	union i2c_smbus_data data;
+
+	i2c_lock_bus(i2c->adapter, I2C_LOCK_SEGMENT);
+
+	ret = __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
+			       I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL);
+	if (ret < 0)
+		goto out;
+
+	ret = __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
+			       I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &data);
+	if (ret < 0)
+		goto out;
+
+	*val = data.byte;
+out:
+	i2c_unlock_bus(i2c->adapter, I2C_LOCK_SEGMENT);
+
+	return ret;
+}
+
+/**
+ * regmap_sccb_write - Write data to SCCB slave device
+ * @context: Device that will be interacted wit
+ * @reg: Register to write to
+ * @val: Value to be written
+ *
+ * This executes the SCCB 3-phase write transmission cycle, returning negative
+ * errno else zero on success.
+ */
+static int regmap_sccb_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	return i2c_smbus_write_byte_data(i2c, reg, val);
+}
+
+static struct regmap_bus regmap_sccb_bus = {
+	.reg_write = regmap_sccb_write,
+	.reg_read = regmap_sccb_read,
+};
+
+static const struct regmap_bus *regmap_get_sccb_bus(struct i2c_client *i2c,
+					const struct regmap_config *config)
+{
+	if (config->val_bits == 8 && config->reg_bits == 8 &&
+			sccb_is_available(i2c->adapter))
+		return &regmap_sccb_bus;
+
+	return ERR_PTR(-ENOTSUPP);
+}
+
+struct regmap *__regmap_init_sccb(struct i2c_client *i2c,
+				  const struct regmap_config *config,
+				  struct lock_class_key *lock_key,
+				  const char *lock_name)
+{
+	const struct regmap_bus *bus = regmap_get_sccb_bus(i2c, config);
+
+	if (IS_ERR(bus))
+		return ERR_CAST(bus);
+
+	return __regmap_init(&i2c->dev, bus, &i2c->dev, config,
+			     lock_key, lock_name);
+}
+EXPORT_SYMBOL_GPL(__regmap_init_sccb);
+
+struct regmap *__devm_regmap_init_sccb(struct i2c_client *i2c,
+				       const struct regmap_config *config,
+				       struct lock_class_key *lock_key,
+				       const char *lock_name)
+{
+	const struct regmap_bus *bus = regmap_get_sccb_bus(i2c, config);
+
+	if (IS_ERR(bus))
+		return ERR_CAST(bus);
+
+	return __devm_regmap_init(&i2c->dev, bus, &i2c->dev, config,
+				  lock_key, lock_name);
+}
+EXPORT_SYMBOL_GPL(__devm_regmap_init_sccb);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4f38068..52bf358 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -514,6 +514,10 @@ struct regmap *__regmap_init_i2c(struct i2c_client *i2c,
 				 const struct regmap_config *config,
 				 struct lock_class_key *lock_key,
 				 const char *lock_name);
+struct regmap *__regmap_init_sccb(struct i2c_client *i2c,
+				  const struct regmap_config *config,
+				  struct lock_class_key *lock_key,
+				  const char *lock_name);
 struct regmap *__regmap_init_slimbus(struct slim_device *slimbus,
 				 const struct regmap_config *config,
 				 struct lock_class_key *lock_key,
@@ -558,6 +562,10 @@ struct regmap *__devm_regmap_init_i2c(struct i2c_client *i2c,
 				      const struct regmap_config *config,
 				      struct lock_class_key *lock_key,
 				      const char *lock_name);
+struct regmap *__devm_regmap_init_sccb(struct i2c_client *i2c,
+				       const struct regmap_config *config,
+				       struct lock_class_key *lock_key,
+				       const char *lock_name);
 struct regmap *__devm_regmap_init_spi(struct spi_device *dev,
 				      const struct regmap_config *config,
 				      struct lock_class_key *lock_key,
@@ -646,6 +654,19 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 				i2c, config)
 
 /**
+ * regmap_init_sccb() - Initialise register map
+ *
+ * @i2c: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+#define regmap_init_sccb(i2c, config)					\
+	__regmap_lockdep_wrapper(__regmap_init_sccb, #config,		\
+				i2c, config)
+
+/**
  * regmap_init_slimbus() - Initialise register map
  *
  * @slimbus: Device that will be interacted with
@@ -798,6 +819,20 @@ bool regmap_ac97_default_volatile(struct device *dev, unsigned int reg);
 				i2c, config)
 
 /**
+ * devm_regmap_init_sccb() - Initialise managed register map
+ *
+ * @i2c: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+#define devm_regmap_init_sccb(i2c, config)				\
+	__regmap_lockdep_wrapper(__devm_regmap_init_sccb, #config,	\
+				i2c, config)
+
+/**
  * devm_regmap_init_spi() - Initialise register map
  *
  * @dev: Device that will be interacted with
-- 
2.7.4
