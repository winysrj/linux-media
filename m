Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0134.outbound.protection.outlook.com ([104.47.37.134]:14796
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754788AbeARInr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 03:43:47 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v5 03/12] [media] cxd2880: Add common files for the driver
Date: Thu, 18 Jan 2018 17:47:38 +0900
Message-ID: <20180118084738.21058-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
References: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

These are common files for the driver for the
Sony CXD2880 DVB-T2/T tuner + demodulator.
These contains helper functions for the driver.

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
   drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
      -modified return not to use ret parameter. 
   drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
      -removed unnecessary parentheses
   drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
      -removed function proto type about cxd2880_stopwatch
      -removed CXD2880_ARG_UNUSED
   #drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
      -cxd2880_stopwatch_port.c file was removed from V5.

Changes in V4
   drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
      -removed unnecessary initialization at variable declaration
      -modified how to write consecutive registers

Changes in V3
   drivers/media/dvb-frontends/cxd2880/cxd2880.h
      -no change
   drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
      -changed MASKUPPER/MASKLOWER with GENMASK 
   drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
      -removed definition NULL and SONY_SLEEP
      -changed CXD2880_SLEEP to usleep_range
      -changed cxd2880_atomic_set to atomic_set
      -removed cxd2880_atomic struct and cxd2880_atomic_read
      -changed stop-watch function
      -modified return code
   drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
      -removed unnecessary cast
      -modified return code
      -changed hexadecimal code to lower case. 
   drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
      -modified return code 
   drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
      -changed CXD2880_SLEEP to usleep_range
      -changed stop-watch function
      -modified return code
   #drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
      -cxd2880_stdlib.h file was removed from V3.

 drivers/media/dvb-frontends/cxd2880/cxd2880.h      | 29 ++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.c   | 21 +++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.h   | 19 +++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c   | 66 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h   | 54 ++++++++++++++++++
 5 files changed, 189 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880.h b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
new file mode 100644
index 000000000000..4ea3510aab66
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver public definitions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_H
+#define CXD2880_H
+
+struct cxd2880_config {
+	struct spi_device *spi;
+	struct mutex *spi_mutex; /* For SPI access exclusive control */
+};
+
+#if IS_REACHABLE(CONFIG_DVB_CXD2880)
+extern struct dvb_frontend *cxd2880_attach(struct dvb_frontend *fe,
+					struct cxd2880_config *cfg);
+#else
+static inline struct dvb_frontend *cxd2880_attach(struct dvb_frontend *fe,
+					struct cxd2880_config *cfg)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_CXD2880 */
+
+#endif /* CXD2880_H */
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
new file mode 100644
index 000000000000..d6f5af6609c1
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxd2880_common.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common functions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#include "cxd2880_common.h"
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen)
+{
+	if (!bitlen || bitlen >= 32)
+		return (int)value;
+
+	if (value & (u32)(1 << (bitlen - 1)))
+		return (int)(GENMASK(31, bitlen) | value);
+	else
+		return (int)(GENMASK(bitlen - 1, 0) & value);
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
new file mode 100644
index 000000000000..b05bce71ab35
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_common.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver common definitions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_COMMON_H
+#define CXD2880_COMMON_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
new file mode 100644
index 000000000000..9d932bccfa6c
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxd2880_io.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface functions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#include "cxd2880_io.h"
+
+int cxd2880_io_common_write_one_reg(struct cxd2880_io *io,
+				    enum cxd2880_io_tgt tgt,
+				    u8 sub_address, u8 data)
+{
+	if (!io)
+		return -EINVAL;
+
+	return io->write_regs(io, tgt, sub_address, &data, 1);
+}
+
+int cxd2880_io_set_reg_bits(struct cxd2880_io *io,
+			    enum cxd2880_io_tgt tgt,
+			    u8 sub_address, u8 data, u8 mask)
+{
+	int ret;
+
+	if (!io)
+		return -EINVAL;
+
+	if (mask == 0x00)
+		return 0;
+
+	if (mask != 0xff) {
+		u8 rdata = 0x00;
+
+		ret = io->read_regs(io, tgt, sub_address, &rdata, 1);
+		if (ret)
+			return ret;
+
+		data = (data & mask) | (rdata & (mask ^ 0xff));
+	}
+
+	return io->write_reg(io, tgt, sub_address, data);
+}
+
+int cxd2880_io_write_multi_regs(struct cxd2880_io *io,
+			     enum cxd2880_io_tgt tgt,
+			     const struct cxd2880_reg_value reg_value[],
+			     u8 size)
+{
+	int ret;
+	int i;
+
+	if (!io)
+		return -EINVAL;
+
+	for (i = 0; i < size ; i++) {
+		ret = io->write_reg(io, tgt, reg_value[i].addr,
+				    reg_value[i].value);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
new file mode 100644
index 000000000000..ba550278881d
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_io.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface definitions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_IO_H
+#define CXD2880_IO_H
+
+#include "cxd2880_common.h"
+
+enum cxd2880_io_tgt {
+	CXD2880_IO_TGT_SYS,
+	CXD2880_IO_TGT_DMD
+};
+
+struct cxd2880_reg_value {
+	u8 addr;
+	u8 value;
+};
+
+struct cxd2880_io {
+	int (*read_regs)(struct cxd2880_io *io,
+			 enum cxd2880_io_tgt tgt, u8 sub_address,
+			 u8 *data, u32 size);
+	int (*write_regs)(struct cxd2880_io *io,
+			  enum cxd2880_io_tgt tgt, u8 sub_address,
+			  const u8 *data, u32 size);
+	int (*write_reg)(struct cxd2880_io *io,
+			 enum cxd2880_io_tgt tgt, u8 sub_address,
+			 u8 data);
+	void *if_object;
+	u8 i2c_address_sys;
+	u8 i2c_address_demod;
+	u8 slave_select;
+	void *user;
+};
+
+int cxd2880_io_common_write_one_reg(struct cxd2880_io *io,
+				    enum cxd2880_io_tgt tgt,
+				    u8 sub_address, u8 data);
+
+int cxd2880_io_set_reg_bits(struct cxd2880_io *io,
+			    enum cxd2880_io_tgt tgt,
+			    u8 sub_address, u8 data, u8 mask);
+
+int cxd2880_io_write_multi_regs(struct cxd2880_io *io,
+				enum cxd2880_io_tgt tgt,
+				const struct cxd2880_reg_value reg_value[],
+				u8 size);
+#endif
-- 
2.15.1
