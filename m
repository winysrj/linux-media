Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36007 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab3KFR5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:57:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] Montage M88DS3103 DVB-S/S2 demodulator driver
Date: Wed,  6 Nov 2013 19:57:30 +0200
Message-Id: <1383760655-11388-4-git-send-email-crope@iki.fi>
In-Reply-To: <1383760655-11388-1-git-send-email-crope@iki.fi>
References: <1383760655-11388-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb-frontends/Kconfig          |    7 +
 drivers/media/dvb-frontends/Makefile         |    1 +
 drivers/media/dvb-frontends/m88ds3103.c      | 1293 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103.h      |  108 +++
 drivers/media/dvb-frontends/m88ds3103_priv.h |  218 +++++
 5 files changed, 1627 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.c
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.h
 create mode 100644 drivers/media/dvb-frontends/m88ds3103_priv.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index bddbab4..6c46caf 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -35,6 +35,13 @@ config DVB_STV6110x
 	help
 	  A Silicon tuner that supports DVB-S and DVB-S2 modes
 
+config DVB_M88DS3103
+	tristate "Montage M88DS3103"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
+
 comment "Multistandard (cable + terrestrial) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index f9cb43d..0c75a6a 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_DVB_STV6110) += stv6110.o
 obj-$(CONFIG_DVB_STV0900) += stv0900.o
 obj-$(CONFIG_DVB_STV090x) += stv090x.o
 obj-$(CONFIG_DVB_STV6110x) += stv6110x.o
