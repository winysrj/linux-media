Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34940 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbcCaTml (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 15:42:41 -0400
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
	<knightrider@are.ma>, linux-kernel@vger.kernel.org, crope@iki.fi,
	m.chehab@samsung.com, mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 2/8] NXP tda2014x & Newport Media nm120/130/131 tuner (PXQ3PE)
Date: Fri,  1 Apr 2016 04:42:26 +0900
Message-Id: <6e54cfbb9d78d3bb480c00d1e44ca5aae37fd1c5.1459450632.git.knightrider@are.ma>
In-Reply-To: <cover.1459450632.git.knightrider@are.ma>
References: <cover.1459450632.git.knightrider@are.ma>
In-Reply-To: <cover.1459450632.git.knightrider@are.ma>
References: <cover.1459450632.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

NXP tda2014x & Newport Media nm120/130/131 tuner drivers for PLEX PX-Q3PE

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/tuners/Kconfig    |  21 ++-
 drivers/media/tuners/Makefile   |   4 +-
 drivers/media/tuners/nm131.c    | 248 +++++++++++++++++++++++++++++
 drivers/media/tuners/nm131.h    |  13 ++
 drivers/media/tuners/tda2014x.c | 342 ++++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/tda2014x.h |  13 ++
 6 files changed, 637 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/tuners/nm131.c
 create mode 100644 drivers/media/tuners/nm131.h
 create mode 100644 drivers/media/tuners/tda2014x.c
 create mode 100644 drivers/media/tuners/tda2014x.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 05998f0..a7f044b 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -271,10 +271,25 @@ config MEDIA_TUNER_MXL301RF
 	help
 	  MaxLinear MxL301RF OFDM tuner driver.
 
-config MEDIA_TUNER_QM1D1C0042
-	tristate "Sharp QM1D1C0042 tuner"
+config MEDIA_TUNER_QM1D1C004X
+	tristate "Sharp QM1D1C004x tuner"
 	depends on MEDIA_SUPPORT && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
-	  Sharp QM1D1C0042 trellis coded 8PSK tuner driver.
+	  Sharp trellis coded 8PSK tuner driver.
+	  Supported chips: QM1D1C0042, QM1D1C0045
+
+config MEDIA_TUNER_NM131
+	tristate "Newport Media tuners NM131, NM130 and NM120"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Newport Media NM131, NM130 and NM120 tuner driver.
+
+config MEDIA_TUNER_TDA2014X
+	tristate "NXP Semiconductors TDA2014x tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  NXP Semiconductor TDA2014x tuner driver.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 06a9ab6..6a2b52a 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -39,8 +39,10 @@ obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 obj-$(CONFIG_MEDIA_TUNER_IT913X) += it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
 obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
-obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1C004X) += qm1d1c004x.o
 obj-$(CONFIG_MEDIA_TUNER_M88RS6000T) += m88rs6000t.o
