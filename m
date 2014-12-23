Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40206 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbaLWUue (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 43/66] rtl2832: merge reg page as a part of reg address
Date: Tue, 23 Dec 2014 22:49:36 +0200
Message-Id: <1419367799-14263-43-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chips uses 8-bit register addresses with 5 pages. Extend register
address by using register page as a first byte of address, defining
virtual register addresses. That is common method of handling
register pages and regmap also uses it. Remove page + address
conversion glue which was there for regmap.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 314 +++++++++++++----------------
 drivers/media/dvb-frontends/rtl2832_priv.h |   3 +-
 2 files changed, 144 insertions(+), 173 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 82398d8..202186d 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -25,133 +25,133 @@
 #define REG_MASK(b) (BIT(b + 1) - 1)
 
 static const struct rtl2832_reg_entry registers[] = {
-	[DVBT_SOFT_RST]		= {0x1, 0x1,   2, 2},
-	[DVBT_IIC_REPEAT]	= {0x1, 0x1,   3, 3},
-	[DVBT_TR_WAIT_MIN_8K]	= {0x1, 0x88, 11, 2},
-	[DVBT_RSD_BER_FAIL_VAL]	= {0x1, 0x8f, 15, 0},
-	[DVBT_EN_BK_TRK]	= {0x1, 0xa6,  7, 7},
-	[DVBT_AD_EN_REG]	= {0x0, 0x8,   7, 7},
-	[DVBT_AD_EN_REG1]	= {0x0, 0x8,   6, 6},
-	[DVBT_EN_BBIN]		= {0x1, 0xb1,  0, 0},
-	[DVBT_MGD_THD0]		= {0x1, 0x95,  7, 0},
-	[DVBT_MGD_THD1]		= {0x1, 0x96,  7, 0},
-	[DVBT_MGD_THD2]		= {0x1, 0x97,  7, 0},
-	[DVBT_MGD_THD3]		= {0x1, 0x98,  7, 0},
-	[DVBT_MGD_THD4]		= {0x1, 0x99,  7, 0},
-	[DVBT_MGD_THD5]		= {0x1, 0x9a,  7, 0},
-	[DVBT_MGD_THD6]		= {0x1, 0x9b,  7, 0},
-	[DVBT_MGD_THD7]		= {0x1, 0x9c,  7, 0},
-	[DVBT_EN_CACQ_NOTCH]	= {0x1, 0x61,  4, 4},
-	[DVBT_AD_AV_REF]	= {0x0, 0x9,   6, 0},
-	[DVBT_REG_PI]		= {0x0, 0xa,   2, 0},
-	[DVBT_PIP_ON]		= {0x0, 0x21,  3, 3},
-	[DVBT_SCALE1_B92]	= {0x2, 0x92,  7, 0},
-	[DVBT_SCALE1_B93]	= {0x2, 0x93,  7, 0},
-	[DVBT_SCALE1_BA7]	= {0x2, 0xa7,  7, 0},
-	[DVBT_SCALE1_BA9]	= {0x2, 0xa9,  7, 0},
-	[DVBT_SCALE1_BAA]	= {0x2, 0xaa,  7, 0},
-	[DVBT_SCALE1_BAB]	= {0x2, 0xab,  7, 0},
-	[DVBT_SCALE1_BAC]	= {0x2, 0xac,  7, 0},
-	[DVBT_SCALE1_BB0]	= {0x2, 0xb0,  7, 0},
-	[DVBT_SCALE1_BB1]	= {0x2, 0xb1,  7, 0},
-	[DVBT_KB_P1]		= {0x1, 0x64,  3, 1},
-	[DVBT_KB_P2]		= {0x1, 0x64,  6, 4},
-	[DVBT_KB_P3]		= {0x1, 0x65,  2, 0},
-	[DVBT_OPT_ADC_IQ]	= {0x0, 0x6,   5, 4},
-	[DVBT_AD_AVI]		= {0x0, 0x9,   1, 0},
-	[DVBT_AD_AVQ]		= {0x0, 0x9,   3, 2},
-	[DVBT_K1_CR_STEP12]	= {0x2, 0xad,  9, 4},
-	[DVBT_TRK_KS_P2]	= {0x1, 0x6f,  2, 0},
-	[DVBT_TRK_KS_I2]	= {0x1, 0x70,  5, 3},
-	[DVBT_TR_THD_SET2]	= {0x1, 0x72,  3, 0},
-	[DVBT_TRK_KC_P2]	= {0x1, 0x73,  5, 3},
-	[DVBT_TRK_KC_I2]	= {0x1, 0x75,  2, 0},
-	[DVBT_CR_THD_SET2]	= {0x1, 0x76,  7, 6},
-	[DVBT_PSET_IFFREQ]	= {0x1, 0x19, 21, 0},
-	[DVBT_SPEC_INV]		= {0x1, 0x15,  0, 0},
-	[DVBT_RSAMP_RATIO]	= {0x1, 0x9f, 27, 2},
-	[DVBT_CFREQ_OFF_RATIO]	= {0x1, 0x9d, 23, 4},
-	[DVBT_FSM_STAGE]	= {0x3, 0x51,  6, 3},
-	[DVBT_RX_CONSTEL]	= {0x3, 0x3c,  3, 2},
-	[DVBT_RX_HIER]		= {0x3, 0x3c,  6, 4},
-	[DVBT_RX_C_RATE_LP]	= {0x3, 0x3d,  2, 0},
-	[DVBT_RX_C_RATE_HP]	= {0x3, 0x3d,  5, 3},
-	[DVBT_GI_IDX]		= {0x3, 0x51,  1, 0},
-	[DVBT_FFT_MODE_IDX]	= {0x3, 0x51,  2, 2},
-	[DVBT_RSD_BER_EST]	= {0x3, 0x4e, 15, 0},
-	[DVBT_CE_EST_EVM]	= {0x4, 0xc,  15, 0},
-	[DVBT_RF_AGC_VAL]	= {0x3, 0x5b, 13, 0},
-	[DVBT_IF_AGC_VAL]	= {0x3, 0x59, 13, 0},
-	[DVBT_DAGC_VAL]		= {0x3, 0x5,   7, 0},
-	[DVBT_SFREQ_OFF]	= {0x3, 0x18, 13, 0},
-	[DVBT_CFREQ_OFF]	= {0x3, 0x5f, 17, 0},
-	[DVBT_POLAR_RF_AGC]	= {0x0, 0xe,   1, 1},
-	[DVBT_POLAR_IF_AGC]	= {0x0, 0xe,   0, 0},
-	[DVBT_AAGC_HOLD]	= {0x1, 0x4,   5, 5},
-	[DVBT_EN_RF_AGC]	= {0x1, 0x4,   6, 6},
-	[DVBT_EN_IF_AGC]	= {0x1, 0x4,   7, 7},
-	[DVBT_IF_AGC_MIN]	= {0x1, 0x8,   7, 0},
-	[DVBT_IF_AGC_MAX]	= {0x1, 0x9,   7, 0},
-	[DVBT_RF_AGC_MIN]	= {0x1, 0xa,   7, 0},
-	[DVBT_RF_AGC_MAX]	= {0x1, 0xb,   7, 0},
-	[DVBT_IF_AGC_MAN]	= {0x1, 0xc,   6, 6},
-	[DVBT_IF_AGC_MAN_VAL]	= {0x1, 0xc,  13, 0},
-	[DVBT_RF_AGC_MAN]	= {0x1, 0xe,   6, 6},
-	[DVBT_RF_AGC_MAN_VAL]	= {0x1, 0xe,  13, 0},
-	[DVBT_DAGC_TRG_VAL]	= {0x1, 0x12,  7, 0},
-	[DVBT_AGC_TARG_VAL_0]	= {0x1, 0x2,   0, 0},
-	[DVBT_AGC_TARG_VAL_8_1]	= {0x1, 0x3,   7, 0},
-	[DVBT_AAGC_LOOP_GAIN]	= {0x1, 0xc7,  5, 1},
-	[DVBT_LOOP_GAIN2_3_0]	= {0x1, 0x4,   4, 1},
-	[DVBT_LOOP_GAIN2_4]	= {0x1, 0x5,   7, 7},
-	[DVBT_LOOP_GAIN3]	= {0x1, 0xc8,  4, 0},
-	[DVBT_VTOP1]		= {0x1, 0x6,   5, 0},
-	[DVBT_VTOP2]		= {0x1, 0xc9,  5, 0},
-	[DVBT_VTOP3]		= {0x1, 0xca,  5, 0},
-	[DVBT_KRF1]		= {0x1, 0xcb,  7, 0},
-	[DVBT_KRF2]		= {0x1, 0x7,   7, 0},
-	[DVBT_KRF3]		= {0x1, 0xcd,  7, 0},
-	[DVBT_KRF4]		= {0x1, 0xce,  7, 0},
-	[DVBT_EN_GI_PGA]	= {0x1, 0xe5,  0, 0},
-	[DVBT_THD_LOCK_UP]	= {0x1, 0xd9,  8, 0},
-	[DVBT_THD_LOCK_DW]	= {0x1, 0xdb,  8, 0},
-	[DVBT_THD_UP1]		= {0x1, 0xdd,  7, 0},
-	[DVBT_THD_DW1]		= {0x1, 0xde,  7, 0},
-	[DVBT_INTER_CNT_LEN]	= {0x1, 0xd8,  3, 0},
-	[DVBT_GI_PGA_STATE]	= {0x1, 0xe6,  3, 3},
-	[DVBT_EN_AGC_PGA]	= {0x1, 0xd7,  0, 0},
-	[DVBT_CKOUTPAR]		= {0x1, 0x7b,  5, 5},
-	[DVBT_CKOUT_PWR]	= {0x1, 0x7b,  6, 6},
-	[DVBT_SYNC_DUR]		= {0x1, 0x7b,  7, 7},
-	[DVBT_ERR_DUR]		= {0x1, 0x7c,  0, 0},
-	[DVBT_SYNC_LVL]		= {0x1, 0x7c,  1, 1},
-	[DVBT_ERR_LVL]		= {0x1, 0x7c,  2, 2},
-	[DVBT_VAL_LVL]		= {0x1, 0x7c,  3, 3},
-	[DVBT_SERIAL]		= {0x1, 0x7c,  4, 4},
-	[DVBT_SER_LSB]		= {0x1, 0x7c,  5, 5},
-	[DVBT_CDIV_PH0]		= {0x1, 0x7d,  3, 0},
-	[DVBT_CDIV_PH1]		= {0x1, 0x7d,  7, 4},
-	[DVBT_MPEG_IO_OPT_2_2]	= {0x0, 0x6,   7, 7},
-	[DVBT_MPEG_IO_OPT_1_0]	= {0x0, 0x7,   7, 6},
-	[DVBT_CKOUTPAR_PIP]	= {0x0, 0xb7,  4, 4},
-	[DVBT_CKOUT_PWR_PIP]	= {0x0, 0xb7,  3, 3},
-	[DVBT_SYNC_LVL_PIP]	= {0x0, 0xb7,  2, 2},
-	[DVBT_ERR_LVL_PIP]	= {0x0, 0xb7,  1, 1},
-	[DVBT_VAL_LVL_PIP]	= {0x0, 0xb7,  0, 0},
-	[DVBT_CKOUTPAR_PID]	= {0x0, 0xb9,  4, 4},
-	[DVBT_CKOUT_PWR_PID]	= {0x0, 0xb9,  3, 3},
-	[DVBT_SYNC_LVL_PID]	= {0x0, 0xb9,  2, 2},
-	[DVBT_ERR_LVL_PID]	= {0x0, 0xb9,  1, 1},
-	[DVBT_VAL_LVL_PID]	= {0x0, 0xb9,  0, 0},
-	[DVBT_SM_PASS]		= {0x1, 0x93, 11, 0},
-	[DVBT_AD7_SETTING]	= {0x0, 0x11, 15, 0},
-	[DVBT_RSSI_R]		= {0x3, 0x1,   6, 0},
-	[DVBT_ACI_DET_IND]	= {0x3, 0x12,  0, 0},
-	[DVBT_REG_MON]		= {0x0, 0xd,   1, 0},
-	[DVBT_REG_MONSEL]	= {0x0, 0xd,   2, 2},
-	[DVBT_REG_GPE]		= {0x0, 0xd,   7, 7},
-	[DVBT_REG_GPO]		= {0x0, 0x10,  0, 0},
-	[DVBT_REG_4MSEL]	= {0x0, 0x13,  0, 0},
+	[DVBT_SOFT_RST]		= {0x101,  2, 2},
+	[DVBT_IIC_REPEAT]	= {0x101,  3, 3},
+	[DVBT_TR_WAIT_MIN_8K]	= {0x188, 11, 2},
+	[DVBT_RSD_BER_FAIL_VAL]	= {0x18f, 15, 0},
+	[DVBT_EN_BK_TRK]	= {0x1a6,  7, 7},
+	[DVBT_AD_EN_REG]	= {0x008,  7, 7},
+	[DVBT_AD_EN_REG1]	= {0x008,  6, 6},
+	[DVBT_EN_BBIN]		= {0x1b1,  0, 0},
+	[DVBT_MGD_THD0]		= {0x195,  7, 0},
+	[DVBT_MGD_THD1]		= {0x196,  7, 0},
+	[DVBT_MGD_THD2]		= {0x197,  7, 0},
+	[DVBT_MGD_THD3]		= {0x198,  7, 0},
+	[DVBT_MGD_THD4]		= {0x199,  7, 0},
+	[DVBT_MGD_THD5]		= {0x19a,  7, 0},
+	[DVBT_MGD_THD6]		= {0x19b,  7, 0},
+	[DVBT_MGD_THD7]		= {0x19c,  7, 0},
+	[DVBT_EN_CACQ_NOTCH]	= {0x161,  4, 4},
+	[DVBT_AD_AV_REF]	= {0x009,  6, 0},
+	[DVBT_REG_PI]		= {0x00a,  2, 0},
+	[DVBT_PIP_ON]		= {0x021,  3, 3},
+	[DVBT_SCALE1_B92]	= {0x292,  7, 0},
+	[DVBT_SCALE1_B93]	= {0x293,  7, 0},
+	[DVBT_SCALE1_BA7]	= {0x2a7,  7, 0},
+	[DVBT_SCALE1_BA9]	= {0x2a9,  7, 0},
+	[DVBT_SCALE1_BAA]	= {0x2aa,  7, 0},
+	[DVBT_SCALE1_BAB]	= {0x2ab,  7, 0},
+	[DVBT_SCALE1_BAC]	= {0x2ac,  7, 0},
+	[DVBT_SCALE1_BB0]	= {0x2b0,  7, 0},
+	[DVBT_SCALE1_BB1]	= {0x2b1,  7, 0},
+	[DVBT_KB_P1]		= {0x164,  3, 1},
+	[DVBT_KB_P2]		= {0x164,  6, 4},
+	[DVBT_KB_P3]		= {0x165,  2, 0},
+	[DVBT_OPT_ADC_IQ]	= {0x006,  5, 4},
+	[DVBT_AD_AVI]		= {0x009,  1, 0},
+	[DVBT_AD_AVQ]		= {0x009,  3, 2},
+	[DVBT_K1_CR_STEP12]	= {0x2ad,  9, 4},
+	[DVBT_TRK_KS_P2]	= {0x16f,  2, 0},
+	[DVBT_TRK_KS_I2]	= {0x170,  5, 3},
+	[DVBT_TR_THD_SET2]	= {0x172,  3, 0},
+	[DVBT_TRK_KC_P2]	= {0x173,  5, 3},
+	[DVBT_TRK_KC_I2]	= {0x175,  2, 0},
+	[DVBT_CR_THD_SET2]	= {0x176,  7, 6},
+	[DVBT_PSET_IFFREQ]	= {0x119, 21, 0},
+	[DVBT_SPEC_INV]		= {0x115,  0, 0},
+	[DVBT_RSAMP_RATIO]	= {0x19f, 27, 2},
+	[DVBT_CFREQ_OFF_RATIO]	= {0x19d, 23, 4},
+	[DVBT_FSM_STAGE]	= {0x351,  6, 3},
+	[DVBT_RX_CONSTEL]	= {0x33c,  3, 2},
+	[DVBT_RX_HIER]		= {0x33c,  6, 4},
+	[DVBT_RX_C_RATE_LP]	= {0x33d,  2, 0},
+	[DVBT_RX_C_RATE_HP]	= {0x33d,  5, 3},
+	[DVBT_GI_IDX]		= {0x351,  1, 0},
+	[DVBT_FFT_MODE_IDX]	= {0x351,  2, 2},
+	[DVBT_RSD_BER_EST]	= {0x34e, 15, 0},
+	[DVBT_CE_EST_EVM]	= {0x40c, 15, 0},
+	[DVBT_RF_AGC_VAL]	= {0x35b, 13, 0},
+	[DVBT_IF_AGC_VAL]	= {0x359, 13, 0},
+	[DVBT_DAGC_VAL]		= {0x305,  7, 0},
+	[DVBT_SFREQ_OFF]	= {0x318, 13, 0},
+	[DVBT_CFREQ_OFF]	= {0x35f, 17, 0},
+	[DVBT_POLAR_RF_AGC]	= {0x00e,  1, 1},
+	[DVBT_POLAR_IF_AGC]	= {0x00e,  0, 0},
+	[DVBT_AAGC_HOLD]	= {0x104,  5, 5},
+	[DVBT_EN_RF_AGC]	= {0x104,  6, 6},
+	[DVBT_EN_IF_AGC]	= {0x104,  7, 7},
+	[DVBT_IF_AGC_MIN]	= {0x108,  7, 0},
+	[DVBT_IF_AGC_MAX]	= {0x109,  7, 0},
+	[DVBT_RF_AGC_MIN]	= {0x10a,  7, 0},
+	[DVBT_RF_AGC_MAX]	= {0x10b,  7, 0},
+	[DVBT_IF_AGC_MAN]	= {0x10c,  6, 6},
+	[DVBT_IF_AGC_MAN_VAL]	= {0x10c, 13, 0},
+	[DVBT_RF_AGC_MAN]	= {0x10e,  6, 6},
+	[DVBT_RF_AGC_MAN_VAL]	= {0x10e, 13, 0},
+	[DVBT_DAGC_TRG_VAL]	= {0x112,  7, 0},
+	[DVBT_AGC_TARG_VAL_0]	= {0x102,  0, 0},
+	[DVBT_AGC_TARG_VAL_8_1]	= {0x103,  7, 0},
+	[DVBT_AAGC_LOOP_GAIN]	= {0x1c7,  5, 1},
+	[DVBT_LOOP_GAIN2_3_0]	= {0x104,  4, 1},
+	[DVBT_LOOP_GAIN2_4]	= {0x105,  7, 7},
+	[DVBT_LOOP_GAIN3]	= {0x1c8,  4, 0},
+	[DVBT_VTOP1]		= {0x106,  5, 0},
+	[DVBT_VTOP2]		= {0x1c9,  5, 0},
+	[DVBT_VTOP3]		= {0x1ca,  5, 0},
+	[DVBT_KRF1]		= {0x1cb,  7, 0},
+	[DVBT_KRF2]		= {0x107,  7, 0},
+	[DVBT_KRF3]		= {0x1cd,  7, 0},
+	[DVBT_KRF4]		= {0x1ce,  7, 0},
+	[DVBT_EN_GI_PGA]	= {0x1e5,  0, 0},
+	[DVBT_THD_LOCK_UP]	= {0x1d9,  8, 0},
+	[DVBT_THD_LOCK_DW]	= {0x1db,  8, 0},
+	[DVBT_THD_UP1]		= {0x1dd,  7, 0},
+	[DVBT_THD_DW1]		= {0x1de,  7, 0},
+	[DVBT_INTER_CNT_LEN]	= {0x1d8,  3, 0},
+	[DVBT_GI_PGA_STATE]	= {0x1e6,  3, 3},
+	[DVBT_EN_AGC_PGA]	= {0x1d7,  0, 0},
+	[DVBT_CKOUTPAR]		= {0x17b,  5, 5},
+	[DVBT_CKOUT_PWR]	= {0x17b,  6, 6},
+	[DVBT_SYNC_DUR]		= {0x17b,  7, 7},
+	[DVBT_ERR_DUR]		= {0x17c,  0, 0},
+	[DVBT_SYNC_LVL]		= {0x17c,  1, 1},
+	[DVBT_ERR_LVL]		= {0x17c,  2, 2},
+	[DVBT_VAL_LVL]		= {0x17c,  3, 3},
+	[DVBT_SERIAL]		= {0x17c,  4, 4},
+	[DVBT_SER_LSB]		= {0x17c,  5, 5},
+	[DVBT_CDIV_PH0]		= {0x17d,  3, 0},
+	[DVBT_CDIV_PH1]		= {0x17d,  7, 4},
+	[DVBT_MPEG_IO_OPT_2_2]	= {0x006,  7, 7},
+	[DVBT_MPEG_IO_OPT_1_0]	= {0x007,  7, 6},
+	[DVBT_CKOUTPAR_PIP]	= {0x0b7,  4, 4},
+	[DVBT_CKOUT_PWR_PIP]	= {0x0b7,  3, 3},
+	[DVBT_SYNC_LVL_PIP]	= {0x0b7,  2, 2},
+	[DVBT_ERR_LVL_PIP]	= {0x0b7,  1, 1},
+	[DVBT_VAL_LVL_PIP]	= {0x0b7,  0, 0},
+	[DVBT_CKOUTPAR_PID]	= {0x0b9,  4, 4},
+	[DVBT_CKOUT_PWR_PID]	= {0x0b9,  3, 3},
+	[DVBT_SYNC_LVL_PID]	= {0x0b9,  2, 2},
+	[DVBT_ERR_LVL_PID]	= {0x0b9,  1, 1},
+	[DVBT_VAL_LVL_PID]	= {0x0b9,  0, 0},
+	[DVBT_SM_PASS]		= {0x193, 11, 0},
+	[DVBT_AD7_SETTING]	= {0x011, 15, 0},
+	[DVBT_RSSI_R]		= {0x301,  6, 0},
+	[DVBT_ACI_DET_IND]	= {0x312,  0, 0},
+	[DVBT_REG_MON]		= {0x00d,  1, 0},
+	[DVBT_REG_MONSEL]	= {0x00d,  2, 2},
+	[DVBT_REG_GPE]		= {0x00d,  7, 7},
+	[DVBT_REG_GPO]		= {0x010,  0, 0},
+	[DVBT_REG_4MSEL]	= {0x013,  0, 0},
 };
 
 /* Our regmap is bypassing I2C adapter lock, thus we do it! */
