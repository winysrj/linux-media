Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39797 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756192Ab2EEQyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 12:54:15 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Thomas Mair <thomas.mair86@googlemail.com>
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
Date: Sat, 5 May 2012 18:54:08 +0200
References: <4F9E5D91.30503@gmail.com> <4FA47568.5070906@gmail.com> <CAKZ=SG_ZEM7n8Xifeq_GWGfVzJP=6GCdfep0fp=eHyzA7HQ-xw@mail.gmail.com>
In-Reply-To: <CAKZ=SG_ZEM7n8Xifeq_GWGfVzJP=6GCdfep0fp=eHyzA7HQ-xw@mail.gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051854.08736.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, 5. Mai 2012 schrieben Sie:
> I am currently finishing up the work at the demod driver and will
> probably send a new version to the list tomorrow.
> 
> As I don't own a device with a different tuner than the fc0012 I will
> include an error message about the unsupported tuner and print its
> type. So It is easier to get the information about the tuners.
> 
> Right now I am writing the signal_strength callback and stumbled upon
> the following problem:
> The signal strength is read from the fc0012 tuner (only for fc0012).
> How should the driver implement this situation. Is there a callback I
> could implement within the tuner or should I just read the tuner
> registers from the demodulator?

I would recommend implementing the function into the demod driver. Please see an example implementation 
attached. To be able to decide which tuner is in use, I had to move the definition of enum rtl28xxu_tuner out of 
rtl28xxu.h into an own file. By the way, what is the sense behind naming the tuners after the demodulator? I 
think a more appropriate naming would be TUNER_RTL28XX_...

p.s.: I have written a tuner driver for the fc0013, which I hope to be able to send to the mailing list later this 
weekend.

Cheers,
Hans-Frieder

> [...]

and here is the patch:
--- a/drivers/media/dvb/frontends/rtl2832.c	2012-05-01 12:28:26.407776103 +0200
+++ b/drivers/media/dvb/frontends/rtl2832.c	2012-05-05 18:35:28.778377211 +0200
@@ -19,10 +19,11 @@
  */
 
 #include "rtl2832_priv.h"
+#include "rtl28xxu_tuners.h"
 
 
 
-int rtl2832_debug = 1;
+int rtl2832_debug;
 module_param_named(debug, rtl2832_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
@@ -391,6 +392,58 @@ err:
 
 }
 
+static int rtl2832_wr_i2c(struct rtl2832_priv *priv, u8 addr, u8 reg, u8 *val, int len)
+{
+	int ret;
+	u8 buf[1+len];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = addr,
+			.flags = 0,
+			.len = 1+len,
+			.buf = buf,
+		}
+	};
+
+	buf[0] = reg;
+	memcpy(&buf[1], val, len);
+
+	ret = i2c_transfer(priv->i2c, msg, 1);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+	return ret;
+}
+
+static int rtl2832_rd_i2c(struct rtl2832_priv *priv, u8 addr, u8 reg, u8 *val, int len)
+{
+	int ret;
+	struct i2c_msg msg[2] = {
+		{
+			.addr = addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &reg,
+		}, {
+			.addr = addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = val,
+		}
+	};
+
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	if (ret == 2) {
+		ret = 0;
+	} else {
+		warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+	return ret;
+}
 
 static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
@@ -683,7 +736,9 @@ static int rtl2832_read_status(struct dv
 	*status = 0;
 
 
+#if 0
 	info("%s", __func__);
+#endif
 	if (priv->sleeping)
 		return 0;
 
@@ -707,32 +762,198 @@ err:
 	return ret;
 }
 
+#define RTL2832_CE_EST_EVM_MAX_VALUE 65535
+#define RTL2832_SNR_FRAC_BIT_NUM 10
+#define RTL2832_SNR_DB_DEN 3402
+
 static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	info("%s", __func__);
-	*snr = 0;
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret;
+	u32 fsm_stage, ce_est_evm, constellation, hierarchy;
+	int num;
+	static const int snr_db_num_const[3][4] =
+	{
+		{122880,        122880,         122880,         122880,   },
+		{146657,        146657,         156897,         171013,   },
+		{167857,        167857,         173127,         181810,   },
+	};
+
+	ret = rtl2832_rd_demod_reg(priv, DVBT_FSM_STAGE, &fsm_stage);
+	if (ret)
+		goto err;
+
+	if (fsm_stage < 10)
+		ce_est_evm = RTL2832_CE_EST_EVM_MAX_VALUE;
+	else {
+		ret = rtl2832_rd_demod_reg(priv, DVBT_CE_EST_EVM, &ce_est_evm);
+		if (ret)
+			goto err;
+	}
+
+	ret = rtl2832_rd_demod_reg(priv, DVBT_RX_CONSTEL, &constellation);
+	if (ret)
+		goto err;
+	if (constellation > 2)
+		goto err;
+
+	ret = rtl2832_rd_demod_reg(priv, DVBT_RX_HIER, &hierarchy);
+	if (ret)
+		goto err;
+	if (hierarchy > 3)
+		goto err;
+
+	num = snr_db_num_const[constellation][hierarchy] -
+		10*ilog2(ce_est_evm*ce_est_evm)*0x200;
+	if (num < 0)
+		*snr = 0;
+	else
+		*snr = 256 * num / RTL2832_SNR_DB_DEN;
 	return 0;
+
+err:
+	info("%s: failed=%d", __func__, ret);
+	return ret;
 }
 
 static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	info("%s", __func__);
