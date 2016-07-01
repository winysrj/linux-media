Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45303 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbcGAIhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:37:35 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected with SPI
Date: Fri, 01 Jul 2016 17:33:42 +0900
Message-id: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
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
 - set length: sets the data length. This information is
   optional, if the length is set, then userspace should send raw
   data only with that length; while if the length is set to '0',
   then the driver will figure out himself the length of the data
   based on the length of the data written on the character
   device.
   The latter is not recommended, though, as the driver, at
   any write, allocates and deallocates a buffer where the data
   from userspace are stored.

The driver provides three feedback commands:

 - get length: reads the length set and (as mentioned), if the
   length is '0' it will be calculated at any write
 - get frequency: the driver reports the frequency. If userpace
   doesn't set the frequency, the driver will use a default value
   of 38000Hz.

The character device is created under /dev/lircX name, where X is
and ID assigned by the LIRC framework.

Example of usage:

        int fd, ret;
        ssize_t n;
        uint32_t val = 0;

        fd = open("/dev/lirc0", O_RDWR);
        if (fd < 0) {
                fprintf(stderr, "unable to open the device\n");
                return -1;
        }

        /* ioctl set frequency and length parameters */
        val = 6430;
        ret = ioctl(fd, LIRC_SET_LENGTH, &val);
        if (ret < 0)
                fprintf(stderr, "LIRC_SET_LENGTH failed\n");
        val = 608000;
        ret = ioctl(fd, LIRC_SET_FREQUENCY, &val);
        if (ret < 0)
                fprintf(stderr, "LIRC_SET_FREQUENCY failed\n");

        /* read back length and frequency parameters */
        ret = ioctl(fd, LIRC_GET_LENGTH, &val);
        if (ret < 0)
                fprintf(stderr, "LIRC_GET_LENGTH failed\n");
        else
                fprintf(stdout, "legnth = %u\n", val);

        ret = ioctl(fd, LIRC_GET_FREQUENCY, &val);
        if (ret < 0)
                fprintf(stderr, "LIRC_GET_FREQUENCY failed\n");
        else
                fprintf(stdout, "frequency = %u\n", val);

        /* write data to device */
        n = write(fd, b, 6430);
        if (n < 0) {
                fprintf(stderr, "unable to write to the device\n");
                ret = -1;
        } else if (n != 6430) {
                fprintf(stderr, "failed to write everything, wrote %ld instead\n", n);
                ret = -1;
        } else {
                fprintf(stdout, "written all the %ld data\n", n);
        }

        close(fd);

The driver supports multi task access, but all the processes
which hold the driver should use the same length and frequency
parameters.

Change-Id: I323d7dd4a56d6dcf48f2c695293822eb04bdb85f
Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 Documentation/devicetree/bindings/media/spi-ir.txt |  24 ++
 drivers/media/rc/Kconfig                           |   9 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ir-spi.c                          | 301 +++++++++++++++++++++
 4 files changed, 335 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt
 create mode 100644 drivers/media/rc/ir-spi.c

diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
new file mode 100644
index 0000000..2232d92
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi-ir.txt
@@ -0,0 +1,24 @@
+Device tree bindings for IR LED connected through SPI bus which is used as
+remote controller.
+
+The IR LED switch is connected to the MOSI line of the SPI device and the data
+are delivered thourgh that.
+
+Required properties:
+	- compatible: should be "ir-spi"
+
+Optional properties:
+	- irled,switch: specifies the gpio switch which enables the irled
+
+Example:
+
+        irled@0 {
+                compatible = "ir-spi";
+                reg = <0x0>;
+                spi-max-frequency = <5000000>;
+                irled,switch = <&gpr3 3 0>;
+
+                controller-data {
+                        samsung,spi-feedback-delay = <0>;
+                };
+        };
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
index 0000000..6eb14e9
--- /dev/null
+++ b/drivers/media/rc/ir-spi.c
@@ -0,0 +1,301 @@
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
+#include <media/lirc_dev.h>
+
+#define IR_SPI_DRIVER_NAME		"ir-spi"
+
+#define IR_SPI_DEFAULT_FREQUENCY	38000
+#define IR_SPI_BIT_PER_WORD		    8
+
+struct ir_spi_data {
+	u16 nusers;
+	int power_gpio;
+
+	u8 *buffer;
+
+	struct lirc_driver lirc_driver;
+	struct spi_device *spi;
+	struct spi_transfer xfer;
+	struct mutex mutex;
+	struct regulator *regulator;
+};
+
+static ssize_t ir_spi_chardev_write(struct file *file,
+					const char __user *buffer,
+					size_t length, loff_t *offset)
+{
+	struct ir_spi_data *idata = file->private_data;
+	bool please_free = false;
+	int ret = 0;
+
+	if (idata->xfer.len && (idata->xfer.len != length))
+		return -EINVAL;
+
+	mutex_lock(&idata->mutex);
+
+	if (!idata->xfer.len) {
+		idata->buffer = kmalloc(length, GFP_KERNEL);
+
+		if (!idata->buffer) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+
+		idata->xfer.len = length;
+		please_free = true;
+	}
+
+	if (copy_from_user(idata->buffer, buffer, length)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	ret = regulator_enable(idata->regulator);
+	if (ret) {
+		dev_err(&idata->spi->dev, "failed to power on the LED\n");
+		goto out_free;
+	}
+
+	idata->xfer.tx_buf = idata->buffer;
+
+	ret = spi_sync_transfer(idata->spi, &idata->xfer, 1);
+	if (ret)
+		dev_err(&idata->spi->dev, "unable to deliver the signal\n");
+
+	regulator_disable(idata->regulator);
+
+out_free:
+	if (please_free) {
+		kfree(idata->buffer);
+		idata->xfer.len = 0;
+		idata->buffer = NULL;
+	}
+
+out_unlock:
+	mutex_unlock(&idata->mutex);
+
+	return ret ? ret : length;
+}
+
+static int ir_spi_chardev_open(struct inode *inode, struct file *file)
+{
+	struct ir_spi_data *idata = lirc_get_pdata(file);
+
+	if (unlikely(idata->nusers >= SHRT_MAX)) {
+		dev_err(&idata->spi->dev, "device busy\n");
+		return -EBUSY;
+	}
+
+	file->private_data = idata;
+
+	mutex_lock(&idata->mutex);
+	idata->nusers++;
+	mutex_unlock(&idata->mutex);
+
+	return 0;
+}
+
+static int ir_spi_chardev_close(struct inode *inode, struct file *file)
+{
+	struct ir_spi_data *idata = lirc_get_pdata(file);
+
+	mutex_lock(&idata->mutex);
+	idata->nusers--;
+
+	/*
+	 * check if someone else is using the driver,
+	 * if not, then:
+	 *
+	 *  - reset length and frequency values to default
+	 *  - shut down the LED
+	 *  - free the buffer (NULL or ZERO_SIZE_PTR are noop)
+	 */
+	if (!idata->nusers) {
+		idata->xfer.len = 0;
+		idata->xfer.speed_hz = IR_SPI_DEFAULT_FREQUENCY;
+
+		kfree(idata->buffer);
+		idata->buffer = NULL;
+	}
+
+	mutex_unlock(&idata->mutex);
+
+	return 0;
+}
+
+static long ir_spi_chardev_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	__u32 p;
+	s32 ret;
+	struct ir_spi_data *idata = file->private_data;
+
+	switch (cmd) {
+	case LIRC_GET_FEATURES:
+		return put_user(idata->lirc_driver.features,
+					(__u32 __user *) arg);
+
+	case LIRC_GET_LENGTH:
+		return put_user(idata->xfer.len, (__u32 __user *) arg);
+
+	case LIRC_SET_LENGTH: {
+		void *new;
+
+		ret = get_user(p, (__u32 __user *) arg);
+		if (ret)
+			return ret;
+
+		/*
+		 * the user is trying to set the same
+		 * length of the current value
+		 */
+		if (idata->xfer.len == p)
+			return 0;
+
+		/*
+		 * multiple users should use the driver with the
+		 * length, otherwise return EPERM same data
+		 */
+		if (idata->nusers > 1)
+			return -EPERM;
+
+		/*
+		 * if the buffer is already allocated, reallocate it with the
+		 * desired value. If the desired value is 0, then the buffer is
+		 * freed from krealloc()
+		 */
+		if (idata->xfer.len)
+			new = krealloc(idata->buffer, p, GFP_KERNEL);
+		else
+			new = kmalloc(p, GFP_KERNEL);
+
+		if (!new)
+			return -ENOMEM;
+
+		mutex_lock(&idata->mutex);
+		idata->buffer = new;
+		idata->xfer.len = p;
+		mutex_unlock(&idata->mutex);
+
+		return 0;
+	}
+
+	case LIRC_GET_SEND_CARRIER:
+		return put_user(idata->xfer.speed_hz, (__u32 __user *) arg);
+
+	case LIRC_SET_SEND_CARRIER:
+		ret = get_user(p, (__u32 __user *) arg);
+		if (ret)
+			return ret;
+
+		/*
+		 * The frequency cannot be obviously set to '0',
+		 * while, as in the case of the data length,
+		 * multiple users should use the driver with the same
+		 * frequency value, otherwise return EPERM
+		 */
+		if (!p || ((idata->nusers > 1) && p != idata->xfer.speed_hz))
+			return -EPERM;
+
+		mutex_lock(&idata->mutex);
+		idata->xfer.speed_hz = p;
+		mutex_unlock(&idata->mutex);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const struct file_operations ir_spi_fops = {
+	.owner   = THIS_MODULE,
+	.read    = lirc_dev_fop_read,
+	.write   = ir_spi_chardev_write,
+	.poll    = lirc_dev_fop_poll,
+	.open    = ir_spi_chardev_open,
+	.release = ir_spi_chardev_close,
+	.llseek  = noop_llseek,
+	.unlocked_ioctl = ir_spi_chardev_ioctl,
+	.compat_ioctl   = ir_spi_chardev_ioctl,
+};
+
+static int ir_spi_probe(struct spi_device *spi)
+{
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
+	snprintf(idata->lirc_driver.name, sizeof(idata->lirc_driver.name),
+							IR_SPI_DRIVER_NAME);
+	idata->lirc_driver.features    = LIRC_CAN_SEND_RAW;
+	idata->lirc_driver.code_length = 1;
+	idata->lirc_driver.fops        = &ir_spi_fops;
+	idata->lirc_driver.dev         = &spi->dev;
+	idata->lirc_driver.data        = idata;
+	idata->lirc_driver.owner       = THIS_MODULE;
+	idata->lirc_driver.minor       = -1;
+
+	idata->lirc_driver.minor = lirc_register_driver(&idata->lirc_driver);
+	if (idata->lirc_driver.minor < 0) {
+		dev_err(&spi->dev, "unable to generate character device\n");
+		return idata->lirc_driver.minor;
+	}
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
+	lirc_unregister_driver(idata->lirc_driver.minor);
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