+obj-$(CONFIG_MEDIA_TUNER_NM131) += nm131.o
+obj-$(CONFIG_MEDIA_TUNER_TDA2014X) += tda2014x.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/nm131.c b/drivers/media/tuners/nm131.c
new file mode 100644
index 0000000..817cf96
--- /dev/null
+++ b/drivers/media/tuners/nm131.c
@@ -0,0 +1,248 @@
+/*
+	Driver for Newport Media tuners NMI131, NMI130 and NMI120
+
+	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+*/
+
+#include "dvb_frontend.h"
+#include "nm131.h"
+
+bool nm131_w(struct dvb_frontend *fe, u16 slvadr, u32 val, u32 sz)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u8		buf[]	= {0xFE, 0xCE, slvadr >> 8, slvadr & 0xFF, 0, 0, 0, 0};
+	struct i2c_msg	msg[]	= {
+		{.addr = d->addr,	.flags = 0,	.buf = buf,	.len = sz + 4,},
+	};
+
+	*(u32 *)(buf + 4) = slvadr == 0x36 ? val & 0x7F : val;
+	return i2c_transfer(d->adapter, msg, 1) == 1;
+}
+
+bool nm131_w8(struct dvb_frontend *fe, u8 slvadr, u8 dat)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u8		buf[]	= {slvadr, dat};
+	struct i2c_msg	msg[]	= {
+		{.addr = d->addr,	.flags = 0,	.buf = buf,	.len = 2,},
+	};
+	return i2c_transfer(d->adapter, msg, 1) == 1;
+}
+
+bool nm131_r(struct dvb_frontend *fe, u16 slvadr, u8 *dat, u32 sz)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u8		rcmd[]	= {0xFE, 0xCF},
+			buf[sz];
+	struct i2c_msg	msg[]	= {
+		{.addr = d->addr,	.flags = 0,		.buf = rcmd,	.len = 2,},
+		{.addr = d->addr,	.flags = I2C_M_RD,	.buf = buf,	.len = sz,},
+	};
+	bool	ret = nm131_w(fe, slvadr, 0, 0) && i2c_transfer(d->adapter, msg, 2) == 2;
+
+	memcpy(dat, buf, sz);
+	return ret;
+}
+
+int nm131_tune(struct dvb_frontend *fe)
+{
+	struct vhf_filter_cutoff_codes_t {
+		u32	Hz;
+		u8	val8_0x08,
+			val8_0x09;
+	} const vhf_filter_cutoff_codes[] = {
+		{45000000, 167, 58},	{55000000, 151, 57},	{65000000, 100, 54},	{75000000, 83, 53},	{85000000, 82, 53},
+		{95000000, 65, 52},	{105000000, 64, 52},	{115000000, 64, 52},	{125000000, 0, 0}
+	};
+	const u8	v45[]		= {0, 1, 2, 3, 4, 6, 9, 12},
+			ACI_audio_lut	= 0,
+			aci_lut		= 1;
+	const u32	lo_freq_lut[]	= {0, 0, 434000000, 237000000, 214000000, 118000000, 79000000, 53000000},
+			*v11,
+			adec_ddfs_fq	= 126217,
+			ddfs_lut	= 0;
+	u8		rf_reg_0x05	= 0x87,
+			v15,
+			val;
+	int		i;
+	u32		tune_rf		= fe->dtv_property_cache.frequency,
+			clk_off_f	= tune_rf,
+			xo		= 24000,
+			lofreq,
+			rf,
+			v14,
+			v32;
+	bool		done		= false;
+
+	if (!(nm131_w8(fe, 1, 0x50)		&&
+		nm131_w8(fe, 0x47, 0x30)	&&
+		nm131_w8(fe, 0x25, 0)		&&
+		nm131_w8(fe, 0x20, 0)		&&
+		nm131_w8(fe, 0x23, 0x4D)))
+		return -EIO;
+	while (1) {
+		rf = clk_off_f;
+		val = rf > 120400000 ? 0x85 : 5;
+		if (rf_reg_0x05 != val) {
+			nm131_w(fe, 0x05, val, 1);
+			rf_reg_0x05 = val;
+		}
+		lofreq = rf;
+		v11 = &lo_freq_lut[6];
+		val = 6;
+		if (lofreq > 53000000) {
+			do {
+				if (*v11 >= lofreq)
+					break;
+				--val;
+				--v11;
+			} while (val != 1);
+		} else
+			val = 7;
+		i = 0;
+		do {
+			if (lofreq > vhf_filter_cutoff_codes[i].Hz && lofreq <= vhf_filter_cutoff_codes[i + 1].Hz)
+				break;
+			++i;
+		} while (i != 8);
+		nm131_w(fe, 8, vhf_filter_cutoff_codes[i].val8_0x08, 1);
+		nm131_w(fe, 9, vhf_filter_cutoff_codes[i].val8_0x09, 1);
+		v14 = lofreq / 1000 * 8 * v45[val];
+		nm131_r(fe, 0x21, &v15, 1);
+		v15 &= 3;
+		xo = v15 == 2 ? xo * 2 : v15 == 3 ? xo >> 1 : xo;
+		v32 = v14 / xo;
+		if (!((v14 % xo * (0x80000000 / xo) >> 12) & 0x7FFFF) || done)
+			break;
+		clk_off_f += 1000;
+		done = true;
+	}
+	xo = (v14 % xo * (0x80000000 / xo) >> 12) & 0x7FFFF;
+	clk_off_f = v14;
+	v14 /= 216000;
+	if (v14 > 31)
+		v14 = 31;
+	if (v14 < 16)
+		v14 = 16;
+	nm131_w(fe, 1, (u16)v32 >> 1, 1);
+	nm131_w(fe, 2, (v32 & 1) | 2 * xo, 1);
+	nm131_w(fe, 3, xo >> 7, 1);
+	nm131_w(fe, 4, (xo >> 15) | 16 * v14, 1);
+	nm131_r(fe, 0x1D, &v15, 1);
+	nm131_w(fe, 0x1D, 32 * val | (v15 & 0x1F), 1);
+	if (lofreq < 300000000) {
+		nm131_w(fe, 0x25, 0x78, 1);
+		nm131_w(fe, 0x27, 0x7F, 1);
+		nm131_w(fe, 0x29, 0x7F, 1);
+		nm131_w(fe, 0x2E, 0x12, 1);
+	} else {
+		nm131_w(fe, 0x25, 0xF4, 1);
+		nm131_w(fe, 0x27, 0xEF, 1);
+		nm131_w(fe, 0x29, 0x4F, 1);
+		nm131_w(fe, 0x2E, 0x34, 1);
+	}
+	nm131_w(fe, 0x36, lofreq < 150000000 ? 0x54 : 0x7C, 1);
+	nm131_w(fe, 0x37, lofreq < 155000000 ? 0x84 : lofreq < 300000000 ? 0x9C : 0x84, 1);
+	clk_off_f = (clk_off_f << 9) / v14 - 110592000;
+
+	nm131_w(fe, 0x164, tune_rf < 300000000 ? 0x600 : 0x500, 4);
+	rf = clk_off_f / 6750 + 16384;
+	nm131_w(fe, 0x230, (adec_ddfs_fq << 15) / rf | 0x80000, 4);
+	nm131_w(fe, 0x250, ACI_audio_lut, 4);
+	nm131_w(fe, 0x27C, 0x1010, 4);
+	nm131_w(fe, 0x1BC, (ddfs_lut << 14) / rf, 4);
+	nm131_r(fe, 0x21C, (u8 *)(&v32), 4);
+	nm131_w(fe, 0x21C, (((v32 & 0xFFC00000) | 524288000 / ((clk_off_f >> 14) + 6750)) & 0xC7BFFFFE) | 0x8000000, 4);
+	nm131_r(fe, 0x234, (u8 *)(&v32), 4);
+	nm131_w(fe, 0x234, v32 & 0xCFC00000, 4);
+	nm131_w(fe, 0x210, ((864 * (clk_off_f >> 5) - 1308983296) / 216000 & 0xFFFFFFF0) | 3, 4);
+	nm131_r(fe, 0x104, (u8 *)(&v32), 4);
+	v32 = ((((clk_off_f > 3686396 ? 2 : clk_off_f >= 1843193 ? 1 : 0) << 16) | (((((((v32 & 0x87FFFFC0) | 0x10000011)
+		& 0xFFFF87FF) | (aci_lut << 11)) & 0xFFFF7FFF) | 0x8000) & 0xFFF0FFFF)) & 0xFC0FFFFF) | 0xA00000;
+	nm131_w(fe, 0x104, v32, 4);
+	v32 = (v32 & 0xFFFFFFEF) | 0x20000020;
+	nm131_w(fe, 0x104, v32, 4);
+	nm131_r(fe, 0x328, (u8 *)(&v14), 4);
+	if (v14) {
+		v32 &= 0xFFFFFFDF;
+		nm131_w(fe, 0x104, v32, 4);
+		nm131_w(fe, 0x104, v32 | 0x20, 4);
+	}
+	return	nm131_w8(fe, 0x23, 0x4C)	&&
+		nm131_w8(fe, 1, 0x50)		&&
+		nm131_w8(fe, 0x71, 1)		&&
+		nm131_w8(fe, 0x72, 0x24)	?
+		0 : -EIO;
+}
+
+int nm131_probe(struct i2c_client *t, const struct i2c_device_id *id)
+{
+	struct tnr_rf_reg_t {
+		u8 slvadr;
+		u8 val;
+	} const
+	tnr_rf_defaults_lut[] = {
+		{6, 72},	{7, 64},	{10, 235},	{11, 17},	{12, 16},	{13, 136},
+		{16, 4},	{17, 48},	{18, 48},	{21, 170},	{22, 3},	{23, 128},
+		{24, 103},	{25, 212},	{26, 68},	{28, 16},	{29, 238},	{30, 153},
+		{33, 197},	{34, 145},	{36, 1},	{43, 145},	{45, 1},	{47, 128},
+		{49, 0},	{51, 0},	{56, 0},	{57, 47},	{58, 0},	{59, 0}
+	},
+	nm120_rf_defaults_lut[] = {
+		{14, 69},	{27, 14},	{35, 255},	{38, 130},	{40, 0},
+		{48, 223},	{50, 223},	{52, 104},	{53, 24}
+	};
+	struct tnr_bb_reg_t {
+		u16 slvadr;
+		u32 val;
+	} const
+	tnr_bb_defaults_lut[2] = {
+		{356, 2048},	{448, 764156359}
+	};
+	u8			i;
+	struct dvb_frontend	*fe	= t->dev.platform_data;
+
+	fe->ops.tuner_ops.set_params	= nm131_tune;
+	if (nm131_w8(fe, 0xB0, 0xA0)		&&
+		nm131_w8(fe, 0xB2, 0x3D)	&&
+		nm131_w8(fe, 0xB3, 0x25)	&&
+		nm131_w8(fe, 0xB4, 0x8B)	&&
+		nm131_w8(fe, 0xB5, 0x4B)	&&
+		nm131_w8(fe, 0xB6, 0x3F)	&&
+		nm131_w8(fe, 0xB7, 0xFF)	&&
+		nm131_w8(fe, 0xB8, 0xC0)	&&
+		nm131_w8(fe, 3, 0)		&&
+		nm131_w8(fe, 0x1D, 0)		&&
+		nm131_w8(fe, 0x1F, 0)) {
+		nm131_w8(fe, 0xE, 0x77);
+		nm131_w8(fe, 0xF, 0x13);
+		nm131_w8(fe, 0x75, 2);
+	}
+	for (i = 0; i < ARRAY_SIZE(tnr_rf_defaults_lut); i++)
+		nm131_w(fe, tnr_rf_defaults_lut[i].slvadr, tnr_rf_defaults_lut[i].val, 1);
+	nm131_r(fe, 0x36, &i, 1);
+	nm131_w(fe, 0x36, i & 0x7F, 1);	/* no LDO bypass */
+	nm131_w(fe, tnr_bb_defaults_lut[0].slvadr, tnr_bb_defaults_lut[0].val, 4);
+	nm131_w(fe, tnr_bb_defaults_lut[1].slvadr, tnr_bb_defaults_lut[1].val, 4);
+	for (i = 0; i < ARRAY_SIZE(nm120_rf_defaults_lut); i++)
+		nm131_w(fe, nm120_rf_defaults_lut[i].slvadr, nm120_rf_defaults_lut[i].val, 1);
+	nm131_w(fe, 0xA, 0xFB, 1);	/* ltgain */
+	return 0;
+}
+
+static struct i2c_device_id nm131_id[] = {
+	{NM131_MODNAME, 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, nm131_id);
+
+static struct i2c_driver nm131_driver = {
+	.driver.name	= nm131_id->name,
+	.probe		= nm131_probe,
+	.id_table	= nm131_id,
+};
+module_i2c_driver(nm131_driver);
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <info@are.ma>");
+MODULE_DESCRIPTION("Driver for Newport Media tuners NMI131, NMI130 and NMI120");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/nm131.h b/drivers/media/tuners/nm131.h
new file mode 100644
index 0000000..21f3627
--- /dev/null
+++ b/drivers/media/tuners/nm131.h
@@ -0,0 +1,13 @@
+/*
+ * Driver for Newport Media tuners NMI131, NMI130 and NMI120
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ */
+
+#ifndef	NM131_H
+#define	NM131_H
+
+#define NM131_MODNAME "nm131"
+
+#endif
+
diff --git a/drivers/media/tuners/tda2014x.c b/drivers/media/tuners/tda2014x.c
new file mode 100644
index 0000000..bd54efc
--- /dev/null
+++ b/drivers/media/tuners/tda2014x.c
@@ -0,0 +1,342 @@
+/*
+	Driver for NXP Semiconductors tuner TDA2014x
+
+	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+*/
+
+#include "dvb_frontend.h"
+#include "tda2014x.h"
+
+int tda2014x_r(struct dvb_frontend *fe, u8 slvadr)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u8		buf[]	= {0xFE, 0xA8, slvadr},
+			rcmd[]	= {0xFE, 0xA9},
+			ret	= 0;
+	struct i2c_msg	msg[]	= {
+		{.addr = d->addr,	.flags = 0,		.buf = buf,	.len = 3,},
+		{.addr = d->addr,	.flags = 0,		.buf = rcmd,	.len = 2,},
+		{.addr = d->addr,	.flags = I2C_M_RD,	.buf = &ret,	.len = 1,},
+	};
+	return i2c_transfer(d->adapter, msg, 3) == 3 ? ret : -EIO;
+}
+
+bool tda2014x_r8(struct dvb_frontend *fe, u16 slvadr, u8 start_bit, u8 nbits, u8 *rdat)
+{
+	u8	mask	= nbits > 7 ? 0xFF : ((1 << nbits) - 1) << start_bit;
+	int	val	= tda2014x_r(fe, slvadr);
+
+	if (val < 0)
+		return false;
+	*rdat = (val & mask) >> start_bit;
+	return true;
+}
+
+bool tda2014x_w8(struct dvb_frontend *fe, u8 slvadr, u8 dat)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u8		buf[]	= {slvadr, dat};
+	struct i2c_msg	msg[]	= {
+		{.addr = d->addr,	.flags = 0,	.buf = buf,	.len = 2,},
+	};
+	return i2c_transfer(d->adapter, msg, 1) == 1;
+}
+
+bool tda2014x_w16(struct dvb_frontend *fe, u16 slvadr, u8 start_bit, u8 nbits, u8 nbytes, bool rmw, u8 access, u16 wdat)
+{
+	struct i2c_client	*d	= fe->demodulator_priv;
+	u16	mask	= nbits > 15 ? 0xFFFF : ((1 << nbits) - 1) << start_bit,
+		val	= mask & (wdat << start_bit);
+	u8	*wval	= (u8 *)&val,
+		i;
+
+	for (i = 0, nbytes = !nbytes ? 1 : nbytes > 2 ? 2 : nbytes; access & 2 && nbytes; i++, nbytes--) {
+		u8	buf[]	= {0xFE, 0xA8, slvadr + i, 0};
+		int	ret	= tda2014x_r(fe, slvadr + i);
+		struct i2c_msg msg[] = {
+			{.addr = d->addr,	.flags = 0,	.buf = buf,	.len = 4,},
+		};
+
+		if (ret < 0)
+			return false;
+		if (rmw)
+			wval[nbytes - 1] |= ~(mask >> 8 * i) & ret;
+		buf[3] = wval[nbytes - 1];
+		if (i2c_transfer(d->adapter, msg, 1) != 1)
+			return false;
+	}
+	return true;
+}
+
+int tda2014x_tune(struct dvb_frontend *fe)
+{
+	enum {
+		TDA2014X_LNA_GAIN_7dB	= 0x0,
+		TDA2014X_LNA_GAIN_10dB	= 0x1,
+		TDA2014X_LNA_GAIN_13dB	= 0x2,		/* default */
+		TDA2014X_LNA_GAIN_18dB	= 0x3,
+		TDA2014X_LNA_GAIN_NEGATIVE_11dB = 0x4,
+
+		TDA2014X_LPT_GAIN_NEGATIVE_8dB	= 0x0,
+		TDA2014X_LPT_GAIN_NEGATIVE_10dB	= 0x1,	/* default */
+		TDA2014X_LPT_GAIN_NEGATIVE_14dB	= 0x2,
+		TDA2014X_LPT_GAIN_NEGATIVE_16dB	= 0x3,
+
+		TDA2014X_AMPOUT_15DB	= 0x0,
+		TDA2014X_AMPOUT_18DB	= 0x1,
+		TDA2014X_AMPOUT_18DB_b	= 0x2,
+		TDA2014X_AMPOUT_21DB	= 0x3,		/* default */
+		TDA2014X_AMPOUT_24DB	= 0x6,		/* ok too */
+		TDA2014X_AMPOUT_27DB	= 0x7,
+		TDA2014X_AMPOUT_30DB	= 0xE,
+		TDA2014X_AMPOUT_33DB	= 0xF,
+	};
+	bool	bDoublerEnable[]		= {false, true, true, true, true},
+		bDcc1Enable[]			= {false, true, true, true, true},
+		bDcc2Enable[]			= {false, true, true, true, true},
+		bPpfEnable[]			= {false, true, true, true, true},
+		bDiv1ConfigInDivideBy3[]	= {false, true, false, true, false},
+		bDiv2ConfigInDivideBy3[]	= {false, true, true, false, false},
+		bSelectDivideBy4Or5Or6Or7Path[]	= {false, true, true, true, true},
+		bSelectDivideBy8Path[]		= {true, false, false, false, false},
+		bInputMuxEnable;
+	u8	PredividerRatio,
+		val;
+	u64	kHz = fe->dtv_property_cache.frequency,
+		ResLsb,
+		Premain,
+		CalcPrecision = 1000000,
+		kint,
+		Nint,
+		R,
+		DsmFracInReg,
+		DsmIntInReg,
+		v15;
+	int	ePllRefClkRatio,
+		i = kHz <= 1075000 ? 0 : kHz <= 1228000 ? 1 : kHz <= 1433000 ? 2 : kHz <= 1720000 ? 3 : 4,
+		lna	= TDA2014X_LNA_GAIN_13dB,
+		gain	= (lna == TDA2014X_LNA_GAIN_18dB) | ((lna & 3) << 4) | (TDA2014X_LPT_GAIN_NEGATIVE_10dB << 1),
+		ampout	= TDA2014X_AMPOUT_21DB;
+
+	/* GetLoConfig */
+	if (!tda2014x_r8(fe, 0x25, 3, 1, &val))
+		return -EIO;
+	bInputMuxEnable = val;
+
+	/* SetLoConfig */
+	if (tda2014x_w16(fe, 0x22, 0, 8, 0, 0, 6,
+		(bDoublerEnable[i] << 7) | (bDcc1Enable[i] << 6) | (bDcc2Enable[i] << 5) | 0b11110 | bPpfEnable[i]) &&
+		tda2014x_r8(fe, 0x23, 0, 8, &val) &&
+		tda2014x_w16(fe, 0x23, 0, 8, 0, 0, 6, (bDiv1ConfigInDivideBy3[i] << 7) | (bDiv2ConfigInDivideBy3[i] << 5) |
+			(bSelectDivideBy4Or5Or6Or7Path[i] << 3) | (bSelectDivideBy8Path[i] << 2) | (val & 0b1010011)))
+		tda2014x_w16(fe, 0x25, 3, 1, 0, 1, 6, bInputMuxEnable);
+
+	ResLsb = (8 - i) * kHz * 1000 / 27;	/* Xtal 27 MHz */
+	kint = ResLsb;
+	v15 = ResLsb / 1000000;
+	R = 1;
+	Premain = 2;
+	Nint = v15 * R / Premain;
+	if (Nint < 131) {
+		Premain = 1;
+		Nint = v15 * R / Premain;
+		if (Nint > 251) {
+			R = 3;
+			Premain = 4;
+			goto LABEL_36;
+		}
+		if (Nint < 131) {
+			R = 3;
+			Premain = 2;
+			goto LABEL_36;
+		}
+	} else if (Nint > 251) {
+		Premain = 4;
+		Nint = v15 * R / Premain;
+		if (Nint > 251) {
+			R = 3;
+			Premain = 4;
+		}
+LABEL_36:
+		Nint = v15 * R / Premain;
+		if (Nint < 131 || Nint > 251)
+			return -ERANGE;
+	}
+	switch (100 * R / Premain) {
+	case 25:
+		kint = ResLsb / 4;
+		break;
+	case 50:
+		kint = ResLsb / 2;
+		break;
+	case 75:
+		kint = ResLsb / 2 + ResLsb / 4;
+		break;
+	case 100:
+		break;
+	case 150:
+		kint = ResLsb / 2 + ResLsb;
+		break;
+	default:
+		return -ERANGE;
+	}
+	kint		= (kint / 10) * 10;
+	ePllRefClkRatio	= R == 2 ? 1 : R == 3 ? 2 : 0;
+	PredividerRatio	= Premain == 2 ? 0 : 1;
+	DsmIntInReg	= kint / 1000000;
+	DsmFracInReg	= kint - 1000000 * DsmIntInReg;
+	for (i = 0; i < 16; i++) {
+		DsmFracInReg *= 2;
+		if (DsmFracInReg > 0xFFFFFFF && i != 15) {
+			DsmFracInReg /= 10;
+			CalcPrecision /= 10;
+		}
+	}
+	return	!(tda2014x_w16(fe, 3, 6, 2, 0, 1, 6, ePllRefClkRatio)	&&
+
+		/* SetPllDividerConfig */
+		tda2014x_w16(fe, 0x1A, 5, 1, 0, 1, 6, PredividerRatio)			&&
+		tda2014x_w16(fe, 0x1E, 0, 8, 0, 0, 6, DsmIntInReg - 128)		&&
+		tda2014x_w16(fe, 0x1F, 0, 0x10, 2, 0, 6, DsmFracInReg / CalcPrecision)	&&
+
+		/* ProgramVcoChannelChange */
+		tda2014x_r8(fe, 0x12, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x12, 0, 8, 0, 0, 6, (val & 0x7F) | 0x40)	&&
+		tda2014x_w16(fe, 0x13, 0, 2, 0, 1, 6, 2)			&&
+		tda2014x_w16(fe, 0x13, 7, 1, 0, 1, 6, 0)			&&
+		tda2014x_w16(fe, 0x13, 5, 1, 0, 1, 6, 1)			&&
+		tda2014x_w16(fe, 0x13, 5, 1, 0, 1, 6, 1)			&&
+		tda2014x_w16(fe, 0x13, 7, 1, 0, 1, 6, 0)			&&
+		tda2014x_w16(fe, 0x13, 4, 1, 0, 1, 6, 1)			&&
+		((tda2014x_r8(fe, 0x15, 4, 1, &val) && val == 1)		||
+		(tda2014x_r8(fe, 0x15, 4, 1, &val) && val == 1))		&&
+		tda2014x_w16(fe, 0x13, 4, 1, 0, 1, 6, 0)			&&
+		tda2014x_r8(fe, 0x12, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x12, 0, 8, 0, 0, 6, val & 0x7F)		&&
+
+		/* SetFilterBandwidth */
+		tda2014x_w16(fe, 0xA, 0, 4, 0, 1, 6, 0xA)	&&
+		tda2014x_w16(fe, 0xB, 1, 7, 0, 1, 6, 0x7C)	&&
+
+		/* SetGainConfig */
+		tda2014x_r8(fe, 6, 0, 8, &val)					&&
+		tda2014x_w16(fe, 6, 0, 8, 0, 0, 6, (val & 0x48) | 0x80 | gain)	&&
+		tda2014x_r8(fe, 9, 0, 8, &val)					&&
+		tda2014x_w16(fe, 9, 0, 8, 0, 0, 6, 0b10110000 | (val & 3))	&&
+		tda2014x_w16(fe, 0xA, 5, 3, 0, 1, 6, 3)				&&
+		tda2014x_w16(fe, 0xC, 4, 4, 0, 1, 6, ampout)			&&
+
+		tda2014x_w8(fe, 0xA, 0xFF)	&&
+		tda2014x_w8(fe, 0x10, 0xB2)	&&
+		tda2014x_w8(fe, 0x11, 0)	&&
+		tda2014x_w8(fe, 3, 1)) * -EIO;
+}
+
+int tda2014x_probe(struct i2c_client *c, const struct i2c_device_id *id)
+{
+	u8			val	= 0;
+	struct dvb_frontend	*fe	= c->dev.platform_data;
+
+	fe->ops.tuner_ops.set_params	= tda2014x_tune;
+	fe->dtv_property_cache.frequency = 1318000;
+	return	!(tda2014x_w8(fe, 0x13, 0)	&&
+		tda2014x_w8(fe, 0x15, 0)	&&
+		tda2014x_w8(fe, 0x17, 0)	&&
+		tda2014x_w8(fe, 0x1C, 0)	&&
+		tda2014x_w8(fe, 0x1D, 0)	&&
+		tda2014x_w8(fe, 0x1F, 0)	&&
+		(tda2014x_w8(fe, 7, 0x31), tda2014x_w8(fe, 8, 0x77), tda2014x_w8(fe, 4, 2))	&&
+
+		/* SetPowerMode */
+		tda2014x_r8(fe, 2, 0, 8, &val)					&&
+		tda2014x_w16(fe, 2, 0, 8, 0, 0, 6, val | 0x81)			&&
+		tda2014x_r8(fe, 6, 0, 8, &val)					&&
+		tda2014x_w16(fe, 6, 0, 8, 0, 0, 6, (val | 0x39) & 0x7F)		&&
+		tda2014x_r8(fe, 7, 0, 8, &val)					&&
+		tda2014x_w16(fe, 7, 0, 8, 0, 0, 6, val | 0xAE)			&&
+		tda2014x_r8(fe, 0xF, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0xF, 0, 8, 0, 0, 6, val | 0x80)		&&
+		tda2014x_r8(fe, 0x18, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x18, 0, 8, 0, 0, 6, val & 0x7F)		&&
+		tda2014x_r8(fe, 0x1A, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x1A, 0, 8, 0, 0, 6, val | 0xC0)		&&
+		tda2014x_w16(fe, 0x22, 0, 8, 0, 0, 6, 0xFF)			&&
+		tda2014x_r8(fe, 0x23, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x23, 0, 8, 0, 0, 6, val & 0xFE)		&&
+		tda2014x_r8(fe, 0x25, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x25, 0, 8, 0, 0, 6, val | 8)			&&
+		tda2014x_r8(fe, 0x27, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x27, 0, 8, 0, 0, 6, (val | 0xC0) & 0xDF)	&&
+		tda2014x_r8(fe, 0x24, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x24, 0, 8, 0, 0, 6, (val | 4) & 0xCF)		&&
+		tda2014x_r8(fe, 0xD, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0xD, 0, 8, 0, 0, 6, val & 0xDF)		&&
+		tda2014x_r8(fe, 9, 0, 8, &val)					&&
+		tda2014x_w16(fe, 9, 0, 8, 0, 0, 6, (val | 0xB0) & 0xB1)		&&
+		tda2014x_r8(fe, 0xA, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0xA, 0, 8, 0, 0, 6, (val | 0x6F) & 0x7F)	&&
+		tda2014x_r8(fe, 0xB, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0xB, 0, 8, 0, 0, 6, (val | 0x7A) & 0x7B)	&&
+		tda2014x_w16(fe, 0xC, 0, 8, 0, 0, 6, 0)				&&
+		tda2014x_w16(fe, 0x19, 0, 8, 0, 0, 6, 0xFA)			&&
+		tda2014x_r8(fe, 0x1B, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x1B, 0, 8, 0, 0, 6, val & 0x7F)		&&
+		tda2014x_r8(fe, 0x21, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x21, 0, 8, 0, 0, 6, val | 0x40)		&&
+		tda2014x_r8(fe, 0x10, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x10, 0, 8, 0, 0, 6, (val | 0x90) & 0xBF)	&&
+		tda2014x_r8(fe, 0x14, 0, 8, &val)				&&
+		tda2014x_w16(fe, 0x14, 0, 8, 0, 0, 6, (val | 0x20) & 0xEF)	&&
+
+		/* ProgramPllPor */
+		tda2014x_w16(fe, 0x1A, 6, 1, 0, 1, 6, 1)	&&
+		tda2014x_w16(fe, 0x18, 0, 1, 0, 1, 6, 1)	&&
+		tda2014x_w16(fe, 0x18, 7, 1, 0, 1, 6, 1)	&&
+		tda2014x_w16(fe, 0x1B, 7, 1, 0, 1, 6, 1)	&&
+		tda2014x_w16(fe, 0x18, 0, 1, 0, 1, 6, 0)	&&
+
+		/* ProgramVcoPor */
+		tda2014x_r8(fe, 0xF, 0, 8, &val)						&&
+		(val = (val & 0x1F) | 0x80, tda2014x_w16(fe, 0xF, 0, 8, 0, 0, 6, val))		&&
+		tda2014x_r8(fe, 0x13, 0, 8, &val)						&&
+		(val = (val & 0xFFFFFFCF) | 0x20, tda2014x_w16(fe, 0x13, 0, 8, 0, 0, 6, val))	&&
+		tda2014x_r8(fe, 0x12, 0, 8, &val)				&&
+		(val |= 0xC0, tda2014x_w16(fe, 0x12, 0, 8, 0, 0, 6, val))	&&
+		tda2014x_w16(fe, 0x10, 5, 1, 0, 1, 6, 1)			&&
+		tda2014x_w16(fe, 0x10, 5, 1, 0, 1, 6, 1)			&&
+		tda2014x_w16(fe, 0xF, 5, 1, 0, 1, 6, 1)				&&
+		tda2014x_r8(fe, 0x11, 4, 1, &val)				&&
+		(val || tda2014x_r8(fe, 0x11, 4, 1, &val))			&&
+		(val || tda2014x_r8(fe, 0x11, 4, 1, &val))			&&
+		val								&&
+		tda2014x_r8(fe, 0x10, 0, 4, &val)				&&
+		tda2014x_w16(fe, 0xF, 0, 4, 0, 1, 6, val)			&&
+		tda2014x_w16(fe, 0xF, 6, 1, 0, 1, 6, 1)				&&
+		tda2014x_w16(fe, 0xF, 5, 1, 0, 1, 6, 0)				&&
+		tda2014x_r8(fe, 0x12, 0, 8, &val)				&&
+		(val &= 0x7F, tda2014x_w16(fe, 0x12, 0, 8, 0, 0, 6, val))	&&
+		tda2014x_w16(fe, 0xD, 5, 2, 0, 1, 6, 1)				&&
+
+		/* EnableLoopThrough */
+		tda2014x_r8(fe, 6, 0, 8, &val)					&&
+		tda2014x_w16(fe, 6, 0, 8, 0, 0, 6, (val & 0xF7) | 8)) * -EIO	||
+
+		tda2014x_tune(fe);
+}
+
+static struct i2c_device_id tda2014x_id[] = {
+	{TDA2014X_MODNAME, 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, tda2014x_id);
+
+static struct i2c_driver tda2014x_driver = {
+	.driver.name	= tda2014x_id->name,
+	.probe		= tda2014x_probe,
+	.id_table	= tda2014x_id,
+};
+module_i2c_driver(tda2014x_driver);
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <info@are.ma>");
+MODULE_DESCRIPTION("Driver for NXP Semiconductors tuner TDA2014x");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/tda2014x.h b/drivers/media/tuners/tda2014x.h
new file mode 100644
index 0000000..36f8198
--- /dev/null
+++ b/drivers/media/tuners/tda2014x.h
@@ -0,0 +1,13 @@
+/*
+ * Driver for NXP Semiconductors tuner TDA2014x
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ */
+
+#ifndef	TDA2014X_H
+#define	TDA2014X_H
+
+#define TDA2014X_MODNAME "tda2014x"
+
+#endif
+
-- 
2.7.4

