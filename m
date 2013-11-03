Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51002 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KCA2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:28:54 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclYi-0001rO-FT
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:28:52 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id B469E140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:28:50 +0100 (CET)
Date: Sun, 3 Nov 2013 01:28:50 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/12] stv0367dd: Support for STV 0367 DVB-C/T (DD)
 demodulator
Message-ID: <20131103002850.GG7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for the STV 0367 DVB-C/T demodulator used by recent
Digital Devices hardware. This will allow update of ddbridge driver
to support newer devices like DVBCT V6.1 DVB adapter.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/dvb-frontends/Kconfig          |    9 +
 drivers/media/dvb-frontends/Makefile         |    1 +
 drivers/media/dvb-frontends/stv0367dd.c      | 2329 +++++++++++++++++
 drivers/media/dvb-frontends/stv0367dd.h      |   48 +
 drivers/media/dvb-frontends/stv0367dd_regs.h | 3442 ++++++++++++++++++++++++++
 5 files changed, 5829 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/stv0367dd.c
 create mode 100644 drivers/media/dvb-frontends/stv0367dd.h
 create mode 100644 drivers/media/dvb-frontends/stv0367dd_regs.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 6f99eb8..7cac015 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -56,6 +56,15 @@ config DVB_TDA18271C2DD
 
 	  Say Y when you want to support this tuner.
 
+config DVB_STV0367DD
+        tristate "STV 0367 (DD)"
+        depends on DVB_CORE && I2C
+        default m if DVB_FE_CUSTOMISE
+        help
+          STV 0367 DVB-C/T demodulator (Digital Devices driver).
+
+          Say Y when you want to support this frontend.
+
 comment "DVB-S (satellite) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index f9cb43d..de100f1 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_DVB_STV0367) += stv0367.o
 obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
 obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
+obj-$(CONFIG_DVB_STV0367DD) += stv0367dd.o
 obj-$(CONFIG_DVB_IT913X_FE) += it913x-fe.o
 obj-$(CONFIG_DVB_A8293) += a8293.o
 obj-$(CONFIG_DVB_TDA10071) += tda10071.o
