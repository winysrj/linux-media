Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33165 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935940AbdCXSZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:25:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11so2236410wma.0
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 11:25:47 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 11/12] [media] dvb-frontends/stv0367: add Digital Devices compatibility
Date: Fri, 24 Mar 2017 19:24:07 +0100
Message-Id: <20170324182408.25996-12-d.scheller.oss@gmail.com>
In-Reply-To: <20170324182408.25996-1-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This - in conjunction with the previous changes - makes it possible to use
the STV0367 DVB-C/T demodulator driver with Digital Devices hardware having
this demodulator soldered on them (namely CineCTv6 bridges and some earlier
DuoFlex CT addon modules).

The changes do the following:

- add a third *_attach function which will make use of a third frontend_ops
  struct which announces both -C and -T support (the same as with DD's own
  driver stv0367dd). This is necessary to support both delivery systems
  on one FE without having to do large conversions to VB2 or the need to
  select either -C or -T mode via modparams and the like. Additionally,
  the frontend_ops point to new "glue" functions which will then call into
  the existing functionality depending on the active delivery system/demod
  state (all used functionality works almost OOTB).
- Demod initialisation has been ported from stv0367dd. DD's driver always
  does a full init of both OFDM and QAM cores, with some additional things.
  The active delivery system is remembered and upon switch, the Demod will
  be reconfigured to work in OFDM or QAM mode (that's what the ddb_setup_XX
  functions are used for). Note that in QAM mode, the DD demods work with
  an IC speed of 58Mhz. It's not very good to perform full reinits upon
  Demod mode changes since in very rare occasions this can lead to the I2C
  interface or the whole Demod to crash, requiring a powercycle, thus the
  flag to perform full reinit is set to disabled.
- A little enum is added for named identifiers of the current Demod state.

Initialisation code/register writes originate from stv0367dd. Permission
to reuse was formally granted by Ralph Metzler <rjkm@metzlerbros.de>.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 325 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/stv0367.h |  10 ++
 2 files changed, 335 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index ffc046a..77dd76d 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -46,6 +46,8 @@ module_param_named(i2c_debug, i2cdebug, int, 0644);
 	} while (0)
 	/* DVB-C */
 
+enum active_demod_state { demod_none, demod_ter, demod_cab };
+
 struct stv0367cab_state {
 	enum stv0367_cab_signal_type	state;
 	u32	mclk;
@@ -96,6 +98,7 @@ struct stv0367_state {
 	u8 deftabs;
 	u8 reinit_on_setfrontend;
 	u8 auto_if_khz;
+	enum active_demod_state activedemod;
 };
 
 #define RF_LOOKUP_TABLE_SIZE  31
@@ -2880,6 +2883,328 @@ struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 }
 EXPORT_SYMBOL(stv0367cab_attach);
 