-	*ber = 0;
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	u32 tmp;
+	int ret;
+
+	ret = rtl2832_rd_demod_reg(priv, DVBT_RSD_BER_EST, &tmp);
+	if (ret)
+		goto err;
+	*ber = tmp;
 	return 0;
+
+err:
+	info("%s: failed=%d", __func__, ret);
+	*ber = 0;
+	return ret;
 }
 
 static int rtl2832_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	info("%s", __func__);
 	*ucblocks = 0;
 	return 0;
 }
 
-static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+#define INPUT_ADC_LEVEL   -8
+
+const int fc001x_lna_gain_table[] = {
+	/* low gain */
+	-63, -58, -99, -73,
+	-63, -65, -54, -60,
+	/* middle gain */
+	 71,  70,  68,  67,
+	 65,  63,  61,  58,
+	/* high gain */
+	197, 191, 188, 186,
+	184, 182, 181, 179,
+};
+
+static int rtl2832_fc001x_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	info("%s", __func__);
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret;
+	u8 val, reg;
+	int int_temp, lna_gain, int_lna, tot_agc_gain, power;
+
+	if (priv->tuner == TUNER_RTL2832_FC0013)
+		reg = 0x13;
+	else
+		reg = 0x12;
+
+	ret = rtl2832_i2c_gate_ctrl(fe, true);
+	if (ret)
+		goto err;
+
+	val = 0x00;
+	ret = rtl2832_wr_i2c(priv, 0xc6 >> 1, reg, &val, 1);
+	if (ret) {
+		err("%s: rtl2832_wr_i2c failed, ret=%d", __func__, ret);
+		goto err_gate;
+	} else {
+		ret = rtl2832_rd_i2c(priv, 0xc6 >> 1, reg, &val, 1);
+		if (ret)
+			err("%s: rtl2832_rd_i2c failed, ret=%d", __func__, ret);
+//		info("fc001x read 0x12: 0x%02x", val);
+		int_temp = val;
+
+		ret = rtl2832_rd_i2c(priv, 0xc6 >> 1, reg + 1, &val, 1);
+		if (ret)
+			err("%s: rtl2832_rd_i2c failed, ret=%d", __func__, ret);
+//		info("fc001x read 0x13: 0x%02x", val);
+		lna_gain = val & 0x1f;
+	}
+
+	ret = rtl2832_i2c_gate_ctrl(fe, false);
+	if (ret)
+		goto err;
+
+	if (lna_gain < ARRAY_SIZE(fc001x_lna_gain_table)) {
+		int_lna = fc001x_lna_gain_table[lna_gain];
+		tot_agc_gain = (abs((int_temp >> 5) - 7) -2) * 2 +
+			(int_temp & 0x1f) * 2;
+		power = INPUT_ADC_LEVEL - tot_agc_gain - int_lna / 10;
+		
+		if (power >= 45)
+			*strength = 255;	/* 100% */
+		else if (power < -95)
+			*strength = 0;
+		else
+			*strength = (power + 95) * 255 / 140;
+		*strength |= *strength << 8;
+	} else {
+		ret = -1;
+		goto err;
+	}
+
+	return 0;
+
+err_gate:
+	ret = rtl2832_i2c_gate_ctrl(fe, false);
+err:
 	*strength = 0;