@@ -191,38 +191,13 @@ int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
 	return ret;
 }
 
-/* write multiple registers */
-static int rtl2832_wr_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val, int len)
-{
-	return rtl2832_bulk_write(dev->client, page << 8 | reg, val, len);
-}
-
-/* read multiple registers */
-static int rtl2832_rd_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val, int len)
-{
-	return rtl2832_bulk_read(dev->client, page << 8 | reg, val, len);
-}
-
-/* write single register */
-static int rtl2832_wr_reg(struct rtl2832_dev *dev, u8 reg, u8 page, u8 val)
-{
-	return rtl2832_wr_regs(dev, reg, page, &val, 1);
-}
-
-/* read single register */
-static int rtl2832_rd_reg(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val)
-{
-	return rtl2832_rd_regs(dev, reg, page, val, 1);
-}
-
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
 	struct i2c_client *client = dev->client;
 	int ret;
 
-	u8 reg_start_addr;
+	u16 reg_start_addr;
 	u8 msb, lsb;
-	u8 page;
 	u8 reading[4];
 	u32 reading_tmp;
 	int i;
@@ -233,12 +208,11 @@ static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 	reg_start_addr = registers[reg].start_address;
 	msb = registers[reg].msb;
 	lsb = registers[reg].lsb;
-	page = registers[reg].page;
 
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_rd_regs(dev, reg_start_addr, page, &reading[0], len);
+	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -261,9 +235,8 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	struct i2c_client *client = dev->client;
 	int ret, i;
 	u8 len;
