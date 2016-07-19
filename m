Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbcGSP5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:57:11 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [RFC 7/7] [media] rc: add support for IR LEDs driven through SPI
Date: Wed, 20 Jul 2016 00:56:58 +0900
Message-id: <1468943818-26025-8-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir-spi is a simple device driver which supports the
connection between an IR LED and the MOSI line of an SPI device.

The driver, indeed, uses the SPI framework to stream the raw data
provided by userspace through a character device. The chardev is
handled by the LIRC framework and its functionality basically
provides:

 - raw write: data to be sent to the SPI and then streamed to the
   MOSI line;
 - set frequency: sets the frequency whith which the data should
   be sent;

The character device is created under /dev/lircX name, where X is
and ID assigned by the LIRC framework.

Example of usage:

        fd = open("/dev/lirc0", O_RDWR);
        if (fd < 0)
                return -1;

        val = 608000;
        ret = ioctl(fd, LIRC_SET_SEND_CARRIER, &val);
        if (ret < 0)
                return -1;

        n = write(fd, buffer, BUF_LEN);
        if (n < 0 || n != BUF_LEN)
                ret = -1;

        close(fd);

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/Kconfig  |   9 ++++
 drivers/media/rc/Makefile |   1 +
 drivers/media/rc/ir-spi.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+)
 create mode 100644 drivers/media/rc/ir-spi.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index bd4d685..dacaa29 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -261,6 +261,15 @@ config IR_REDRAT3
 	   To compile this driver as a module, choose M here: the
 	   module will be called redrat3.
 
+config IR_SPI
+	tristate "SPI connected IR LED"
+	depends on SPI && LIRC
+	---help---
+	  Say Y if you want to use an IR LED connected through SPI bus.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ir-spi.
+
 config IR_STREAMZAP
 	tristate "Streamzap PC Remote IR Receiver"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 379a5c0..1417c8d 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
 obj-$(CONFIG_IR_ENE) += ene_ir.o
 obj-$(CONFIG_IR_REDRAT3) += redrat3.o
 obj-$(CONFIG_IR_RX51) += ir-rx51.o
+obj-$(CONFIG_IR_SPI) += ir-spi.o
 obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
 obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
 obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
new file mode 100644
index 0000000..7b6f344
--- /dev/null
+++ b/drivers/media/rc/ir-spi.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ * Author: Andi Shyti <andi.shyti@samsung.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * SPI driven IR LED device driver
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+#include <media/rc-core.h>
+
+#define IR_SPI_DRIVER_NAME		"ir-spi"
+
+#define IR_SPI_DEFAULT_FREQUENCY	38000
+#define IR_SPI_BIT_PER_WORD		    8
+
+struct ir_spi_data {
+	struct rc_dev *rc;
+	struct spi_device *spi;
+	struct spi_transfer xfer;
+	struct mutex mutex;
+	struct regulator *regulator;
+};
+
+static int ir_spi_tx(struct rc_dev *dev, unsigned *buffer, unsigned n)
+{
+	int ret;
+	struct ir_spi_data *idata = (struct ir_spi_data *) dev->priv;
+
+	ret = regulator_enable(idata->regulator);
+	if (ret)
+		return ret;
+
+	mutex_lock(&idata->mutex);
+	idata->xfer.len = n;
+	idata->xfer.tx_buf = buffer;
+	mutex_unlock(&idata->mutex);
+
+	ret = spi_sync_transfer(idata->spi, &idata->xfer, 1);
+	if (ret)
+		dev_err(&idata->spi->dev, "unable to deliver the signal\n");
+
+	regulator_disable(idata->regulator);
+
+	return ret;
+}
+
+static int ir_spi_set_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct ir_spi_data *idata = (struct ir_spi_data *) dev->priv;
+
+	if (!carrier)
+		return -EINVAL;
+
+	mutex_lock(&idata->mutex);
+	idata->xfer.speed_hz = carrier;
+	mutex_unlock(&idata->mutex);
+
+	return 0;
+}
+
+static int ir_spi_probe(struct spi_device *spi)
+{
+	int ret;
+	struct ir_spi_data *idata;
+
+	idata = devm_kzalloc(&spi->dev, sizeof(*idata), GFP_KERNEL);
+	if (!idata)
+		return -ENOMEM;
+
+	idata->regulator = devm_regulator_get(&spi->dev, "irda_regulator");
+	if (IS_ERR(idata->regulator))
+		return PTR_ERR(idata->regulator);
+
+	idata->rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX);
+	if (!idata->rc)
+		return -ENOMEM;
+
+	idata->rc->s_tx_carrier = ir_spi_set_tx_carrier;
+	idata->rc->tx_ir = ir_spi_tx;
+	idata->rc->driver_name = IR_SPI_DRIVER_NAME;
+	idata->rc->priv = idata;
+
+        ret = rc_register_device(idata->rc);
+	if (ret)
+		return ret;
+
+	mutex_init(&idata->mutex);
+
+	idata->spi = spi;
+
+	idata->xfer.bits_per_word = IR_SPI_BIT_PER_WORD;
+	idata->xfer.speed_hz = IR_SPI_DEFAULT_FREQUENCY;
+
+	return 0;
+}
+
+static int ir_spi_remove(struct spi_device *spi)
+{
+	struct ir_spi_data *idata = spi_get_drvdata(spi);
+
+	rc_unregister_device(idata->rc);
+
+	return 0;
+}
+
+static const struct of_device_id ir_spi_of_match[] = {
+	{ .compatible = "ir-spi" },
+	{},
+};
+
+static struct spi_driver ir_spi_driver = {
+	.probe = ir_spi_probe,
+	.remove = ir_spi_remove,
+	.driver = {
+		.name = IR_SPI_DRIVER_NAME,
+		.of_match_table = ir_spi_of_match,
+	},
+};
+
+module_spi_driver(ir_spi_driver);
+
+MODULE_AUTHOR("Andi Shyti <andi.shyti@samsung.com>");
+MODULE_DESCRIPTION("SPI IR LED");
+MODULE_LICENSE("GPL v2");
-- 
2.8.1