+	return ret;
+}
+
+static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret, if_agc;
+	u32 fsm_stage, if_agc_raw;
+
+	if ((priv->tuner == TUNER_RTL2832_FC0012) ||
+	    (priv->tuner == TUNER_RTL2832_FC0013))
+		return rtl2832_fc001x_read_signal_strength(fe, strength);
+
+	ret = rtl2832_rd_demod_reg(priv, DVBT_FSM_STAGE, &fsm_stage);
+	if (ret)
+		goto err;
+	if (fsm_stage < 10)
+		*strength = 0;
+	else {
+		/* if_agc is read as a 10bit binary */
+		ret = rtl2832_rd_demod_reg(priv, DVBT_IF_AGC_VAL, &if_agc_raw);
+		if (ret)
+			goto err;
+	info("%s: if_agc_raw: 0x%04x", __func__, if_agc_raw);
+		if (if_agc_raw < (1 << 9))
+			if_agc = if_agc_raw;
+		else {
+			if_agc = -(~(if_agc_raw-1) & 0x1ff);
+		}
+		*strength = 55 - if_agc / 182;
+		*strength |= *strength << 8;
+	}
+
 	return 0;
+err:
+	info("%s: failed=%d", __func__, ret);
+	return ret;
 }
 
 static struct dvb_frontend_ops rtl2832_ops;
--- /dev/null	2012-05-05 09:43:48.063333275 +0200
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h	2012-05-02 22:43:24.446371878 +0200
@@ -0,0 +1,44 @@
+/*
+ * Realtek RTL28xxU DVB USB driver
+ *
+ * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
+ * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
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
+#ifndef RTL28XXU_TUNERS_H
+#define RTL28XXU_TUNERS_H
+
+enum rtl28xxu_tuner {
+	TUNER_NONE,
+
+	TUNER_RTL2830_QT1010,
+	TUNER_RTL2830_MT2060,
+	TUNER_RTL2830_MXL5005S,
+
+	TUNER_RTL2832_MT2266,
+	TUNER_RTL2832_FC2580,
+	TUNER_RTL2832_MT2063,
+	TUNER_RTL2832_MAX3543,
+	TUNER_RTL2832_TUA9001,
+	TUNER_RTL2832_MXL5007T,
+	TUNER_RTL2832_FC0012,
+	TUNER_RTL2832_E4000,
+	TUNER_RTL2832_TDA18272,
+	TUNER_RTL2832_FC0013,
+};
+
+#endif
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.h	2012-02-29 05:45:38.000000000 +0100
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.h	2012-05-02 22:43:53.002893237 +0200
@@ -84,25 +84,6 @@ enum rtl28xxu_chip_id {
 	CHIP_ID_RTL2832U,
 };
 
-enum rtl28xxu_tuner {
-	TUNER_NONE,
-
-	TUNER_RTL2830_QT1010,
-	TUNER_RTL2830_MT2060,
-	TUNER_RTL2830_MXL5005S,
-
-	TUNER_RTL2832_MT2266,
-	TUNER_RTL2832_FC2580,
-	TUNER_RTL2832_MT2063,
-	TUNER_RTL2832_MAX3543,
-	TUNER_RTL2832_TUA9001,
-	TUNER_RTL2832_MXL5007T,
-	TUNER_RTL2832_FC0012,
-	TUNER_RTL2832_E4000,
-	TUNER_RTL2832_TDA18272,
-	TUNER_RTL2832_FC0013,
-};
-
 struct rtl28xxu_req {
 	u16 value;
 	u16 index;
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c      2012-05-01 12:28:26.407776103 +0200
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c  2012-05-05 14:25:04.212866649 +0200
@@ -21,6 +21,7 @@
  */
 
 #include "rtl28xxu.h"
+#include "rtl28xxu_tuners.h"
 
 #include "rtl2830.h"
 #include "rtl2832.h"



Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
