Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53402 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaIJLi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 07:38:28 -0400
Received: by mail-pd0-f174.google.com with SMTP id v10so10980830pde.33
        for <linux-media@vger.kernel.org>; Wed, 10 Sep 2014 04:38:27 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: Bud <knightrider@are.ma>, crope@iki.fi, m.chehab@samsung.com,
	hdegoede@redhat.com, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH] Earthsoft PT3 ISDB-S/T driver (tuners: mxl301rf, qm1d1c0042)
Date: Wed, 10 Sep 2014 20:38:21 +0900
Message-Id: <1410349101-30299-1-git-send-email-knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bud <knightrider@are.ma>


DVB driver for Earthsoft PT3 (PCIE ISDB-S/T receiver)
-----------------------------------------------------

Status: stable

Features:
- tuning enhancements, from  PT1 DVB
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#
- allocated devices
	ISDB-S : /dev/dvb/adapter0, /dev/dvb/adapter1
	ISDB-T : /dev/dvb/adapter2, /dev/dvb/adapter3

Main components:
1. Sharp	VA4M6JC2103	: contains 2 ISDB-S + 2 ISDB-T tuners
	ISDB-S : Sharp QM1D1C0042 RF-IC
	ISDB-T : MaxLinear CMOS Hybrid TV MxL301RF
2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
3. Altera	EP4CGX15BF14C8N	: customized FPGA PCI bridge

Full package:
- URL:	https://github.com/knight-rider/ptx/tree/master/pt3_dvb
- buildable as standalone, DKMS or tree embedded module
- installation:
	$ chmod +x dkms.install dkms.uninstall
	$ ./dkms.install

Changes since last release:
- cleanups (removed unused/useless features, simple is the best)
- removed .ops.write hacks

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/tuners/Kconfig          |  15 +-
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 361 +++++++++++++++++++++++
 drivers/media/tuners/mxl301rf.h       |  33 +++
 drivers/media/tuners/qm1d1c0042.c     | 382 +++++++++++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  33 +++

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 8319996..ee89558 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -226,7 +226,6 @@ config MEDIA_TUNER_FC2580
 config MEDIA_TUNER_M88TS2022
 	tristate "Montage M88TS2022 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