+obj-$(CONFIG_DVB_M88DS3103) += m88ds3103.o
 obj-$(CONFIG_DVB_ISL6423) += isl6423.o
 obj-$(CONFIG_DVB_EC100) += ec100.o
 obj-$(CONFIG_DVB_HD29L2) += hd29l2.o
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
new file mode 100644
index 0000000..91b3729
--- /dev/null
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -0,0 +1,1293 @@
+/*
+ * Montage M88DS3103 demodulator driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
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
+#include "m88ds3103_priv.h"
+
+static struct dvb_frontend_ops m88ds3103_ops;
+
+/* write multiple registers */
+static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
+		u8 reg, const u8 *val, int len)
+{
+	int ret;
+	u8 buf[1 + len];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = priv->cfg->i2c_addr,
+			.flags = 0,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
+
+	buf[0] = reg;
+	memcpy(&buf[1], val, len);
+
+	mutex_lock(&priv->i2c_mutex);
+	ret = i2c_transfer(priv->i2c, msg, 1);
+	mutex_unlock(&priv->i2c_mutex);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+/* read multiple registers */
+static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
+		u8 reg, u8 *val, int len)
+{
+	int ret;
+	u8 buf[len];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = priv->cfg->i2c_addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &reg,
+		}, {
+			.addr = priv->cfg->i2c_addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
+
+	mutex_lock(&priv->i2c_mutex);
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	mutex_unlock(&priv->i2c_mutex);
+	if (ret == 2) {
+		memcpy(val, buf, len);
+		ret = 0;
+	} else {
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+/* write single register */
+static int m88ds3103_wr_reg(struct m88ds3103_priv *priv, u8 reg, u8 val)
+{
+	return m88ds3103_wr_regs(priv, reg, &val, 1);
+}
+
+/* read single register */
+static int m88ds3103_rd_reg(struct m88ds3103_priv *priv, u8 reg, u8 *val)
+{
+	return m88ds3103_rd_regs(priv, reg, val, 1);
+}
+
+/* write single register with mask */
+static int m88ds3103_wr_reg_mask(struct m88ds3103_priv *priv,
+		u8 reg, u8 val, u8 mask)
+{
+	int ret;
+	u8 u8tmp;
+
+	/* no need for read if whole reg is written */
+	if (mask != 0xff) {
+		ret = m88ds3103_rd_regs(priv, reg, &u8tmp, 1);
+		if (ret)
+			return ret;
+
+		val &= mask;
+		u8tmp &= ~mask;
+		val |= u8tmp;
+	}
+
+	return m88ds3103_wr_regs(priv, reg, &val, 1);
+}
+
+/* read single register with mask */
+static int m88ds3103_rd_reg_mask(struct m88ds3103_priv *priv,
+		u8 reg, u8 *val, u8 mask)
+{
+	int ret, i;
+	u8 u8tmp;
+
+	ret = m88ds3103_rd_regs(priv, reg, &u8tmp, 1);
+	if (ret)
+		return ret;
+
+	u8tmp &= mask;
+
+	/* find position of the first bit */
+	for (i = 0; i < 8; i++) {
+		if ((mask >> i) & 0x01)
+			break;
+	}
+	*val = u8tmp >> i;
+
+	return 0;
+}
+
+static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u8 u8tmp;
+
+	*status = 0;
+
+	if (!priv->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		ret = m88ds3103_rd_reg_mask(priv, 0xd1, &u8tmp, 0x07);
+		if (ret)
+			goto err;
+
+		if (u8tmp == 0x07)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI | FE_HAS_SYNC |
+					FE_HAS_LOCK;
+		break;
+	case SYS_DVBS2:
+		ret = m88ds3103_rd_reg_mask(priv, 0x0d, &u8tmp, 0x8f);
+		if (ret)
+			goto err;
+
+		if (u8tmp == 0x8f)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI | FE_HAS_SYNC |
+					FE_HAS_LOCK;
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	priv->fe_status = *status;
+
+	dev_dbg(&priv->i2c->dev, "%s: lock=%02x status=%02x\n",
+			__func__, u8tmp, *status);
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_set_frontend(struct dvb_frontend *fe)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i, len;
+	const struct m88ds3103_reg_val *init;
+	u8 u8tmp, u8tmp1, u8tmp2;
+	u8 buf[2];
+	u16 u16tmp, divide_ratio;
+	u32 tuner_frequency, target_mclk, ts_clk;
+	s32 s32tmp;
+	dev_dbg(&priv->i2c->dev,
+			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
+			__func__, c->delivery_system,
+			c->modulation, c->frequency, c->symbol_rate,
+			c->inversion, c->pilot, c->rolloff);
+
+	if (!priv->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	/* program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		ret = fe->ops.tuner_ops.set_params(fe);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.tuner_ops.get_frequency) {
+		ret = fe->ops.tuner_ops.get_frequency(fe, &tuner_frequency);
+		if (ret)
+			goto err;
+	}
+
+	/* reset */
+	ret = m88ds3103_wr_reg(priv, 0x07, 0x80);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x00, 0x01);
+	if (ret)
+		goto err;
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		len = ARRAY_SIZE(m88ds3103_dvbs_init_reg_vals);
+		init = m88ds3103_dvbs_init_reg_vals;
+		target_mclk = 96000;
+		break;
+	case SYS_DVBS2:
+		len = ARRAY_SIZE(m88ds3103_dvbs2_init_reg_vals);
+		init = m88ds3103_dvbs2_init_reg_vals;
+
+		switch (priv->cfg->ts_mode) {
+		case M88DS3103_TS_SERIAL:
+		case M88DS3103_TS_SERIAL_D7:
+			if (c->symbol_rate < 18000000)
+				target_mclk = 96000;
+			else
+				target_mclk = 144000;
+			break;
+		case M88DS3103_TS_PARALLEL:
+		case M88DS3103_TS_PARALLEL_12:
+		case M88DS3103_TS_PARALLEL_16:
+		case M88DS3103_TS_PARALLEL_19_2:
+		case M88DS3103_TS_CI:
+			if (c->symbol_rate < 18000000)
+				target_mclk = 96000;
+			else if (c->symbol_rate < 28000000)
+				target_mclk = 144000;
+			else
+				target_mclk = 192000;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
+					__func__);
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* program init table */
+	if (c->delivery_system != priv->delivery_system) {
+		dev_dbg(&priv->i2c->dev, "%s: program init\n", __func__);
+		for (i = 0; i < len; i++) {
+			ret = m88ds3103_wr_reg(priv, init[i].reg, init[i].val);
+			if (ret)
+				goto err;
+		}
+	}
+
+	u8tmp1 = 0; /* silence compiler warning */
+	switch (priv->cfg->ts_mode) {
+	case M88DS3103_TS_SERIAL:
+		u8tmp1 = 0x00;
+		ts_clk = 0;
+		u8tmp = 0x04;
+		break;
+	case M88DS3103_TS_SERIAL_D7:
+		u8tmp1 = 0x20;
+		ts_clk = 0;
+		u8tmp = 0x04;
+		break;
+	case M88DS3103_TS_PARALLEL:
+		ts_clk = 24000;
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_TS_PARALLEL_12:
+		ts_clk = 12000;
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_TS_PARALLEL_16:
+		ts_clk = 16000;
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_TS_PARALLEL_19_2:
+		ts_clk = 19200;
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_TS_CI:
+		ts_clk = 6000;
+		u8tmp = 0x01;
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n", __func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* TS mode */
+	ret = m88ds3103_wr_reg_mask(priv, 0xfd, u8tmp, 0x05);
+	if (ret)
+		goto err;
+
+	switch (priv->cfg->ts_mode) {
+	case M88DS3103_TS_SERIAL:
+	case M88DS3103_TS_SERIAL_D7:
+		ret = m88ds3103_wr_reg_mask(priv, 0x29, u8tmp1, 0x20);
+		if (ret)
+			goto err;
+	}
+
+	if (ts_clk) {
+		divide_ratio = DIV_ROUND_UP(target_mclk, ts_clk);
+		u8tmp1 = divide_ratio / 2;
+		u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
+	} else {
+		divide_ratio = 0;
+		u8tmp1 = 0;
+		u8tmp2 = 0;
+	}
+
+	dev_dbg(&priv->i2c->dev,
+			"%s: target_mclk=%d ts_clk=%d divide_ratio=%d\n",
+			__func__, target_mclk, ts_clk, divide_ratio);
+
+	u8tmp1--;
+	u8tmp2--;
+	/* u8tmp1[5:2] => fe[3:0], u8tmp1[1:0] => ea[7:6] */
+	u8tmp1 &= 0x3f;
+	/* u8tmp2[5:0] => ea[5:0] */
+	u8tmp2 &= 0x3f;
+
+	ret = m88ds3103_rd_reg(priv, 0xfe, &u8tmp);
+	if (ret)
+		goto err;
+
+	u8tmp = ((u8tmp  & 0xf0) << 0) | u8tmp1 >> 2;
+	ret = m88ds3103_wr_reg(priv, 0xfe, u8tmp);
+	if (ret)
+		goto err;
+
+	u8tmp = ((u8tmp1 & 0x03) << 6) | u8tmp2 >> 0;
+	ret = m88ds3103_wr_reg(priv, 0xea, u8tmp);
+	if (ret)
+		goto err;
+
+	switch (target_mclk) {
+	case 72000:
+		u8tmp1 = 0x00; /* 0b00 */
+		u8tmp2 = 0x03; /* 0b11 */
+		break;
+	case 96000:
+		u8tmp1 = 0x02; /* 0b10 */
+		u8tmp2 = 0x01; /* 0b01 */
+		break;
+	case 115200:
+		u8tmp1 = 0x01; /* 0b01 */
+		u8tmp2 = 0x01; /* 0b01 */
+		break;
+	case 144000:
+		u8tmp1 = 0x00; /* 0b00 */
+		u8tmp2 = 0x01; /* 0b01 */
+		break;
+	case 192000:
+		u8tmp1 = 0x03; /* 0b11 */
+		u8tmp2 = 0x00; /* 0b00 */
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid target_mclk\n", __func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x22, u8tmp1 << 6, 0xc0);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x24, u8tmp2 << 6, 0xc0);
+	if (ret)
+		goto err;
+
+	if (c->symbol_rate <= 3000000)
+		u8tmp = 0x20;
+	else if (c->symbol_rate <= 10000000)
+		u8tmp = 0x10;
+	else
+		u8tmp = 0x06;
+
+	ret = m88ds3103_wr_reg(priv, 0xc3, 0x08);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xc8, u8tmp);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xc4, 0x08);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xc7, 0x00);
+	if (ret)
+		goto err;
+
+	u16tmp = (((c->symbol_rate / 1000) << 15) + (M88DS3103_MCLK_KHZ / 4)) /
+			(M88DS3103_MCLK_KHZ / 2);
+	buf[0] = (u16tmp >> 0) & 0xff;
+	buf[1] = (u16tmp >> 8) & 0xff;
+	ret = m88ds3103_wr_regs(priv, 0x61, buf, 2);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x4d, priv->cfg->spec_inv << 1, 0x02);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x30, priv->cfg->agc_inv << 4, 0x10);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x33, priv->cfg->agc);
+	if (ret)
+		goto err;
+
+	dev_dbg(&priv->i2c->dev, "%s: carrier offset=%d\n", __func__,
+			(tuner_frequency - c->frequency));
+
+	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
+	s32tmp = (2 * s32tmp + M88DS3103_MCLK_KHZ) / (2 * M88DS3103_MCLK_KHZ);
+	if (s32tmp < 0)
+		s32tmp += 0x10000;
+
+	buf[0] = (s32tmp >> 0) & 0xff;
+	buf[1] = (s32tmp >> 8) & 0xff;
+	ret = m88ds3103_wr_regs(priv, 0x5e, buf, 2);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x00, 0x00);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xb2, 0x00);
+	if (ret)
+		goto err;
+
+	priv->delivery_system = c->delivery_system;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_init(struct dvb_frontend *fe)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	int ret, len, remaining;
+	const struct firmware *fw = NULL;
+	u8 *fw_file = M88DS3103_FIRMWARE;
+	u8 u8tmp;
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	/* set cold state by default */
+	priv->warm = false;
+
+	/* wake up device from sleep */
+	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x01, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x00, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x00, 0x10);
+	if (ret)
+		goto err;
+
+	/* reset */
+	ret = m88ds3103_wr_reg(priv, 0x07, 0x60);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
+	if (ret)
+		goto err;
+
+	/* firmware status */
+	ret = m88ds3103_rd_reg(priv, 0xb9, &u8tmp);
+	if (ret)
+		goto err;
+
+	dev_dbg(&priv->i2c->dev, "%s: firmware=%02x\n", __func__, u8tmp);
+
+	if (u8tmp)
+		goto skip_fw_download;
+
+	/* cold state - try to download firmware */
+	dev_info(&priv->i2c->dev, "%s: found a '%s' in cold state\n",
+			KBUILD_MODNAME, m88ds3103_ops.info.name);
+
+	/* request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
+	if (ret) {
+		dev_err(&priv->i2c->dev, "%s: firmare file '%s' not found\n",
+				KBUILD_MODNAME, fw_file);
+		goto err;
+	}
+
+	dev_info(&priv->i2c->dev, "%s: downloading firmware from file '%s'\n",
+			KBUILD_MODNAME, fw_file);
+
+	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
+	if (ret)
+		goto err;
+
+	for (remaining = fw->size; remaining > 0;
+			remaining -= (priv->cfg->i2c_wr_max - 1)) {
+		len = remaining;
+		if (len > (priv->cfg->i2c_wr_max - 1))
+			len = (priv->cfg->i2c_wr_max - 1);
+
+		ret = m88ds3103_wr_regs(priv, 0xb0,
+				&fw->data[fw->size - remaining], len);
+		if (ret) {
+			dev_err(&priv->i2c->dev,
+					"%s: firmware download failed=%d\n",
+					KBUILD_MODNAME, ret);
+			goto err;
+		}
+	}
+
+	ret = m88ds3103_wr_reg(priv, 0xb2, 0x00);
+	if (ret)
+		goto err;
+
+	release_firmware(fw);
+	fw = NULL;
+
+	ret = m88ds3103_rd_reg(priv, 0xb9, &u8tmp);
+	if (ret)
+		goto err;
+
+	if (!u8tmp) {
+		dev_info(&priv->i2c->dev, "%s: firmware did not run\n",
+				KBUILD_MODNAME);
+		ret = -EFAULT;
+		goto err;
+	}
+
+	dev_info(&priv->i2c->dev, "%s: found a '%s' in warm state\n",
+			KBUILD_MODNAME, m88ds3103_ops.info.name);
+	dev_info(&priv->i2c->dev, "%s: firmware version %X.%X\n",
+			KBUILD_MODNAME, (u8tmp >> 4) & 0xf, (u8tmp >> 0 & 0xf));
+
+skip_fw_download:
+	/* warm state */
+	priv->warm = true;
+
+	return 0;
+err:
+	if (fw)
+		release_firmware(fw);
+
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_sleep(struct dvb_frontend *fe)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	int ret;
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	priv->delivery_system = SYS_UNDEFINED;
+
+	/* TS Hi-Z */
+	ret = m88ds3103_wr_reg_mask(priv, 0x27, 0x00, 0x01);
+	if (ret)
+		goto err;
+
+	/* sleep */
+	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x00, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x01, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x10, 0x10);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_get_frontend(struct dvb_frontend *fe)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u8 buf[3];
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		ret = m88ds3103_rd_reg(priv, 0xe0, &buf[0]);
+		if (ret)
+			goto err;
+
+		ret = m88ds3103_rd_reg(priv, 0xe6, &buf[1]);
+		if (ret)
+			goto err;
+
+		switch ((buf[0] >> 2) & 0x01) {
+		case 0:
+			c->inversion = INVERSION_OFF;
+			break;
+		case 1:
+			c->inversion = INVERSION_ON;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid inversion\n",
+					__func__);
+		}
+
+		switch ((buf[1] >> 5) & 0x07) {
+		case 0:
+			c->fec_inner = FEC_7_8;
+			break;
+		case 1:
+			c->fec_inner = FEC_5_6;
+			break;
+		case 2:
+			c->fec_inner = FEC_3_4;
+			break;
+		case 3:
+			c->fec_inner = FEC_2_3;
+			break;
+		case 4:
+			c->fec_inner = FEC_1_2;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid fec_inner\n",
+					__func__);
+		}
+
+		c->modulation = QPSK;
+
+		break;
+	case SYS_DVBS2:
+		ret = m88ds3103_rd_reg(priv, 0x7e, &buf[0]);
+		if (ret)
+			goto err;
+
+		ret = m88ds3103_rd_reg(priv, 0x89, &buf[1]);
+		if (ret)
+			goto err;
+
+		ret = m88ds3103_rd_reg(priv, 0xf2, &buf[2]);
+		if (ret)
+			goto err;
+
+		switch ((buf[0] >> 0) & 0x0f) {
+		case 2:
+			c->fec_inner = FEC_2_5;
+			break;
+		case 3:
+			c->fec_inner = FEC_1_2;
+			break;
+		case 4:
+			c->fec_inner = FEC_3_5;
+			break;
+		case 5:
+			c->fec_inner = FEC_2_3;
+			break;
+		case 6:
+			c->fec_inner = FEC_3_4;
+			break;
+		case 7:
+			c->fec_inner = FEC_4_5;
+			break;
+		case 8:
+			c->fec_inner = FEC_5_6;
+			break;
+		case 9:
+			c->fec_inner = FEC_8_9;
+			break;
+		case 10:
+			c->fec_inner = FEC_9_10;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid fec_inner\n",
+					__func__);
+		}
+
+		switch ((buf[0] >> 5) & 0x01) {
+		case 0:
+			c->pilot = PILOT_OFF;
+			break;
+		case 1:
+			c->pilot = PILOT_ON;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid pilot\n",
+					__func__);
+		}
+
+		switch ((buf[0] >> 6) & 0x07) {
+		case 0:
+			c->modulation = QPSK;
+			break;
+		case 1:
+			c->modulation = PSK_8;
+			break;
+		case 2:
+			c->modulation = APSK_16;
+			break;
+		case 3:
+			c->modulation = APSK_32;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid modulation\n",
+					__func__);
+		}
+
+		switch ((buf[1] >> 7) & 0x01) {
+		case 0:
+			c->inversion = INVERSION_OFF;
+			break;
+		case 1:
+			c->inversion = INVERSION_ON;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid inversion\n",
+					__func__);
+		}
+
+		switch ((buf[2] >> 0) & 0x03) {
+		case 0:
+			c->rolloff = ROLLOFF_35;
+			break;
+		case 1:
+			c->rolloff = ROLLOFF_25;
+			break;
+		case 2:
+			c->rolloff = ROLLOFF_20;
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid rolloff\n",
+					__func__);
+		}
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = m88ds3103_rd_regs(priv, 0x6d, buf, 2);
+	if (ret)
+		goto err;
+
+	c->symbol_rate = 1ull * ((buf[1] << 8) | (buf[0] << 0)) *
+			M88DS3103_MCLK_KHZ * 1000 / 0x10000;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i, tmp;
+	u8 buf[3];
+	u16 noise, signal;
+	u32 noise_tot, signal_tot;
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	/* reports SNR in resolution of 0.1 dB */
+
+	/* more iterations for more accurate estimation */
+	#define M88DS3103_SNR_ITERATIONS 3
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		tmp = 0;
+
+		for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
+			ret = m88ds3103_rd_reg(priv, 0xff, &buf[0]);
+			if (ret)
+				goto err;
+
+			tmp += buf[0];
+		}
+
+		/* use of one register limits max value to 15 dB */
+		/* SNR(X) dB = 10 * ln(X) / ln(10) dB */
+		tmp = DIV_ROUND_CLOSEST(tmp, 8 * M88DS3103_SNR_ITERATIONS);
+		if (tmp)
+			*snr = 100ul * intlog2(tmp) / intlog2(10);
+		else
+			*snr = 0;
+		break;
+	case SYS_DVBS2:
+		noise_tot = 0;
+		signal_tot = 0;
+
+		for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
+			ret = m88ds3103_rd_regs(priv, 0x8c, buf, 3);
+			if (ret)
+				goto err;
+
+			noise = buf[1] << 6;    /* [13:6] */
+			noise |= buf[0] & 0x3f; /*  [5:0] */
+			noise >>= 2;
+			signal = buf[2] * buf[2];
+			signal >>= 1;
+
+			noise_tot += noise;
+			signal_tot += signal;
+		}
+
+		noise = noise_tot / M88DS3103_SNR_ITERATIONS;
+		signal = signal_tot / M88DS3103_SNR_ITERATIONS;
+
+		/* SNR(X) dB = 10 * log10(X) dB */
+		if (signal > noise) {
+			tmp = signal / noise;
+			*snr = 100ul * intlog10(tmp) / (1 << 24);
+		} else
+			*snr = 0;
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+
+static int m88ds3103_set_tone(struct dvb_frontend *fe,
+	fe_sec_tone_mode_t fe_sec_tone_mode)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	int ret;
+	u8 u8tmp, tone, reg_a1_mask;
+	dev_dbg(&priv->i2c->dev, "%s: fe_sec_tone_mode=%d\n", __func__,
+			fe_sec_tone_mode);
+
+	if (!priv->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	switch (fe_sec_tone_mode) {
+	case SEC_TONE_ON:
+		tone = 0;
+		reg_a1_mask = 0x87;
+		break;
+	case SEC_TONE_OFF:
+		tone = 1;
+		reg_a1_mask = 0x00;
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_tone_mode\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	u8tmp = tone << 7 | priv->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	if (ret)
+		goto err;
+
+	u8tmp = 1 << 2;
+	ret = m88ds3103_wr_reg_mask(priv, 0xa1, u8tmp, reg_a1_mask);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
+		struct dvb_diseqc_master_cmd *diseqc_cmd)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	int ret, i;
+	u8 u8tmp;
+	dev_dbg(&priv->i2c->dev, "%s: msg=%*ph\n", __func__,
+			diseqc_cmd->msg_len, diseqc_cmd->msg);
+
+	if (!priv->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	if (diseqc_cmd->msg_len < 3 || diseqc_cmd->msg_len > 6) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	u8tmp = priv->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_regs(priv, 0xa3, diseqc_cmd->msg,
+			diseqc_cmd->msg_len);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg(priv, 0xa1,
+			(diseqc_cmd->msg_len - 1) << 3 | 0x07);
+	if (ret)
+		goto err;
+
+	/* DiSEqC message typical period is 54 ms */
+	usleep_range(40000, 60000);
+
+	/* wait DiSEqC TX ready */
+	for (i = 20, u8tmp = 1; i && u8tmp; i--) {
+		usleep_range(5000, 10000);
+
+		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
+		if (ret)
+			goto err;
+	}
+
+	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+
+	if (i == 0) {
+		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+
+		ret = m88ds3103_wr_reg_mask(priv, 0xa1, 0x40, 0xc0);
+		if (ret)
+			goto err;
+	}
+
+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, 0x80, 0xc0);
+	if (ret)
+		goto err;
+
+	if (i == 0) {
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
+	fe_sec_mini_cmd_t fe_sec_mini_cmd)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	int ret, i;
+	u8 u8tmp, burst;
+	dev_dbg(&priv->i2c->dev, "%s: fe_sec_mini_cmd=%d\n", __func__,
+			fe_sec_mini_cmd);
+
+	if (!priv->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	u8tmp = priv->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	if (ret)
+		goto err;
+
+	switch (fe_sec_mini_cmd) {
+	case SEC_MINI_A:
+		burst = 0x02;
+		break;
+	case SEC_MINI_B:
+		burst = 0x01;
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_mini_cmd\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = m88ds3103_wr_reg(priv, 0xa1, burst);
+	if (ret)
+		goto err;
+
+	/* DiSEqC ToneBurst period is 12.5 ms */
+	usleep_range(11000, 20000);
+
+	/* wait DiSEqC TX ready */
+	for (i = 5, u8tmp = 1; i && u8tmp; i--) {
+		usleep_range(800, 2000);
+
+		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
+		if (ret)
+			goto err;
+	}
+
+	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+
+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, 0x80, 0xc0);
+	if (ret)
+		goto err;
+
+	if (i == 0) {
+		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int m88ds3103_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *s)
+{
+	s->min_delay_ms = 3000;
+
+	return 0;
+}
+
+static u32 m88ds3103_tuner_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static int m88ds3103_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
+		struct i2c_msg msg[], int num)
+{
+	struct m88ds3103_priv *priv = i2c_get_adapdata(i2c_adap);
+	int ret;
+	struct i2c_msg gate_open_msg[1] = {
+		{
+			.addr = priv->cfg->i2c_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = "\x03\x11",
+		}
+	};
+	dev_dbg(&priv->i2c->dev, "%s: num=%d\n", __func__, num);
+
+	mutex_lock(&priv->i2c_mutex);
+
+	/* open i2c-gate */
+	ret = i2c_transfer(priv->i2c, gate_open_msg, 1);
+	if (ret != 1) {
+		mutex_unlock(&priv->i2c_mutex);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c wr failed=%d\n",
+				KBUILD_MODNAME, ret);
+		ret = -EREMOTEIO;
+		goto err;
+	}
+
+	ret = i2c_transfer(priv->i2c, msg, num);
+	mutex_unlock(&priv->i2c_mutex);
+	if (ret < 0)
+		dev_warn(&priv->i2c->dev, "%s: i2c failed=%d\n",
+				KBUILD_MODNAME, ret);
+
+	return ret;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static struct i2c_algorithm m88ds3103_tuner_i2c_algo = {
+	.master_xfer   = m88ds3103_tuner_i2c_xfer,
+	.functionality = m88ds3103_tuner_i2c_func,
+};
+
+static void m88ds3103_release(struct dvb_frontend *fe)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	i2c_del_adapter(&priv->i2c_adapter);
+	kfree(priv);
+}
+
+struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
+		struct i2c_adapter *i2c, struct i2c_adapter **tuner_i2c_adapter)
+{
+	int ret;
+	struct m88ds3103_priv *priv;
+	u8 chip_id, u8tmp;
+
+	/* allocate memory for the internal priv */
+	priv = kzalloc(sizeof(struct m88ds3103_priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
+
+	priv->cfg = cfg;
+	priv->i2c = i2c;
+	mutex_init(&priv->i2c_mutex);
+
+	ret = m88ds3103_rd_reg(priv, 0x01, &chip_id);
+	if (ret)
+		goto err;
+
+	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+
+	switch (chip_id) {
+	case 0xd0:
+		break;
+	default:
+		goto err;
+	}
+
+	switch (priv->cfg->clock_out) {
+	case M88DS3103_CLOCK_OUT_DISABLED:
+		u8tmp = 0x80;
+		break;
+	case M88DS3103_CLOCK_OUT_ENABLED:
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_CLOCK_OUT_ENABLED_DIV2:
+		u8tmp = 0x10;
+		break;
+	default:
+		goto err;
+	}
+
+	ret = m88ds3103_wr_reg(priv, 0x29, u8tmp);
+	if (ret)
+		goto err;
+
+	/* sleep */
+	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x00, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x01, 0x01);
+	if (ret)
+		goto err;
+
+	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x10, 0x10);
+	if (ret)
+		goto err;
+
+	/* create dvb_frontend */
+	memcpy(&priv->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
+	priv->fe.demodulator_priv = priv;
+
+	/* create i2c adapter for tuner */
+	strlcpy(priv->i2c_adapter.name, KBUILD_MODNAME,
+			sizeof(priv->i2c_adapter.name));
+	priv->i2c_adapter.algo = &m88ds3103_tuner_i2c_algo;
+	priv->i2c_adapter.algo_data = NULL;
+	i2c_set_adapdata(&priv->i2c_adapter, priv);
+	ret = i2c_add_adapter(&priv->i2c_adapter);
+	if (ret) {
+		dev_err(&i2c->dev, "%s: i2c bus could not be initialized\n",
+				KBUILD_MODNAME);
+		goto err;
+	}
+	*tuner_i2c_adapter = &priv->i2c_adapter;
+
+	return &priv->fe;
+err:
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(priv);
+	return NULL;
+}
+EXPORT_SYMBOL(m88ds3103_attach);
+
+static struct dvb_frontend_ops m88ds3103_ops = {
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
+	.info = {
+		.name = "Montage M88DS3103",
+		.frequency_min =  950000,
+		.frequency_max = 2150000,
+		.frequency_tolerance = 5000,
+		.symbol_rate_min =  1000000,
+		.symbol_rate_max = 45000000,
+		.caps = FE_CAN_INVERSION_AUTO |
+			FE_CAN_FEC_1_2 |
+			FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_4_5 |
+			FE_CAN_FEC_5_6 |
+			FE_CAN_FEC_6_7 |
+			FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_8_9 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK |
+			FE_CAN_RECOVER |
+			FE_CAN_2G_MODULATION
+	},
+
+	.release = m88ds3103_release,
+
+	.get_tune_settings = m88ds3103_get_tune_settings,
+
+	.init = m88ds3103_init,
+	.sleep = m88ds3103_sleep,
+
+	.set_frontend = m88ds3103_set_frontend,
+	.get_frontend = m88ds3103_get_frontend,
+
+	.read_status = m88ds3103_read_status,
+	.read_snr = m88ds3103_read_snr,
+
+	.diseqc_send_master_cmd = m88ds3103_diseqc_send_master_cmd,
+	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
+
+	.set_tone = m88ds3103_set_tone,
+};
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("Montage M88DS3103 DVB-S/S2 demodulator driver");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(M88DS3103_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
new file mode 100644
index 0000000..287d62a
--- /dev/null
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -0,0 +1,108 @@
+/*
+ * Montage M88DS3103 demodulator driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
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
+#ifndef M88DS3103_H
+#define M88DS3103_H
+
+#include <linux/dvb/frontend.h>
+
+struct m88ds3103_config {
+	/*
+	 * I2C address
+	 * 0x68, ...
+	 */
+	u8 i2c_addr;
+
+	/*
+	 * clock
+	 * 27000000
+	 */
+	u32 clock;
+
+	/*
+	 * max bytes I2C provider is asked to write at once
+	 * Note: Buffer is taken from the stack currently!
+	 * Value must be set.
+	 * 33, 65, ...
+	 */
+	u16 i2c_wr_max;
+
+	/*
+	 * TS output mode
+	 */
+#define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
+#define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
+#define M88DS3103_TS_PARALLEL           2 /* 24 MHz, normal */
+#define M88DS3103_TS_PARALLEL_12        3 /* 12 MHz */
+#define M88DS3103_TS_PARALLEL_16        4 /* 16 MHz */
+#define M88DS3103_TS_PARALLEL_19_2      5 /* 19.2 MHz */
+#define M88DS3103_TS_CI                 6 /* 6 MHz */
+	u8 ts_mode;
+
+	/*
+	 * spectrum inversion
+	 */
+	u8 spec_inv:1;
+
+	/*
+	 * AGC polarity
+	 */
+	u8 agc_inv:1;
+
+	/*
+	 * clock output
+	 */
+#define M88DS3103_CLOCK_OUT_DISABLED        0
+#define M88DS3103_CLOCK_OUT_ENABLED         1
+#define M88DS3103_CLOCK_OUT_ENABLED_DIV2    2
+	u8 clock_out;
+
+	/*
+	 * DiSEqC envelope mode
+	 */
+	u8 envelope_mode:1;
+
+	u8 agc;
+};
+
+/*
+ * Driver implements own I2C-adapter for tuner I2C access. That's since chip
+ * has I2C-gate control which closes gate automatically after I2C transfer.
+ * Using own I2C adapter we can workaround that.
+ */
+
+#if defined(CONFIG_DVB_M88DS3103) || \
+		(defined(CONFIG_DVB_M88DS3103_MODULE) && defined(MODULE))
+extern struct dvb_frontend *m88ds3103_attach(
+		const struct m88ds3103_config *config,
+		struct i2c_adapter *i2c,
+		struct i2c_adapter **tuner_i2c);
+#else
+static inline struct dvb_frontend *m88ds3103_attach(
+		const struct m88ds3103_config *config,
+		struct i2c_adapter *i2c,
+		struct i2c_adapter **tuner_i2c)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
new file mode 100644
index 0000000..f3d0867
--- /dev/null
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -0,0 +1,218 @@
+/*
+ * Montage M88DS3103 demodulator driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
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
+#ifndef M88DS3103_PRIV_H
+#define M88DS3103_PRIV_H
+
+#include "dvb_frontend.h"
+#include "m88ds3103.h"
+#include "dvb_math.h"
+#include <linux/firmware.h>
+
+#define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
+#define M88DS3103_MCLK_KHZ 96000
+
+struct m88ds3103_priv {
+	struct i2c_adapter *i2c;
+	/* mutex needed due to own tuner I2C adapter */
+	struct mutex i2c_mutex;
+	const struct m88ds3103_config *cfg;
+	struct dvb_frontend fe;
+	fe_delivery_system_t delivery_system;
+	fe_status_t fe_status;
+	bool warm; /* FW running */
+	struct i2c_adapter i2c_adapter;
+};
+
+struct m88ds3103_reg_val {
+	u8 reg;
+	u8 val;
+};
+
+static const struct m88ds3103_reg_val m88ds3103_dvbs_init_reg_vals[] = {
+	{0x23, 0x07},
+	{0x08, 0x03},
+	{0x0c, 0x02},
+	{0x21, 0x54},
+	{0x25, 0x8a},
+	{0x27, 0x31},
+	{0x30, 0x08},
+	{0x31, 0x40},
+	{0x32, 0x32},
+	{0x33, 0x35},
+	{0x35, 0xff},
+	{0x3a, 0x00},
+	{0x37, 0x10},
+	{0x38, 0x10},
+	{0x39, 0x02},
+	{0x42, 0x60},
+	{0x4a, 0x80},
+	{0x4b, 0x04},
+	{0x4d, 0x91},
+	{0x5d, 0xc8},
+	{0x50, 0x36},
+	{0x51, 0x36},
+	{0x52, 0x36},
+	{0x53, 0x36},
+	{0x63, 0x0f},
+	{0x64, 0x30},
+	{0x65, 0x40},
+	{0x68, 0x26},
+	{0x69, 0x4c},
+	{0x70, 0x20},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x40},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x60},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x80},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0xa0},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x1f},
+	{0x76, 0x38},
+	{0x77, 0xa6},
+	{0x78, 0x0c},
+	{0x79, 0x80},
+	{0x7f, 0x14},
+	{0x7c, 0x00},
+	{0xae, 0x82},
+	{0x80, 0x64},
+	{0x81, 0x66},
+	{0x82, 0x44},
+	{0x85, 0x04},
+	{0xcd, 0xf4},
+	{0x90, 0x33},
+	{0xa0, 0x44},
+	{0xc0, 0x08},
+	{0xc3, 0x10},
+	{0xc4, 0x08},
+	{0xc5, 0xf0},
+	{0xc6, 0xff},
+	{0xc7, 0x00},
+	{0xc8, 0x1a},
+	{0xc9, 0x80},
+	{0xe0, 0xf8},
+	{0xe6, 0x8b},
+	{0xd0, 0x40},
+	{0xf8, 0x20},
+	{0xfa, 0x0f},
+	{0x00, 0x00},
+	{0xbd, 0x01},
+	{0xb8, 0x00},
+};
+
+static const struct m88ds3103_reg_val m88ds3103_dvbs2_init_reg_vals[] = {
+	{0x23, 0x07},
+	{0x08, 0x07},
+	{0x0c, 0x02},
+	{0x21, 0x54},
+	{0x25, 0x8a},
+	{0x27, 0x31},
+	{0x30, 0x08},
+	{0x32, 0x32},
+	{0x33, 0x35},
+	{0x35, 0xff},
+	{0x3a, 0x00},
+	{0x37, 0x10},
+	{0x38, 0x10},
+	{0x39, 0x02},
+	{0x42, 0x60},
+	{0x4a, 0x80},
+	{0x4b, 0x04},
+	{0x4d, 0x91},
+	{0x5d, 0xc8},
+	{0x50, 0x36},
+	{0x51, 0x36},
+	{0x52, 0x36},
+	{0x53, 0x36},
+	{0x63, 0x0f},
+	{0x64, 0x10},
+	{0x65, 0x20},
+	{0x68, 0x46},
+	{0x69, 0xcd},
+	{0x70, 0x20},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x40},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x60},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x80},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0xa0},
+	{0x71, 0x70},
+	{0x72, 0x04},
+	{0x73, 0x00},
+	{0x70, 0x1f},
+	{0x76, 0x38},
+	{0x77, 0xa6},
+	{0x78, 0x0c},
+	{0x79, 0x80},
+	{0x7f, 0x14},
+	{0x85, 0x08},
+	{0xcd, 0xf4},
+	{0x90, 0x33},
+	{0x86, 0x00},
+	{0x87, 0x0f},
+	{0x89, 0x00},
+	{0x8b, 0x44},
+	{0x8c, 0x66},
+	{0x9d, 0xc1},
+	{0x8a, 0x10},
+	{0xad, 0x40},
+	{0xa0, 0x44},
+	{0xc0, 0x08},
+	{0xc1, 0x10},
+	{0xc2, 0x08},
+	{0xc3, 0x10},
+	{0xc4, 0x08},
+	{0xc5, 0xf0},
+	{0xc6, 0xff},
+	{0xc7, 0x00},
+	{0xc8, 0x1a},
+	{0xc9, 0x80},
+	{0xca, 0x23},
+	{0xcb, 0x24},
+	{0xcc, 0xf4},
+	{0xce, 0x74},
+	{0x00, 0x00},
+	{0xbd, 0x01},
+	{0xb8, 0x00},
+};
+
+#endif
-- 
1.8.4.2