+/*
+ * Functions for operation on Digital Devices hardware
+ */
+
+static void stv0367ddb_setup_ter(struct stv0367_state *state)
+{
+	stv0367_writereg(state, R367TER_DEBUG_LT4, 0x00);
+	stv0367_writereg(state, R367TER_DEBUG_LT5, 0x00);
+	stv0367_writereg(state, R367TER_DEBUG_LT6, 0x00); /* R367CAB_CTRL_1 */
+	stv0367_writereg(state, R367TER_DEBUG_LT7, 0x00); /* R367CAB_CTRL_2 */
+	stv0367_writereg(state, R367TER_DEBUG_LT8, 0x00);
+	stv0367_writereg(state, R367TER_DEBUG_LT9, 0x00);
+
+	/* Tuner Setup */
+	/* Buffer Q disabled, I Enabled, unsigned ADC */
+	stv0367_writereg(state, R367TER_ANADIGCTRL, 0x89);
+	stv0367_writereg(state, R367TER_DUAL_AD12, 0x04); /* ADCQ disabled */
+
+	/* Clock setup */
+	/* PLL bypassed and disabled */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x0D);
+	stv0367_writereg(state, R367TER_TOPCTRL, 0x00); /* Set OFDM */
+
+	/* IC runs at 54 MHz with a 27 MHz crystal */
+	stv0367_pll_setup(state, STV0367_ICSPEED_53125, state->config->xtal);
+
+	msleep(50);
+	/* PLL enabled and used */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x00);
+
+	state->activedemod = demod_ter;
+}
+
+static void stv0367ddb_setup_cab(struct stv0367_state *state)
+{
+	stv0367_writereg(state, R367TER_DEBUG_LT4, 0x00);
+	stv0367_writereg(state, R367TER_DEBUG_LT5, 0x01);
+	stv0367_writereg(state, R367TER_DEBUG_LT6, 0x06); /* R367CAB_CTRL_1 */
+	stv0367_writereg(state, R367TER_DEBUG_LT7, 0x03); /* R367CAB_CTRL_2 */
+	stv0367_writereg(state, R367TER_DEBUG_LT8, 0x00);
+	stv0367_writereg(state, R367TER_DEBUG_LT9, 0x00);
+
+	/* Tuner Setup */
+	/* Buffer Q disabled, I Enabled, signed ADC */
+	stv0367_writereg(state, R367TER_ANADIGCTRL, 0x8B);
+	/* ADCQ disabled */
+	stv0367_writereg(state, R367TER_DUAL_AD12, 0x04);
+
+	/* Clock setup */
+	/* PLL bypassed and disabled */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x0D);
+	/* Set QAM */
+	stv0367_writereg(state, R367TER_TOPCTRL, 0x10);
+
+	/* IC runs at 58 MHz with a 27 MHz crystal */
+	stv0367_pll_setup(state, STV0367_ICSPEED_58000, state->config->xtal);
+
+	msleep(50);
+	/* PLL enabled and used */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x00);
+
+	state->cab_state->mclk = stv0367cab_get_mclk(&state->fe,
+		state->config->xtal);
+	state->cab_state->adc_clk = stv0367cab_get_adc_freq(&state->fe,
+		state->config->xtal);
+
+	state->activedemod = demod_cab;
+}
+
+static int stv0367ddb_set_frontend(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	switch (fe->dtv_property_cache.delivery_system) {
+	case SYS_DVBT:
+		if (state->activedemod != demod_ter)
+			stv0367ddb_setup_ter(state);
+
+		return stv0367ter_set_frontend(fe);
+	case SYS_DVBC_ANNEX_A:
+		if (state->activedemod != demod_cab)
+			stv0367ddb_setup_cab(state);
+
+		/* protect against division error oopses */
+		if (fe->dtv_property_cache.symbol_rate == 0) {
+			pr_err("Invalid symbol rate\n");
+			return -EINVAL;
+		}
+
+		return stv0367cab_set_frontend(fe);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
+				   struct dtv_frontend_properties *p)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	switch (state->activedemod) {
+	case demod_ter:
+		return stv0367ter_get_frontend(fe, p);
+	case demod_cab:
+		return stv0367cab_get_frontend(fe, p);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int stv0367ddb_read_status(struct dvb_frontend *fe,
+				  enum fe_status *status)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	switch (state->activedemod) {
+	case demod_ter:
+		return stv0367ter_read_status(fe, status);
+	case demod_cab:
+		return stv0367cab_read_status(fe, status);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int stv0367ddb_sleep(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	switch (state->activedemod) {
+	case demod_ter:
+		state->activedemod = demod_none;
+		return stv0367ter_sleep(fe);
+	case demod_cab:
+		state->activedemod = demod_none;
+		return stv0367cab_sleep(fe);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int stv0367ddb_init(struct stv0367_state *state)
+{
+	struct stv0367ter_state *ter_state = state->ter_state;
+
+	stv0367_writereg(state, R367TER_TOPCTRL, 0x10);
+
+	if (stv0367_deftabs[state->deftabs][STV0367_TAB_BASE])
+		stv0367_write_table(state,
+			stv0367_deftabs[state->deftabs][STV0367_TAB_BASE]);
+
+	stv0367_write_table(state,
+		stv0367_deftabs[state->deftabs][STV0367_TAB_CAB]);
+
+	stv0367_writereg(state, R367TER_TOPCTRL, 0x00);
+	stv0367_write_table(state,
+		stv0367_deftabs[state->deftabs][STV0367_TAB_TER]);
+
+	stv0367_writereg(state, R367TER_GAIN_SRC1, 0x2A);
+	stv0367_writereg(state, R367TER_GAIN_SRC2, 0xD6);
+	stv0367_writereg(state, R367TER_INC_DEROT1, 0x55);
+	stv0367_writereg(state, R367TER_INC_DEROT2, 0x55);
+	stv0367_writereg(state, R367TER_TRL_CTL, 0x14);
+	stv0367_writereg(state, R367TER_TRL_NOMRATE1, 0xAE);
+	stv0367_writereg(state, R367TER_TRL_NOMRATE2, 0x56);
+	stv0367_writereg(state, R367TER_FEPATH_CFG, 0x0);
+
+	/* OFDM TS Setup */
+
+	stv0367_writereg(state, R367TER_TSCFGH, 0x70);
+	stv0367_writereg(state, R367TER_TSCFGM, 0xC0);
+	stv0367_writereg(state, R367TER_TSCFGL, 0x20);
+	stv0367_writereg(state, R367TER_TSSPEED, 0x40); /* Fixed at 54 MHz */
+
+	stv0367_writereg(state, R367TER_TSCFGH, 0x71);
+	stv0367_writereg(state, R367TER_TSCFGH, 0x70);
+
+	stv0367_writereg(state, R367TER_TOPCTRL, 0x10);
+
+	/* Also needed for QAM */
+	stv0367_writereg(state, R367TER_AGC12C, 0x01); /* AGC Pin setup */
+
+	stv0367_writereg(state, R367TER_AGCCTRL1, 0x8A);
+
+	/* QAM TS setup, note exact format also depends on descrambler */
+	/* settings */
+	/* Inverted Clock, Swap, serial */
+	stv0367_writereg(state, R367CAB_OUTFORMAT_0, 0x85);
+
+	/* Clock setup (PLL bypassed and disabled) */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x0D);
+
+	/* IC runs at 58 MHz with a 27 MHz crystal */
+	stv0367_pll_setup(state, STV0367_ICSPEED_58000, state->config->xtal);
+
+	/* Tuner setup */
+	/* Buffer Q disabled, I Enabled, signed ADC */
+	stv0367_writereg(state, R367TER_ANADIGCTRL, 0x8b);
+	stv0367_writereg(state, R367TER_DUAL_AD12, 0x04); /* ADCQ disabled */
+
+	/* Improves the C/N lock limit */
+	stv0367_writereg(state, R367CAB_FSM_SNR2_HTH, 0x23);
+	/* ZIF/IF Automatic mode */
+	stv0367_writereg(state, R367CAB_IQ_QAM, 0x01);
+	/* Improving burst noise performances */
+	stv0367_writereg(state, R367CAB_EQU_FFE_LEAKAGE, 0x83);
+	/* Improving ACI performances */
+	stv0367_writereg(state, R367CAB_IQDEM_ADJ_EN, 0x05);
+
+	/* PLL enabled and used */
+	stv0367_writereg(state, R367TER_ANACTRL, 0x00);
+
+	stv0367_writereg(state, R367TER_I2CRPT, (0x08 | ((5 & 0x07) << 4)));
+
+	ter_state->pBER = 0;
+	ter_state->first_lock = 0;
+	ter_state->unlock_counter = 2;
+
+	return 0;
+}
+
+static const struct dvb_frontend_ops stv0367ddb_ops = {
+	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBT },
+	.info = {
+		.name			= "ST STV0367 DDB DVB-C/T",
+		.frequency_min		= 47000000,
+		.frequency_max		= 865000000,
+		.frequency_stepsize	= 166667,
+		.frequency_tolerance	= 0,
+		.symbol_rate_min	= 870000,
+		.symbol_rate_max	= 11700000,
+		.caps = /* DVB-C */
+			0x400 |/* FE_CAN_QAM_4 */
+			FE_CAN_QAM_16 | FE_CAN_QAM_32  |
+			FE_CAN_QAM_64 | FE_CAN_QAM_128 |
+			FE_CAN_QAM_256 | FE_CAN_FEC_AUTO |
+			/* DVB-T */
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_RECOVER |
+			FE_CAN_INVERSION_AUTO |
+			FE_CAN_MUTE_TS
+	},
+	.release = stv0367_release,
+	.sleep = stv0367ddb_sleep,
+	.i2c_gate_ctrl = stv0367cab_gate_ctrl, /* valid for TER and CAB */
+	.set_frontend = stv0367ddb_set_frontend,
+	.get_frontend = stv0367ddb_get_frontend,
+	.get_tune_settings = stv0367_get_tune_settings,
+	.read_status = stv0367ddb_read_status,
+};
+
+struct dvb_frontend *stv0367ddb_attach(const struct stv0367_config *config,
+				   struct i2c_adapter *i2c)
+{
+	struct stv0367_state *state = NULL;
+	struct stv0367ter_state *ter_state = NULL;
+	struct stv0367cab_state *cab_state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct stv0367_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+	ter_state = kzalloc(sizeof(struct stv0367ter_state), GFP_KERNEL);
+	if (ter_state == NULL)
+		goto error;
+	cab_state = kzalloc(sizeof(struct stv0367cab_state), GFP_KERNEL);
+	if (cab_state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->i2c = i2c;
+	state->config = config;
+	state->ter_state = ter_state;
+	cab_state->search_range = 280000;
+	cab_state->qamfec_status_reg = F367CAB_DESCR_SYNCSTATE;
+	state->cab_state = cab_state;
+	state->fe.ops = stv0367ddb_ops;
+	state->fe.demodulator_priv = state;
+	state->chip_id = stv0367_readreg(state, 0xf000);
+
+	/* demod operation options */
+	state->use_i2c_gatectrl = 0;
+	state->deftabs = STV0367_DEFTAB_DDB;
+	state->reinit_on_setfrontend = 0;
+	state->auto_if_khz = 1;
+	state->activedemod = demod_none;
+
+	state->chip_id = stv0367_readreg(state, R367TER_ID);
+
+	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
+
+	/* check if the demod is there */
+	if ((state->chip_id != 0x50) && (state->chip_id != 0x60))
+		goto error;
+
+	dev_info(&i2c->dev, "Found %s with ChipID %02X at adr %02X\n",
+		state->fe.ops.info.name, state->chip_id,
+		config->demod_address);
+
+	stv0367ddb_init(state);
+
+	return &state->fe;
+
+error:
+	kfree(ter_state);
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(stv0367ddb_attach);
+
 MODULE_PARM_DESC(debug, "Set debug");
 MODULE_PARM_DESC(i2c_debug, "Set i2c debug");
 
diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
index aaa0236..8f7a314 100644
--- a/drivers/media/dvb-frontends/stv0367.h
+++ b/drivers/media/dvb-frontends/stv0367.h
@@ -44,6 +44,9 @@ dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 extern struct
 dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 					struct i2c_adapter *i2c);
+extern struct
+dvb_frontend *stv0367ddb_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c);
 #else
 static inline struct
 dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
@@ -59,6 +62,13 @@ dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+static inline struct
+dvb_frontend *stv0367ddb_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
 #endif
 
 #endif
-- 
2.10.2