-	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Montage M88TS2022 silicon tuner driver.
@@ -258,4 +257,18 @@ config MEDIA_TUNER_R820T
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Rafael Micro R820T silicon tuner driver.
+
+config MEDIA_TUNER_MXL301RF
+	tristate "MaxLinear MXL301RF ISDB-T tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  MaxLinear MxL301RF ISDB-T tuner for PT3.
+
+config MEDIA_TUNER_QM1D1C0042
+	tristate "Sharp QM1D1C0042 ISDB-S tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Sharp QM1D1C0042 ISDB-S tuner for PT3.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 5591699..04d5efc 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -39,6 +39,8 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
+obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
new file mode 100644
index 0000000..f0c0a4a
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.c
@@ -0,0 +1,361 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mxl301rf.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver");
+MODULE_LICENSE("GPL");
+
+struct mxl301rf {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx;
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
+};
+
+struct shf_dvbt {
+	u32	freq,		/* Channel center frequency @ kHz	*/
+		freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val,	/* Spur shift value			*/
+		shf_dir;	/* Spur shift direction			*/
+};
+
+static const struct shf_dvbt shf_dvbt_tab[] = {
+	{  64500, 500, 0x92, 0x07 },
+	{ 191500, 300, 0xe2, 0x07 },
+	{ 205500, 500, 0x2c, 0x04 },
+	{ 212500, 500, 0x1e, 0x04 },
+	{ 226500, 500, 0xd4, 0x07 },
+	{  99143, 500, 0x9c, 0x07 },
+	{ 173143, 500, 0xd4, 0x07 },
+	{ 191143, 300, 0xd4, 0x07 },
+	{ 207143, 500, 0xce, 0x07 },
+	{ 225143, 500, 0xce, 0x07 },
+	{ 243143, 500, 0xd4, 0x07 },
+	{ 261143, 500, 0xd4, 0x07 },
+	{ 291143, 500, 0xd4, 0x07 },
+	{ 339143, 500, 0x2c, 0x04 },
+	{ 117143, 500, 0x7a, 0x07 },
+	{ 135143, 300, 0x7a, 0x07 },
+	{ 153143, 500, 0x01, 0x07 }
+};
+
+static const u32 mxl301rf_rf_tab[112] = {
+	0x058d3f49, 0x05e8ccc9, 0x06445a49, 0x069fe7c9, 0x06fb7549,
+	0x075702c9, 0x07b29049, 0x080e1dc9, 0x0869ab49, 0x08c538c9,
+	0x0920c649, 0x097c53c9, 0x09f665c9, 0x0a51f349, 0x0aad80c9,
+	0x0b090e49, 0x0b649bc9, 0x0ba1a4c9, 0x0bfd3249, 0x0c58bfc9,
+	0x0cb44d49, 0x0d0fdac9, 0x0d6b6849, 0x0dc6f5c9, 0x0e228349,
+	0x0e7e10c9, 0x0ed99e49, 0x0f352bc9, 0x0f90b949, 0x0fec46c9,
+	0x1047d449, 0x10a361c9, 0x10feef49, 0x115a7cc9, 0x11b60a49,
+	0x121197c9, 0x126d2549, 0x12c8b2c9, 0x13244049, 0x137fcdc9,
+	0x13db5b49, 0x1436e8c9, 0x14927649, 0x14ee03c9, 0x15499149,
+	0x15a51ec9, 0x1600ac49, 0x165c39c9, 0x16b7c749, 0x171354c9,
+	0x176ee249, 0x17ca6fc9, 0x1825fd49, 0x18818ac9, 0x18dd1849,
+	0x1938a5c9, 0x19943349, 0x19efc0c9, 0x1a4b4e49, 0x1aa6dbc9,
+	0x1b026949, 0x1b5df6c9, 0x1bb98449, 0x1c339649, 0x1c8f23c9,
+	0x1ceab149, 0x1d463ec9, 0x1da1cc49, 0x1dfd59c9, 0x1e58e749,
+	0x1eb474c9, 0x1f100249, 0x1f6b8fc9, 0x1fc71d49, 0x2022aac9,
+	0x207e3849, 0x20d9c5c9, 0x21355349, 0x2190e0c9, 0x21ec6e49,
+	0x2247fbc9, 0x22a38949, 0x22ff16c9, 0x235aa449, 0x23b631c9,
+	0x2411bf49, 0x246d4cc9, 0x24c8da49, 0x252467c9, 0x257ff549,
+	0x25db82c9, 0x26371049, 0x26929dc9, 0x26ee2b49, 0x2749b8c9,
+	0x27a54649, 0x2800d3c9, 0x285c6149, 0x28b7eec9, 0x29137c49,
+	0x296f09c9, 0x29ca9749, 0x2a2624c9, 0x2a81b249, 0x2add3fc9,
+	0x2b38cd49, 0x2b945ac9, 0x2befe849, 0x2c4b75c9, 0x2ca70349,
+	0x2d0290c9, 0x2d5e1e49,
+};
+#define MXL301RF_NHK (mxl301rf_rf_tab[77])	/* 日本放送協会 Nippon Hōsō Kyōkai, Japan Broadcasting Corporation */
+
+int mxl301rf_freq(int freq)
+{
+	if (freq >= 90000000)
+		return freq;					/* real_freq Hz	*/
+	if (freq > 255)
+		return MXL301RF_NHK;
+	if (freq > 127)
+		return mxl301rf_rf_tab[freq - 128];		/* freqno (IO#)	*/
+	if (freq > 63) {					/* CATV		*/
+		freq -= 64;
+		if (freq > 22)
+			return mxl301rf_rf_tab[freq - 1];	/* C23-C62	*/
+		if (freq > 12)
+			return mxl301rf_rf_tab[freq - 10];	/* C13-C22	*/
+		return MXL301RF_NHK;
+	}
+	if (freq > 62)
+		return MXL301RF_NHK;
+	if (freq > 12)
+		return mxl301rf_rf_tab[freq + 50];		/* 13-62	*/
+	if (freq >  3)
+		return mxl301rf_rf_tab[freq +  9];		/*  4-12	*/
+	if (freq)
+		return mxl301rf_rf_tab[freq -  1];		/*  1-3		*/
+	return MXL301RF_NHK;
+}
+
+void mxl301rf_rftune(struct dvb_frontend *fe, u8 *data, u32 *size, u32 freq)
+{
+	u8 rf_data[] = {
+		0x13, 0x00,	/* abort tune			*/
+		0x3b, 0xc0,
+		0x3b, 0x80,
+		0x10, 0x95,	/* BW				*/
+		0x1a, 0x05,
+		0x61, 0x00,
+		0x62, 0xa0,
+		0x11, 0x40,	/* 2 bytes to store RF freq.	*/
+		0x12, 0x0e,	/* 2 bytes to store RF freq.	*/
+		0x13, 0x01	/* start tune			*/
+	};
+	u32 i, dig_rf_freq, tmp,
+		kHz = 1000,
+		MHz = 1000000,
+		frac_divider = 1000000;
+
+	freq = mxl301rf_freq(freq);
+	dig_rf_freq = freq / MHz;
+	tmp = freq % MHz;
+	for (i = 0; i < 6; i++) {
+		dig_rf_freq <<= 1;
+		frac_divider /= 2;
+		if (tmp > frac_divider) {
+			tmp -= frac_divider;
+			dig_rf_freq++;
+		}
+	}
+	if (tmp > 7812)
+		dig_rf_freq++;
+	rf_data[2 * 7 + 1] = (u8)(dig_rf_freq);
+	rf_data[2 * 8 + 1] = (u8)(dig_rf_freq >> 8);
+
+	for (i = 0; i < ARRAY_SIZE(shf_dvbt_tab); i++) {
+		if ((freq >= (shf_dvbt_tab[i].freq - shf_dvbt_tab[i].freq_th) * kHz) &&
+				(freq <= (shf_dvbt_tab[i].freq + shf_dvbt_tab[i].freq_th) * kHz)) {
+			rf_data[2 * 5 + 1] = shf_dvbt_tab[i].shf_val;
+			rf_data[2 * 6 + 1] = 0xa0 | shf_dvbt_tab[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
+
+	dev_dbg(fe->dvb->device, "mx_rftune freq=%d\n", freq);
+}
+
+/* write via demodulator */
+int mxl301rf_fe_write_data(struct dvb_frontend *fe, u8 addr_data, const u8 *data, int len)
+{
+	u8 buf[len + 1];
+
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
+}
+
+#define MXL301RF_FE_PASSTHROUGH 0xfe
+
+int mxl301rf_fe_write_tuner(struct dvb_frontend *fe, const u8 *data, int len)
+{
+	u8 buf[len + 2];
+
+	buf[0] = MXL301RF_FE_PASSTHROUGH;
+	buf[1] = ((struct mxl301rf *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+/* read via demodulator */
+void mxl301rf_fe_read(struct dvb_frontend *fe, u8 addr, u8 *data)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	const u8 wbuf[2] = {0xfb, addr};
+	int ret;
+
+	mxl301rf_fe_write_tuner(fe, wbuf, sizeof(wbuf));
+	ret = mx->read(fe, &mx->addr_tuner, 1);
+	if (ret >= 0)
+		*data = ret;
+}
+
+void mxl301rf_idac_setting(struct dvb_frontend *fe)
+{
+	const u8 idac[] = {
+		0x0d, 0x00,
+		0x0c, 0x67,
+		0x6f, 0x89,
+		0x70, 0x0c,
+		0x6f, 0x8a,
+		0x70, 0x0e,
+		0x6f, 0x8b,
+		0x70, 0x10+12,
+	};
+	mxl301rf_fe_write_tuner(fe, idac, sizeof(idac));
+}
+
+void mxl301rf_set_register(struct dvb_frontend *fe, u8 addr, u8 value)
+{
+	const u8 data[2] = {addr, value};
+
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+}
+
+int mxl301rf_write_imsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01 << 6;
+
+	return mxl301rf_fe_write_data(fe, 0x01, &data, 1);
+}
+
+enum mxl301rf_agc {
+	MXL301RF_AGC_AUTO,
+	MXL301RF_AGC_MANUAL,
+};
+
+int mxl301rf_set_agc(struct dvb_frontend *fe, enum mxl301rf_agc agc)
+{
+	u8 data = (agc == MXL301RF_AGC_AUTO) ? 0x40 : 0x00;
+	int err = mxl301rf_fe_write_data(fe, 0x25, &data, 1);
+
+	if (err)
+		return err;
+	data = 0x4c | ((agc == MXL301RF_AGC_AUTO) ? 0x00 : 0x01);
+	return	mxl301rf_fe_write_data(fe, 0x23, &data, 1) ||
+		mxl301rf_write_imsrst(fe);
+}
+
+int mxl301rf_sleep(struct dvb_frontend *fe)
+{
+	u8 buf = (1 << 7) | (1 << 4);
+	const u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	return mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+}
+
+bool mxl301rf_rfsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
+
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x0c) == 0x0c;
+}
+
+bool mxl301rf_refsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
+
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x03) == 0x03;
+}
+
+bool mxl301rf_locked(struct dvb_frontend *fe)
+{
+	bool locked1 = false, locked2 = false;
+	unsigned long timeout = jiffies + msecs_to_jiffies(100);
+
+	while (time_before(jiffies, timeout)) {
+		locked1 = mxl301rf_rfsynth_locked(fe);
+		locked2 = mxl301rf_refsynth_locked(fe);
+		if (locked1 && locked2)
+			break;
+		msleep_interruptible(1);
+	}
+	dev_dbg(fe->dvb->device, "#%d %s lock1=%d lock2=%d\n", ((struct mxl301rf *)fe->tuner_priv)->idx, __func__, locked1, locked2);
+	return locked1 && locked2 ? !mxl301rf_set_agc(fe, MXL301RF_AGC_AUTO) : false;
+}
+
+int mxl301rf_tuner_rftune(struct dvb_frontend *fe, u32 freq)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	u8 data[100];
+	u32 size = 0;
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mx->freq = freq;
+	mxl301rf_rftune(fe, data, &size, freq);
+	if (size != 20) {
+		dev_dbg(fe->dvb->device, "fail mx_rftune size = %d\n", size);
+		return -EINVAL;
+	}
+	mxl301rf_fe_write_tuner(fe, data, 14);
+	msleep_interruptible(1);
+	mxl301rf_fe_write_tuner(fe, data + 14, 6);
+	msleep_interruptible(1);
+	mxl301rf_set_register(fe, 0x1a, 0x0d);
+	mxl301rf_idac_setting(fe);
+	return mxl301rf_locked(fe) ? 0 : -ETIMEDOUT;
+}
+
+int mxl301rf_wakeup(struct dvb_frontend *fe)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	int err;
+	u8 buf = (1 << 7) | (0 << 4);
+	const u8 data[2] = {0x01, 0x01};
+
+	err = mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	mxl301rf_tuner_rftune(fe, mx->freq);
+	return 0;
+}
+
+int mxl301rf_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static struct dvb_tuner_ops mxl301rf_ops = {
+	.info = {
+		.frequency_min	= 1,		/* actually 90 MHz, freq below that is handled as ch */
+		.frequency_max	= 770000000,	/* Hz */
+		.frequency_step	= 142857,
+	},
+	.set_frequency = mxl301rf_tuner_rftune,
+	.sleep = mxl301rf_sleep,
+	.init = mxl301rf_wakeup,
+	.release = mxl301rf_release,
+};
+
+int mxl301rf_attach(struct dvb_frontend *fe, u8 addr_tuner)
+{
+	u8 d[] = { 0x10, 0x01 };
+	struct mxl301rf *mx = kzalloc(sizeof(struct mxl301rf), GFP_KERNEL);
+
+	if (!mx)
+		return -ENOMEM;
+	fe->tuner_priv = mx;
+	mx->fe = fe;
+	mx->idx = (addr_tuner & 1) | 2;
+	mx->addr_tuner = addr_tuner;
+	mx->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(struct dvb_tuner_ops));
+
+	return	mxl301rf_fe_write_data(fe, 0x1c, d, 1)	||
+		mxl301rf_fe_write_data(fe, 0x1d, d+1, 1);
+}
+EXPORT_SYMBOL(mxl301rf_attach);
+
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
new file mode 100644
index 0000000..bb54a2bf
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.h
@@ -0,0 +1,33 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MXL301RF_H__
+#define __MXL301RF_H__
+
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL301RF)
+extern int mxl301rf_attach(struct dvb_frontend *fe, u8 addr_tuner);
+#else
+static inline int mxl301rf_attach(struct dvb_frontend *fe, u8 addr_tuner)
+{
+	dev_warn(fe->dvb->device, "%s: driver disabled by Kconfig\n", __func__);
+	return 0;
+}
+#endif
+
+#endif
+
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
new file mode 100644
index 0000000..690e4a4
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -0,0 +1,382 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "qm1d1c0042.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 QM1D1C0042 ISDB-S tuner driver");
+MODULE_LICENSE("GPL");
+
+struct qm1d1c0042 {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx, reg[32];
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
+};
+
+static const u8 qm1d1c0042_reg_rw[] = {
+	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
+};
+
+/* read via demodulator */
+int qm1d1c0042_fe_read(struct dvb_frontend *fe, u8 addr_data, u8 *data)
+{
+	int ret;
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 addr[] = { qm->addr_tuner, addr_data };
+
+	if ((addr_data != 0x00) && (addr_data != 0x0d))
+		return -EFAULT;
+	ret = qm->read(fe, addr, ARRAY_SIZE(addr));
+	if (ret < 0)
+		return ret;
+	*data = ret;
+	return 0;
+}
+
+/* write via demodulator */
+int qm1d1c0042_fe_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, int len)
+{
+	u8 buf[len + 1];
+
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
+}
+
+#define QM1D1C0042_FE_PASSTHROUGH 0xfe
+
+int qm1d1c0042_fe_write_tuner(struct dvb_frontend *fe, u8 *data, int len)
+{
+	u8 buf[len + 2];
+
+	buf[0] = QM1D1C0042_FE_PASSTHROUGH;
+	buf[1] = ((struct qm1d1c0042 *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+int qm1d1c0042_write(struct dvb_frontend *fe, u8 addr, u8 data)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf[] = { addr, data };
+	int err = qm1d1c0042_fe_write_tuner(fe, buf, sizeof(buf));
+
+	qm->reg[addr] = buf[1];
+	return err;
+}
+
+static const u8 qm1d1c0042_flag[32] = {
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
+};
+
+int qm1d1c0042_write_pskmsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01;
+
+	return qm1d1c0042_fe_write_data(fe, 0x03, &data, 1);
+}
+
+enum qm1d1c0042_agc {
+	QM1D1C0042_AGC_AUTO,
+	QM1D1C0042_AGC_MANUAL,
+};
+
+int qm1d1c0042_set_agc(struct dvb_frontend *fe, enum qm1d1c0042_agc agc)
+{
+	u8 data = (agc == QM1D1C0042_AGC_AUTO) ? 0xff : 0x00;
+	int err = qm1d1c0042_fe_write_data(fe, 0x0a, &data, 1);
+
+	if (err)
+		return err;
+	data = 0xb0 | ((agc == QM1D1C0042_AGC_AUTO) ? 1 : 0);
+	err = qm1d1c0042_fe_write_data(fe, 0x10, &data, 1);
+	if (err)
+		return err;
+
+	data = (agc == QM1D1C0042_AGC_AUTO) ? 0x40 : 0x00;
+	return (err = qm1d1c0042_fe_write_data(fe, 0x11, &data, 1)) ? err : qm1d1c0042_write_pskmsrst(fe);
+}
+
+int qm1d1c0042_sleep(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 1;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+	qm->reg[0x01] |= 1 << 0;
+	qm->reg[0x05] |= 1 << 3;
+	return	qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL)	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05])	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1);
+}
+
+int qm1d1c0042_wakeup(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 0;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] |= 1 << 3;
+	qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+	qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+	return	qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1)	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05]);
+}
+
+void qm1d1c0042_get_channel_freq(u32 channel, u32 *number, u32 *freq)
+{
+	if (channel < 12) {
+		*number = 1 + 2 * channel;
+		*freq = 104948 + 3836 * channel;
+	} else if (channel < 24) {
+		channel -= 12;
+		*number = 2 + 2 * channel;
+		*freq = 161300 + 4000 * channel;
+	} else {
+		channel -= 24;
+		*number = 1 + 2 * channel;
+		*freq = 159300 + 4000 * channel;
+	}
+}
+
+static const u32 qm1d1c0042_freq_tab[9][3] = {
+	{ 2151000, 1, 7 },
+	{ 1950000, 1, 6 },
+	{ 1800000, 1, 5 },
+	{ 1600000, 1, 4 },
+	{ 1450000, 1, 3 },
+	{ 1250000, 1, 2 },
+	{ 1200000, 0, 7 },
+	{  975000, 0, 6 },
+	{  950000, 0, 0 }
+};
+
+static const u32 qm1d1c0042_sd_tab[24][3] = {
+	{0x38fae1, 0x0d, 0x5},
+	{0x3f570a, 0x0e, 0x3},
+	{0x05b333, 0x0e, 0x5},
+	{0x3c0f5c, 0x0f, 0x4},
+	{0x026b85, 0x0f, 0x6},
+	{0x38c7ae, 0x10, 0x5},
+	{0x3f23d7, 0x11, 0x3},
+	{0x058000, 0x11, 0x5},
+	{0x3bdc28, 0x12, 0x4},
+	{0x023851, 0x12, 0x6},
+	{0x38947a, 0x13, 0x5},
+	{0x3ef0a3, 0x14, 0x3},
+	{0x3c8000, 0x16, 0x4},
+	{0x048000, 0x16, 0x6},
+	{0x3c8000, 0x17, 0x5},
+	{0x048000, 0x18, 0x3},
+	{0x3c8000, 0x18, 0x6},
+	{0x048000, 0x19, 0x4},
+	{0x3c8000, 0x1a, 0x3},
+	{0x048000, 0x1a, 0x5},
+	{0x3c8000, 0x1b, 0x4},
+	{0x048000, 0x1b, 0x6},
+	{0x3c8000, 0x1c, 0x5},
+	{0x048000, 0x1d, 0x3},
+};
+
+static int qm1d1c0042_tuning(struct qm1d1c0042 *qm, u32 *sd, u32 channel)
+{
+	int ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 i, N, A;
+
+	qm->reg[0x08] &= 0xf0;
+	qm->reg[0x08] |= 0x09;
+
+	qm->reg[0x13] &= 0x9f;
+	qm->reg[0x13] |= 0x20;
+
+	for (i = 0; i < 8; i++) {
+		if ((qm1d1c0042_freq_tab[i+1][0] <= qm->freq) && (qm->freq < qm1d1c0042_freq_tab[i][0])) {
+			i_data = qm->reg[0x02];
+			i_data &= 0x0f;
+			i_data |= qm1d1c0042_freq_tab[i][1] << 7;
+			i_data |= qm1d1c0042_freq_tab[i][2] << 4;
+			qm1d1c0042_write(fe, 0x02, i_data);
+		}
+	}
+
+	*sd = qm1d1c0042_sd_tab[channel][0];
+	N = qm1d1c0042_sd_tab[channel][1];
+	A = qm1d1c0042_sd_tab[channel][2];
+
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = qm1d1c0042_write(fe, 0x06, qm->reg[0x06]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return qm1d1c0042_write(fe, 0x07, qm->reg[0x07]);
+}
+
+static int qm1d1c0042_local_lpf_tuning(struct qm1d1c0042 *qm, u32 channel)
+{
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 sd = 0;
+	int err = qm1d1c0042_tuning(qm, &sd, channel);
+
+	if (err)
+		return err;
+	i_data = qm->reg[0x08] & 0xf0;
+	i_data |= 2;
+	err = qm1d1c0042_write(fe, 0x08, i_data);
+	if (err)
+		return err;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	err =	qm1d1c0042_write(fe, 0x09, qm->reg[0x09])	||
+		qm1d1c0042_write(fe, 0x0a, qm->reg[0x0a])	||
+		qm1d1c0042_write(qm->fe, 0x0b, qm->reg[0x0b]);
+	if (err)
+		return err;
+
+	i_data = qm->reg[0x0c];
+	i_data &= 0x3f;
+	err = qm1d1c0042_write(fe, 0x0c, i_data);
+	if (err)
+		return err;
+	msleep_interruptible(1);
+
+	i_data = qm->reg[0x0c];
+	i_data |= 0xc0;
+	return	qm1d1c0042_write(fe, 0x0c, i_data)	||
+		qm1d1c0042_write(fe, 0x08, 0x09)	||
+		qm1d1c0042_write(fe, 0x13, qm->reg[0x13]);
+}
+
+int qm1d1c0042_get_locked(struct qm1d1c0042 *qm, bool *locked)
+{
+	int err = qm1d1c0042_fe_read(qm->fe, 0x0d, &qm->reg[0x0d]);
+
+	if (err)
+		return err;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return err;
+}
+
+u32 qm1d1c0042_freq2ch(u32 frequency)
+{
+	u32 freq = frequency / 10,
+	    ch0 = (freq - 104948) / 3836, diff0 = freq - (104948 + 3836 * ch0),
+	    ch1 = (freq - 161300) / 4000, diff1 = freq - (161300 + 4000 * ch1),
+	    ch2 = (freq - 159300) / 4000, diff2 = freq - (159300 + 4000 * ch2),
+	    min = diff0 < diff1 ? diff0 : diff1;
+
+	if (frequency < 1024)
+		return frequency;	/* consider as channel ID if low */
+	if (diff2 < min)
+		return ch2 + 24;
+	if (min == diff1)
+		return ch1 + 12;
+	return ch0;
+}
+
+int qm1d1c0042_set_freq(struct dvb_frontend *fe, u32 frequency)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u32 channel = qm1d1c0042_freq2ch(frequency);
+	u32 number, freq;
+	bool locked = false;
+	unsigned long timeout;
+	int err = qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL);
+
+	if (err)
+		return err;
+	qm1d1c0042_get_channel_freq(channel, &number, &freq);
+	qm->freq = freq * 10 - 500;
+	dev_dbg(fe->dvb->device, "#%d ch %d freq %d kHz\n", qm->idx, channel, qm->freq);
+
+	err = qm1d1c0042_local_lpf_tuning(qm, channel);
+	if (err)
+		return err;
+
+	timeout = jiffies + msecs_to_jiffies(1000);	/* 1s */
+	while (time_before(jiffies, timeout)) {
+		err = qm1d1c0042_get_locked(qm, &locked);
+		if (err)
+			return err;
+		if (locked)
+			break;
+		msleep_interruptible(1);
+	}
+	dev_dbg(fe->dvb->device, "#%d %s %s\n", qm->idx, __func__, locked ? "LOCKED" : "TIMEOUT");
+	return locked ? qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_AUTO) : -ETIMEDOUT;
+}
+
+int qm1d1c0042_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static struct dvb_tuner_ops qm1d1c0042_ops = {
+	.info = {
+		.frequency_min	= 1,		/* actually 1024 kHz, freq below that is handled as ch */
+		.frequency_max	= 2150000,	/* kHz */
+		.frequency_step	= 1000,		/* = 1 MHz */
+	},
+	.set_frequency = qm1d1c0042_set_freq,
+	.sleep = qm1d1c0042_sleep,
+	.init = qm1d1c0042_wakeup,
+	.release = qm1d1c0042_release,
+};
+
+int qm1d1c0042_attach(struct dvb_frontend *fe, u8 addr_tuner)
+{
+	u8 d[] = { 0x10, 0x15, 0x04 };
+	struct qm1d1c0042 *qm = kzalloc(sizeof(struct qm1d1c0042), GFP_KERNEL);
+
+	if (!qm)
+		return -ENOMEM;
+	fe->tuner_priv = qm;
+	qm->fe = fe;
+	qm->addr_tuner = addr_tuner;
+	qm->idx = !(addr_tuner & 1);
+	qm->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(struct dvb_tuner_ops));
+
+	memcpy(qm->reg, qm1d1c0042_reg_rw, sizeof(qm1d1c0042_reg_rw));
+	qm->freq = 0;
+
+	return	qm1d1c0042_fe_write_data(fe, 0x1e, d,   1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1c, d+1, 1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1f, d+2, 1);
+}
+EXPORT_SYMBOL(qm1d1c0042_attach);
+
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
new file mode 100644
index 0000000..1f4f6a5
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -0,0 +1,33 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __QM1D1C0042_H__
+#define __QM1D1C0042_H__
+
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_QM1D1C0042)
+extern int qm1d1c0042_attach(struct dvb_frontend *fe, u8 addr_tuner);
+#else
+static inline int qm1d1c0042_attach(struct dvb_frontend *fe, u8 addr_tuner)
+{
+	dev_warn(fe->dvb->device, "%s: driver disabled by Kconfig\n", __func__);
+	return 0;
+}
+#endif
+
+#endif
+
-- 
1.8.4.5