-	u8 reg_start_addr;
+	u16 reg_start_addr;
 	u8 msb, lsb;
-	u8 page;
 	u32 mask;
 
 
@@ -276,13 +249,12 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	reg_start_addr = registers[reg].start_address;
 	msb = registers[reg].msb;
 	lsb = registers[reg].lsb;
-	page = registers[reg].page;
 
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
 
-	ret = rtl2832_rd_regs(dev, reg_start_addr, page, &reading[0], len);
+	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
 
@@ -297,7 +269,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	for (i = 0; i < len; i++)
 		writing[i] = (writing_tmp >> ((len - 1 - i) * 8)) & 0xff;
 
-	ret = rtl2832_wr_regs(dev, reg_start_addr, page, &writing[0], len);
+	ret = rtl2832_bulk_write(client, reg_start_addr, writing, len);
 	if (ret)
 		goto err;
 
@@ -522,7 +494,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* PIP mode related */
-	ret = rtl2832_wr_regs(dev, 0x92, 1, "\x00\x0f\xff", 3);
+	ret = rtl2832_bulk_write(client, 0x192, "\x00\x0f\xff", 3);
 	if (ret)
 		goto err;
 
@@ -560,7 +532,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	}
 
 	for (j = 0; j < sizeof(bw_params[0]); j++) {
-		ret = rtl2832_wr_regs(dev, 0x1c+j, 1, &bw_params[i][j], 1);
+		ret = rtl2832_bulk_write(client, 0x11c + j, &bw_params[i][j], 1);
 		if (ret)
 			goto err;
 	}
