Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0103.outbound.protection.outlook.com ([104.47.40.103]:62053
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751438AbdDNCO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:14:29 -0400
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
Subject: [PATCH v2 03/15] [media] cxd2880: Add common files for the driver
Date: Fri, 14 Apr 2017 11:17:01 +0900
Message-ID: <20170414021701.17133-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
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
 drivers/media/dvb-frontends/cxd2880/cxd2880.h      | 46 ++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.c   | 84 +++++++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_common.h   | 86 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c   | 68 +++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h   | 62 ++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_stdlib.h   | 35 +++++++++
 .../dvb-frontends/cxd2880/cxd2880_stopwatch_port.c | 71 ++++++++++++++++++
 7 files changed, 452 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
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
index 000000000000..850f3a76b2c7
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
@@ -0,0 +1,84 @@
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
+#define MASKUPPER(n) (((n) == 0) ? 0 : (0xFFFFFFFFU << (32 - (n))))
+#define MASKLOWER(n) (((n) == 0) ? 0 : (0xFFFFFFFFU >> (32 - (n))))
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen)
+{
+	if ((bitlen == 0) || (bitlen >= 32))
+		return (int)value;
+
+	if (value & (u32)(1 << (bitlen - 1)))
+		return (int)(MASKUPPER(32 - bitlen) | value);
+	else
+		return (int)(MASKLOWER(bitlen) & value);
+}
+
+u32 cxd2880_bit_split_from_byte_array(u8 *array, u32 start_bit, u32 bit_num)
+{
+	u32 value = 0;
+	u8 *array_read;
+	u8 bit_read;
+	u32 len_remain;
+
+	if (!array)
+		return 0;
+	if ((bit_num == 0) || (bit_num > 32))
+		return 0;
+
+	array_read = array + (start_bit / 8);
+	bit_read = (u8)(start_bit % 8);
+	len_remain = bit_num;
+
+	if (bit_read != 0) {
+		if (((int)len_remain) <= 8 - bit_read) {
+			value = (*array_read) >> ((8 - bit_read) - len_remain);
+			len_remain = 0;
+		} else {
+			value = *array_read++;
+			len_remain -= 8 - bit_read;
+		}
+	}
+
+	while (len_remain > 0) {
+		if (len_remain < 8) {
+			value <<= len_remain;
+			value |= (*array_read++ >> (8 - len_remain));
+			len_remain = 0;
+		} else {
+			value <<= 8;
+			value |= (u32)(*array_read++);
+			len_remain -= 8;
+		}
+	}
+
+	value &= MASKLOWER(bit_num);
+
+	return value;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
new file mode 100644
index 000000000000..b1ecb44bca10
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -0,0 +1,86 @@
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
+
+#ifndef NULL
+#ifdef __cplusplus
+#define NULL 0
+#else
+#define NULL ((void *)0)
+#endif
+#endif
+
+#include <linux/delay.h>
+#define CXD2880_SLEEP(n) msleep(n)
+#ifndef CXD2880_SLEEP_IN_MON
+#define CXD2880_SLEEP_IN_MON(n, obj) CXD2880_SLEEP(n)
+#endif
+
+#define CXD2880_ARG_UNUSED(arg) ((void)(arg))
+
+enum cxd2880_ret {
+	CXD2880_RESULT_OK,
+	CXD2880_RESULT_ERROR_ARG,
+	CXD2880_RESULT_ERROR_IO,
+	CXD2880_RESULT_ERROR_SW_STATE,
+	CXD2880_RESULT_ERROR_HW_STATE,
+	CXD2880_RESULT_ERROR_TIMEOUT,
+	CXD2880_RESULT_ERROR_UNLOCK,
+	CXD2880_RESULT_ERROR_RANGE,
+	CXD2880_RESULT_ERROR_NOSUPPORT,
+	CXD2880_RESULT_ERROR_CANCEL,
+	CXD2880_RESULT_ERROR_OTHER,
+	CXD2880_RESULT_ERROR_OVERFLOW,
+	CXD2880_RESULT_OK_CONFIRM
+};
+
+int cxd2880_convert2s_complement(u32 value, u32 bitlen);
+
+u32 cxd2880_bit_split_from_byte_array(u8 *array, u32 start_bit, u32 bit_num);
+
+struct cxd2880_atomic {
+	int counter;
+};
+
+#define cxd2880_atomic_set(a, i) ((a)->counter = i)
+#define cxd2880_atomic_read(a) ((a)->counter)
+
+struct cxd2880_stopwatch {
+	u32 start_time;
+};
+
+enum cxd2880_ret cxd2880_stopwatch_start(struct cxd2880_stopwatch *stopwatch);
+
+enum cxd2880_ret cxd2880_stopwatch_sleep(struct cxd2880_stopwatch *stopwatch,
+					 u32 ms);
+
+enum cxd2880_ret cxd2880_stopwatch_elapsed(struct cxd2880_stopwatch *stopwatch,
+					   u32 *elapsed);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
new file mode 100644
index 000000000000..f0f82055a953
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
+enum cxd2880_ret cxd2880_io_common_write_one_reg(struct cxd2880_io *io,
+						 enum cxd2880_io_tgt tgt,
+						 u8 sub_address, u8 data)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!io)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = io->write_regs(io, tgt, sub_address, &data, 1);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_io_set_reg_bits(struct cxd2880_io *io,
+					 enum cxd2880_io_tgt tgt,
+					 u8 sub_address, u8 data, u8 mask)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!io)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (mask == 0x00)
+		return CXD2880_RESULT_OK;
+
+	if (mask != 0xFF) {
+		u8 rdata = 0x00;
+
+		ret = io->read_regs(io, tgt, sub_address, &rdata, 1);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		data = (u8)((data & mask) | (rdata & (mask ^ 0xFF)));
+	}
+
+	ret = io->write_reg(io, tgt, sub_address, data);
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
new file mode 100644
index 000000000000..4d6db13cf910
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
+	enum cxd2880_ret (*read_regs)(struct cxd2880_io *io,
+				       enum cxd2880_io_tgt tgt, u8 sub_address,
+				       u8 *data, u32 size);
+	enum cxd2880_ret (*write_regs)(struct cxd2880_io *io,
+					enum cxd2880_io_tgt tgt, u8 sub_address,
+					const u8 *data, u32 size);
+	enum cxd2880_ret (*write_reg)(struct cxd2880_io *io,
+				       enum cxd2880_io_tgt tgt, u8 sub_address,
+				       u8 data);
+	void *if_object;
+	u8 i2c_address_sys;
+	u8 i2c_address_demod;
+	u8 slave_select;
+	void *user;
+};
+
+enum cxd2880_ret cxd2880_io_common_write_one_reg(struct cxd2880_io *io,
+						 enum cxd2880_io_tgt tgt,
+						 u8 sub_address, u8 data);
+
+enum cxd2880_ret cxd2880_io_set_reg_bits(struct cxd2880_io *io,
+					 enum cxd2880_io_tgt tgt,
+					 u8 sub_address, u8 data, u8 mask);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
new file mode 100644
index 000000000000..b9ca1b9df110
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
@@ -0,0 +1,35 @@
+/*
+ * cxd2880_stdlib.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * standard lib function aliases
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
+#ifndef CXD2880_STDLIB_H
+#define CXD2880_STDLIB_H
+
+#include <linux/string.h>
+
+#define cxd2880_memcpy  memcpy
+#define cxd2880_memset  memset
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
new file mode 100644
index 000000000000..14ad6aa6c4c0
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
@@ -0,0 +1,71 @@
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
+#include "cxd2880_common.h"
+
+#include <linux/ktime.h>
+#include <linux/time.h>
+#include <linux/timekeeping.h>
+
+static u32 get_time_count(void)
+{
+	struct timespec tp;
+
+	getnstimeofday(&tp);
+
+	return (u32)((tp.tv_sec * 1000) + (tp.tv_nsec / 1000000));
+}
+
+enum cxd2880_ret cxd2880_stopwatch_start(struct cxd2880_stopwatch *stopwatch)
+{
+	if (!stopwatch)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	stopwatch->start_time = get_time_count();
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_stopwatch_sleep(struct cxd2880_stopwatch *stopwatch,
+					 u32 ms)
+{
+	if (!stopwatch)
+		return CXD2880_RESULT_ERROR_ARG;
+	CXD2880_ARG_UNUSED(*stopwatch);
+	CXD2880_SLEEP(ms);
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_stopwatch_elapsed(struct cxd2880_stopwatch *stopwatch,
+					   u32 *elapsed)
+{
+	if (!stopwatch || !elapsed)
+		return CXD2880_RESULT_ERROR_ARG;
+	*elapsed = get_time_count() - stopwatch->start_time;
+
+	return CXD2880_RESULT_OK;
+}
-- 
2.11.0