diff --git a/drivers/media/dvb-frontends/stv0367dd.c b/drivers/media/dvb-frontends/stv0367dd.c
new file mode 100644
index 0000000..37c8e2d
--- /dev/null
+++ b/drivers/media/dvb-frontends/stv0367dd.c
@@ -0,0 +1,2329 @@
+/*
+ *  stv0367dd.c: STV0367 DVB-C/T demodulator driver
+ *
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/version.h>
+#include <asm/div64.h>
+
+#include "dvb_frontend.h"
+#include "stv0367dd.h"
+#include "stv0367dd_regs.h"
+
+enum omode { OM_NONE, OM_DVBT, OM_DVBC, OM_QAM_ITU_C };
+enum {  QAM_MOD_QAM4 = 0,
+	QAM_MOD_QAM16,
+	QAM_MOD_QAM32,
+	QAM_MOD_QAM64,
+	QAM_MOD_QAM128,
+	QAM_MOD_QAM256,
+	QAM_MOD_QAM512,
+	QAM_MOD_QAM1024
+};
+
+enum {QAM_SPECT_NORMAL, QAM_SPECT_INVERTED };
+
+enum {
+	QAM_FEC_A = 1,					/* J83 Annex A */
+	QAM_FEC_B = (1<<1),				/* J83 Annex B */
+	QAM_FEC_C = (1<<2)				/* J83 Annex C */
+};
+
+enum EDemodState { Off, QAMSet, OFDMSet, QAMStarted, OFDMStarted };
+
+struct stv_state {
+#ifdef USE_API3
+	struct dvb_frontend c_frontend;
+	struct dvb_frontend t_frontend;
+#else
+	struct dvb_frontend frontend;
+#endif
+	fe_modulation_t modulation;
+	u32 symbol_rate;
+	u32 bandwidth;
+	struct device *dev;
+
+	struct i2c_adapter *i2c;
+	u8     adr;
+	void  *priv;
+
+	struct mutex mutex;
+	struct mutex ctlock;
+
+	u32 master_clock;
+	u32 adc_clock;
+	u8 ID;
+	u8 I2CRPT;
+	u32 omode;
+	u8  qam_inversion;
+
+	s32 IF;
+
+	s32    m_FECTimeOut;
+	s32    m_DemodTimeOut;
+	s32    m_SignalTimeOut;
+	s32    m_DemodLockTime;
+	s32    m_FFTTimeOut;
+	s32    m_TSTimeOut;
+
+	bool    m_bFirstTimeLock;
+
+	u8    m_Save_QAM_AGC_CTL;
+
+	enum EDemodState demod_state;
+
+	u8    m_OFDM_FFTMode;          // 0 = 2k, 1 = 8k, 2 = 4k
+	u8    m_OFDM_Modulation;   //
+	u8    m_OFDM_FEC;          //
+	u8    m_OFDM_Guard;
+
+	u32   ucblocks;
+	u32   ber;
+};
+
+struct init_table {
+	u16  adr;
+	u8   data;
+};
+
+struct init_table base_init[] = {
+	{ R367_IOCFG0,     0x80 },
+	{ R367_DAC0R,      0x00 },
+	{ R367_IOCFG1,     0x00 },
+	{ R367_DAC1R,      0x00 },
+	{ R367_IOCFG2,     0x00 },
+	{ R367_SDFR,       0x00 },
+	{ R367_AUX_CLK,    0x00 },
+	{ R367_FREESYS1,   0x00 },
+	{ R367_FREESYS2,   0x00 },
+	{ R367_FREESYS3,   0x00 },
+	{ R367_GPIO_CFG,   0x55 },
+	{ R367_GPIO_CMD,   0x01 },
+	{ R367_TSTRES,     0x00 },
+	{ R367_ANACTRL,    0x00 },
+	{ R367_TSTBUS,     0x00 },
+	{ R367_RF_AGC2,    0x20 },
+	{ R367_ANADIGCTRL, 0x0b },
+	{ R367_PLLMDIV,    0x01 },
+	{ R367_PLLNDIV,    0x08 },
+	{ R367_PLLSETUP,   0x18 },
+	{ R367_DUAL_AD12,  0x04 },
+	{ R367_TSTBIST,    0x00 },
+	{ 0x0000,          0x00 }
+};
+
+struct init_table qam_init[] = {
+	{ R367_QAM_CTRL_1,                  0x06 },// Orginal 0x04
+	{ R367_QAM_CTRL_2,                  0x03 },
+	{ R367_QAM_IT_STATUS1,              0x2b },
+	{ R367_QAM_IT_STATUS2,              0x08 },
+	{ R367_QAM_IT_EN1,                  0x00 },
+	{ R367_QAM_IT_EN2,                  0x00 },
+	{ R367_QAM_CTRL_STATUS,             0x04 },
+	{ R367_QAM_TEST_CTL,                0x00 },
+	{ R367_QAM_AGC_CTL,                 0x73 },
+	{ R367_QAM_AGC_IF_CFG,              0x50 },
+	{ R367_QAM_AGC_RF_CFG,              0x02 },// RF Freeze
+	{ R367_QAM_AGC_PWM_CFG,             0x03 },
+	{ R367_QAM_AGC_PWR_REF_L,           0x5a },
+	{ R367_QAM_AGC_PWR_REF_H,           0x00 },
+	{ R367_QAM_AGC_RF_TH_L,             0xff },
+	{ R367_QAM_AGC_RF_TH_H,             0x07 },
+	{ R367_QAM_AGC_IF_LTH_L,            0x00 },
+	{ R367_QAM_AGC_IF_LTH_H,            0x08 },
+	{ R367_QAM_AGC_IF_HTH_L,            0xff },
+	{ R367_QAM_AGC_IF_HTH_H,            0x07 },
+	{ R367_QAM_AGC_PWR_RD_L,            0xa0 },
+	{ R367_QAM_AGC_PWR_RD_M,            0xe9 },
+	{ R367_QAM_AGC_PWR_RD_H,            0x03 },
+	{ R367_QAM_AGC_PWM_IFCMD_L,         0xe4 },
+	{ R367_QAM_AGC_PWM_IFCMD_H,         0x00 },
+	{ R367_QAM_AGC_PWM_RFCMD_L,         0xff },
+	{ R367_QAM_AGC_PWM_RFCMD_H,         0x07 },
+	{ R367_QAM_IQDEM_CFG,               0x01 },
+	{ R367_QAM_MIX_NCO_LL,              0x22 },
+	{ R367_QAM_MIX_NCO_HL,              0x96 },
+	{ R367_QAM_MIX_NCO_HH,              0x55 },
+	{ R367_QAM_SRC_NCO_LL,              0xff },
+	{ R367_QAM_SRC_NCO_LH,              0x0c },
+	{ R367_QAM_SRC_NCO_HL,              0xf5 },
+	{ R367_QAM_SRC_NCO_HH,              0x20 },
+	{ R367_QAM_IQDEM_GAIN_SRC_L,        0x06 },
+	{ R367_QAM_IQDEM_GAIN_SRC_H,        0x01 },
+	{ R367_QAM_IQDEM_DCRM_CFG_LL,       0xfe },
+	{ R367_QAM_IQDEM_DCRM_CFG_LH,       0xff },
+	{ R367_QAM_IQDEM_DCRM_CFG_HL,       0x0f },
+	{ R367_QAM_IQDEM_DCRM_CFG_HH,       0x00 },
+	{ R367_QAM_IQDEM_ADJ_COEFF0,        0x34 },
+	{ R367_QAM_IQDEM_ADJ_COEFF1,        0xae },
+	{ R367_QAM_IQDEM_ADJ_COEFF2,        0x46 },
+	{ R367_QAM_IQDEM_ADJ_COEFF3,        0x77 },
+	{ R367_QAM_IQDEM_ADJ_COEFF4,        0x96 },
+	{ R367_QAM_IQDEM_ADJ_COEFF5,        0x69 },
+	{ R367_QAM_IQDEM_ADJ_COEFF6,        0xc7 },
+	{ R367_QAM_IQDEM_ADJ_COEFF7,        0x01 },
+	{ R367_QAM_IQDEM_ADJ_EN,            0x04 },
+	{ R367_QAM_IQDEM_ADJ_AGC_REF,       0x94 },
+	{ R367_QAM_ALLPASSFILT1,            0xc9 },
+	{ R367_QAM_ALLPASSFILT2,            0x2d },
+	{ R367_QAM_ALLPASSFILT3,            0xa3 },
+	{ R367_QAM_ALLPASSFILT4,            0xfb },
+	{ R367_QAM_ALLPASSFILT5,            0xf6 },
+	{ R367_QAM_ALLPASSFILT6,            0x45 },
+	{ R367_QAM_ALLPASSFILT7,            0x6f },
+	{ R367_QAM_ALLPASSFILT8,            0x7e },
+	{ R367_QAM_ALLPASSFILT9,            0x05 },
+	{ R367_QAM_ALLPASSFILT10,           0x0a },
+	{ R367_QAM_ALLPASSFILT11,           0x51 },
+	{ R367_QAM_TRL_AGC_CFG,             0x20 },
+	{ R367_QAM_TRL_LPF_CFG,             0x28 },
+	{ R367_QAM_TRL_LPF_ACQ_GAIN,        0x44 },
+	{ R367_QAM_TRL_LPF_TRK_GAIN,        0x22 },
+	{ R367_QAM_TRL_LPF_OUT_GAIN,        0x03 },
+	{ R367_QAM_TRL_LOCKDET_LTH,         0x04 },
+	{ R367_QAM_TRL_LOCKDET_HTH,         0x11 },
+	{ R367_QAM_TRL_LOCKDET_TRGVAL,      0x20 },
+	{ R367_QAM_IQ_QAM,			0x01 },
+	{ R367_QAM_FSM_STATE,               0xa0 },
+	{ R367_QAM_FSM_CTL,                 0x08 },
+	{ R367_QAM_FSM_STS,                 0x0c },
+	{ R367_QAM_FSM_SNR0_HTH,            0x00 },
+	{ R367_QAM_FSM_SNR1_HTH,            0x00 },
+	{ R367_QAM_FSM_SNR2_HTH,            0x00 },
+	{ R367_QAM_FSM_SNR0_LTH,            0x00 },
+	{ R367_QAM_FSM_SNR1_LTH,            0x00 },
+	{ R367_QAM_FSM_EQA1_HTH,            0x00 },
+	{ R367_QAM_FSM_TEMPO,               0x32 },
+	{ R367_QAM_FSM_CONFIG,              0x03 },
+	{ R367_QAM_EQU_I_TESTTAP_L,         0x11 },
+	{ R367_QAM_EQU_I_TESTTAP_M,         0x00 },
+	{ R367_QAM_EQU_I_TESTTAP_H,         0x00 },
+	{ R367_QAM_EQU_TESTAP_CFG,          0x00 },
+	{ R367_QAM_EQU_Q_TESTTAP_L,         0xff },
+	{ R367_QAM_EQU_Q_TESTTAP_M,         0x00 },
+	{ R367_QAM_EQU_Q_TESTTAP_H,         0x00 },
+	{ R367_QAM_EQU_TAP_CTRL,            0x00 },
+	{ R367_QAM_EQU_CTR_CRL_CONTROL_L,   0x11 },
+	{ R367_QAM_EQU_CTR_CRL_CONTROL_H,   0x05 },
+	{ R367_QAM_EQU_CTR_HIPOW_L,         0x00 },
+	{ R367_QAM_EQU_CTR_HIPOW_H,         0x00 },
+	{ R367_QAM_EQU_I_EQU_LO,            0xef },
+	{ R367_QAM_EQU_I_EQU_HI,            0x00 },
+	{ R367_QAM_EQU_Q_EQU_LO,            0xee },
+	{ R367_QAM_EQU_Q_EQU_HI,            0x00 },
+	{ R367_QAM_EQU_MAPPER,              0xc5 },
+	{ R367_QAM_EQU_SWEEP_RATE,          0x80 },
+	{ R367_QAM_EQU_SNR_LO,              0x64 },
+	{ R367_QAM_EQU_SNR_HI,              0x03 },
+	{ R367_QAM_EQU_GAMMA_LO,            0x00 },
+	{ R367_QAM_EQU_GAMMA_HI,            0x00 },
+	{ R367_QAM_EQU_ERR_GAIN,            0x36 },
+	{ R367_QAM_EQU_RADIUS,              0xaa },
+	{ R367_QAM_EQU_FFE_MAINTAP,         0x00 },
+	{ R367_QAM_EQU_FFE_LEAKAGE,         0x63 },
+	{ R367_QAM_EQU_FFE_MAINTAP_POS,     0xdf },
+	{ R367_QAM_EQU_GAIN_WIDE,           0x88 },
+	{ R367_QAM_EQU_GAIN_NARROW,         0x41 },
+	{ R367_QAM_EQU_CTR_LPF_GAIN,        0xd1 },
+	{ R367_QAM_EQU_CRL_LPF_GAIN,        0xa7 },
+	{ R367_QAM_EQU_GLOBAL_GAIN,         0x06 },
+	{ R367_QAM_EQU_CRL_LD_SEN,          0x85 },
+	{ R367_QAM_EQU_CRL_LD_VAL,          0xe2 },
+	{ R367_QAM_EQU_CRL_TFR,             0x20 },
+	{ R367_QAM_EQU_CRL_BISTH_LO,        0x00 },
+	{ R367_QAM_EQU_CRL_BISTH_HI,        0x00 },
+	{ R367_QAM_EQU_SWEEP_RANGE_LO,      0x00 },
+	{ R367_QAM_EQU_SWEEP_RANGE_HI,      0x00 },
+	{ R367_QAM_EQU_CRL_LIMITER,         0x40 },
+	{ R367_QAM_EQU_MODULUS_MAP,         0x90 },
+	{ R367_QAM_EQU_PNT_GAIN,            0xa7 },
+	{ R367_QAM_FEC_AC_CTR_0,            0x16 },
+	{ R367_QAM_FEC_AC_CTR_1,            0x0b },
+	{ R367_QAM_FEC_AC_CTR_2,            0x88 },
+	{ R367_QAM_FEC_AC_CTR_3,            0x02 },
+	{ R367_QAM_FEC_STATUS,              0x12 },
+	{ R367_QAM_RS_COUNTER_0,            0x7d },
+	{ R367_QAM_RS_COUNTER_1,            0xd0 },
+	{ R367_QAM_RS_COUNTER_2,            0x19 },
+	{ R367_QAM_RS_COUNTER_3,            0x0b },
+	{ R367_QAM_RS_COUNTER_4,            0xa3 },
+	{ R367_QAM_RS_COUNTER_5,            0x00 },
+	{ R367_QAM_BERT_0,                  0x01 },
+	{ R367_QAM_BERT_1,                  0x25 },
+	{ R367_QAM_BERT_2,                  0x41 },
+	{ R367_QAM_BERT_3,                  0x39 },
+	{ R367_QAM_OUTFORMAT_0,             0xc2 },
+	{ R367_QAM_OUTFORMAT_1,             0x22 },
+	{ R367_QAM_SMOOTHER_2,              0x28 },
+	{ R367_QAM_TSMF_CTRL_0,             0x01 },
+	{ R367_QAM_TSMF_CTRL_1,             0xc6 },
+	{ R367_QAM_TSMF_CTRL_3,             0x43 },
+	{ R367_QAM_TS_ON_ID_0,              0x00 },
+	{ R367_QAM_TS_ON_ID_1,              0x00 },
+	{ R367_QAM_TS_ON_ID_2,              0x00 },
+	{ R367_QAM_TS_ON_ID_3,              0x00 },
+	{ R367_QAM_RE_STATUS_0,             0x00 },
+	{ R367_QAM_RE_STATUS_1,             0x00 },
+	{ R367_QAM_RE_STATUS_2,             0x00 },
+	{ R367_QAM_RE_STATUS_3,             0x00 },
+	{ R367_QAM_TS_STATUS_0,             0x00 },
+	{ R367_QAM_TS_STATUS_1,             0x00 },
+	{ R367_QAM_TS_STATUS_2,             0xa0 },
+	{ R367_QAM_TS_STATUS_3,             0x00 },
+	{ R367_QAM_T_O_ID_0,                0x00 },
+	{ R367_QAM_T_O_ID_1,                0x00 },
+	{ R367_QAM_T_O_ID_2,                0x00 },
+	{ R367_QAM_T_O_ID_3,                0x00 },
+	{ 0x0000, 0x00 } // EOT
+};
+
+struct init_table ofdm_init[] = {
+	//{R367_OFDM_ID                   ,0x60},
+	//{R367_OFDM_I2CRPT 				,0x22},
+	//{R367_OFDM_TOPCTRL				,0x02},
+	//{R367_OFDM_IOCFG0				,0x40},
+	//{R367_OFDM_DAC0R				,0x00},
+	//{R367_OFDM_IOCFG1				,0x00},
+	//{R367_OFDM_DAC1R				,0x00},
+	//{R367_OFDM_IOCFG2				,0x62},
+	//{R367_OFDM_SDFR 				,0x00},
+	//{R367_OFDM_STATUS				,0xf8},
+	//{R367_OFDM_AUX_CLK				,0x0a},
+	//{R367_OFDM_FREESYS1			,0x00},
+	//{R367_OFDM_FREESYS2			,0x00},
+	//{R367_OFDM_FREESYS3			,0x00},
+	//{R367_OFDM_GPIO_CFG			,0x55},
+	//{R367_OFDM_GPIO_CMD			,0x00},
+	{R367_OFDM_AGC2MAX				,0xff},
+	{R367_OFDM_AGC2MIN				,0x00},
+	{R367_OFDM_AGC1MAX				,0xff},
+	{R367_OFDM_AGC1MIN				,0x00},
+	{R367_OFDM_AGCR					,0xbc},
+	{R367_OFDM_AGC2TH				,0x00},
+	//{R367_OFDM_AGC12C				,0x01}, //Note: This defines AGC pins, also needed for QAM
+	{R367_OFDM_AGCCTRL1			,0x85},
+	{R367_OFDM_AGCCTRL2			,0x1f},
+	{R367_OFDM_AGC1VAL1			,0x00},
+	{R367_OFDM_AGC1VAL2			,0x00},
+	{R367_OFDM_AGC2VAL1			,0x6f},
+	{R367_OFDM_AGC2VAL2			,0x05},
+	{R367_OFDM_AGC2PGA				,0x00},
+	{R367_OFDM_OVF_RATE1			,0x00},
+	{R367_OFDM_OVF_RATE2			,0x00},
+	{R367_OFDM_GAIN_SRC1			,0x2b},
+	{R367_OFDM_GAIN_SRC2			,0x04},
+	{R367_OFDM_INC_DEROT1			,0x55},
+	{R367_OFDM_INC_DEROT2			,0x55},
+	{R367_OFDM_PPM_CPAMP_DIR		,0x2c},
+	{R367_OFDM_PPM_CPAMP_INV		,0x00},
+	{R367_OFDM_FREESTFE_1			,0x00},
+	{R367_OFDM_FREESTFE_2			,0x1c},
+	{R367_OFDM_DCOFFSET			,0x00},
+	{R367_OFDM_EN_PROCESS			,0x05},
+	{R367_OFDM_SDI_SMOOTHER		,0x80},
+	{R367_OFDM_FE_LOOP_OPEN		,0x1c},
+	{R367_OFDM_FREQOFF1			,0x00},
+	{R367_OFDM_FREQOFF2			,0x00},
+	{R367_OFDM_FREQOFF3			,0x00},
+	{R367_OFDM_TIMOFF1				,0x00},
+	{R367_OFDM_TIMOFF2				,0x00},
+	{R367_OFDM_EPQ					,0x02},
+	{R367_OFDM_EPQAUTO				,0x01},
+	{R367_OFDM_SYR_UPDATE			,0xf5},
+	{R367_OFDM_CHPFREE						,0x00},
+	{R367_OFDM_PPM_STATE_MAC		      ,0x23},
+	{R367_OFDM_INR_THRESHOLD		      ,0xff},
+	{R367_OFDM_EPQ_TPS_ID_CELL	      ,0xf9},
+	{R367_OFDM_EPQ_CFG				      ,0x00},
+	{R367_OFDM_EPQ_STATUS			      ,0x01},
+	{R367_OFDM_AUTORELOCK			      ,0x81},
+	{R367_OFDM_BER_THR_VMSB		      ,0x00},
+	{R367_OFDM_BER_THR_MSB		      ,0x00},
+	{R367_OFDM_BER_THR_LSB		      ,0x00},
+	{R367_OFDM_CCD					      ,0x83},
+	{R367_OFDM_SPECTR_CFG			      ,0x00},
+	{R367_OFDM_CHC_DUMMY			      ,0x18},
+	{R367_OFDM_INC_CTL				      ,0x88},
+	{R367_OFDM_INCTHRES_COR1		      ,0xb4},
+	{R367_OFDM_INCTHRES_COR2		      ,0x96},
+	{R367_OFDM_INCTHRES_DET1		      ,0x0e},
+	{R367_OFDM_INCTHRES_DET2		      ,0x11},
+	{R367_OFDM_IIR_CELLNB				   ,0x8d},
+	{R367_OFDM_IIRCX_COEFF1_MSB	      ,0x00},
+	{R367_OFDM_IIRCX_COEFF1_LSB	      ,0x00},
+	{R367_OFDM_IIRCX_COEFF2_MSB	      ,0x09},
+	{R367_OFDM_IIRCX_COEFF2_LSB	      ,0x18},
+	{R367_OFDM_IIRCX_COEFF3_MSB	      ,0x14},
+	{R367_OFDM_IIRCX_COEFF3_LSB	      ,0x9c},
+	{R367_OFDM_IIRCX_COEFF4_MSB	      ,0x00},
+	{R367_OFDM_IIRCX_COEFF4_LSB	      ,0x00},
+	{R367_OFDM_IIRCX_COEFF5_MSB	      ,0x36},
+	{R367_OFDM_IIRCX_COEFF5_LSB			,0x42},
+	{R367_OFDM_FEPATH_CFG			      ,0x00},
+	{R367_OFDM_PMC1_FUNC			      ,0x65},
+	{R367_OFDM_PMC1_FOR			      ,0x00},
+	{R367_OFDM_PMC2_FUNC			      ,0x00},
+	{R367_OFDM_STATUS_ERR_DA		      ,0xe0},
+	{R367_OFDM_DIG_AGC_R			      ,0xfe},
+	{R367_OFDM_COMAGC_TARMSB		      ,0x0b},
+	{R367_OFDM_COM_AGC_TAR_ENMODE     ,0x41},
+	{R367_OFDM_COM_AGC_CFG			   ,0x3e},
+	{R367_OFDM_COM_AGC_GAIN1				,0x39},
+	{R367_OFDM_AUT_AGC_TARGETMSB	   ,0x0b},
+	{R367_OFDM_LOCK_DET_MSB			   ,0x01},
+	{R367_OFDM_AGCTAR_LOCK_LSBS		   ,0x40},
+	{R367_OFDM_AUT_GAIN_EN		      ,0xf4},
+	{R367_OFDM_AUT_CFG				      ,0xf0},
+	{R367_OFDM_LOCKN				      ,0x23},
+	{R367_OFDM_INT_X_3				      ,0x00},
+	{R367_OFDM_INT_X_2				      ,0x03},
+	{R367_OFDM_INT_X_1				      ,0x8d},
+	{R367_OFDM_INT_X_0				      ,0xa0},
+	{R367_OFDM_MIN_ERRX_MSB		      ,0x00},
+	{R367_OFDM_COR_CTL				      ,0x00},
+	{R367_OFDM_COR_STAT			      ,0xf6},
+	{R367_OFDM_COR_INTEN			      ,0x00},
+	{R367_OFDM_COR_INTSTAT		      ,0x3f},
+	{R367_OFDM_COR_MODEGUARD		      ,0x03},
+	{R367_OFDM_AGC_CTL				      ,0x08},
+	{R367_OFDM_AGC_MANUAL1		      ,0x00},
+	{R367_OFDM_AGC_MANUAL2		      ,0x00},
+	{R367_OFDM_AGC_TARG			      ,0x16},
+	{R367_OFDM_AGC_GAIN1			      ,0x53},
+	{R367_OFDM_AGC_GAIN2			      ,0x1d},
+	{R367_OFDM_RESERVED_1			      ,0x00},
+	{R367_OFDM_RESERVED_2			      ,0x00},
+	{R367_OFDM_RESERVED_3			      ,0x00},
+	{R367_OFDM_CAS_CTL				      ,0x44},
+	{R367_OFDM_CAS_FREQ			      ,0xb3},
+	{R367_OFDM_CAS_DAGCGAIN		      ,0x12},
+	{R367_OFDM_SYR_CTL				      ,0x04},
+	{R367_OFDM_SYR_STAT			      ,0x10},
+	{R367_OFDM_SYR_NCO1			      ,0x00},
+	{R367_OFDM_SYR_NCO2			      ,0x00},
+	{R367_OFDM_SYR_OFFSET1		      ,0x00},
+	{R367_OFDM_SYR_OFFSET2		      ,0x00},
+	{R367_OFDM_FFT_CTL				      ,0x00},
+	{R367_OFDM_SCR_CTL				      ,0x70},
+	{R367_OFDM_PPM_CTL1			      ,0xf8},
+	{R367_OFDM_TRL_CTL				      ,0xac},
+	{R367_OFDM_TRL_NOMRATE1		      ,0x1e},
+	{R367_OFDM_TRL_NOMRATE2		      ,0x58},
+	{R367_OFDM_TRL_TIME1			      ,0x1d},
+	{R367_OFDM_TRL_TIME2			      ,0xfc},
+	{R367_OFDM_CRL_CTL				      ,0x24},
+	{R367_OFDM_CRL_FREQ1			      ,0xad},
+	{R367_OFDM_CRL_FREQ2			      ,0x9d},
+	{R367_OFDM_CRL_FREQ3			      ,0xff},
+	{R367_OFDM_CHC_CTL		       ,0x01},
+	{R367_OFDM_CHC_SNR				      ,0xf0},
+	{R367_OFDM_BDI_CTL				      ,0x00},
+	{R367_OFDM_DMP_CTL				      ,0x00},
+	{R367_OFDM_TPS_RCVD1			      ,0x30},
+	{R367_OFDM_TPS_RCVD2			      ,0x02},
+	{R367_OFDM_TPS_RCVD3			      ,0x01},
+	{R367_OFDM_TPS_RCVD4			      ,0x00},
+	{R367_OFDM_TPS_ID_CELL1		      ,0x00},
+	{R367_OFDM_TPS_ID_CELL2		      ,0x00},
+	{R367_OFDM_TPS_RCVD5_SET1	      ,0x02},
+	{R367_OFDM_TPS_SET2			      ,0x02},
+	{R367_OFDM_TPS_SET3			      ,0x01},
+	{R367_OFDM_TPS_CTL				      ,0x00},
+	{R367_OFDM_CTL_FFTOSNUM		      ,0x34},
+	{R367_OFDM_TESTSELECT			      ,0x09},
+	{R367_OFDM_MSC_REV 			      ,0x0a},
+	{R367_OFDM_PIR_CTL 			      ,0x00},
+	{R367_OFDM_SNR_CARRIER1 		      ,0xa1},
+	{R367_OFDM_SNR_CARRIER2		      ,0x9a},
+	{R367_OFDM_PPM_CPAMP			      ,0x2c},
+	{R367_OFDM_TSM_AP0				      ,0x00},
+	{R367_OFDM_TSM_AP1				      ,0x00},
+	{R367_OFDM_TSM_AP2 			      ,0x00},
+	{R367_OFDM_TSM_AP3				      ,0x00},
+	{R367_OFDM_TSM_AP4				      ,0x00},
+	{R367_OFDM_TSM_AP5				      ,0x00},
+	{R367_OFDM_TSM_AP6				      ,0x00},
+	{R367_OFDM_TSM_AP7				      ,0x00},
+	//{R367_OFDM_TSTRES				 ,0x00},
+	//{R367_OFDM_ANACTRL				 ,0x0D},/*caution PLL stopped, to be restarted at init!!!*/
+	//{R367_OFDM_TSTBUS				      ,0x00},
+	//{R367_OFDM_TSTRATE				      ,0x00},
+	{R367_OFDM_CONSTMODE			      ,0x01},
+	{R367_OFDM_CONSTCARR1			      ,0x00},
+	{R367_OFDM_CONSTCARR2			      ,0x00},
+	{R367_OFDM_ICONSTEL			      ,0x0a},
+	{R367_OFDM_QCONSTEL			      ,0x15},
+	{R367_OFDM_TSTBISTRES0		      ,0x00},
+	{R367_OFDM_TSTBISTRES1		      ,0x00},
+	{R367_OFDM_TSTBISTRES2		      ,0x28},
+	{R367_OFDM_TSTBISTRES3		      ,0x00},
+	//{R367_OFDM_RF_AGC1				      ,0xff},
+	//{R367_OFDM_RF_AGC2				      ,0x83},
+	//{R367_OFDM_ANADIGCTRL			      ,0x19},
+	//{R367_OFDM_PLLMDIV				      ,0x0c},
+	//{R367_OFDM_PLLNDIV				      ,0x55},
+	//{R367_OFDM_PLLSETUP			      ,0x18},
+	//{R367_OFDM_DUAL_AD12			      ,0x00},
+	//{R367_OFDM_TSTBIST				      ,0x00},
+	//{R367_OFDM_PAD_COMP_CTRL		      ,0x00},
+	//{R367_OFDM_PAD_COMP_WR		      ,0x00},
+	//{R367_OFDM_PAD_COMP_RD		      ,0xe0},
+	{R367_OFDM_SYR_TARGET_FFTADJT_MSB	,0x00},
+	{R367_OFDM_SYR_TARGET_FFTADJT_LSB ,0x00},
+	{R367_OFDM_SYR_TARGET_CHCADJT_MSB ,0x00},
+	{R367_OFDM_SYR_TARGET_CHCADJT_LSB ,0x00},
+	{R367_OFDM_SYR_FLAG			 ,0x00},
+	{R367_OFDM_CRL_TARGET1		 ,0x00},
+	{R367_OFDM_CRL_TARGET2		 ,0x00},
+	{R367_OFDM_CRL_TARGET3		 ,0x00},
+	{R367_OFDM_CRL_TARGET4		 ,0x00},
+	{R367_OFDM_CRL_FLAG			 ,0x00},
+	{R367_OFDM_TRL_TARGET1		 ,0x00},
+	{R367_OFDM_TRL_TARGET2		 ,0x00},
+	{R367_OFDM_TRL_CHC				 ,0x00},
+	{R367_OFDM_CHC_SNR_TARG		 ,0x00},
+	{R367_OFDM_TOP_TRACK			      ,0x00},
+	{R367_OFDM_TRACKER_FREE1		 ,0x00},
+	{R367_OFDM_ERROR_CRL1			 ,0x00},
+	{R367_OFDM_ERROR_CRL2			 ,0x00},
+	{R367_OFDM_ERROR_CRL3			 ,0x00},
+	{R367_OFDM_ERROR_CRL4			 ,0x00},
+	{R367_OFDM_DEC_NCO1			 ,0x2c},
+	{R367_OFDM_DEC_NCO2			 ,0x0f},
+	{R367_OFDM_DEC_NCO3			 ,0x20},
+	{R367_OFDM_SNR					 ,0xf1},
+	{R367_OFDM_SYR_FFTADJ1		      ,0x00},
+	{R367_OFDM_SYR_FFTADJ2		 ,0x00},
+	{R367_OFDM_SYR_CHCADJ1		 ,0x00},
+	{R367_OFDM_SYR_CHCADJ2		 ,0x00},
+	{R367_OFDM_SYR_OFF				 ,0x00},
+	{R367_OFDM_PPM_OFFSET1		      ,0x00},
+	{R367_OFDM_PPM_OFFSET2		 ,0x03},
+	{R367_OFDM_TRACKER_FREE2		 ,0x00},
+	{R367_OFDM_DEBG_LT10			 ,0x00},
+	{R367_OFDM_DEBG_LT11			 ,0x00},
+	{R367_OFDM_DEBG_LT12			      ,0x00},
+	{R367_OFDM_DEBG_LT13			 ,0x00},
+	{R367_OFDM_DEBG_LT14			 ,0x00},
+	{R367_OFDM_DEBG_LT15			 ,0x00},
+	{R367_OFDM_DEBG_LT16			 ,0x00},
+	{R367_OFDM_DEBG_LT17			 ,0x00},
+	{R367_OFDM_DEBG_LT18			 ,0x00},
+	{R367_OFDM_DEBG_LT19			 ,0x00},
+	{R367_OFDM_DEBG_LT1A			 ,0x00},
+	{R367_OFDM_DEBG_LT1B			 ,0x00},
+	{R367_OFDM_DEBG_LT1C 			 ,0x00},
+	{R367_OFDM_DEBG_LT1D 			 ,0x00},
+	{R367_OFDM_DEBG_LT1E			 ,0x00},
+	{R367_OFDM_DEBG_LT1F			 ,0x00},
+	{R367_OFDM_RCCFGH				 ,0x00},
+	{R367_OFDM_RCCFGM						,0x00},
+	{R367_OFDM_RCCFGL						,0x00},
+	{R367_OFDM_RCINSDELH					,0x00},
+	{R367_OFDM_RCINSDELM			 ,0x00},
+	{R367_OFDM_RCINSDELL			 ,0x00},
+	{R367_OFDM_RCSTATUS			 ,0x00},
+	{R367_OFDM_RCSPEED 			 ,0x6f},
+	{R367_OFDM_RCDEBUGM			 ,0xe7},
+	{R367_OFDM_RCDEBUGL			 ,0x9b},
+	{R367_OFDM_RCOBSCFG			 ,0x00},
+	{R367_OFDM_RCOBSM 				 ,0x00},
+	{R367_OFDM_RCOBSL 				 ,0x00},
+	{R367_OFDM_RCFECSPY			 ,0x00},
+	{R367_OFDM_RCFSPYCFG 			 ,0x00},
+	{R367_OFDM_RCFSPYDATA			 ,0x00},
+	{R367_OFDM_RCFSPYOUT 			 ,0x00},
+	{R367_OFDM_RCFSTATUS 			 ,0x00},
+	{R367_OFDM_RCFGOODPACK		 ,0x00},
+	{R367_OFDM_RCFPACKCNT 		 ,0x00},
+	{R367_OFDM_RCFSPYMISC 		 ,0x00},
+	{R367_OFDM_RCFBERCPT4 		 ,0x00},
+	{R367_OFDM_RCFBERCPT3 		 ,0x00},
+	{R367_OFDM_RCFBERCPT2 		 ,0x00},
+	{R367_OFDM_RCFBERCPT1 		 ,0x00},
+	{R367_OFDM_RCFBERCPT0 		 ,0x00},
+	{R367_OFDM_RCFBERERR2 		 ,0x00},
+	{R367_OFDM_RCFBERERR1 		 ,0x00},
+	{R367_OFDM_RCFBERERR0 		 ,0x00},
+	{R367_OFDM_RCFSTATESM 		 ,0x00},
+	{R367_OFDM_RCFSTATESL 		 ,0x00},
+	{R367_OFDM_RCFSPYBER  		 ,0x00},
+	{R367_OFDM_RCFSPYDISTM		 ,0x00},
+	{R367_OFDM_RCFSPYDISTL		 ,0x00},
+	{R367_OFDM_RCFSPYOBS7 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS6 		      ,0x00},
+	{R367_OFDM_RCFSPYOBS5 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS4 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS3 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS2 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS1 		 ,0x00},
+	{R367_OFDM_RCFSPYOBS0			 ,0x00},
+	//{R367_OFDM_TSGENERAL 			 ,0x00},
+	//{R367_OFDM_RC1SPEED  			 ,0x6f},
+	//{R367_OFDM_TSGSTATUS			 ,0x18},
+	{R367_OFDM_FECM					 ,0x01},
+	{R367_OFDM_VTH12				 ,0xff},
+	{R367_OFDM_VTH23				 ,0xa1},
+	{R367_OFDM_VTH34				 ,0x64},
+	{R367_OFDM_VTH56				 ,0x40},
+	{R367_OFDM_VTH67				 ,0x00},
+	{R367_OFDM_VTH78				 ,0x2c},
+	{R367_OFDM_VITCURPUN			 ,0x12},
+	{R367_OFDM_VERROR				 ,0x01},
+	{R367_OFDM_PRVIT				 ,0x3f},
+	{R367_OFDM_VAVSRVIT			 ,0x00},
+	{R367_OFDM_VSTATUSVIT			 ,0xbd},
+	{R367_OFDM_VTHINUSE 			 ,0xa1},
+	{R367_OFDM_KDIV12				 ,0x20},
+	{R367_OFDM_KDIV23				 ,0x40},
+	{R367_OFDM_KDIV34				 ,0x20},
+	{R367_OFDM_KDIV56				 ,0x30},
+	{R367_OFDM_KDIV67				 ,0x00},
+	{R367_OFDM_KDIV78				 ,0x30},
+	{R367_OFDM_SIGPOWER 			 ,0x54},
+	{R367_OFDM_DEMAPVIT 			 ,0x40},
+	{R367_OFDM_VITSCALE 			 ,0x00},
+	{R367_OFDM_FFEC1PRG 			 ,0x00},
+	{R367_OFDM_FVITCURPUN 		 ,0x12},
+	{R367_OFDM_FVERROR 			 ,0x01},
+	{R367_OFDM_FVSTATUSVIT		 ,0xbd},
+	{R367_OFDM_DEBUG_LT1			 ,0x00},
+	{R367_OFDM_DEBUG_LT2			 ,0x00},
+	{R367_OFDM_DEBUG_LT3			 ,0x00},
+	{R367_OFDM_TSTSFMET  			 ,0x00},
+	{R367_OFDM_SELOUT				 ,0x00},
+	{R367_OFDM_TSYNC				 ,0x00},
+	{R367_OFDM_TSTERR				 ,0x00},
+	{R367_OFDM_TSFSYNC   			 ,0x00},
+	{R367_OFDM_TSTSFERR  			 ,0x00},
+	{R367_OFDM_TSTTSSF1  			 ,0x01},
+	{R367_OFDM_TSTTSSF2  			 ,0x1f},
+	{R367_OFDM_TSTTSSF3  			 ,0x00},
+	{R367_OFDM_TSTTS1   			 ,0x00},
+	{R367_OFDM_TSTTS2   			      ,0x1f},
+	{R367_OFDM_TSTTS3   			 ,0x01},
+	{R367_OFDM_TSTTS4   			 ,0x00},
+	{R367_OFDM_TSTTSRC  			 ,0x00},
+	{R367_OFDM_TSTTSRS  			 ,0x00},
+	{R367_OFDM_TSSTATEM			 ,0xb0},
+	{R367_OFDM_TSSTATEL			 ,0x40},
+	{R367_OFDM_TSCFGH  			 ,0x80},
+	{R367_OFDM_TSCFGM  			 ,0x00},
+	{R367_OFDM_TSCFGL  			 ,0x20},
+	{R367_OFDM_TSSYNC  			 ,0x00},
+	{R367_OFDM_TSINSDELH			 ,0x00},
+	{R367_OFDM_TSINSDELM 			 ,0x00},
+	{R367_OFDM_TSINSDELL			 ,0x00},
+	{R367_OFDM_TSDIVN				 ,0x03},
+	{R367_OFDM_TSDIVPM				 ,0x00},
+	{R367_OFDM_TSDIVPL				 ,0x00},
+	{R367_OFDM_TSDIVQM 			 ,0x00},
+	{R367_OFDM_TSDIVQL				 ,0x00},
+	{R367_OFDM_TSDILSTKM			 ,0x00},
+	{R367_OFDM_TSDILSTKL			 ,0x00},
+	{R367_OFDM_TSSPEED				 ,0x6f},
+	{R367_OFDM_TSSTATUS			 ,0x81},
+	{R367_OFDM_TSSTATUS2			 ,0x6a},
+	{R367_OFDM_TSBITRATEM			 ,0x0f},
+	{R367_OFDM_TSBITRATEL			 ,0xc6},
+	{R367_OFDM_TSPACKLENM			 ,0x00},
+	{R367_OFDM_TSPACKLENL			 ,0xfc},
+	{R367_OFDM_TSBLOCLENM			 ,0x0a},
+	{R367_OFDM_TSBLOCLENL			 ,0x80},
+	{R367_OFDM_TSDLYH 				 ,0x90},
+	{R367_OFDM_TSDLYM				 ,0x68},
+	{R367_OFDM_TSDLYL				 ,0x01},
+	{R367_OFDM_TSNPDAV				 ,0x00},
+	{R367_OFDM_TSBUFSTATH 		 ,0x00},
+	{R367_OFDM_TSBUFSTATM 		 ,0x00},
+	{R367_OFDM_TSBUFSTATL			 ,0x00},
+	{R367_OFDM_TSDEBUGM			 ,0xcf},
+	{R367_OFDM_TSDEBUGL			 ,0x1e},
+	{R367_OFDM_TSDLYSETH 			 ,0x00},
+	{R367_OFDM_TSDLYSETM			 ,0x68},
+	{R367_OFDM_TSDLYSETL			 ,0x00},
+	{R367_OFDM_TSOBSCFG			 ,0x00},
+	{R367_OFDM_TSOBSM 				 ,0x47},
+	{R367_OFDM_TSOBSL				 ,0x1f},
+	{R367_OFDM_ERRCTRL1			 ,0x95},
+	{R367_OFDM_ERRCNT1H 			 ,0x80},
+	{R367_OFDM_ERRCNT1M 			 ,0x00},
+	{R367_OFDM_ERRCNT1L 			 ,0x00},
+	{R367_OFDM_ERRCTRL2			 ,0x95},
+	{R367_OFDM_ERRCNT2H			 ,0x00},
+	{R367_OFDM_ERRCNT2M			 ,0x00},
+	{R367_OFDM_ERRCNT2L			 ,0x00},
+	{R367_OFDM_FECSPY 				 ,0x88},
+	{R367_OFDM_FSPYCFG				 ,0x2c},
+	{R367_OFDM_FSPYDATA			 ,0x3a},
+	{R367_OFDM_FSPYOUT				 ,0x06},
+	{R367_OFDM_FSTATUS				 ,0x61},
+	{R367_OFDM_FGOODPACK			 ,0xff},
+	{R367_OFDM_FPACKCNT			 ,0xff},
+	{R367_OFDM_FSPYMISC 			 ,0x66},
+	{R367_OFDM_FBERCPT4 			 ,0x00},
+	{R367_OFDM_FBERCPT3			 ,0x00},
+	{R367_OFDM_FBERCPT2			 ,0x36},
+	{R367_OFDM_FBERCPT1			 ,0x36},
+	{R367_OFDM_FBERCPT0 			 ,0x14},
+	{R367_OFDM_FBERERR2			 ,0x00},
+	{R367_OFDM_FBERERR1			 ,0x03},
+	{R367_OFDM_FBERERR0			 ,0x28},
+	{R367_OFDM_FSTATESM			 ,0x00},
+	{R367_OFDM_FSTATESL			 ,0x02},
+	{R367_OFDM_FSPYBER 			 ,0x00},
+	{R367_OFDM_FSPYDISTM			 ,0x01},
+	{R367_OFDM_FSPYDISTL			 ,0x9f},
+	{R367_OFDM_FSPYOBS7 			 ,0xc9},
+	{R367_OFDM_FSPYOBS6 			 ,0x99},
+	{R367_OFDM_FSPYOBS5			 ,0x08},
+	{R367_OFDM_FSPYOBS4			 ,0xec},
+	{R367_OFDM_FSPYOBS3			 ,0x01},
+	{R367_OFDM_FSPYOBS2			 ,0x0f},
+	{R367_OFDM_FSPYOBS1			 ,0xf5},
+	{R367_OFDM_FSPYOBS0			 ,0x08},
+	{R367_OFDM_SFDEMAP 			 ,0x40},
+	{R367_OFDM_SFERROR 			 ,0x00},
+	{R367_OFDM_SFAVSR  			 ,0x30},
+	{R367_OFDM_SFECSTATUS			 ,0xcc},
+	{R367_OFDM_SFKDIV12			 ,0x20},
+	{R367_OFDM_SFKDIV23			 ,0x40},
+	{R367_OFDM_SFKDIV34			 ,0x20},
+	{R367_OFDM_SFKDIV56			 ,0x20},
+	{R367_OFDM_SFKDIV67			 ,0x00},
+	{R367_OFDM_SFKDIV78			 ,0x20},
+	{R367_OFDM_SFDILSTKM			 ,0x00},
+	{R367_OFDM_SFDILSTKL 			 ,0x00},
+	{R367_OFDM_SFSTATUS			 ,0xb5},
+	{R367_OFDM_SFDLYH				 ,0x90},
+	{R367_OFDM_SFDLYM				 ,0x60},
+	{R367_OFDM_SFDLYL				 ,0x01},
+	{R367_OFDM_SFDLYSETH			 ,0xc0},
+	{R367_OFDM_SFDLYSETM			 ,0x60},
+	{R367_OFDM_SFDLYSETL			 ,0x00},
+	{R367_OFDM_SFOBSCFG 			 ,0x00},
+	{R367_OFDM_SFOBSM 				 ,0x47},
+	{R367_OFDM_SFOBSL				 ,0x05},
+	{R367_OFDM_SFECINFO 			 ,0x40},
+	{R367_OFDM_SFERRCTRL 			 ,0x74},
+	{R367_OFDM_SFERRCNTH			 ,0x80},
+	{R367_OFDM_SFERRCNTM 			 ,0x00},
+	{R367_OFDM_SFERRCNTL			 ,0x00},
+	{R367_OFDM_SYMBRATEM			 ,0x2f},
+	{R367_OFDM_SYMBRATEL			      ,0x50},
+	{R367_OFDM_SYMBSTATUS			 ,0x7f},
+	{R367_OFDM_SYMBCFG 			 ,0x00},
+	{R367_OFDM_SYMBFIFOM 			 ,0xf4},
+	{R367_OFDM_SYMBFIFOL 			 ,0x0d},
+	{R367_OFDM_SYMBOFFSM 			 ,0xf0},
+	{R367_OFDM_SYMBOFFSL 			 ,0x2d},
+	//{R367_OFDM_DEBUG_LT4			 ,0x00},
+	//{R367_OFDM_DEBUG_LT5			 ,0x00},
+	//{R367_OFDM_DEBUG_LT6			 ,0x00},
+	//{R367_OFDM_DEBUG_LT7			 ,0x00},
+	//{R367_OFDM_DEBUG_LT8			 ,0x00},
+	//{R367_OFDM_DEBUG_LT9			 ,0x00},
+	{ 0x0000, 0x00 } // EOT
+};
+
+static inline u32 MulDiv32(u32 a, u32 b, u32 c)
+{
+	u64 tmp64;
+
+	tmp64 = (u64)a * (u64)b;
+	do_div(tmp64, c);
+
+	return (u32) tmp64;
+}
+
+static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg =
+		{.addr = adr, .flags = 0, .buf = data, .len = len};
+
+	if (i2c_transfer(adap, &msg, 1) != 1) {
+		printk("stv0367: i2c_write error\n");
+		return -1;
+	}
+	return 0;
+}
+
+#if 0
+static int i2c_read(struct i2c_adapter *adap,
+		    u8 adr, u8 *msg, int len, u8 *answ, int alen)
+{
+	struct i2c_msg msgs[2] = { { .addr = adr, .flags = 0,
+				     .buf = msg, .len = len},
+				   { .addr = adr, .flags = I2C_M_RD,
+				     .buf = answ, .len = alen } };
+	if (i2c_transfer(adap, msgs, 2) != 2) {
+		printk("stv0367: i2c_read error\n");
+		return -1;
+	}
+	return 0;
+}
+#endif
+
+static int writereg(struct stv_state *state, u16 reg, u8 dat)
+{
+	u8 mm[3] = { (reg >> 8), reg & 0xff, dat };
+
+	return i2c_write(state->i2c, state->adr, mm, 3);
+}
+
+static int readreg(struct stv_state *state, u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg >> 8, reg & 0xff};
+	struct i2c_msg msgs[2] = {{.addr = state->adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = state->adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1}};
+	return (i2c_transfer(state->i2c, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int readregs(struct stv_state *state, u16 reg, u8 *val, int count)
+{
+	u8 msg[2] = {reg >> 8, reg & 0xff};
+	struct i2c_msg msgs[2] = {{.addr = state->adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = state->adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = count}};
+	return (i2c_transfer(state->i2c, msgs, 2) == 2) ? 0 : -1;
+}
+
+static int write_init_table(struct stv_state *state, struct init_table *tab)
+{
+	while (1) {
+		if (!tab->adr)
+			break;
+		if (writereg(state, tab->adr, tab->data) < 0)
+			return -1;
+		tab++;
+	}
+	return 0;
+}
+
+static int qam_set_modulation(struct stv_state *state)
+{
+	int stat = 0;
+
+	switch(state->modulation) {
+	case QAM_16:
+		writereg(state, R367_QAM_EQU_MAPPER,state->qam_inversion | QAM_MOD_QAM16 );
+		writereg(state, R367_QAM_AGC_PWR_REF_L,0x64);       /* Set analog AGC reference */
+		writereg(state, R367_QAM_IQDEM_ADJ_AGC_REF,0x00);   /* Set digital AGC reference */
+		writereg(state, R367_QAM_FSM_STATE,0x90);
+		writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+		writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa7);
+		writereg(state, R367_QAM_EQU_CRL_LD_SEN,0x95);
+		writereg(state, R367_QAM_EQU_CRL_LIMITER,0x40);
+		writereg(state, R367_QAM_EQU_PNT_GAIN,0x8a);
+		break;
+	case QAM_32:
+		writereg(state, R367_QAM_EQU_MAPPER,state->qam_inversion | QAM_MOD_QAM32 );
+		writereg(state, R367_QAM_AGC_PWR_REF_L,0x6e);       /* Set analog AGC reference */
+		writereg(state, R367_QAM_IQDEM_ADJ_AGC_REF,0x00);   /* Set digital AGC reference */
+		writereg(state, R367_QAM_FSM_STATE,0xb0);
+		writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+		writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xb7);
+		writereg(state, R367_QAM_EQU_CRL_LD_SEN,0x9d);
+		writereg(state, R367_QAM_EQU_CRL_LIMITER,0x7f);
+		writereg(state, R367_QAM_EQU_PNT_GAIN,0xa7);
+		break;
+	case QAM_64:
+		writereg(state, R367_QAM_EQU_MAPPER,state->qam_inversion | QAM_MOD_QAM64 );
+		writereg(state, R367_QAM_AGC_PWR_REF_L,0x5a);       /* Set analog AGC reference */
+		writereg(state, R367_QAM_IQDEM_ADJ_AGC_REF,0x82);   /* Set digital AGC reference */
+		if(state->symbol_rate>4500000)
+		{
+			writereg(state, R367_QAM_FSM_STATE,0xb0);
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa5);
+		}
+		else if(state->symbol_rate>2500000) // 25000000
+		{
+			writereg(state, R367_QAM_FSM_STATE,0xa0);
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa6);
+		}
+		else
+		{
+			writereg(state, R367_QAM_FSM_STATE,0xa0);
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xd1);
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa7);
+		}
+		writereg(state, R367_QAM_EQU_CRL_LD_SEN,0x95);
+		writereg(state, R367_QAM_EQU_CRL_LIMITER,0x40);
+		writereg(state, R367_QAM_EQU_PNT_GAIN,0x99);
+		break;
+	case QAM_128:
+		writereg(state, R367_QAM_EQU_MAPPER,state->qam_inversion | QAM_MOD_QAM128 );
+		writereg(state, R367_QAM_AGC_PWR_REF_L,0x76);       /* Set analog AGC reference */
+		writereg(state, R367_QAM_IQDEM_ADJ_AGC_REF,0x00);	/* Set digital AGC reference */
+		writereg(state, R367_QAM_FSM_STATE,0x90);
+		writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xb1);
+		if(state->symbol_rate>4500000) // 45000000
+		{
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa7);
+		}
+		else if(state->symbol_rate>2500000) // 25000000
+		{
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa6);
+		}
+		else
+		{
+			writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0x97);
+		}
+		writereg(state, R367_QAM_EQU_CRL_LD_SEN,0x8e);
+		writereg(state, R367_QAM_EQU_CRL_LIMITER,0x7f);
+		writereg(state, R367_QAM_EQU_PNT_GAIN,0xa7);
+		break;
+	case QAM_256:
+		writereg(state, R367_QAM_EQU_MAPPER,state->qam_inversion | QAM_MOD_QAM256 );
+		writereg(state, R367_QAM_AGC_PWR_REF_L,0x5a);     /* Set analog AGC reference */
+		writereg(state, R367_QAM_IQDEM_ADJ_AGC_REF,0x94); /* Set digital AGC reference */
+		writereg(state, R367_QAM_FSM_STATE,0xa0);
+		if(state->symbol_rate>4500000) // 45000000
+		{
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+		}
+		else if(state->symbol_rate>2500000) // 25000000
+		{
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xc1);
+		}
+		else
+		{
+			writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,0xd1);
+		}
+		writereg(state, R367_QAM_EQU_CRL_LPF_GAIN,0xa7);
+		writereg(state, R367_QAM_EQU_CRL_LD_SEN,0x85);
+		writereg(state, R367_QAM_EQU_CRL_LIMITER,0x40);
+		writereg(state, R367_QAM_EQU_PNT_GAIN,0xa7);
+		break;
+	default:
+		stat = -EINVAL;
+		break;
+	}
+	return stat;
+}
+
+
+static int QAM_SetSymbolRate(struct stv_state *state)
+{
+	int status = 0;
+	u32 sr = state->symbol_rate;
+	u32 Corr = 0;
+	u32 Temp, Temp1, AdpClk;
+
+	switch(state->modulation) {
+	default:
+	case QAM_16:   Corr = 1032; break;
+	case QAM_32:   Corr =  954; break;
+	case QAM_64:   Corr =  983; break;
+	case QAM_128:  Corr =  957; break;
+	case QAM_256:  Corr =  948; break;
+	}
+
+	// Transfer ration
+	Temp = (256*sr) / state->adc_clock;
+	writereg(state, R367_QAM_EQU_CRL_TFR,(Temp));
+
+	/* Symbol rate and SRC gain calculation */
+	AdpClk = (state->master_clock) / 2000; /* TRL works at half the system clock */
+
+	Temp = state->symbol_rate;
+	Temp1 = sr;
+
+	if(sr < 2097152)				/* 2097152 = 2^21 */
+	{
+		Temp  = ((((sr * 2048) / AdpClk) * 16384 ) / 125 ) * 8;
+		Temp1 = (((((sr * 2048) / 439 ) * 256 ) / AdpClk ) * Corr * 9 ) / 10000000;
+	}
+	else if(sr < 4194304)			/* 4194304 = 2**22 */
+	{
+		Temp  = ((((sr * 1024) / AdpClk) * 16384 ) / 125 ) * 16;
+		Temp1 = (((((sr * 1024) / 439 ) * 256 ) / AdpClk ) * Corr * 9 ) / 5000000;
+	}
+	else if(sr < 8388608)			/* 8388608 = 2**23 */
+	{
+		Temp  = ((((sr * 512) / AdpClk) * 16384 ) / 125 ) * 32;
+		Temp1 = (((((sr * 512) / 439 ) * 256 ) / AdpClk ) * Corr * 9 ) / 2500000;
+	}
+	else
+	{
+		Temp  = ((((sr * 256) / AdpClk) * 16384 ) / 125 ) * 64;
+		Temp1 = (((((sr * 256) / 439 ) * 256 ) / AdpClk ) * Corr * 9 ) / 1250000;
+	}
+
+	///* Filters' coefficients are calculated and written into registers only if the filters are enabled */
+	//if (ChipGetField(hChip,F367qam_ADJ_EN)) // Is disabled from init!
+	//{
+	//    FE_367qam_SetIirAdjacentcoefficient(hChip, MasterClk_Hz, SymbolRate);
+	//}
+	///* AllPass filter is never used on this IC */
+	//ChipSetField(hChip,F367qam_ALLPASSFILT_EN,0); // should be disabled from init!
+
+	writereg(state, R367_QAM_SRC_NCO_LL,(Temp));
+	writereg(state, R367_QAM_SRC_NCO_LH,(Temp>>8));
+	writereg(state, R367_QAM_SRC_NCO_HL,(Temp>>16));
+	writereg(state, R367_QAM_SRC_NCO_HH,(Temp>>24));
+
+	writereg(state, R367_QAM_IQDEM_GAIN_SRC_L,(Temp1));
+	writereg(state, R367_QAM_IQDEM_GAIN_SRC_H,(Temp1>>8));
+	return status;
+}
+
+
+static int QAM_SetDerotFrequency(struct stv_state *state, u32 DerotFrequency)
+{
+	int status = 0;
+	u32 Sampled_IF;
+
+	do {
+		//if (DerotFrequency < 1000000)
+		//    DerotFrequency = state->adc_clock/4; /* ZIF operation */
+		if (DerotFrequency > state->adc_clock)
+			DerotFrequency = DerotFrequency - state->adc_clock;	// User Alias
+
+		Sampled_IF = ((32768 * (DerotFrequency/1000)) / (state->adc_clock/1000)) * 256;
+		if(Sampled_IF > 8388607)
+			Sampled_IF = 8388607;
+
+		writereg(state, R367_QAM_MIX_NCO_LL, (Sampled_IF));
+		writereg(state, R367_QAM_MIX_NCO_HL, (Sampled_IF>>8));
+		writereg(state, R367_QAM_MIX_NCO_HH, (Sampled_IF>>16));
+	} while(0);
+
+	return status;
+}
+
+
+
+static int QAM_Start(struct stv_state *state, s32 offsetFreq,s32 IntermediateFrequency)
+{
+	int status = 0;
+	u32 AGCTimeOut = 25;
+	u32 TRLTimeOut = 100000000 / state->symbol_rate;
+	u32 CRLSymbols = 0;
+	u32 EQLTimeOut = 100;
+	u32 SearchRange = state->symbol_rate / 25;
+	u32 CRLTimeOut;
+	u8 Temp;
+
+	if( state->demod_state != QAMSet ) {
+		writereg(state, R367_DEBUG_LT4,0x00);
+		writereg(state, R367_DEBUG_LT5,0x01);
+		writereg(state, R367_DEBUG_LT6,0x06);// R367_QAM_CTRL_1
+		writereg(state, R367_DEBUG_LT7,0x03);// R367_QAM_CTRL_2
+		writereg(state, R367_DEBUG_LT8,0x00);
+		writereg(state, R367_DEBUG_LT9,0x00);
+
+		// Tuner Setup
+		writereg(state, R367_ANADIGCTRL,0x8B); /* Buffer Q disabled, I Enabled, signed ADC */
+		writereg(state, R367_DUAL_AD12,0x04); /* ADCQ disabled */
+
+		// Clock setup
+		writereg(state, R367_ANACTRL,0x0D); /* PLL bypassed and disabled */
+		writereg(state, R367_TOPCTRL,0x10); // Set QAM
+
+		writereg(state, R367_PLLMDIV,27); /* IC runs at 58 MHz with a 27 MHz crystal */
+		writereg(state, R367_PLLNDIV,232);
+		writereg(state, R367_PLLSETUP,0x18);  /* ADC clock is equal to system clock */
+
+		msleep(50);
+		writereg(state, R367_ANACTRL,0x00); /* PLL enabled and used */
+
+		state->master_clock = 58000000;
+		state->adc_clock = 58000000;
+
+		state->demod_state = QAMSet;
+	}
+
+	state->m_bFirstTimeLock = true;
+	state->m_DemodLockTime  = -1;
+
+	qam_set_modulation(state);
+	QAM_SetSymbolRate(state);
+
+	// Will make problems on low symbol rates ( < 2500000 )
+
+	switch(state->modulation) {
+	default:
+	case QAM_16:   CRLSymbols = 150000; break;
+	case QAM_32:   CRLSymbols = 250000; break;
+	case QAM_64:   CRLSymbols = 200000; break;
+	case QAM_128:  CRLSymbols = 250000; break;
+	case QAM_256:  CRLSymbols = 250000; break;
+	}
+
+	CRLTimeOut = (25 * CRLSymbols * (SearchRange/1000)) / (state->symbol_rate/1000);
+	CRLTimeOut = (1000 * CRLTimeOut) / state->symbol_rate;
+	if( CRLTimeOut < 50 ) CRLTimeOut = 50;
+
+	state->m_FECTimeOut = 20;
+	state->m_DemodTimeOut = AGCTimeOut + TRLTimeOut + CRLTimeOut + EQLTimeOut;
+	state->m_SignalTimeOut = AGCTimeOut + TRLTimeOut;
+
+	// QAM_AGC_ACCUMRSTSEL = 0;
+	readreg(state, R367_QAM_AGC_CTL,&state->m_Save_QAM_AGC_CTL);
+	writereg(state, R367_QAM_AGC_CTL,state->m_Save_QAM_AGC_CTL & ~0x0F);
+
+	// QAM_MODULUSMAP_EN = 0
+	readreg(state, R367_QAM_EQU_PNT_GAIN,&Temp);
+	writereg(state, R367_QAM_EQU_PNT_GAIN,Temp & ~0x40);
+
+	// QAM_SWEEP_EN = 0
+	readreg(state, R367_QAM_EQU_CTR_LPF_GAIN,&Temp);
+	writereg(state, R367_QAM_EQU_CTR_LPF_GAIN,Temp & ~0x08);
+
+	QAM_SetDerotFrequency(state, IntermediateFrequency);
+
+	// Release TRL
+	writereg(state, R367_QAM_CTRL_1,0x00);
+
+	state->IF = IntermediateFrequency;
+	state->demod_state = QAMStarted;
+
+	return status;
+}
+
+static int OFDM_Start(struct stv_state *state, s32 offsetFreq,s32 IntermediateFrequency)
+{
+	int status = 0;
+	u8 GAIN_SRC1;
+	u32 Derot;
+	u8 SYR_CTL;
+	u8 tmp1;
+	u8 tmp2;
+
+	if ( state->demod_state != OFDMSet ) {
+		// QAM Disable
+		writereg(state, R367_DEBUG_LT4, 0x00);
+		writereg(state, R367_DEBUG_LT5, 0x00);
+		writereg(state, R367_DEBUG_LT6, 0x00);// R367_QAM_CTRL_1
+		writereg(state, R367_DEBUG_LT7, 0x00);// R367_QAM_CTRL_2
+		writereg(state, R367_DEBUG_LT8, 0x00);
+		writereg(state, R367_DEBUG_LT9, 0x00);
+
+		// Tuner Setup
+		writereg(state, R367_ANADIGCTRL, 0x89); /* Buffer Q disabled, I Enabled, unsigned ADC */
+		writereg(state, R367_DUAL_AD12, 0x04); /* ADCQ disabled */
+
+		// Clock setup
+		writereg(state, R367_ANACTRL, 0x0D); /* PLL bypassed and disabled */
+		writereg(state, R367_TOPCTRL, 0x00); // Set OFDM
+
+		writereg(state, R367_PLLMDIV, 1); /* IC runs at 54 MHz with a 27 MHz crystal */
+		writereg(state, R367_PLLNDIV, 8);
+		writereg(state, R367_PLLSETUP, 0x18);  /* ADC clock is equal to system clock */
+
+		msleep(50);
+		writereg(state, R367_ANACTRL, 0x00); /* PLL enabled and used */
+
+		state->master_clock = 54000000;
+		state->adc_clock    = 54000000;
+
+		state->demod_state = OFDMSet;
+	}
+
+	state->m_bFirstTimeLock = true;
+	state->m_DemodLockTime  = -1;
+
+	// Set inversion in GAIN_SRC1 (fixed from init)
+	//  is in GAIN_SRC1, see below
+
+	GAIN_SRC1 = 0xA0;
+	// Bandwidth
+
+	// Fixed values for 54 MHz
+	switch(state->bandwidth) {
+	case 0:
+	case 8000000:
+		// Normrate = 44384;
+		writereg(state, R367_OFDM_TRL_CTL,0x14);
+		writereg(state, R367_OFDM_TRL_NOMRATE1,0xB0);
+		writereg(state, R367_OFDM_TRL_NOMRATE2,0x56);
+		// Gain SRC = 2774
+		writereg(state, R367_OFDM_GAIN_SRC1,0x0A | GAIN_SRC1);
+		writereg(state, R367_OFDM_GAIN_SRC2,0xD6);
+		break;
+	case 7000000:
+		// Normrate = 38836;
+		writereg(state, R367_OFDM_TRL_CTL,0x14);
+		writereg(state, R367_OFDM_TRL_NOMRATE1,0xDA);
+		writereg(state, R367_OFDM_TRL_NOMRATE2,0x4B);
+		// Gain SRC = 2427
+		writereg(state, R367_OFDM_GAIN_SRC1,0x09 | GAIN_SRC1);
+		writereg(state, R367_OFDM_GAIN_SRC2,0x7B);
+		break;
+	case 6000000:
+		// Normrate = 33288;
+		writereg(state, R367_OFDM_TRL_CTL,0x14);
+		writereg(state, R367_OFDM_TRL_NOMRATE1,0x04);
+		writereg(state, R367_OFDM_TRL_NOMRATE2,0x41);
+		// Gain SRC = 2080
+		writereg(state, R367_OFDM_GAIN_SRC1,0x08 | GAIN_SRC1);
+		writereg(state, R367_OFDM_GAIN_SRC2,0x20);
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	Derot = ((IntermediateFrequency / 1000) * 65536) / (state->master_clock / 1000);
+
+	writereg(state, R367_OFDM_INC_DEROT1,(Derot>>8));
+	writereg(state, R367_OFDM_INC_DEROT2,(Derot));
+
+	readreg(state, R367_OFDM_SYR_CTL,&SYR_CTL);
+	SYR_CTL  &= ~0x78;
+	writereg(state, R367_OFDM_SYR_CTL,SYR_CTL);    // EchoPos = 0
+
+
+	writereg(state, R367_OFDM_COR_MODEGUARD,0x03); // Force = 0, Mode = 0, Guard = 3
+	SYR_CTL &= 0x01;
+	writereg(state, R367_OFDM_SYR_CTL,SYR_CTL);    // SYR_TR_DIS = 0
+
+	msleep(5);
+
+	writereg(state, R367_OFDM_COR_CTL,0x20);    // Start core
+
+	// -- Begin M.V.
+	// Reset FEC and Read Solomon
+	readreg(state, R367_OFDM_SFDLYSETH,&tmp1);
+	readreg(state, R367_TSGENERAL,&tmp2);
+	writereg(state, R367_OFDM_SFDLYSETH,tmp1 | 0x08);
+	writereg(state, R367_TSGENERAL,tmp2 | 0x01);
+	// -- End M.V.
+
+	state->m_SignalTimeOut = 200;
+	state->IF = IntermediateFrequency;
+	state->demod_state = OFDMStarted;
+	state->m_DemodTimeOut = 0;
+	state->m_FECTimeOut = 0;
+	state->m_TSTimeOut = 0;
+
+	return status;
+}
+
+#if 0
+static int Stop(struct stv_state *state)
+{
+	int status = 0;
+
+	switch(state->demod_state)
+	{
+	case QAMStarted:
+		status = writereg(state, R367_QAM_CTRL_1,0x06);
+		state->demod_state = QAMSet;
+		break;
+	case OFDMStarted:
+		status = writereg(state, R367_OFDM_COR_CTL,0x00);
+		state->demod_state = OFDMSet;
+		break;
+	default:
+		break;
+	}
+	return status;
+}
+#endif
+
+static s32 Log10x100(u32 x)
+{
+	static u32 LookupTable[100] = {
+		101157945, 103514217, 105925373, 108392691, 110917482,
+		113501082, 116144861, 118850223, 121618600, 124451461, // 800.5 - 809.5
+		127350308, 130316678, 133352143, 136458314, 139636836,
+		142889396, 146217717, 149623566, 153108746, 156675107, // 810.5 - 819.5
+		160324539, 164058977, 167880402, 171790839, 175792361,
+		179887092, 184077200, 188364909, 192752491, 197242274, // 820.5 - 829.5
+		201836636, 206538016, 211348904, 216271852, 221309471,
+		226464431, 231739465, 237137371, 242661010, 248313311, // 830.5 - 839.5
+		254097271, 260015956, 266072506, 272270131, 278612117,
+		285101827, 291742701, 298538262, 305492111, 312607937, // 840.5 - 849.5
+		319889511, 327340695, 334965439, 342767787, 350751874,
+		358921935, 367282300, 375837404, 384591782, 393550075, // 850.5 - 859.5
+		402717034, 412097519, 421696503, 431519077, 441570447,
+		451855944, 462381021, 473151259, 484172368, 495450191, // 860.5 - 869.5
+		506990708, 518800039, 530884444, 543250331, 555904257,
+		568852931, 582103218, 595662144, 609536897, 623734835, // 870.5 - 879.5
+		638263486, 653130553, 668343918, 683911647, 699841996,
+		716143410, 732824533, 749894209, 767361489, 785235635, // 880.5 - 889.5
+		803526122, 822242650, 841395142, 860993752, 881048873,
+		901571138, 922571427, 944060876, 966050879, 988553095, // 890.5 - 899.5
+	};
+	s32 y;
+	int i;
+
+	if (x == 0)
+		return 0;
+	y = 800;
+	if (x >= 1000000000) {
+		x /= 10;
+		y += 100;
+	}
+
+	while (x < 100000000) {
+		x *= 10;
+		y -= 100;
+	}
+	i = 0;
+	while (i < 100 && x > LookupTable[i])
+		i += 1;
+	y += i;
+	return y;
+}
+
+static int QAM_GetSignalToNoise(struct stv_state *state, s32 *pSignalToNoise)
+{
+	u32 RegValAvg = 0;
+	u8 RegVal[2];
+	int status = 0, i;
+
+	*pSignalToNoise = 0;
+	for (i = 0; i < 10; i += 1 ) {
+		readregs(state, R367_QAM_EQU_SNR_LO, RegVal, 2);
+		RegValAvg += RegVal[0] + 256 * RegVal[1];
+	}
+	if (RegValAvg != 0) {
+		s32 Power = 1;
+		switch(state->modulation) {
+		case QAM_16:
+			Power = 20480;
+			break;
+		case QAM_32:
+			Power = 23040;
+			break;
+		case QAM_64:
+			Power = 21504;
+			break;
+		case QAM_128:
+			Power = 23616; 
+			break;
+		case QAM_256:
+			Power = 21760; 
+			break;
+		default:
+			break;
+		}
+		*pSignalToNoise = Log10x100((Power * 320) / RegValAvg);
+	} else {
+		*pSignalToNoise = 380;
+	}
+	return status;
+}
+
+static int OFDM_GetSignalToNoise(struct stv_state *state, s32 *pSignalToNoise)
+{
+	u8 CHC_SNR = 0;
+
+	int status = readreg(state, R367_OFDM_CHC_SNR, &CHC_SNR);
+	if (status >= 0) {
+		// Note: very unclear documentation on this.
+		//   Datasheet states snr = CHC_SNR/4 dB  -> way to high values!
+		//   Software  snr = ( 1000 * CHC_SNR ) / 8 / 32 / 10; -> to low values
+		//   Comment in SW states this should be ( 1000 * CHC_SNR ) / 4 / 32 / 10; for the 367
+		//   361/362 Datasheet: snr = CHC_SNR/8 dB -> this looks best
+		*pSignalToNoise = ( (s32)CHC_SNR * 10) / 8;
+	}
+	//printk("SNR %d\n", *pSignalToNoise);
+	return status;
+}
+
+#if 0
+static int DVBC_GetQuality(struct stv_state *state, s32 SignalToNoise, s32 *pQuality)
+{
+	*pQuality = 100;
+	return 0;
+};
+
+static int DVBT_GetQuality(struct stv_state *state, s32 SignalToNoise, s32 *pQuality)
+{
+	static s32 QE_SN[] = {
+		51, // QPSK 1/2
+		69, // QPSK 2/3
+		79, // QPSK 3/4
+		89, // QPSK 5/6
+		97, // QPSK 7/8
+		108, // 16-QAM 1/2
+		131, // 16-QAM 2/3
+		146, // 16-QAM 3/4
+		156, // 16-QAM 5/6
+		160, // 16-QAM 7/8
+		165, // 64-QAM 1/2
+		187, // 64-QAM 2/3
+		202, // 64-QAM 3/4
+		216, // 64-QAM 5/6
+		225, // 64-QAM 7/8
+	};
+	u8 TPS_Received[2];
+	int Constellation;
+	int CodeRate;
+	s32 SignalToNoiseRel, BERQuality;
+
+	*pQuality = 0;
+	readregs(state, R367_OFDM_TPS_RCVD2, TPS_Received, sizeof(TPS_Received));
+	Constellation = TPS_Received[0] & 0x03;
+	CodeRate = TPS_Received[1] & 0x07;
+
+	if( Constellation > 2 || CodeRate > 5 )
+		return -1;
+	SignalToNoiseRel = SignalToNoise - QE_SN[Constellation * 5 + CodeRate];
+	BERQuality = 100;
+
+	if( SignalToNoiseRel < -70 )
+		*pQuality = 0;
+	else if( SignalToNoiseRel < 30 ) {
+		*pQuality = ((SignalToNoiseRel + 70) * BERQuality)/100;
+	} else
+		*pQuality = BERQuality;
+	return 0;
+};
+
+static s32 DVBCQuality(struct stv_state *state, s32 SignalToNoise)
+{
+	s32 SignalToNoiseRel = 0;
+	s32 Quality = 0;
+	s32 BERQuality = 100;
+
+	switch(state->modulation) {
+	case QAM_16:  SignalToNoiseRel = SignalToNoise - 200 ; break;
+	case QAM_32:  SignalToNoiseRel = SignalToNoise - 230 ; break; // Not in NorDig
+	case QAM_64:  SignalToNoiseRel = SignalToNoise - 260 ; break;
+	case QAM_128: SignalToNoiseRel = SignalToNoise - 290 ; break;
+	case QAM_256: SignalToNoiseRel = SignalToNoise - 320 ; break;
+	}
+
+	if( SignalToNoiseRel < -70 ) Quality = 0;
+	else if( SignalToNoiseRel < 30 )
+	{
+		Quality = ((SignalToNoiseRel + 70) * BERQuality)/100;
+	}
+	else
+	Quality = BERQuality;
+
+	return Quality;
+}
+
+static int GetQuality(struct stv_state *state, s32 SignalToNoise, s32 *pQuality)
+{
+	*pQuality = 0;
+	switch(state->demod_state)
+	{
+	case QAMStarted:
+		*pQuality = DVBCQuality(state, SignalToNoise);
+		break;
+	case OFDMStarted:
+		return DVBT_GetQuality(state, SignalToNoise, pQuality);
+	}
+	return 0;
+};
+#endif
+
+static int attach_init(struct stv_state *state)
+{
+	int stat = 0;
+
+	stat = readreg(state, R367_ID, &state->ID);
+	if ( stat < 0 || state->ID != 0x60 )
+		return -ENODEV;
+	printk("stv0367 found\n");
+
+	writereg(state, R367_TOPCTRL, 0x10);
+	write_init_table(state, base_init);
+	write_init_table(state, qam_init);
+
+	writereg(state, R367_TOPCTRL, 0x00);
+	write_init_table(state, ofdm_init);
+
+	writereg(state, R367_OFDM_GAIN_SRC1, 0x2A);
+	writereg(state, R367_OFDM_GAIN_SRC2, 0xD6);
+	writereg(state, R367_OFDM_INC_DEROT1, 0x55);
+	writereg(state, R367_OFDM_INC_DEROT2, 0x55);
+	writereg(state, R367_OFDM_TRL_CTL, 0x14);
+	writereg(state, R367_OFDM_TRL_NOMRATE1, 0xAE);
+	writereg(state, R367_OFDM_TRL_NOMRATE2, 0x56);
+	writereg(state, R367_OFDM_FEPATH_CFG, 0x0);
+
+	// OFDM TS Setup
+
+	writereg(state, R367_OFDM_TSCFGH, 0x70);
+	writereg(state, R367_OFDM_TSCFGM, 0xC0);
+	writereg(state, R367_OFDM_TSCFGL, 0x20);
+	writereg(state, R367_OFDM_TSSPEED, 0x40);        // Fixed at 54 MHz
+	//writereg(state, R367_TSTBUS, 0x80);      // Invert CLK
+
+	writereg(state, R367_OFDM_TSCFGH, 0x71);
+	writereg(state, R367_OFDM_TSCFGH, 0x70);
+
+	writereg(state, R367_TOPCTRL, 0x10);
+
+	// Also needed for QAM
+	writereg(state, R367_OFDM_AGC12C, 0x01); // AGC Pin setup
+
+	writereg(state, R367_OFDM_AGCCTRL1, 0x8A); //
+
+	// QAM TS setup, note exact format also depends on descrambler settings
+	writereg(state, R367_QAM_OUTFORMAT_0, 0x85); // Inverted Clock, Swap, serial
+	// writereg(state, R367_QAM_OUTFORMAT_1, 0x00); //
+
+	// Clock setup
+	writereg(state, R367_ANACTRL, 0x0D); /* PLL bypassed and disabled */
+
+	if( state->master_clock == 58000000 ) {
+		writereg(state, R367_PLLMDIV,27); /* IC runs at 58 MHz with a 27 MHz crystal */
+		writereg(state, R367_PLLNDIV,232);
+	} else {
+		writereg(state, R367_PLLMDIV,1); /* IC runs at 54 MHz with a 27 MHz crystal */
+		writereg(state, R367_PLLNDIV,8);
+	}
+	writereg(state, R367_PLLSETUP, 0x18);  /* ADC clock is equal to system clock */
+
+	// Tuner setup
+	writereg(state, R367_ANADIGCTRL, 0x8b); /* Buffer Q disabled, I Enabled, signed ADC */
+	writereg(state, R367_DUAL_AD12, 0x04); /* ADCQ disabled */
+
+	writereg(state, R367_QAM_FSM_SNR2_HTH, 0x23); /* Improves the C/N lock limit */
+	writereg(state, R367_QAM_IQ_QAM, 0x01); /* ZIF/IF Automatic mode */
+	writereg(state, R367_QAM_EQU_FFE_LEAKAGE, 0x83); /* Improving burst noise performances */
+	writereg(state, R367_QAM_IQDEM_ADJ_EN, 0x05); /* Improving ACI performances */
+
+	writereg(state, R367_ANACTRL, 0x00); /* PLL enabled and used */
+
+	writereg(state, R367_I2CRPT, state->I2CRPT);
+	state->demod_state    = QAMSet;
+	return stat;
+}
+
+#ifdef USE_API3
+static void c_release(struct dvb_frontend* fe)
+#else
+static void release(struct dvb_frontend* fe)
+#endif
+{
+	struct stv_state *state=fe->demodulator_priv;
+	printk("%s\n", __FUNCTION__);
+	kfree(state);
+}
+
+#ifdef USE_API3
+static int c_init (struct dvb_frontend *fe)
+{
+	struct stv_state *state=fe->demodulator_priv;
+
+	if (mutex_trylock(&state->ctlock)==0)
+		return -EBUSY;
+	state->omode = OM_DVBC;
+	return 0;
+}
+
+static int c_sleep(struct dvb_frontend* fe)
+{
+	struct stv_state *state=fe->demodulator_priv;
+
+	mutex_unlock(&state->ctlock);
+	return 0;
+}
+#endif
+
+static int gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct stv_state *state = fe->demodulator_priv;
+	u8 i2crpt = state->I2CRPT & ~0x80;
+
+	if (enable)
+		i2crpt |= 0x80;
+	if (writereg(state, R367_I2CRPT, i2crpt) < 0)
+		return -1;
+	state->I2CRPT = i2crpt;
+	return 0;
+}
+
+#if 0
+static int c_track(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+{
+	return DVBFE_ALGO_SEARCH_AGAIN;
+}
+#endif
+
+#if 0
+int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
+int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
+#endif
+
+static int ofdm_lock(struct stv_state *state)
+{
+	int status = 0;
+	u8 OFDM_Status;
+	s32 DemodTimeOut = 10;
+	s32 FECTimeOut = 0;
+	s32 TSTimeOut = 0;
+	u8 CPAMPMin = 255;
+	u8 CPAMPValue;
+	u8 SYR_STAT;
+	u8 FFTMode;
+	u8 TSStatus;
+
+	msleep(state->m_SignalTimeOut);
+	readreg(state, R367_OFDM_STATUS,&OFDM_Status);
+
+	if (!(OFDM_Status & 0x40))
+		return -1;
+	//printk("lock 1\n");
+
+	readreg(state, R367_OFDM_SYR_STAT,&SYR_STAT);
+	FFTMode = (SYR_STAT & 0x0C) >> 2;
+
+	switch(FFTMode)
+	{
+	    case 0: // 2K
+		DemodTimeOut = 10;
+		FECTimeOut = 150;
+		TSTimeOut = 125;
+		CPAMPMin = 20;
+		break;
+	    case 1: // 8K
+		DemodTimeOut = 55;
+		FECTimeOut = 600;
+		TSTimeOut = 500;
+		CPAMPMin = 80;
+		break;
+	    case 2: // 4K
+		DemodTimeOut = 40;
+		FECTimeOut = 300;
+		TSTimeOut = 250;
+		CPAMPMin = 30;
+		break;
+	}
+	state->m_OFDM_FFTMode = FFTMode;
+	readreg(state, R367_OFDM_PPM_CPAMP_DIR,&CPAMPValue);
+	msleep(DemodTimeOut);
+	{
+	    // Release FEC and Read Solomon Reset
+	    u8 tmp1;
+	    u8 tmp2;
+	    readreg(state, R367_OFDM_SFDLYSETH,&tmp1);
+	    readreg(state, R367_TSGENERAL,&tmp2);
+	    writereg(state, R367_OFDM_SFDLYSETH,tmp1 & ~0x08);
+	    writereg(state, R367_TSGENERAL,tmp2 & ~0x01);
+	}
+	msleep(FECTimeOut);
+	if( (OFDM_Status & 0x98) != 0x98 )
+		;//return -1;
+	//printk("lock 2\n");
+
+	{
+	    u8 Guard = (SYR_STAT & 0x03);
+	    if(Guard < 2)
+	    {
+		u8 tmp;
+		readreg(state, R367_OFDM_SYR_CTL,&tmp);
+		writereg(state, R367_OFDM_SYR_CTL,tmp & ~0x04); // Clear AUTO_LE_EN
+		readreg(state, R367_OFDM_SYR_UPDATE,&tmp);
+		writereg(state, R367_OFDM_SYR_UPDATE,tmp & ~0x10); // Clear SYR_FILTER
+	    } else {
+		u8 tmp;
+		readreg(state, R367_OFDM_SYR_CTL,&tmp);
+		writereg(state, R367_OFDM_SYR_CTL,tmp | 0x04); // Set AUTO_LE_EN
+		readreg(state, R367_OFDM_SYR_UPDATE,&tmp);
+		writereg(state, R367_OFDM_SYR_UPDATE,tmp | 0x10); // Set SYR_FILTER
+	    }
+
+	    // apply Sfec workaround if 8K 64QAM CR!=1/2
+	    if( FFTMode == 1)
+	    {
+		u8 tmp[2];
+		readregs(state, R367_OFDM_TPS_RCVD2, tmp, 2);
+		if( ((tmp[0] & 0x03) == 0x02) && (( tmp[1] & 0x07 ) != 0) )
+		{
+		    writereg(state, R367_OFDM_SFDLYSETH,0xc0);
+		    writereg(state, R367_OFDM_SFDLYSETM,0x60);
+		    writereg(state, R367_OFDM_SFDLYSETL,0x00);
+		}
+		else
+		{
+		    writereg(state, R367_OFDM_SFDLYSETH,0x00);
+		}
+	    }
+	}
+	msleep(TSTimeOut);
+	readreg(state, R367_OFDM_TSSTATUS,&TSStatus);
+	if( (TSStatus & 0x80) != 0x80 )
+		return -1;
+	//printk("lock 3\n");
+	return status;
+}
+
+
+#ifdef USE_API3
+static int set_parameters(struct dvb_frontend *fe,
+			  struct dvb_frontend_parameters *p)
+{
+	int stat;
+	struct stv_state *state = fe->demodulator_priv;
+	u32 OF = 0;
+	u32 IF;
+
+	if (fe->ops.tuner_ops.set_params)
+		fe->ops.tuner_ops.set_params(fe, p);
+
+	switch (state->omode) {
+	case OM_DVBC:
+	case OM_QAM_ITU_C:
+		state->modulation = p->u.qam.modulation;
+		state->symbol_rate = p->u.qam.symbol_rate;
+		break;
+	case OM_DVBT:
+		switch (p->u.ofdm.bandwidth) {
+		case BANDWIDTH_AUTO:
+		case BANDWIDTH_8_MHZ:
+			state->bandwidth = 8000000;
+			break;
+		case BANDWIDTH_7_MHZ:
+			state->bandwidth = 7000000;
+			break;
+		case BANDWIDTH_6_MHZ:
+			state->bandwidth = 6000000;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+#else
+static int set_parameters(struct dvb_frontend *fe)
+{
+	int stat;
+	struct stv_state *state = fe->demodulator_priv;
+	u32 OF = 0;
+	u32 IF;
+
+	switch (fe->dtv_property_cache.delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+		state->omode = OM_DVBC;
+		/* symbol rate 0 might cause an oops */
+		if (fe->dtv_property_cache.symbol_rate == 0) {
+			printk(KERN_ERR "stv0367dd: Invalid symbol rate\n");
+			return -EINVAL;
+		}
+		break;
+	case SYS_DVBT:
+		state->omode = OM_DVBT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (fe->ops.tuner_ops.set_params)
+		fe->ops.tuner_ops.set_params(fe);
+	state->modulation = fe->dtv_property_cache.modulation;
+	state->symbol_rate = fe->dtv_property_cache.symbol_rate;
+	state->bandwidth = fe->dtv_property_cache.bandwidth_hz;
+#endif
+	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+	//fe->ops.tuner_ops.get_frequency(fe, &IF);
+
+	switch(state->omode) {
+	case OM_DVBT:
+		stat = OFDM_Start(state, OF, IF);
+		ofdm_lock(state);
+		break;
+	case OM_DVBC:
+	case OM_QAM_ITU_C:
+		stat = QAM_Start(state, OF, IF);
+		break;
+	default:
+		stat = -EINVAL;
+	}
+	//printk("%s IF=%d OF=%d done\n", __FUNCTION__, IF, OF);
+	return stat;
+}
+
+#if 0
+static int c_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+{
+	//struct stv_state *state = fe->demodulator_priv;
+	//printk("%s\n", __FUNCTION__);
+	return 0;
+}
+
+static int OFDM_GetLockStatus(struct stv_state *state, LOCK_STATUS* pLockStatus, s32 Time)
+{
+	int status = STATUS_SUCCESS;
+	u8 OFDM_Status;
+	s32 DemodTimeOut = 0;
+	s32 FECTimeOut = 0;
+	s32 TSTimeOut = 0;
+	u8 CPAMPMin = 255;
+	u8 CPAMPValue;
+	bool SYRLock;
+	u8 SYR_STAT;
+	u8 FFTMode;
+	u8 TSStatus;
+
+	readreg(state, R367_OFDM_STATUS,&OFDM_Status);
+
+	SYRLock = (OFDM_Status & 0x40) != 0;
+
+	if( Time > m_SignalTimeOut && !SYRLock )
+	{
+	    *pLockStatus = NEVER_LOCK;
+	    break;
+	}
+
+	if( !SYRLock ) break;
+
+	*pLockStatus = SIGNAL_PRESENT;
+
+	// Check Mode
+
+	readreg(state, R367_OFDM_SYR_STAT,&SYR_STAT);
+	FFTMode = (SYR_STAT & 0x0C) >> 2;
+
+	switch(FFTMode)
+	{
+	    case 0: // 2K
+		DemodTimeOut = 10;
+		FECTimeOut = 150;
+		TSTimeOut = 125;
+		CPAMPMin = 20;
+		break;
+	    case 1: // 8K
+		DemodTimeOut = 55;
+		FECTimeOut = 600;
+		TSTimeOut = 500;
+		CPAMPMin = 80;
+		break;
+	    case 2: // 4K
+		DemodTimeOut = 40;
+		FECTimeOut = 300;
+		TSTimeOut = 250;
+		CPAMPMin = 30;
+		break;
+	}
+
+	m_OFDM_FFTMode = FFTMode;
+
+	if( m_DemodTimeOut == 0 && m_bFirstTimeLock )
+	{
+	    m_DemodTimeOut = Time + DemodTimeOut;
+	    //break;
+	}
+
+	readreg(state, R367_OFDM_PPM_CPAMP_DIR,&CPAMPValue);
+
+	if( Time <= m_DemodTimeOut && CPAMPValue < CPAMPMin )
+	{
+	    break;
+	}
+
+	if( CPAMPValue < CPAMPMin && m_bFirstTimeLock )
+	{
+	    // initiate retry
+	    *pLockStatus = NEVER_LOCK;
+	    break;
+	}
+
+	if( CPAMPValue < CPAMPMin ) break;
+
+	*pLockStatus = DEMOD_LOCK;
+
+	if( m_FECTimeOut == 0 && m_bFirstTimeLock )
+	{
+	    // Release FEC and Read Solomon Reset
+	    u8 tmp1;
+	    u8 tmp2;
+	    readreg(state, R367_OFDM_SFDLYSETH,&tmp1);
+	    readreg(state, R367_TSGENERAL,&tmp2);
+	    writereg(state, R367_OFDM_SFDLYSETH,tmp1 & ~0x08);
+	    writereg(state, R367_TSGENERAL,tmp2 & ~0x01);
+
+	    m_FECTimeOut = Time + FECTimeOut;
+	}
+
+	// Wait for TSP_LOCK, LK, PRF
+	if( (OFDM_Status & 0x98) != 0x98 )
+	{
+	    if( Time > m_FECTimeOut ) *pLockStatus = NEVER_LOCK;
+	    break;
+	}
+
+	if( m_bFirstTimeLock && m_TSTimeOut == 0)
+	{
+	    u8 Guard = (SYR_STAT & 0x03);
+	    if(Guard < 2)
+	    {
+		u8 tmp;
+		readreg(state, R367_OFDM_SYR_CTL,&tmp);
+		writereg(state, R367_OFDM_SYR_CTL,tmp & ~0x04); // Clear AUTO_LE_EN
+		readreg(state, R367_OFDM_SYR_UPDATE,&tmp);
+		writereg(state, R367_OFDM_SYR_UPDATE,tmp & ~0x10); // Clear SYR_FILTER
+	    } else {
+		u8 tmp;
+		readreg(state, R367_OFDM_SYR_CTL,&tmp);
+		writereg(state, R367_OFDM_SYR_CTL,tmp | 0x04); // Set AUTO_LE_EN
+		readreg(state, R367_OFDM_SYR_UPDATE,&tmp);
+		writereg(state, R367_OFDM_SYR_UPDATE,tmp | 0x10); // Set SYR_FILTER
+	    }
+
+	    // apply Sfec workaround if 8K 64QAM CR!=1/2
+	    if( FFTMode == 1)
+	    {
+		u8 tmp[2];
+		readreg(state, R367_OFDM_TPS_RCVD2,tmp,2);
+		if( ((tmp[0] & 0x03) == 0x02) && (( tmp[1] & 0x07 ) != 0) )
+		{
+		    writereg(state, R367_OFDM_SFDLYSETH,0xc0);
+		    writereg(state, R367_OFDM_SFDLYSETM,0x60);
+		    writereg(state, R367_OFDM_SFDLYSETL,0x00);
+		}
+		else
+		{
+		    writereg(state, R367_OFDM_SFDLYSETH,0x00);
+		}
+	    }
+
+	    m_TSTimeOut = Time + TSTimeOut;
+	}
+	readreg(state, R367_OFDM_TSSTATUS,&TSStatus);
+	if( (TSStatus & 0x80) != 0x80 )
+	{
+		if( Time > m_TSTimeOut ) *pLockStatus = NEVER_LOCK;
+	    break;
+	}
+	*pLockStatus = MPEG_LOCK;
+	m_bFirstTimeLock = false;
+	return status;
+}
+
+#endif
+
+static int read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct stv_state *state = fe->demodulator_priv;
+	*status=0;
+
+	switch(state->demod_state) {
+	case QAMStarted:
+	{
+		u8 FEC_Lock;
+		u8 QAM_Lock;
+
+		readreg(state, R367_QAM_FSM_STS, &QAM_Lock);
+		QAM_Lock &= 0x0F;
+		if (QAM_Lock >10)
+			*status|=0x07;
+		readreg(state, R367_QAM_FEC_STATUS,&FEC_Lock);
+		if (FEC_Lock&2)
+			*status|=0x1f;
+		if (state->m_bFirstTimeLock) {
+			state->m_bFirstTimeLock = false;
+			// QAM_AGC_ACCUMRSTSEL to Tracking;
+			writereg(state, R367_QAM_AGC_CTL, state->m_Save_QAM_AGC_CTL);
+		}
+		break;
+	}
+	case OFDMStarted:
+	{
+		u8 OFDM_Status;
+		u8 TSStatus;
+
+		readreg(state, R367_OFDM_TSSTATUS, &TSStatus);
+
+		readreg(state, R367_OFDM_STATUS, &OFDM_Status);
+		if (OFDM_Status & 0x40)
+			*status |= FE_HAS_SIGNAL;
+
+		if ((OFDM_Status & 0x98) == 0x98)
+			*status|=0x0f;
+
+		if (TSStatus & 0x80)
+			*status |= 0x1f;
+		break;
+	}
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int read_ber_ter(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv_state *state = fe->demodulator_priv;
+	u32 err;
+	u8 cnth, cntm, cntl;
+
+#if 1
+	readreg(state, R367_OFDM_SFERRCNTH, &cnth);
+
+	if (cnth & 0x80) {
+		*ber = state->ber; 
+		return 0;
+	}
+
+	readreg(state, R367_OFDM_SFERRCNTM, &cntm);
+	readreg(state, R367_OFDM_SFERRCNTL, &cntl);
+
+	err = ((cnth & 0x7f) << 16) | (cntm << 8) | cntl;
+	
+#if 0
+	{
+		u64 err64;
+		err64 = (u64) err;
+		err64 *= 1000000000ULL;
+		err64 >>= 21;
+		err = err64;
+	}
+#endif
+#else
+	readreg(state, R367_OFDM_ERRCNT1HM, &cnth);
+
+#endif
+	*ber = state->ber = err;
+	return 0;
+}
+
+static int read_ber_cab(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv_state *state = fe->demodulator_priv;
+	u32 err;
+	u8 cntm, cntl, ctrl;
+
+	readreg(state, R367_QAM_BERT_1, &ctrl);
+	if (!(ctrl & 0x20)) {
+		readreg(state, R367_QAM_BERT_2, &cntl);
+		readreg(state, R367_QAM_BERT_3, &cntm);
+		err = (cntm << 8) | cntl;
+		//printk("err %04x\n", err);
+		state->ber = err;
+		writereg(state, R367_QAM_BERT_1, 0x27);
+	}
+	*ber = (u32) state->ber;
+	return 0;
+}
+
+static int read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv_state *state = fe->demodulator_priv;
+
+	if (state->demod_state == QAMStarted)
+		return read_ber_cab(fe, ber);
+	if (state->demod_state == OFDMStarted)
+		return read_ber_ter(fe, ber);
+	*ber = 0;
+	return 0;
+}
+
+static int read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	if (fe->ops.tuner_ops.get_rf_strength)
+		fe->ops.tuner_ops.get_rf_strength(fe, strength);
+	else
+		*strength = 0;
+	return 0;
+}
+
+static int read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+ 	struct stv_state *state = fe->demodulator_priv;
+	s32 snr2 = 0;
+
+	switch(state->demod_state) {
+	case QAMStarted:
+		QAM_GetSignalToNoise(state, &snr2);
+		break;
+	case OFDMStarted:
+		OFDM_GetSignalToNoise(state, &snr2);
+		break;
+	default:
+		break;
+	}
+	*snr = snr2&0xffff;
+	return 0;
+}
+
+static int read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct stv_state *state = fe->demodulator_priv;
+	u8 errl, errm, errh;
+	u8 val;
+
+	switch(state->demod_state) {
+	case QAMStarted:
+		readreg(state, R367_QAM_RS_COUNTER_4, &errl);
+		readreg(state, R367_QAM_RS_COUNTER_5, &errm);
+		*ucblocks = (errm << 8) | errl;
+		break;
+	case OFDMStarted:
+		readreg(state, R367_OFDM_SFERRCNTH, &val);
+		if ((val & 0x80) == 0) {
+			readreg(state, R367_OFDM_ERRCNT1H, &errh);
+			readreg(state, R367_OFDM_ERRCNT1M, &errl);
+			readreg(state, R367_OFDM_ERRCNT1L, &errm);
+			state->ucblocks = (errh <<16) | (errm << 8) | errl;
+		}
+		*ucblocks = state->ucblocks;
+		break;
+	default:
+		*ucblocks = 0;
+		break;
+	}
+	return 0;
+}
+
+static int c_get_tune_settings(struct dvb_frontend *fe,
+				    struct dvb_frontend_tune_settings *sets)
+{
+	sets->min_delay_ms=3000;
+	sets->max_drift=0;
+	sets->step_size=0;
+	return 0;
+}
+
+#ifndef USE_API3
+static int get_tune_settings(struct dvb_frontend *fe,
+			     struct dvb_frontend_tune_settings *sets)
+{
+	switch (fe->dtv_property_cache.delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		return c_get_tune_settings(fe, sets);
+	default:
+		/* DVB-T: Use info.frequency_stepsize. */
+		return -EINVAL;
+	}
+}
+#endif
+
+#ifdef USE_API3
+static void t_release(struct dvb_frontend* fe)
+{
+	//struct stv_state *state=fe->demodulator_priv;
+	//printk("%s\n", __FUNCTION__);
+	//kfree(state);
+}
+
+static int t_init (struct dvb_frontend *fe)
+{
+	struct stv_state *state=fe->demodulator_priv;
+	if (mutex_trylock(&state->ctlock)==0)
+		return -EBUSY;
+	state->omode = OM_DVBT;
+	return 0;
+}
+
+static int t_sleep(struct dvb_frontend* fe)
+{
+	struct stv_state *state=fe->demodulator_priv;
+	mutex_unlock(&state->ctlock);
+	return 0;
+}
+#endif
+
+#if 0
+static int t_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+{
+	//struct stv_state *state = fe->demodulator_priv;
+	//printk("%s\n", __FUNCTION__);
+	return 0;
+}
+
+static enum dvbfe_algo algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_CUSTOM;
+}
+#endif
+
+#ifdef USE_API3
+static struct dvb_frontend_ops c_ops = {
+	.info = {
+		.name = "STV0367 DVB-C",
+		.type = FE_QAM,
+		.frequency_stepsize = 62500,
+		.frequency_min = 47000000,
+		.frequency_max = 862000000,
+		.symbol_rate_min = 870000,
+		.symbol_rate_max = 11700000,
+		.caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_FEC_AUTO
+	},
+	.release = c_release,
+	.init = c_init,
+	.sleep = c_sleep,
+	.i2c_gate_ctrl = gate_ctrl,
+
+	.get_tune_settings = c_get_tune_settings,
+
+	.read_status = read_status,
+	.read_ber = read_ber,
+	.read_signal_strength = read_signal_strength,
+	.read_snr = read_snr,
+	.read_ucblocks = read_ucblocks,
+
+#if 1
+	.set_frontend = set_parameters,
+#else
+	.get_frontend_algo = algo,
+	.search = search,
+#endif
+};
+
+static struct dvb_frontend_ops t_ops = {
+	.info = {
+		.name			= "STV0367 DVB-T",
+		.type			= FE_OFDM,
+		.frequency_min		= 47125000,
+		.frequency_max		= 865000000,
+		.frequency_stepsize	= 166667,
+		.frequency_tolerance	= 0,
+		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
+		FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
+		FE_CAN_FEC_AUTO |
+		FE_CAN_QAM_16 | FE_CAN_QAM_64 |
+		FE_CAN_QAM_AUTO |
+		FE_CAN_TRANSMISSION_MODE_AUTO |
+		FE_CAN_GUARD_INTERVAL_AUTO |
+		FE_CAN_HIERARCHY_AUTO | FE_CAN_RECOVER |
+		FE_CAN_MUTE_TS
+	},
+	.release = t_release,
+	.init = t_init,
+	.sleep = t_sleep,
+	.i2c_gate_ctrl = gate_ctrl,
+
+	.set_frontend = set_parameters,
+
+	.read_status = read_status,
+	.read_ber = read_ber,
+	.read_signal_strength = read_signal_strength,
+	.read_snr = read_snr,
+	.read_ucblocks = read_ucblocks,
+};
+
+#else
+
+static struct dvb_frontend_ops common_ops = {
+	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBT },
+	.info = {
+		.name = "STV0367 DVB-C DVB-T",
+		.frequency_stepsize = 166667,	/* DVB-T only */
+		.frequency_min = 47000000,	/* DVB-T: 47125000 */
+		.frequency_max = 865000000,	/* DVB-C: 862000000 */
+		.symbol_rate_min = 870000,
+		.symbol_rate_max = 11700000,
+		.caps = /* DVB-C */
+			FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 |
+			FE_CAN_FEC_AUTO |
+			/* DVB-T */
+			FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO |
+			FE_CAN_RECOVER | FE_CAN_MUTE_TS
+	},
+	.release = release,
+	.i2c_gate_ctrl = gate_ctrl,
+
+	.get_tune_settings = get_tune_settings,
+
+	.set_frontend = set_parameters,
+
+	.read_status = read_status,
+	.read_ber = read_ber,
+	.read_signal_strength = read_signal_strength,
+	.read_snr = read_snr,
+	.read_ucblocks = read_ucblocks,
+};
+#endif
+
+
+static void init_state(struct stv_state *state, struct stv0367_cfg *cfg)
+{
+	u32 ulENARPTLEVEL = 5;
+	u32 ulQAMInversion = 2;
+	state->omode = OM_NONE;
+	state->adr = cfg->adr;
+
+	mutex_init(&state->mutex);
+	mutex_init(&state->ctlock);
+
+#ifdef USE_API3
+	memcpy(&state->c_frontend.ops, &c_ops, sizeof(struct dvb_frontend_ops));
+	memcpy(&state->t_frontend.ops, &t_ops, sizeof(struct dvb_frontend_ops));
+	state->c_frontend.demodulator_priv = state;
+	state->t_frontend.demodulator_priv = state;
+#else
+	memcpy(&state->frontend.ops, &common_ops, sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+#endif
+
+	state->master_clock = 58000000;
+	state->adc_clock = 58000000;
+	state->I2CRPT = 0x08 | ((ulENARPTLEVEL & 0x07) << 4);
+	state->qam_inversion = ((ulQAMInversion & 3) << 6 );
+	state->demod_state   = Off;
+}
+
+
+struct dvb_frontend *stv0367_attach(struct i2c_adapter *i2c, struct stv0367_cfg *cfg,
+				    struct dvb_frontend **fe_t)
+{
+	struct stv_state *state = NULL;
+
+	state = kzalloc(sizeof(struct stv_state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->i2c = i2c;
+	init_state(state, cfg);
+
+	if (attach_init(state)<0)
+		goto error;
+#ifdef USE_API3
+	*fe_t = &state->t_frontend;
+	return &state->c_frontend;
+#else
+	return &state->frontend;
+#endif
+
+error:
+	printk("stv0367: not found\n");
+	kfree(state);
+	return NULL;
+}
+
+
+MODULE_DESCRIPTION("STV0367DD driver");
+MODULE_AUTHOR("Ralph Metzler, Manfred Voelkel");
+MODULE_LICENSE("GPL");
+
+EXPORT_SYMBOL(stv0367_attach);
+
+
+
diff --git a/drivers/media/dvb-frontends/stv0367dd.h b/drivers/media/dvb-frontends/stv0367dd.h
new file mode 100644
index 0000000..a13df69
--- /dev/null
+++ b/drivers/media/dvb-frontends/stv0367dd.h
@@ -0,0 +1,48 @@
+/*
+ *  stv0367dd.h: STV0367 DVB-C/T demodulator driver
+ *
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
+ */
+
+#ifndef _STV0367DD_H_
+#define _STV0367DD_H_
+
+#include <linux/types.h>
+#include <linux/i2c.h>
+
+struct stv0367_cfg {
+	u8  adr;
+	u32 xtal;
+	u32 ts_mode;
+};
+
+#if IS_ENABLED(CONFIG_DVB_STV0367DD)
+extern struct dvb_frontend *stv0367_attach(struct i2c_adapter *i2c,
+					   struct stv0367_cfg *cfg,
+					   struct dvb_frontend **fe_t);
+#else
+static inline struct dvb_frontend *stv0367_attach(struct i2c_adapter *i2c,
+						  struct stv0367_cfg *cfg,
+						  struct dvb_frontend **fe_t);
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/dvb-frontends/stv0367dd_regs.h b/drivers/media/dvb-frontends/stv0367dd_regs.h
new file mode 100644
index 0000000..3881f55
--- /dev/null
+++ b/drivers/media/dvb-frontends/stv0367dd_regs.h
@@ -0,0 +1,3442 @@
+/*
+ *  stv0367dd_regs.h: DVB-C/DVB-T STMicroelectronics STV0367
+ *                    register defintions
+ *
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
+ */
+
+#ifndef _STV0367DD_REGS_H_
+#define _STV0367DD_REGS_H_
+
+/* ID */
+#define	R367_ID		0xF000
+#define	F367_IDENTIFICATIONREG		0xF00000FF
+
+/* I2CRPT */
+#define	R367_I2CRPT		0xF001
+#define	F367_I2CT_ON		0xF0010080
+#define	F367_ENARPT_LEVEL		0xF0010070
+#define	F367_SCLT_DELAY		0xF0010008
+#define	F367_SCLT_NOD		0xF0010004
+#define	F367_STOP_ENABLE		0xF0010002
+#define	F367_SDAT_NOD		0xF0010001
+
+/* TOPCTRL */
+#define	R367_TOPCTRL		0xF002
+#define	F367_STDBY		0xF0020080
+#define	F367_STDBY_FEC		0xF0020040
+#define	F367_STDBY_CORE		0xF0020020
+#define	F367_QAM_COFDM		0xF0020010
+#define	F367_TS_DIS		0xF0020008
+#define	F367_DIR_CLK_216		0xF0020004
+#define	F367_TUNER_BB		0xF0020002
+#define	F367_DVBT_H		0xF0020001
+
+/* IOCFG0 */
+#define	R367_IOCFG0		0xF003
+#define	F367_OP0_SD		0xF0030080
+#define	F367_OP0_VAL		0xF0030040
+#define	F367_OP0_OD		0xF0030020
+#define	F367_OP0_INV		0xF0030010
+#define	F367_OP0_DACVALUE_HI		0xF003000F
+
+/* DAC0R */
+#define	R367_DAC0R		0xF004
+#define	F367_OP0_DACVALUE_LO		0xF00400FF
+
+/* IOCFG1 */
+#define	R367_IOCFG1		0xF005
+#define	F367_IP0		0xF0050040
+#define	F367_OP1_OD		0xF0050020
+#define	F367_OP1_INV		0xF0050010
+#define	F367_OP1_DACVALUE_HI		0xF005000F
+
+/* DAC1R */
+#define	R367_DAC1R		0xF006
+#define	F367_OP1_DACVALUE_LO		0xF00600FF
+
+/* IOCFG2 */
+#define	R367_IOCFG2		0xF007
+#define	F367_OP2_LOCK_CONF		0xF00700E0
+#define	F367_OP2_OD		0xF0070010
+#define	F367_OP2_VAL		0xF0070008
+#define	F367_OP1_LOCK_CONF		0xF0070007
+
+/* SDFR */
+#define	R367_SDFR		0xF008
+#define	F367_OP0_FREQ		0xF00800F0
+#define	F367_OP1_FREQ		0xF008000F
+
+/* STATUS */
+#define	R367_OFDM_STATUS		0xF009
+#define	F367_TPS_LOCK		0xF0090080
+#define	F367_SYR_LOCK		0xF0090040
+#define	F367_AGC_LOCK		0xF0090020
+#define	F367_PRF		0xF0090010
+#define	F367_LK		0xF0090008
+#define	F367_PR		0xF0090007
+
+/* AUX_CLK */
+#define	R367_AUX_CLK		0xF00A
+#define	F367_AUXFEC_CTL		0xF00A00C0
+#define	F367_DIS_CKX4		0xF00A0020
+#define	F367_CKSEL		0xF00A0018
+#define	F367_CKDIV_PROG		0xF00A0006
+#define	F367_AUXCLK_ENA		0xF00A0001
+
+/* FREESYS1 */
+#define	R367_FREESYS1		0xF00B
+#define	F367_FREE_SYS1		0xF00B00FF
+
+/* FREESYS2 */
+#define	R367_FREESYS2		0xF00C
+#define	F367_FREE_SYS2		0xF00C00FF
+
+/* FREESYS3 */
+#define	R367_FREESYS3		0xF00D
+#define	F367_FREE_SYS3		0xF00D00FF
+
+/* GPIO_CFG */
+#define	R367_GPIO_CFG		0xF00E
+#define	F367_GPIO7_NOD		0xF00E0080
+#define	F367_GPIO7_CFG		0xF00E0040
+#define	F367_GPIO6_NOD		0xF00E0020
+#define	F367_GPIO6_CFG		0xF00E0010
+#define	F367_GPIO5_NOD		0xF00E0008
+#define	F367_GPIO5_CFG		0xF00E0004
+#define	F367_GPIO4_NOD		0xF00E0002
+#define	F367_GPIO4_CFG		0xF00E0001
+
+/* GPIO_CMD */
+#define	R367_GPIO_CMD		0xF00F
+#define	F367_GPIO7_VAL		0xF00F0008
+#define	F367_GPIO6_VAL		0xF00F0004
+#define	F367_GPIO5_VAL		0xF00F0002
+#define	F367_GPIO4_VAL		0xF00F0001
+
+/* AGC2MAX */
+#define	R367_OFDM_AGC2MAX		0xF010
+#define	F367_OFDM_AGC2_MAX		0xF01000FF
+
+/* AGC2MIN */
+#define	R367_OFDM_AGC2MIN		0xF011
+#define	F367_OFDM_AGC2_MIN		0xF01100FF
+
+/* AGC1MAX */
+#define	R367_OFDM_AGC1MAX		0xF012
+#define	F367_OFDM_AGC1_MAX		0xF01200FF
+
+/* AGC1MIN */
+#define	R367_OFDM_AGC1MIN		0xF013
+#define	F367_OFDM_AGC1_MIN		0xF01300FF
+
+/* AGCR */
+#define	R367_OFDM_AGCR		0xF014
+#define	F367_OFDM_RATIO_A		0xF01400E0
+#define	F367_OFDM_RATIO_B		0xF0140018
+#define	F367_OFDM_RATIO_C		0xF0140007
+
+/* AGC2TH */
+#define	R367_OFDM_AGC2TH		0xF015
+#define	F367_OFDM_AGC2_THRES		0xF01500FF
+
+/* AGC12C */
+#define	R367_OFDM_AGC12C		0xF016
+#define	F367_OFDM_AGC1_IV		0xF0160080
+#define	F367_OFDM_AGC1_OD		0xF0160040
+#define	F367_OFDM_AGC1_LOAD		0xF0160020
+#define	F367_OFDM_AGC2_IV		0xF0160010
+#define	F367_OFDM_AGC2_OD		0xF0160008
+#define	F367_OFDM_AGC2_LOAD		0xF0160004
+#define	F367_OFDM_AGC12_MODE		0xF0160003
+
+/* AGCCTRL1 */
+#define	R367_OFDM_AGCCTRL1		0xF017
+#define	F367_OFDM_DAGC_ON		0xF0170080
+#define	F367_OFDM_INVERT_AGC12		0xF0170040
+#define	F367_OFDM_AGC1_MODE		0xF0170008
+#define	F367_OFDM_AGC2_MODE		0xF0170007
+
+/* AGCCTRL2 */
+#define	R367_OFDM_AGCCTRL2		0xF018
+#define	F367_OFDM_FRZ2_CTRL		0xF0180060
+#define	F367_OFDM_FRZ1_CTRL		0xF0180018
+#define	F367_OFDM_TIME_CST		0xF0180007
+
+/* AGC1VAL1 */
+#define	R367_OFDM_AGC1VAL1		0xF019
+#define	F367_OFDM_AGC1_VAL_LO		0xF01900FF
+
+/* AGC1VAL2 */
+#define	R367_OFDM_AGC1VAL2		0xF01A
+#define	F367_OFDM_AGC1_VAL_HI		0xF01A000F
+
+/* AGC2VAL1 */
+#define	R367_OFDM_AGC2VAL1		0xF01B
+#define	F367_OFDM_AGC2_VAL_LO		0xF01B00FF
+
+/* AGC2VAL2 */
+#define	R367_OFDM_AGC2VAL2		0xF01C
+#define	F367_OFDM_AGC2_VAL_HI		0xF01C000F
+
+/* AGC2PGA */
+#define	R367_OFDM_AGC2PGA		0xF01D
+#define	F367_OFDM_AGC2_PGA		0xF01D00FF
+
+/* OVF_RATE1 */
+#define	R367_OFDM_OVF_RATE1		0xF01E
+#define	F367_OFDM_OVF_RATE_HI		0xF01E000F
+
+/* OVF_RATE2 */
+#define	R367_OFDM_OVF_RATE2		0xF01F
+#define	F367_OFDM_OVF_RATE_LO		0xF01F00FF
+
+/* GAIN_SRC1 */
+#define	R367_OFDM_GAIN_SRC1		0xF020
+#define	F367_OFDM_INV_SPECTR		0xF0200080
+#define	F367_OFDM_IQ_INVERT		0xF0200040
+#define	F367_OFDM_INR_BYPASS		0xF0200020
+#define	F367_OFDM_STATUS_INV_SPECRUM		0xF0200010
+#define	F367_OFDM_GAIN_SRC_HI		0xF020000F
+
+/* GAIN_SRC2 */
+#define	R367_OFDM_GAIN_SRC2		0xF021
+#define	F367_OFDM_GAIN_SRC_LO		0xF02100FF
+
+/* INC_DEROT1 */
+#define	R367_OFDM_INC_DEROT1		0xF022
+#define	F367_OFDM_INC_DEROT_HI		0xF02200FF
+
+/* INC_DEROT2 */
+#define	R367_OFDM_INC_DEROT2		0xF023
+#define	F367_OFDM_INC_DEROT_LO		0xF02300FF
+
+/* PPM_CPAMP_DIR */
+#define	R367_OFDM_PPM_CPAMP_DIR		0xF024
+#define	F367_OFDM_PPM_CPAMP_DIRECT		0xF02400FF
+
+/* PPM_CPAMP_INV */
+#define	R367_OFDM_PPM_CPAMP_INV		0xF025
+#define	F367_OFDM_PPM_CPAMP_INVER		0xF02500FF
+
+/* FREESTFE_1 */
+#define	R367_OFDM_FREESTFE_1		0xF026
+#define	F367_OFDM_SYMBOL_NUMBER_INC		0xF02600C0
+#define	F367_OFDM_SEL_LSB		0xF0260004
+#define	F367_OFDM_AVERAGE_ON		0xF0260002
+#define	F367_OFDM_DC_ADJ		0xF0260001
+
+/* FREESTFE_2 */
+#define	R367_OFDM_FREESTFE_2		0xF027
+#define	F367_OFDM_SEL_SRCOUT		0xF02700C0
+#define	F367_OFDM_SEL_SYRTHR		0xF027001F
+
+/* DCOFFSET */
+#define	R367_OFDM_DCOFFSET		0xF028
+#define	F367_OFDM_SELECT_I_Q		0xF0280080
+#define	F367_OFDM_DC_OFFSET		0xF028007F
+
+/* EN_PROCESS */
+#define	R367_OFDM_EN_PROCESS		0xF029
+#define	F367_OFDM_FREE		0xF02900F0
+#define	F367_OFDM_ENAB_MANUAL		0xF0290001
+
+/* SDI_SMOOTHER */
+#define	R367_OFDM_SDI_SMOOTHER		0xF02A
+#define	F367_OFDM_DIS_SMOOTH		0xF02A0080
+#define	F367_OFDM_SDI_INC_SMOOTHER		0xF02A007F
+
+/* FE_LOOP_OPEN */
+#define	R367_OFDM_FE_LOOP_OPEN		0xF02B
+#define	F367_OFDM_TRL_LOOP_OP		0xF02B0002
+#define	F367_OFDM_CRL_LOOP_OP		0xF02B0001
+
+/* FREQOFF1 */
+#define	R367_OFDM_FREQOFF1		0xF02C
+#define	F367_OFDM_FREQ_OFFSET_LOOP_OPEN_VHI		0xF02C00FF
+
+/* FREQOFF2 */
+#define	R367_OFDM_FREQOFF2		0xF02D
+#define	F367_OFDM_FREQ_OFFSET_LOOP_OPEN_HI		0xF02D00FF
+
+/* FREQOFF3 */
+#define	R367_OFDM_FREQOFF3		0xF02E
+#define	F367_OFDM_FREQ_OFFSET_LOOP_OPEN_LO		0xF02E00FF
+
+/* TIMOFF1 */
+#define	R367_OFDM_TIMOFF1		0xF02F
+#define	F367_OFDM_TIM_OFFSET_LOOP_OPEN_HI		0xF02F00FF
+
+/* TIMOFF2 */
+#define	R367_OFDM_TIMOFF2		0xF030
+#define	F367_OFDM_TIM_OFFSET_LOOP_OPEN_LO		0xF03000FF
+
+/* EPQ */
+#define	R367_OFDM_EPQ		0xF031
+#define	F367_OFDM_EPQ1		0xF03100FF
+
+/* EPQAUTO */
+#define	R367_OFDM_EPQAUTO		0xF032
+#define	F367_OFDM_EPQ2		0xF03200FF
+
+/* SYR_UPDATE */
+#define	R367_OFDM_SYR_UPDATE		0xF033
+#define	F367_OFDM_SYR_PROTV		0xF0330080
+#define	F367_OFDM_SYR_PROTV_GAIN		0xF0330060
+#define	F367_OFDM_SYR_FILTER		0xF0330010
+#define	F367_OFDM_SYR_TRACK_THRES		0xF033000C
+
+/* CHPFREE */
+#define	R367_OFDM_CHPFREE		0xF034
+#define	F367_OFDM_CHP_FREE		0xF03400FF
+
+/* PPM_STATE_MAC */
+#define	R367_OFDM_PPM_STATE_MAC		0xF035
+#define	F367_OFDM_PPM_STATE_MACHINE_DECODER		0xF035003F
+
+/* INR_THRESHOLD */
+#define	R367_OFDM_INR_THRESHOLD		0xF036
+#define	F367_OFDM_INR_THRESH		0xF03600FF
+
+/* EPQ_TPS_ID_CELL */
+#define	R367_OFDM_EPQ_TPS_ID_CELL		0xF037
+#define	F367_OFDM_ENABLE_LGTH_TO_CF		0xF0370080
+#define	F367_OFDM_DIS_TPS_RSVD		0xF0370040
+#define	F367_OFDM_DIS_BCH		0xF0370020
+#define	F367_OFDM_DIS_ID_CEL		0xF0370010
+#define	F367_OFDM_TPS_ADJUST_SYM		0xF037000F
+
+/* EPQ_CFG */
+#define	R367_OFDM_EPQ_CFG		0xF038
+#define	F367_OFDM_EPQ_RANGE		0xF0380002
+#define	F367_OFDM_EPQ_SOFT		0xF0380001
+
+/* EPQ_STATUS */
+#define	R367_OFDM_EPQ_STATUS		0xF039
+#define	F367_OFDM_SLOPE_INC		0xF03900FC
+#define	F367_OFDM_TPS_FIELD		0xF0390003
+
+/* AUTORELOCK */
+#define	R367_OFDM_AUTORELOCK		0xF03A
+#define	F367_OFDM_BYPASS_BER_TEMPO		0xF03A0080
+#define	F367_OFDM_BER_TEMPO		0xF03A0070
+#define	F367_OFDM_BYPASS_COFDM_TEMPO		0xF03A0008
+#define	F367_OFDM_COFDM_TEMPO		0xF03A0007
+
+/* BER_THR_VMSB */
+#define	R367_OFDM_BER_THR_VMSB		0xF03B
+#define	F367_OFDM_BER_THRESHOLD_HI		0xF03B00FF
+
+/* BER_THR_MSB */
+#define	R367_OFDM_BER_THR_MSB		0xF03C
+#define	F367_OFDM_BER_THRESHOLD_MID		0xF03C00FF
+
+/* BER_THR_LSB */
+#define	R367_OFDM_BER_THR_LSB		0xF03D
+#define	F367_OFDM_BER_THRESHOLD_LO		0xF03D00FF
+
+/* CCD */
+#define	R367_OFDM_CCD		0xF03E
+#define	F367_OFDM_CCD_DETECTED		0xF03E0080
+#define	F367_OFDM_CCD_RESET		0xF03E0040
+#define	F367_OFDM_CCD_THRESHOLD		0xF03E000F
+
+/* SPECTR_CFG */
+#define	R367_OFDM_SPECTR_CFG		0xF03F
+#define	F367_OFDM_SPECT_CFG		0xF03F0003
+
+/* CONSTMU_MSB */
+#define	R367_OFDM_CONSTMU_MSB		0xF040
+#define	F367_OFDM_CONSTMU_FREEZE		0xF0400080
+#define	F367_OFDM_CONSTNU_FORCE_EN		0xF0400040
+#define	F367_OFDM_CONST_MU_MSB		0xF040003F
+
+/* CONSTMU_LSB */
+#define	R367_OFDM_CONSTMU_LSB		0xF041
+#define	F367_OFDM_CONST_MU_LSB		0xF04100FF
+
+/* CONSTMU_MAX_MSB */
+#define	R367_OFDM_CONSTMU_MAX_MSB		0xF042
+#define	F367_OFDM_CONST_MU_MAX_MSB		0xF042003F
+
+/* CONSTMU_MAX_LSB */
+#define	R367_OFDM_CONSTMU_MAX_LSB		0xF043
+#define	F367_OFDM_CONST_MU_MAX_LSB		0xF04300FF
+
+/* ALPHANOISE */
+#define	R367_OFDM_ALPHANOISE		0xF044
+#define	F367_OFDM_USE_ALLFILTER		0xF0440080
+#define	F367_OFDM_INTER_ON		0xF0440040
+#define	F367_OFDM_ALPHA_NOISE		0xF044001F
+
+/* MAXGP_MSB */
+#define	R367_OFDM_MAXGP_MSB		0xF045
+#define	F367_OFDM_MUFILTER_LENGTH		0xF04500F0
+#define	F367_OFDM_MAX_GP_MSB		0xF045000F
+
+/* MAXGP_LSB */
+#define	R367_OFDM_MAXGP_LSB		0xF046
+#define	F367_OFDM_MAX_GP_LSB		0xF04600FF
+
+/* ALPHAMSB */
+#define	R367_OFDM_ALPHAMSB		0xF047
+#define	F367_OFDM_CHC_DATARATE		0xF04700C0
+#define	F367_OFDM_ALPHA_MSB		0xF047003F
+
+/* ALPHALSB */
+#define	R367_OFDM_ALPHALSB		0xF048
+#define	F367_OFDM_ALPHA_LSB		0xF04800FF
+
+/* PILOT_ACCU */
+#define	R367_OFDM_PILOT_ACCU		0xF049
+#define	F367_OFDM_USE_SCAT4ADDAPT		0xF0490080
+#define	F367_OFDM_PILOT_ACC		0xF049001F
+
+/* PILOTMU_ACCU */
+#define	R367_OFDM_PILOTMU_ACCU		0xF04A
+#define	F367_OFDM_DISCARD_BAD_SP		0xF04A0080
+#define	F367_OFDM_DISCARD_BAD_CP		0xF04A0040
+#define	F367_OFDM_PILOT_MU_ACCU		0xF04A001F
+
+/* FILT_CHANNEL_EST */
+#define	R367_OFDM_FILT_CHANNEL_EST		0xF04B
+#define	F367_OFDM_USE_FILT_PILOT		0xF04B0080
+#define	F367_OFDM_FILT_CHANNEL		0xF04B007F
+
+/* ALPHA_NOPISE_FREQ */
+#define	R367_OFDM_ALPHA_NOPISE_FREQ		0xF04C
+#define	F367_OFDM_NOISE_FREQ_FILT		0xF04C0040
+#define	F367_OFDM_ALPHA_NOISE_FREQ		0xF04C003F
+
+/* RATIO_PILOT */
+#define	R367_OFDM_RATIO_PILOT		0xF04D
+#define	F367_OFDM_RATIO_MEAN_SP		0xF04D00F0
+#define	F367_OFDM_RATIO_MEAN_CP		0xF04D000F
+
+/* CHC_CTL */
+#define	R367_OFDM_CHC_CTL		0xF04E
+#define	F367_OFDM_TRACK_EN		0xF04E0080
+#define	F367_OFDM_NOISE_NORM_EN		0xF04E0040
+#define	F367_OFDM_FORCE_CHC_RESET		0xF04E0020
+#define	F367_OFDM_SHORT_TIME		0xF04E0010
+#define	F367_OFDM_FORCE_STATE_EN		0xF04E0008
+#define	F367_OFDM_FORCE_STATE		0xF04E0007
+
+/* EPQ_ADJUST */
+#define	R367_OFDM_EPQ_ADJUST		0xF04F
+#define	F367_OFDM_ADJUST_SCAT_IND		0xF04F00C0
+#define	F367_OFDM_ONE_SYMBOL		0xF04F0010
+#define	F367_OFDM_EPQ_DECAY		0xF04F000E
+#define	F367_OFDM_HOLD_SLOPE		0xF04F0001
+
+/* EPQ_THRES */
+#define	R367_OFDM_EPQ_THRES		0xF050
+#define	F367_OFDM_EPQ_THR		0xF05000FF
+
+/* OMEGA_CTL */
+#define	R367_OFDM_OMEGA_CTL		0xF051
+#define	F367_OFDM_OMEGA_RST		0xF0510080
+#define	F367_OFDM_FREEZE_OMEGA		0xF0510040
+#define	F367_OFDM_OMEGA_SEL		0xF051003F
+
+/* GP_CTL */
+#define	R367_OFDM_GP_CTL		0xF052
+#define	F367_OFDM_CHC_STATE		0xF05200E0
+#define	F367_OFDM_FREEZE_GP		0xF0520010
+#define	F367_OFDM_GP_SEL		0xF052000F
+
+/* MUMSB */
+#define	R367_OFDM_MUMSB		0xF053
+#define	F367_OFDM_MU_MSB		0xF053007F
+
+/* MULSB */
+#define	R367_OFDM_MULSB		0xF054
+#define	F367_OFDM_MU_LSB		0xF05400FF
+
+/* GPMSB */
+#define	R367_OFDM_GPMSB		0xF055
+#define	F367_OFDM_CSI_THRESHOLD		0xF05500E0
+#define	F367_OFDM_GP_MSB		0xF055000F
+
+/* GPLSB */
+#define	R367_OFDM_GPLSB		0xF056
+#define	F367_OFDM_GP_LSB		0xF05600FF
+
+/* OMEGAMSB */
+#define	R367_OFDM_OMEGAMSB		0xF057
+#define	F367_OFDM_OMEGA_MSB		0xF057007F
+
+/* OMEGALSB */
+#define	R367_OFDM_OMEGALSB		0xF058
+#define	F367_OFDM_OMEGA_LSB		0xF05800FF
+
+/* SCAT_NB */
+#define	R367_OFDM_SCAT_NB		0xF059
+#define	F367_OFDM_CHC_TEST		0xF05900F8
+#define	F367_OFDM_SCAT_NUMB		0xF0590003
+
+/* CHC_DUMMY */
+#define	R367_OFDM_CHC_DUMMY		0xF05A
+#define	F367_OFDM_CHC_DUM		0xF05A00FF
+
+/* INC_CTL */
+#define	R367_OFDM_INC_CTL		0xF05B
+#define	F367_OFDM_INC_BYPASS		0xF05B0080
+#define	F367_OFDM_INC_NDEPTH		0xF05B000C
+#define	F367_OFDM_INC_MADEPTH		0xF05B0003
+
+/* INCTHRES_COR1 */
+#define	R367_OFDM_INCTHRES_COR1		0xF05C
+#define	F367_OFDM_INC_THRES_COR1		0xF05C00FF
+
+/* INCTHRES_COR2 */
+#define	R367_OFDM_INCTHRES_COR2		0xF05D
+#define	F367_OFDM_INC_THRES_COR2		0xF05D00FF
+
+/* INCTHRES_DET1 */
+#define	R367_OFDM_INCTHRES_DET1		0xF05E
+#define	F367_OFDM_INC_THRES_DET1		0xF05E003F
+
+/* INCTHRES_DET2 */
+#define	R367_OFDM_INCTHRES_DET2		0xF05F
+#define	F367_OFDM_INC_THRES_DET2		0xF05F003F
+
+/* IIR_CELLNB */
+#define	R367_OFDM_IIR_CELLNB		0xF060
+#define	F367_OFDM_NRST_IIR		0xF0600080
+#define	F367_OFDM_IIR_CELL_NB		0xF0600007
+
+/* IIRCX_COEFF1_MSB */
+#define	R367_OFDM_IIRCX_COEFF1_MSB		0xF061
+#define	F367_OFDM_IIR_CX_COEFF1_MSB		0xF06100FF
+
+/* IIRCX_COEFF1_LSB */
+#define	R367_OFDM_IIRCX_COEFF1_LSB		0xF062
+#define	F367_OFDM_IIR_CX_COEFF1_LSB		0xF06200FF
+
+/* IIRCX_COEFF2_MSB */
+#define	R367_OFDM_IIRCX_COEFF2_MSB		0xF063
+#define	F367_OFDM_IIR_CX_COEFF2_MSB		0xF06300FF
+
+/* IIRCX_COEFF2_LSB */
+#define	R367_OFDM_IIRCX_COEFF2_LSB		0xF064
+#define	F367_OFDM_IIR_CX_COEFF2_LSB		0xF06400FF
+
+/* IIRCX_COEFF3_MSB */
+#define	R367_OFDM_IIRCX_COEFF3_MSB		0xF065
+#define	F367_OFDM_IIR_CX_COEFF3_MSB		0xF06500FF
+
+/* IIRCX_COEFF3_LSB */
+#define	R367_OFDM_IIRCX_COEFF3_LSB		0xF066
+#define	F367_OFDM_IIR_CX_COEFF3_LSB		0xF06600FF
+
+/* IIRCX_COEFF4_MSB */
+#define	R367_OFDM_IIRCX_COEFF4_MSB		0xF067
+#define	F367_OFDM_IIR_CX_COEFF4_MSB		0xF06700FF
+
+/* IIRCX_COEFF4_LSB */
+#define	R367_OFDM_IIRCX_COEFF4_LSB		0xF068
+#define	F367_OFDM_IIR_CX_COEFF4_LSB		0xF06800FF
+
+/* IIRCX_COEFF5_MSB */
+#define	R367_OFDM_IIRCX_COEFF5_MSB		0xF069
+#define	F367_OFDM_IIR_CX_COEFF5_MSB		0xF06900FF
+
+/* IIRCX_COEFF5_LSB */
+#define	R367_OFDM_IIRCX_COEFF5_LSB		0xF06A
+#define	F367_OFDM_IIR_CX_COEFF5_LSB		0xF06A00FF
+
+/* FEPATH_CFG */
+#define	R367_OFDM_FEPATH_CFG		0xF06B
+#define	F367_OFDM_DEMUX_SWAP		0xF06B0004
+#define	F367_OFDM_DIGAGC_SWAP		0xF06B0002
+#define	F367_OFDM_LONGPATH_IF		0xF06B0001
+
+/* PMC1_FUNC */
+#define	R367_OFDM_PMC1_FUNC		0xF06C
+#define	F367_OFDM_SOFT_RSTN		0xF06C0080
+#define	F367_OFDM_PMC1_AVERAGE_TIME		0xF06C0078
+#define	F367_OFDM_PMC1_WAIT_TIME		0xF06C0006
+#define	F367_OFDM_PMC1_2N_SEL		0xF06C0001
+
+/* PMC1_FOR */
+#define	R367_OFDM_PMC1_FOR		0xF06D
+#define	F367_OFDM_PMC1_FORCE		0xF06D0080
+#define	F367_OFDM_PMC1_FORCE_VALUE		0xF06D007C
+
+/* PMC2_FUNC */
+#define	R367_OFDM_PMC2_FUNC		0xF06E
+#define	F367_OFDM_PMC2_SOFT_STN		0xF06E0080
+#define	F367_OFDM_PMC2_ACCU_TIME		0xF06E0070
+#define	F367_OFDM_PMC2_CMDP_MN		0xF06E0008
+#define	F367_OFDM_PMC2_SWAP		0xF06E0004
+
+/* STATUS_ERR_DA */
+#define	R367_OFDM_STATUS_ERR_DA		0xF06F
+#define	F367_OFDM_COM_USEGAINTRK		0xF06F0080
+#define	F367_OFDM_COM_AGCLOCK		0xF06F0040
+#define	F367_OFDM_AUT_AGCLOCK		0xF06F0020
+#define	F367_OFDM_MIN_ERR_X_LSB		0xF06F000F
+
+/* DIG_AGC_R */
+#define	R367_OFDM_DIG_AGC_R		0xF070
+#define	F367_OFDM_COM_SOFT_RSTN		0xF0700080
+#define	F367_OFDM_COM_AGC_ON		0xF0700040
+#define	F367_OFDM_COM_EARLY		0xF0700020
+#define	F367_OFDM_AUT_SOFT_RESETN		0xF0700010
+#define	F367_OFDM_AUT_AGC_ON		0xF0700008
+#define	F367_OFDM_AUT_EARLY		0xF0700004
+#define	F367_OFDM_AUT_ROT_EN		0xF0700002
+#define	F367_OFDM_LOCK_SOFT_RESETN		0xF0700001
+
+/* COMAGC_TARMSB */
+#define	R367_OFDM_COMAGC_TARMSB		0xF071
+#define	F367_OFDM_COM_AGC_TARGET_MSB		0xF07100FF
+
+/* COM_AGC_TAR_ENMODE */
+#define	R367_OFDM_COM_AGC_TAR_ENMODE		0xF072
+#define	F367_OFDM_COM_AGC_TARGET_LSB		0xF07200F0
+#define	F367_OFDM_COM_ENMODE		0xF072000F
+
+/* COM_AGC_CFG */
+#define	R367_OFDM_COM_AGC_CFG		0xF073
+#define	F367_OFDM_COM_N		0xF07300F8
+#define	F367_OFDM_COM_STABMODE		0xF0730006
+#define	F367_OFDM_ERR_SEL		0xF0730001
+
+/* COM_AGC_GAIN1 */
+#define	R367_OFDM_COM_AGC_GAIN1		0xF074
+#define	F367_OFDM_COM_GAIN1ACK		0xF07400F0
+#define	F367_OFDM_COM_GAIN1TRK		0xF074000F
+
+/* AUT_AGC_TARGETMSB */
+#define	R367_OFDM_AUT_AGC_TARGETMSB		0xF075
+#define	F367_OFDM_AUT_AGC_TARGET_MSB		0xF07500FF
+
+/* LOCK_DET_MSB */
+#define	R367_OFDM_LOCK_DET_MSB		0xF076
+#define	F367_OFDM_LOCK_DETECT_MSB		0xF07600FF
+
+/* AGCTAR_LOCK_LSBS */
+#define	R367_OFDM_AGCTAR_LOCK_LSBS		0xF077
+#define	F367_OFDM_AUT_AGC_TARGET_LSB		0xF07700F0
+#define	F367_OFDM_LOCK_DETECT_LSB		0xF077000F
+
+/* AUT_GAIN_EN */
+#define	R367_OFDM_AUT_GAIN_EN		0xF078
+#define	F367_OFDM_AUT_ENMODE		0xF07800F0
+#define	F367_OFDM_AUT_GAIN2		0xF078000F
+
+/* AUT_CFG */
+#define	R367_OFDM_AUT_CFG		0xF079
+#define	F367_OFDM_AUT_N		0xF07900F8
+#define	F367_OFDM_INT_CHOICE		0xF0790006
+#define	F367_OFDM_INT_LOAD		0xF0790001
+
+/* LOCKN */
+#define	R367_OFDM_LOCKN		0xF07A
+#define	F367_OFDM_LOCK_N		0xF07A00F8
+#define	F367_OFDM_SEL_IQNTAR		0xF07A0004
+#define	F367_OFDM_LOCK_DETECT_CHOICE		0xF07A0003
+
+/* INT_X_3 */
+#define	R367_OFDM_INT_X_3		0xF07B
+#define	F367_OFDM_INT_X3		0xF07B00FF
+
+/* INT_X_2 */
+#define	R367_OFDM_INT_X_2		0xF07C
+#define	F367_OFDM_INT_X2		0xF07C00FF
+
+/* INT_X_1 */
+#define	R367_OFDM_INT_X_1		0xF07D
+#define	F367_OFDM_INT_X1		0xF07D00FF
+
+/* INT_X_0 */
+#define	R367_OFDM_INT_X_0		0xF07E
+#define	F367_OFDM_INT_X0		0xF07E00FF
+
+/* MIN_ERRX_MSB */
+#define	R367_OFDM_MIN_ERRX_MSB		0xF07F
+#define	F367_OFDM_MIN_ERR_X_MSB		0xF07F00FF
+
+/* COR_CTL */
+#define	R367_OFDM_COR_CTL		0xF080
+#define	F367_OFDM_CORE_ACTIVE		0xF0800020
+#define	F367_OFDM_HOLD		0xF0800010
+#define	F367_OFDM_CORE_STATE_CTL		0xF080000F
+
+/* COR_STAT */
+#define	R367_OFDM_COR_STAT		0xF081
+#define	F367_OFDM_SCATT_LOCKED		0xF0810080
+#define	F367_OFDM_TPS_LOCKED		0xF0810040
+#define	F367_OFDM_SYR_LOCKED_COR		0xF0810020
+#define	F367_OFDM_AGC_LOCKED_STAT		0xF0810010
+#define	F367_OFDM_CORE_STATE_STAT		0xF081000F
+
+/* COR_INTEN */
+#define	R367_OFDM_COR_INTEN		0xF082
+#define	F367_OFDM_INTEN		0xF0820080
+#define	F367_OFDM_INTEN_SYR		0xF0820020
+#define	F367_OFDM_INTEN_FFT		0xF0820010
+#define	F367_OFDM_INTEN_AGC		0xF0820008
+#define	F367_OFDM_INTEN_TPS1		0xF0820004
+#define	F367_OFDM_INTEN_TPS2		0xF0820002
+#define	F367_OFDM_INTEN_TPS3		0xF0820001
+
+/* COR_INTSTAT */
+#define	R367_OFDM_COR_INTSTAT		0xF083
+#define	F367_OFDM_INTSTAT_SYR		0xF0830020
+#define	F367_OFDM_INTSTAT_FFT		0xF0830010
+#define	F367_OFDM_INTSAT_AGC		0xF0830008
+#define	F367_OFDM_INTSTAT_TPS1		0xF0830004
+#define	F367_OFDM_INTSTAT_TPS2		0xF0830002
+#define	F367_OFDM_INTSTAT_TPS3		0xF0830001
+
+/* COR_MODEGUARD */
+#define	R367_OFDM_COR_MODEGUARD		0xF084
+#define	F367_OFDM_FORCE		0xF0840010
+#define	F367_OFDM_MODE		0xF084000C
+#define	F367_OFDM_GUARD		0xF0840003
+
+/* AGC_CTL */
+#define	R367_OFDM_AGC_CTL		0xF085
+#define	F367_OFDM_AGC_TIMING_FACTOR		0xF08500E0
+#define	F367_OFDM_AGC_LAST		0xF0850010
+#define	F367_OFDM_AGC_GAIN		0xF085000C
+#define	F367_OFDM_AGC_NEG		0xF0850002
+#define	F367_OFDM_AGC_SET		0xF0850001
+
+/* AGC_MANUAL1 */
+#define	R367_OFDM_AGC_MANUAL1		0xF086
+#define	F367_OFDM_AGC_VAL_LO		0xF08600FF
+
+/* AGC_MANUAL2 */
+#define	R367_OFDM_AGC_MANUAL2		0xF087
+#define	F367_OFDM_AGC_VAL_HI		0xF087000F
+
+/* AGC_TARG */
+#define	R367_OFDM_AGC_TARG		0xF088
+#define	F367_OFDM_AGC_TARGET		0xF08800FF
+
+/* AGC_GAIN1 */
+#define	R367_OFDM_AGC_GAIN1		0xF089
+#define	F367_OFDM_AGC_GAIN_LO		0xF08900FF
+
+/* AGC_GAIN2 */
+#define	R367_OFDM_AGC_GAIN2		0xF08A
+#define	F367_OFDM_AGC_LOCKED_GAIN2		0xF08A0010
+#define	F367_OFDM_AGC_GAIN_HI		0xF08A000F
+
+/* RESERVED_1 */
+#define	R367_OFDM_RESERVED_1		0xF08B
+#define	F367_OFDM_RESERVED1		0xF08B00FF
+
+/* RESERVED_2 */
+#define	R367_OFDM_RESERVED_2		0xF08C
+#define	F367_OFDM_RESERVED2		0xF08C00FF
+
+/* RESERVED_3 */
+#define	R367_OFDM_RESERVED_3		0xF08D
+#define	F367_OFDM_RESERVED3		0xF08D00FF
+
+/* CAS_CTL */
+#define	R367_OFDM_CAS_CTL		0xF08E
+#define	F367_OFDM_CCS_ENABLE		0xF08E0080
+#define	F367_OFDM_ACS_DISABLE		0xF08E0040
+#define	F367_OFDM_DAGC_DIS		0xF08E0020
+#define	F367_OFDM_DAGC_GAIN		0xF08E0018
+#define	F367_OFDM_CCSMU		0xF08E0007
+
+/* CAS_FREQ */
+#define	R367_OFDM_CAS_FREQ		0xF08F
+#define	F367_OFDM_CCS_FREQ		0xF08F00FF
+
+/* CAS_DAGCGAIN */
+#define	R367_OFDM_CAS_DAGCGAIN		0xF090
+#define	F367_OFDM_CAS_DAGC_GAIN		0xF09000FF
+
+/* SYR_CTL */
+#define	R367_OFDM_SYR_CTL		0xF091
+#define	F367_OFDM_SICTH_ENABLE		0xF0910080
+#define	F367_OFDM_LONG_ECHO		0xF0910078
+#define	F367_OFDM_AUTO_LE_EN		0xF0910004
+#define	F367_OFDM_SYR_BYPASS		0xF0910002
+#define	F367_OFDM_SYR_TR_DIS		0xF0910001
+
+/* SYR_STAT */
+#define	R367_OFDM_SYR_STAT		0xF092
+#define	F367_OFDM_SYR_LOCKED_STAT		0xF0920010
+#define	F367_OFDM_SYR_MODE		0xF092000C
+#define	F367_OFDM_SYR_GUARD		0xF0920003
+
+/* SYR_NCO1 */
+#define	R367_OFDM_SYR_NCO1		0xF093
+#define	F367_OFDM_SYR_NCO_LO		0xF09300FF
+
+/* SYR_NCO2 */
+#define	R367_OFDM_SYR_NCO2		0xF094
+#define	F367_OFDM_SYR_NCO_HI		0xF094003F
+
+/* SYR_OFFSET1 */
+#define	R367_OFDM_SYR_OFFSET1		0xF095
+#define	F367_OFDM_SYR_OFFSET_LO		0xF09500FF
+
+/* SYR_OFFSET2 */
+#define	R367_OFDM_SYR_OFFSET2		0xF096
+#define	F367_OFDM_SYR_OFFSET_HI		0xF096003F
+
+/* FFT_CTL */
+#define	R367_OFDM_FFT_CTL		0xF097
+#define	F367_OFDM_SHIFT_FFT_TRIG		0xF0970018
+#define	F367_OFDM_FFT_TRIGGER		0xF0970004
+#define	F367_OFDM_FFT_MANUAL		0xF0970002
+#define	F367_OFDM_IFFT_MODE		0xF0970001
+
+/* SCR_CTL */
+#define	R367_OFDM_SCR_CTL		0xF098
+#define	F367_OFDM_SYRADJDECAY		0xF0980070
+#define	F367_OFDM_SCR_CPEDIS		0xF0980002
+#define	F367_OFDM_SCR_DIS		0xF0980001
+
+/* PPM_CTL1 */
+#define	R367_OFDM_PPM_CTL1		0xF099
+#define	F367_OFDM_PPM_MAXFREQ		0xF0990030
+#define	F367_OFDM_PPM_MAXTIM		0xF0990008
+#define	F367_OFDM_PPM_INVSEL		0xF0990004
+#define	F367_OFDM_PPM_SCATDIS		0xF0990002
+#define	F367_OFDM_PPM_BYP		0xF0990001
+
+/* TRL_CTL */
+#define	R367_OFDM_TRL_CTL		0xF09A
+#define	F367_OFDM_TRL_NOMRATE_LSB		0xF09A0080
+#define	F367_OFDM_TRL_GAIN_FACTOR		0xF09A0078
+#define	F367_OFDM_TRL_LOOPGAIN		0xF09A0007
+
+/* TRL_NOMRATE1 */
+#define	R367_OFDM_TRL_NOMRATE1		0xF09B
+#define	F367_OFDM_TRL_NOMRATE_LO		0xF09B00FF
+
+/* TRL_NOMRATE2 */
+#define	R367_OFDM_TRL_NOMRATE2		0xF09C
+#define	F367_OFDM_TRL_NOMRATE_HI		0xF09C00FF
+
+/* TRL_TIME1 */
+#define	R367_OFDM_TRL_TIME1		0xF09D
+#define	F367_OFDM_TRL_TOFFSET_LO		0xF09D00FF
+
+/* TRL_TIME2 */
+#define	R367_OFDM_TRL_TIME2		0xF09E
+#define	F367_OFDM_TRL_TOFFSET_HI		0xF09E00FF
+
+/* CRL_CTL */
+#define	R367_OFDM_CRL_CTL		0xF09F
+#define	F367_OFDM_CRL_DIS		0xF09F0080
+#define	F367_OFDM_CRL_GAIN_FACTOR		0xF09F0078
+#define	F367_OFDM_CRL_LOOPGAIN		0xF09F0007
+
+/* CRL_FREQ1 */
+#define	R367_OFDM_CRL_FREQ1		0xF0A0
+#define	F367_OFDM_CRL_FOFFSET_LO		0xF0A000FF
+
+/* CRL_FREQ2 */
+#define	R367_OFDM_CRL_FREQ2		0xF0A1
+#define	F367_OFDM_CRL_FOFFSET_HI		0xF0A100FF
+
+/* CRL_FREQ3 */
+#define	R367_OFDM_CRL_FREQ3		0xF0A2
+#define	F367_OFDM_CRL_FOFFSET_VHI		0xF0A200FF
+
+/* TPS_SFRAME_CTL */
+#define	R367_OFDM_TPS_SFRAME_CTL		0xF0A3
+#define	F367_OFDM_TPS_SFRAME_SYNC		0xF0A30001
+
+/* CHC_SNR */
+#define	R367_OFDM_CHC_SNR		0xF0A4
+#define	F367_OFDM_CHCSNR		0xF0A400FF
+
+/* BDI_CTL */
+#define	R367_OFDM_BDI_CTL		0xF0A5
+#define	F367_OFDM_BDI_LPSEL		0xF0A50002
+#define	F367_OFDM_BDI_SERIAL		0xF0A50001
+
+/* DMP_CTL */
+#define	R367_OFDM_DMP_CTL		0xF0A6
+#define	F367_OFDM_DMP_SCALING_FACTOR		0xF0A6001E
+#define	F367_OFDM_DMP_SDDIS		0xF0A60001
+
+/* TPS_RCVD1 */
+#define	R367_OFDM_TPS_RCVD1		0xF0A7
+#define	F367_OFDM_TPS_CHANGE		0xF0A70040
+#define	F367_OFDM_BCH_OK		0xF0A70020
+#define	F367_OFDM_TPS_SYNC		0xF0A70010
+#define	F367_OFDM_TPS_FRAME		0xF0A70003
+
+/* TPS_RCVD2 */
+#define	R367_OFDM_TPS_RCVD2		0xF0A8
+#define	F367_OFDM_TPS_HIERMODE		0xF0A80070
+#define	F367_OFDM_TPS_CONST		0xF0A80003
+
+/* TPS_RCVD3 */
+#define	R367_OFDM_TPS_RCVD3		0xF0A9
+#define	F367_OFDM_TPS_LPCODE		0xF0A90070
+#define	F367_OFDM_TPS_HPCODE		0xF0A90007
+
+/* TPS_RCVD4 */
+#define	R367_OFDM_TPS_RCVD4		0xF0AA
+#define	F367_OFDM_TPS_GUARD		0xF0AA0030
+#define	F367_OFDM_TPS_MODE		0xF0AA0003
+
+/* TPS_ID_CELL1 */
+#define	R367_OFDM_TPS_ID_CELL1		0xF0AB
+#define	F367_OFDM_TPS_ID_CELL_LO		0xF0AB00FF
+
+/* TPS_ID_CELL2 */
+#define	R367_OFDM_TPS_ID_CELL2		0xF0AC
+#define	F367_OFDM_TPS_ID_CELL_HI		0xF0AC00FF
+
+/* TPS_RCVD5_SET1 */
+#define	R367_OFDM_TPS_RCVD5_SET1		0xF0AD
+#define	F367_OFDM_TPS_NA		0xF0AD00FC
+#define	F367_OFDM_TPS_SETFRAME		0xF0AD0003
+
+/* TPS_SET2 */
+#define	R367_OFDM_TPS_SET2		0xF0AE
+#define	F367_OFDM_TPS_SETHIERMODE		0xF0AE0070
+#define	F367_OFDM_TPS_SETCONST		0xF0AE0003
+
+/* TPS_SET3 */
+#define	R367_OFDM_TPS_SET3		0xF0AF
+#define	F367_OFDM_TPS_SETLPCODE		0xF0AF0070
+#define	F367_OFDM_TPS_SETHPCODE		0xF0AF0007
+
+/* TPS_CTL */
+#define	R367_OFDM_TPS_CTL		0xF0B0
+#define	F367_OFDM_TPS_IMM		0xF0B00004
+#define	F367_OFDM_TPS_BCHDIS		0xF0B00002
+#define	F367_OFDM_TPS_UPDDIS		0xF0B00001
+
+/* CTL_FFTOSNUM */
+#define	R367_OFDM_CTL_FFTOSNUM		0xF0B1
+#define	F367_OFDM_SYMBOL_NUMBER		0xF0B1007F
+
+/* TESTSELECT */
+#define	R367_OFDM_TESTSELECT		0xF0B2
+#define	F367_OFDM_TEST_SELECT		0xF0B2001F
+
+/* MSC_REV */
+#define	R367_OFDM_MSC_REV		0xF0B3
+#define	F367_OFDM_REV_NUMBER		0xF0B300FF
+
+/* PIR_CTL */
+#define	R367_OFDM_PIR_CTL		0xF0B4
+#define	F367_OFDM_FREEZE		0xF0B40001
+
+/* SNR_CARRIER1 */
+#define	R367_OFDM_SNR_CARRIER1		0xF0B5
+#define	F367_OFDM_SNR_CARRIER_LO		0xF0B500FF
+
+/* SNR_CARRIER2 */
+#define	R367_OFDM_SNR_CARRIER2		0xF0B6
+#define	F367_OFDM_MEAN		0xF0B600C0
+#define	F367_OFDM_SNR_CARRIER_HI		0xF0B6001F
+
+/* PPM_CPAMP */
+#define	R367_OFDM_PPM_CPAMP		0xF0B7
+#define	F367_OFDM_PPM_CPC		0xF0B700FF
+
+/* TSM_AP0 */
+#define	R367_OFDM_TSM_AP0		0xF0B8
+#define	F367_OFDM_ADDRESS_BYTE_0		0xF0B800FF
+
+/* TSM_AP1 */
+#define	R367_OFDM_TSM_AP1		0xF0B9
+#define	F367_OFDM_ADDRESS_BYTE_1		0xF0B900FF
+
+/* TSM_AP2 */
+#define	R367_OFDM_TSM_AP2		0xF0BA
+#define	F367_OFDM_DATA_BYTE_0		0xF0BA00FF
+
+/* TSM_AP3 */
+#define	R367_OFDM_TSM_AP3		0xF0BB
+#define	F367_OFDM_DATA_BYTE_1		0xF0BB00FF
+
+/* TSM_AP4 */
+#define	R367_OFDM_TSM_AP4		0xF0BC
+#define	F367_OFDM_DATA_BYTE_2		0xF0BC00FF
+
+/* TSM_AP5 */
+#define	R367_OFDM_TSM_AP5		0xF0BD
+#define	F367_OFDM_DATA_BYTE_3		0xF0BD00FF
+
+/* TSM_AP6 */
+#define	R367_OFDM_TSM_AP6		0xF0BE
+#define	F367_OFDM_TSM_AP_6		0xF0BE00FF
+
+/* TSM_AP7 */
+#define	R367_OFDM_TSM_AP7		0xF0BF
+#define	F367_OFDM_MEM_SELECT_BYTE		0xF0BF00FF
+
+/* TSTRES */
+#define	R367_TSTRES		0xF0C0
+#define	F367_FRES_DISPLAY		0xF0C00080
+#define	F367_FRES_FIFO_AD		0xF0C00020
+#define	F367_FRESRS		0xF0C00010
+#define	F367_FRESACS		0xF0C00008
+#define	F367_FRESFEC		0xF0C00004
+#define	F367_FRES_PRIF		0xF0C00002
+#define	F367_FRESCORE		0xF0C00001
+
+/* ANACTRL */
+#define	R367_ANACTRL		0xF0C1
+#define	F367_BYPASS_XTAL		0xF0C10040
+#define	F367_BYPASS_PLLXN		0xF0C1000C
+#define	F367_DIS_PAD_OSC		0xF0C10002
+#define	F367_STDBY_PLLXN		0xF0C10001
+
+/* TSTBUS */
+#define	R367_TSTBUS		0xF0C2
+#define	F367_TS_BYTE_CLK_INV		0xF0C20080
+#define	F367_CFG_IP		0xF0C20070
+#define	F367_CFG_TST		0xF0C2000F
+
+/* TSTRATE */
+#define	R367_TSTRATE		0xF0C6
+#define	F367_FORCEPHA		0xF0C60080
+#define	F367_FNEWPHA		0xF0C60010
+#define	F367_FROT90		0xF0C60008
+#define	F367_FR		0xF0C60007
+
+/* CONSTMODE */
+#define	R367_OFDM_CONSTMODE		0xF0CB
+#define	F367_OFDM_TST_PRIF		0xF0CB00E0
+#define	F367_OFDM_CAR_TYPE		0xF0CB0018
+#define	F367_OFDM_CONST_MODE		0xF0CB0003
+
+/* CONSTCARR1 */
+#define	R367_OFDM_CONSTCARR1		0xF0CC
+#define	F367_OFDM_CONST_CARR_LO		0xF0CC00FF
+
+/* CONSTCARR2 */
+#define	R367_OFDM_CONSTCARR2		0xF0CD
+#define	F367_OFDM_CONST_CARR_HI		0xF0CD001F
+
+/* ICONSTEL */
+#define	R367_OFDM_ICONSTEL		0xF0CE
+#define	F367_OFDM_PICONSTEL		0xF0CE00FF
+
+/* QCONSTEL */
+#define	R367_OFDM_QCONSTEL		0xF0CF
+#define	F367_OFDM_PQCONSTEL		0xF0CF00FF
+
+/* TSTBISTRES0 */
+#define	R367_OFDM_TSTBISTRES0		0xF0D0
+#define	F367_OFDM_BEND_PPM		0xF0D00080
+#define	F367_OFDM_BBAD_PPM		0xF0D00040
+#define	F367_OFDM_BEND_FFTW		0xF0D00020
+#define	F367_OFDM_BBAD_FFTW		0xF0D00010
+#define	F367_OFDM_BEND_FFT_BUF		0xF0D00008
+#define	F367_OFDM_BBAD_FFT_BUF		0xF0D00004
+#define	F367_OFDM_BEND_SYR		0xF0D00002
+#define	F367_OFDM_BBAD_SYR		0xF0D00001
+
+/* TSTBISTRES1 */
+#define	R367_OFDM_TSTBISTRES1		0xF0D1
+#define	F367_OFDM_BEND_CHC_CP		0xF0D10080
+#define	F367_OFDM_BBAD_CHC_CP		0xF0D10040
+#define	F367_OFDM_BEND_CHCI		0xF0D10020
+#define	F367_OFDM_BBAD_CHCI		0xF0D10010
+#define	F367_OFDM_BEND_BDI		0xF0D10008
+#define	F367_OFDM_BBAD_BDI		0xF0D10004
+#define	F367_OFDM_BEND_SDI		0xF0D10002
+#define	F367_OFDM_BBAD_SDI		0xF0D10001
+
+/* TSTBISTRES2 */
+#define	R367_OFDM_TSTBISTRES2		0xF0D2
+#define	F367_OFDM_BEND_CHC_INC		0xF0D20080
+#define	F367_OFDM_BBAD_CHC_INC		0xF0D20040
+#define	F367_OFDM_BEND_CHC_SPP		0xF0D20020
+#define	F367_OFDM_BBAD_CHC_SPP		0xF0D20010
+#define	F367_OFDM_BEND_CHC_CPP		0xF0D20008
+#define	F367_OFDM_BBAD_CHC_CPP		0xF0D20004
+#define	F367_OFDM_BEND_CHC_SP		0xF0D20002
+#define	F367_OFDM_BBAD_CHC_SP		0xF0D20001
+
+/* TSTBISTRES3 */
+#define	R367_OFDM_TSTBISTRES3		0xF0D3
+#define	F367_OFDM_BEND_QAM		0xF0D30080
+#define	F367_OFDM_BBAD_QAM		0xF0D30040
+#define	F367_OFDM_BEND_SFEC_VIT		0xF0D30020
+#define	F367_OFDM_BBAD_SFEC_VIT		0xF0D30010
+#define	F367_OFDM_BEND_SFEC_DLINE		0xF0D30008
+#define	F367_OFDM_BBAD_SFEC_DLINE		0xF0D30004
+#define	F367_OFDM_BEND_SFEC_HW		0xF0D30002
+#define	F367_OFDM_BBAD_SFEC_HW		0xF0D30001
+
+/* RF_AGC1 */
+#define	R367_RF_AGC1		0xF0D4
+#define	F367_RF_AGC1_LEVEL_HI		0xF0D400FF
+
+/* RF_AGC2 */
+#define	R367_RF_AGC2		0xF0D5
+#define	F367_REF_ADGP		0xF0D50080
+#define	F367_STDBY_ADCGP		0xF0D50020
+#define	F367_CHANNEL_SEL		0xF0D5001C
+#define	F367_RF_AGC1_LEVEL_LO		0xF0D50003
+
+/* ANADIGCTRL */
+#define	R367_ANADIGCTRL		0xF0D7
+#define	F367_SEL_CLKDEM		0xF0D70020
+#define	F367_EN_BUFFER_Q		0xF0D70010
+#define	F367_EN_BUFFER_I		0xF0D70008
+#define	F367_ADC_RIS_EGDE		0xF0D70004
+#define	F367_SGN_ADC		0xF0D70002
+#define	F367_SEL_AD12_SYNC		0xF0D70001
+
+/* PLLMDIV */
+#define	R367_PLLMDIV		0xF0D8
+#define	F367_PLL_MDIV		0xF0D800FF
+
+/* PLLNDIV */
+#define	R367_PLLNDIV		0xF0D9
+#define	F367_PLL_NDIV		0xF0D900FF
+
+/* PLLSETUP */
+#define	R367_PLLSETUP		0xF0DA
+#define	F367_PLL_PDIV		0xF0DA0070
+#define	F367_PLL_KDIV		0xF0DA000F
+
+/* DUAL_AD12 */
+#define	R367_DUAL_AD12		0xF0DB
+#define	F367_FS20M		0xF0DB0020
+#define	F367_FS50M		0xF0DB0010
+#define	F367_INMODE0		0xF0DB0008
+#define	F367_POFFQ		0xF0DB0004
+#define	F367_POFFI		0xF0DB0002
+#define	F367_INMODE1		0xF0DB0001
+
+/* TSTBIST */
+#define	R367_TSTBIST		0xF0DC
+#define	F367_TST_BYP_CLK		0xF0DC0080
+#define	F367_TST_GCLKENA_STD		0xF0DC0040
+#define	F367_TST_GCLKENA		0xF0DC0020
+#define	F367_TST_MEMBIST		0xF0DC001F
+
+/* PAD_COMP_CTRL */
+#define	R367_PAD_COMP_CTRL		0xF0DD
+#define	F367_COMPTQ		0xF0DD0010
+#define	F367_COMPEN		0xF0DD0008
+#define	F367_FREEZE2		0xF0DD0004
+#define	F367_SLEEP_INHBT		0xF0DD0002
+#define	F367_CHIP_SLEEP		0xF0DD0001
+
+/* PAD_COMP_WR */
+#define	R367_PAD_COMP_WR		0xF0DE
+#define	F367_WR_ASRC		0xF0DE007F
+
+/* PAD_COMP_RD */
+#define	R367_PAD_COMP_RD		0xF0DF
+#define	F367_COMPOK		0xF0DF0080
+#define	F367_RD_ASRC		0xF0DF007F
+
+/* SYR_TARGET_FFTADJT_MSB */
+#define	R367_OFDM_SYR_TARGET_FFTADJT_MSB		0xF100
+#define	F367_OFDM_SYR_START		0xF1000080
+#define	F367_OFDM_SYR_TARGET_FFTADJ_HI		0xF100000F
+
+/* SYR_TARGET_FFTADJT_LSB */
+#define	R367_OFDM_SYR_TARGET_FFTADJT_LSB		0xF101
+#define	F367_OFDM_SYR_TARGET_FFTADJ_LO		0xF10100FF
+
+/* SYR_TARGET_CHCADJT_MSB */
+#define	R367_OFDM_SYR_TARGET_CHCADJT_MSB		0xF102
+#define	F367_OFDM_SYR_TARGET_CHCADJ_HI		0xF102000F
+
+/* SYR_TARGET_CHCADJT_LSB */
+#define	R367_OFDM_SYR_TARGET_CHCADJT_LSB		0xF103
+#define	F367_OFDM_SYR_TARGET_CHCADJ_LO		0xF10300FF
+
+/* SYR_FLAG */
+#define	R367_OFDM_SYR_FLAG		0xF104
+#define	F367_OFDM_TRIG_FLG1		0xF1040080
+#define	F367_OFDM_TRIG_FLG0		0xF1040040
+#define	F367_OFDM_FFT_FLG1		0xF1040008
+#define	F367_OFDM_FFT_FLG0		0xF1040004
+#define	F367_OFDM_CHC_FLG1		0xF1040002
+#define	F367_OFDM_CHC_FLG0		0xF1040001
+
+/* CRL_TARGET1 */
+#define	R367_OFDM_CRL_TARGET1		0xF105
+#define	F367_OFDM_CRL_START		0xF1050080
+#define	F367_OFDM_CRL_TARGET_VHI		0xF105000F
+
+/* CRL_TARGET2 */
+#define	R367_OFDM_CRL_TARGET2		0xF106
+#define	F367_OFDM_CRL_TARGET_HI		0xF10600FF
+
+/* CRL_TARGET3 */
+#define	R367_OFDM_CRL_TARGET3		0xF107
+#define	F367_OFDM_CRL_TARGET_LO		0xF10700FF
+
+/* CRL_TARGET4 */
+#define	R367_OFDM_CRL_TARGET4		0xF108
+#define	F367_OFDM_CRL_TARGET_VLO		0xF10800FF
+
+/* CRL_FLAG */
+#define	R367_OFDM_CRL_FLAG		0xF109
+#define	F367_OFDM_CRL_FLAG1		0xF1090002
+#define	F367_OFDM_CRL_FLAG0		0xF1090001
+
+/* TRL_TARGET1 */
+#define	R367_OFDM_TRL_TARGET1		0xF10A
+#define	F367_OFDM_TRL_TARGET_HI		0xF10A00FF
+
+/* TRL_TARGET2 */
+#define	R367_OFDM_TRL_TARGET2		0xF10B
+#define	F367_OFDM_TRL_TARGET_LO		0xF10B00FF
+
+/* TRL_CHC */
+#define	R367_OFDM_TRL_CHC		0xF10C
+#define	F367_OFDM_TRL_START		0xF10C0080
+#define	F367_OFDM_CHC_START		0xF10C0040
+#define	F367_OFDM_TRL_FLAG1		0xF10C0002
+#define	F367_OFDM_TRL_FLAG0		0xF10C0001
+
+/* CHC_SNR_TARG */
+#define	R367_OFDM_CHC_SNR_TARG		0xF10D
+#define	F367_OFDM_CHC_SNR_TARGET		0xF10D00FF
+
+/* TOP_TRACK */
+#define	R367_OFDM_TOP_TRACK		0xF10E
+#define	F367_OFDM_TOP_START		0xF10E0080
+#define	F367_OFDM_FIRST_FLAG		0xF10E0070
+#define	F367_OFDM_TOP_FLAG1		0xF10E0008
+#define	F367_OFDM_TOP_FLAG0		0xF10E0004
+#define	F367_OFDM_CHC_FLAG1		0xF10E0002
+#define	F367_OFDM_CHC_FLAG0		0xF10E0001
+
+/* TRACKER_FREE1 */
+#define	R367_OFDM_TRACKER_FREE1		0xF10F
+#define	F367_OFDM_TRACKER_FREE_1		0xF10F00FF
+
+/* ERROR_CRL1 */
+#define	R367_OFDM_ERROR_CRL1		0xF110
+#define	F367_OFDM_ERROR_CRL_VHI		0xF11000FF
+
+/* ERROR_CRL2 */
+#define	R367_OFDM_ERROR_CRL2		0xF111
+#define	F367_OFDM_ERROR_CRL_HI		0xF11100FF
+
+/* ERROR_CRL3 */
+#define	R367_OFDM_ERROR_CRL3		0xF112
+#define	F367_OFDM_ERROR_CRL_LOI		0xF11200FF
+
+/* ERROR_CRL4 */
+#define	R367_OFDM_ERROR_CRL4		0xF113
+#define	F367_OFDM_ERROR_CRL_VLO		0xF11300FF
+
+/* DEC_NCO1 */
+#define	R367_OFDM_DEC_NCO1		0xF114
+#define	F367_OFDM_DEC_NCO_VHI		0xF11400FF
+
+/* DEC_NCO2 */
+#define	R367_OFDM_DEC_NCO2		0xF115
+#define	F367_OFDM_DEC_NCO_HI		0xF11500FF
+
+/* DEC_NCO3 */
+#define	R367_OFDM_DEC_NCO3		0xF116
+#define	F367_OFDM_DEC_NCO_LO		0xF11600FF
+
+/* SNR */
+#define	R367_OFDM_SNR		0xF117
+#define	F367_OFDM_SNRATIO		0xF11700FF
+
+/* SYR_FFTADJ1 */
+#define	R367_OFDM_SYR_FFTADJ1		0xF118
+#define	F367_OFDM_SYR_FFTADJ_HI		0xF11800FF
+
+/* SYR_FFTADJ2 */
+#define	R367_OFDM_SYR_FFTADJ2		0xF119
+#define	F367_OFDM_SYR_FFTADJ_LO		0xF11900FF
+
+/* SYR_CHCADJ1 */
+#define	R367_OFDM_SYR_CHCADJ1		0xF11A
+#define	F367_OFDM_SYR_CHCADJ_HI		0xF11A00FF
+
+/* SYR_CHCADJ2 */
+#define	R367_OFDM_SYR_CHCADJ2		0xF11B
+#define	F367_OFDM_SYR_CHCADJ_LO		0xF11B00FF
+
+/* SYR_OFF */
+#define	R367_OFDM_SYR_OFF		0xF11C
+#define	F367_OFDM_SYR_OFFSET		0xF11C00FF
+
+/* PPM_OFFSET1 */
+#define	R367_OFDM_PPM_OFFSET1		0xF11D
+#define	F367_OFDM_PPM_OFFSET_HI		0xF11D00FF
+
+/* PPM_OFFSET2 */
+#define	R367_OFDM_PPM_OFFSET2		0xF11E
+#define	F367_OFDM_PPM_OFFSET_LO		0xF11E00FF
+
+/* TRACKER_FREE2 */
+#define	R367_OFDM_TRACKER_FREE2		0xF11F
+#define	F367_OFDM_TRACKER_FREE_2		0xF11F00FF
+
+/* DEBG_LT10 */
+#define	R367_OFDM_DEBG_LT10		0xF120
+#define	F367_OFDM_DEBUG_LT10		0xF12000FF
+
+/* DEBG_LT11 */
+#define	R367_OFDM_DEBG_LT11		0xF121
+#define	F367_OFDM_DEBUG_LT11		0xF12100FF
+
+/* DEBG_LT12 */
+#define	R367_OFDM_DEBG_LT12		0xF122
+#define	F367_OFDM_DEBUG_LT12		0xF12200FF
+
+/* DEBG_LT13 */
+#define	R367_OFDM_DEBG_LT13		0xF123
+#define	F367_OFDM_DEBUG_LT13		0xF12300FF
+
+/* DEBG_LT14 */
+#define	R367_OFDM_DEBG_LT14		0xF124
+#define	F367_OFDM_DEBUG_LT14		0xF12400FF
+
+/* DEBG_LT15 */
+#define	R367_OFDM_DEBG_LT15		0xF125
+#define	F367_OFDM_DEBUG_LT15		0xF12500FF
+
+/* DEBG_LT16 */
+#define	R367_OFDM_DEBG_LT16		0xF126
+#define	F367_OFDM_DEBUG_LT16		0xF12600FF
+
+/* DEBG_LT17 */
+#define	R367_OFDM_DEBG_LT17		0xF127
+#define	F367_OFDM_DEBUG_LT17		0xF12700FF
+
+/* DEBG_LT18 */
+#define	R367_OFDM_DEBG_LT18		0xF128
+#define	F367_OFDM_DEBUG_LT18		0xF12800FF
+
+/* DEBG_LT19 */
+#define	R367_OFDM_DEBG_LT19		0xF129
+#define	F367_OFDM_DEBUG_LT19		0xF12900FF
+
+/* DEBG_LT1A */
+#define	R367_OFDM_DEBG_LT1A		0xF12A
+#define	F367_OFDM_DEBUG_LT1A		0xF12A00FF
+
+/* DEBG_LT1B */
+#define	R367_OFDM_DEBG_LT1B		0xF12B
+#define	F367_OFDM_DEBUG_LT1B		0xF12B00FF
+
+/* DEBG_LT1C */
+#define	R367_OFDM_DEBG_LT1C		0xF12C
+#define	F367_OFDM_DEBUG_LT1C		0xF12C00FF
+
+/* DEBG_LT1D */
+#define	R367_OFDM_DEBG_LT1D		0xF12D
+#define	F367_OFDM_DEBUG_LT1D		0xF12D00FF
+
+/* DEBG_LT1E */
+#define	R367_OFDM_DEBG_LT1E		0xF12E
+#define	F367_OFDM_DEBUG_LT1E		0xF12E00FF
+
+/* DEBG_LT1F */
+#define	R367_OFDM_DEBG_LT1F		0xF12F
+#define	F367_OFDM_DEBUG_LT1F		0xF12F00FF
+
+/* RCCFGH */
+#define	R367_OFDM_RCCFGH		0xF200
+#define	F367_OFDM_TSRCFIFO_DVBCI		0xF2000080
+#define	F367_OFDM_TSRCFIFO_SERIAL		0xF2000040
+#define	F367_OFDM_TSRCFIFO_DISABLE		0xF2000020
+#define	F367_OFDM_TSFIFO_2TORC		0xF2000010
+#define	F367_OFDM_TSRCFIFO_HSGNLOUT		0xF2000008
+#define	F367_OFDM_TSRCFIFO_ERRMODE		0xF2000006
+#define	F367_OFDM_RCCFGH_0		0xF2000001
+
+/* RCCFGM */
+#define	R367_OFDM_RCCFGM		0xF201
+#define	F367_OFDM_TSRCFIFO_MANSPEED		0xF20100C0
+#define	F367_OFDM_TSRCFIFO_PERMDATA		0xF2010020
+#define	F367_OFDM_TSRCFIFO_NONEWSGNL		0xF2010010
+#define	F367_OFDM_RCBYTE_OVERSAMPLING		0xF201000E
+#define	F367_OFDM_TSRCFIFO_INVDATA		0xF2010001
+
+/* RCCFGL */
+#define	R367_OFDM_RCCFGL		0xF202
+#define	F367_OFDM_TSRCFIFO_BCLKDEL1CK		0xF20200C0
+#define	F367_OFDM_RCCFGL_5		0xF2020020
+#define	F367_OFDM_TSRCFIFO_DUTY50		0xF2020010
+#define	F367_OFDM_TSRCFIFO_NSGNL2DATA		0xF2020008
+#define	F367_OFDM_TSRCFIFO_DISSERMUX		0xF2020004
+#define	F367_OFDM_RCCFGL_1		0xF2020002
+#define	F367_OFDM_TSRCFIFO_STOPCKDIS		0xF2020001
+
+/* RCINSDELH */
+#define	R367_OFDM_RCINSDELH		0xF203
+#define	F367_OFDM_TSRCDEL_SYNCBYTE		0xF2030080
+#define	F367_OFDM_TSRCDEL_XXHEADER		0xF2030040
+#define	F367_OFDM_TSRCDEL_BBHEADER		0xF2030020
+#define	F367_OFDM_TSRCDEL_DATAFIELD		0xF2030010
+#define	F367_OFDM_TSRCINSDEL_ISCR		0xF2030008
+#define	F367_OFDM_TSRCINSDEL_NPD		0xF2030004
+#define	F367_OFDM_TSRCINSDEL_RSPARITY		0xF2030002
+#define	F367_OFDM_TSRCINSDEL_CRC8		0xF2030001
+
+/* RCINSDELM */
+#define	R367_OFDM_RCINSDELM		0xF204
+#define	F367_OFDM_TSRCINS_BBPADDING		0xF2040080
+#define	F367_OFDM_TSRCINS_BCHFEC		0xF2040040
+#define	F367_OFDM_TSRCINS_LDPCFEC		0xF2040020
+#define	F367_OFDM_TSRCINS_EMODCOD		0xF2040010
+#define	F367_OFDM_TSRCINS_TOKEN		0xF2040008
+#define	F367_OFDM_TSRCINS_XXXERR		0xF2040004
+#define	F367_OFDM_TSRCINS_MATYPE		0xF2040002
+#define	F367_OFDM_TSRCINS_UPL		0xF2040001
+
+/* RCINSDELL */
+#define	R367_OFDM_RCINSDELL		0xF205
+#define	F367_OFDM_TSRCINS_DFL		0xF2050080
+#define	F367_OFDM_TSRCINS_SYNCD		0xF2050040
+#define	F367_OFDM_TSRCINS_BLOCLEN		0xF2050020
+#define	F367_OFDM_TSRCINS_SIGPCOUNT		0xF2050010
+#define	F367_OFDM_TSRCINS_FIFO		0xF2050008
+#define	F367_OFDM_TSRCINS_REALPACK		0xF2050004
+#define	F367_OFDM_TSRCINS_TSCONFIG		0xF2050002
+#define	F367_OFDM_TSRCINS_LATENCY		0xF2050001
+
+/* RCSTATUS */
+#define	R367_OFDM_RCSTATUS		0xF206
+#define	F367_OFDM_TSRCFIFO_LINEOK		0xF2060080
+#define	F367_OFDM_TSRCFIFO_ERROR		0xF2060040
+#define	F367_OFDM_TSRCFIFO_DATA7		0xF2060020
+#define	F367_OFDM_RCSTATUS_4		0xF2060010
+#define	F367_OFDM_TSRCFIFO_DEMODSEL		0xF2060008
+#define	F367_OFDM_TSRC1FIFOSPEED_STORE		0xF2060004
+#define	F367_OFDM_RCSTATUS_1		0xF2060002
+#define	F367_OFDM_TSRCSERIAL_IMPOSSIBLE		0xF2060001
+
+/* RCSPEED */
+#define	R367_OFDM_RCSPEED		0xF207
+#define	F367_OFDM_TSRCFIFO_OUTSPEED		0xF20700FF
+
+/* RCDEBUGM */
+#define	R367_OFDM_RCDEBUGM		0xF208
+#define	F367_OFDM_SD_UNSYNC		0xF2080080
+#define	F367_OFDM_ULFLOCK_DETECTM		0xF2080040
+#define	F367_OFDM_SUL_SELECTOS		0xF2080020
+#define	F367_OFDM_DILUL_NOSCRBLE		0xF2080010
+#define	F367_OFDM_NUL_SCRB		0xF2080008
+#define	F367_OFDM_UL_SCRB		0xF2080004
+#define	F367_OFDM_SCRAULBAD		0xF2080002
+#define	F367_OFDM_SCRAUL_UNSYNC		0xF2080001
+
+/* RCDEBUGL */
+#define	R367_OFDM_RCDEBUGL		0xF209
+#define	F367_OFDM_RS_ERR		0xF2090080
+#define	F367_OFDM_LLFLOCK_DETECTM		0xF2090040
+#define	F367_OFDM_NOT_SUL_SELECTOS		0xF2090020
+#define	F367_OFDM_DILLL_NOSCRBLE		0xF2090010
+#define	F367_OFDM_NLL_SCRB		0xF2090008
+#define	F367_OFDM_LL_SCRB		0xF2090004
+#define	F367_OFDM_SCRALLBAD		0xF2090002
+#define	F367_OFDM_SCRALL_UNSYNC		0xF2090001
+
+/* RCOBSCFG */
+#define	R367_OFDM_RCOBSCFG		0xF20A
+#define	F367_OFDM_TSRCFIFO_OBSCFG		0xF20A00FF
+
+/* RCOBSM */
+#define	R367_OFDM_RCOBSM		0xF20B
+#define	F367_OFDM_TSRCFIFO_OBSDATA_HI		0xF20B00FF
+
+/* RCOBSL */
+#define	R367_OFDM_RCOBSL		0xF20C
+#define	F367_OFDM_TSRCFIFO_OBSDATA_LO		0xF20C00FF
+
+/* RCFECSPY */
+#define	R367_OFDM_RCFECSPY		0xF210
+#define	F367_OFDM_SPYRC_ENABLE		0xF2100080
+#define	F367_OFDM_RCNO_SYNCBYTE		0xF2100040
+#define	F367_OFDM_RCSERIAL_MODE		0xF2100020
+#define	F367_OFDM_RCUNUSUAL_PACKET		0xF2100010
+#define	F367_OFDM_BERRCMETER_DATAMODE		0xF210000C
+#define	F367_OFDM_BERRCMETER_LMODE		0xF2100002
+#define	F367_OFDM_BERRCMETER_RESET		0xF2100001
+
+/* RCFSPYCFG */
+#define	R367_OFDM_RCFSPYCFG		0xF211
+#define	F367_OFDM_FECSPYRC_INPUT		0xF21100C0
+#define	F367_OFDM_RCRST_ON_ERROR		0xF2110020
+#define	F367_OFDM_RCONE_SHOT		0xF2110010
+#define	F367_OFDM_RCI2C_MODE		0xF211000C
+#define	F367_OFDM_SPYRC_HSTERESIS		0xF2110003
+
+/* RCFSPYDATA */
+#define	R367_OFDM_RCFSPYDATA		0xF212
+#define	F367_OFDM_SPYRC_STUFFING		0xF2120080
+#define	F367_OFDM_RCNOERR_PKTJITTER		0xF2120040
+#define	F367_OFDM_SPYRC_CNULLPKT		0xF2120020
+#define	F367_OFDM_SPYRC_OUTDATA_MODE		0xF212001F
+
+/* RCFSPYOUT */
+#define	R367_OFDM_RCFSPYOUT		0xF213
+#define	F367_OFDM_FSPYRC_DIRECT		0xF2130080
+#define	F367_OFDM_RCFSPYOUT_6		0xF2130040
+#define	F367_OFDM_SPYRC_OUTDATA_BUS		0xF2130038
+#define	F367_OFDM_RCSTUFF_MODE		0xF2130007
+
+/* RCFSTATUS */
+#define	R367_OFDM_RCFSTATUS		0xF214
+#define	F367_OFDM_SPYRC_ENDSIM		0xF2140080
+#define	F367_OFDM_RCVALID_SIM		0xF2140040
+#define	F367_OFDM_RCFOUND_SIGNAL		0xF2140020
+#define	F367_OFDM_RCDSS_SYNCBYTE		0xF2140010
+#define	F367_OFDM_RCRESULT_STATE		0xF214000F
+
+/* RCFGOODPACK */
+#define	R367_OFDM_RCFGOODPACK		0xF215
+#define	F367_OFDM_RCGOOD_PACKET		0xF21500FF
+
+/* RCFPACKCNT */
+#define	R367_OFDM_RCFPACKCNT		0xF216
+#define	F367_OFDM_RCPACKET_COUNTER		0xF21600FF
+
+/* RCFSPYMISC */
+#define	R367_OFDM_RCFSPYMISC		0xF217
+#define	F367_OFDM_RCLABEL_COUNTER		0xF21700FF
+
+/* RCFBERCPT4 */
+#define	R367_OFDM_RCFBERCPT4		0xF218
+#define	F367_OFDM_FBERRCMETER_CPT_MMMMSB		0xF21800FF
+
+/* RCFBERCPT3 */
+#define	R367_OFDM_RCFBERCPT3		0xF219
+#define	F367_OFDM_FBERRCMETER_CPT_MMMSB		0xF21900FF
+
+/* RCFBERCPT2 */
+#define	R367_OFDM_RCFBERCPT2		0xF21A
+#define	F367_OFDM_FBERRCMETER_CPT_MMSB		0xF21A00FF
+
+/* RCFBERCPT1 */
+#define	R367_OFDM_RCFBERCPT1		0xF21B
+#define	F367_OFDM_FBERRCMETER_CPT_MSB		0xF21B00FF
+
+/* RCFBERCPT0 */
+#define	R367_OFDM_RCFBERCPT0		0xF21C
+#define	F367_OFDM_FBERRCMETER_CPT_LSB		0xF21C00FF
+
+/* RCFBERERR2 */
+#define	R367_OFDM_RCFBERERR2		0xF21D
+#define	F367_OFDM_FBERRCMETER_ERR_HI		0xF21D00FF
+
+/* RCFBERERR1 */
+#define	R367_OFDM_RCFBERERR1		0xF21E
+#define	F367_OFDM_FBERRCMETER_ERR		0xF21E00FF
+
+/* RCFBERERR0 */
+#define	R367_OFDM_RCFBERERR0		0xF21F
+#define	F367_OFDM_FBERRCMETER_ERR_LO		0xF21F00FF
+
+/* RCFSTATESM */
+#define	R367_OFDM_RCFSTATESM		0xF220
+#define	F367_OFDM_RCRSTATE_F		0xF2200080
+#define	F367_OFDM_RCRSTATE_E		0xF2200040
+#define	F367_OFDM_RCRSTATE_D		0xF2200020
+#define	F367_OFDM_RCRSTATE_C		0xF2200010
+#define	F367_OFDM_RCRSTATE_B		0xF2200008
+#define	F367_OFDM_RCRSTATE_A		0xF2200004
+#define	F367_OFDM_RCRSTATE_9		0xF2200002
+#define	F367_OFDM_RCRSTATE_8		0xF2200001
+
+/* RCFSTATESL */
+#define	R367_OFDM_RCFSTATESL		0xF221
+#define	F367_OFDM_RCRSTATE_7		0xF2210080
+#define	F367_OFDM_RCRSTATE_6		0xF2210040
+#define	F367_OFDM_RCRSTATE_5		0xF2210020
+#define	F367_OFDM_RCRSTATE_4		0xF2210010
+#define	F367_OFDM_RCRSTATE_3		0xF2210008
+#define	F367_OFDM_RCRSTATE_2		0xF2210004
+#define	F367_OFDM_RCRSTATE_1		0xF2210002
+#define	F367_OFDM_RCRSTATE_0		0xF2210001
+
+/* RCFSPYBER */
+#define	R367_OFDM_RCFSPYBER		0xF222
+#define	F367_OFDM_RCFSPYBER_7		0xF2220080
+#define	F367_OFDM_SPYRCOBS_XORREAD		0xF2220040
+#define	F367_OFDM_FSPYRCBER_OBSMODE		0xF2220020
+#define	F367_OFDM_FSPYRCBER_SYNCBYT		0xF2220010
+#define	F367_OFDM_FSPYRCBER_UNSYNC		0xF2220008
+#define	F367_OFDM_FSPYRCBER_CTIME		0xF2220007
+
+/* RCFSPYDISTM */
+#define	R367_OFDM_RCFSPYDISTM		0xF223
+#define	F367_OFDM_RCPKTTIME_DISTANCE_HI		0xF22300FF
+
+/* RCFSPYDISTL */
+#define	R367_OFDM_RCFSPYDISTL		0xF224
+#define	F367_OFDM_RCPKTTIME_DISTANCE_LO		0xF22400FF
+
+/* RCFSPYOBS7 */
+#define	R367_OFDM_RCFSPYOBS7		0xF228
+#define	F367_OFDM_RCSPYOBS_SPYFAIL		0xF2280080
+#define	F367_OFDM_RCSPYOBS_SPYFAIL1		0xF2280040
+#define	F367_OFDM_RCSPYOBS_ERROR		0xF2280020
+#define	F367_OFDM_RCSPYOBS_STROUT		0xF2280010
+#define	F367_OFDM_RCSPYOBS_RESULTSTATE1		0xF228000F
+
+/* RCFSPYOBS6 */
+#define	R367_OFDM_RCFSPYOBS6		0xF229
+#define	F367_OFDM_RCSPYOBS_RESULTSTATE0		0xF22900F0
+#define	F367_OFDM_RCSPYOBS_RESULTSTATEM1		0xF229000F
+
+/* RCFSPYOBS5 */
+#define	R367_OFDM_RCFSPYOBS5		0xF22A
+#define	F367_OFDM_RCSPYOBS_BYTEOFPACKET1		0xF22A00FF
+
+/* RCFSPYOBS4 */
+#define	R367_OFDM_RCFSPYOBS4		0xF22B
+#define	F367_OFDM_RCSPYOBS_BYTEVALUE1		0xF22B00FF
+
+/* RCFSPYOBS3 */
+#define	R367_OFDM_RCFSPYOBS3		0xF22C
+#define	F367_OFDM_RCSPYOBS_DATA1		0xF22C00FF
+
+/* RCFSPYOBS2 */
+#define	R367_OFDM_RCFSPYOBS2		0xF22D
+#define	F367_OFDM_RCSPYOBS_DATA0		0xF22D00FF
+
+/* RCFSPYOBS1 */
+#define	R367_OFDM_RCFSPYOBS1		0xF22E
+#define	F367_OFDM_RCSPYOBS_DATAM1		0xF22E00FF
+
+/* RCFSPYOBS0 */
+#define	R367_OFDM_RCFSPYOBS0		0xF22F
+#define	F367_OFDM_RCSPYOBS_DATAM2		0xF22F00FF
+
+/* TSGENERAL */
+#define	R367_TSGENERAL		0xF230
+#define	F367_TSGENERAL_7		0xF2300080
+#define	F367_TSGENERAL_6		0xF2300040
+#define	F367_TSFIFO_BCLK1ALL		0xF2300020
+#define	F367_TSGENERAL_4		0xF2300010
+#define	F367_MUXSTREAM_OUTMODE		0xF2300008
+#define	F367_TSFIFO_PERMPARAL		0xF2300006
+#define	F367_RST_REEDSOLO		0xF2300001
+
+/* RC1SPEED */
+#define	R367_RC1SPEED		0xF231
+#define	F367_TSRCFIFO1_OUTSPEED		0xF23100FF
+
+/* TSGSTATUS */
+#define	R367_TSGSTATUS		0xF232
+#define	F367_TSGSTATUS_7		0xF2320080
+#define	F367_TSGSTATUS_6		0xF2320040
+#define	F367_RSMEM_FULL		0xF2320020
+#define	F367_RS_MULTCALC		0xF2320010
+#define	F367_RSIN_OVERTIME		0xF2320008
+#define	F367_TSFIFO3_DEMODSEL		0xF2320004
+#define	F367_TSFIFO2_DEMODSEL		0xF2320002
+#define	F367_TSFIFO1_DEMODSEL		0xF2320001
+
+
+/* FECM */
+#define	R367_OFDM_FECM		0xF233
+#define	F367_OFDM_DSS_DVB		0xF2330080
+#define	F367_OFDM_DEMOD_BYPASS		0xF2330040
+#define	F367_OFDM_CMP_SLOWMODE		0xF2330020
+#define	F367_OFDM_DSS_SRCH		0xF2330010
+#define	F367_OFDM_FECM_3		0xF2330008
+#define	F367_OFDM_DIFF_MODEVIT		0xF2330004
+#define	F367_OFDM_SYNCVIT		0xF2330002
+#define	F367_OFDM_I2CSYM		0xF2330001
+
+/* VTH12 */
+#define	R367_OFDM_VTH12		0xF234
+#define	F367_OFDM_VTH_12		0xF23400FF
+
+/* VTH23 */
+#define	R367_OFDM_VTH23		0xF235
+#define	F367_OFDM_VTH_23		0xF23500FF
+
+/* VTH34 */
+#define	R367_OFDM_VTH34		0xF236
+#define	F367_OFDM_VTH_34		0xF23600FF
+
+/* VTH56 */
+#define	R367_OFDM_VTH56		0xF237
+#define	F367_OFDM_VTH_56		0xF23700FF
+
+/* VTH67 */
+#define	R367_OFDM_VTH67		0xF238
+#define	F367_OFDM_VTH_67		0xF23800FF
+
+/* VTH78 */
+#define	R367_OFDM_VTH78		0xF239
+#define	F367_OFDM_VTH_78		0xF23900FF
+
+/* VITCURPUN */
+#define	R367_OFDM_VITCURPUN		0xF23A
+#define	F367_OFDM_VIT_MAPPING		0xF23A00E0
+#define	F367_OFDM_VIT_CURPUN		0xF23A001F
+
+/* VERROR */
+#define	R367_OFDM_VERROR		0xF23B
+#define	F367_OFDM_REGERR_VIT		0xF23B00FF
+
+/* PRVIT */
+#define	R367_OFDM_PRVIT		0xF23C
+#define	F367_OFDM_PRVIT_7		0xF23C0080
+#define	F367_OFDM_DIS_VTHLOCK		0xF23C0040
+#define	F367_OFDM_E7_8VIT		0xF23C0020
+#define	F367_OFDM_E6_7VIT		0xF23C0010
+#define	F367_OFDM_E5_6VIT		0xF23C0008
+#define	F367_OFDM_E3_4VIT		0xF23C0004
+#define	F367_OFDM_E2_3VIT		0xF23C0002
+#define	F367_OFDM_E1_2VIT		0xF23C0001
+
+/* VAVSRVIT */
+#define	R367_OFDM_VAVSRVIT		0xF23D
+#define	F367_OFDM_AMVIT		0xF23D0080
+#define	F367_OFDM_FROZENVIT		0xF23D0040
+#define	F367_OFDM_SNVIT		0xF23D0030
+#define	F367_OFDM_TOVVIT		0xF23D000C
+#define	F367_OFDM_HYPVIT		0xF23D0003
+
+/* VSTATUSVIT */
+#define	R367_OFDM_VSTATUSVIT		0xF23E
+#define	F367_OFDM_VITERBI_ON		0xF23E0080
+#define	F367_OFDM_END_LOOPVIT		0xF23E0040
+#define	F367_OFDM_VITERBI_DEPRF		0xF23E0020
+#define	F367_OFDM_PRFVIT		0xF23E0010
+#define	F367_OFDM_LOCKEDVIT		0xF23E0008
+#define	F367_OFDM_VITERBI_DELOCK		0xF23E0004
+#define	F367_OFDM_VIT_DEMODSEL		0xF23E0002
+#define	F367_OFDM_VITERBI_COMPOUT		0xF23E0001
+
+/* VTHINUSE */
+#define	R367_OFDM_VTHINUSE		0xF23F
+#define	F367_OFDM_VIT_INUSE		0xF23F00FF
+
+/* KDIV12 */
+#define	R367_OFDM_KDIV12		0xF240
+#define	F367_OFDM_KDIV12_MANUAL		0xF2400080
+#define	F367_OFDM_K_DIVIDER_12		0xF240007F
+
+/* KDIV23 */
+#define	R367_OFDM_KDIV23		0xF241
+#define	F367_OFDM_KDIV23_MANUAL		0xF2410080
+#define	F367_OFDM_K_DIVIDER_23		0xF241007F
+
+/* KDIV34 */
+#define	R367_OFDM_KDIV34		0xF242
+#define	F367_OFDM_KDIV34_MANUAL		0xF2420080
+#define	F367_OFDM_K_DIVIDER_34		0xF242007F
+
+/* KDIV56 */
+#define	R367_OFDM_KDIV56		0xF243
+#define	F367_OFDM_KDIV56_MANUAL		0xF2430080
+#define	F367_OFDM_K_DIVIDER_56		0xF243007F
+
+/* KDIV67 */
+#define	R367_OFDM_KDIV67		0xF244
+#define	F367_OFDM_KDIV67_MANUAL		0xF2440080
+#define	F367_OFDM_K_DIVIDER_67		0xF244007F
+
+/* KDIV78 */
+#define	R367_OFDM_KDIV78		0xF245
+#define	F367_OFDM_KDIV78_MANUAL		0xF2450080
+#define	F367_OFDM_K_DIVIDER_78		0xF245007F
+
+/* SIGPOWER */
+#define	R367_OFDM_SIGPOWER		0xF246
+#define	F367_OFDM_SIGPOWER_MANUAL		0xF2460080
+#define	F367_OFDM_SIG_POWER		0xF246007F
+
+/* DEMAPVIT */
+#define	R367_OFDM_DEMAPVIT		0xF247
+#define	F367_OFDM_DEMAPVIT_7		0xF2470080
+#define	F367_OFDM_K_DIVIDER_VIT		0xF247007F
+
+/* VITSCALE */
+#define	R367_OFDM_VITSCALE		0xF248
+#define	F367_OFDM_NVTH_NOSRANGE		0xF2480080
+#define	F367_OFDM_VERROR_MAXMODE		0xF2480040
+#define	F367_OFDM_KDIV_MODE		0xF2480030
+#define	F367_OFDM_NSLOWSN_LOCKED		0xF2480008
+#define	F367_OFDM_DELOCK_PRFLOSS		0xF2480004
+#define	F367_OFDM_DIS_RSFLOCK		0xF2480002
+#define	F367_OFDM_VITSCALE_0		0xF2480001
+
+/* FFEC1PRG */
+#define	R367_OFDM_FFEC1PRG		0xF249
+#define	F367_OFDM_FDSS_DVB		0xF2490080
+#define	F367_OFDM_FDSS_SRCH		0xF2490040
+#define	F367_OFDM_FFECPROG_5		0xF2490020
+#define	F367_OFDM_FFECPROG_4		0xF2490010
+#define	F367_OFDM_FFECPROG_3		0xF2490008
+#define	F367_OFDM_FFECPROG_2		0xF2490004
+#define	F367_OFDM_FTS1_DISABLE		0xF2490002
+#define	F367_OFDM_FTS2_DISABLE		0xF2490001
+
+/* FVITCURPUN */
+#define	R367_OFDM_FVITCURPUN		0xF24A
+#define	F367_OFDM_FVIT_MAPPING		0xF24A00E0
+#define	F367_OFDM_FVIT_CURPUN		0xF24A001F
+
+/* FVERROR */
+#define	R367_OFDM_FVERROR		0xF24B
+#define	F367_OFDM_FREGERR_VIT		0xF24B00FF
+
+/* FVSTATUSVIT */
+#define	R367_OFDM_FVSTATUSVIT		0xF24C
+#define	F367_OFDM_FVITERBI_ON		0xF24C0080
+#define	F367_OFDM_F1END_LOOPVIT		0xF24C0040
+#define	F367_OFDM_FVITERBI_DEPRF		0xF24C0020
+#define	F367_OFDM_FPRFVIT		0xF24C0010
+#define	F367_OFDM_FLOCKEDVIT		0xF24C0008
+#define	F367_OFDM_FVITERBI_DELOCK		0xF24C0004
+#define	F367_OFDM_FVIT_DEMODSEL		0xF24C0002
+#define	F367_OFDM_FVITERBI_COMPOUT		0xF24C0001
+
+/* DEBUG_LT1 */
+#define	R367_OFDM_DEBUG_LT1		0xF24D
+#define	F367_OFDM_DBG_LT1		0xF24D00FF
+
+/* DEBUG_LT2 */
+#define	R367_OFDM_DEBUG_LT2		0xF24E
+#define	F367_OFDM_DBG_LT2		0xF24E00FF
+
+/* DEBUG_LT3 */
+#define	R367_OFDM_DEBUG_LT3		0xF24F
+#define	F367_OFDM_DBG_LT3		0xF24F00FF
+
+	/*	TSTSFMET */
+#define	R367_OFDM_TSTSFMET			0xF250
+#define F367_OFDM_TSTSFEC_METRIQUES	0xF25000FF
+
+	/*	SELOUT */
+#define	R367_OFDM_SELOUT				0xF252
+#define	F367_OFDM_EN_SYNC			0xF2520080
+#define	F367_OFDM_EN_TBUSDEMAP       0xF2520040 
+#define	F367_OFDM_SELOUT_5			0xF2520020
+#define	F367_OFDM_SELOUT_4			0xF2520010
+#define	F367_OFDM_TSTSYNCHRO_MODE    0xF2520002
+
+	/*	TSYNC */
+#define R367_OFDM_TSYNC				0xF253
+#define F367_OFDM_CURPUN_INCMODE		0xF2530080
+#define F367_OFDM_CERR_TSTMODE		0xF2530040
+#define F367_OFDM_SHIFTSOF_MODE		0xF2530030
+#define F367_OFDM_SLOWPHA_MODE		0xF2530008
+#define F367_OFDM_PXX_BYPALL			0xF2530004
+#define F367_OFDM_FROTA45_FIRST		0xF2530002
+#define F367_OFDM_TST_BCHERROR		0xF2530001
+
+	/*	TSTERR */
+#define R367_OFDM_TSTERR				0xF254
+#define F367_OFDM_TST_LONGPKT		0xF2540080
+#define F367_OFDM_TST_ISSYION		0xF2540040
+#define F367_OFDM_TST_NPDON			0xF2540020
+#define F367_OFDM_TSTERR_4			0xF2540010
+#define F367_OFDM_TRACEBACK_MODE		0xF2540008
+#define F367_OFDM_TST_RSPARITY		0xF2540004
+#define F367_OFDM_METRIQUE_MODE		0xF2540003
+
+	/*	TSFSYNC */
+#define R367_OFDM_TSFSYNC			0xF255
+#define F367_OFDM_EN_SFECSYNC		0xF2550080
+#define F367_OFDM_EN_SFECDEMAP		0xF2550040
+#define F367_OFDM_SFCERR_TSTMODE		0xF2550020
+#define F367_OFDM_SFECPXX_BYPALL		0xF2550010
+#define F367_OFDM_SFECTSTSYNCHRO_MODE 0xF255000F
+
+	/*	TSTSFERR */
+#define R367_OFDM_TSTSFERR			0xF256
+#define F367_OFDM_TSTSTERR_7			0xF2560080
+#define F367_OFDM_TSTSTERR_6			0xF2560040
+#define F367_OFDM_TSTSTERR_5 		0xF2560020
+#define F367_OFDM_TSTSTERR_4			0xF2560010
+#define F367_OFDM_SFECTRACEBACK_MODE	0xF2560008
+#define F367_OFDM_SFEC_NCONVPROG		0xF2560004
+#define F367_OFDM_SFECMETRIQUE_MODE	0xF2560003
+
+	/*	TSTTSSF1 */
+#define R367_OFDM_TSTTSSF1			0xF258
+#define F367_OFDM_TSTERSSF			0xF2580080
+#define F367_OFDM_TSTTSSFEN			0xF2580040
+#define F367_OFDM_SFEC_OUTMODE		0xF2580030
+#define F367_OFDM_XLSF_NOFTHRESHOLD  0xF2580008
+#define F367_OFDM_TSTTSSF_STACKSEL	0xF2580007
+
+	/*	TSTTSSF2 */
+#define R367_OFDM_TSTTSSF2			0xF259
+#define F367_OFDM_DILSF_DBBHEADER	0xF2590080
+#define F367_OFDM_TSTTSSF_DISBUG		0xF2590040
+#define F367_OFDM_TSTTSSF_NOBADSTART	0xF2590020
+#define F367_OFDM_TSTTSSF_SELECT 	0xF259001F
+
+	/*	TSTTSSF3 */
+#define R367_OFDM_TSTTSSF3			0xF25A
+#define F367_OFDM_TSTTSSF3_7			0xF25A0080
+#define F367_OFDM_TSTTSSF3_6			0xF25A0040
+#define F367_OFDM_TSTTSSF3_5			0xF25A0020
+#define F367_OFDM_TSTTSSF3_4			0xF25A0010
+#define F367_OFDM_TSTTSSF3_3			0xF25A0008
+#define F367_OFDM_TSTTSSF3_2			0xF25A0004
+#define F367_OFDM_TSTTSSF3_1			0xF25A0002
+#define F367_OFDM_DISSF_CLKENABLE    0xF25A0001
+
+	/*	TSTTS1 */
+#define R367_OFDM_TSTTS1				0xF25C
+#define F367_OFDM_TSTERS				0xF25C0080
+#define F367_OFDM_TSFIFO_DSSSYNCB	0xF25C0040
+#define F367_OFDM_TSTTS_FSPYBEFRS	0xF25C0020
+#define F367_OFDM_NFORCE_SYNCBYTE	0xF25C0010
+#define F367_OFDM_XL_NOFTHRESHOLD	0xF25C0008
+#define F367_OFDM_TSTTS_FRFORCEPKT	0xF25C0004
+#define F367_OFDM_DESCR_NOTAUTO		0xF25C0002
+#define F367_OFDM_TSTTSEN			0xF25C0001
+		    
+	/*	TSTTS2 */
+#define R367_OFDM_TSTTS2				0xF25D
+#define F367_OFDM_DIL_DBBHEADER		0xF25D0080
+#define F367_OFDM_TSTTS_NOBADXXX		0xF25D0040
+#define F367_OFDM_TSFIFO_DELSPEEDUP	0xF25D0020
+#define F367_OFDM_TSTTS_SELECT		0xF25D001F
+		    
+	/*	TSTTS3 */
+#define R367_OFDM_TSTTS3				0xF25E
+#define F367_OFDM_TSTTS_NOPKTGAIN	0xF25E0080
+#define F367_OFDM_TSTTS_NOPKTENE		0xF25E0040
+#define F367_OFDM_TSTTS_ISOLATION	0xF25E0020
+#define F367_OFDM_TSTTS_DISBUG		0xF25E0010
+#define F367_OFDM_TSTTS_NOBADSTART	0xF25E0008
+#define F367_OFDM_TSTTS_STACKSEL		0xF25E0007
+
+	/*	TSTTS4 */
+#define R367_OFDM_TSTTS4				0xF25F
+#define F367_OFDM_TSTTS4_7			0xF25F0080
+#define F367_OFDM_TSTTS4_6			0xF25F0040
+#define F367_OFDM_TSTTS4_5			0xF25F0020
+#define F367_OFDM_TSTTS_DISDSTATE	0xF25F0010
+#define F367_OFDM_TSTTS_FASTNOSYNC	0xF25F0008
+#define F367_OFDM_EXT_FECSPYIN		0xF25F0004
+#define F367_OFDM_TSTTS_NODPZERO		0xF25F0002
+#define F367_OFDM_TSTTS_NODIV3		0xF25F0001
+
+	/*	TSTTSRC */
+#define R367_OFDM_TSTTSRC				0xF26C
+#define F367_OFDM_TSTTSRC_7				0xF26C0080
+#define F367_OFDM_TSRCFIFO_DSSSYNCB		0xF26C0040
+#define F367_OFDM_TSRCFIFO_DPUNACTIVE	0xF26C0020
+#define F367_OFDM_TSRCFIFO_DELSPEEDUP	0xF26C0010
+#define F367_OFDM_TSTTSRC_NODIV3			0xF26C0008
+#define F367_OFDM_TSTTSRC_FRFORCEPKT		0xF26C0004
+#define F367_OFDM_SAT25_SDDORIGINE		0xF26C0002
+#define F367_OFDM_TSTTSRC_INACTIVE		0xF26C0001
+
+	/*	TSTTSRS */
+#define R367_OFDM_TSTTSRS				0xF26D
+#define F367_OFDM_TSTTSRS_7				0xF26D0080
+#define F367_OFDM_TSTTSRS_6				0xF26D0040
+#define F367_OFDM_TSTTSRS_5				0xF26D0020
+#define F367_OFDM_TSTTSRS_4				0xF26D0010
+#define F367_OFDM_TSTTSRS_3				0xF26D0008
+#define F367_OFDM_TSTTSRS_2				0xF26D0004
+#define F367_OFDM_TSTRS_DISRS2			0xF26D0002
+#define F367_OFDM_TSTRS_DISRS1			0xF26D0001
+
+/* TSSTATEM */
+#define	R367_OFDM_TSSTATEM		0xF270
+#define	F367_OFDM_TSDIL_ON		0xF2700080
+#define	F367_OFDM_TSSKIPRS_ON		0xF2700040
+#define	F367_OFDM_TSRS_ON		0xF2700020
+#define	F367_OFDM_TSDESCRAMB_ON		0xF2700010
+#define	F367_OFDM_TSFRAME_MODE		0xF2700008
+#define	F367_OFDM_TS_DISABLE		0xF2700004
+#define	F367_OFDM_TSACM_MODE		0xF2700002
+#define	F367_OFDM_TSOUT_NOSYNC		0xF2700001
+
+/* TSSTATEL */
+#define	R367_OFDM_TSSTATEL		0xF271
+#define	F367_OFDM_TSNOSYNCBYTE		0xF2710080
+#define	F367_OFDM_TSPARITY_ON		0xF2710040
+#define	F367_OFDM_TSSYNCOUTRS_ON		0xF2710020
+#define	F367_OFDM_TSDVBS2_MODE		0xF2710010
+#define	F367_OFDM_TSISSYI_ON		0xF2710008
+#define	F367_OFDM_TSNPD_ON		0xF2710004
+#define	F367_OFDM_TSCRC8_ON		0xF2710002
+#define	F367_OFDM_TSDSS_PACKET		0xF2710001
+
+/* TSCFGH */
+#define	R367_OFDM_TSCFGH		0xF272
+#define	F367_OFDM_TSFIFO_DVBCI		0xF2720080
+#define	F367_OFDM_TSFIFO_SERIAL		0xF2720040
+#define	F367_OFDM_TSFIFO_TEIUPDATE		0xF2720020
+#define	F367_OFDM_TSFIFO_DUTY50		0xF2720010
+#define	F367_OFDM_TSFIFO_HSGNLOUT		0xF2720008
+#define	F367_OFDM_TSFIFO_ERRMODE		0xF2720006
+#define	F367_OFDM_RST_HWARE		0xF2720001
+
+/* TSCFGM */
+#define	R367_OFDM_TSCFGM		0xF273
+#define	F367_OFDM_TSFIFO_MANSPEED		0xF27300C0
+#define	F367_OFDM_TSFIFO_PERMDATA		0xF2730020
+#define	F367_OFDM_TSFIFO_NONEWSGNL		0xF2730010
+#define	F367_OFDM_TSFIFO_BITSPEED		0xF2730008
+#define	F367_OFDM_NPD_SPECDVBS2		0xF2730004
+#define	F367_OFDM_TSFIFO_STOPCKDIS		0xF2730002
+#define	F367_OFDM_TSFIFO_INVDATA		0xF2730001
+
+/* TSCFGL */
+#define	R367_OFDM_TSCFGL		0xF274
+#define	F367_OFDM_TSFIFO_BCLKDEL1CK		0xF27400C0
+#define	F367_OFDM_BCHERROR_MODE		0xF2740030
+#define	F367_OFDM_TSFIFO_NSGNL2DATA		0xF2740008
+#define	F367_OFDM_TSFIFO_EMBINDVB		0xF2740004
+#define	F367_OFDM_TSFIFO_DPUNACT		0xF2740002
+#define	F367_OFDM_TSFIFO_NPDOFF		0xF2740001
+
+/* TSSYNC */
+#define	R367_OFDM_TSSYNC		0xF275
+#define	F367_OFDM_TSFIFO_PERMUTE		0xF2750080
+#define	F367_OFDM_TSFIFO_FISCR3B		0xF2750060
+#define	F367_OFDM_TSFIFO_SYNCMODE		0xF2750018
+#define	F367_OFDM_TSFIFO_SYNCSEL		0xF2750007
+
+/* TSINSDELH */
+#define	R367_OFDM_TSINSDELH		0xF276
+#define	F367_OFDM_TSDEL_SYNCBYTE		0xF2760080
+#define	F367_OFDM_TSDEL_XXHEADER		0xF2760040
+#define	F367_OFDM_TSDEL_BBHEADER		0xF2760020
+#define	F367_OFDM_TSDEL_DATAFIELD		0xF2760010
+#define	F367_OFDM_TSINSDEL_ISCR		0xF2760008
+#define	F367_OFDM_TSINSDEL_NPD		0xF2760004
+#define	F367_OFDM_TSINSDEL_RSPARITY		0xF2760002
+#define	F367_OFDM_TSINSDEL_CRC8		0xF2760001
+
+/* TSINSDELM */
+#define	R367_OFDM_TSINSDELM		0xF277
+#define	F367_OFDM_TSINS_BBPADDING		0xF2770080
+#define	F367_OFDM_TSINS_BCHFEC		0xF2770040
+#define	F367_OFDM_TSINS_LDPCFEC		0xF2770020
+#define	F367_OFDM_TSINS_EMODCOD		0xF2770010
+#define	F367_OFDM_TSINS_TOKEN		0xF2770008
+#define	F367_OFDM_TSINS_XXXERR		0xF2770004
+#define	F367_OFDM_TSINS_MATYPE		0xF2770002
+#define	F367_OFDM_TSINS_UPL		0xF2770001
+
+/* TSINSDELL */
+#define	R367_OFDM_TSINSDELL		0xF278
+#define	F367_OFDM_TSINS_DFL		0xF2780080
+#define	F367_OFDM_TSINS_SYNCD		0xF2780040
+#define	F367_OFDM_TSINS_BLOCLEN		0xF2780020
+#define	F367_OFDM_TSINS_SIGPCOUNT		0xF2780010
+#define	F367_OFDM_TSINS_FIFO		0xF2780008
+#define	F367_OFDM_TSINS_REALPACK		0xF2780004
+#define	F367_OFDM_TSINS_TSCONFIG		0xF2780002
+#define	F367_OFDM_TSINS_LATENCY		0xF2780001
+
+/* TSDIVN */
+#define	R367_OFDM_TSDIVN		0xF279
+#define	F367_OFDM_TSFIFO_LOWSPEED		0xF2790080
+#define	F367_OFDM_BYTE_OVERSAMPLING		0xF2790070
+#define	F367_OFDM_TSMANUAL_PACKETNBR		0xF279000F
+
+/* TSDIVPM */
+#define	R367_OFDM_TSDIVPM		0xF27A
+#define	F367_OFDM_TSMANUAL_P_HI		0xF27A00FF
+
+/* TSDIVPL */
+#define	R367_OFDM_TSDIVPL		0xF27B
+#define	F367_OFDM_TSMANUAL_P_LO		0xF27B00FF
+
+/* TSDIVQM */
+#define	R367_OFDM_TSDIVQM		0xF27C
+#define	F367_OFDM_TSMANUAL_Q_HI		0xF27C00FF
+
+/* TSDIVQL */
+#define	R367_OFDM_TSDIVQL		0xF27D
+#define	F367_OFDM_TSMANUAL_Q_LO		0xF27D00FF
+
+/* TSDILSTKM */
+#define	R367_OFDM_TSDILSTKM		0xF27E
+#define	F367_OFDM_TSFIFO_DILSTK_HI		0xF27E00FF
+
+/* TSDILSTKL */
+#define	R367_OFDM_TSDILSTKL		0xF27F
+#define	F367_OFDM_TSFIFO_DILSTK_LO		0xF27F00FF
+
+/* TSSPEED */
+#define	R367_OFDM_TSSPEED		0xF280
+#define	F367_OFDM_TSFIFO_OUTSPEED		0xF28000FF
+
+/* TSSTATUS */
+#define	R367_OFDM_TSSTATUS		0xF281
+#define	F367_OFDM_TSFIFO_LINEOK		0xF2810080
+#define	F367_OFDM_TSFIFO_ERROR		0xF2810040
+#define	F367_OFDM_TSFIFO_DATA7		0xF2810020
+#define	F367_OFDM_TSFIFO_NOSYNC		0xF2810010
+#define	F367_OFDM_ISCR_INITIALIZED		0xF2810008
+#define	F367_OFDM_ISCR_UPDATED		0xF2810004
+#define	F367_OFDM_SOFFIFO_UNREGUL		0xF2810002
+#define	F367_OFDM_DIL_READY		0xF2810001
+
+/* TSSTATUS2 */
+#define	R367_OFDM_TSSTATUS2		0xF282
+#define	F367_OFDM_TSFIFO_DEMODSEL		0xF2820080
+#define	F367_OFDM_TSFIFOSPEED_STORE		0xF2820040
+#define	F367_OFDM_DILXX_RESET		0xF2820020
+#define	F367_OFDM_TSSERIAL_IMPOSSIBLE		0xF2820010
+#define	F367_OFDM_TSFIFO_UNDERSPEED		0xF2820008
+#define	F367_OFDM_BITSPEED_EVENT		0xF2820004
+#define	F367_OFDM_UL_SCRAMBDETECT		0xF2820002
+#define	F367_OFDM_ULDTV67_FALSELOCK		0xF2820001
+
+/* TSBITRATEM */
+#define	R367_OFDM_TSBITRATEM		0xF283
+#define	F367_OFDM_TSFIFO_BITRATE_HI		0xF28300FF
+
+/* TSBITRATEL */
+#define	R367_OFDM_TSBITRATEL		0xF284
+#define	F367_OFDM_TSFIFO_BITRATE_LO		0xF28400FF
+
+/* TSPACKLENM */
+#define	R367_OFDM_TSPACKLENM		0xF285
+#define	F367_OFDM_TSFIFO_PACKCPT		0xF28500E0
+#define	F367_OFDM_DIL_RPLEN_HI		0xF285001F
+
+/* TSPACKLENL */
+#define	R367_OFDM_TSPACKLENL		0xF286
+#define	F367_OFDM_DIL_RPLEN_LO		0xF28600FF
+
+/* TSBLOCLENM */
+#define	R367_OFDM_TSBLOCLENM		0xF287
+#define	F367_OFDM_TSFIFO_PFLEN_HI		0xF28700FF
+
+/* TSBLOCLENL */
+#define	R367_OFDM_TSBLOCLENL		0xF288
+#define	F367_OFDM_TSFIFO_PFLEN_LO		0xF28800FF
+
+/* TSDLYH */
+#define	R367_OFDM_TSDLYH		0xF289
+#define	F367_OFDM_SOFFIFO_TSTIMEVALID		0xF2890080
+#define	F367_OFDM_SOFFIFO_SPEEDUP		0xF2890040
+#define	F367_OFDM_SOFFIFO_STOP		0xF2890020
+#define	F367_OFDM_SOFFIFO_REGULATED		0xF2890010
+#define	F367_OFDM_SOFFIFO_REALSBOFF_HI		0xF289000F
+
+/* TSDLYM */
+#define	R367_OFDM_TSDLYM		0xF28A
+#define	F367_OFDM_SOFFIFO_REALSBOFF_MED		0xF28A00FF
+
+/* TSDLYL */
+#define	R367_OFDM_TSDLYL		0xF28B
+#define	F367_OFDM_SOFFIFO_REALSBOFF_LO		0xF28B00FF
+
+/* TSNPDAV */
+#define	R367_OFDM_TSNPDAV		0xF28C
+#define	F367_OFDM_TSNPD_AVERAGE		0xF28C00FF
+
+/* TSBUFSTATH */
+#define	R367_OFDM_TSBUFSTATH		0xF28D
+#define	F367_OFDM_TSISCR_3BYTES		0xF28D0080
+#define	F367_OFDM_TSISCR_NEWDATA		0xF28D0040
+#define	F367_OFDM_TSISCR_BUFSTAT_HI		0xF28D003F
+
+/* TSBUFSTATM */
+#define	R367_OFDM_TSBUFSTATM		0xF28E
+#define	F367_OFDM_TSISCR_BUFSTAT_MED		0xF28E00FF
+
+/* TSBUFSTATL */
+#define	R367_OFDM_TSBUFSTATL		0xF28F
+#define	F367_OFDM_TSISCR_BUFSTAT_LO		0xF28F00FF
+
+/* TSDEBUGM */
+#define	R367_OFDM_TSDEBUGM		0xF290
+#define	F367_OFDM_TSFIFO_ILLPACKET		0xF2900080
+#define	F367_OFDM_DIL_NOSYNC		0xF2900040
+#define	F367_OFDM_DIL_ISCR		0xF2900020
+#define	F367_OFDM_DILOUT_BSYNCB		0xF2900010
+#define	F367_OFDM_TSFIFO_EMPTYPKT		0xF2900008
+#define	F367_OFDM_TSFIFO_EMPTYRD		0xF2900004
+#define	F367_OFDM_SOFFIFO_STOPM		0xF2900002
+#define	F367_OFDM_SOFFIFO_SPEEDUPM		0xF2900001
+
+/* TSDEBUGL */
+#define	R367_OFDM_TSDEBUGL		0xF291
+#define	F367_OFDM_TSFIFO_PACKLENFAIL		0xF2910080
+#define	F367_OFDM_TSFIFO_SYNCBFAIL		0xF2910040
+#define	F367_OFDM_TSFIFO_VITLIBRE		0xF2910020
+#define	F367_OFDM_TSFIFO_BOOSTSPEEDM		0xF2910010
+#define	F367_OFDM_TSFIFO_UNDERSPEEDM		0xF2910008
+#define	F367_OFDM_TSFIFO_ERROR_EVNT		0xF2910004
+#define	F367_OFDM_TSFIFO_FULL		0xF2910002
+#define	F367_OFDM_TSFIFO_OVERFLOWM		0xF2910001
+
+/* TSDLYSETH */
+#define	R367_OFDM_TSDLYSETH		0xF292
+#define	F367_OFDM_SOFFIFO_OFFSET		0xF29200E0
+#define	F367_OFDM_SOFFIFO_SYMBOFFSET_HI		0xF292001F
+
+/* TSDLYSETM */
+#define	R367_OFDM_TSDLYSETM		0xF293
+#define	F367_OFDM_SOFFIFO_SYMBOFFSET_MED		0xF29300FF
+
+/* TSDLYSETL */
+#define	R367_OFDM_TSDLYSETL		0xF294
+#define	F367_OFDM_SOFFIFO_SYMBOFFSET_LO		0xF29400FF
+
+/* TSOBSCFG */
+#define	R367_OFDM_TSOBSCFG		0xF295
+#define	F367_OFDM_TSFIFO_OBSCFG		0xF29500FF
+
+/* TSOBSM */
+#define	R367_OFDM_TSOBSM		0xF296
+#define	F367_OFDM_TSFIFO_OBSDATA_HI		0xF29600FF
+
+/* TSOBSL */
+#define	R367_OFDM_TSOBSL		0xF297
+#define	F367_OFDM_TSFIFO_OBSDATA_LO		0xF29700FF
+
+/* ERRCTRL1 */
+#define	R367_OFDM_ERRCTRL1		0xF298
+#define	F367_OFDM_ERR_SRC1		0xF29800F0
+#define	F367_OFDM_ERRCTRL1_3		0xF2980008
+#define	F367_OFDM_NUM_EVT1		0xF2980007
+
+/* ERRCNT1H */
+#define	R367_OFDM_ERRCNT1H		0xF299
+#define	F367_OFDM_ERRCNT1_OLDVALUE		0xF2990080
+#define	F367_OFDM_ERR_CNT1		0xF299007F
+
+/* ERRCNT1M */
+#define	R367_OFDM_ERRCNT1M		0xF29A
+#define	F367_OFDM_ERR_CNT1_HI		0xF29A00FF
+
+/* ERRCNT1L */
+#define	R367_OFDM_ERRCNT1L		0xF29B
+#define	F367_OFDM_ERR_CNT1_LO		0xF29B00FF
+
+/* ERRCTRL2 */
+#define	R367_OFDM_ERRCTRL2		0xF29C
+#define	F367_OFDM_ERR_SRC2		0xF29C00F0
+#define	F367_OFDM_ERRCTRL2_3		0xF29C0008
+#define	F367_OFDM_NUM_EVT2		0xF29C0007
+
+/* ERRCNT2H */
+#define	R367_OFDM_ERRCNT2H		0xF29D
+#define	F367_OFDM_ERRCNT2_OLDVALUE		0xF29D0080
+#define	F367_OFDM_ERR_CNT2_HI		0xF29D007F
+
+/* ERRCNT2M */
+#define	R367_OFDM_ERRCNT2M		0xF29E
+#define	F367_OFDM_ERR_CNT2_MED		0xF29E00FF
+
+/* ERRCNT2L */
+#define	R367_OFDM_ERRCNT2L		0xF29F
+#define	F367_OFDM_ERR_CNT2_LO		0xF29F00FF
+
+/* FECSPY */
+#define	R367_OFDM_FECSPY		0xF2A0
+#define	F367_OFDM_SPY_ENABLE		0xF2A00080
+#define	F367_OFDM_NO_SYNCBYTE		0xF2A00040
+#define	F367_OFDM_SERIAL_MODE		0xF2A00020
+#define	F367_OFDM_UNUSUAL_PACKET		0xF2A00010
+#define	F367_OFDM_BERMETER_DATAMODE		0xF2A0000C
+#define	F367_OFDM_BERMETER_LMODE		0xF2A00002
+#define	F367_OFDM_BERMETER_RESET		0xF2A00001
+
+/* FSPYCFG */
+#define	R367_OFDM_FSPYCFG		0xF2A1
+#define	F367_OFDM_FECSPY_INPUT		0xF2A100C0
+#define	F367_OFDM_RST_ON_ERROR		0xF2A10020
+#define	F367_OFDM_ONE_SHOT		0xF2A10010
+#define	F367_OFDM_I2C_MOD		0xF2A1000C
+#define	F367_OFDM_SPY_HYSTERESIS		0xF2A10003
+
+/* FSPYDATA */
+#define	R367_OFDM_FSPYDATA		0xF2A2
+#define	F367_OFDM_SPY_STUFFING		0xF2A20080
+#define	F367_OFDM_NOERROR_PKTJITTER		0xF2A20040
+#define	F367_OFDM_SPY_CNULLPKT		0xF2A20020
+#define	F367_OFDM_SPY_OUTDATA_MODE		0xF2A2001F
+
+/* FSPYOUT */
+#define	R367_OFDM_FSPYOUT		0xF2A3
+#define	F367_OFDM_FSPY_DIRECT		0xF2A30080
+#define	F367_OFDM_FSPYOUT_6		0xF2A30040
+#define	F367_OFDM_SPY_OUTDATA_BUS		0xF2A30038
+#define	F367_OFDM_STUFF_MODE		0xF2A30007
+
+/* FSTATUS */
+#define	R367_OFDM_FSTATUS		0xF2A4
+#define	F367_OFDM_SPY_ENDSIM		0xF2A40080
+#define	F367_OFDM_VALID_SIM		0xF2A40040
+#define	F367_OFDM_FOUND_SIGNAL		0xF2A40020
+#define	F367_OFDM_DSS_SYNCBYTE		0xF2A40010
+#define	F367_OFDM_RESULT_STATE		0xF2A4000F
+
+/* FGOODPACK */
+#define	R367_OFDM_FGOODPACK		0xF2A5
+#define	F367_OFDM_FGOOD_PACKET		0xF2A500FF
+
+/* FPACKCNT */
+#define	R367_OFDM_FPACKCNT		0xF2A6
+#define	F367_OFDM_FPACKET_COUNTER		0xF2A600FF
+
+/* FSPYMISC */
+#define	R367_OFDM_FSPYMISC		0xF2A7
+#define	F367_OFDM_FLABEL_COUNTER		0xF2A700FF
+
+/* FBERCPT4 */
+#define	R367_OFDM_FBERCPT4		0xF2A8
+#define	F367_OFDM_FBERMETER_CPT5		0xF2A800FF
+
+/* FBERCPT3 */
+#define	R367_OFDM_FBERCPT3		0xF2A9
+#define	F367_OFDM_FBERMETER_CPT4		0xF2A900FF
+
+/* FBERCPT2 */
+#define	R367_OFDM_FBERCPT2		0xF2AA
+#define	F367_OFDM_FBERMETER_CPT3		0xF2AA00FF
+
+/* FBERCPT1 */
+#define	R367_OFDM_FBERCPT1		0xF2AB
+#define	F367_OFDM_FBERMETER_CPT2		0xF2AB00FF
+
+/* FBERCPT0 */
+#define	R367_OFDM_FBERCPT0		0xF2AC
+#define	F367_OFDM_FBERMETER_CPT1		0xF2AC00FF
+
+/* FBERERR2 */
+#define	R367_OFDM_FBERERR2		0xF2AD
+#define	F367_OFDM_FBERMETER_ERR_HI		0xF2AD00FF
+
+/* FBERERR1 */
+#define	R367_OFDM_FBERERR1		0xF2AE
+#define	F367_OFDM_FBERMETER_ERR_MED		0xF2AE00FF
+
+/* FBERERR0 */
+#define	R367_OFDM_FBERERR0		0xF2AF
+#define	F367_OFDM_FBERMETER_ERR_LO		0xF2AF00FF
+
+/* FSTATESM */
+#define	R367_OFDM_FSTATESM		0xF2B0
+#define	F367_OFDM_RSTATE_F		0xF2B00080
+#define	F367_OFDM_RSTATE_E		0xF2B00040
+#define	F367_OFDM_RSTATE_D		0xF2B00020
+#define	F367_OFDM_RSTATE_C		0xF2B00010
+#define	F367_OFDM_RSTATE_B		0xF2B00008
+#define	F367_OFDM_RSTATE_A		0xF2B00004
+#define	F367_OFDM_RSTATE_9		0xF2B00002
+#define	F367_OFDM_RSTATE_8		0xF2B00001
+
+/* FSTATESL */
+#define	R367_OFDM_FSTATESL		0xF2B1
+#define	F367_OFDM_RSTATE_7		0xF2B10080
+#define	F367_OFDM_RSTATE_6		0xF2B10040
+#define	F367_OFDM_RSTATE_5		0xF2B10020
+#define	F367_OFDM_RSTATE_4		0xF2B10010
+#define	F367_OFDM_RSTATE_3		0xF2B10008
+#define	F367_OFDM_RSTATE_2		0xF2B10004
+#define	F367_OFDM_RSTATE_1		0xF2B10002
+#define	F367_OFDM_RSTATE_0		0xF2B10001
+
+/* FSPYBER */
+#define	R367_OFDM_FSPYBER		0xF2B2
+#define	F367_OFDM_FSPYBER_7		0xF2B20080
+#define	F367_OFDM_FSPYOBS_XORREAD		0xF2B20040
+#define	F367_OFDM_FSPYBER_OBSMODE		0xF2B20020
+#define	F367_OFDM_FSPYBER_SYNCBYTE		0xF2B20010
+#define	F367_OFDM_FSPYBER_UNSYNC		0xF2B20008
+#define	F367_OFDM_FSPYBER_CTIME		0xF2B20007
+
+/* FSPYDISTM */
+#define	R367_OFDM_FSPYDISTM		0xF2B3
+#define	F367_OFDM_PKTTIME_DISTANCE_HI		0xF2B300FF
+
+/* FSPYDISTL */
+#define	R367_OFDM_FSPYDISTL		0xF2B4
+#define	F367_OFDM_PKTTIME_DISTANCE_LO		0xF2B400FF
+
+/* FSPYOBS7 */
+#define	R367_OFDM_FSPYOBS7		0xF2B8
+#define	F367_OFDM_FSPYOBS_SPYFAIL		0xF2B80080
+#define	F367_OFDM_FSPYOBS_SPYFAIL1		0xF2B80040
+#define	F367_OFDM_FSPYOBS_ERROR		0xF2B80020
+#define	F367_OFDM_FSPYOBS_STROUT		0xF2B80010
+#define	F367_OFDM_FSPYOBS_RESULTSTATE1		0xF2B8000F
+
+/* FSPYOBS6 */
+#define	R367_OFDM_FSPYOBS6		0xF2B9
+#define	F367_OFDM_FSPYOBS_RESULTSTATE0		0xF2B900F0
+#define	F367_OFDM_FSPYOBS_RESULTSTATEM1		0xF2B9000F
+
+/* FSPYOBS5 */
+#define	R367_OFDM_FSPYOBS5		0xF2BA
+#define	F367_OFDM_FSPYOBS_BYTEOFPACKET1		0xF2BA00FF
+
+/* FSPYOBS4 */
+#define	R367_OFDM_FSPYOBS4		0xF2BB
+#define	F367_OFDM_FSPYOBS_BYTEVALUE1		0xF2BB00FF
+
+/* FSPYOBS3 */
+#define	R367_OFDM_FSPYOBS3		0xF2BC
+#define	F367_OFDM_FSPYOBS_DATA1		0xF2BC00FF
+
+/* FSPYOBS2 */
+#define	R367_OFDM_FSPYOBS2		0xF2BD
+#define	F367_OFDM_FSPYOBS_DATA0		0xF2BD00FF
+
+/* FSPYOBS1 */
+#define	R367_OFDM_FSPYOBS1		0xF2BE
+#define	F367_OFDM_FSPYOBS_DATAM1		0xF2BE00FF
+
+/* FSPYOBS0 */
+#define	R367_OFDM_FSPYOBS0		0xF2BF
+#define	F367_OFDM_FSPYOBS_DATAM2		0xF2BF00FF
+
+/* SFDEMAP */
+#define	R367_OFDM_SFDEMAP		0xF2C0
+#define	F367_OFDM_SFDEMAP_7		0xF2C00080
+#define	F367_OFDM_SFEC_K_DIVIDER_VIT		0xF2C0007F
+
+/* SFERROR */
+#define	R367_OFDM_SFERROR		0xF2C1
+#define	F367_OFDM_SFEC_REGERR_VIT		0xF2C100FF
+
+/* SFAVSR */
+#define	R367_OFDM_SFAVSR		0xF2C2
+#define	F367_OFDM_SFEC_SUMERRORS		0xF2C20080
+#define	F367_OFDM_SERROR_MAXMODE		0xF2C20040
+#define	F367_OFDM_SN_SFEC		0xF2C20030
+#define	F367_OFDM_KDIV_MODE_SFEC		0xF2C2000C
+#define	F367_OFDM_SFAVSR_1		0xF2C20002
+#define	F367_OFDM_SFAVSR_0		0xF2C20001
+
+/* SFECSTATUS */
+#define	R367_OFDM_SFECSTATUS		0xF2C3
+#define	F367_OFDM_SFEC_ON		0xF2C30080
+#define	F367_OFDM_SFSTATUS_6		0xF2C30040
+#define	F367_OFDM_SFSTATUS_5		0xF2C30020
+#define	F367_OFDM_SFSTATUS_4		0xF2C30010
+#define	F367_OFDM_LOCKEDSFEC		0xF2C30008
+#define	F367_OFDM_SFEC_DELOCK		0xF2C30004
+#define	F367_OFDM_SFEC_DEMODSEL1		0xF2C30002
+#define	F367_OFDM_SFEC_OVFON		0xF2C30001
+
+/* SFKDIV12 */
+#define	R367_OFDM_SFKDIV12		0xF2C4
+#define	F367_OFDM_SFECKDIV12_MAN		0xF2C40080
+#define	F367_OFDM_SFEC_K_DIVIDER_12		0xF2C4007F
+
+/* SFKDIV23 */
+#define	R367_OFDM_SFKDIV23		0xF2C5
+#define	F367_OFDM_SFECKDIV23_MAN		0xF2C50080
+#define	F367_OFDM_SFEC_K_DIVIDER_23		0xF2C5007F
+
+/* SFKDIV34 */
+#define	R367_OFDM_SFKDIV34		0xF2C6
+#define	F367_OFDM_SFECKDIV34_MAN		0xF2C60080
+#define	F367_OFDM_SFEC_K_DIVIDER_34		0xF2C6007F
+
+/* SFKDIV56 */
+#define	R367_OFDM_SFKDIV56		0xF2C7
+#define	F367_OFDM_SFECKDIV56_MAN		0xF2C70080
+#define	F367_OFDM_SFEC_K_DIVIDER_56		0xF2C7007F
+
+/* SFKDIV67 */
+#define	R367_OFDM_SFKDIV67		0xF2C8
+#define	F367_OFDM_SFECKDIV67_MAN		0xF2C80080
+#define	F367_OFDM_SFEC_K_DIVIDER_67		0xF2C8007F
+
+/* SFKDIV78 */
+#define	R367_OFDM_SFKDIV78		0xF2C9
+#define	F367_OFDM_SFECKDIV78_MAN		0xF2C90080
+#define	F367_OFDM_SFEC_K_DIVIDER_78		0xF2C9007F
+
+/* SFDILSTKM */
+#define	R367_OFDM_SFDILSTKM		0xF2CA
+#define	F367_OFDM_SFEC_PACKCPT		0xF2CA00E0
+#define	F367_OFDM_SFEC_DILSTK_HI		0xF2CA001F
+
+/* SFDILSTKL */
+#define	R367_OFDM_SFDILSTKL		0xF2CB
+#define	F367_OFDM_SFEC_DILSTK_LO		0xF2CB00FF
+
+/* SFSTATUS */
+#define	R367_OFDM_SFSTATUS		0xF2CC
+#define	F367_OFDM_SFEC_LINEOK		0xF2CC0080
+#define	F367_OFDM_SFEC_ERROR		0xF2CC0040
+#define	F367_OFDM_SFEC_DATA7		0xF2CC0020
+#define	F367_OFDM_SFEC_OVERFLOW		0xF2CC0010
+#define	F367_OFDM_SFEC_DEMODSEL2		0xF2CC0008
+#define	F367_OFDM_SFEC_NOSYNC		0xF2CC0004
+#define	F367_OFDM_SFEC_UNREGULA		0xF2CC0002
+#define	F367_OFDM_SFEC_READY		0xF2CC0001
+
+/* SFDLYH */
+#define	R367_OFDM_SFDLYH		0xF2CD
+#define	F367_OFDM_SFEC_TSTIMEVALID		0xF2CD0080
+#define	F367_OFDM_SFEC_SPEEDUP		0xF2CD0040
+#define	F367_OFDM_SFEC_STOP		0xF2CD0020
+#define	F367_OFDM_SFEC_REGULATED		0xF2CD0010
+#define	F367_OFDM_SFEC_REALSYMBOFFSET		0xF2CD000F
+
+/* SFDLYM */
+#define	R367_OFDM_SFDLYM		0xF2CE
+#define	F367_OFDM_SFEC_REALSYMBOFFSET_HI		0xF2CE00FF
+
+/* SFDLYL */
+#define	R367_OFDM_SFDLYL		0xF2CF
+#define	F367_OFDM_SFEC_REALSYMBOFFSET_LO		0xF2CF00FF
+
+/* SFDLYSETH */
+#define	R367_OFDM_SFDLYSETH		0xF2D0
+#define	F367_OFDM_SFEC_OFFSET		0xF2D000E0
+#define	F367_OFDM_SFECDLYSETH_4		0xF2D00010
+#define	F367_OFDM_RST_SFEC		0xF2D00008
+#define	F367_OFDM_SFECDLYSETH_2		0xF2D00004
+#define	F367_OFDM_SFEC_DISABLE		0xF2D00002
+#define	F367_OFDM_SFEC_UNREGUL		0xF2D00001
+
+/* SFDLYSETM */
+#define	R367_OFDM_SFDLYSETM		0xF2D1
+#define	F367_OFDM_SFECDLYSETM_7		0xF2D10080
+#define	F367_OFDM_SFEC_SYMBOFFSET_HI		0xF2D1007F
+
+/* SFDLYSETL */
+#define	R367_OFDM_SFDLYSETL		0xF2D2
+#define	F367_OFDM_SFEC_SYMBOFFSET_LO		0xF2D200FF
+
+/* SFOBSCFG */
+#define	R367_OFDM_SFOBSCFG		0xF2D3
+#define	F367_OFDM_SFEC_OBSCFG		0xF2D300FF
+
+/* SFOBSM */
+#define	R367_OFDM_SFOBSM		0xF2D4
+#define	F367_OFDM_SFEC_OBSDATA_HI		0xF2D400FF
+
+/* SFOBSL */
+#define	R367_OFDM_SFOBSL		0xF2D5
+#define	F367_OFDM_SFEC_OBSDATA_LO		0xF2D500FF
+
+/* SFECINFO */
+#define	R367_OFDM_SFECINFO		0xF2D6
+#define	F367_OFDM_SFECINFO_7		0xF2D60080
+#define	F367_OFDM_SFEC_SYNCDLSB		0xF2D60070
+#define	F367_OFDM_SFCE_S1CPHASE		0xF2D6000F
+
+/* SFERRCTRL */
+#define	R367_OFDM_SFERRCTRL		0xF2D8
+#define	F367_OFDM_SFEC_ERR_SOURCE		0xF2D800F0
+#define	F367_OFDM_SFERRCTRL_3		0xF2D80008
+#define	F367_OFDM_SFEC_NUM_EVENT		0xF2D80007
+
+/* SFERRCNTH */
+#define	R367_OFDM_SFERRCNTH		0xF2D9
+#define	F367_OFDM_SFERRC_OLDVALUE		0xF2D90080
+#define	F367_OFDM_SFEC_ERR_CNT		0xF2D9007F
+
+/* SFERRCNTM */
+#define	R367_OFDM_SFERRCNTM		0xF2DA
+#define	F367_OFDM_SFEC_ERR_CNT_HI		0xF2DA00FF
+
+/* SFERRCNTL */
+#define	R367_OFDM_SFERRCNTL		0xF2DB
+#define	F367_OFDM_SFEC_ERR_CNT_LO		0xF2DB00FF
+
+/* SYMBRATEM */
+#define	R367_OFDM_SYMBRATEM		0xF2E0
+#define	F367_OFDM_DEFGEN_SYMBRATE_HI		0xF2E000FF
+
+/* SYMBRATEL */
+#define	R367_OFDM_SYMBRATEL		0xF2E1
+#define	F367_OFDM_DEFGEN_SYMBRATE_LO		0xF2E100FF
+
+/* SYMBSTATUS */
+#define	R367_OFDM_SYMBSTATUS		0xF2E2
+#define	F367_OFDM_SYMBDLINE2_OFF		0xF2E20080
+#define	F367_OFDM_SDDL_REINIT1		0xF2E20040
+#define	F367_OFDM_SDD_REINIT1		0xF2E20020
+#define	F367_OFDM_TOKENID_ERROR		0xF2E20010
+#define	F367_OFDM_SYMBRATE_OVERFLOW		0xF2E20008
+#define	F367_OFDM_SYMBRATE_UNDERFLOW		0xF2E20004
+#define	F367_OFDM_TOKENID_RSTEVENT		0xF2E20002
+#define	F367_OFDM_TOKENID_RESET1		0xF2E20001
+
+/* SYMBCFG */
+#define	R367_OFDM_SYMBCFG		0xF2E3
+#define	F367_OFDM_SYMBCFG_7		0xF2E30080
+#define	F367_OFDM_SYMBCFG_6		0xF2E30040
+#define	F367_OFDM_SYMBCFG_5		0xF2E30020
+#define	F367_OFDM_SYMBCFG_4		0xF2E30010
+#define	F367_OFDM_SYMRATE_FSPEED		0xF2E3000C
+#define	F367_OFDM_SYMRATE_SSPEED		0xF2E30003
+
+/* SYMBFIFOM */
+#define	R367_OFDM_SYMBFIFOM		0xF2E4
+#define	F367_OFDM_SYMBFIFOM_7		0xF2E40080
+#define	F367_OFDM_SYMBFIFOM_6		0xF2E40040
+#define	F367_OFDM_DEFGEN_SYMFIFO_HI		0xF2E4003F
+
+/* SYMBFIFOL */
+#define	R367_OFDM_SYMBFIFOL		0xF2E5
+#define	F367_OFDM_DEFGEN_SYMFIFO_LO		0xF2E500FF
+
+/* SYMBOFFSM */
+#define	R367_OFDM_SYMBOFFSM		0xF2E6
+#define	F367_OFDM_TOKENID_RESET2		0xF2E60080
+#define	F367_OFDM_SDDL_REINIT2		0xF2E60040
+#define	F367_OFDM_SDD_REINIT2		0xF2E60020
+#define	F367_OFDM_SYMBOFFSM_4		0xF2E60010
+#define	F367_OFDM_SYMBOFFSM_3		0xF2E60008
+#define	F367_OFDM_DEFGEN_SYMBOFFSET_HI		0xF2E60007
+
+/* SYMBOFFSL */
+#define	R367_OFDM_SYMBOFFSL		0xF2E7
+#define	F367_OFDM_DEFGEN_SYMBOFFSET_LO		0xF2E700FF
+
+/* DEBUG_LT4 */
+#define	R367_DEBUG_LT4		0xF400
+#define	F367_F_DEBUG_LT4		0xF40000FF
+
+/* DEBUG_LT5 */
+#define	R367_DEBUG_LT5		0xF401
+#define	F367_F_DEBUG_LT5		0xF40100FF
+
+/* DEBUG_LT6 */
+#define	R367_DEBUG_LT6		0xF402
+#define	F367_F_DEBUG_LT6		0xF40200FF
+
+/* DEBUG_LT7 */
+#define	R367_DEBUG_LT7		0xF403
+#define	F367_F_DEBUG_LT7		0xF40300FF
+
+/* DEBUG_LT8 */
+#define	R367_DEBUG_LT8		0xF404
+#define	F367_F_DEBUG_LT8		0xF40400FF
+
+/* DEBUG_LT9 */
+#define	R367_DEBUG_LT9		0xF405
+#define	F367_F_DEBUG_LT9		0xF40500FF
+
+/* CTRL_1 */
+#define	R367_QAM_CTRL_1		0xF402
+#define	F367_QAM_SOFT_RST		0xF4020080
+#define	F367_QAM_EQU_RST		0xF4020008
+#define	F367_QAM_CRL_RST		0xF4020004
+#define	F367_QAM_TRL_RST		0xF4020002
+#define	F367_QAM_AGC_RST		0xF4020001
+
+/* CTRL_2 */
+#define	R367_QAM_CTRL_2		0xF403
+#define	F367_QAM_DEINT_RST		0xF4030008
+#define	F367_QAM_RS_RST		0xF4030004
+
+/* IT_STATUS1 */
+#define	R367_QAM_IT_STATUS1		0xF408
+#define	F367_QAM_SWEEP_OUT		0xF4080080
+#define	F367_QAM_FSM_CRL		0xF4080040
+#define	F367_QAM_CRL_LOCK		0xF4080020
+#define	F367_QAM_MFSM		0xF4080010
+#define	F367_QAM_TRL_LOCK		0xF4080008
+#define	F367_QAM_TRL_AGC_LIMIT		0xF4080004
+#define	F367_QAM_ADJ_AGC_LOCK		0xF4080002
+#define	F367_QAM_AGC_QAM_LOCK		0xF4080001
+
+/* IT_STATUS2 */
+#define	R367_QAM_IT_STATUS2		0xF409
+#define	F367_QAM_TSMF_CNT		0xF4090080
+#define	F367_QAM_TSMF_EOF		0xF4090040
+#define	F367_QAM_TSMF_RDY		0xF4090020
+#define	F367_QAM_FEC_NOCORR		0xF4090010
+#define	F367_QAM_SYNCSTATE		0xF4090008
+#define	F367_QAM_DEINT_LOCK		0xF4090004
+#define	F367_QAM_FADDING_FRZ		0xF4090002
+#define	F367_QAM_TAPMON_ALARM		0xF4090001
+
+/* IT_EN1 */
+#define	R367_QAM_IT_EN1		0xF40A
+#define	F367_QAM_SWEEP_OUTE		0xF40A0080
+#define	F367_QAM_FSM_CRLE		0xF40A0040
+#define	F367_QAM_CRL_LOCKE		0xF40A0020
+#define	F367_QAM_MFSME		0xF40A0010
+#define	F367_QAM_TRL_LOCKE		0xF40A0008
+#define	F367_QAM_TRL_AGC_LIMITE		0xF40A0004
+#define	F367_QAM_ADJ_AGC_LOCKE		0xF40A0002
+#define	F367_QAM_AGC_LOCKE		0xF40A0001
+
+/* IT_EN2 */
+#define	R367_QAM_IT_EN2		0xF40B
+#define	F367_QAM_TSMF_CNTE		0xF40B0080
+#define	F367_QAM_TSMF_EOFE		0xF40B0040
+#define	F367_QAM_TSMF_RDYE		0xF40B0020
+#define	F367_QAM_FEC_NOCORRE		0xF40B0010
+#define	F367_QAM_SYNCSTATEE		0xF40B0008
+#define	F367_QAM_DEINT_LOCKE		0xF40B0004
+#define	F367_QAM_FADDING_FRZE		0xF40B0002
+#define	F367_QAM_TAPMON_ALARME		0xF40B0001
+
+/* CTRL_STATUS */
+#define	R367_QAM_CTRL_STATUS		0xF40C
+#define	F367_QAM_QAMFEC_LOCK		0xF40C0004
+#define	F367_QAM_TSMF_LOCK		0xF40C0002
+#define	F367_QAM_TSMF_ERROR		0xF40C0001
+
+/* TEST_CTL */
+#define	R367_QAM_TEST_CTL		0xF40F
+#define	F367_QAM_TST_BLK_SEL		0xF40F0060
+#define	F367_QAM_TST_BUS_SEL		0xF40F001F
+
+/* AGC_CTL */
+#define	R367_QAM_AGC_CTL		0xF410
+#define	F367_QAM_AGC_LCK_TH		0xF41000F0
+#define	F367_QAM_AGC_ACCUMRSTSEL		0xF4100007
+
+/* AGC_IF_CFG */
+#define	R367_QAM_AGC_IF_CFG		0xF411
+#define	F367_QAM_AGC_IF_BWSEL		0xF41100F0
+#define	F367_QAM_AGC_IF_FREEZE		0xF4110002
+
+/* AGC_RF_CFG */
+#define	R367_QAM_AGC_RF_CFG		0xF412
+#define	F367_QAM_AGC_RF_BWSEL		0xF4120070
+#define	F367_QAM_AGC_RF_FREEZE		0xF4120002
+
+/* AGC_PWM_CFG */
+#define	R367_QAM_AGC_PWM_CFG		0xF413
+#define	F367_QAM_AGC_RF_PWM_TST		0xF4130080
+#define	F367_QAM_AGC_RF_PWM_INV		0xF4130040
+#define	F367_QAM_AGC_IF_PWM_TST		0xF4130008
+#define	F367_QAM_AGC_IF_PWM_INV		0xF4130004
+#define	F367_QAM_AGC_PWM_CLKDIV		0xF4130003
+
+/* AGC_PWR_REF_L */
+#define	R367_QAM_AGC_PWR_REF_L		0xF414
+#define	F367_QAM_AGC_PWRREF_LO		0xF41400FF
+
+/* AGC_PWR_REF_H */
+#define	R367_QAM_AGC_PWR_REF_H		0xF415
+#define	F367_QAM_AGC_PWRREF_HI		0xF4150003
+
+/* AGC_RF_TH_L */
+#define	R367_QAM_AGC_RF_TH_L		0xF416
+#define	F367_QAM_AGC_RF_TH_LO		0xF41600FF
+
+/* AGC_RF_TH_H */
+#define	R367_QAM_AGC_RF_TH_H		0xF417
+#define	F367_QAM_AGC_RF_TH_HI		0xF417000F
+
+/* AGC_IF_LTH_L */
+#define	R367_QAM_AGC_IF_LTH_L		0xF418
+#define	F367_QAM_AGC_IF_THLO_LO		0xF41800FF
+
+/* AGC_IF_LTH_H */
+#define	R367_QAM_AGC_IF_LTH_H		0xF419
+#define	F367_QAM_AGC_IF_THLO_HI		0xF419000F
+
+/* AGC_IF_HTH_L */
+#define	R367_QAM_AGC_IF_HTH_L		0xF41A
+#define	F367_QAM_AGC_IF_THHI_LO		0xF41A00FF
+
+/* AGC_IF_HTH_H */
+#define	R367_QAM_AGC_IF_HTH_H		0xF41B
+#define	F367_QAM_AGC_IF_THHI_HI		0xF41B000F
+
+/* AGC_PWR_RD_L */
+#define	R367_QAM_AGC_PWR_RD_L		0xF41C
+#define	F367_QAM_AGC_PWR_WORD_LO		0xF41C00FF
+
+/* AGC_PWR_RD_M */
+#define	R367_QAM_AGC_PWR_RD_M		0xF41D
+#define	F367_QAM_AGC_PWR_WORD_ME		0xF41D00FF
+
+/* AGC_PWR_RD_H */
+#define	R367_QAM_AGC_PWR_RD_H		0xF41E
+#define	F367_QAM_AGC_PWR_WORD_HI		0xF41E0003
+
+/* AGC_PWM_IFCMD_L */
+#define	R367_QAM_AGC_PWM_IFCMD_L		0xF420
+#define	F367_QAM_AGC_IF_PWMCMD_LO		0xF42000FF
+
+/* AGC_PWM_IFCMD_H */
+#define	R367_QAM_AGC_PWM_IFCMD_H		0xF421
+#define	F367_QAM_AGC_IF_PWMCMD_HI		0xF421000F
+
+/* AGC_PWM_RFCMD_L */
+#define	R367_QAM_AGC_PWM_RFCMD_L		0xF422
+#define	F367_QAM_AGC_RF_PWMCMD_LO		0xF42200FF
+
+/* AGC_PWM_RFCMD_H */
+#define	R367_QAM_AGC_PWM_RFCMD_H		0xF423
+#define	F367_QAM_AGC_RF_PWMCMD_HI		0xF423000F
+
+/* IQDEM_CFG */
+#define	R367_QAM_IQDEM_CFG		0xF424
+#define	F367_QAM_IQDEM_CLK_SEL		0xF4240004
+#define	F367_QAM_IQDEM_INVIQ		0xF4240002
+#define	F367_QAM_IQDEM_A2DTYPE		0xF4240001
+
+/* MIX_NCO_LL */
+#define	R367_QAM_MIX_NCO_LL		0xF425
+#define	F367_QAM_MIX_NCO_INC_LL		0xF42500FF
+
+/* MIX_NCO_HL */
+#define	R367_QAM_MIX_NCO_HL		0xF426
+#define	F367_QAM_MIX_NCO_INC_HL		0xF42600FF
+
+/* MIX_NCO_HH */
+#define	R367_QAM_MIX_NCO_HH		0xF427
+#define	F367_QAM_MIX_NCO_INVCNST		0xF4270080
+#define	F367_QAM_MIX_NCO_INC_HH		0xF427007F
+
+/* SRC_NCO_LL */
+#define	R367_QAM_SRC_NCO_LL		0xF428
+#define	F367_QAM_SRC_NCO_INC_LL		0xF42800FF
+
+/* SRC_NCO_LH */
+#define	R367_QAM_SRC_NCO_LH		0xF429
+#define	F367_QAM_SRC_NCO_INC_LH		0xF42900FF
+
+/* SRC_NCO_HL */
+#define	R367_QAM_SRC_NCO_HL		0xF42A
+#define	F367_QAM_SRC_NCO_INC_HL		0xF42A00FF
+
+/* SRC_NCO_HH */
+#define	R367_QAM_SRC_NCO_HH		0xF42B
+#define	F367_QAM_SRC_NCO_INC_HH		0xF42B007F
+
+/* IQDEM_GAIN_SRC_L */
+#define	R367_QAM_IQDEM_GAIN_SRC_L		0xF42C
+#define	F367_QAM_GAIN_SRC_LO		0xF42C00FF
+
+/* IQDEM_GAIN_SRC_H */
+#define	R367_QAM_IQDEM_GAIN_SRC_H		0xF42D
+#define	F367_QAM_GAIN_SRC_HI		0xF42D0003
+
+/* IQDEM_DCRM_CFG_LL */
+#define	R367_QAM_IQDEM_DCRM_CFG_LL		0xF430
+#define	F367_QAM_DCRM0_DCIN_L		0xF43000FF
+
+/* IQDEM_DCRM_CFG_LH */
+#define	R367_QAM_IQDEM_DCRM_CFG_LH		0xF431
+#define	F367_QAM_DCRM1_I_DCIN_L		0xF43100FC
+#define	F367_QAM_DCRM0_DCIN_H		0xF4310003
+
+/* IQDEM_DCRM_CFG_HL */
+#define	R367_QAM_IQDEM_DCRM_CFG_HL		0xF432
+#define	F367_QAM_DCRM1_Q_DCIN_L		0xF43200F0
+#define	F367_QAM_DCRM1_I_DCIN_H		0xF432000F
+
+/* IQDEM_DCRM_CFG_HH */
+#define	R367_QAM_IQDEM_DCRM_CFG_HH		0xF433
+#define	F367_QAM_DCRM1_FRZ		0xF4330080
+#define	F367_QAM_DCRM0_FRZ		0xF4330040
+#define	F367_QAM_DCRM1_Q_DCIN_H		0xF433003F
+
+/* IQDEM_ADJ_COEFF0 */
+#define	R367_QAM_IQDEM_ADJ_COEFF0		0xF434
+#define	F367_QAM_ADJIIR_COEFF10_L		0xF43400FF
+
+/* IQDEM_ADJ_COEFF1 */
+#define	R367_QAM_IQDEM_ADJ_COEFF1		0xF435
+#define	F367_QAM_ADJIIR_COEFF11_L		0xF43500FC
+#define	F367_QAM_ADJIIR_COEFF10_H		0xF4350003
+
+/* IQDEM_ADJ_COEFF2 */
+#define	R367_QAM_IQDEM_ADJ_COEFF2		0xF436
+#define	F367_QAM_ADJIIR_COEFF12_L		0xF43600F0
+#define	F367_QAM_ADJIIR_COEFF11_H		0xF436000F
+
+/* IQDEM_ADJ_COEFF3 */
+#define	R367_QAM_IQDEM_ADJ_COEFF3		0xF437
+#define	F367_QAM_ADJIIR_COEFF20_L		0xF43700C0
+#define	F367_QAM_ADJIIR_COEFF12_H		0xF437003F
+
+/* IQDEM_ADJ_COEFF4 */
+#define	R367_QAM_IQDEM_ADJ_COEFF4		0xF438
+#define	F367_QAM_ADJIIR_COEFF20_H		0xF43800FF
+
+/* IQDEM_ADJ_COEFF5 */
+#define	R367_QAM_IQDEM_ADJ_COEFF5		0xF439
+#define	F367_QAM_ADJIIR_COEFF21_L		0xF43900FF
+
+/* IQDEM_ADJ_COEFF6 */
+#define	R367_QAM_IQDEM_ADJ_COEFF6		0xF43A
+#define	F367_QAM_ADJIIR_COEFF22_L		0xF43A00FC
+#define	F367_QAM_ADJIIR_COEFF21_H		0xF43A0003
+
+/* IQDEM_ADJ_COEFF7 */
+#define	R367_QAM_IQDEM_ADJ_COEFF7		0xF43B
+#define	F367_QAM_ADJIIR_COEFF22_H		0xF43B000F
+
+/* IQDEM_ADJ_EN */
+#define	R367_QAM_IQDEM_ADJ_EN		0xF43C
+#define	F367_QAM_ALLPASSFILT_EN		0xF43C0008
+#define	F367_QAM_ADJ_AGC_EN		0xF43C0004
+#define	F367_QAM_ADJ_COEFF_FRZ		0xF43C0002
+#define	F367_QAM_ADJ_EN		0xF43C0001
+
+/* IQDEM_ADJ_AGC_REF */
+#define	R367_QAM_IQDEM_ADJ_AGC_REF		0xF43D
+#define	F367_QAM_ADJ_AGC_REF		0xF43D00FF
+
+/* ALLPASSFILT1 */
+#define	R367_QAM_ALLPASSFILT1		0xF440
+#define	F367_QAM_ALLPASSFILT_COEFF1_LO		0xF44000FF
+
+/* ALLPASSFILT2 */
+#define	R367_QAM_ALLPASSFILT2		0xF441
+#define	F367_QAM_ALLPASSFILT_COEFF1_ME		0xF44100FF
+
+/* ALLPASSFILT3 */
+#define	R367_QAM_ALLPASSFILT3		0xF442
+#define	F367_QAM_ALLPASSFILT_COEFF2_LO		0xF44200C0
+#define	F367_QAM_ALLPASSFILT_COEFF1_HI		0xF442003F
+
+/* ALLPASSFILT4 */
+#define	R367_QAM_ALLPASSFILT4		0xF443
+#define	F367_QAM_ALLPASSFILT_COEFF2_MEL		0xF44300FF
+
+/* ALLPASSFILT5 */
+#define	R367_QAM_ALLPASSFILT5		0xF444
+#define	F367_QAM_ALLPASSFILT_COEFF2_MEH		0xF44400FF
+
+/* ALLPASSFILT6 */
+#define	R367_QAM_ALLPASSFILT6		0xF445
+#define	F367_QAM_ALLPASSFILT_COEFF3_LO		0xF44500F0
+#define	F367_QAM_ALLPASSFILT_COEFF2_HI		0xF445000F
+
+/* ALLPASSFILT7 */
+#define	R367_QAM_ALLPASSFILT7		0xF446
+#define	F367_QAM_ALLPASSFILT_COEFF3_MEL		0xF44600FF
+
+/* ALLPASSFILT8 */
+#define	R367_QAM_ALLPASSFILT8		0xF447
+#define	F367_QAM_ALLPASSFILT_COEFF3_MEH		0xF44700FF
+
+/* ALLPASSFILT9 */
+#define	R367_QAM_ALLPASSFILT9		0xF448
+#define	F367_QAM_ALLPASSFILT_COEFF4_LO		0xF44800FC
+#define	F367_QAM_ALLPASSFILT_COEFF3_HI		0xF4480003
+
+/* ALLPASSFILT10 */
+#define	R367_QAM_ALLPASSFILT10		0xF449
+#define	F367_QAM_ALLPASSFILT_COEFF4_ME		0xF44900FF
+
+/* ALLPASSFILT11 */
+#define	R367_QAM_ALLPASSFILT11		0xF44A
+#define	F367_QAM_ALLPASSFILT_COEFF4_HI		0xF44A00FF
+
+/* TRL_AGC_CFG */
+#define	R367_QAM_TRL_AGC_CFG		0xF450
+#define	F367_QAM_TRL_AGC_FREEZE		0xF4500080
+#define	F367_QAM_TRL_AGC_REF		0xF450007F
+
+/* TRL_LPF_CFG */
+#define	R367_QAM_TRL_LPF_CFG		0xF454
+#define	F367_QAM_NYQPOINT_INV		0xF4540040
+#define	F367_QAM_TRL_SHIFT		0xF4540030
+#define	F367_QAM_NYQ_COEFF_SEL		0xF454000C
+#define	F367_QAM_TRL_LPF_FREEZE		0xF4540002
+#define	F367_QAM_TRL_LPF_CRT		0xF4540001
+
+/* TRL_LPF_ACQ_GAIN */
+#define	R367_QAM_TRL_LPF_ACQ_GAIN		0xF455
+#define	F367_QAM_TRL_GDIR_ACQ		0xF4550070
+#define	F367_QAM_TRL_GINT_ACQ		0xF4550007
+
+/* TRL_LPF_TRK_GAIN */
+#define	R367_QAM_TRL_LPF_TRK_GAIN		0xF456
+#define	F367_QAM_TRL_GDIR_TRK		0xF4560070
+#define	F367_QAM_TRL_GINT_TRK		0xF4560007
+
+/* TRL_LPF_OUT_GAIN */
+#define	R367_QAM_TRL_LPF_OUT_GAIN		0xF457
+#define	F367_QAM_TRL_GAIN_OUT		0xF4570007
+
+/* TRL_LOCKDET_LTH */
+#define	R367_QAM_TRL_LOCKDET_LTH		0xF458
+#define	F367_QAM_TRL_LCK_THLO		0xF4580007
+
+/* TRL_LOCKDET_HTH */
+#define	R367_QAM_TRL_LOCKDET_HTH		0xF459
+#define	F367_QAM_TRL_LCK_THHI		0xF45900FF
+
+/* TRL_LOCKDET_TRGVAL */
+#define	R367_QAM_TRL_LOCKDET_TRGVAL		0xF45A
+#define	F367_QAM_TRL_LCK_TRG		0xF45A00FF
+
+/* IQ_QAM */
+#define	R367_QAM_IQ_QAM		0xF45C
+#define	F367_QAM_IQ_INPUT		0xF45C0008
+#define	F367_QAM_DETECT_MODE		0xF45C0007
+
+/* FSM_STATE */
+#define	R367_QAM_FSM_STATE		0xF460
+#define	F367_QAM_CRL_DFE		0xF4600080
+#define	F367_QAM_DFE_START		0xF4600040
+#define	F367_QAM_CTRLG_START		0xF4600030
+#define	F367_QAM_FSM_FORCESTATE		0xF460000F
+
+/* FSM_CTL */
+#define	R367_QAM_FSM_CTL		0xF461
+#define	F367_QAM_FEC2_EN		0xF4610040
+#define	F367_QAM_SIT_EN		0xF4610020
+#define	F367_QAM_TRL_AHEAD		0xF4610010
+#define	F367_QAM_TRL2_EN		0xF4610008
+#define	F367_QAM_FSM_EQA1_EN		0xF4610004
+#define	F367_QAM_FSM_BKP_DIS		0xF4610002
+#define	F367_QAM_FSM_FORCE_EN		0xF4610001
+
+/* FSM_STS */
+#define	R367_QAM_FSM_STS		0xF462
+#define	F367_QAM_FSM_STATUS		0xF462000F
+
+/* FSM_SNR0_HTH */
+#define	R367_QAM_FSM_SNR0_HTH		0xF463
+#define	F367_QAM_SNR0_HTH		0xF46300FF
+
+/* FSM_SNR1_HTH */
+#define	R367_QAM_FSM_SNR1_HTH		0xF464
+#define	F367_QAM_SNR1_HTH		0xF46400FF
+
+/* FSM_SNR2_HTH */
+#define	R367_QAM_FSM_SNR2_HTH		0xF465
+#define	F367_QAM_SNR2_HTH		0xF46500FF
+
+/* FSM_SNR0_LTH */
+#define	R367_QAM_FSM_SNR0_LTH		0xF466
+#define	F367_QAM_SNR0_LTH		0xF46600FF
+
+/* FSM_SNR1_LTH */
+#define	R367_QAM_FSM_SNR1_LTH		0xF467
+#define	F367_QAM_SNR1_LTH		0xF46700FF
+
+/* FSM_EQA1_HTH */
+#define	R367_QAM_FSM_EQA1_HTH		0xF468
+#define	F367_QAM_SNR3_HTH_LO		0xF46800F0
+#define	F367_QAM_EQA1_HTH		0xF468000F
+
+/* FSM_TEMPO */
+#define	R367_QAM_FSM_TEMPO		0xF469
+#define	F367_QAM_SIT		0xF46900C0
+#define	F367_QAM_WST		0xF4690038
+#define	F367_QAM_ELT		0xF4690006
+#define	F367_QAM_SNR3_HTH_HI		0xF4690001
+
+/* FSM_CONFIG */
+#define	R367_QAM_FSM_CONFIG		0xF46A
+#define	F367_QAM_FEC2_DFEOFF		0xF46A0004
+#define	F367_QAM_PRIT_STATE		0xF46A0002
+#define	F367_QAM_MODMAP_STATE		0xF46A0001
+
+/* EQU_I_TESTTAP_L */
+#define	R367_QAM_EQU_I_TESTTAP_L		0xF474
+#define	F367_QAM_I_TEST_TAP_L		0xF47400FF
+
+/* EQU_I_TESTTAP_M */
+#define	R367_QAM_EQU_I_TESTTAP_M		0xF475
+#define	F367_QAM_I_TEST_TAP_M		0xF47500FF
+
+/* EQU_I_TESTTAP_H */
+#define	R367_QAM_EQU_I_TESTTAP_H		0xF476
+#define	F367_QAM_I_TEST_TAP_H		0xF476001F
+
+/* EQU_TESTAP_CFG */
+#define	R367_QAM_EQU_TESTAP_CFG		0xF477
+#define	F367_QAM_TEST_FFE_DFE_SEL		0xF4770040
+#define	F367_QAM_TEST_TAP_SELECT		0xF477003F
+
+/* EQU_Q_TESTTAP_L */
+#define	R367_QAM_EQU_Q_TESTTAP_L		0xF478
+#define	F367_QAM_Q_TEST_TAP_L		0xF47800FF
+
+/* EQU_Q_TESTTAP_M */
+#define	R367_QAM_EQU_Q_TESTTAP_M		0xF479
+#define	F367_QAM_Q_TEST_TAP_M		0xF47900FF
+
+/* EQU_Q_TESTTAP_H */
+#define	R367_QAM_EQU_Q_TESTTAP_H		0xF47A
+#define	F367_QAM_Q_TEST_TAP_H		0xF47A001F
+
+/* EQU_TAP_CTRL */
+#define	R367_QAM_EQU_TAP_CTRL		0xF47B
+#define	F367_QAM_MTAP_FRZ		0xF47B0010
+#define	F367_QAM_PRE_FREEZE		0xF47B0008
+#define	F367_QAM_DFE_TAPMON_EN		0xF47B0004
+#define	F367_QAM_FFE_TAPMON_EN		0xF47B0002
+#define	F367_QAM_MTAP_ONLY		0xF47B0001
+
+/* EQU_CTR_CRL_CONTROL_L */
+#define	R367_QAM_EQU_CTR_CRL_CONTROL_L		0xF47C
+#define	F367_QAM_EQU_CTR_CRL_CONTROL_LO		0xF47C00FF
+
+/* EQU_CTR_CRL_CONTROL_H */
+#define	R367_QAM_EQU_CTR_CRL_CONTROL_H		0xF47D
+#define	F367_QAM_EQU_CTR_CRL_CONTROL_HI		0xF47D00FF
+
+/* EQU_CTR_HIPOW_L */
+#define	R367_QAM_EQU_CTR_HIPOW_L		0xF47E
+#define	F367_QAM_CTR_HIPOW_L		0xF47E00FF
+
+/* EQU_CTR_HIPOW_H */
+#define	R367_QAM_EQU_CTR_HIPOW_H		0xF47F
+#define	F367_QAM_CTR_HIPOW_H		0xF47F00FF
+
+/* EQU_I_EQU_LO */
+#define	R367_QAM_EQU_I_EQU_LO		0xF480
+#define	F367_QAM_EQU_I_EQU_L		0xF48000FF
+
+/* EQU_I_EQU_HI */
+#define	R367_QAM_EQU_I_EQU_HI		0xF481
+#define	F367_QAM_EQU_I_EQU_H		0xF4810003
+
+/* EQU_Q_EQU_LO */
+#define	R367_QAM_EQU_Q_EQU_LO		0xF482
+#define	F367_QAM_EQU_Q_EQU_L		0xF48200FF
+
+/* EQU_Q_EQU_HI */
+#define	R367_QAM_EQU_Q_EQU_HI		0xF483
+#define	F367_QAM_EQU_Q_EQU_H		0xF4830003
+
+/* EQU_MAPPER */
+#define	R367_QAM_EQU_MAPPER		0xF484
+#define	F367_QAM_QUAD_AUTO		0xF4840080
+#define	F367_QAM_QUAD_INV		0xF4840040
+#define	F367_QAM_QAM_MODE		0xF4840007
+
+/* EQU_SWEEP_RATE */
+#define	R367_QAM_EQU_SWEEP_RATE		0xF485
+#define	F367_QAM_SNR_PER		0xF48500C0
+#define	F367_QAM_SWEEP_RATE		0xF485003F
+
+/* EQU_SNR_LO */
+#define	R367_QAM_EQU_SNR_LO		0xF486
+#define	F367_QAM_SNR_LO		0xF48600FF
+
+/* EQU_SNR_HI */
+#define	R367_QAM_EQU_SNR_HI		0xF487
+#define	F367_QAM_SNR_HI		0xF48700FF
+
+/* EQU_GAMMA_LO */
+#define	R367_QAM_EQU_GAMMA_LO		0xF488
+#define	F367_QAM_GAMMA_LO		0xF48800FF
+
+/* EQU_GAMMA_HI */
+#define	R367_QAM_EQU_GAMMA_HI		0xF489
+#define	F367_QAM_GAMMA_ME		0xF48900FF
+
+/* EQU_ERR_GAIN */
+#define	R367_QAM_EQU_ERR_GAIN		0xF48A
+#define	F367_QAM_EQA1MU		0xF48A0070
+#define	F367_QAM_CRL2MU		0xF48A000E
+#define	F367_QAM_GAMMA_HI		0xF48A0001
+
+/* EQU_RADIUS */
+#define	R367_QAM_EQU_RADIUS		0xF48B
+#define	F367_QAM_RADIUS		0xF48B00FF
+
+/* EQU_FFE_MAINTAP */
+#define	R367_QAM_EQU_FFE_MAINTAP		0xF48C
+#define	F367_QAM_FFE_MAINTAP_INIT		0xF48C00FF
+
+/* EQU_FFE_LEAKAGE */
+#define	R367_QAM_EQU_FFE_LEAKAGE		0xF48E
+#define	F367_QAM_LEAK_PER		0xF48E00F0
+#define	F367_QAM_EQU_OUTSEL		0xF48E0002
+#define	F367_QAM_PNT2DFE		0xF48E0001
+
+/* EQU_FFE_MAINTAP_POS */
+#define	R367_QAM_EQU_FFE_MAINTAP_POS		0xF48F
+#define	F367_QAM_FFE_LEAK_EN		0xF48F0080
+#define	F367_QAM_DFE_LEAK_EN		0xF48F0040
+#define	F367_QAM_FFE_MAINTAP_POS		0xF48F003F
+
+/* EQU_GAIN_WIDE */
+#define	R367_QAM_EQU_GAIN_WIDE		0xF490
+#define	F367_QAM_DFE_GAIN_WIDE		0xF49000F0
+#define	F367_QAM_FFE_GAIN_WIDE		0xF490000F
+
+/* EQU_GAIN_NARROW */
+#define	R367_QAM_EQU_GAIN_NARROW		0xF491
+#define	F367_QAM_DFE_GAIN_NARROW		0xF49100F0
+#define	F367_QAM_FFE_GAIN_NARROW		0xF491000F
+
+/* EQU_CTR_LPF_GAIN */
+#define	R367_QAM_EQU_CTR_LPF_GAIN		0xF492
+#define	F367_QAM_CTR_GTO		0xF4920080
+#define	F367_QAM_CTR_GDIR		0xF4920070
+#define	F367_QAM_SWEEP_EN		0xF4920008
+#define	F367_QAM_CTR_GINT		0xF4920007
+
+/* EQU_CRL_LPF_GAIN */
+#define	R367_QAM_EQU_CRL_LPF_GAIN		0xF493
+#define	F367_QAM_CRL_GTO		0xF4930080
+#define	F367_QAM_CRL_GDIR		0xF4930070
+#define	F367_QAM_SWEEP_DIR		0xF4930008
+#define	F367_QAM_CRL_GINT		0xF4930007
+
+/* EQU_GLOBAL_GAIN */
+#define	R367_QAM_EQU_GLOBAL_GAIN		0xF494
+#define	F367_QAM_CRL_GAIN		0xF49400F8
+#define	F367_QAM_CTR_INC_GAIN		0xF4940004
+#define	F367_QAM_CTR_FRAC		0xF4940003
+
+/* EQU_CRL_LD_SEN */
+#define	R367_QAM_EQU_CRL_LD_SEN		0xF495
+#define	F367_QAM_CTR_BADPOINT_EN		0xF4950080
+#define	F367_QAM_CTR_GAIN		0xF4950070
+#define	F367_QAM_LIMANEN		0xF4950008
+#define	F367_QAM_CRL_LD_SEN		0xF4950007
+
+/* EQU_CRL_LD_VAL */
+#define	R367_QAM_EQU_CRL_LD_VAL		0xF496
+#define	F367_QAM_CRL_BISTH_LIMIT		0xF4960080
+#define	F367_QAM_CARE_EN		0xF4960040
+#define	F367_QAM_CRL_LD_PER		0xF4960030
+#define	F367_QAM_CRL_LD_WST		0xF496000C
+#define	F367_QAM_CRL_LD_TFS		0xF4960003
+
+/* EQU_CRL_TFR */
+#define	R367_QAM_EQU_CRL_TFR		0xF497
+#define	F367_QAM_CRL_LD_TFR		0xF49700FF
+
+/* EQU_CRL_BISTH_LO */
+#define	R367_QAM_EQU_CRL_BISTH_LO		0xF498
+#define	F367_QAM_CRL_BISTH_LO		0xF49800FF
+
+/* EQU_CRL_BISTH_HI */
+#define	R367_QAM_EQU_CRL_BISTH_HI		0xF499
+#define	F367_QAM_CRL_BISTH_HI		0xF49900FF
+
+/* EQU_SWEEP_RANGE_LO */
+#define	R367_QAM_EQU_SWEEP_RANGE_LO		0xF49A
+#define	F367_QAM_SWEEP_RANGE_LO		0xF49A00FF
+
+/* EQU_SWEEP_RANGE_HI */
+#define	R367_QAM_EQU_SWEEP_RANGE_HI		0xF49B
+#define	F367_QAM_SWEEP_RANGE_HI		0xF49B00FF
+
+/* EQU_CRL_LIMITER */
+#define	R367_QAM_EQU_CRL_LIMITER		0xF49C
+#define	F367_QAM_BISECTOR_EN		0xF49C0080
+#define	F367_QAM_PHEST128_EN		0xF49C0040
+#define	F367_QAM_CRL_LIM		0xF49C003F
+
+/* EQU_MODULUS_MAP */
+#define	R367_QAM_EQU_MODULUS_MAP		0xF49D
+#define	F367_QAM_PNT_DEPTH		0xF49D00E0
+#define	F367_QAM_MODULUS_CMP		0xF49D001F
+
+/* EQU_PNT_GAIN */
+#define	R367_QAM_EQU_PNT_GAIN		0xF49E
+#define	F367_QAM_PNT_EN		0xF49E0080
+#define	F367_QAM_MODULUSMAP_EN		0xF49E0040
+#define	F367_QAM_PNT_GAIN		0xF49E003F
+
+/* FEC_AC_CTR_0 */
+#define	R367_QAM_FEC_AC_CTR_0		0xF4A8
+#define	F367_QAM_BE_BYPASS		0xF4A80020
+#define	F367_QAM_REFRESH47		0xF4A80010
+#define	F367_QAM_CT_NBST		0xF4A80008
+#define	F367_QAM_TEI_ENA		0xF4A80004
+#define	F367_QAM_DS_ENA		0xF4A80002
+#define	F367_QAM_TSMF_EN		0xF4A80001
+
+/* FEC_AC_CTR_1 */
+#define	R367_QAM_FEC_AC_CTR_1		0xF4A9
+#define	F367_QAM_DEINT_DEPTH		0xF4A900FF
+
+/* FEC_AC_CTR_2 */
+#define	R367_QAM_FEC_AC_CTR_2		0xF4AA
+#define	F367_QAM_DEINT_M		0xF4AA00F8
+#define	F367_QAM_DIS_UNLOCK		0xF4AA0004
+#define	F367_QAM_DESCR_MODE		0xF4AA0003
+
+/* FEC_AC_CTR_3 */
+#define	R367_QAM_FEC_AC_CTR_3		0xF4AB
+#define	F367_QAM_DI_UNLOCK		0xF4AB0080
+#define	F367_QAM_DI_FREEZE		0xF4AB0040
+#define	F367_QAM_MISMATCH		0xF4AB0030
+#define	F367_QAM_ACQ_MODE		0xF4AB000C
+#define	F367_QAM_TRK_MODE		0xF4AB0003
+
+/* FEC_STATUS */
+#define	R367_QAM_FEC_STATUS		0xF4AC
+#define	F367_QAM_DEINT_SMCNTR		0xF4AC00E0
+#define	F367_QAM_DEINT_SYNCSTATE		0xF4AC0018
+#define	F367_QAM_DEINT_SYNLOST		0xF4AC0004
+#define	F367_QAM_DESCR_SYNCSTATE		0xF4AC0002
+
+/* RS_COUNTER_0 */
+#define	R367_QAM_RS_COUNTER_0		0xF4AE
+#define	F367_QAM_BK_CT_L		0xF4AE00FF
+
+/* RS_COUNTER_1 */
+#define	R367_QAM_RS_COUNTER_1		0xF4AF
+#define	F367_QAM_BK_CT_H		0xF4AF00FF
+
+/* RS_COUNTER_2 */
+#define	R367_QAM_RS_COUNTER_2		0xF4B0
+#define	F367_QAM_CORR_CT_L		0xF4B000FF
+
+/* RS_COUNTER_3 */
+#define	R367_QAM_RS_COUNTER_3		0xF4B1
+#define	F367_QAM_CORR_CT_H		0xF4B100FF
+
+/* RS_COUNTER_4 */
+#define	R367_QAM_RS_COUNTER_4		0xF4B2
+#define	F367_QAM_UNCORR_CT_L		0xF4B200FF
+
+/* RS_COUNTER_5 */
+#define	R367_QAM_RS_COUNTER_5		0xF4B3
+#define	F367_QAM_UNCORR_CT_H		0xF4B300FF
+
+/* BERT_0 */
+#define	R367_QAM_BERT_0		0xF4B4
+#define	F367_QAM_RS_NOCORR		0xF4B40004
+#define	F367_QAM_CT_HOLD		0xF4B40002
+#define	F367_QAM_CT_CLEAR		0xF4B40001
+
+/* BERT_1 */
+#define	R367_QAM_BERT_1		0xF4B5
+#define	F367_QAM_BERT_ON		0xF4B50020
+#define	F367_QAM_BERT_ERR_SRC		0xF4B50010
+#define	F367_QAM_BERT_ERR_MODE		0xF4B50008
+#define	F367_QAM_BERT_NBYTE		0xF4B50007
+
+/* BERT_2 */
+#define	R367_QAM_BERT_2		0xF4B6
+#define	F367_QAM_BERT_ERRCOUNT_L		0xF4B600FF
+
+/* BERT_3 */
+#define	R367_QAM_BERT_3		0xF4B7
+#define	F367_QAM_BERT_ERRCOUNT_H		0xF4B700FF
+
+/* OUTFORMAT_0 */
+#define	R367_QAM_OUTFORMAT_0		0xF4B8
+#define	F367_QAM_CLK_POLARITY		0xF4B80080
+#define	F367_QAM_FEC_TYPE		0xF4B80040
+#define	F367_QAM_SYNC_STRIP		0xF4B80008
+#define	F367_QAM_TS_SWAP		0xF4B80004
+#define	F367_QAM_OUTFORMAT		0xF4B80003
+
+/* OUTFORMAT_1 */
+#define	R367_QAM_OUTFORMAT_1		0xF4B9
+#define	F367_QAM_CI_DIVRANGE		0xF4B900FF
+
+/* SMOOTHER_2 */
+#define	R367_QAM_SMOOTHER_2		0xF4BE
+#define	F367_QAM_FIFO_BYPASS		0xF4BE0020
+
+/* TSMF_CTRL_0 */
+#define	R367_QAM_TSMF_CTRL_0		0xF4C0
+#define	F367_QAM_TS_NUMBER		0xF4C0001E
+#define	F367_QAM_SEL_MODE		0xF4C00001
+
+/* TSMF_CTRL_1 */
+#define	R367_QAM_TSMF_CTRL_1		0xF4C1
+#define	F367_QAM_CHECK_ERROR_BIT		0xF4C10080
+#define	F367_QAM_CHCK_F_SYNC		0xF4C10040
+#define	F367_QAM_H_MODE		0xF4C10008
+#define	F367_QAM_D_V_MODE		0xF4C10004
+#define	F367_QAM_MODE		0xF4C10003
+
+/* TSMF_CTRL_3 */
+#define	R367_QAM_TSMF_CTRL_3		0xF4C3
+#define	F367_QAM_SYNC_IN_COUNT		0xF4C300F0
+#define	F367_QAM_SYNC_OUT_COUNT		0xF4C3000F
+
+/* TS_ON_ID_0 */
+#define	R367_QAM_TS_ON_ID_0		0xF4C4
+#define	F367_QAM_TS_ID_L		0xF4C400FF
+
+/* TS_ON_ID_1 */
+#define	R367_QAM_TS_ON_ID_1		0xF4C5
+#define	F367_QAM_TS_ID_H		0xF4C500FF
+
+/* TS_ON_ID_2 */
+#define	R367_QAM_TS_ON_ID_2		0xF4C6
+#define	F367_QAM_ON_ID_L		0xF4C600FF
+
+/* TS_ON_ID_3 */
+#define	R367_QAM_TS_ON_ID_3		0xF4C7
+#define	F367_QAM_ON_ID_H		0xF4C700FF
+
+/* RE_STATUS_0 */
+#define	R367_QAM_RE_STATUS_0		0xF4C8
+#define	F367_QAM_RECEIVE_STATUS_L		0xF4C800FF
+
+/* RE_STATUS_1 */
+#define	R367_QAM_RE_STATUS_1		0xF4C9
+#define	F367_QAM_RECEIVE_STATUS_LH		0xF4C900FF
+
+/* RE_STATUS_2 */
+#define	R367_QAM_RE_STATUS_2		0xF4CA
+#define	F367_QAM_RECEIVE_STATUS_HL		0xF4CA00FF
+
+/* RE_STATUS_3 */
+#define	R367_QAM_RE_STATUS_3		0xF4CB
+#define	F367_QAM_RECEIVE_STATUS_HH		0xF4CB003F
+
+/* TS_STATUS_0 */
+#define	R367_QAM_TS_STATUS_0		0xF4CC
+#define	F367_QAM_TS_STATUS_L		0xF4CC00FF
+
+/* TS_STATUS_1 */
+#define	R367_QAM_TS_STATUS_1		0xF4CD
+#define	F367_QAM_TS_STATUS_H		0xF4CD007F
+
+/* TS_STATUS_2 */
+#define	R367_QAM_TS_STATUS_2		0xF4CE
+#define	F367_QAM_ERROR		0xF4CE0080
+#define	F367_QAM_EMERGENCY		0xF4CE0040
+#define	F367_QAM_CRE_TS		0xF4CE0030
+#define	F367_QAM_VER		0xF4CE000E
+#define	F367_QAM_M_LOCK		0xF4CE0001
+
+/* TS_STATUS_3 */
+#define	R367_QAM_TS_STATUS_3		0xF4CF
+#define	F367_QAM_UPDATE_READY		0xF4CF0080
+#define	F367_QAM_END_FRAME_HEADER		0xF4CF0040
+#define	F367_QAM_CONTCNT		0xF4CF0020
+#define	F367_QAM_TS_IDENTIFIER_SEL		0xF4CF000F
+
+/* T_O_ID_0 */
+#define	R367_QAM_T_O_ID_0		0xF4D0
+#define	F367_QAM_ON_ID_I_L		0xF4D000FF
+
+/* T_O_ID_1 */
+#define	R367_QAM_T_O_ID_1		0xF4D1
+#define	F367_QAM_ON_ID_I_H		0xF4D100FF
+
+/* T_O_ID_2 */
+#define	R367_QAM_T_O_ID_2		0xF4D2
+#define	F367_QAM_TS_ID_I_L		0xF4D200FF
+
+/* T_O_ID_3 */
+#define	R367_QAM_T_O_ID_3		0xF4D3
+#define	F367_QAM_TS_ID_I_H		0xF4D300FF
+
+#endif
-- 
1.8.4.2