@@ -616,11 +588,11 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2832_rd_regs(dev, 0x3c, 3, buf, 2);
+	ret = rtl2832_bulk_read(client, 0x33c, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_rd_reg(dev, 0x51, 3, &buf[2]);
+	ret = rtl2832_bulk_read(client, 0x351, &buf[2], 1);
 	if (ret)
 		goto err;
 
@@ -1103,7 +1075,7 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = rtl2832_wr_regs(dev, 0x0c, 1, "\x5f\xff", 2);
+	ret = rtl2832_bulk_write(client, 0x10c, "\x5f\xff", 2);
 	if (ret)
 		goto err;
 
@@ -1111,23 +1083,23 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_reg(dev, 0xbc, 0, 0x18);
+	ret = rtl2832_bulk_write(client, 0x0bc, "\x18", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_reg(dev, 0x22, 0, 0x01);
+	ret = rtl2832_bulk_write(client, 0x022, "\x01", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_reg(dev, 0x26, 0, 0x1f);
+	ret = rtl2832_bulk_write(client, 0x026, "\x1f", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_reg(dev, 0x27, 0, 0xff);
+	ret = rtl2832_bulk_write(client, 0x027, "\xff", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_regs(dev, 0x92, 1, "\x7f\xf7\xff", 3);
+	ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
 	if (ret)
 		goto err;
 
@@ -1289,7 +1261,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 
 	/* check if the demod is there */
-	ret = rtl2832_rd_reg(dev, 0x00, 0x0, &tmp);
+	ret = rtl2832_bulk_read(client, 0x000, &tmp, 1);
 	if (ret)
 		goto err_i2c_del_mux_adapter;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 216e905..973892a 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -45,8 +45,7 @@ struct rtl2832_dev {
 };
 
 struct rtl2832_reg_entry {
-	u8 page;
-	u8 start_address;
+	u16 start_address;
 	u8 msb;
 	u8 lsb;
 };
-- 
http://palosaari.fi/

