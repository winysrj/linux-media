Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0092.outbound.protection.outlook.com ([104.47.32.92]:1377
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754870AbeARIpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 03:45:07 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v5 04/12] [media] cxd2880: Add spi device IO routines
Date: Thu, 18 Jan 2018 17:48:58 +0900
Message-ID: <20180118084858.21151-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
References: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Add functions for initializing, reading and writing to the SPI
device for the Sony CXD2880 DVB-T2/T tuner + demodulator.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---

[Change list]
Changes in V5
   Using SPDX-License-Identifier
   drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
      -modified return error code
      -removed unnecessary parentheses 
   drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
      -removed unnecessary parentheses

Changes in V4
   drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
      -removed unnecessary initialization at variable declaration

Changes in V3
   drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
      -removed unnecessary cast
      -changed cxd2880_memcpy to memcpy
      -modified return code
      -changed hexadecimal code to lower case. 
   drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
      -modified return code
   drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
      -modified return code
   drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
      -removed unnecessary cast
      -modified return code
   drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
      -modified return code

 .../dvb-frontends/cxd2880/cxd2880_devio_spi.c      | 129 +++++++++++++++++++++
 .../dvb-frontends/cxd2880/cxd2880_devio_spi.h      |  23 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h  |  34 ++++++
 .../dvb-frontends/cxd2880/cxd2880_spi_device.c     | 113 ++++++++++++++++++
 .../dvb-frontends/cxd2880/cxd2880_spi_device.h     |  26 +++++
 5 files changed, 325 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
