Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0103.outbound.protection.outlook.com ([104.47.34.103]:12288
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753777AbdCGAtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 19:49:23 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [RFC PATCH 3/5] media: Add suppurt for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Tue, 7 Mar 2017 09:32:31 +0900
Message-ID: <1488846751-8278-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the driver for Sony CXD2880 DVB-T2/T tuner + demodulator.

Regarding this third Beta Release, the status is:
- Tested on Raspberry Pi 3.
- The DVB-API operates under dvbv5 tools.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 drivers/media/dvb-frontends/Kconfig                |    2 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/cxd2880/Kconfig        |    6 +
 drivers/media/dvb-frontends/cxd2880/Makefile       |   22 +
 drivers/media/dvb-frontends/cxd2880/cxd2880.h      |   37 +
 .../media/dvb-frontends/cxd2880/cxd2880_common.c   |   84 +
 .../media/dvb-frontends/cxd2880/cxd2880_common.h   |   85 +
 .../dvb-frontends/cxd2880/cxd2880_devio_spi.c      |  145 +
 .../dvb-frontends/cxd2880/cxd2880_devio_spi.h      |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h  |   50 +
 .../media/dvb-frontends/cxd2880/cxd2880_integ.c    |  101 +
 .../media/dvb-frontends/cxd2880/cxd2880_integ.h    |   44 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c   |   68 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h   |   62 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c |   89 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h  |   51 +
 .../dvb-frontends/cxd2880/cxd2880_spi_device.c     |  130 +
 .../dvb-frontends/cxd2880/cxd2880_spi_device.h     |   45 +
 .../media/dvb-frontends/cxd2880/cxd2880_stdlib.h   |   35 +
 .../dvb-frontends/cxd2880/cxd2880_stopwatch_port.c |   73 +
 .../media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c   | 3936 ++++++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h   |  395 ++
 .../cxd2880/cxd2880_tnrdmd_driver_version.h        |   29 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c     |  207 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h     |   52 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c  | 1558 ++++++++
 27 files changed, 7387 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index e8c6554..3a3a712 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -518,6 +518,8 @@ config DVB_GP8PSK_FE
 	depends on DVB_CORE
 	default DVB_USB_GP8PSK
 
+source "drivers/media/dvb-frontends/cxd2880/Kconfig"
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 3fccaf3..d298c79 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -126,3 +126,4 @@ obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
 obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
 obj-$(CONFIG_DVB_HELENE) += helene.o
 obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
+obj-$(CONFIG_DVB_CXD2880) += cxd2880/
diff --git a/drivers/media/dvb-frontends/cxd2880/Kconfig b/drivers/media/dvb-frontends/cxd2880/Kconfig
new file mode 100644
index 0000000..36b8b6f
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Kconfig
@@ -0,0 +1,6 @@
+config DVB_CXD2880
+	tristate "Sony CXD2880 DVB-T2/T tuner + demodulator"
+	depends on DVB_CORE && SPI
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
\ No newline at end of file
diff --git a/drivers/media/dvb-frontends/cxd2880/Makefile b/drivers/media/dvb-frontends/cxd2880/Makefile
new file mode 100644
index 0000000..551f20c
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Makefile
@@ -0,0 +1,22 @@
+cxd2880-objs := cxd2880_common.o \
+		cxd2880_devio_spi.o \
+		cxd2880_integ.o \
+		cxd2880_integ_dvbt2.o \
+		cxd2880_integ_dvbt.o \
+		cxd2880_io.o \
+		cxd2880_spi_device.o \
+		cxd2880_stopwatch_port.o \
+		cxd2880_tnrdmd.o \
+		cxd2880_tnrdmd_dvbt2.o \
+		cxd2880_tnrdmd_dvbt2_mon.o \
+		cxd2880_tnrdmd_dvbt.o \
+		cxd2880_tnrdmd_dvbt_mon.o\
+		cxd2880_tnrdmd_mon.o\
+		cxd2880_math.o \
+		cxd2880_top.o
+
+obj-$(CONFIG_DVB_CXD2880) += cxd2880.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
+
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880.h b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
new file mode 100644
index 0000000..c0c1ba4
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880.h
@@ -0,0 +1,37 @@
+/*
+ * cxd2880.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver public definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+	struct mutex *spi_mutex;
+};
+
+extern struct dvb_frontend *cxd2880_attach(struct dvb_frontend *fe,
+					struct cxd2880_config *cfg);
+
+#endif /* CXD2880_H */
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
new file mode 100644
index 0000000..6f88ec8
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
@@ -0,0 +1,84 @@
+/*
+ * cxd2880_common.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+	if (value & (u32) (1 << (bitlen - 1)))
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
+	bit_read = (u8) (start_bit % 8);
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
+			value |= (u32) (*array_read++);
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
index 0000000..bf58a35
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -0,0 +1,85 @@
+/*
+ * cxd2880_common.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver common definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
new file mode 100644
index 0000000..96c34b0
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
@@ -0,0 +1,145 @@
+/*
+ * cxd2880_devio_spi.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * I/O interface via SPI
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_devio_spi.h"
+#include "cxd2880_stdlib.h"
+
+#define BURST_WRITE_MAX 128
+
+static enum cxd2880_ret cxd2880_io_spi_read_reg(struct cxd2880_io *io,
+						enum cxd2880_io_tgt tgt,
+						u8 sub_address, u8 *data,
+						u32 size)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_spi *spi = NULL;
+	u8 send_data[6];
+	u8 *read_data_top = data;
+
+	if ((!io) || (!io->if_object) || (!data))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (sub_address + size > 0x100)
+		return CXD2880_RESULT_ERROR_RANGE;
+
+	spi = (struct cxd2880_spi *)(io->if_object);
+
+	if (tgt == CXD2880_IO_TGT_SYS)
+		send_data[0] = 0x0B;
+	else
+		send_data[0] = 0x0A;
+
+	send_data[3] = send_data[4] = send_data[5] = 0;
+
+	while (size > 0) {
+		send_data[1] = sub_address;
+		if (size > 255)
+			send_data[2] = 255;
+		else
+			send_data[2] = (u8)size;
+
+		ret =
+		    spi->write_read(spi, send_data, sizeof(send_data),
+				    read_data_top, send_data[2]);
+		if (ret != CXD2880_RESULT_OK)
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
+static enum cxd2880_ret cxd2880_io_spi_write_reg(struct cxd2880_io *io,
+						 enum cxd2880_io_tgt tgt,
+						 u8 sub_address,
+						 const u8 *data, u32 size)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_spi *spi = NULL;
+	u8 send_data[BURST_WRITE_MAX + 4];
+	const u8 *write_data_top = data;
+
+	if ((!io) || (!io->if_object) || (!data))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (size > BURST_WRITE_MAX)
+		return CXD2880_RESULT_ERROR_OVERFLOW;
+
+	if (sub_address + size > 0x100)
+		return CXD2880_RESULT_ERROR_RANGE;
+
+	spi = (struct cxd2880_spi *)(io->if_object);
+
+	if (tgt == CXD2880_IO_TGT_SYS)
+		send_data[0] = 0x0F;
+	else
+		send_data[0] = 0x0E;
+
+	while (size > 0) {
+		send_data[1] = sub_address;
+		if (size > 255)
+			send_data[2] = 255;
+		else
+			send_data[2] = (u8)size;
+
+		cxd2880_memcpy(&send_data[3], write_data_top, send_data[2]);
+
+		if (tgt == CXD2880_IO_TGT_SYS) {
+			send_data[3 + send_data[2]] = 0x00;
+			ret = spi->write(spi, send_data, send_data[2] + 4);
+		} else {
+			ret = spi->write(spi, send_data, send_data[2] + 3);
+		}
+		if (ret != CXD2880_RESULT_OK)
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
+enum cxd2880_ret cxd2880_io_spi_create(struct cxd2880_io *io,
+				       struct cxd2880_spi *spi, u8 slave_select)
+{
+	if ((!io) || (!spi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	io->read_regs = cxd2880_io_spi_read_reg;
+	io->write_regs = cxd2880_io_spi_write_reg;
+	io->write_reg = cxd2880_io_common_write_one_reg;
+	io->if_object = spi;
+	io->i2c_address_sys = 0;
+	io->i2c_address_demod = 0;
+	io->slave_select = slave_select;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
new file mode 100644
index 0000000..710526a
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
@@ -0,0 +1,40 @@
+/*
+ * cxd2880_devio_spi.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * I/O interface via SPI
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_DEVIO_SPI_H
+#define CXD2880_DEVIO_SPI_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_io.h"
+#include "cxd2880_spi.h"
+
+#include "cxd2880_tnrdmd.h"
+
+enum cxd2880_ret cxd2880_io_spi_create(struct cxd2880_io *io,
+				       struct cxd2880_spi *spi,
+				       u8 slave_select);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
new file mode 100644
index 0000000..79cfc21
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
@@ -0,0 +1,50 @@
+/*
+ * cxd2880_dtv.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DTV related definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_DTV_H
+#define CXD2880_DTV_H
+
+enum cxd2880_dtv_sys {
+	CXD2880_DTV_SYS_UNKNOWN,
+	CXD2880_DTV_SYS_DVBT,
+	CXD2880_DTV_SYS_DVBT2,
+	CXD2880_DTV_SYS_ISDBT,
+	CXD2880_DTV_SYS_ISDBTSB,
+	CXD2880_DTV_SYS_ISDBTMM_A,
+	CXD2880_DTV_SYS_ISDBTMM_B,
+	CXD2880_DTV_SYS_ANY
+};
+
+enum cxd2880_dtv_bandwidth {
+	CXD2880_DTV_BW_UNKNOWN = 0,
+	CXD2880_DTV_BW_1_7_MHZ = 1,
+	CXD2880_DTV_BW_5_MHZ = 5,
+	CXD2880_DTV_BW_6_MHZ = 6,
+	CXD2880_DTV_BW_7_MHZ = 7,
+	CXD2880_DTV_BW_8_MHZ = 8
+};
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
new file mode 100644
index 0000000..8133d57
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
@@ -0,0 +1,101 @@
+/*
+ * cxd2880_integ.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_integ.h"
+
+enum cxd2880_ret cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_stopwatch timer;
+	u32 elapsed_time = 0;
+	u8 cpu_task_completed = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_init1(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	while (1) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed_time);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret =
+		    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
+						     &cpu_task_completed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (cpu_task_completed)
+			break;
+
+		if (elapsed_time > CXD2880_TNRDMD_WAIT_INIT_TIMEOUT)
+			return CXD2880_RESULT_ERROR_TIMEOUT;
+		ret =
+		    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_TNRDMD_WAIT_INIT_INTVL);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = cxd2880_tnrdmd_init2(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	cxd2880_atomic_set(&(tnr_dmd->cancel), 1);
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
+						  *tnr_dmd)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (cxd2880_atomic_read(&(tnr_dmd->cancel)) != 0)
+		return CXD2880_RESULT_ERROR_CANCEL;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
new file mode 100644
index 0000000..d54061b
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
@@ -0,0 +1,44 @@
+/*
+ * cxd2880_integ.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_INTEG_H
+#define CXD2880_INTEG_H
+
+#include "cxd2880_tnrdmd.h"
+
+#define CXD2880_TNRDMD_WAIT_INIT_TIMEOUT	500
+#define CXD2880_TNRDMD_WAIT_INIT_INTVL	10
+
+#define CXD2880_TNRDMD_WAIT_AGC_STABLE		100
+
+enum cxd2880_ret cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
+						  *tnr_dmd);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
new file mode 100644
index 0000000..83e0194
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
@@ -0,0 +1,68 @@
+/*
+ * cxd2880_io.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+		data = (u8) ((data & mask) | (rdata & (mask ^ 0xFF)));
+	}
+
+	ret = io->write_reg(io, tgt, sub_address, data);
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
new file mode 100644
index 0000000..f73ca59
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
@@ -0,0 +1,62 @@
+/*
+ * cxd2880_io.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * register I/O interface definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
new file mode 100644
index 0000000..117bcd7
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
@@ -0,0 +1,89 @@
+/*
+ * cxd2880_math.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * mathmatics functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_math.h"
+
+#define MAX_BIT_PRECISION	  5
+#define FRAC_BITMASK	    0x1F
+#define LOG2_10_100X	     332
+#define LOG2_E_100X	      144
+
+static const u8 log2_look_up[] = {
+	0, 4,
+	9, 13,
+	17, 21,
+	25, 29,
+	32, 36,
+	39, 43,
+	46, 49,
+	52, 55,
+	58, 61,
+	64, 67,
+	70, 73,
+	75, 78,
+	81, 83,
+	86, 88,
+	91, 93,
+	95, 98
+};
+
+u32 cxd2880_math_log2(u32 x)
+{
+	u8 count = 0;
+	u8 index = 0;
+	u32 xval = x;
+
+	for (x >>= 1; x > 0; x >>= 1)
+		count++;
+
+	x = count * 100;
+
+	if (count > 0) {
+		if (count <= MAX_BIT_PRECISION) {
+			index =
+			    (u8) (xval << (MAX_BIT_PRECISION - count)) &
+			    FRAC_BITMASK;
+			x += log2_look_up[index];
+		} else {
+			index =
+			    (u8) (xval >> (count - MAX_BIT_PRECISION)) &
+			    FRAC_BITMASK;
+			x += log2_look_up[index];
+		}
+	}
+
+	return x;
+}
+
+u32 cxd2880_math_log10(u32 x)
+{
+	return ((100 * cxd2880_math_log2(x) + LOG2_10_100X / 2) / LOG2_10_100X);
+}
+
+u32 cxd2880_math_log(u32 x)
+{
+	return ((100 * cxd2880_math_log2(x) + LOG2_E_100X / 2) / LOG2_E_100X);
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
new file mode 100644
index 0000000..4e56a7d
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
@@ -0,0 +1,40 @@
+/*
+ * cxd2880_math.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * mathmatics definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_MATH_H_
+#define CXD2880_MATH_H_
+
+#include "cxd2880_common.h"
+
+u32 cxd2880_math_log2(u32 x);
+u32 cxd2880_math_log10(u32 x);
+u32 cxd2880_math_log(u32 x);
+
+#ifndef min
+#define min(a, b)	    (((a) < (b)) ? (a) : (b))
+#endif
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
new file mode 100644
index 0000000..cfa9a80
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
@@ -0,0 +1,51 @@
+/*
+ * cxd2880_spi.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+	enum cxd2880_ret (*read)(struct cxd2880_spi *spi, u8 *data,
+				  u32 size);
+	enum cxd2880_ret (*write)(struct cxd2880_spi *spi, const u8 *data,
+				   u32 size);
+	enum cxd2880_ret (*write_read)(struct cxd2880_spi *spi,
+					const u8 *tx_data, u32 tx_size,
+					u8 *rx_data, u32 rx_size);
+	u32 flags;
+	void *user;
+};
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
new file mode 100644
index 0000000..e9ee2a1
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
@@ -0,0 +1,130 @@
+/*
+ * cxd2880_spi_device.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include <linux/spi/spi.h>
+
+#include "cxd2880_spi_device.h"
+
+static enum cxd2880_ret cxd2880_spi_device_write(struct cxd2880_spi *spi,
+						const u8 *data, u32 size)
+{
+	struct cxd2880_spi_device *spi_device = NULL;
+	struct spi_message msg;
+	struct spi_transfer tx;
+	int result = 0;
+
+	if ((!spi) || (!spi->user) || (!data) || (size == 0))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	spi_device = (struct cxd2880_spi_device *)(spi->user);
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
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_spi_device_write_read(struct cxd2880_spi *spi,
+							const u8 *tx_data,
+							u32 tx_size,
+							u8 *rx_data,
+							u32 rx_size)
+{
+	struct cxd2880_spi_device *spi_device = NULL;
+	int result = 0;
+
+	if ((!spi) || (!spi->user) || (!tx_data) ||
+		 (tx_size == 0) || (!rx_data) || (rx_size == 0))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	spi_device = (struct cxd2880_spi_device *)(spi->user);
+
+	result = spi_write_then_read(spi_device->spi, tx_data,
+					tx_size, rx_data, rx_size);
+	if (result < 0)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret
+cxd2880_spi_device_initialize(struct cxd2880_spi_device *spi_device,
+				enum cxd2880_spi_mode mode,
+				u32 speed_hz)
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
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+
+	spi->max_speed_hz = speed_hz;
+	spi->bits_per_word = 8;
+	result = spi_setup(spi);
+	if (result != 0) {
+		pr_err("spi_setup failed %d\n", result);
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_spi_device_create_spi(struct cxd2880_spi *spi,
+					struct cxd2880_spi_device *spi_device)
+{
+	if ((!spi) || (!spi_device))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	spi->read = NULL;
+	spi->write = cxd2880_spi_device_write;
+	spi->write_read = cxd2880_spi_device_write_read;
+	spi->flags = 0;
+	spi->user = spi_device;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
new file mode 100644
index 0000000..1eefa14
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
@@ -0,0 +1,45 @@
+/*
+ * cxd2880_spi_device.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * SPI access interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_SPI_DEVICE_H
+#define CXD2880_SPI_DEVICE_H
+
+#include "cxd2880_spi.h"
+
+struct cxd2880_spi_device {
+	struct spi_device *spi;
+};
+
+enum cxd2880_ret
+cxd2880_spi_device_initialize(struct cxd2880_spi_device *spi_device,
+				enum cxd2880_spi_mode mode,
+				u32 speedHz);
+
+enum cxd2880_ret
+cxd2880_spi_device_create_spi(struct cxd2880_spi *spi,
+				struct cxd2880_spi_device *spi_device);
+
+#endif /* CXD2880_SPI_DEVICE_H */
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
new file mode 100644
index 0000000..6e3b2fd
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
@@ -0,0 +1,35 @@
+/*
+ * cxd2880_stdlib.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * standard lib function aliases
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
index 0000000..8ce4317
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
@@ -0,0 +1,73 @@
+/*
+ * cxd2880_stopwatch_port.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * time measurement functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+	return (u32) ((tp.tv_sec * 1000) + (tp.tv_nsec / 1000000));
+}
+
+enum cxd2880_ret cxd2880_stopwatch_start(struct cxd2880_stopwatch *stopwatch)
+{
+
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
+
+	if (!stopwatch || !elapsed)
+		return CXD2880_RESULT_ERROR_ARG;
+	*elapsed = get_time_count() - stopwatch->start_time;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
new file mode 100644
index 0000000..aaeed99
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
@@ -0,0 +1,3936 @@
+/*
+ * cxd2880_tnrdmd.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common control functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_stdlib.h"
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_tnrdmd_dvbt2.h"
+
+static enum cxd2880_ret p_init1(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if ((tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE)
+	    || (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)) {
+		switch (tnr_dmd->create_param.ts_output_if) {
+		case CXD2880_TNRDMD_TSOUT_IF_TS:
+			data = 0x00;
+			break;
+		case CXD2880_TNRDMD_TSOUT_IF_SPI:
+			data = 0x01;
+			break;
+		case CXD2880_TNRDMD_TSOUT_IF_SDIO:
+			data = 0x02;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_ARG;
+		}
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x10,
+					   data) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x11,
+				   0x16) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	switch (tnr_dmd->chip_id) {
+	case CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X:
+		data = 0x1A;
+		break;
+	case CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_11:
+		data = 0x16;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x10,
+				   data) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->create_param.en_internal_ldo)
+		data = 0x01;
+	else
+		data = 0x00;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x11,
+				   data) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x13,
+				   data) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x12,
+				   data) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	switch (tnr_dmd->chip_id) {
+	case CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X:
+		data = 0x01;
+		break;
+	case CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_11:
+		data = 0x00;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x69,
+				   data) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret p_init2(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[6] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = tnr_dmd->create_param.xosc_cap;
+	data[1] = tnr_dmd->create_param.xosc_i;
+	switch (tnr_dmd->create_param.xtal_share_type) {
+	case CXD2880_TNRDMD_XTAL_SHARE_NONE:
+		data[2] = 0x01;
+		data[3] = 0x00;
+		break;
+	case CXD2880_TNRDMD_XTAL_SHARE_EXTREF:
+		data[2] = 0x00;
+		data[3] = 0x00;
+		break;
+	case CXD2880_TNRDMD_XTAL_SHARE_MASTER:
+		data[2] = 0x01;
+		data[3] = 0x01;
+		break;
+	case CXD2880_TNRDMD_XTAL_SHARE_SLAVE:
+		data[2] = 0x00;
+		data[3] = 0x01;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+	data[4] = 0x06;
+	data[5] = 0x00;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x13, data,
+				    6) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret p_init3(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[2] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	switch (tnr_dmd->diver_mode) {
+	case CXD2880_TNRDMD_DIVERMODE_SINGLE:
+		data[0] = 0x00;
+		break;
+	case CXD2880_TNRDMD_DIVERMODE_MAIN:
+		data[0] = 0x03;
+		break;
+	case CXD2880_TNRDMD_DIVERMODE_SUB:
+		data[0] = 0x02;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+
+	data[1] = 0x01;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x1F, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret rf_init1(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[80] = { 0 };
+	u8 addr = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x01;
+	data[1] = 0x00;
+	data[2] = 0x01;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x21, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x01;
+	data[1] = 0x01;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x17, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->create_param.stationary_use) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x1A,
+					   0x06) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x4F,
+				   0x18) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x61,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x71,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x9D,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x7D,
+				   0x02) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x8F,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x8B,
+				   0xC6) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x9A,
+				   0x03) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x1C,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	if ((tnr_dmd->create_param.is_cxd2881gg)
+	    && (tnr_dmd->create_param.xtal_share_type ==
+		CXD2880_TNRDMD_XTAL_SHARE_SLAVE))
+		data[1] = 0x00;
+	else
+		data[1] = 0x1F;
+	data[2] = 0x0A;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xB5, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xB9,
+				   0x07) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x33,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xC1,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xC4,
+				   0x1E) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->chip_id == CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X) {
+		data[0] = 0x34;
+		data[1] = 0x2C;
+	} else {
+		data[0] = 0x2F;
+		data[1] = 0x25;
+	}
+	data[2] = 0x15;
+	data[3] = 0x19;
+	data[4] = 0x1B;
+	data[5] = 0x15;
+	data[6] = 0x19;
+	data[7] = 0x1B;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xD9, data,
+				    8) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x6C;
+	data[1] = 0x10;
+	data[2] = 0xA6;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x44, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x16;
+	data[1] = 0xA8;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x50, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x22;
+	data[2] = 0x00;
+	data[3] = 0x88;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x62, data,
+				    4) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x74,
+				   0x75) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x05;
+	data[1] = 0x05;
+	data[2] = 0x05;
+	data[3] = 0x05;
+	data[4] = 0x05;
+	data[5] = 0x05;
+	data[6] = 0x05;
+	data[7] = 0x05;
+	data[8] = 0x05;
+	data[9] = 0x04;
+	data[10] = 0x04;
+	data[11] = 0x04;
+	data[12] = 0x03;
+	data[13] = 0x03;
+	data[14] = 0x03;
+	data[15] = 0x04;
+	data[16] = 0x04;
+	data[17] = 0x05;
+	data[18] = 0x05;
+	data[19] = 0x05;
+	data[20] = 0x02;
+	data[21] = 0x02;
+	data[22] = 0x02;
+	data[23] = 0x02;
+	data[24] = 0x02;
+	data[25] = 0x02;
+	data[26] = 0x02;
+	data[27] = 0x02;
+	data[28] = 0x02;
+	data[29] = 0x03;
+	data[30] = 0x02;
+	data[31] = 0x01;
+	data[32] = 0x01;
+	data[33] = 0x01;
+	data[34] = 0x02;
+	data[35] = 0x02;
+	data[36] = 0x03;
+	data[37] = 0x04;
+	data[38] = 0x04;
+	data[39] = 0x04;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x7F, data,
+				    40) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x16) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x71;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x10, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x23,
+				   0x89) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0xFF;
+	data[1] = 0x00;
+	data[2] = 0x00;
+	data[3] = 0x00;
+	data[4] = 0x00;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x27, data,
+				    5) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x00;
+	data[2] = 0x00;
+	data[3] = 0x00;
+	data[4] = 0x00;
+	data[5] = 0x01;
+	data[6] = 0x00;
+	data[7] = 0x01;
+	data[8] = 0x00;
+	data[9] = 0x02;
+	data[10] = 0x00;
+	data[11] = 0x63;
+	data[12] = 0x00;
+	data[13] = 0x00;
+	data[14] = 0x00;
+	data[15] = 0x03;
+	data[16] = 0x00;
+	data[17] = 0x04;
+	data[18] = 0x00;
+	data[19] = 0x04;
+	data[20] = 0x00;
+	data[21] = 0x06;
+	data[22] = 0x00;
+	data[23] = 0x06;
+	data[24] = 0x00;
+	data[25] = 0x08;
+	data[26] = 0x00;
+	data[27] = 0x09;
+	data[28] = 0x00;
+	data[29] = 0x0B;
+	data[30] = 0x00;
+	data[31] = 0x0B;
+	data[32] = 0x00;
+	data[33] = 0x0D;
+	data[34] = 0x00;
+	data[35] = 0x0D;
+	data[36] = 0x00;
+	data[37] = 0x0F;
+	data[38] = 0x00;
+	data[39] = 0x0F;
+	data[40] = 0x00;
+	data[41] = 0x0F;
+	data[42] = 0x00;
+	data[43] = 0x10;
+	data[44] = 0x00;
+	data[45] = 0x79;
+	data[46] = 0x00;
+	data[47] = 0x00;
+	data[48] = 0x00;
+	data[49] = 0x02;
+	data[50] = 0x00;
+	data[51] = 0x00;
+	data[52] = 0x00;
+	data[53] = 0x03;
+	data[54] = 0x00;
+	data[55] = 0x01;
+	data[56] = 0x00;
+	data[57] = 0x03;
+	data[58] = 0x00;
+	data[59] = 0x03;
+	data[60] = 0x00;
+	data[61] = 0x03;
+	data[62] = 0x00;
+	data[63] = 0x04;
+	data[64] = 0x00;
+	data[65] = 0x04;
+	data[66] = 0x00;
+	data[67] = 0x06;
+	data[68] = 0x00;
+	data[69] = 0x05;
+	data[70] = 0x00;
+	data[71] = 0x07;
+	data[72] = 0x00;
+	data[73] = 0x07;
+	data[74] = 0x00;
+	data[75] = 0x08;
+	data[76] = 0x00;
+	data[77] = 0x0A;
+	data[78] = 0x03;
+	data[79] = 0xE0;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x3A, data,
+				    80) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = 0x03;
+	data[1] = 0xE0;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xBC, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x51,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xC5,
+				   0x07) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x70,
+				   0xE9) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x76,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x78,
+				   0x32) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x7A,
+				   0x46) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x7C,
+				   0x86) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x7E,
+				   0xA4) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xE1,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->create_param.stationary_use) {
+		data[0] = 0x06;
+		data[1] = 0x07;
+		data[2] = 0x1A;
+	} else {
+		data[0] = 0x00;
+		data[1] = 0x08;
+		data[2] = 0x19;
+	}
+	data[3] = 0x0E;
+	data[4] = 0x09;
+	data[5] = 0x0E;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x12) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	for (addr = 0x10; addr < 0x9F; addr += 6) {
+		if (tnr_dmd->lna_thrs_tbl_air) {
+			u8 idx = 0;
+
+			idx = (addr - 0x10) / 6;
+			data[0] =
+			    tnr_dmd->lna_thrs_tbl_air->thrs[idx].off_on;
+			data[1] =
+			    tnr_dmd->lna_thrs_tbl_air->thrs[idx].on_off;
+		}
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, addr,
+					    data,
+					    6) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	data[0] = 0x00;
+	data[1] = 0x08;
+	if (tnr_dmd->create_param.stationary_use)
+		data[2] = 0x1A;
+	else
+		data[2] = 0x19;
+	data[3] = 0x0E;
+	data[4] = 0x09;
+	data[5] = 0x0E;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x13) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	for (addr = 0x10; addr < 0xCF; addr += 6) {
+		if (tnr_dmd->lna_thrs_tbl_cable) {
+			u8 idx = 0;
+
+			idx = (addr - 0x10) / 6;
+			data[0] =
+			    tnr_dmd->lna_thrs_tbl_cable->thrs[idx].off_on;
+			data[1] =
+			    tnr_dmd->lna_thrs_tbl_cable->thrs[idx].on_off;
+		}
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, addr,
+					    data,
+					    6) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x08;
+	data[1] = 0x09;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xBD, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x08;
+	data[1] = 0x09;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xC4, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x20;
+	data[1] = 0x20;
+	data[2] = 0x30;
+	data[3] = 0x41;
+	data[4] = 0x50;
+	data[5] = 0x5F;
+	data[6] = 0x6F;
+	data[7] = 0x80;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xC9, data,
+				    8) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x14) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x15;
+	data[1] = 0x18;
+	data[2] = 0x00;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x10, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x15,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x16) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x09;
+	data[2] = 0x00;
+	data[3] = 0x08;
+	data[4] = 0x00;
+	data[5] = 0x07;
+	data[6] = 0x00;
+	data[7] = 0x06;
+	data[8] = 0x00;
+	data[9] = 0x05;
+	data[10] = 0x00;
+	data[11] = 0x03;
+	data[12] = 0x00;
+	data[13] = 0x02;
+	data[14] = 0x00;
+	data[15] = 0x00;
+	data[16] = 0x00;
+	data[17] = 0x78;
+	data[18] = 0x00;
+	data[19] = 0x00;
+	data[20] = 0x00;
+	data[21] = 0x06;
+	data[22] = 0x00;
+	data[23] = 0x08;
+	data[24] = 0x00;
+	data[25] = 0x08;
+	data[26] = 0x00;
+	data[27] = 0x0C;
+	data[28] = 0x00;
+	data[29] = 0x0C;
+	data[30] = 0x00;
+	data[31] = 0x0D;
+	data[32] = 0x00;
+	data[33] = 0x0F;
+	data[34] = 0x00;
+	data[35] = 0x0E;
+	data[36] = 0x00;
+	data[37] = 0x0E;
+	data[38] = 0x00;
+	data[39] = 0x10;
+	data[40] = 0x00;
+	data[41] = 0x0F;
+	data[42] = 0x00;
+	data[43] = 0x0E;
+	data[44] = 0x00;
+	data[45] = 0x10;
+	data[46] = 0x00;
+	data[47] = 0x0F;
+	data[48] = 0x00;
+	data[49] = 0x0E;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x12, data,
+				    50) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x10, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data[0] & 0x01) == 0x00)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x25,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x11, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data[0] & 0x01) == 0x00)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x02,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0xE1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x8F,
+				   0x16) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x67,
+				   0x60) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x6A,
+				   0x0F) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x6C,
+				   0x17) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0xFE;
+	data[2] = 0xEE;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_DMD, 0x6E, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0xA1;
+	data[1] = 0x8B;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_DMD, 0x8D, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x08;
+	data[1] = 0x09;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_DMD, 0x77, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->create_param.stationary_use) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x80,
+					   0xAA) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0xE2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x41,
+				   0xA0) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x4B,
+				   0x68) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x25,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x1A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x10, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data[0] & 0x01) == 0x00)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x14,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x26,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret rf_init2(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[5] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x40;
+	data[1] = 0x40;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xEA, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	data[0] = 0x00;
+	if (tnr_dmd->chip_id == CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X)
+		data[1] = 0x00;
+	else
+		data[1] = 0x01;
+	data[2] = 0x01;
+	data[3] = 0x03;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x30, data,
+				    4) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x14) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x1B,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0xE1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xD3,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_tune1(struct cxd2880_tnrdmd *tnr_dmd,
+				enum cxd2880_dtv_sys sys, u32 freq_khz,
+				enum cxd2880_dtv_bandwidth bandwidth,
+				u8 is_cable, int shift_frequency_khz)
+{
+	u8 data[11] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = 0x00;
+	data[1] = 0x00;
+	data[2] = 0x0E;
+	data[3] = 0x00;
+	data[4] = 0x03;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xE7, data,
+				    5) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = 0x1F;
+	data[1] = 0x80;
+	data[2] = 0x18;
+	data[3] = 0x00;
+	data[4] = 0x07;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xE7, data,
+				    5) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	data[0] = 0x72;
+	data[1] = 0x81;
+	data[3] = 0x1D;
+	data[4] = 0x6F;
+	data[5] = 0x7E;
+	data[7] = 0x1C;
+	switch (sys) {
+	case CXD2880_DTV_SYS_DVBT:
+	case CXD2880_DTV_SYS_ISDBT:
+	case CXD2880_DTV_SYS_ISDBTSB:
+	case CXD2880_DTV_SYS_ISDBTMM_A:
+	case CXD2880_DTV_SYS_ISDBTMM_B:
+		data[2] = 0x94;
+		data[6] = 0x91;
+		break;
+	case CXD2880_DTV_SYS_DVBT2:
+		data[2] = 0x96;
+		data[6] = 0x93;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x44, data,
+				    8) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x62,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x15) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x03;
+	data[1] = 0xE2;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x1E, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = (u8) (is_cable ? 0x01 : 0x00);
+	data[1] = 0x00;
+	data[2] = 0x6B;
+	data[3] = 0x4D;
+
+	switch (bandwidth) {
+	case CXD2880_DTV_BW_1_7_MHZ:
+		data[4] = 0x03;
+		break;
+	case CXD2880_DTV_BW_5_MHZ:
+	case CXD2880_DTV_BW_6_MHZ:
+		data[4] = 0x00;
+		break;
+	case CXD2880_DTV_BW_7_MHZ:
+		data[4] = 0x01;
+		break;
+	case CXD2880_DTV_BW_8_MHZ:
+		data[4] = 0x02;
+		break;
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+
+	data[5] = 0x00;
+
+	freq_khz += shift_frequency_khz;
+
+	data[6] = (u8) ((freq_khz >> 16) & 0x0F);
+	data[7] = (u8) ((freq_khz >> 8) & 0xFF);
+	data[8] = (u8) (freq_khz & 0xFF);
+	data[9] = 0xFF;
+	data[10] = 0xFE;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x52, data,
+				    11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_tune2(struct cxd2880_tnrdmd *tnr_dmd,
+				enum cxd2880_dtv_bandwidth bandwidth,
+				enum cxd2880_tnrdmd_clockmode clk_mode,
+				int shift_frequency_khz)
+{
+	u8 data[3] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = 0x01;
+	data[1] = 0x0E;
+	data[2] = 0x01;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x2D, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x1A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x29,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x2C, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x60,
+				   data[0]) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x62,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x11) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x2D,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x2F,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (shift_frequency_khz != 0) {
+		int shift_freq = 0;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0xE1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x60, data,
+					   2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		shift_freq = shift_frequency_khz * 1000;
+
+		switch (clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+		default:
+			if (shift_freq >= 0)
+				shift_freq = (shift_freq + 183 / 2) / 183;
+			else
+				shift_freq = (shift_freq - 183 / 2) / 183;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			if (shift_freq >= 0)
+				shift_freq = (shift_freq + 178 / 2) / 178;
+			else
+				shift_freq = (shift_freq - 178 / 2) / 178;
+			break;
+		}
+
+		shift_freq +=
+		    cxd2880_convert2s_complement((data[0] << 8) | data[1], 16);
+
+		if (shift_freq > 32767)
+			shift_freq = 32767;
+		else if (shift_freq < -32768)
+			shift_freq = -32768;
+
+		data[0] = (u8) (((u32) shift_freq >> 8) & 0xFF);
+		data[1] = (u8) ((u32) shift_freq & 0xFF);
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x60, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x69, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		shift_freq = -shift_frequency_khz;
+
+		if (bandwidth == CXD2880_DTV_BW_1_7_MHZ) {
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+			default:
+				if (shift_freq >= 0)
+					shift_freq =
+					    (shift_freq * 1000 +
+					     17578 / 2) / 17578;
+				else
+					shift_freq =
+					    (shift_freq * 1000 -
+					     17578 / 2) / 17578;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				if (shift_freq >= 0)
+					shift_freq =
+					    (shift_freq * 1000 +
+					     17090 / 2) / 17090;
+				else
+					shift_freq =
+					    (shift_freq * 1000 -
+					     17090 / 2) / 17090;
+				break;
+			}
+		} else {
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+			default:
+				if (shift_freq >= 0)
+					shift_freq =
+					    (shift_freq * 1000 +
+					     35156 / 2) / 35156;
+				else
+					shift_freq =
+					    (shift_freq * 1000 -
+					     35156 / 2) / 35156;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				if (shift_freq >= 0)
+					shift_freq =
+					    (shift_freq * 1000 +
+					     34180 / 2) / 34180;
+				else
+					shift_freq =
+					    (shift_freq * 1000 -
+					     34180 / 2) / 34180;
+				break;
+			}
+		}
+
+		shift_freq += cxd2880_convert2s_complement(data[0], 8);
+
+		if (shift_freq > 127)
+			shift_freq = 127;
+		else if (shift_freq < -128)
+			shift_freq = -128;
+
+		data[0] = (u8) ((u32) shift_freq & 0xFF);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x69,
+					   data[0]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->create_param.stationary_use) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0xE1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x8A,
+					   0x87) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_tune3(struct cxd2880_tnrdmd *tnr_dmd,
+				enum cxd2880_dtv_sys sys,
+				u8 en_fef_intmtnt_ctrl)
+{
+	u8 data[6] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0xE2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x41,
+				   0xA0) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xFE,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((sys == CXD2880_DTV_SYS_DVBT2) && en_fef_intmtnt_ctrl) {
+		data[0] = 0x01;
+		data[1] = 0x01;
+		data[2] = 0x01;
+		data[3] = 0x01;
+		data[4] = 0x01;
+		data[5] = 0x01;
+	} else {
+		data[0] = 0x00;
+		data[1] = 0x00;
+		data[2] = 0x00;
+		data[3] = 0x00;
+		data[4] = 0x00;
+		data[5] = 0x00;
+	}
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0xEF, data,
+				    6) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x2D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((sys == CXD2880_DTV_SYS_DVBT2) && en_fef_intmtnt_ctrl)
+		data[0] = 0x00;
+	else
+		data[0] = 0x01;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xB1,
+				   data[0]) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_tune4(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[2] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	{
+		if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+						      CXD2880_IO_TGT_SYS, 0x00,
+						      0x00) !=
+		    CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x14;
+		data[1] = 0x00;
+		if (tnr_dmd->diver_sub->io->write_regs(tnr_dmd->diver_sub->io,
+						       CXD2880_IO_TGT_SYS, 0x55,
+						       data,
+						       2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x0B;
+		data[1] = 0xFF;
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x53, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x57,
+					   0x01) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x0B;
+		data[1] = 0xFF;
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x55, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+						      CXD2880_IO_TGT_SYS, 0x00,
+						      0x00) !=
+		    CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x14;
+		data[1] = 0x00;
+		if (tnr_dmd->diver_sub->io->write_regs(tnr_dmd->diver_sub->io,
+						       CXD2880_IO_TGT_SYS, 0x53,
+						       data,
+						       2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+						      CXD2880_IO_TGT_SYS, 0x57,
+						      0x02) !=
+		    CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xFE,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+					      CXD2880_IO_TGT_DMD, 0x00,
+					      0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+					      CXD2880_IO_TGT_DMD, 0xFE,
+					      0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_sleep1(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data[3] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	{
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x57,
+					   0x03) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x00;
+		data[1] = 0x00;
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x53, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		if (tnr_dmd->diver_sub->io->write_reg(tnr_dmd->diver_sub->io,
+						      CXD2880_IO_TGT_SYS, 0x00,
+						      0x00) !=
+		    CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x1F;
+		data[1] = 0xFF;
+		data[2] = 0x03;
+		if (tnr_dmd->diver_sub->io->write_regs(tnr_dmd->diver_sub->io,
+						       CXD2880_IO_TGT_SYS, 0x55,
+						       data,
+						       3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x00;
+		data[1] = 0x00;
+		if (tnr_dmd->diver_sub->io->write_regs(tnr_dmd->diver_sub->io,
+						       CXD2880_IO_TGT_SYS, 0x53,
+						       data,
+						       2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		data[0] = 0x1F;
+		data[1] = 0xFF;
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x55, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_sleep2(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 data = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x2D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xB1,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xB2, &data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data & 0x01) == 0x00)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xF4,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xF3,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xF2,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xF1,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xF0,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xEF,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_sleep3(struct cxd2880_tnrdmd *tnr_dmd)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xFD,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_sleep4(struct cxd2880_tnrdmd *tnr_dmd)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0xE2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x41,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x21,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret spll_reset(struct cxd2880_tnrdmd *tnr_dmd,
+				   enum cxd2880_tnrdmd_clockmode clockmode)
+{
+	u8 data[4] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x29,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x28,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x26,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x22,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	switch (clockmode) {
+	case CXD2880_TNRDMD_CLOCKMODE_A:
+		data[0] = 0x00;
+		break;
+
+	case CXD2880_TNRDMD_CLOCKMODE_B:
+		data[0] = 0x01;
+		break;
+
+	case CXD2880_TNRDMD_CLOCKMODE_C:
+		data[0] = 0x02;
+		break;
+
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x30,
+				   data[0]) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x22,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(2);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x10, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data[0] & 0x01) == 0x00)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x00;
+	data[2] = 0x00;
+	data[3] = 0x00;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x26, data,
+				    4) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret t_power_x(struct cxd2880_tnrdmd *tnr_dmd, u8 on)
+{
+	u8 data[3] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x29,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x28,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x25,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (on) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x2B,
+					   0x01) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		CXD2880_SLEEP(1);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x0A) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x12, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if ((data[0] & 0x01) == 0)
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x2A,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	} else {
+		data[0] = 0x03;
+		data[1] = 0x00;
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x2A, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		CXD2880_SLEEP(1);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x0A) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x13, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+		if ((data[0] & 0x01) == 0)
+			return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x25,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x11, data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if ((data[0] & 0x01) == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x27,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	data[0] = 0x00;
+	data[1] = 0x00;
+	data[2] = 0x00;
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x27, data,
+				    3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+struct cxd2880_tnrdmd_ts_clk_cfg {
+	u8 srl_clk_mode;
+	u8 srl_duty_mode;
+	u8 ts_clk_period;
+};
+
+static enum cxd2880_ret set_ts_clk_mode_and_freq(struct cxd2880_tnrdmd *tnr_dmd,
+						 enum cxd2880_dtv_sys sys)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 backwards_compatible = 0;
+	struct cxd2880_tnrdmd_ts_clk_cfg ts_clk_cfg;
+
+	const struct cxd2880_tnrdmd_ts_clk_cfg srl_ts_clk_stgs[2][2] = {
+	{
+		{3, 1, 8,},
+		{0, 2, 16,}
+	},
+	{
+		{1, 1, 8,},
+		{2, 2, 16,}
+	}
+	};
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 ts_rate_ctrl_off = 0;
+		u8 ts_in_off = 0;
+		u8 ts_clk_manaul_on = 0;
+
+		if ((sys == CXD2880_DTV_SYS_ISDBT)
+		    || (sys == CXD2880_DTV_SYS_ISDBTSB)
+		    || (sys == CXD2880_DTV_SYS_ISDBTMM_A)
+		    || (sys == CXD2880_DTV_SYS_ISDBTMM_B)) {
+			backwards_compatible = 0;
+			ts_rate_ctrl_off = 1;
+			ts_in_off = 0;
+		} else if (tnr_dmd->is_ts_backwards_compatible_mode) {
+			backwards_compatible = 1;
+			ts_rate_ctrl_off = 1;
+			ts_in_off = 1;
+		} else {
+			backwards_compatible = 0;
+			ts_rate_ctrl_off = 0;
+			ts_in_off = 0;
+		}
+
+		if (tnr_dmd->ts_byte_clk_manual_setting) {
+			ts_clk_manaul_on = 1;
+			ts_rate_ctrl_off = 0;
+		}
+
+		ret =
+		    cxd2880_io_set_reg_bits(tnr_dmd->io, CXD2880_IO_TGT_DMD,
+					    0xD3, ts_rate_ctrl_off, 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret =
+		    cxd2880_io_set_reg_bits(tnr_dmd->io, CXD2880_IO_TGT_DMD,
+					    0xDE, ts_in_off, 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret =
+		    cxd2880_io_set_reg_bits(tnr_dmd->io, CXD2880_IO_TGT_DMD,
+					    0xDA, ts_clk_manaul_on, 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ts_clk_cfg =
+	    srl_ts_clk_stgs[tnr_dmd->srl_ts_clk_mod_cnts]
+			[(u8) tnr_dmd->srl_ts_clk_frq];
+
+	if (tnr_dmd->ts_byte_clk_manual_setting)
+		ts_clk_cfg.ts_clk_period = tnr_dmd->ts_byte_clk_manual_setting;
+
+	ret =
+	    cxd2880_io_set_reg_bits(tnr_dmd->io, CXD2880_IO_TGT_DMD, 0xC4,
+				    ts_clk_cfg.srl_clk_mode, 0x03);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_io_set_reg_bits(tnr_dmd->io, CXD2880_IO_TGT_DMD, 0xD1,
+				    ts_clk_cfg.srl_duty_mode, 0x03);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
+				     CXD2880_IO_TGT_DMD, 0xD9,
+				     ts_clk_cfg.ts_clk_period);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	{
+		u8 data = (u8) (backwards_compatible ? 0x00 : 0x01);
+
+		if (sys == CXD2880_DTV_SYS_DVBT) {
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   0x10) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			ret =
+			    cxd2880_io_set_reg_bits(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x66,
+						    data, 0x01);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret pid_ftr_setting(struct cxd2880_tnrdmd *tnr_dmd,
+					struct cxd2880_tnrdmd_pid_ftr_cfg
+					*pid_ftr_cfg)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (!pid_ftr_cfg) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x50,
+					   0x02) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	} else {
+		u8 data[65];
+
+		data[0] = (u8) (pid_ftr_cfg->is_negative ? 0x01 : 0x00);
+		{
+			int i = 0;
+
+			for (i = 0; i < 32; i++) {
+				if (pid_ftr_cfg->pid_cfg[i].is_en) {
+					data[1 + (i * 2)] =
+					    (u8) ((u8)
+					    (pid_ftr_cfg->pid_cfg[i].pid
+					     >> 8) | 0x20);
+					data[2 + (i * 2)] =
+					    (u8) (pid_ftr_cfg->pid_cfg[i].pid
+					     & 0xFF);
+				} else {
+					data[1 + (i * 2)] = 0x00;
+					data[2 + (i * 2)] = 0x00;
+				}
+			}
+		}
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x50, data,
+					    65) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret load_cfg_mem(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 i;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	for (i = 0; i < tnr_dmd->cfg_mem_last_entry; i++) {
+		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
+					     tnr_dmd->cfg_mem[i].tgt,
+					     0x00, tnr_dmd->cfg_mem[i].bank);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret = cxd2880_io_set_reg_bits(tnr_dmd->io,
+					      tnr_dmd->cfg_mem[i].tgt,
+					      tnr_dmd->cfg_mem[i].address,
+					      tnr_dmd->cfg_mem[i].value,
+					      tnr_dmd->cfg_mem[i].bit_mask);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret set_cfg_mem(struct cxd2880_tnrdmd *tnr_dmd,
+				    enum cxd2880_io_tgt tgt,
+				    u8 bank, u8 address, u8 value, u8 bit_mask)
+{
+	u8 i;
+	u8 value_stored = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	for (i = 0; i < tnr_dmd->cfg_mem_last_entry; i++) {
+		if ((value_stored == 0) &&
+		    (tnr_dmd->cfg_mem[i].tgt == tgt) &&
+		    (tnr_dmd->cfg_mem[i].bank == bank) &&
+		    (tnr_dmd->cfg_mem[i].address == address)) {
+			tnr_dmd->cfg_mem[i].value &= ~bit_mask;
+			tnr_dmd->cfg_mem[i].value |= (value & bit_mask);
+
+			tnr_dmd->cfg_mem[i].bit_mask |= bit_mask;
+
+			value_stored = 1;
+		}
+	}
+
+	if (value_stored == 0) {
+		if (tnr_dmd->cfg_mem_last_entry <
+		    CXD2880_TNRDMD_MAX_CFG_MEM_COUNT) {
+			tnr_dmd->cfg_mem[tnr_dmd->cfg_mem_last_entry].tgt = tgt;
+			tnr_dmd->cfg_mem[tnr_dmd->cfg_mem_last_entry].bank =
+			    bank;
+			tnr_dmd->cfg_mem[tnr_dmd->cfg_mem_last_entry].address =
+			    address;
+			tnr_dmd->cfg_mem[tnr_dmd->cfg_mem_last_entry].value =
+			    (value & bit_mask);
+			tnr_dmd->cfg_mem[tnr_dmd->cfg_mem_last_entry].bit_mask =
+			    bit_mask;
+			tnr_dmd->cfg_mem_last_entry++;
+		} else {
+			return CXD2880_RESULT_ERROR_OVERFLOW;
+		}
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_create(struct cxd2880_tnrdmd *tnr_dmd,
+				       struct cxd2880_io *io,
+				       struct cxd2880_tnrdmd_create_param
+				       *create_param)
+{
+
+	if ((!tnr_dmd) || (!io) || (!create_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	cxd2880_memset(tnr_dmd, 0, sizeof(struct cxd2880_tnrdmd));
+
+	tnr_dmd->io = io;
+	tnr_dmd->create_param = *create_param;
+
+	tnr_dmd->diver_mode = CXD2880_TNRDMD_DIVERMODE_SINGLE;
+	tnr_dmd->diver_sub = NULL;
+
+	tnr_dmd->srl_ts_clk_mod_cnts = 1;
+	tnr_dmd->en_fef_intmtnt_base = 1;
+	tnr_dmd->en_fef_intmtnt_lite = 1;
+	tnr_dmd->rf_lvl_cmpstn = NULL;
+	tnr_dmd->lna_thrs_tbl_air = NULL;
+	tnr_dmd->lna_thrs_tbl_cable = NULL;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_diver_create(struct cxd2880_tnrdmd
+					     *tnr_dmd_main,
+					     struct cxd2880_io *io_main,
+					     struct cxd2880_tnrdmd *tnr_dmd_sub,
+					     struct cxd2880_io *io_sub,
+					     struct
+					     cxd2880_tnrdmd_diver_create_param
+					     *create_param)
+{
+
+	if ((!tnr_dmd_main) || (!io_main) || (!tnr_dmd_sub) || (!io_sub)
+	    || (!create_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	cxd2880_memset(tnr_dmd_main, 0, sizeof(struct cxd2880_tnrdmd));
+	cxd2880_memset(tnr_dmd_sub, 0, sizeof(struct cxd2880_tnrdmd));
+
+	tnr_dmd_main->io = io_main;
+	tnr_dmd_main->diver_mode = CXD2880_TNRDMD_DIVERMODE_MAIN;
+	tnr_dmd_main->diver_sub = tnr_dmd_sub;
+	tnr_dmd_main->create_param.en_internal_ldo =
+	    create_param->en_internal_ldo;
+	tnr_dmd_main->create_param.ts_output_if = create_param->ts_output_if;
+	tnr_dmd_main->create_param.xtal_share_type =
+	    CXD2880_TNRDMD_XTAL_SHARE_MASTER;
+	tnr_dmd_main->create_param.xosc_cap = create_param->xosc_cap_main;
+	tnr_dmd_main->create_param.xosc_i = create_param->xosc_i_main;
+	tnr_dmd_main->create_param.is_cxd2881gg = create_param->is_cxd2881gg;
+	tnr_dmd_main->create_param.stationary_use =
+	    create_param->stationary_use;
+
+	tnr_dmd_sub->io = io_sub;
+	tnr_dmd_sub->diver_mode = CXD2880_TNRDMD_DIVERMODE_SUB;
+	tnr_dmd_sub->diver_sub = NULL;
+	tnr_dmd_sub->create_param.en_internal_ldo =
+	    create_param->en_internal_ldo;
+	tnr_dmd_sub->create_param.ts_output_if = create_param->ts_output_if;
+	tnr_dmd_sub->create_param.xtal_share_type =
+	    CXD2880_TNRDMD_XTAL_SHARE_SLAVE;
+	tnr_dmd_sub->create_param.xosc_cap = 0;
+	tnr_dmd_sub->create_param.xosc_i = create_param->xosc_i_sub;
+	tnr_dmd_sub->create_param.is_cxd2881gg = create_param->is_cxd2881gg;
+	tnr_dmd_sub->create_param.stationary_use = create_param->stationary_use;
+
+	tnr_dmd_main->srl_ts_clk_mod_cnts = 1;
+	tnr_dmd_main->en_fef_intmtnt_base = 1;
+	tnr_dmd_main->en_fef_intmtnt_lite = 1;
+	tnr_dmd_main->rf_lvl_cmpstn = NULL;
+	tnr_dmd_main->lna_thrs_tbl_air = NULL;
+	tnr_dmd_main->lna_thrs_tbl_cable = NULL;
+
+	tnr_dmd_sub->srl_ts_clk_mod_cnts = 1;
+	tnr_dmd_sub->en_fef_intmtnt_base = 1;
+	tnr_dmd_sub->en_fef_intmtnt_lite = 1;
+	tnr_dmd_sub->rf_lvl_cmpstn = NULL;
+	tnr_dmd_sub->lna_thrs_tbl_air = NULL;
+	tnr_dmd_sub->lna_thrs_tbl_cable = NULL;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_init1(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	tnr_dmd->chip_id = CXD2880_TNRDMD_CHIP_ID_UNKNOWN;
+	tnr_dmd->state = CXD2880_TNRDMD_STATE_UNKNOWN;
+	tnr_dmd->clk_mode = CXD2880_TNRDMD_CLOCKMODE_UNKNOWN;
+	tnr_dmd->frequency_khz = 0;
+	tnr_dmd->sys = CXD2880_DTV_SYS_UNKNOWN;
+	tnr_dmd->bandwidth = CXD2880_DTV_BW_UNKNOWN;
+	tnr_dmd->scan_mode = 0;
+	cxd2880_atomic_set(&(tnr_dmd->cancel), 0);
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		tnr_dmd->diver_sub->chip_id = CXD2880_TNRDMD_CHIP_ID_UNKNOWN;
+		tnr_dmd->diver_sub->state = CXD2880_TNRDMD_STATE_UNKNOWN;
+		tnr_dmd->diver_sub->clk_mode = CXD2880_TNRDMD_CLOCKMODE_UNKNOWN;
+		tnr_dmd->diver_sub->frequency_khz = 0;
+		tnr_dmd->diver_sub->sys = CXD2880_DTV_SYS_UNKNOWN;
+		tnr_dmd->diver_sub->bandwidth = CXD2880_DTV_BW_UNKNOWN;
+		tnr_dmd->diver_sub->scan_mode = 0;
+		cxd2880_atomic_set(&(tnr_dmd->diver_sub->cancel), 0);
+	}
+
+	ret = cxd2880_tnrdmd_chip_id(tnr_dmd, &tnr_dmd->chip_id);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (!CXD2880_TNRDMD_CHIP_ID_VALID(tnr_dmd->chip_id))
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret =
+		    cxd2880_tnrdmd_chip_id(tnr_dmd->diver_sub,
+					   &tnr_dmd->diver_sub->chip_id);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (!CXD2880_TNRDMD_CHIP_ID_VALID(tnr_dmd->diver_sub->chip_id))
+			return CXD2880_RESULT_ERROR_NOSUPPORT;
+	}
+
+	ret = p_init1(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = p_init1(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	CXD2880_SLEEP(1);
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = p_init2(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = p_init2(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	CXD2880_SLEEP(5);
+
+	ret = p_init3(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = p_init3(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = rf_init1(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = rf_init1(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_init2(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	{
+		u8 cpu_task_completed = 0;
+
+		ret =
+		    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
+						     &cpu_task_completed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (!cpu_task_completed)
+			return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	ret = rf_init2(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = rf_init2(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = load_cfg_mem(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = load_cfg_mem(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	tnr_dmd->state = CXD2880_TNRDMD_STATE_SLEEP;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+		tnr_dmd->diver_sub->state = CXD2880_TNRDMD_STATE_SLEEP;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_check_internal_cpu_status(struct cxd2880_tnrdmd
+							  *tnr_dmd,
+							  u8 *task_completed)
+{
+	u16 cpu_status = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!task_completed))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_mon_internal_cpu_status(tnr_dmd, &cpu_status);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
+		if (cpu_status == 0)
+			*task_completed = 1;
+		else
+			*task_completed = 0;
+
+		return ret;
+	}
+	if (cpu_status != 0) {
+		*task_completed = 0;
+		return ret;
+	}
+
+	ret = cxd2880_tnrdmd_mon_internal_cpu_status_sub(tnr_dmd, &cpu_status);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (cpu_status == 0)
+		*task_completed = 1;
+	else
+		*task_completed = 0;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_common_tune_setting1(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum cxd2880_dtv_sys sys,
+						     u32 frequency_khz,
+						     enum cxd2880_dtv_bandwidth
+						     bandwidth, u8 one_seg_opt,
+						     u8 one_seg_opt_shft_dir)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (frequency_khz < 4000)
+		return CXD2880_RESULT_ERROR_RANGE;
+
+	ret = cxd2880_tnrdmd_sleep(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	{
+		u8 data = 0;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x2B, &data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		switch (sys) {
+		case CXD2880_DTV_SYS_DVBT:
+		case CXD2880_DTV_SYS_ISDBT:
+		case CXD2880_DTV_SYS_ISDBTSB:
+		case CXD2880_DTV_SYS_ISDBTMM_A:
+		case CXD2880_DTV_SYS_ISDBTMM_B:
+			if (data == 0x00) {
+				ret = t_power_x(tnr_dmd, 1);
+				if (ret != CXD2880_RESULT_OK)
+					return ret;
+
+				if (tnr_dmd->diver_mode ==
+				    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+					ret = t_power_x(tnr_dmd->diver_sub, 1);
+					if (ret != CXD2880_RESULT_OK)
+						return ret;
+				}
+
+			}
+			break;
+
+		case CXD2880_DTV_SYS_DVBT2:
+			if (data == 0x01) {
+				ret = t_power_x(tnr_dmd, 0);
+				if (ret != CXD2880_RESULT_OK)
+					return ret;
+
+				if (tnr_dmd->diver_mode ==
+				    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+					ret = t_power_x(tnr_dmd->diver_sub, 0);
+					if (ret != CXD2880_RESULT_OK)
+						return ret;
+				}
+			}
+			break;
+
+		default:
+			return CXD2880_RESULT_ERROR_ARG;
+		}
+	}
+
+	{
+		enum cxd2880_tnrdmd_clockmode new_clk_mode =
+		    CXD2880_TNRDMD_CLOCKMODE_A;
+
+		ret = spll_reset(tnr_dmd, new_clk_mode);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		tnr_dmd->clk_mode = new_clk_mode;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = spll_reset(tnr_dmd->diver_sub, new_clk_mode);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+
+			tnr_dmd->diver_sub->clk_mode = new_clk_mode;
+		}
+
+		ret = load_cfg_mem(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = load_cfg_mem(tnr_dmd->diver_sub);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+	}
+
+	{
+		int shift_frequency_khz = 0;
+
+		if (one_seg_opt) {
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+				shift_frequency_khz = 350;
+			} else {
+				if (one_seg_opt_shft_dir)
+					shift_frequency_khz = 350;
+				else
+					shift_frequency_khz = -350;
+
+				if (tnr_dmd->create_param.xtal_share_type ==
+				    CXD2880_TNRDMD_XTAL_SHARE_SLAVE)
+					shift_frequency_khz *= -1;
+			}
+		} else {
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+				shift_frequency_khz = 150;
+			} else {
+				switch (tnr_dmd->create_param.xtal_share_type) {
+				case CXD2880_TNRDMD_XTAL_SHARE_NONE:
+				case CXD2880_TNRDMD_XTAL_SHARE_EXTREF:
+				default:
+					shift_frequency_khz = 0;
+					break;
+				case CXD2880_TNRDMD_XTAL_SHARE_MASTER:
+					shift_frequency_khz = 150;
+					break;
+				case CXD2880_TNRDMD_XTAL_SHARE_SLAVE:
+					shift_frequency_khz = -150;
+					break;
+				}
+			}
+		}
+
+		ret =
+		    x_tune1(tnr_dmd, sys, frequency_khz, bandwidth,
+			    tnr_dmd->is_cable_input, shift_frequency_khz);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret =
+			    x_tune1(tnr_dmd->diver_sub, sys, frequency_khz,
+				    bandwidth, tnr_dmd->is_cable_input,
+				    -shift_frequency_khz);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		CXD2880_SLEEP(10);
+
+		{
+			u8 cpu_task_completed = 0;
+
+			ret =
+			    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
+						     &cpu_task_completed);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+
+			if (!cpu_task_completed)
+				return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		ret =
+		    x_tune2(tnr_dmd, bandwidth, tnr_dmd->clk_mode,
+			    shift_frequency_khz);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret =
+			    x_tune2(tnr_dmd->diver_sub, bandwidth,
+				    tnr_dmd->diver_sub->clk_mode,
+				    -shift_frequency_khz);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+	}
+
+	if (tnr_dmd->create_param.ts_output_if == CXD2880_TNRDMD_TSOUT_IF_TS) {
+		ret = set_ts_clk_mode_and_freq(tnr_dmd, sys);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	} else {
+		struct cxd2880_tnrdmd_pid_ftr_cfg *pid_ftr_cfg;
+
+		if (tnr_dmd->pid_ftr_cfg_en)
+			pid_ftr_cfg = &tnr_dmd->pid_ftr_cfg;
+		else
+			pid_ftr_cfg = NULL;
+
+		ret = pid_ftr_setting(tnr_dmd, pid_ftr_cfg);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_common_tune_setting2(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum cxd2880_dtv_sys sys,
+						     u8 en_fef_intmtnt_ctrl)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = x_tune3(tnr_dmd, sys, en_fef_intmtnt_ctrl);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = x_tune3(tnr_dmd->diver_sub, sys, en_fef_intmtnt_ctrl);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = x_tune4(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = cxd2880_tnrdmd_set_ts_output(tnr_dmd, 1);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_sleep(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state == CXD2880_TNRDMD_STATE_SLEEP) {
+	} else if (tnr_dmd->state == CXD2880_TNRDMD_STATE_ACTIVE) {
+		ret = cxd2880_tnrdmd_set_ts_output(tnr_dmd, 0);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = x_sleep1(tnr_dmd);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		ret = x_sleep2(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = x_sleep2(tnr_dmd->diver_sub);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		switch (tnr_dmd->sys) {
+		case CXD2880_DTV_SYS_DVBT:
+			ret = cxd2880_tnrdmd_dvbt_sleep_setting(tnr_dmd);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+			break;
+
+		case CXD2880_DTV_SYS_DVBT2:
+			ret = cxd2880_tnrdmd_dvbt2_sleep_setting(tnr_dmd);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+			break;
+
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		ret = x_sleep3(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = x_sleep3(tnr_dmd->diver_sub);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		ret = x_sleep4(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			ret = x_sleep4(tnr_dmd->diver_sub);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		tnr_dmd->state = CXD2880_TNRDMD_STATE_SLEEP;
+		tnr_dmd->frequency_khz = 0;
+		tnr_dmd->sys = CXD2880_DTV_SYS_UNKNOWN;
+		tnr_dmd->bandwidth = CXD2880_DTV_BW_UNKNOWN;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			tnr_dmd->diver_sub->state = CXD2880_TNRDMD_STATE_SLEEP;
+			tnr_dmd->diver_sub->frequency_khz = 0;
+			tnr_dmd->diver_sub->sys = CXD2880_DTV_SYS_UNKNOWN;
+			tnr_dmd->diver_sub->bandwidth = CXD2880_DTV_BW_UNKNOWN;
+		}
+	} else {
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_cfg(struct cxd2880_tnrdmd *tnr_dmd,
+					enum cxd2880_tnrdmd_cfg_id id,
+					int value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 data[2] = { 0 };
+	u8 need_sub_setting = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	switch (id) {
+	case CXD2880_TNRDMD_CFG_OUTPUT_SEL_MSB:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC4,
+							 (u8) (value ? 0x00 :
+							       0x10), 0x10);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSVALID_ACTIVE_HI:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC5,
+							 (u8) (value ? 0x00 :
+							       0x02), 0x02);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSSYNC_ACTIVE_HI:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC5,
+							 (u8) (value ? 0x00 :
+							       0x04), 0x04);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSERR_ACTIVE_HI:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xCB,
+							 (u8) (value ? 0x00 :
+							       0x01), 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_LATCH_ON_POSEDGE:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC5,
+							 (u8) (value ? 0x01 :
+							       0x00), 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSCLK_CONT:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		tnr_dmd->srl_ts_clk_mod_cnts = (u8) (value ? 0x01 : 0x00);
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSCLK_MASK:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 0x1F))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC6, (u8) value,
+							 0x1F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSVALID_MASK:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 0x1F))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC8, (u8) value,
+							 0x1F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSERR_MASK:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 0x1F))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xC9, (u8) value,
+							 0x1F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSERR_VALID_DIS:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x91,
+							 (u8) (value ? 0x01 :
+							       0x00), 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSPIN_CURRENT:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x51, (u8) value,
+							 0x3F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSPIN_PULLUP_MANUAL:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x50,
+							 (u8) (value ? 0x80 :
+							       0x00), 0x80);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSPIN_PULLUP:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x50, (u8) value,
+							 0x3F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSCLK_FREQ:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 1))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		tnr_dmd->srl_ts_clk_frq =
+		    (enum cxd2880_tnrdmd_serial_ts_clk)value;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TSBYTECLK_MANUAL:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 0xFF))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		tnr_dmd->ts_byte_clk_manual_setting = (u8) value;
+
+		break;
+
+	case CXD2880_TNRDMD_CFG_TS_PACKET_GAP:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		if ((value < 0) || (value > 7))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0xD6, (u8) value,
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		break;
+
+	case CXD2880_TNRDMD_CFG_TS_BACKWARDS_COMPATIBLE:
+		if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+			return CXD2880_RESULT_ERROR_SW_STATE;
+
+		tnr_dmd->is_ts_backwards_compatible_mode = (u8) (value ? 1 : 0);
+
+		break;
+
+	case CXD2880_TNRDMD_CFG_PWM_VALUE:
+		if ((value < 0) || (value > 0x1000))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x22,
+							 (u8) (value ? 0x01 :
+							       0x00), 0x01);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		{
+			u8 data[2];
+
+			data[0] = (u8) (((u16) value >> 8) & 0x1F);
+			data[1] = (u8) ((u16) value & 0xFF);
+
+			ret =
+			    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x23,
+							 data[0], 0x1F);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+
+			ret =
+			    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x24,
+							 data[1], 0xFF);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+
+		break;
+
+	case CXD2880_TNRDMD_CFG_INTERRUPT:
+		data[0] = (u8) ((value >> 8) & 0xFF);
+		data[1] = (u8) (value & 0xFF);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x48, data[0],
+							 0xFF);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x49, data[1],
+							 0xFF);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_INTERRUPT_LOCK_SEL:
+		data[0] = (u8) (value & 0x07);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x4A, data[0],
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_INTERRUPT_INV_LOCK_SEL:
+		data[0] = (u8) ((value & 0x07) << 3);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_SYS,
+							 0x00, 0x4A, data[0],
+							 0x38);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_FIXED_CLOCKMODE:
+		if ((value < (int)CXD2880_TNRDMD_CLOCKMODE_UNKNOWN)
+		    || (value > (int)CXD2880_TNRDMD_CLOCKMODE_C))
+			return CXD2880_RESULT_ERROR_RANGE;
+		tnr_dmd->fixed_clk_mode = (enum cxd2880_tnrdmd_clockmode)value;
+		break;
+
+	case CXD2880_TNRDMD_CFG_CABLE_INPUT:
+		tnr_dmd->is_cable_input = (u8) (value ? 1 : 0);
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT2_FEF_INTERMITTENT_BASE:
+		tnr_dmd->en_fef_intmtnt_base = (u8) (value ? 1 : 0);
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT2_FEF_INTERMITTENT_LITE:
+		tnr_dmd->en_fef_intmtnt_lite = (u8) (value ? 1 : 0);
+		break;
+
+	case CXD2880_TNRDMD_CFG_TS_BUF_ALMOST_EMPTY_THRS:
+		data[0] = (u8) ((value >> 8) & 0x07);
+		data[1] = (u8) (value & 0xFF);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x99, data[0],
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x9A, data[1],
+							 0xFF);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TS_BUF_ALMOST_FULL_THRS:
+		data[0] = (u8) ((value >> 8) & 0x07);
+		data[1] = (u8) (value & 0xFF);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x9B, data[0],
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x9C, data[1],
+							 0xFF);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_TS_BUF_RRDY_THRS:
+		data[0] = (u8) ((value >> 8) & 0x07);
+		data[1] = (u8) (value & 0xFF);
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x9D, data[0],
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x00, 0x9E, data[1],
+							 0xFF);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_BLINDTUNE_DVBT2_FIRST:
+		tnr_dmd->blind_tune_dvbt2_first = (u8) (value ? 1 : 0);
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT_BERN_PERIOD:
+		if ((value < 0) || (value > 31))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x10, 0x60,
+							 (u8) (value & 0x1F),
+							 0x1F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT_VBER_PERIOD:
+		if ((value < 0) || (value > 7))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x10, 0x6F,
+							 (u8) (value & 0x07),
+							 0x07);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT2_BBER_MES:
+		if ((value < 0) || (value > 15))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x20, 0x72,
+							 (u8) (value & 0x0F),
+							 0x0F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT2_LBER_MES:
+		if ((value < 0) || (value > 15))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x20, 0x6F,
+							 (u8) (value & 0x0F),
+							 0x0F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT_PER_MES:
+		if ((value < 0) || (value > 15))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x10, 0x5C,
+							 (u8) (value & 0x0F),
+							 0x0F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_DVBT2_PER_MES:
+		if ((value < 0) || (value > 15))
+			return CXD2880_RESULT_ERROR_RANGE;
+
+		ret =
+		    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x24, 0xDC,
+							 (u8) (value & 0x0F),
+							 0x0F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+		break;
+
+	case CXD2880_TNRDMD_CFG_ISDBT_BERPER_PERIOD:
+		{
+			u8 data[2];
+
+			data[0] = (u8) ((value & 0x00007F00) >> 8);
+			data[1] = (u8) (value & 0x000000FF);
+
+			ret =
+			    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x60, 0x5B,
+							 data[0], 0x7F);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+			ret =
+			    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd,
+							 CXD2880_IO_TGT_DMD,
+							 0x60, 0x5C,
+							 data[1], 0xFF);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		}
+		break;
+
+	default:
+		return CXD2880_RESULT_ERROR_ARG;
+	}
+
+	if (need_sub_setting
+	    && (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)) {
+		ret = cxd2880_tnrdmd_set_cfg(tnr_dmd->diver_sub, id, value);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_set_cfg(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 id,
+					     u8 en,
+					     enum cxd2880_tnrdmd_gpio_mode mode,
+					     u8 open_drain, u8 invert)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (id > 2)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (mode > CXD2880_TNRDMD_GPIO_MODE_EEW)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd, CXD2880_IO_TGT_SYS,
+						 0x00, 0x40 + id, (u8) mode,
+						 0x0F);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd, CXD2880_IO_TGT_SYS,
+						 0x00, 0x43,
+						 (u8) (open_drain ? (1 << id) :
+						       0), (u8) (1 << id));
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd, CXD2880_IO_TGT_SYS,
+						 0x00, 0x44,
+						 (u8) (invert ? (1 << id) : 0),
+						 (u8) (1 << id));
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd, CXD2880_IO_TGT_SYS,
+						 0x00, 0x45,
+						 (u8) (en ? 0 : (1 << id)),
+						 (u8) (1 << id));
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_set_cfg_sub(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 id,
+						 u8 en,
+						 enum cxd2880_tnrdmd_gpio_mode
+						 mode, u8 open_drain, u8 invert)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_gpio_set_cfg(tnr_dmd->diver_sub, id, en, mode,
+					open_drain, invert);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_read(struct cxd2880_tnrdmd *tnr_dmd,
+					  u8 id, u8 *value)
+{
+	u8 data = 0;
+
+	if ((!tnr_dmd) || (!value))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (id > 2)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x20, &data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*value = (u8) ((data >> id) & 0x01);
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_read_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 id, u8 *value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_gpio_read(tnr_dmd->diver_sub, id, value);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_write(struct cxd2880_tnrdmd *tnr_dmd,
+					   u8 id, u8 value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (id > 2)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_set_and_save_reg_bits(tnr_dmd, CXD2880_IO_TGT_SYS,
+						 0x00, 0x46,
+						 (u8) (value ? (1 << id) : 0),
+						 (u8) (1 << id));
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_write_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					       u8 id, u8 value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_gpio_write(tnr_dmd->diver_sub, id, value);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_interrupt_read(struct cxd2880_tnrdmd *tnr_dmd,
+					       u16 *value)
+{
+	u8 data[2] = { 0 };
+
+	if ((!tnr_dmd) || (!value))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x15, data,
+				   2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*value = (u16) (((u16) data[0] << 8) | (data[1]));
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_interrupt_clear(struct cxd2880_tnrdmd *tnr_dmd,
+						u16 value)
+{
+	u8 data[2] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = (u8) ((value >> 8) & 0xFF);
+	data[1] = (u8) (value & 0xFF);
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_SYS, 0x3C, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_ts_buf_clear(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 clear_overflow_flag,
+					     u8 clear_underflow_flag,
+					     u8 clear_buf)
+{
+	u8 data[2] = { 0 };
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	data[0] = (u8) (clear_overflow_flag ? 0x02 : 0x00);
+	data[0] |= (u8) (clear_underflow_flag ? 0x01 : 0x00);
+	data[1] = (u8) (clear_buf ? 0x01 : 0x00);
+	if (tnr_dmd->io->write_regs(tnr_dmd->io,
+				    CXD2880_IO_TGT_DMD, 0x9F, data,
+				    2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_chip_id(struct cxd2880_tnrdmd *tnr_dmd,
+					enum cxd2880_tnrdmd_chip_id *chip_id)
+{
+	u8 data = 0;
+
+	if ((!tnr_dmd) || (!chip_id))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0xFD, &data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*chip_id = (enum cxd2880_tnrdmd_chip_id)data;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_and_save_reg_bits(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum cxd2880_io_tgt tgt,
+						      u8 bank, u8 address,
+						      u8 value, u8 bit_mask)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   tgt, 0x00, bank) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (cxd2880_io_set_reg_bits(tnr_dmd->io, tgt, address, value, bit_mask)
+	    != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = set_cfg_mem(tnr_dmd, tgt, bank, address, value, bit_mask);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_scan_mode(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dtv_sys sys,
+					      u8 scan_mode_end)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	CXD2880_ARG_UNUSED(sys);
+
+	tnr_dmd->scan_mode = scan_mode_end;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+		ret =
+		    cxd2880_tnrdmd_set_scan_mode(tnr_dmd->diver_sub, sys,
+						 scan_mode_end);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_pid_ftr(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_tnrdmd_pid_ftr_cfg
+					    *pid_ftr_cfg)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->create_param.ts_output_if == CXD2880_TNRDMD_TSOUT_IF_TS)
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+
+	if (pid_ftr_cfg) {
+		tnr_dmd->pid_ftr_cfg = *pid_ftr_cfg;
+		tnr_dmd->pid_ftr_cfg_en = 1;
+	} else {
+		tnr_dmd->pid_ftr_cfg_en = 0;
+	}
+
+	if (tnr_dmd->state == CXD2880_TNRDMD_STATE_ACTIVE) {
+		ret = pid_ftr_setting(tnr_dmd, pid_ftr_cfg);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_rf_lvl_cmpstn(struct cxd2880_tnrdmd
+					  *tnr_dmd,
+					  enum
+					  cxd2880_ret(*rf_lvl_cmpstn)
+					  (struct cxd2880_tnrdmd *,
+					   int *))
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	tnr_dmd->rf_lvl_cmpstn = rf_lvl_cmpstn;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_rf_lvl_cmpstn_sub(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum
+						      cxd2880_ret
+						      (*rf_lvl_cmpstn)(struct
+								cxd2880_tnrdmd
+								*,
+								int *))
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_set_rf_lvl_cmpstn(tnr_dmd->diver_sub, rf_lvl_cmpstn);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_lna_thrs(struct cxd2880_tnrdmd *tnr_dmd,
+					     struct
+					     cxd2880_tnrdmd_lna_thrs_tbl_air
+					     *tbl_air,
+					     struct
+					     cxd2880_tnrdmd_lna_thrs_tbl_cable
+					     *tbl_cable)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	tnr_dmd->lna_thrs_tbl_air = tbl_air;
+	tnr_dmd->lna_thrs_tbl_cable = tbl_cable;
+
+	return CXD2880_RESULT_OK;
+
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_lna_thrs_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					 struct
+					 cxd2880_tnrdmd_lna_thrs_tbl_air
+					 *tbl_air,
+					 struct
+					 cxd2880_tnrdmd_lna_thrs_tbl_cable
+					 *tbl_cable)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_set_lna_thrs(tnr_dmd->diver_sub, tbl_air, tbl_cable);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_ts_pin_high_low(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 en, u8 value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->create_param.ts_output_if != CXD2880_TNRDMD_TSOUT_IF_TS)
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (en) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x50,
+					   ((value & 0x1F) | 0x80)) !=
+		    CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x52,
+					   (value & 0x1F)) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	} else {
+		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
+					     CXD2880_IO_TGT_SYS, 0x50, 0x3F);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x52,
+					   0x1F) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret = load_cfg_mem(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_set_ts_output(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 en)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	switch (tnr_dmd->create_param.ts_output_if) {
+	case CXD2880_TNRDMD_TSOUT_IF_TS:
+		if (en) {
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_SYS, 0x00,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_SYS, 0x52,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0xC3,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		} else {
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0xC3,
+						   0x01) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_SYS, 0x00,
+						   0x00) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_SYS, 0x52,
+						   0x1F) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_TNRDMD_TSOUT_IF_SPI:
+		break;
+
+	case CXD2880_TNRDMD_TSOUT_IF_SDIO:
+		break;
+
+	default:
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret slvt_freeze_reg(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	switch (tnr_dmd->create_param.ts_output_if) {
+	case CXD2880_TNRDMD_TSOUT_IF_SPI:
+	case CXD2880_TNRDMD_TSOUT_IF_SDIO:
+		{
+			u8 data = 0;
+
+			if (tnr_dmd->io->read_regs(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   &data,
+						   1) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+	case CXD2880_TNRDMD_TSOUT_IF_TS:
+	default:
+		break;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x01,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
new file mode 100644
index 0000000..84243e9
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
@@ -0,0 +1,395 @@
+/*
+ * cxd2880_tnrdmd.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common control interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_TNRDMD_H
+#define CXD2880_TNRDMD_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_io.h"
+#include "cxd2880_dtv.h"
+#include "cxd2880_dvbt.h"
+#include "cxd2880_dvbt2.h"
+
+#define CXD2880_TNRDMD_MAX_CFG_MEM_COUNT 100
+
+#define slvt_unfreeze_reg(tnr_dmd) ((void)((tnr_dmd)->io->write_reg\
+((tnr_dmd)->io, CXD2880_IO_TGT_DMD, 0x01, 0x00)))
+
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_BUF_UNDERFLOW     0x0001
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_BUF_OVERFLOW      0x0002
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_BUF_ALMOST_EMPTY  0x0004
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_BUF_ALMOST_FULL   0x0008
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_BUF_RRDY	  0x0010
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_ILLEGAL_COMMAND      0x0020
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_ILLEGAL_ACCESS       0x0040
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_CPU_ERROR	    0x0100
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_LOCK		 0x0200
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_INV_LOCK	     0x0400
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_NOOFDM	       0x0800
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_EWS		  0x1000
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_EEW		  0x2000
+#define CXD2880_TNRDMD_INTERRUPT_TYPE_FEC_FAIL	     0x4000
+
+#define CXD2880_TNRDMD_INTERRUPT_LOCK_SEL_L1POST_OK	0x01
+#define CXD2880_TNRDMD_INTERRUPT_LOCK_SEL_DMD_LOCK	 0x02
+#define CXD2880_TNRDMD_INTERRUPT_LOCK_SEL_TS_LOCK	  0x04
+
+enum cxd2880_tnrdmd_chip_id {
+	CXD2880_TNRDMD_CHIP_ID_UNKNOWN = 0x00,
+	CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X = 0x62,
+	CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_11 = 0x6A
+};
+
+#define CXD2880_TNRDMD_CHIP_ID_VALID(chip_id) (((chip_id) == \
+CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X) || \
+((chip_id) == CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_11))
+
+enum cxd2880_tnrdmd_state {
+	CXD2880_TNRDMD_STATE_UNKNOWN,
+	CXD2880_TNRDMD_STATE_SLEEP,
+	CXD2880_TNRDMD_STATE_ACTIVE,
+	CXD2880_TNRDMD_STATE_INVALID
+};
+
+enum cxd2880_tnrdmd_divermode {
+	CXD2880_TNRDMD_DIVERMODE_SINGLE,
+	CXD2880_TNRDMD_DIVERMODE_MAIN,
+	CXD2880_TNRDMD_DIVERMODE_SUB
+};
+
+enum cxd2880_tnrdmd_clockmode {
+	CXD2880_TNRDMD_CLOCKMODE_UNKNOWN,
+	CXD2880_TNRDMD_CLOCKMODE_A,
+	CXD2880_TNRDMD_CLOCKMODE_B,
+	CXD2880_TNRDMD_CLOCKMODE_C
+};
+
+enum cxd2880_tnrdmd_tsout_if {
+	CXD2880_TNRDMD_TSOUT_IF_TS,
+	CXD2880_TNRDMD_TSOUT_IF_SPI,
+	CXD2880_TNRDMD_TSOUT_IF_SDIO
+};
+
+enum cxd2880_tnrdmd_xtal_share {
+	CXD2880_TNRDMD_XTAL_SHARE_NONE,
+	CXD2880_TNRDMD_XTAL_SHARE_EXTREF,
+	CXD2880_TNRDMD_XTAL_SHARE_MASTER,
+	CXD2880_TNRDMD_XTAL_SHARE_SLAVE
+};
+
+enum cxd2880_tnrdmd_spectrum_sense {
+	CXD2880_TNRDMD_SPECTRUM_NORMAL,
+	CXD2880_TNRDMD_SPECTRUM_INV
+};
+
+enum cxd2880_tnrdmd_cfg_id {
+	CXD2880_TNRDMD_CFG_OUTPUT_SEL_MSB,
+	CXD2880_TNRDMD_CFG_TSVALID_ACTIVE_HI,
+	CXD2880_TNRDMD_CFG_TSSYNC_ACTIVE_HI,
+	CXD2880_TNRDMD_CFG_TSERR_ACTIVE_HI,
+	CXD2880_TNRDMD_CFG_LATCH_ON_POSEDGE,
+	CXD2880_TNRDMD_CFG_TSCLK_CONT,
+	CXD2880_TNRDMD_CFG_TSCLK_MASK,
+	CXD2880_TNRDMD_CFG_TSVALID_MASK,
+	CXD2880_TNRDMD_CFG_TSERR_MASK,
+	CXD2880_TNRDMD_CFG_TSERR_VALID_DIS,
+	CXD2880_TNRDMD_CFG_TSPIN_CURRENT,
+	CXD2880_TNRDMD_CFG_TSPIN_PULLUP_MANUAL,
+	CXD2880_TNRDMD_CFG_TSPIN_PULLUP,
+	CXD2880_TNRDMD_CFG_TSCLK_FREQ,
+	CXD2880_TNRDMD_CFG_TSBYTECLK_MANUAL,
+	CXD2880_TNRDMD_CFG_TS_PACKET_GAP,
+	CXD2880_TNRDMD_CFG_TS_BACKWARDS_COMPATIBLE,
+	CXD2880_TNRDMD_CFG_PWM_VALUE,
+	CXD2880_TNRDMD_CFG_INTERRUPT,
+	CXD2880_TNRDMD_CFG_INTERRUPT_LOCK_SEL,
+	CXD2880_TNRDMD_CFG_INTERRUPT_INV_LOCK_SEL,
+	CXD2880_TNRDMD_CFG_TS_BUF_ALMOST_EMPTY_THRS,
+	CXD2880_TNRDMD_CFG_TS_BUF_ALMOST_FULL_THRS,
+	CXD2880_TNRDMD_CFG_TS_BUF_RRDY_THRS,
+	CXD2880_TNRDMD_CFG_FIXED_CLOCKMODE,
+	CXD2880_TNRDMD_CFG_CABLE_INPUT,
+	CXD2880_TNRDMD_CFG_DVBT2_FEF_INTERMITTENT_BASE,
+	CXD2880_TNRDMD_CFG_DVBT2_FEF_INTERMITTENT_LITE,
+	CXD2880_TNRDMD_CFG_BLINDTUNE_DVBT2_FIRST,
+	CXD2880_TNRDMD_CFG_DVBT_BERN_PERIOD,
+	CXD2880_TNRDMD_CFG_DVBT_VBER_PERIOD,
+	CXD2880_TNRDMD_CFG_DVBT_PER_MES,
+	CXD2880_TNRDMD_CFG_DVBT2_BBER_MES,
+	CXD2880_TNRDMD_CFG_DVBT2_LBER_MES,
+	CXD2880_TNRDMD_CFG_DVBT2_PER_MES,
+	CXD2880_TNRDMD_CFG_ISDBT_BERPER_PERIOD
+};
+
+enum cxd2880_tnrdmd_lock_result {
+	CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT,
+	CXD2880_TNRDMD_LOCK_RESULT_LOCKED,
+	CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED
+};
+
+enum cxd2880_tnrdmd_gpio_mode {
+	CXD2880_TNRDMD_GPIO_MODE_OUTPUT = 0x00,
+	CXD2880_TNRDMD_GPIO_MODE_INPUT = 0x01,
+	CXD2880_TNRDMD_GPIO_MODE_INT = 0x02,
+	CXD2880_TNRDMD_GPIO_MODE_FEC_FAIL = 0x03,
+	CXD2880_TNRDMD_GPIO_MODE_PWM = 0x04,
+	CXD2880_TNRDMD_GPIO_MODE_EWS = 0x05,
+	CXD2880_TNRDMD_GPIO_MODE_EEW = 0x06
+};
+
+enum cxd2880_tnrdmd_serial_ts_clk {
+	CXD2880_TNRDMD_SERIAL_TS_CLK_FULL,
+	CXD2880_TNRDMD_SERIAL_TS_CLK_HALF
+};
+
+struct cxd2880_tnrdmd_cfg_mem {
+	enum cxd2880_io_tgt tgt;
+	u8 bank;
+	u8 address;
+	u8 value;
+	u8 bit_mask;
+};
+
+struct cxd2880_tnrdmd_pid_cfg {
+	u8 is_en;
+	u16 pid;
+};
+
+struct cxd2880_tnrdmd_pid_ftr_cfg {
+	u8 is_negative;
+	struct cxd2880_tnrdmd_pid_cfg pid_cfg[32];
+};
+
+struct cxd2880_tnrdmd_ts_buf_info {
+	u8 read_ready;
+	u8 almost_full;
+	u8 almost_empty;
+	u8 overflow;
+	u8 underflow;
+	u16 packet_num;
+};
+
+struct cxd2880_tnrdmd_lna_thrs {
+	u8 off_on;
+	u8 on_off;
+};
+
+struct cxd2880_tnrdmd_lna_thrs_tbl_air {
+	struct cxd2880_tnrdmd_lna_thrs thrs[24];
+};
+
+struct cxd2880_tnrdmd_lna_thrs_tbl_cable {
+	struct cxd2880_tnrdmd_lna_thrs thrs[32];
+};
+
+struct cxd2880_tnrdmd_create_param {
+	enum cxd2880_tnrdmd_tsout_if ts_output_if;
+	u8 en_internal_ldo;
+	enum cxd2880_tnrdmd_xtal_share xtal_share_type;
+	u8 xosc_cap;
+	u8 xosc_i;
+	u8 is_cxd2881gg;
+	u8 stationary_use;
+};
+
+struct cxd2880_tnrdmd_diver_create_param {
+	enum cxd2880_tnrdmd_tsout_if ts_output_if;
+	u8 en_internal_ldo;
+	u8 xosc_cap_main;
+	u8 xosc_i_main;
+	u8 xosc_i_sub;
+	u8 is_cxd2881gg;
+	u8 stationary_use;
+};
+
+struct cxd2880_tnrdmd {
+	struct cxd2880_tnrdmd *diver_sub;
+	struct cxd2880_io *io;
+	struct cxd2880_tnrdmd_create_param create_param;
+	enum cxd2880_tnrdmd_divermode diver_mode;
+	enum cxd2880_tnrdmd_clockmode fixed_clk_mode;
+	u8 is_cable_input;
+	u8 en_fef_intmtnt_base;
+	u8 en_fef_intmtnt_lite;
+	u8 blind_tune_dvbt2_first;
+	enum cxd2880_ret (*rf_lvl_cmpstn)(struct cxd2880_tnrdmd *tnr_dmd,
+					   int *rf_lvl_db);
+	struct cxd2880_tnrdmd_lna_thrs_tbl_air *lna_thrs_tbl_air;
+	struct cxd2880_tnrdmd_lna_thrs_tbl_cable *lna_thrs_tbl_cable;
+	u8 srl_ts_clk_mod_cnts;
+	enum cxd2880_tnrdmd_serial_ts_clk srl_ts_clk_frq;
+	u8 ts_byte_clk_manual_setting;
+	u8 is_ts_backwards_compatible_mode;
+	struct cxd2880_tnrdmd_cfg_mem cfg_mem[CXD2880_TNRDMD_MAX_CFG_MEM_COUNT];
+	u8 cfg_mem_last_entry;
+	struct cxd2880_tnrdmd_pid_ftr_cfg pid_ftr_cfg;
+	u8 pid_ftr_cfg_en;
+	void *user;
+	enum cxd2880_tnrdmd_chip_id chip_id;
+	enum cxd2880_tnrdmd_state state;
+	enum cxd2880_tnrdmd_clockmode clk_mode;
+	u32 frequency_khz;
+	enum cxd2880_dtv_sys sys;
+	enum cxd2880_dtv_bandwidth bandwidth;
+	u8 scan_mode;
+	struct cxd2880_atomic cancel;
+};
+
+enum cxd2880_ret cxd2880_tnrdmd_create(struct cxd2880_tnrdmd *tnr_dmd,
+				       struct cxd2880_io *io,
+				       struct cxd2880_tnrdmd_create_param
+				       *create_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_diver_create(struct cxd2880_tnrdmd
+					     *tnr_dmd_main,
+					     struct cxd2880_io *io_main,
+					     struct cxd2880_tnrdmd *tnr_dmd_sub,
+					     struct cxd2880_io *io_sub,
+					     struct
+					     cxd2880_tnrdmd_diver_create_param
+					     *create_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_init1(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_init2(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_check_internal_cpu_status(struct cxd2880_tnrdmd
+							  *tnr_dmd,
+							  u8 *task_completed);
+
+enum cxd2880_ret cxd2880_tnrdmd_common_tune_setting1(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum cxd2880_dtv_sys sys,
+						     u32 frequency_khz,
+						     enum cxd2880_dtv_bandwidth
+						     bandwidth, u8 one_seg_opt,
+						     u8 one_seg_opt_shft_dir);
+
+enum cxd2880_ret cxd2880_tnrdmd_common_tune_setting2(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum cxd2880_dtv_sys sys,
+						     u8 en_fef_intmtnt_ctrl);
+
+enum cxd2880_ret cxd2880_tnrdmd_sleep(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_cfg(struct cxd2880_tnrdmd *tnr_dmd,
+					enum cxd2880_tnrdmd_cfg_id id,
+					int value);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_set_cfg(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 id,
+					     u8 en,
+					     enum cxd2880_tnrdmd_gpio_mode mode,
+					     u8 open_drain, u8 invert);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_set_cfg_sub(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 id,
+						 u8 en,
+						 enum cxd2880_tnrdmd_gpio_mode
+						 mode, u8 open_drain,
+						 u8 invert);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_read(struct cxd2880_tnrdmd *tnr_dmd,
+					  u8 id, u8 *value);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_read_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 id, u8 *value);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_write(struct cxd2880_tnrdmd *tnr_dmd,
+					   u8 id, u8 value);
+
+enum cxd2880_ret cxd2880_tnrdmd_gpio_write_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					       u8 id, u8 value);
+
+enum cxd2880_ret cxd2880_tnrdmd_interrupt_read(struct cxd2880_tnrdmd *tnr_dmd,
+					       u16 *value);
+
+enum cxd2880_ret cxd2880_tnrdmd_interrupt_clear(struct cxd2880_tnrdmd *tnr_dmd,
+						u16 value);
+
+enum cxd2880_ret cxd2880_tnrdmd_ts_buf_clear(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 clear_overflow_flag,
+					     u8 clear_underflow_flag,
+					     u8 clear_buf);
+
+enum cxd2880_ret cxd2880_tnrdmd_chip_id(struct cxd2880_tnrdmd *tnr_dmd,
+					enum cxd2880_tnrdmd_chip_id *chip_id);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_and_save_reg_bits(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum cxd2880_io_tgt tgt,
+						      u8 bank, u8 address,
+						      u8 value, u8 bit_mask);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_scan_mode(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dtv_sys sys,
+					      u8 scan_mode_end);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_pid_ftr(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_tnrdmd_pid_ftr_cfg
+					    *pid_ftr_cfg);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_rf_lvl_cmpstn(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum
+						  cxd2880_ret(*rf_lvl_cmpstn)
+						  (struct cxd2880_tnrdmd *,
+						   int *));
+
+enum cxd2880_ret cxd2880_tnrdmd_set_rf_lvl_cmpstn_sub(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum
+						      cxd2880_ret
+						      (*rf_lvl_cmpstn)(struct
+								cxd2880_tnrdmd
+								*,
+								int *));
+
+enum cxd2880_ret cxd2880_tnrdmd_set_lna_thrs(struct cxd2880_tnrdmd *tnr_dmd,
+					     struct
+					     cxd2880_tnrdmd_lna_thrs_tbl_air
+					     *tbl_air,
+					     struct
+					     cxd2880_tnrdmd_lna_thrs_tbl_cable
+					     *tbl_cable);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_lna_thrs_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					 struct
+					 cxd2880_tnrdmd_lna_thrs_tbl_air
+					 *tbl_air,
+					 struct
+					 cxd2880_tnrdmd_lna_thrs_tbl_cable
+					 *tbl_cable);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_ts_pin_high_low(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 en, u8 value);
+
+enum cxd2880_ret cxd2880_tnrdmd_set_ts_output(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 en);
+
+enum cxd2880_ret slvt_freeze_reg(struct cxd2880_tnrdmd *tnr_dmd);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
new file mode 100644
index 0000000..61ad9e9
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
@@ -0,0 +1,29 @@
+/*
+ * cxd2880_tnrdmd_driver_version.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * version information
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#define CXD2880_TNRDMD_DRIVER_VERSION "1.4.1 - 0.0.4"
+
+#define CXD2880_TNRDMD_DRIVER_RELEASE_DATE "2017-03-02"
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
new file mode 100644
index 0000000..1ff1f87
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
@@ -0,0 +1,207 @@
+/*
+ * cxd2880_tnrdmd_mon.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common monitor functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd_mon.h"
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_rf_lvl(struct cxd2880_tnrdmd *tnr_dmd,
+					   int *rf_lvl_db)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!rf_lvl_db))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data[2] = { 0x80, 0x00 };
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_SYS, 0x5B, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	CXD2880_SLEEP_IN_MON(2, tnr_dmd);
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x1A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data[2];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x15, data,
+					   2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if ((data[0] != 0) || (data[1] != 0))
+			return CXD2880_RESULT_ERROR_OTHER;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_SYS, 0x11, data,
+					   2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		*rf_lvl_db =
+		    cxd2880_convert2s_complement((data[0] << 3) |
+						 ((data[1] & 0xE0) >> 5), 11);
+	}
+
+	*rf_lvl_db *= 125;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->rf_lvl_cmpstn) {
+		ret = tnr_dmd->rf_lvl_cmpstn(tnr_dmd, rf_lvl_db);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_rf_lvl_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					       int *rf_lvl_db)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!rf_lvl_db))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd->diver_sub, rf_lvl_db);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_internal_cpu_status(struct cxd2880_tnrdmd
+							*tnr_dmd, u16 *status)
+{
+	u8 data[2] = { 0 };
+
+	if ((!tnr_dmd) || (!status))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x1A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x15, data,
+				   2) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*status = (u16) (((u16) data[0] << 8) | data[1]);
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_internal_cpu_status_sub(struct
+							    cxd2880_tnrdmd
+							    *tnr_dmd,
+							    u16 *status)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!status))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_mon_internal_cpu_status(tnr_dmd->diver_sub, status);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_ts_buf_info(struct cxd2880_tnrdmd *tnr_dmd,
+						struct
+						cxd2880_tnrdmd_ts_buf_info
+						*info)
+{
+	u8 data[3] = { 0 };
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!info))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0A) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x50, data,
+				   3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	info->read_ready = (u8) ((data[0] & 0x10) ? 0x01 : 0x00);
+	info->almost_full = (u8) ((data[0] & 0x08) ? 0x01 : 0x00);
+	info->almost_empty = (u8) ((data[0] & 0x04) ? 0x01 : 0x00);
+	info->overflow = (u8) ((data[0] & 0x02) ? 0x01 : 0x00);
+	info->underflow = (u8) ((data[0] & 0x01) ? 0x01 : 0x00);
+
+	info->packet_num = (u16) (((u32) (data[1] & 0x07) << 8) | data[2]);
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
new file mode 100644
index 0000000..37d37d5
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
@@ -0,0 +1,52 @@
+/*
+ * cxd2880_tnrdmd_mon.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * common monitor interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_TNRDMD_MON_H
+#define CXD2880_TNRDMD_MON_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_tnrdmd.h"
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_rf_lvl(struct cxd2880_tnrdmd *tnr_dmd,
+					   int *rf_lvl_db);
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_rf_lvl_sub(struct cxd2880_tnrdmd *tnr_dmd,
+					       int *rf_lvl_db);
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_internal_cpu_status(struct cxd2880_tnrdmd
+							*tnr_dmd, u16 *status);
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_internal_cpu_status_sub(struct
+							    cxd2880_tnrdmd
+							    *tnr_dmd,
+							    u16 *status);
+
+enum cxd2880_ret cxd2880_tnrdmd_mon_ts_buf_info(struct cxd2880_tnrdmd *tnr_dmd,
+						struct
+						cxd2880_tnrdmd_ts_buf_info
+						*info);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
new file mode 100644
index 0000000..2302ea5
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
@@ -0,0 +1,1558 @@
+/*
+ * cxd2880_top.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/spi/spi.h>
+
+#include "dvb_frontend.h"
+
+#include "cxd2880.h"
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_tnrdmd_dvbt2.h"
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_tnrdmd_dvbt2_mon.h"
+#include "cxd2880_tnrdmd_dvbt_mon.h"
+#include "cxd2880_integ.h"
+#include "cxd2880_integ_dvbt2.h"
+#include "cxd2880_integ_dvbt.h"
+#include "cxd2880_io.h"
+#include "cxd2880_devio_spi.h"
+#include "cxd2880_spi_device.h"
+#include "cxd2880_tnrdmd_driver_version.h"
+
+struct cxd2880_priv {
+	struct cxd2880_tnrdmd tnrdmd;
+	struct spi_device *spi;
+	struct cxd2880_io regio;
+	struct cxd2880_spi_device spi_device;
+	struct cxd2880_spi cxd2880_spi;
+	struct cxd2880_dvbt_tune_param dvbt_tune_param;
+	struct cxd2880_dvbt2_tune_param dvbt2_tune_param;
+	struct mutex *spi_mutex;
+};
+
+/*
+ * return value conversion table
+ */
+static int return_tbl[] = {
+	0,             /* CXD2880_RESULT_OK */
+	-EINVAL,       /* CXD2880_RESULT_ERROR_ARG*/
+	-EIO,          /* CXD2880_RESULT_ERROR_IO */
+	-EPERM,        /* CXD2880_RESULT_ERROR_SW_STATE */
+	-EBUSY,        /* CXD2880_RESULT_ERROR_HW_STATE */
+	-ETIME,        /* CXD2880_RESULT_ERROR_TIMEOUT */
+	-EAGAIN,       /* CXD2880_RESULT_ERROR_UNLOCK */
+	-ERANGE,       /* CXD2880_RESULT_ERROR_RANGE */
+	-EOPNOTSUPP,   /* CXD2880_RESULT_ERROR_NOSUPPORT */
+	-ECANCELED,    /* CXD2880_RESULT_ERROR_CANCEL */
+	-EPERM,        /* CXD2880_RESULT_ERROR_OTHER */
+	-EOVERFLOW,    /* CXD2880_RESULT_ERROR_OVERFLOW */
+	0,             /* CXD2880_RESULT_OK_CONFIRM */
+};
+
+static enum cxd2880_ret cxd2880_pre_bit_err_t(
+		struct cxd2880_tnrdmd *tnrdmd, u32 *pre_bit_err,
+		u32 *pre_bit_count)
+{
+	u8 rdata[2];
+
+	if ((!tnrdmd) || (!pre_bit_err) || (!pre_bit_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnrdmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x10) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x39, rdata, 1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if ((rdata[0] & 0x01) == 0) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x22, rdata, 2) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	*pre_bit_err = (rdata[0] << 8) | rdata[1];
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x6F, rdata, 1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnrdmd);
+
+	*pre_bit_count = ((rdata[0] & 0x07) == 0) ?
+			256 : (0x1000 << (rdata[0] & 0x07));
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_pre_bit_err_t2(
+		struct cxd2880_tnrdmd *tnrdmd, u32 *pre_bit_err,
+		u32 *pre_bit_count)
+{
+	u32 period_exp = 0;
+	u32 n_ldpc = 0;
+	u8 data[5];
+
+	if ((!tnrdmd) || (!pre_bit_err) || (!pre_bit_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnrdmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x3C, data, sizeof(data))
+				 != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (!(data[0] & 0x01)) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+	*pre_bit_err =
+	((data[1] & 0x0F) << 24) | (data[2] << 16) | (data[3] << 8) | data[4];
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0xA0, data, 1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnrdmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (((enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03)) ==
+	    CXD2880_DVBT2_FEC_LDPC_16K)
+		n_ldpc = 16200;
+	else
+		n_ldpc = 64800;
+	slvt_unfreeze_reg(tnrdmd);
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x20) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x6F, data, 1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	period_exp = data[0] & 0x0F;
+
+	*pre_bit_count = (1U << period_exp) * n_ldpc;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_post_bit_err_t(struct cxd2880_tnrdmd *tnrdmd,
+						u32 *post_bit_err,
+						u32 *post_bit_count)
+{
+	u8 rdata[3];
+	u32 bit_error = 0;
+	u32 period_exp = 0;
+
+	if ((!tnrdmd) || (!post_bit_err) || (!post_bit_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x15, rdata, 3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if ((rdata[0] & 0x40) == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	*post_bit_err = ((rdata[0] & 0x3F) << 16) | (rdata[1] << 8) | rdata[2];
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x60, rdata, 1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	period_exp = (rdata[0] & 0x1F);
+
+	if ((period_exp <= 11) && (bit_error > (1U << period_exp) * 204 * 8))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (period_exp == 11)
+		*post_bit_count = 3342336;
+	else
+		*post_bit_count = (1U << period_exp) * 204 * 81;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_post_bit_err_t2(struct cxd2880_tnrdmd *tnrdmd,
+						u32 *post_bit_err,
+						u32 *post_bit_count)
+{
+	u32 period_exp = 0;
+	u32 n_bch = 0;
+
+	if ((!tnrdmd) || (!post_bit_err) || (!post_bit_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[3];
+		enum cxd2880_dvbt2_plp_fec plp_fec_type =
+			CXD2880_DVBT2_FEC_LDPC_16K;
+		enum cxd2880_dvbt2_plp_code_rate plp_code_rate =
+			CXD2880_DVBT2_R1_2;
+
+		static const u16 n_bch_bits_lookup[2][8] = {
+			{7200, 9720, 10800, 11880, 12600, 13320, 5400, 6480},
+			{32400, 38880, 43200, 48600, 51840, 54000, 21600, 25920}
+		};
+
+		if (slvt_freeze_reg(tnrdmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x00, 0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnrdmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					 0x15, data, 3) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnrdmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(data[0] & 0x40)) {
+			slvt_unfreeze_reg(tnrdmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		*post_bit_err =
+			((data[0] & 0x3F) << 16) | (data[1] << 8) | data[2];
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x9D, data, 1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnrdmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		plp_code_rate =
+		(enum cxd2880_dvbt2_plp_code_rate)(data[0] & 0x07);
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0xA0, data, 1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnrdmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		plp_fec_type = (enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03);
+
+		slvt_unfreeze_reg(tnrdmd);
+
+		if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x00, 0x20) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x72, data, 1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		period_exp = data[0] & 0x0F;
+
+		if ((plp_fec_type > CXD2880_DVBT2_FEC_LDPC_64K) ||
+			(plp_code_rate > CXD2880_DVBT2_R2_5))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		n_bch = n_bch_bits_lookup[plp_fec_type][plp_code_rate];
+	}
+
+	if (*post_bit_err > ((1U << period_exp) * n_bch))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	*post_bit_count = (1U << period_exp) * n_bch;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_read_block_err_t(
+					struct cxd2880_tnrdmd *tnrdmd,
+					u32 *block_err,
+					u32 *block_count)
+{
+	u8 rdata[3];
+
+	if ((!tnrdmd) || (!block_err) || (!block_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x18, rdata, 3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if ((rdata[0] & 0x01) == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	*block_err = (rdata[1] << 8) | rdata[2];
+
+	if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x00, 0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+				0x5C, rdata, 1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*block_count = 1U << (rdata[0] & 0x0F);
+
+	if ((*block_count == 0) || (*block_err > *block_count))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret cxd2880_read_block_err_t2(
+					struct cxd2880_tnrdmd *tnrdmd,
+					u32 *block_err,
+					u32 *block_count)
+{
+	if ((!tnrdmd) || (!block_err) || (!block_count))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnrdmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	if (tnrdmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 rdata[3];
+
+		if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x00, 0x0B) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x18, rdata, 3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if ((rdata[0] & 0x01) == 0)
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		*block_err = (rdata[1] << 8) | rdata[2];
+
+		if (tnrdmd->io->write_reg(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0x00, 0x24) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnrdmd->io->read_regs(tnrdmd->io, CXD2880_IO_TGT_DMD,
+					0xDC, rdata, 1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		*block_count = 1U << (rdata[0] & 0x0F);
+	}
+
+	if ((*block_count == 0) || (*block_err > *block_count))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	return CXD2880_RESULT_OK;
+}
+
+static void cxd2880_release(struct dvb_frontend *fe)
+{
+	struct cxd2880_priv *priv = NULL;
+
+	if (!fe) {
+		pr_err("%s: invalid arg.\n", __func__);
+		return;
+	}
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	kfree(priv);
+}
+
+static int cxd2880_init(struct dvb_frontend *fe)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_priv *priv = NULL;
+	struct cxd2880_tnrdmd_create_param create_param;
+
+	if (!fe) {
+		pr_err("%s: invalid arg.\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+
+	create_param.ts_output_if = CXD2880_TNRDMD_TSOUT_IF_SPI;
+	create_param.xtal_share_type = CXD2880_TNRDMD_XTAL_SHARE_NONE;
+	create_param.en_internal_ldo = 1;
+	create_param.xosc_cap = 18;
+	create_param.xosc_i = 8;
+	create_param.stationary_use = 1;
+
+	mutex_lock(priv->spi_mutex);
+	if (priv->tnrdmd.io != &priv->regio) {
+		ret = cxd2880_tnrdmd_create(&priv->tnrdmd,
+				&priv->regio, &create_param);
+		if (ret != CXD2880_RESULT_OK) {
+			mutex_unlock(priv->spi_mutex);
+			dev_info(&priv->spi->dev,
+				"%s: cxd2880 tnrdmd create failed %d\n",
+				__func__, ret);
+			return return_tbl[ret];
+		}
+	}
+	ret = cxd2880_integ_init(&priv->tnrdmd);
+	if (ret != CXD2880_RESULT_OK) {
+		mutex_unlock(priv->spi_mutex);
+		dev_err(&priv->spi->dev, "%s: cxd2880 integ init failed %d\n",
+				__func__, ret);
+		return return_tbl[ret];
+	}
+	mutex_unlock(priv->spi_mutex);
+
+	dev_dbg(&priv->spi->dev, "%s: OK.\n", __func__);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_sleep(struct dvb_frontend *fe)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_priv *priv = NULL;
+
+	if (!fe) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_sleep(&priv->tnrdmd);
+	mutex_unlock(priv->spi_mutex);
+
+	dev_dbg(&priv->spi->dev, "%s: tnrdmd_sleep ret %d\n",
+		__func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_read_signal_strength(struct dvb_frontend *fe,
+				u16 *strength)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_priv *priv = NULL;
+	struct dtv_frontend_properties *c = NULL;
+	int level = 0;
+
+	if ((!fe) || (!strength)) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+
+	mutex_lock(priv->spi_mutex);
+	if ((c->delivery_system == SYS_DVBT) ||
+		(c->delivery_system == SYS_DVBT2)) {
+		ret = cxd2880_tnrdmd_mon_rf_lvl(&priv->tnrdmd, &level);
+	} else {
+		dev_dbg(&priv->spi->dev, "%s: invalid system\n", __func__);
+		mutex_unlock(priv->spi_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(priv->spi_mutex);
+
+	level /= 125;
+	/* -105dBm - -30dBm (-105000/125 = -840, -30000/125 = -240 */
+	level = clamp(level, -840, -240);
+	/* scale value to 0x0000-0xFFFF */
+	*strength = (u16)(((level + 840) * 0xFFFF) / (-240 + 840));
+
+	if (ret != CXD2880_RESULT_OK)
+		dev_dbg(&priv->spi->dev, "%s: ret = %d\n", __func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	int snrvalue = 0;
+	struct cxd2880_priv *priv = NULL;
+	struct dtv_frontend_properties *c = NULL;
+
+	if ((!fe) || (!snr)) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+
+	mutex_lock(priv->spi_mutex);
+	if (c->delivery_system == SYS_DVBT) {
+		ret = cxd2880_tnrdmd_dvbt_mon_snr(&priv->tnrdmd,
+						&snrvalue);
+	} else if (c->delivery_system == SYS_DVBT2) {
+		ret = cxd2880_tnrdmd_dvbt2_mon_snr(&priv->tnrdmd,
+						&snrvalue);
+	} else {
+		dev_err(&priv->spi->dev, "%s: invalid system\n", __func__);
+		mutex_unlock(priv->spi_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(priv->spi_mutex);
+
+	if (snrvalue < 0)
+		snrvalue = 0;
+	*snr = (u16)snrvalue;
+
+	if (ret != CXD2880_RESULT_OK)
+		dev_dbg(&priv->spi->dev, "%s: ret = %d\n", __func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_priv *priv = NULL;
+	struct dtv_frontend_properties *c = NULL;
+
+	if ((!fe) || (!ucblocks)) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+
+	mutex_lock(priv->spi_mutex);
+	if (c->delivery_system == SYS_DVBT) {
+		ret = cxd2880_tnrdmd_dvbt_mon_packet_error_number(
+								&priv->tnrdmd,
+								ucblocks);
+	} else if (c->delivery_system == SYS_DVBT2) {
+		ret = cxd2880_tnrdmd_dvbt2_mon_packet_error_number(
+								&priv->tnrdmd,
+								ucblocks);
+	} else {
+		dev_err(&priv->spi->dev, "%s: invlaid system\n", __func__);
+		mutex_unlock(priv->spi_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(priv->spi_mutex);
+
+	if (ret != CXD2880_RESULT_OK)
+		dev_dbg(&priv->spi->dev, "%s: ret = %d\n", __func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_priv *priv = NULL;
+	struct dtv_frontend_properties *c = NULL;
+
+	if ((!fe) || (!ber)) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+
+	mutex_lock(priv->spi_mutex);
+	if (c->delivery_system == SYS_DVBT) {
+		ret = cxd2880_tnrdmd_dvbt_mon_pre_rsber(&priv->tnrdmd,
+						ber);
+		/* x100 to change unit.(10^7 -> 10^9 */
+		*ber *= 100;
+	} else if (c->delivery_system == SYS_DVBT2) {
+		ret = cxd2880_tnrdmd_dvbt2_mon_pre_bchber(&priv->tnrdmd,
+						ber);
+	} else {
+		dev_err(&priv->spi->dev, "%s: invlaid system\n", __func__);
+		mutex_unlock(priv->spi_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(priv->spi_mutex);
+
+	if (ret != CXD2880_RESULT_OK)
+		dev_dbg(&priv->spi->dev, "%s: ret = %d\n", __func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_set_frontend(struct dvb_frontend *fe)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct dtv_frontend_properties *c;
+	struct cxd2880_priv *priv;
+	enum cxd2880_dtv_bandwidth bw = CXD2880_DTV_BW_1_7_MHZ;
+
+	if (!fe) {
+		pr_err("%s: inavlid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+
+	switch (c->bandwidth_hz) {
+	case 1712000:
+		bw = CXD2880_DTV_BW_1_7_MHZ;
+		break;
+	case 5000000:
+		bw = CXD2880_DTV_BW_5_MHZ;
+		break;
+	case 6000000:
+		bw = CXD2880_DTV_BW_6_MHZ;
+		break;
+	case 7000000:
+		bw = CXD2880_DTV_BW_7_MHZ;
+		break;
+	case 8000000:
+		bw = CXD2880_DTV_BW_8_MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dev_info(&priv->spi->dev, "%s: sys:%d freq:%d bw:%d\n", __func__,
+			c->delivery_system, c->frequency, bw);
+	mutex_lock(priv->spi_mutex);
+	if (c->delivery_system == SYS_DVBT) {
+		priv->tnrdmd.sys = CXD2880_DTV_SYS_DVBT;
+		priv->dvbt_tune_param.center_freq_khz = c->frequency / 1000;
+		priv->dvbt_tune_param.bandwidth = bw;
+		priv->dvbt_tune_param.profile = CXD2880_DVBT_PROFILE_HP;
+		ret = cxd2880_integ_dvbt_tune(&priv->tnrdmd,
+						&priv->dvbt_tune_param);
+	} else if (c->delivery_system == SYS_DVBT2) {
+		priv->tnrdmd.sys = CXD2880_DTV_SYS_DVBT2;
+		priv->dvbt2_tune_param.center_freq_khz = c->frequency / 1000;
+		priv->dvbt2_tune_param.bandwidth = bw;
+		priv->dvbt2_tune_param.data_plp_id = (u16)c->stream_id;
+		ret = cxd2880_integ_dvbt2_tune(&priv->tnrdmd,
+						&priv->dvbt2_tune_param);
+	} else {
+		dev_err(&priv->spi->dev, "%s: invalid system\n", __func__);
+		mutex_unlock(priv->spi_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(priv->spi_mutex);
+	dev_info(&priv->spi->dev, "%s: tune result %d\n", __func__, ret);
+
+	return return_tbl[ret];
+}
+
+static int cxd2880_read_status(struct dvb_frontend *fe,
+				enum fe_status *status)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 sync = 0;
+	u8 lock = 0;
+	u8 unlock = 0;
+	struct cxd2880_priv *priv = NULL;
+	struct dtv_frontend_properties *c = NULL;
+
+	if ((!fe) || (!status)) {
+		pr_err("%s: invalid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+	c = &fe->dtv_property_cache;
+	*status = 0;
+
+	if (priv->tnrdmd.state == CXD2880_TNRDMD_STATE_ACTIVE) {
+		mutex_lock(priv->spi_mutex);
+		if (c->delivery_system == SYS_DVBT) {
+			ret = cxd2880_tnrdmd_dvbt_mon_sync_stat(
+							&priv->tnrdmd,
+							&sync,
+							&lock,
+							&unlock);
+		} else if (c->delivery_system == SYS_DVBT2) {
+			ret = cxd2880_tnrdmd_dvbt2_mon_sync_stat(
+							&priv->tnrdmd,
+							&sync,
+							&lock,
+							&unlock);
+		} else {
+			dev_err(&priv->spi->dev,
+				"%s: invlaid system", __func__);
+			mutex_unlock(priv->spi_mutex);
+			return -EINVAL;
+		}
+
+		mutex_unlock(priv->spi_mutex);
+		if (ret != CXD2880_RESULT_OK) {
+			dev_err(&priv->spi->dev, "%s: failed. sys = %d\n",
+				__func__, priv->tnrdmd.sys);
+			return  return_tbl[ret];
+		}
+
+		if (sync == 6) {
+			*status = FE_HAS_SIGNAL |
+					FE_HAS_CARRIER;
+		}
+		if (lock)
+			*status |= FE_HAS_VITERBI |
+					FE_HAS_SYNC |
+					FE_HAS_LOCK;
+	}
+
+	dev_dbg(&priv->spi->dev, "%s: status %d result %d\n", __func__,
+		*status, ret);
+
+	return  return_tbl[CXD2880_RESULT_OK];
+}
+
+static int cxd2880_tune(struct dvb_frontend *fe,
+			bool retune,
+			unsigned int mode_flags,
+			unsigned int *delay,
+			enum fe_status *status)
+{
+	int ret = 0;
+
+	if ((!fe) || (!delay) || (!status)) {
+		pr_err("%s: invalid arg.", __func__);
+		return -EINVAL;
+	}
+
+	if (retune) {
+		ret = cxd2880_set_frontend(fe);
+		if (ret) {
+			pr_err("%s: cxd2880_set_frontend failed %d\n",
+				__func__, ret);
+			return ret;
+		}
+	}
+
+	*delay = HZ / 5;
+
+	return cxd2880_read_status(fe, status);
+}
+
+static int cxd2880_get_frontend_t(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	int result = 0;
+	struct cxd2880_priv *priv = NULL;
+	enum cxd2880_dvbt_mode mode = CXD2880_DVBT_MODE_2K;
+	enum cxd2880_dvbt_guard guard = CXD2880_DVBT_GUARD_1_32;
+	struct cxd2880_dvbt_tpsinfo tps;
+	enum cxd2880_tnrdmd_spectrum_sense sense;
+	u16 snr = 0;
+	int strength = 0;
+	u32 pre_bit_err = 0, pre_bit_count = 0;
+	u32 post_bit_err = 0, post_bit_count = 0;
+	u32 block_err = 0, block_count = 0;
+
+	if ((!fe) || (!c)) {
+		pr_err("%s: invalid arg\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt_mon_mode_guard(&priv->tnrdmd,
+						 &mode, &guard);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (mode) {
+		case CXD2880_DVBT_MODE_2K:
+			c->transmission_mode = TRANSMISSION_MODE_2K;
+			break;
+		case CXD2880_DVBT_MODE_8K:
+			c->transmission_mode = TRANSMISSION_MODE_8K;
+			break;
+		default:
+			c->transmission_mode = TRANSMISSION_MODE_2K;
+			dev_err(&priv->spi->dev, "%s: get invalid mode %d\n",
+					__func__, mode);
+			break;
+		}
+		switch (guard) {
+		case CXD2880_DVBT_GUARD_1_32:
+			c->guard_interval = GUARD_INTERVAL_1_32;
+			break;
+		case CXD2880_DVBT_GUARD_1_16:
+			c->guard_interval = GUARD_INTERVAL_1_16;
+			break;
+		case CXD2880_DVBT_GUARD_1_8:
+			c->guard_interval = GUARD_INTERVAL_1_8;
+			break;
+		case CXD2880_DVBT_GUARD_1_4:
+			c->guard_interval = GUARD_INTERVAL_1_4;
+			break;
+		default:
+			c->guard_interval = GUARD_INTERVAL_1_32;
+			dev_err(&priv->spi->dev, "%s: get invalid guard %d\n",
+					__func__, guard);
+			break;
+		}
+	} else {
+		c->transmission_mode = TRANSMISSION_MODE_2K;
+		c->guard_interval = GUARD_INTERVAL_1_32;
+		dev_dbg(&priv->spi->dev,
+			"%s: ModeGuard err %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(&priv->tnrdmd, &tps);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (tps.hierarchy) {
+		case CXD2880_DVBT_HIERARCHY_NON:
+			c->hierarchy = HIERARCHY_NONE;
+			break;
+		case CXD2880_DVBT_HIERARCHY_1:
+			c->hierarchy = HIERARCHY_1;
+			break;
+		case CXD2880_DVBT_HIERARCHY_2:
+			c->hierarchy = HIERARCHY_2;
+			break;
+		case CXD2880_DVBT_HIERARCHY_4:
+			c->hierarchy = HIERARCHY_4;
+			break;
+		default:
+			c->hierarchy = HIERARCHY_NONE;
+			dev_err(&priv->spi->dev,
+				"%s: TPSInfo hierarchy invalid %d\n",
+				__func__, tps.hierarchy);
+			break;
+		}
+
+		switch (tps.rate_hp) {
+		case CXD2880_DVBT_CODERATE_1_2:
+			c->code_rate_HP = FEC_1_2;
+			break;
+		case CXD2880_DVBT_CODERATE_2_3:
+			c->code_rate_HP = FEC_2_3;
+			break;
+		case CXD2880_DVBT_CODERATE_3_4:
+			c->code_rate_HP = FEC_3_4;
+			break;
+		case CXD2880_DVBT_CODERATE_5_6:
+			c->code_rate_HP = FEC_5_6;
+			break;
+		case CXD2880_DVBT_CODERATE_7_8:
+			c->code_rate_HP = FEC_7_8;
+			break;
+		default:
+			c->code_rate_HP = FEC_NONE;
+			dev_err(&priv->spi->dev,
+				"%s: TPSInfo rateHP invalid %d\n",
+				__func__, tps.rate_hp);
+			break;
+		}
+		switch (tps.rate_lp) {
+		case CXD2880_DVBT_CODERATE_1_2:
+			c->code_rate_LP = FEC_1_2;
+			break;
+		case CXD2880_DVBT_CODERATE_2_3:
+			c->code_rate_LP = FEC_2_3;
+			break;
+		case CXD2880_DVBT_CODERATE_3_4:
+			c->code_rate_LP = FEC_3_4;
+			break;
+		case CXD2880_DVBT_CODERATE_5_6:
+			c->code_rate_LP = FEC_5_6;
+			break;
+		case CXD2880_DVBT_CODERATE_7_8:
+			c->code_rate_LP = FEC_7_8;
+			break;
+		default:
+			c->code_rate_LP = FEC_NONE;
+			dev_err(&priv->spi->dev,
+				"%s: TPSInfo rateLP invalid %d\n",
+				__func__, tps.rate_lp);
+			break;
+		}
+		switch (tps.constellation) {
+		case CXD2880_DVBT_CONSTELLATION_QPSK:
+			c->modulation = QPSK;
+			break;
+		case CXD2880_DVBT_CONSTELLATION_16QAM:
+			c->modulation = QAM_16;
+			break;
+		case CXD2880_DVBT_CONSTELLATION_64QAM:
+			c->modulation = QAM_64;
+			break;
+		default:
+			c->modulation = QPSK;
+			dev_err(&priv->spi->dev,
+				"%s: TPSInfo constellation invalid %d\n",
+				__func__, tps.constellation);
+			break;
+		}
+	} else {
+		c->hierarchy = HIERARCHY_NONE;
+		c->code_rate_HP = FEC_NONE;
+		c->code_rate_LP = FEC_NONE;
+		c->modulation = QPSK;
+		dev_dbg(&priv->spi->dev,
+			"%s: TPS info err %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt_mon_spectrum_sense(&priv->tnrdmd, &sense);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (sense) {
+		case CXD2880_TNRDMD_SPECTRUM_NORMAL:
+			c->inversion = INVERSION_OFF;
+			break;
+		case CXD2880_TNRDMD_SPECTRUM_INV:
+			c->inversion = INVERSION_ON;
+			break;
+		default:
+			c->inversion = INVERSION_OFF;
+			dev_err(&priv->spi->dev,
+				"%s: spectrum sense invalid %d\n",
+				__func__, sense);
+			break;
+		}
+	} else {
+		c->inversion = INVERSION_OFF;
+		dev_dbg(&priv->spi->dev,
+			"%s: spectrum_sense %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_mon_rf_lvl(&priv->tnrdmd, &strength);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = strength;
+	} else {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev, "%s: mon_rf_lvl %d\n",
+			__func__, result);
+	}
+
+	result = cxd2880_read_snr(fe, &snr);
+	if (!result) {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = snr;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev, "%s: read_snr %d\n", __func__, result);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_pre_bit_err_t(&priv->tnrdmd, &pre_bit_err,
+					&pre_bit_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->pre_bit_error.len = 1;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_error.stat[0].uvalue = pre_bit_err;
+		c->pre_bit_count.len = 1;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_count.stat[0].uvalue = pre_bit_count;
+	} else {
+		c->pre_bit_error.len = 1;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.len = 1;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: pre_bit_error_t failed %d\n",
+			__func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_post_bit_err_t(&priv->tnrdmd,
+				&post_bit_err, &post_bit_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = post_bit_err;
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = post_bit_count;
+	} else {
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: post_bit_err_t %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_read_block_err_t(&priv->tnrdmd,
+					&block_err, &block_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = block_err;
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue = block_count;
+	} else {
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: read_block_err_t  %d\n", __func__, ret);
+	}
+
+	return 0;
+}
+
+static int cxd2880_get_frontend_t2(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *c)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	int result = 0;
+	struct cxd2880_priv *priv = NULL;
+	struct cxd2880_dvbt2_l1pre l1pre;
+	enum cxd2880_dvbt2_plp_code_rate coderate;
+	enum cxd2880_dvbt2_plp_constell qam;
+	enum cxd2880_tnrdmd_spectrum_sense sense;
+	u16 snr = 0;
+	int strength = 0;
+	u32 pre_bit_err = 0, pre_bit_count = 0;
+	u32 post_bit_err = 0, post_bit_count = 0;
+	u32 block_err = 0, block_count = 0;
+
+	if ((!fe) || (!c)) {
+		pr_err("%s: invalid arg.\n", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt2_mon_l1_pre(&priv->tnrdmd, &l1pre);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (l1pre.fft_mode) {
+		case CXD2880_DVBT2_M2K:
+			c->transmission_mode = TRANSMISSION_MODE_2K;
+			break;
+		case CXD2880_DVBT2_M8K:
+			c->transmission_mode = TRANSMISSION_MODE_8K;
+			break;
+		case CXD2880_DVBT2_M4K:
+			c->transmission_mode = TRANSMISSION_MODE_4K;
+			break;
+		case CXD2880_DVBT2_M1K:
+			c->transmission_mode = TRANSMISSION_MODE_1K;
+			break;
+		case CXD2880_DVBT2_M16K:
+			c->transmission_mode = TRANSMISSION_MODE_16K;
+			break;
+		case CXD2880_DVBT2_M32K:
+			c->transmission_mode = TRANSMISSION_MODE_32K;
+			break;
+		default:
+			c->transmission_mode = TRANSMISSION_MODE_2K;
+			dev_err(&priv->spi->dev,
+				"%s: L1Pre fft_mode invalid %d\n",
+				__func__, l1pre.fft_mode);
+			break;
+		}
+		switch (l1pre.gi) {
+		case CXD2880_DVBT2_G1_32:
+			c->guard_interval = GUARD_INTERVAL_1_32;
+			break;
+		case CXD2880_DVBT2_G1_16:
+			c->guard_interval = GUARD_INTERVAL_1_16;
+			break;
+		case CXD2880_DVBT2_G1_8:
+			c->guard_interval = GUARD_INTERVAL_1_8;
+			break;
+		case CXD2880_DVBT2_G1_4:
+			c->guard_interval = GUARD_INTERVAL_1_4;
+			break;
+		case CXD2880_DVBT2_G1_128:
+			c->guard_interval = GUARD_INTERVAL_1_128;
+			break;
+		case CXD2880_DVBT2_G19_128:
+			c->guard_interval = GUARD_INTERVAL_19_128;
+			break;
+		case CXD2880_DVBT2_G19_256:
+			c->guard_interval = GUARD_INTERVAL_19_256;
+			break;
+		default:
+			c->guard_interval = GUARD_INTERVAL_1_32;
+			dev_err(&priv->spi->dev,
+				"%s: L1Pre gi invalid %d\n",
+				__func__, l1pre.gi);
+			break;
+		}
+	} else {
+		c->transmission_mode = TRANSMISSION_MODE_2K;
+		c->guard_interval = GUARD_INTERVAL_1_32;
+		dev_dbg(&priv->spi->dev,
+			"%s: L1Pre err %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt2_mon_code_rate(&priv->tnrdmd,
+						CXD2880_DVBT2_PLP_DATA,
+						&coderate);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (coderate) {
+		case CXD2880_DVBT2_R1_2:
+			c->fec_inner = FEC_1_2;
+			break;
+		case CXD2880_DVBT2_R3_5:
+			c->fec_inner = FEC_3_5;
+			break;
+		case CXD2880_DVBT2_R2_3:
+			c->fec_inner = FEC_2_3;
+			break;
+		case CXD2880_DVBT2_R3_4:
+			c->fec_inner = FEC_3_4;
+			break;
+		case CXD2880_DVBT2_R4_5:
+			c->fec_inner = FEC_4_5;
+			break;
+		case CXD2880_DVBT2_R5_6:
+			c->fec_inner = FEC_5_6;
+			break;
+		default:
+			c->fec_inner = FEC_NONE;
+			dev_err(&priv->spi->dev,
+				"%s: CodeRate invalid %d\n",
+				__func__, coderate);
+			break;
+		}
+	} else {
+		c->fec_inner = FEC_NONE;
+		dev_dbg(&priv->spi->dev, "%s: CodeRate %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt2_mon_qam(&priv->tnrdmd,
+					CXD2880_DVBT2_PLP_DATA,
+					&qam);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (qam) {
+		case CXD2880_DVBT2_QPSK:
+			c->modulation = QPSK;
+			break;
+		case CXD2880_DVBT2_QAM16:
+			c->modulation = QAM_16;
+			break;
+		case CXD2880_DVBT2_QAM64:
+			c->modulation = QAM_64;
+			break;
+		case CXD2880_DVBT2_QAM256:
+			c->modulation = QAM_256;
+			break;
+		default:
+			c->modulation = QPSK;
+			dev_err(&priv->spi->dev,
+				"%s: QAM invalid %d\n",
+				__func__, qam);
+			break;
+		}
+	} else {
+		c->modulation = QPSK;
+		dev_dbg(&priv->spi->dev, "%s: QAM %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(&priv->tnrdmd, &sense);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		switch (sense) {
+		case CXD2880_TNRDMD_SPECTRUM_NORMAL:
+			c->inversion = INVERSION_OFF;
+			break;
+		case CXD2880_TNRDMD_SPECTRUM_INV:
+			c->inversion = INVERSION_ON;
+			break;
+		default:
+			c->inversion = INVERSION_OFF;
+			dev_err(&priv->spi->dev,
+				"%s: spectrum sense invalid %d\n",
+				__func__, sense);
+			break;
+		}
+	} else {
+		c->inversion = INVERSION_OFF;
+		dev_dbg(&priv->spi->dev,
+			"%s: SpectrumSense %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_tnrdmd_mon_rf_lvl(&priv->tnrdmd, &strength);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = strength;
+	} else {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: mon_rf_lvl %d\n", __func__, ret);
+	}
+
+	result = cxd2880_read_snr(fe, &snr);
+	if (!result) {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = snr;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev, "%s: read_snr %d\n", __func__, result);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_pre_bit_err_t2(&priv->tnrdmd,
+				&pre_bit_err,
+				&pre_bit_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->pre_bit_error.len = 1;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_error.stat[0].uvalue = pre_bit_err;
+		c->pre_bit_count.len = 1;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_count.stat[0].uvalue = pre_bit_count;
+	} else {
+		c->pre_bit_error.len = 1;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.len = 1;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: read_bit_err_t2 %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_post_bit_err_t2(&priv->tnrdmd,
+				&post_bit_err, &post_bit_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = post_bit_err;
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = post_bit_count;
+	} else {
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: post_bit_err_t2 %d\n", __func__, ret);
+	}
+
+	mutex_lock(priv->spi_mutex);
+	ret = cxd2880_read_block_err_t2(&priv->tnrdmd,
+					&block_err, &block_count);
+	mutex_unlock(priv->spi_mutex);
+	if (ret == CXD2880_RESULT_OK) {
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = block_err;
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue = block_count;
+	} else {
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		dev_dbg(&priv->spi->dev,
+			"%s: read_block_err_t2 %d\n", __func__, ret);
+	}
+
+	return 0;
+}
+
+static int cxd2880_get_frontend(struct dvb_frontend *fe,
+				struct dtv_frontend_properties *props)
+{
+	struct cxd2880_priv *priv = NULL;
+	int result = 0;
+
+	if ((!fe) || (!props)) {
+		pr_err("%s: invalid arg.", __func__);
+		return -EINVAL;
+	}
+
+	priv = (struct cxd2880_priv *)fe->demodulator_priv;
+
+	dev_dbg(&priv->spi->dev, "%s: system=%d\n", __func__,
+		fe->dtv_property_cache.delivery_system);
+	switch (fe->dtv_property_cache.delivery_system) {
+	case SYS_DVBT:
+		result = cxd2880_get_frontend_t(fe, props);
+		break;
+	case SYS_DVBT2:
+		result = cxd2880_get_frontend_t2(fe, props);
+		break;
+	default:
+		result = -EINVAL;
+		break;
+	}
+
+	return result;
+}
+
+static enum dvbfe_algo cxd2880_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static struct dvb_frontend_ops cxd2880_dvbt_t2_ops;
+
+struct dvb_frontend *cxd2880_attach(struct dvb_frontend *fe,
+				struct cxd2880_config *cfg)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	enum cxd2880_tnrdmd_chip_id chipid =
+					CXD2880_TNRDMD_CHIP_ID_UNKNOWN;
+	static struct cxd2880_priv *priv;
+	u8 data = 0;
+
+	if (!fe) {
+		pr_err("%s: invalid arg.\n", __func__);
+		return NULL;
+	}
+
+	priv = kzalloc(sizeof(struct cxd2880_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->spi = cfg->spi;
+	priv->spi_mutex = cfg->spi_mutex;
+	priv->spi_device.spi = cfg->spi;
+
+	memcpy(&fe->ops, &cxd2880_dvbt_t2_ops,
+			sizeof(struct dvb_frontend_ops));
+
+	ret = cxd2880_spi_device_initialize(&priv->spi_device,
+						CXD2880_SPI_MODE_0,
+						55000000);
+	if (ret != CXD2880_RESULT_OK) {
+		dev_err(&priv->spi->dev,
+			"%s: spi_device_initialize failed. %d\n",
+			__func__, ret);
+		kfree(priv);
+		return NULL;
+	}
+
+	ret = cxd2880_spi_device_create_spi(&priv->cxd2880_spi,
+					&priv->spi_device);
+	if (ret != CXD2880_RESULT_OK) {
+		dev_err(&priv->spi->dev,
+			"%s: spi_device_create_spi failed. %d\n",
+			__func__, ret);
+		kfree(priv);
+		return NULL;
+	}
+
+	ret = cxd2880_io_spi_create(&priv->regio, &priv->cxd2880_spi, 0);
+	if (ret != CXD2880_RESULT_OK) {
+		dev_err(&priv->spi->dev,
+			"%s: io_spi_create failed. %d\n", __func__, ret);
+		kfree(priv);
+		return NULL;
+	}
+	if (priv->regio.write_reg(&priv->regio, CXD2880_IO_TGT_SYS, 0x00, 0x00)
+		!= CXD2880_RESULT_OK) {
+		dev_err(&priv->spi->dev,
+			"%s: set bank to 0x00 failed.\n", __func__);
+		kfree(priv);
+		return NULL;
+	}
+	if (priv->regio.read_regs(&priv->regio,
+					CXD2880_IO_TGT_SYS, 0xFD, &data, 1)
+					!= CXD2880_RESULT_OK) {
+		dev_err(&priv->spi->dev,
+			"%s: read chip id failed.\n", __func__);
+		kfree(priv);
+		return NULL;
+	}
+
+	chipid = (enum cxd2880_tnrdmd_chip_id)data;
+	if ((chipid != CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_0X) &&
+		(chipid != CXD2880_TNRDMD_CHIP_ID_CXD2880_ES1_11)) {
+		dev_err(&priv->spi->dev,
+			"%s: chip id invalid.\n", __func__);
+		kfree(priv);
+		return NULL;
+	}
+
+	fe->demodulator_priv = priv;
+	dev_info(&priv->spi->dev,
+		"CXD2880 driver version: Ver %s\n",
+		CXD2880_TNRDMD_DRIVER_VERSION);
+
+	return fe;
+}
+EXPORT_SYMBOL(cxd2880_attach);
+
+static struct dvb_frontend_ops cxd2880_dvbt_t2_ops = {
+	.info = {
+		.name = "Sony CXD2880",
+		.frequency_min =  174000000,
+		.frequency_max = 862000000,
+		.frequency_stepsize = 1000,
+		.caps = FE_CAN_INVERSION_AUTO |
+				FE_CAN_FEC_1_2 |
+				FE_CAN_FEC_2_3 |
+				FE_CAN_FEC_3_4 |
+				FE_CAN_FEC_4_5 |
+				FE_CAN_FEC_5_6	|
+				FE_CAN_FEC_7_8	|
+				FE_CAN_FEC_AUTO |
+				FE_CAN_QPSK |
+				FE_CAN_QAM_16 |
+				FE_CAN_QAM_32 |
+				FE_CAN_QAM_64 |
+				FE_CAN_QAM_128 |
+				FE_CAN_QAM_256 |
+				FE_CAN_QAM_AUTO |
+				FE_CAN_TRANSMISSION_MODE_AUTO |
+				FE_CAN_GUARD_INTERVAL_AUTO |
+				FE_CAN_2G_MODULATION |
+				FE_CAN_RECOVER |
+				FE_CAN_MUTE_TS,
+	},
+	.delsys = { SYS_DVBT, SYS_DVBT2 },
+
+	.release = cxd2880_release,
+	.init = cxd2880_init,
+	.sleep = cxd2880_sleep,
+	.tune = cxd2880_tune,
+	.set_frontend = cxd2880_set_frontend,
+	.get_frontend = cxd2880_get_frontend,
+	.read_status = cxd2880_read_status,
+	.read_ber = cxd2880_read_ber,
+	.read_signal_strength = cxd2880_read_signal_strength,
+	.read_snr = cxd2880_read_snr,
+	.read_ucblocks = cxd2880_read_ucblocks,
+	.get_frontend_algo = cxd2880_get_frontend_algo,
+};
+
+MODULE_DESCRIPTION(
+"Sony CXD2880 DVB-T2/T tuner + demodulator drvier");
+MODULE_AUTHOR("Sony Semiconductor Solutions Corporation");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5
