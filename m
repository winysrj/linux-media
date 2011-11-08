Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55605 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab1KHXyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 18:54:36 -0500
Message-ID: <4EB9C13A.2060707@iki.fi>
Date: Wed, 09 Nov 2011 01:54:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: [RFC 1/2] dvb-core: add generic helper function for I2C register
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function that splits and sends most typical I2C register write.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/dvb/dvb-core/Makefile      |    2 +-
  drivers/media/dvb/dvb-core/dvb_generic.c |   48 
++++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-core/dvb_generic.h |   21 +++++++++++++
  3 files changed, 70 insertions(+), 1 deletions(-)
  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.c
  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.h

diff --git a/drivers/media/dvb/dvb-core/Makefile 
b/drivers/media/dvb/dvb-core/Makefile
index 8f22bcd..230584a 100644
--- a/drivers/media/dvb/dvb-core/Makefile
+++ b/drivers/media/dvb/dvb-core/Makefile
@@ -6,6 +6,6 @@ dvb-net-$(CONFIG_DVB_NET) := dvb_net.o

  dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
  		 dvb_ca_en50221.o dvb_frontend.o 		\
-		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
+		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o dvb_generic.o

  obj-$(CONFIG_DVB_CORE) += dvb-core.o
diff --git a/drivers/media/dvb/dvb-core/dvb_generic.c 
b/drivers/media/dvb/dvb-core/dvb_generic.c
new file mode 100644
index 0000000..002bd24
--- /dev/null
+++ b/drivers/media/dvb/dvb-core/dvb_generic.c
@@ -0,0 +1,48 @@
+#include <linux/i2c.h>
+#include "dvb_generic.h"
+
+/* write multiple registers */
+int dvb_wr_regs(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 *val, int len_tot)
+{
+#define REG_ADDR_LEN 1
+#define REG_VAL_LEN 1
+	int ret, len_cur, len_rem, len_max;
+	u8 buf[i2c_cfg->max_wr];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = i2c_cfg->addr,
+			.flags = 0,
+			.buf = buf,
+		}
+	};
+
+	len_max = i2c_cfg->max_wr - REG_ADDR_LEN;
+	for (len_rem = len_tot; len_rem > 0; len_rem -= len_max) {
+		len_cur = len_rem;
+		if (len_cur > len_max)
+			len_cur = len_max;
+
+		msg[0].len = len_cur + REG_ADDR_LEN;
+		buf[0] = reg;
+		memcpy(&buf[REG_ADDR_LEN], &val[len_tot - len_rem], len_cur);
+
+		ret = i2c_transfer(i2c_cfg->adapter, msg, 1);
+		if (ret != 1) {
+			warn("i2c wr failed=%d reg=%02x len=%d",
+				ret, reg, len_cur);
+			return -EREMOTEIO;
+		}
+		reg += len_cur;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dvb_wr_regs);
+
+/* write single register */
+int dvb_wr_reg(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 val)
+{
+	return dvb_wr_regs(i2c_cfg, reg, &val, 1);
+}
+EXPORT_SYMBOL(dvb_wr_reg);
+
diff --git a/drivers/media/dvb/dvb-core/dvb_generic.h 
b/drivers/media/dvb/dvb-core/dvb_generic.h
new file mode 100644
index 0000000..7a140ab
--- /dev/null
+++ b/drivers/media/dvb/dvb-core/dvb_generic.h
@@ -0,0 +1,21 @@
+#ifndef DVB_GENERIC_H
+#define DVB_GENERIC_H
+
+#define DVB_GENERIC_LOG_PREFIX "dvb_generic"
+#define warn(f, arg...) \
+	printk(KERN_WARNING DVB_GENERIC_LOG_PREFIX": " f "\n", ## arg)
+
+struct dvb_i2c_cfg {
+	struct i2c_adapter *adapter;
+	u8 addr;
+	/* TODO: reg_addr_len; as now use one byte */
+	/* TODO: reg_val_len; as now use one byte */
+	u8 max_wr;
+	u8 max_rd;
+};
+
+extern int dvb_wr_regs(struct dvb_i2c_cfg *, u8, u8 *, int);
+extern int dvb_wr_reg(struct dvb_i2c_cfg *, u8, u8);
+
+#endif
+
-- 
1.7.4.4