new file mode 100644
index 000000000000..d2e37c95d748
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxd2880_devio_spi.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * I/O interface via SPI
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#include "cxd2880_devio_spi.h"
+
+#define BURST_WRITE_MAX 128
+
+static int cxd2880_io_spi_read_reg(struct cxd2880_io *io,
+				   enum cxd2880_io_tgt tgt,
+				   u8 sub_address, u8 *data,
+				   u32 size)
+{
+	int ret;
+	struct cxd2880_spi *spi = NULL;
+	u8 send_data[6];
+	u8 *read_data_top = data;
+
+	if (!io || !io->if_object || !data)
+		return -EINVAL;
+
+	if (sub_address + size > 0x100)
+		return -EINVAL;
+
+	spi = io->if_object;
+
+	if (tgt == CXD2880_IO_TGT_SYS)
+		send_data[0] = 0x0b;
+	else
+		send_data[0] = 0x0a;
+
+	send_data[3] = 0;
+	send_data[4] = 0;
+	send_data[5] = 0;
+
+	while (size > 0) {
+		send_data[1] = sub_address;
+		if (size > 255)
+			send_data[2] = 255;
+		else
+			send_data[2] = size;
+
+		ret =
+		    spi->write_read(spi, send_data, sizeof(send_data),
+				    read_data_top, send_data[2]);
+		if (ret)
+			return ret;
+
+		sub_address += send_data[2];
+		read_data_top += send_data[2];
+		size -= send_data[2];
+	}
+
+	return ret;
+}
+
+static int cxd2880_io_spi_write_reg(struct cxd2880_io *io,
+				    enum cxd2880_io_tgt tgt,
+				    u8 sub_address,
+				    const u8 *data, u32 size)
+{
+	int ret;
+	struct cxd2880_spi *spi = NULL;
+	u8 send_data[BURST_WRITE_MAX + 4];
+	const u8 *write_data_top = data;
+
+	if (!io || !io->if_object || !data)
+		return -EINVAL;
+
+	if (size > BURST_WRITE_MAX)
+		return -EINVAL;
+
+	if (sub_address + size > 0x100)
+		return -EINVAL;
+
+	spi = io->if_object;
+
+	if (tgt == CXD2880_IO_TGT_SYS)
+		send_data[0] = 0x0f;
+	else
+		send_data[0] = 0x0e;
+
+	while (size > 0) {
+		send_data[1] = sub_address;
+		if (size > 255)
+			send_data[2] = 255;
+		else
+			send_data[2] = size;
+
+		memcpy(&send_data[3], write_data_top, send_data[2]);
+
+		if (tgt == CXD2880_IO_TGT_SYS) {
+			send_data[3 + send_data[2]] = 0x00;
+			ret = spi->write(spi, send_data, send_data[2] + 4);
+		} else {
+			ret = spi->write(spi, send_data, send_data[2] + 3);
+		}
+		if (ret)
+			return ret;
+
+		sub_address += send_data[2];
+		write_data_top += send_data[2];
+		size -= send_data[2];
+	}
+
+	return ret;
+}
+
+int cxd2880_io_spi_create(struct cxd2880_io *io,
+			  struct cxd2880_spi *spi, u8 slave_select)
+{
+	if (!io || !spi)
+		return -EINVAL;
+
+	io->read_regs = cxd2880_io_spi_read_reg;
+	io->write_regs = cxd2880_io_spi_write_reg;
+	io->write_reg = cxd2880_io_common_write_one_reg;
+	io->if_object = spi;
+	io->i2c_address_sys = 0;
+	io->i2c_address_demod = 0;
+	io->slave_select = slave_select;
+
+	return 0;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
new file mode 100644
index 000000000000..27f7cb12fad4
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_devio_spi.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * I/O interface via SPI
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_DEVIO_SPI_H
+#define CXD2880_DEVIO_SPI_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_io.h"
+#include "cxd2880_spi.h"
+
+#include "cxd2880_tnrdmd.h"
+
+int cxd2880_io_spi_create(struct cxd2880_io *io,
+			  struct cxd2880_spi *spi,
+			  u8 slave_select);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
new file mode 100644
index 000000000000..2be207461847
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_spi.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access definitions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_SPI_H
+#define CXD2880_SPI_H
+
+#include "cxd2880_common.h"
+
+enum cxd2880_spi_mode {
+	CXD2880_SPI_MODE_0,
+	CXD2880_SPI_MODE_1,
+	CXD2880_SPI_MODE_2,
+	CXD2880_SPI_MODE_3
+};
+
+struct cxd2880_spi {
+	int (*read)(struct cxd2880_spi *spi, u8 *data,
+		    u32 size);
+	int (*write)(struct cxd2880_spi *spi, const u8 *data,
+		     u32 size);
+	int (*write_read)(struct cxd2880_spi *spi,
+			  const u8 *tx_data, u32 tx_size,
+			  u8 *rx_data, u32 rx_size);
+	u32 flags;
+	void *user;
+};
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
new file mode 100644
index 000000000000..b8cbaa8d7aff
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxd2880_spi_device.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access functions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#include <linux/spi/spi.h>
+
+#include "cxd2880_spi_device.h"
+
+static int cxd2880_spi_device_write(struct cxd2880_spi *spi,
+				    const u8 *data, u32 size)
+{
+	struct cxd2880_spi_device *spi_device = NULL;
+	struct spi_message msg;
+	struct spi_transfer tx;
+	int result = 0;
+
+	if (!spi || !spi->user || !data || size == 0)
+		return -EINVAL;
+
+	spi_device = spi->user;
+
+	memset(&tx, 0, sizeof(tx));
+	tx.tx_buf = data;
+	tx.len = size;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&tx, &msg);
+	result = spi_sync(spi_device->spi, &msg);
+
+	if (result < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int cxd2880_spi_device_write_read(struct cxd2880_spi *spi,
+					 const u8 *tx_data,
+					 u32 tx_size,
+					 u8 *rx_data,
+					 u32 rx_size)
+{
+	struct cxd2880_spi_device *spi_device = NULL;
+	int result = 0;
+
+	if (!spi || !spi->user || !tx_data ||
+	    !tx_size || !rx_data || !rx_size)
+		return -EINVAL;
+
+	spi_device = spi->user;
+
+	result = spi_write_then_read(spi_device->spi, tx_data,
+				     tx_size, rx_data, rx_size);
+	if (result < 0)
+		return -EIO;
+
+	return 0;
+}
+
+int
+cxd2880_spi_device_initialize(struct cxd2880_spi_device *spi_device,
+			      enum cxd2880_spi_mode mode,
+			      u32 speed_hz)
+{
+	int result = 0;
+	struct spi_device *spi = spi_device->spi;
+
+	switch (mode) {
+	case CXD2880_SPI_MODE_0:
+		spi->mode = SPI_MODE_0;
+		break;
+	case CXD2880_SPI_MODE_1:
+		spi->mode = SPI_MODE_1;
+		break;
+	case CXD2880_SPI_MODE_2:
+		spi->mode = SPI_MODE_2;
+		break;
+	case CXD2880_SPI_MODE_3:
+		spi->mode = SPI_MODE_3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spi->max_speed_hz = speed_hz;
+	spi->bits_per_word = 8;
+	result = spi_setup(spi);
+	if (result != 0) {
+		pr_err("spi_setup failed %d\n", result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int cxd2880_spi_device_create_spi(struct cxd2880_spi *spi,
+				  struct cxd2880_spi_device *spi_device)
+{
+	if (!spi || !spi_device)
+		return -EINVAL;
+
+	spi->read = NULL;
+	spi->write = cxd2880_spi_device_write;
+	spi->write_read = cxd2880_spi_device_write_read;
+	spi->flags = 0;
+	spi->user = spi_device;
+
+	return 0;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
new file mode 100644
index 000000000000..05e3a03de3a3
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_spi_device.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access interface
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_SPI_DEVICE_H
+#define CXD2880_SPI_DEVICE_H
+
+#include "cxd2880_spi.h"
+
+struct cxd2880_spi_device {
+	struct spi_device *spi;
+};
+
+int cxd2880_spi_device_initialize(struct cxd2880_spi_device *spi_device,
+				  enum cxd2880_spi_mode mode,
+				  u32 speedHz);
+
+int cxd2880_spi_device_create_spi(struct cxd2880_spi *spi,
+				  struct cxd2880_spi_device *spi_device);
+
+#endif /* CXD2880_SPI_DEVICE_H */
-- 
2.15.1
