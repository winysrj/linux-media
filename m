Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53758 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758800AbcLPGMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 01:12:53 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v5 6/6] [media] rc: add support for IR LEDs driven through SPI
Date: Fri, 16 Dec 2016 15:12:18 +0900
Message-id: <20161216061218.5906-7-andi.shyti@samsung.com>
In-reply-to: <20161216061218.5906-1-andi.shyti@samsung.com>
References: <20161216061218.5906-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir-spi is a simple device driver which supports the
connection between an IR LED and the MOSI line of an SPI device.

The driver, indeed, uses the SPI framework to stream the raw data
provided by userspace through an rc character device. The chardev
is handled by the LIRC framework and its functionality basically
provides:

 - write: the driver gets a pulse/space signal and translates it
   to a binary signal that will be streamed to the IR led through
   the SPI framework.
 - set frequency: sets the frequency whith which the data should
   be sent. This is handle with ioctl with the
   LIRC_SET_SEND_CARRIER flag (as per lirc documentation)
 - set duty cycle: this is also handled with ioctl with the
   LIRC_SET_SEND_DUTY_CYCLE flag. The driver handles duty cycles
   of 50%, 60%, 70%, 75%, 80% and 90%, calculated on 16bit data.

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

	val = 60;
        ret = ioctl(fd, LIRC_SET_SEND_DUTY_CYCLE, &val);
        if (ret < 0)
                return -1;

        n = write(fd, buffer, BUF_LEN);
        if (n < 0 || n != BUF_LEN)
                ret = -1;

        close(fd);

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
Reviewed-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig  |   9 +++
 drivers/media/rc/Makefile |   1 +
 drivers/media/rc/ir-spi.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 drivers/media/rc/ir-spi.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 629e8ca..3351e25 100644
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
index 3a984ee..938c98b 100644
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
index 0000000..d45c603
--- /dev/null
+++ b/drivers/media/rc/ir-spi.c
@@ -0,0 +1,199 @@
+/*
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ * Author: Andi Shyti <andi.shyti@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * SPI driven IR LED device driver
+ */
+
+#include <linux/delay.h>
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
+/* pulse value for different duty cycles */
+#define IR_SPI_PULSE_DC_50		0xff00
+#define IR_SPI_PULSE_DC_60		0xfc00
+#define IR_SPI_PULSE_DC_70		0xf800
+#define IR_SPI_PULSE_DC_75		0xf000
+#define IR_SPI_PULSE_DC_80		0xc000
+#define IR_SPI_PULSE_DC_90		0x8000
+
+#define IR_SPI_DEFAULT_FREQUENCY	38000
+#define IR_SPI_BIT_PER_WORD		    8
+#define IR_SPI_MAX_BUFSIZE		 4096
+
+struct ir_spi_data {
+	u32 freq;
+	u8 duty_cycle;
+	bool negated;
+
+	u16 tx_buf[IR_SPI_MAX_BUFSIZE];
+	u16 pulse;
+	u16 space;
+
+	struct rc_dev *rc;
+	struct spi_device *spi;
+	struct regulator *regulator;
+};
+
+static int ir_spi_tx(struct rc_dev *dev,
+			unsigned int *buffer, unsigned int count)
+{
+	int i;
+	int ret;
+	unsigned int len = 0;
+	struct ir_spi_data *idata = dev->priv;
+	struct spi_transfer xfer;
+
+	/* convert the pulse/space signal to raw binary signal */
+	for (i = 0; i < count; i++) {
+		int j;
+		u16 val = ((i+1) % 2) ? idata->pulse : idata->space;
+
+		if (len + buffer[i] >= IR_SPI_MAX_BUFSIZE)
+			return -EINVAL;
+
+		/*
+		 * the first value in buffer is a pulse, so that 0, 2, 4, ...
+		 * contain a pulse duration. On the contrary, 1, 3, 5, ...
+		 * contain a space duration.
+		 */
+		val = (i % 2) ? idata->space : idata->pulse;
+		for (j = 0; j < buffer[i]; j++)
+			idata->tx_buf[len++] = val;
+	}
+
+	memset(&xfer, 0, sizeof(xfer));
+
+	xfer.speed_hz = idata->freq;
+	xfer.len = len * sizeof(*idata->tx_buf);
+	xfer.tx_buf = idata->tx_buf;
+
+	ret = regulator_enable(idata->regulator);
+	if (ret)
+		return ret;
+
+	ret = spi_sync_transfer(idata->spi, &xfer, 1);
+	if (ret)
+		dev_err(&idata->spi->dev, "unable to deliver the signal\n");
+
+	regulator_disable(idata->regulator);
+
+	return ret ? ret : count;
+}
+
+static int ir_spi_set_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct ir_spi_data *idata = dev->priv;
+
+	if (!carrier)
+		return -EINVAL;
+
+	idata->freq = carrier;
+
+	return 0;
+}
+
+static int ir_spi_set_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
+{
+	struct ir_spi_data *idata = dev->priv;
+
+	if (duty_cycle >= 90)
+		idata->pulse = IR_SPI_PULSE_DC_90;
+	else if (duty_cycle >= 80)
+		idata->pulse = IR_SPI_PULSE_DC_80;
+	else if (duty_cycle >= 75)
+		idata->pulse = IR_SPI_PULSE_DC_75;
+	else if (duty_cycle >= 70)
+		idata->pulse = IR_SPI_PULSE_DC_70;
+	else if (duty_cycle >= 60)
+		idata->pulse = IR_SPI_PULSE_DC_60;
+	else
+		idata->pulse = IR_SPI_PULSE_DC_50;
+
+	if (idata->negated) {
+		idata->pulse = ~idata->pulse;
+		idata->space = 0xffff;
+	} else {
+		idata->space = 0;
+	}
+
+	return 0;
+}
+
+static int ir_spi_probe(struct spi_device *spi)
+{
+	int ret;
+	u8 dc;
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
+	idata->rc = devm_rc_allocate_device(&spi->dev, RC_DRIVER_IR_RAW_TX);
+	if (!idata->rc)
+		return -ENOMEM;
+
+	idata->rc->tx_ir           = ir_spi_tx;
+	idata->rc->s_tx_carrier    = ir_spi_set_tx_carrier;
+	idata->rc->s_tx_duty_cycle = ir_spi_set_duty_cycle;
+	idata->rc->driver_name     = IR_SPI_DRIVER_NAME;
+	idata->rc->priv            = idata;
+	idata->spi                 = spi;
+
+	idata->negated = of_property_read_bool(spi->dev.of_node,
+							"led-active-low");
+	ret = of_property_read_u8(spi->dev.of_node, "duty-cycle", &dc);
+	if (ret)
+		dc = 50;
+
+	/* ir_spi_set_duty_cycle cannot fail,
+	 * it returns int to be compatible with the
+	 * rc->s_tx_duty_cycle function
+	 */
+	ir_spi_set_duty_cycle(idata->rc, dc);
+
+	idata->freq = IR_SPI_DEFAULT_FREQUENCY;
+
+	return devm_rc_register_device(&spi->dev, idata->rc);
+}
+
+static int ir_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+static const struct of_device_id ir_spi_of_match[] = {
+	{ .compatible = "ir-spi-led" },
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
2.10.2

