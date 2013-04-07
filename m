Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986Ab3DGQKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Apr 2013 12:10:41 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37GAfD7006761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 7 Apr 2013 12:10:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH 1/2] r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
Date: Sun,  7 Apr 2013 13:10:30 -0300
Message-Id: <1365351031-22079-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
References: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver was written from scratch, based on an existing driver
that it is part of rtl-sdr git tree, released under GPLv2:
	https://groups.google.com/forum/#!topic/ultra-cheap-sdr/Y3rBEOFtHug
	https://github.com/n1gp/gr-baz
	http://cgit.osmocom.org/rtl-sdr/plain/src/tuner_r820t.c
	(there are also other variants of it out there)

>From what I understood from the threads, the original driver was converted
to userspace from a Realtek tree. I couldn't find the original tree.
However, the original driver look awkward on my eyes. So, I decided to
write a new version from it from the scratch, while trying to reproduce
everything found there.

TODO:
- After locking, the original driver seems to have some routines to
  improve reception. This was not implemented here yet.
- RF Gain set/get is not implemented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/Kconfig  |    7 +
 drivers/media/tuners/Makefile |    1 +
 drivers/media/tuners/r820t.c  | 1486 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/r820t.h  |   55 ++
 4 files changed, 1549 insertions(+)
 create mode 100644 drivers/media/tuners/r820t.c
 create mode 100644 drivers/media/tuners/r820t.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index e8fdf71..d434903 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -241,4 +241,11 @@ config MEDIA_TUNER_TUA9001
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Infineon TUA 9001 silicon tuner driver.
+
+config MEDIA_TUNER_R820T
+	tristate "Rafael Micro R820T silicon tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Rafael Micro R820T silicon tuner driver.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 5e569b1..7ec48f2 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
 obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
+obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
new file mode 100644
index 0000000..7e02920
--- /dev/null
+++ b/drivers/media/tuners/r820t.c
@@ -0,0 +1,1486 @@
+/*
+ * Rafael Micro R820T driver
+ *
+ * Copyright (C) 2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This driver was written from scratch, based on an existing driver
+ * that it is part of rtl-sdr git tree, released under GPLv2:
+ *	https://groups.google.com/forum/#!topic/ultra-cheap-sdr/Y3rBEOFtHug
+ *	https://github.com/n1gp/gr-baz
+ *
+ * From what I understood from the threads, the original driver was converted
+ * to userspace from a Realtek tree. I couldn't find the original tree.
+ * However, the original driver look awkward on my eyes. So, I decided to
+ * write a new version from it from the scratch, while trying to reproduce
+ * everything found there.
+ *
+ * TODO:
+ *	After locking, the original driver seems to have some routines to
+ *		improve reception. This was not implemented here yet.
+ *
+ *	RF Gain set/get is not implemented.
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ */
+
+#include <linux/videodev2.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include "tuner-i2c.h"
+#include <asm/div64.h>
+#include "r820t.h"
+
+/*
+ * FIXME: I think that there are only 32 registers, but better safe than
+ *	  sorry. After finishing the driver, we may review it.
+ */
+#define REG_SHADOW_START	5
+#define NUM_REGS		27
+
+#define VER_NUM  49
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable verbose debug messages");
+
+/*
+ * enums and structures
+ */
+
+enum xtal_cap_value {
+	XTAL_LOW_CAP_30P = 0,
+	XTAL_LOW_CAP_20P,
+	XTAL_LOW_CAP_10P,
+	XTAL_LOW_CAP_0P,
+	XTAL_HIGH_CAP_0P
+};
+
+struct r820t_priv {
+	struct list_head		hybrid_tuner_instance_list;
+	const struct r820t_config	*cfg;
+	struct tuner_i2c_props		i2c_props;
+	struct mutex			lock;
+
+	u8				regs[NUM_REGS];
+	u8				buf[NUM_REGS + 1];
+	enum xtal_cap_value		xtal_cap_sel;
+	u16				pll;	/* kHz */
+	u32				int_freq;
+	u8				fil_cal_code;
+	bool				imr_done;
+
+	/* Store current mode */
+	u32				delsys;
+	enum v4l2_tuner_type		type;
+	v4l2_std_id			std;
+	u32				bw;	/* in MHz */
+
+	bool				has_lock;
+};
+
+struct r820t_freq_range {
+	u32	freq;
+	u8	open_d;
+	u8	rf_mux_ploy;
+	u8	tf_c;
+	u8	xtal_cap20p;
+	u8	xtal_cap10p;
+	u8	xtal_cap0p;
+	u8	imr_mem;		/* Not used, currently */
+};
+
+#define VCO_POWER_REF   0x02
+
+/*
+ * Static constants
+ */
+
+static LIST_HEAD(hybrid_tuner_instance_list);
+static DEFINE_MUTEX(r820t_list_mutex);
+
+/* Those initial values start from REG_SHADOW_START */
+static const u8 r820t_init_array[NUM_REGS] = {
+	0x83, 0x32, 0x75,			/* 05 to 07 */
+	0xc0, 0x40, 0xd6, 0x6c,			/* 08 to 0b */
+	0xf5, 0x63, 0x75, 0x68,			/* 0c to 0f */
+	0x6c, 0x83, 0x80, 0x00,			/* 10 to 13 */
+	0x0f, 0x00, 0xc0, 0x30,			/* 14 to 17 */
+	0x48, 0xcc, 0x60, 0x00,			/* 18 to 1b */
+	0x54, 0xae, 0x4a, 0xc0			/* 1c to 1f */
+};
+
+/* Tuner frequency ranges */
+static const struct r820t_freq_range freq_ranges[] = {
+	{
+		.freq = 0,
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0xdf,		/* R27[7:0]  band2,band0 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 50,		/* Start freq, in MHz */
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0xbe,		/* R27[7:0]  band4,band1  */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 55,		/* Start freq, in MHz */
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x8b,		/* R27[7:0]  band7,band4 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 60,		/* Start freq, in MHz */
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x7b,		/* R27[7:0]  band8,band4 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 65,		/* Start freq, in MHz */
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x69,		/* R27[7:0]  band9,band6 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 70,		/* Start freq, in MHz */
+		.open_d = 0x08,		/* low */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x58,		/* R27[7:0]  band10,band7 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 75,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x44,		/* R27[7:0]  band11,band11 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 80,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x44,		/* R27[7:0]  band11,band11 */
+		.xtal_cap20p = 0x02,	/* R16[1:0]  20pF (10)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 90,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x34,		/* R27[7:0]  band12,band11 */
+		.xtal_cap20p = 0x01,	/* R16[1:0]  10pF (01)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 100,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x34,		/* R27[7:0]  band12,band11 */
+		.xtal_cap20p = 0x01,	/* R16[1:0]  10pF (01)    */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 0,
+	}, {
+		.freq = 110,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x24,		/* R27[7:0]  band13,band11 */
+		.xtal_cap20p = 0x01,	/* R16[1:0]  10pF (01)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 1,
+	}, {
+		.freq = 120,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x24,		/* R27[7:0]  band13,band11 */
+		.xtal_cap20p = 0x01,	/* R16[1:0]  10pF (01)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 1,
+	}, {
+		.freq = 140,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x14,		/* R27[7:0]  band14,band11 */
+		.xtal_cap20p = 0x01,	/* R16[1:0]  10pF (01)   */
+		.xtal_cap10p = 0x01,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 1,
+	}, {
+		.freq = 180,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x13,		/* R27[7:0]  band14,band12 */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 1,
+	}, {
+		.freq = 220,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x13,		/* R27[7:0]  band14,band12 */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 2,
+	}, {
+		.freq = 250,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x11,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 2,
+	}, {
+		.freq = 280,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x02,	/* R26[7:6]=0 (LPF)  R26[1:0]=2 (low) */
+		.tf_c = 0x00,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 2,
+	}, {
+		.freq = 310,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x41,	/* R26[7:6]=1 (bypass)  R26[1:0]=1 (middle) */
+		.tf_c = 0x00,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 2,
+	}, {
+		.freq = 450,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x41,	/* R26[7:6]=1 (bypass)  R26[1:0]=1 (middle) */
+		.tf_c = 0x00,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 3,
+	}, {
+		.freq = 588,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x40,	/* R26[7:6]=1 (bypass)  R26[1:0]=0 (highest) */
+		.tf_c = 0x00,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 3,
+	}, {
+		.freq = 650,		/* Start freq, in MHz */
+		.open_d = 0x00,		/* high */
+		.rf_mux_ploy = 0x40,	/* R26[7:6]=1 (bypass)  R26[1:0]=0 (highest) */
+		.tf_c = 0x00,		/* R27[7:0]  highest,highest */
+		.xtal_cap20p = 0x00,	/* R16[1:0]  0pF (00)   */
+		.xtal_cap10p = 0x00,
+		.xtal_cap0p = 0x00,
+		.imr_mem = 4,
+	}
+};
+
+static int r820t_xtal_capacitor[][2] = {
+	{ 0x0b, XTAL_LOW_CAP_30P },
+	{ 0x02, XTAL_LOW_CAP_20P },
+	{ 0x01, XTAL_LOW_CAP_10P },
+	{ 0x00, XTAL_LOW_CAP_0P  },
+	{ 0x10, XTAL_HIGH_CAP_0P },
+};
+
+/*
+ * I2C read/write code and shadow registers logic
+ */
+static void shadow_store(struct r820t_priv *priv, u8 reg, const u8 *val,
+			 int len)
+{
+	int r = reg - REG_SHADOW_START;
+
+	if (r < 0) {
+		len += r;
+		r = 0;
+	}
+	if (len <= 0)
+		return;
+	if (len > NUM_REGS)
+		len = NUM_REGS;
+
+	tuner_dbg("%s: prev  reg=%02x len=%d: %*ph\n",
+		  __func__, r + REG_SHADOW_START, len, len, val);
+
+	memcpy(&priv->regs[r], val, len);
+}
+
+static int r820t_write(struct r820t_priv *priv, u8 reg, const u8 *val,
+		       int len)
+{
+	int rc, size, pos = 0;
+
+	/* Store the shadow registers */
+	shadow_store(priv, reg, val, len);
+
+	do {
+		if (len > priv->cfg->max_i2c_msg_len - 1)
+			size = priv->cfg->max_i2c_msg_len - 1;
+		else
+			size = len;
+
+		/* Fill I2C buffer */
+		priv->buf[0] = reg;
+		memcpy(&priv->buf[1], &val[pos], size);
+
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, priv->buf, size + 1);
+		if (rc != size + 1) {
+			tuner_info("%s: i2c wr failed=%d reg=%02x len=%d: %*ph\n",
+				   __func__, rc, reg, size, size, &priv->buf[1]);
+			if (rc < 0)
+				return rc;
+			return -EREMOTEIO;
+		}
+		tuner_dbg("%s: i2c wr reg=%02x len=%d: %*ph\n",
+			  __func__, reg, size, size, &priv->buf[1]);
+
+		reg += size;
+		len -= size;
+		pos += size;
+	} while (len > 0);
+
+	return 0;
+}
+
+static int r820t_write_reg(struct r820t_priv *priv, u8 reg, u8 val)
+{
+	return r820t_write(priv, reg, &val, 1);
+}
+
+static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
+				u8 bit_mask)
+{
+	int r = reg - REG_SHADOW_START;
+
+	if (r >= 0 && r < NUM_REGS)
+		val = (priv->regs[r] & ~bit_mask) | (val & bit_mask);
+	else
+		return -EINVAL;
+
+	return r820t_write(priv, reg, &val, 1);
+}
+
+static int r820_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
+{
+	int rc;
+	u8 *p = &priv->buf[1];
+
+	priv->buf[0] = reg;
+
+	rc = tuner_i2c_xfer_send_recv(&priv->i2c_props, priv->buf, 1, p, len);
+	if (rc != len) {
+		tuner_info("%s: i2c rd failed=%d reg=%02x len=%d: %*ph\n",
+			   __func__, rc, reg, len, len, p);
+		if (rc < 0)
+			return rc;
+		return -EREMOTEIO;
+	}
+	tuner_dbg("%s: i2c rd reg=%02x len=%d: %*ph\n",
+		  __func__, reg, len, len, p);
+
+	/* Copy data to the output buffer */
+	memcpy(val, p, len);
+
+	return 0;
+}
+
+/*
+ * r820t tuning logic
+ */
+
+static int r820t_set_mux(struct r820t_priv *priv, u32 freq)
+{
+	const struct r820t_freq_range *range;
+	int i, rc;
+	u8 val;
+
+	/* Get the proper frequency range */
+	freq = freq / 1000000;
+	for (i = 0; i < ARRAY_SIZE(freq_ranges) - 1; i++) {
+		if (freq < freq_ranges[i + 1].freq)
+			break;
+	}
+	range = &freq_ranges[i];
+
+	tuner_dbg("set r820t range#%d for frequency %d MHz\n", i, freq);
+
+	/* Open Drain */
+	rc = r820t_write_reg_mask(priv, 0x17, range->open_d, 0x08);
+	if (rc < 0)
+		return rc;
+
+	/* RF_MUX,Polymux */
+	rc = r820t_write_reg_mask(priv, 0x1a, range->rf_mux_ploy, 0xc3);
+	if (rc < 0)
+		return rc;
+
+	/* TF BAND */
+	rc = r820t_write_reg(priv, 0x1b, range->tf_c);
+	if (rc < 0)
+		return rc;
+
+	/* XTAL CAP & Drive */
+	switch (priv->xtal_cap_sel) {
+	case XTAL_LOW_CAP_30P:
+	case XTAL_LOW_CAP_20P:
+		val = range->xtal_cap20p | 0x08;
+		break;
+	case XTAL_LOW_CAP_10P:
+		val = range->xtal_cap10p | 0x08;
+		break;
+	case XTAL_HIGH_CAP_0P:
+		val = range->xtal_cap0p | 0x00;
+		break;
+	default:
+	case XTAL_LOW_CAP_0P:
+		val = range->xtal_cap0p | 0x08;
+		break;
+	}
+	rc = r820t_write_reg_mask(priv, 0x10, val, 0x0b);
+	if (rc < 0)
+		return rc;
+
+	/*
+	 * FIXME: the original driver has a logic there with preserves
+	 * gain/phase from registers 8 and 9 reading the data from the
+	 * registers before writing, if "IMF done". That code was sort of
+	 * commented there, as the flag is always false.
+	 */
+	rc = r820t_write_reg_mask(priv, 0x08, 0, 0x3f);
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_write_reg_mask(priv, 0x09, 0, 0x3f);
+
+	return rc;
+}
+
+static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
+{
+	u64 tmp64, vco_freq;
+	int rc, i;
+	u32 vco_fra;		/* VCO contribution by SDM (kHz) */
+	u32 vco_min  = 1770000;
+	u32 vco_max  = vco_min * 2;
+	u32 pll_ref;
+	u16 n_sdm = 2;
+	u16 sdm = 0;
+	u8 mix_div = 2;
+	u8 div_buf = 0;
+	u8 div_num = 0;
+	u8 ni, si, nint, vco_fine_tune, val;
+	u8 data[5];
+
+	freq = freq / 1000;	/* Frequency in kHz */
+
+	pll_ref = priv->cfg->xtal / 1000;
+
+	tuner_dbg("set r820t pll for frequency %d kHz = %d\n", freq, pll_ref);
+
+	/* FIXME: this seems to be a hack - probably it can be removed */
+	rc = r820t_write_reg_mask(priv, 0x10, 0x00, 0x00);
+	if (rc < 0)
+		return rc;
+
+	/* set pll autotune = 128kHz */
+	rc = r820t_write_reg_mask(priv, 0x1a, 0x00, 0x0c);
+	if (rc < 0)
+		return rc;
+
+	/* set VCO current = 100 */
+	rc = r820t_write_reg_mask(priv, 0x12, 0x80, 0xe0);
+	if (rc < 0)
+		return rc;
+
+	/* Calculate divider */
+	while (mix_div <= 64) {
+		if (((freq * mix_div) >= vco_min) &&
+		   ((freq * mix_div) < vco_max)) {
+			div_buf = mix_div;
+			while (div_buf > 2) {
+				div_buf = div_buf >> 1;
+				div_num++;
+			}
+			break;
+		}
+		mix_div = mix_div << 1;
+	}
+
+	rc = r820_read(priv, 0x00, data, sizeof(data));
+	if (rc < 0)
+		return rc;
+
+	vco_fine_tune = (data[4] & 0x30) >> 4;
+
+	if (vco_fine_tune > VCO_POWER_REF)
+		div_num = div_num - 1;
+	else if (vco_fine_tune < VCO_POWER_REF)
+		div_num = div_num + 1;
+
+	rc = r820t_write_reg_mask(priv, 0x10, div_num << 5, 0xe0);
+	if (rc < 0)
+		return rc;
+
+	vco_freq = (u64)(freq * (u64)mix_div);
+
+	tmp64 = vco_freq;
+	do_div(tmp64, 2 * pll_ref);
+	nint = (u8)tmp64;
+
+	tmp64 = vco_freq - ((u64)2) * pll_ref * nint;
+	do_div(tmp64, 1000);
+	vco_fra  = (u16)(tmp64);
+
+	pll_ref /= 1000;
+
+	/* boundary spur prevention */
+	if (vco_fra < pll_ref / 64) {
+		vco_fra = 0;
+	} else if (vco_fra > pll_ref * 127 / 64) {
+		vco_fra = 0;
+		nint++;
+	} else if ((vco_fra > pll_ref * 127 / 128) && (vco_fra < pll_ref)) {
+		vco_fra = pll_ref * 127 / 128;
+	} else if ((vco_fra > pll_ref) && (vco_fra < pll_ref * 129 / 128)) {
+		vco_fra = pll_ref * 129 / 128;
+	}
+
+	if (nint > 63) {
+		tuner_info("No valid PLL values for %u kHz!\n", freq);
+		return -EINVAL;
+	}
+
+	ni = (nint - 13) / 4;
+	si = nint - 4 * ni - 13;
+
+	rc = r820t_write_reg(priv, 0x14, ni + (si << 6));
+	if (rc < 0)
+		return rc;
+
+	/* pw_sdm */
+	if (!vco_fra)
+		val = 0x08;
+	else
+		val = 0x00;
+
+	rc = r820t_write_reg_mask(priv, 0x12, val, 0x08);
+	if (rc < 0)
+		return rc;
+
+	/* sdm calculator */
+	while (vco_fra > 1) {
+		if (vco_fra > (2 * pll_ref / n_sdm)) {
+			sdm = sdm + 32768 / (n_sdm / 2);
+			vco_fra = vco_fra - 2 * pll_ref / n_sdm;
+			if (n_sdm >= 0x8000)
+				break;
+		}
+		n_sdm = n_sdm << 1;
+	}
+
+	rc = r820t_write_reg_mask(priv, 0x16, sdm >> 8, 0x08);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg_mask(priv, 0x15, sdm & 0xff, 0x08);
+	if (rc < 0)
+		return rc;
+
+	for (i = 0; i < 2; i++) {
+		/*
+		 * FIXME: Rafael chips R620D, R828D and R828 seems to
+		 * need 20 ms for analog TV
+		 */
+		msleep(10);
+
+		/* Check if PLL has locked */
+		rc = r820_read(priv, 0x00, data, 3);
+		if (rc < 0)
+			return rc;
+		if (data[2] & 0x40)
+			break;
+
+		if (!i) {
+			/* Didn't lock. Increase VCO current */
+			rc = r820t_write_reg_mask(priv, 0x12, 0x60, 0xe0);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
+	if (!(data[2] & 0x40)) {
+		priv->has_lock = false;
+		return 0;
+	}
+
+	priv->has_lock = true;
+	tuner_dbg("tuner has lock at frequency %d kHz\n", freq);
+
+	/* set pll autotune = 8kHz */
+	rc = r820t_write_reg_mask(priv, 0x1a, 0x08, 0x08);
+
+	return rc;
+}
+
+static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
+			     enum v4l2_tuner_type type,
+			     v4l2_std_id std,
+			     u32 delsys)
+{
+	int rc;
+	u8 mixer_top, lna_top, cp_cur, div_buf_cur, lna_vth_l, mixer_vth_l;
+	u8 air_cable1_in, cable2_in, pre_dect, lna_discharge, filter_cur;
+
+	tuner_dbg("adjusting tuner parameters for the standard\n");
+
+	switch (delsys) {
+	case SYS_DVBT:
+		if ((freq == 506000000) || (freq == 666000000) ||
+		   (freq == 818000000)) {
+			mixer_top = 0x14;	/* mixer top:14 , top-1, low-discharge */
+			lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
+			cp_cur = 0x28;		/* 101, 0.2 */
+			div_buf_cur = 0x20;	/* 10, 200u */
+		} else {
+			mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
+			lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
+			cp_cur = 0x38;		/* 111, auto */
+			div_buf_cur = 0x30;	/* 11, 150u */
+		}
+		lna_vth_l = 0x53;		/* lna vth 0.84	,  vtl 0.64 */
+		mixer_vth_l = 0x75;		/* mixer vth 1.04, vtl 0.84 */
+		air_cable1_in = 0x00;
+		cable2_in = 0x00;
+		pre_dect = 0x40;
+		lna_discharge = 14;
+		filter_cur = 0x40;		/* 10, low */
+		break;
+	case SYS_DVBT2:
+		mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
+		lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
+		lna_vth_l = 0x53;	/* lna vth 0.84	,  vtl 0.64 */
+		mixer_vth_l = 0x75;	/* mixer vth 1.04, vtl 0.84 */
+		air_cable1_in = 0x00;
+		cable2_in = 0x00;
+		pre_dect = 0x40;
+		lna_discharge = 14;
+		cp_cur = 0x38;		/* 111, auto */
+		div_buf_cur = 0x30;	/* 11, 150u */
+		filter_cur = 0x40;	/* 10, low */
+		break;
+	case SYS_ISDBT:
+		mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
+		lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
+		lna_vth_l = 0x75;	/* lna vth 1.04	,  vtl 0.84 */
+		mixer_vth_l = 0x75;	/* mixer vth 1.04, vtl 0.84 */
+		air_cable1_in = 0x00;
+		cable2_in = 0x00;
+		pre_dect = 0x40;
+		lna_discharge = 14;
+		cp_cur = 0x38;		/* 111, auto */
+		div_buf_cur = 0x30;	/* 11, 150u */
+		filter_cur = 0x40;	/* 10, low */
+		break;
+	default: /* DVB-T 8M */
+		mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
+		lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
+		lna_vth_l = 0x53;	/* lna vth 0.84	,  vtl 0.64 */
+		mixer_vth_l = 0x75;	/* mixer vth 1.04, vtl 0.84 */
+		air_cable1_in = 0x00;
+		cable2_in = 0x00;
+		pre_dect = 0x40;
+		lna_discharge = 14;
+		cp_cur = 0x38;		/* 111, auto */
+		div_buf_cur = 0x30;	/* 11, 150u */
+		filter_cur = 0x40;	/* 10, low */
+		break;
+	}
+
+	rc = r820t_write_reg_mask(priv, 0x1d, lna_top, 0xc7);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg_mask(priv, 0x1c, mixer_top, 0xf8);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x0d, lna_vth_l);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x0e, mixer_vth_l);
+	if (rc < 0)
+		return rc;
+
+	/* Air-IN only for Astrometa */
+	rc = r820t_write_reg_mask(priv, 0x05, air_cable1_in, 0x60);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg_mask(priv, 0x06, cable2_in, 0x08);
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_write_reg_mask(priv, 0x11, cp_cur, 0x38);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg_mask(priv, 0x17, div_buf_cur, 0x30);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg_mask(priv, 0x0a, filter_cur, 0x60);
+	if (rc < 0)
+		return rc;
+	/*
+	 * Original driver initializes regs 0x05 and 0x06 with the
+	 * same value again on this point. Probably, it is just an
+	 * error there
+	 */
+
+	/*
+	 * Set LNA
+	 */
+
+	tuner_dbg("adjusting LNA parameters\n");
+	if (type != V4L2_TUNER_ANALOG_TV) {
+		/* LNA TOP: lowest */
+		rc = r820t_write_reg_mask(priv, 0x1d, 0, 0x38);
+		if (rc < 0)
+			return rc;
+
+		/* 0: normal mode */
+		rc = r820t_write_reg_mask(priv, 0x1c, 0, 0x04);
+		if (rc < 0)
+			return rc;
+
+		/* 0: PRE_DECT off */
+		rc = r820t_write_reg_mask(priv, 0x06, 0, 0x40);
+		if (rc < 0)
+			return rc;
+
+		/* agc clk 250hz */
+		rc = r820t_write_reg_mask(priv, 0x1a, 0x30, 0x30);
+		if (rc < 0)
+			return rc;
+
+		msleep(250);
+
+		/* write LNA TOP = 3 */
+		rc = r820t_write_reg_mask(priv, 0x1d, 0x18, 0x38);
+		if (rc < 0)
+			return rc;
+
+		/*
+		 * write discharge mode
+		 * FIXME: IMHO, the mask here is wrong, but it matches
+		 * what's there at the original driver
+		 */
+		rc = r820t_write_reg_mask(priv, 0x1c, mixer_top, 0x04);
+		if (rc < 0)
+			return rc;
+
+		/* LNA discharge current */
+		rc = r820t_write_reg_mask(priv, 0x1e, lna_discharge, 0x1f);
+		if (rc < 0)
+			return rc;
+
+		/* agc clk 60hz */
+		rc = r820t_write_reg_mask(priv, 0x1a, 0x20, 0x30);
+		if (rc < 0)
+			return rc;
+	} else {
+		/* PRE_DECT off */
+		rc = r820t_write_reg_mask(priv, 0x06, 0, 0x40);
+		if (rc < 0)
+			return rc;
+
+		/* write LNA TOP */
+		rc = r820t_write_reg_mask(priv, 0x1d, lna_top, 0x38);
+		if (rc < 0)
+			return rc;
+
+		/*
+		 * write discharge mode
+		 * FIXME: IMHO, the mask here is wrong, but it matches
+		 * what's there at the original driver
+		 */
+		rc = r820t_write_reg_mask(priv, 0x1c, mixer_top, 0x04);
+		if (rc < 0)
+			return rc;
+
+		/* LNA discharge current */
+		rc = r820t_write_reg_mask(priv, 0x1e, lna_discharge, 0x1f);
+		if (rc < 0)
+			return rc;
+
+		/* agc clk 1Khz, external det1 cap 1u */
+		rc = r820t_write_reg_mask(priv, 0x1a, 0x00, 0x30);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_write_reg_mask(priv, 0x10, 0x00, 0x04);
+		if (rc < 0)
+			return rc;
+	 }
+	 return 0;
+}
+
+static int r820t_set_tv_standard(struct r820t_priv *priv,
+				 unsigned bw,
+				 enum v4l2_tuner_type type,
+				 v4l2_std_id std, u32 delsys)
+
+{
+	int rc, i;
+	u32 if_khz, filt_cal_lo;
+	u8 data[5], val;
+	u8 filt_gain, img_r, filt_q, hp_cor, ext_enable, loop_through;
+	u8 lt_att, flt_ext_widest, polyfil_cur;
+	bool need_calibration;
+
+	tuner_dbg("selecting the delivery system\n");
+
+	if (delsys == SYS_ISDBT) {
+		if_khz = 4063;
+		filt_cal_lo = 59000;
+		filt_gain = 0x10;	/* +3db, 6mhz on */
+		img_r = 0x00;		/* image negative */
+		filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+		hp_cor = 0x6a;		/* 1.7m disable, +2cap, 1.25mhz */
+		ext_enable = 0x40;	/* r30[6], ext enable; r30[5]:0 ext at lna max */
+		loop_through = 0x00;	/* r5[7], lt on */
+		lt_att = 0x00;		/* r31[7], lt att enable */
+		flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+		polyfil_cur = 0x60;	/* r25[6:5]:min */
+	} else {
+		if (bw <= 6) {
+			if_khz = 3570;
+			filt_cal_lo = 56000;	/* 52000->56000 */
+			filt_gain = 0x10;	/* +3db, 6mhz on */
+			img_r = 0x00;		/* image negative */
+			filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+			hp_cor = 0x6b;		/* 1.7m disable, +2cap, 1.0mhz */
+			ext_enable = 0x60;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
+			loop_through = 0x00;	/* r5[7], lt on */
+			lt_att = 0x00;		/* r31[7], lt att enable */
+			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+			polyfil_cur = 0x60;	/* r25[6:5]:min */
+		} else if (bw == 7) {
+			if_khz = 4070;
+			filt_cal_lo = 60000;
+			filt_gain = 0x10;	/* +3db, 6mhz on */
+			img_r = 0x00;		/* image negative */
+			filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+			hp_cor = 0x2b;		/* 1.7m disable, +1cap, 1.0mhz */
+			ext_enable = 0x60;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
+			loop_through = 0x00;	/* r5[7], lt on */
+			lt_att = 0x00;		/* r31[7], lt att enable */
+			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+			polyfil_cur = 0x60;	/* r25[6:5]:min */
+#if 0 /* 7 MHz type 2 - nor sure why/where this is used - Perhaps Australia? */
+			if_khz = 4570;
+			filt_cal_lo = 63000;
+			filt_gain = 0x10;	/* +3db, 6mhz on */
+			img_r = 0x00;		/* image negative */
+			filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+			hp_cor = 0x2a;		/* 1.7m disable, +1cap, 1.25mhz */
+			ext_enable = 0x60;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
+			loop_through = 0x00;	/* r5[7], lt on */
+			lt_att = 0x00;		/* r31[7], lt att enable */
+			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+			polyfil_cur = 0x60;	/* r25[6:5]:min */
+#endif
+		} else {
+			if_khz = 4570;
+			filt_cal_lo = 68500;
+			filt_gain = 0x10;	/* +3db, 6mhz on */
+			img_r = 0x00;		/* image negative */
+			filt_q = 0x10;		/* r10[4]:low q(1'b1) */
+			hp_cor = 0x0b;		/* 1.7m disable, +0cap, 1.0mhz */
+			ext_enable = 0x60;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
+			loop_through = 0x00;	/* r5[7], lt on */
+			lt_att = 0x00;		/* r31[7], lt att enable */
+			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+			polyfil_cur = 0x60;	/* r25[6:5]:min */
+		}
+	}
+
+	/* Initialize the shadow registers */
+	memcpy(priv->regs, r820t_init_array, sizeof(r820t_init_array));
+
+	/* Init Flag & Xtal_check Result */
+	if (priv->imr_done)
+		val = 1 | priv->xtal_cap_sel << 1;
+	else
+		val = 0;
+	rc = r820t_write_reg_mask(priv, 0x0c, val, 0x0f);
+	if (rc < 0)
+		return rc;
+
+	/* version */
+	rc = r820t_write_reg_mask(priv, 0x13, VER_NUM, 0x3f);
+	if (rc < 0)
+		return rc;
+
+	/* for LT Gain test */
+	if (type != V4L2_TUNER_ANALOG_TV) {
+		rc = r820t_write_reg_mask(priv, 0x1d, 0x00, 0x38);
+		if (rc < 0)
+			return rc;
+		msleep(1);
+	}
+	priv->int_freq = if_khz;
+
+	/* Check if standard changed. If so, filter calibration is needed */
+	if (type != priv->type)
+		need_calibration = true;
+	else if ((type == V4L2_TUNER_ANALOG_TV) && (std != priv->std))
+		need_calibration = true;
+	else if ((type == V4L2_TUNER_DIGITAL_TV) &&
+		 ((delsys != priv->delsys) || bw != priv->bw))
+		need_calibration = true;
+	else
+		need_calibration = false;
+
+	if (need_calibration) {
+		tuner_dbg("calibrating the tuner\n");
+		for (i = 0; i < 2; i++) {
+			/* Set filt_cap */
+			rc = r820t_write_reg_mask(priv, 0x0b, hp_cor, 0x60);
+			if (rc < 0)
+				return rc;
+
+			/* set cali clk =on */
+			rc = r820t_write_reg_mask(priv, 0x0f, 0x04, 0x04);
+			if (rc < 0)
+				return rc;
+
+			/* X'tal cap 0pF for PLL */
+			rc = r820t_write_reg_mask(priv, 0x10, 0x00, 0x03);
+			if (rc < 0)
+				return rc;
+
+			rc = r820t_set_pll(priv, filt_cal_lo);
+			if (rc < 0 || !priv->has_lock)
+				return rc;
+
+			/* Start Trigger */
+			rc = r820t_write_reg_mask(priv, 0x0b, 0x10, 0x10);
+			if (rc < 0)
+				return rc;
+
+			msleep(1);
+
+			/* Stop Trigger */
+			rc = r820t_write_reg_mask(priv, 0x0b, 0x00, 0x10);
+			if (rc < 0)
+				return rc;
+
+			/* set cali clk =off */
+			rc = r820t_write_reg_mask(priv, 0x0f, 0x00, 0x04);
+			if (rc < 0)
+				return rc;
+
+			/* Check if calibration worked */
+			rc = r820_read(priv, 0x00, data, sizeof(data));
+			if (rc < 0)
+				return rc;
+
+			priv->fil_cal_code = data[4] & 0x0f;
+			if (priv->fil_cal_code && priv->fil_cal_code != 0x0f)
+				break;
+		}
+		/* narrowest */
+		if (priv->fil_cal_code == 0x0f)
+			priv->fil_cal_code = 0;
+	}
+
+	rc = r820t_write_reg_mask(priv, 0x0a,
+				  filt_q | priv->fil_cal_code, 0x1f);
+	if (rc < 0)
+		return rc;
+
+	/* Set BW, Filter_gain, & HP corner */
+	rc = r820t_write_reg_mask(priv, 0x0b, hp_cor, 0x10);
+	if (rc < 0)
+		return rc;
+
+
+	/* Set Img_R */
+	rc = r820t_write_reg_mask(priv, 0x07, img_r, 0x80);
+	if (rc < 0)
+		return rc;
+
+	/* Set filt_3dB, V6MHz */
+	rc = r820t_write_reg_mask(priv, 0x06, filt_gain, 0x30);
+	if (rc < 0)
+		return rc;
+
+	/* channel filter extension */
+	rc = r820t_write_reg_mask(priv, 0x1e, ext_enable, 0x60);
+	if (rc < 0)
+		return rc;
+
+	/* Loop through */
+	rc = r820t_write_reg_mask(priv, 0x05, loop_through, 0x80);
+	if (rc < 0)
+		return rc;
+
+	/* Loop through attenuation */
+	rc = r820t_write_reg_mask(priv, 0x1f, lt_att, 0x80);
+	if (rc < 0)
+		return rc;
+
+	/* filter extension widest */
+	rc = r820t_write_reg_mask(priv, 0x0f, flt_ext_widest, 0x80);
+	if (rc < 0)
+		return rc;
+
+	/* RF poly filter current */
+	rc = r820t_write_reg_mask(priv, 0x19, polyfil_cur, 0x60);
+	if (rc < 0)
+		return rc;
+
+	/* Store current standard. If it changes, re-calibrate the tuner */
+	priv->delsys = delsys;
+	priv->type = type;
+	priv->std = std;
+	priv->bw = bw;
+
+	return 0;
+}
+
+static int generic_set_freq(struct dvb_frontend *fe,
+			    u32 freq /* in HZ */,
+			    unsigned bw,
+			    enum v4l2_tuner_type type,
+			    v4l2_std_id std, u32 delsys)
+{
+	struct r820t_priv		*priv = fe->tuner_priv;
+	int				rc = -EINVAL;
+	u32				lo_freq;
+
+	tuner_dbg("should set frequency to %d kHz, bw %d MHz\n",
+		  freq / 1000, bw);
+
+	mutex_lock(&priv->lock);
+
+	if ((type == V4L2_TUNER_ANALOG_TV) && (std == V4L2_STD_SECAM_LC))
+		lo_freq = freq - priv->int_freq;
+	 else
+		lo_freq = freq + priv->int_freq;
+
+	rc = r820t_set_tv_standard(priv, bw, type, std, delsys);
+	if (rc < 0)
+		goto err;
+
+	rc = r820t_set_mux(priv, lo_freq);
+	if (rc < 0)
+		goto err;
+	rc = r820t_set_pll(priv, lo_freq);
+	if (rc < 0 || !priv->has_lock)
+		goto err;
+
+	rc = r820t_sysfreq_sel(priv, freq, type, std, delsys);
+err:
+	mutex_unlock(&priv->lock);
+
+	if (rc < 0)
+		tuner_dbg("%s: failed=%d\n", __func__, rc);
+	return rc;
+}
+
+/*
+ * r820t standby logic
+ */
+
+static int r820t_standby(struct r820t_priv *priv)
+{
+	int rc;
+
+	rc = r820t_write_reg(priv, 0x06, 0xb1);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x05, 0x03);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x07, 0x3a);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x08, 0x40);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x09, 0xc0);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x0a, 0x36);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x0c, 0x35);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x0f, 0x68);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x11, 0x03);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x17, 0xf4);
+	if (rc < 0)
+		return rc;
+	rc = r820t_write_reg(priv, 0x19, 0x0c);
+
+	/* Force initial calibration */
+	priv->type = -1;
+
+	return rc;
+}
+
+/*
+ * r820t device init logic
+ */
+
+static int r820t_xtal_check(struct r820t_priv *priv)
+{
+	int rc, i;
+	u8 data[3], val;
+
+	/* Initialize the shadow registers */
+	memcpy(priv->regs, r820t_init_array, sizeof(r820t_init_array));
+
+	/* cap 30pF & Drive Low */
+	rc = r820t_write_reg_mask(priv, 0x10, 0x0b, 0x0b);
+	if (rc < 0)
+		return rc;
+
+	/* set pll autotune = 128kHz */
+	rc = r820t_write_reg_mask(priv, 0x1a, 0x00, 0x0c);
+	if (rc < 0)
+		return rc;
+
+	/* set manual initial reg = 111111;  */
+	rc = r820t_write_reg_mask(priv, 0x13, 0x7f, 0x7f);
+	if (rc < 0)
+		return rc;
+
+	/* set auto */
+	rc = r820t_write_reg_mask(priv, 0x13, 0x00, 0x40);
+	if (rc < 0)
+		return rc;
+
+	/* Try several xtal capacitor alternatives */
+	for (i = 0; i < ARRAY_SIZE(r820t_xtal_capacitor); i++) {
+		rc = r820t_write_reg_mask(priv, 0x10,
+					  r820t_xtal_capacitor[i][0], 0x1b);
+		if (rc < 0)
+			return rc;
+
+		msleep(5);
+
+		rc = r820_read(priv, 0x00, data, sizeof(data));
+		if (rc < 0)
+			return rc;
+		if ((!data[2]) & 0x40)
+			continue;
+
+		val = data[2] & 0x3f;
+
+		if (priv->cfg->xtal == 16000000 && (val > 29 || val < 23))
+			break;
+
+		if (val != 0x3f)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(r820t_xtal_capacitor))
+		return -EINVAL;
+
+	return r820t_xtal_capacitor[i][1];
+}
+
+/*
+ *  r820t frontend operations and tuner attach code
+ */
+
+static int r820t_init(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	int rc, i;
+	int xtal_cap = 0;
+
+	tuner_dbg("%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	mutex_lock(&priv->lock);
+
+	if ((priv->cfg->rafael_chip == CHIP_R820T) ||
+	    (priv->cfg->rafael_chip == CHIP_R828S) ||
+	    (priv->cfg->rafael_chip == CHIP_R820C)) {
+		priv->xtal_cap_sel = XTAL_HIGH_CAP_0P;
+	} else {
+		for (i = 0; i < 3; i++) {
+			rc = r820t_xtal_check(priv);
+			if (rc < 0)
+				goto err;
+			if (!i || rc > xtal_cap)
+				xtal_cap = rc;
+		}
+		priv->xtal_cap_sel = xtal_cap;
+	}
+
+	/* Initialize registers */
+	rc = r820t_write(priv, 0x05,
+			 r820t_init_array, sizeof(r820t_init_array));
+
+	mutex_unlock(&priv->lock);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return rc;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	tuner_dbg("%s: failed=%d\n", __func__, rc);
+	return rc;
+}
+
+static int r820t_sleep(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	int rc;
+
+	tuner_dbg("%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	mutex_lock(&priv->lock);
+	rc = r820t_standby(priv);
+	mutex_unlock(&priv->lock);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	tuner_dbg("%s: failed=%d\n", __func__, rc);
+	return rc;
+}
+
+static int r820t_set_analog_freq(struct dvb_frontend *fe,
+				 struct analog_parameters *p)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	unsigned bw;
+
+	tuner_dbg("%s called\n", __func__);
+
+	/* if std is not defined, choose one */
+	if (!p->std)
+		p->std = V4L2_STD_MN;
+
+	if ((p->std == V4L2_STD_PAL_M) || (p->std == V4L2_STD_NTSC))
+		bw = 6;
+	else
+		bw = 8;
+
+	return generic_set_freq(fe, 62500l * p->frequency, bw,
+				V4L2_TUNER_ANALOG_TV, p->std, SYS_UNDEFINED);
+}
+
+static int r820t_set_params(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc;
+	unsigned bw;
+
+	tuner_dbg("%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
+		__func__, c->delivery_system, c->frequency, c->bandwidth_hz);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	bw = (c->bandwidth_hz + 500000) / 1000000;
+	if (!bw)
+		bw = 8;
+
+	rc = generic_set_freq(fe, c->frequency, bw,
+			      V4L2_TUNER_DIGITAL_TV, 0, c->delivery_system);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (rc)
+		tuner_dbg("%s: failed=%d\n", __func__, rc);
+	return rc;
+}
+
+static int r820t_signal(struct dvb_frontend *fe, u16 *strength)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+
+	if (priv->has_lock)
+		*strength = 0xffff;
+	else
+		*strength = 0;
+
+	return 0;
+}
+
+static int r820t_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+
+	tuner_dbg("%s:\n", __func__);
+
+	*frequency = priv->int_freq;
+
+	return 0;
+}
+
+static int r820t_release(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+
+	tuner_dbg("%s:\n", __func__);
+
+	mutex_lock(&r820t_list_mutex);
+
+	if (priv)
+		hybrid_tuner_release_state(priv);
+
+	mutex_unlock(&r820t_list_mutex);
+
+	fe->tuner_priv = NULL;
+
+	kfree(fe->tuner_priv);
+
+	return 0;
+}
+
+static const struct dvb_tuner_ops r820t_tuner_ops = {
+	.info = {
+		.name           = "Rafael Micro R820T",
+		.frequency_min  =   42000000,
+		.frequency_max  = 1002000000,
+	},
+	.init = r820t_init,
+	.release = r820t_release,
+	.sleep = r820t_sleep,
+	.set_params = r820t_set_params,
+	.set_analog_params = r820t_set_analog_freq,
+	.get_if_frequency = r820t_get_if_frequency,
+	.get_rf_strength = r820t_signal,
+};
+
+struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
+				  struct i2c_adapter *i2c,
+				  const struct r820t_config *cfg)
+{
+	struct r820t_priv *priv;
+	int rc = -ENODEV;
+	u8 data[5];
+	int instance;
+
+	mutex_lock(&r820t_list_mutex);
+
+	instance = hybrid_tuner_request_state(struct r820t_priv, priv,
+					      hybrid_tuner_instance_list,
+					      i2c, cfg->i2c_addr,
+					      "r820t");
+	switch (instance) {
+	case 0:
+		/* memory allocation failure */
+		goto err_no_gate;
+		break;
+	case 1:
+		/* new tuner instance */
+		priv->cfg = cfg;
+
+		mutex_init(&priv->lock);
+
+		fe->tuner_priv = priv;
+		break;
+	case 2:
+		/* existing tuner instance */
+		fe->tuner_priv = priv;
+		break;
+	}
+
+	memcpy(&fe->ops.tuner_ops, &r820t_tuner_ops, sizeof(r820t_tuner_ops));
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* check if the tuner is there */
+	rc = r820_read(priv, 0x00, data, sizeof(data));
+	if (rc < 0)
+		goto err;
+
+	rc = r820t_sleep(fe);
+	if (rc < 0)
+		goto err;
+
+	tuner_info("Rafael Micro r820t successfully identified\n");
+
+	fe->tuner_priv = priv;
+	memcpy(&fe->ops.tuner_ops, &r820t_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	mutex_unlock(&r820t_list_mutex);
+
+	return fe;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+err_no_gate:
+	mutex_unlock(&r820t_list_mutex);
+
+	tuner_info("%s: failed=%d\n", __func__, rc);
+	r820t_release(fe);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(r820t_attach);
+
+MODULE_DESCRIPTION("Rafael Micro r820t silicon tuner driver");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
new file mode 100644
index 0000000..a64a7b6
--- /dev/null
+++ b/drivers/media/tuners/r820t.h
@@ -0,0 +1,55 @@
+/*
+ * Elonics R820T silicon tuner driver
+ *
+ * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef R820T_H
+#define R820T_H
+
+#include <linux/kconfig.h>
+#include "dvb_frontend.h"
+
+enum r820t_chip {
+	CHIP_R820T,
+	CHIP_R828S,
+	CHIP_R820C,
+};
+
+struct r820t_config {
+	u8 i2c_addr;		/* 0x34 */
+
+	u32 xtal;
+	enum r820t_chip rafael_chip;
+	unsigned max_i2c_msg_len;
+};
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
+struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
+				  struct i2c_adapter *i2c,
+				  const struct r820t_config *cfg);
+#else
+static inline struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
+						struct i2c_adapter *i2c,
+						const struct r820t_config *cfg)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
-- 
1.8.1.4

