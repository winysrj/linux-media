Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0090.outbound.protection.outlook.com ([104.47.36.90]:27960
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdHPEa2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 00:30:28 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v3 03/14] [media] cxd2880: Add common files for the driver
Date: Wed, 16 Aug 2017 13:33:38 +0900
Message-ID: <20170816043338.21251-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

These are common files for the driver for the
Sony CXD2880 DVB-T2/T tuner + demodulator.
These contains helper functions for the driver.

[Change list]
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

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 drivers/media/dvb-frontends/cxd2880/cxd2880.h      | 46 +++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.c   | 38 ++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.h   | 50 ++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c   | 68 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h   | 62 ++++++++++++++++++++
 .../dvb-frontends/cxd2880/cxd2880_stopwatch_port.c | 60 +++++++++++++++++++
 6 files changed, 324 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880.h b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
new file mode 100644
index 000000000000..281f9a784eb5
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
@@ -0,0 +1,46 @@
+/*
+ * cxd2880.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver public definitions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
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
index 000000000000..ffaa140bb8cb
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
@@ -0,0 +1,38 @@
+/*
+ * cxd2880_common.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common functions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "cxd2880_common.h"
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen)
+{
+	if ((bitlen == 0) || (bitlen >= 32))
+		return (int)value;
+
+	if (value & (u32)(1 << (bitlen - 1)))
+		return (int)(GENMASK(31, bitlen) | value);
+	else
+		return (int)(GENMASK(bitlen - 1, 0) & value);
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
new file mode 100644
index 000000000000..cf6b800809ee
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -0,0 +1,50 @@
+/*
+ * cxd2880_common.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver common definitions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
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
+#define CXD2880_ARG_UNUSED(arg) ((void)(arg))
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen);
+
+struct cxd2880_stopwatch {
+	unsigned long start_time;
+};
+
+int cxd2880_stopwatch_start(struct cxd2880_stopwatch *stopwatch);
+
+int cxd2880_stopwatch_sleep(struct cxd2880_stopwatch *stopwatch,
+			    u32 ms);
+
+int cxd2880_stopwatch_elapsed(struct cxd2880_stopwatch *stopwatch,
+			      unsigned int *elapsed);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
new file mode 100644
index 000000000000..38dd8b04a514
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
@@ -0,0 +1,68 @@
+/*
+ * cxd2880_io.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface functions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "cxd2880_io.h"
+
+int cxd2880_io_common_write_one_reg(struct cxd2880_io *io,
+				    enum cxd2880_io_tgt tgt,
+				    u8 sub_address, u8 data)
+{
+	int ret = 0;
+
+	if (!io)
+		return -EINVAL;
+
+	ret = io->write_regs(io, tgt, sub_address, &data, 1);
+
+	return ret;
+}
+
+int cxd2880_io_set_reg_bits(struct cxd2880_io *io,
+			    enum cxd2880_io_tgt tgt,
+			    u8 sub_address, u8 data, u8 mask)
+{
+	int ret = 0;
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
+	ret = io->write_reg(io, tgt, sub_address, data);
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
new file mode 100644
index 000000000000..11a045720110
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
@@ -0,0 +1,62 @@
+/*
+ * cxd2880_io.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface definitions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
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
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
new file mode 100644
index 000000000000..a4a1e29de653
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
@@ -0,0 +1,60 @@
+/*
+ * cxd2880_stopwatch_port.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * time measurement functions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/jiffies.h>
+
+#include "cxd2880_common.h"
+
+int cxd2880_stopwatch_start(struct cxd2880_stopwatch *stopwatch)
+{
+	if (!stopwatch)
+		return -EINVAL;
+
+	stopwatch->start_time = jiffies;
+
+	return 0;
+}
+
+int cxd2880_stopwatch_sleep(struct cxd2880_stopwatch *stopwatch,
+			    u32 ms)
+{
+	if (!stopwatch)
+		return -EINVAL;
+	CXD2880_ARG_UNUSED(*stopwatch);
+	usleep_range(ms * 10000, ms * 10000 + 1000);
+
+	return 0;
+}
+
+int cxd2880_stopwatch_elapsed(struct cxd2880_stopwatch *stopwatch,
+			      unsigned int *elapsed)
+{
+	if (!stopwatch || !elapsed)
+		return -EINVAL;
+	*elapsed = jiffies_to_msecs(jiffies - stopwatch->start_time);
+
+	return 0;
+}
-- 
2.13.0
