Return-path: <linux-media-owner@vger.kernel.org>
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:46856 "EHLO
	10.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcDAQhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 12:37:25 -0400
Received: from mail699.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 2ECF61068147
	for <linux-media@vger.kernel.org>; Fri,  1 Apr 2016 18:02:09 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH] Add GS1662 driver (a SPI video serializer)
Message-ID: <56FE9B7F.7060206@nexvision.fr>
Date: Fri, 1 Apr 2016 18:02:07 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010302000505030307050202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010302000505030307050202
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


--------------010302000505030307050202
Content-Type: text/x-patch;
 name="gs1662.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gs1662.patch"

>From 65b48bf1c77801c210bf93c07bc7f513efdbcbb5 Mon Sep 17 00:00:00 2001
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Date: Fri, 1 Apr 2016 17:19:26 +0200
Subject: [PATCH] Add GS1662 driver (a SPI video serializer)

Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
---
 drivers/media/Kconfig      |   1 +
 drivers/media/Makefile     |   2 +-
 drivers/media/spi/Kconfig  |   5 ++
 drivers/media/spi/Makefile |   1 +
 drivers/media/spi/gs1662.c | 128 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/gs1662.c

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a8518fb..d2fa6e7 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -215,5 +215,6 @@ config MEDIA_ATTACH
 source "drivers/media/i2c/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
+source "drivers/media/spi/Kconfig"
 
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbc..75bc82e 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -28,6 +28,6 @@ obj-y += rc/
 # Finally, merge the drivers that require the core
 #
 
-obj-y += common/ platform/ pci/ usb/ mmc/ firewire/
+obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ spi/
 obj-$(CONFIG_VIDEO_DEV) += radio/
 
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
new file mode 100644
index 0000000..d5e7b98
--- /dev/null
+++ b/drivers/media/spi/Kconfig
@@ -0,0 +1,5 @@
+config VIDEO_GS1662
+	tristate "Gennum Serializer 1662 video"
+	depends on SPI
+	---help---
+	  Enable the GS1662 driver which serializes video streams.
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
new file mode 100644
index 0000000..ea64013
--- /dev/null
+++ b/drivers/media/spi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_GS1662) += gs1662.o
diff --git a/drivers/media/spi/gs1662.c b/drivers/media/spi/gs1662.c
new file mode 100644
index 0000000..6698fbf
--- /dev/null
+++ b/drivers/media/spi/gs1662.c
@@ -0,0 +1,128 @@
+/*
+ * GS1662 device registration
+ *
+ * Copyright (C) 2015-2016 Nexvision
+ * Author: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/ctype.h>
+#include <linux/err.h>
+#include <linux/device.h>
+
+#define READ_FLAG		0x8000
+#define WRITE_FLAG		0x0000
+#define BURST_FLAG		0x1000
+
+#define ADDRESS_MASK	0x0FFF
+
+static int gs1662_read_register(struct spi_device *spi, u16 addr, u16 *value)
+{
+	int ret;
+	u16 buf_addr =  (READ_FLAG | (ADDRESS_MASK & addr));
+	u16 buf_value = 0;
+	struct spi_message msg;
+	struct spi_transfer tx[] = {
+		{
+			.tx_buf = &buf_addr,
+			.len = 2,
+			.delay_usecs = 1,
+		}, {
+			.rx_buf = &buf_value,
+			.len = 2,
+			.delay_usecs = 1,
+		},
+	};
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&tx[0], &msg);
+	spi_message_add_tail(&tx[1], &msg);
+	ret = spi_sync(spi, &msg);
+
+	*value = buf_value;
+
+	return ret;
+}
+
+static int gs1662_write_register(struct spi_device *spi, u16 addr, u16 value)
+{
+	int ret;
+	u16 buf_addr = (WRITE_FLAG | (ADDRESS_MASK & addr));
+	u16 buf_value = value;
+	struct spi_message msg;
+	struct spi_transfer tx[] = {
+		{
+			.tx_buf = &buf_addr,
+			.len = 2,
+			.delay_usecs = 1,
+		}, {
+			.tx_buf = &buf_value,
+			.len = 2,
+			.delay_usecs = 1,
+		},
+	};
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&tx[0], &msg);
+	spi_message_add_tail(&tx[1], &msg);
+	ret = spi_sync(spi, &msg);
+
+	return ret;
+}
+
+static int gs1662_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->mode = SPI_MODE_0;
+	spi->irq = -1;
+	spi->max_speed_hz = 10000000;
+	spi->bits_per_word = 16;
+	ret = spi_setup(spi);
+
+	/* Set H_CONFIG to SMPTE timings */
+	gs1662_write_register(spi, 0x0, 0x100);
+
+	return ret;
+}
+
+static int gs1662_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+static struct spi_driver gs1662_driver = {
+	.driver = {
+		.name		= "gs1662",
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= gs1662_probe,
+	.remove		= gs1662_remove,
+};
+
+static int __init gs1662_init(void)
+{
+	spi_register_driver(&gs1662_driver);
+	return 0;
+}
+
+static void __exit gs1662_exit(void)
+{
+	spi_unregister_driver(&gs1662_driver);
+}
+
+module_init(gs1662_init);
+module_exit(gs1662_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>");
+MODULE_DESCRIPTION("GS1662 SPI driver");
-- 
2.5.5


--------------010302000505030307050202--
