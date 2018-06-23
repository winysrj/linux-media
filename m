Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36086 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbeFWPgd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:33 -0400
Received: by mail-wr0-f196.google.com with SMTP id f16-v6so9433032wrm.3
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 15/19] [media] ddbridge/mci: split MaxSX8 specific code off to ddbridge-sx8.c
Date: Sat, 23 Jun 2018 17:36:11 +0200
Message-Id: <20180623153615.27630-16-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Split off all code specific to the MaxSX8 cards to a separate ddbridge-sx8
module and hook it up in the Makefile. This also adds evaluation of the
mci_type to allow for using different attach handling for different cards.
As different cards can implement things differently (ie. support differing
frontend_ops, and have different base structs being put ontop of the
common mci_base struct), this introduces the mci_cfg struct which is
initially used to hold a few specifics to the -sx8 submodule. While at it,
the handling of the i/q mode is adjusted slightly. Besides this and
handling mci_base and sx8_base struct pointers where needed, all code
is copied unmodified from ddbridge-mci.c.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile        |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c |   2 +-
 drivers/media/pci/ddbridge/ddbridge-max.c  |  18 +-
 drivers/media/pci/ddbridge/ddbridge-max.h  |   2 +-
 drivers/media/pci/ddbridge/ddbridge-mci.c  | 408 +------------------------
 drivers/media/pci/ddbridge/ddbridge-mci.h  |  28 +-
 drivers/media/pci/ddbridge/ddbridge-sx8.c  | 474 +++++++++++++++++++++++++++++
 7 files changed, 516 insertions(+), 419 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-sx8.c

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 9b9e35f171b7..5b6d5bbc38af 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -4,7 +4,8 @@
 #
 
 ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-ci.o \
-		ddbridge-hw.o ddbridge-i2c.o ddbridge-max.o ddbridge-mci.o
+		ddbridge-hw.o ddbridge-i2c.o ddbridge-max.o ddbridge-mci.o \
+		ddbridge-sx8.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 67b60da12cf4..c1b982e8e6c9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1593,7 +1593,7 @@ static int dvb_input_attach(struct ddb_input *input)
 			goto err_detach;
 		break;
 	case DDB_TUNER_MCI_SX8:
-		if (ddb_fe_attach_mci(input) < 0)
+		if (ddb_fe_attach_mci(input, port->type) < 0)
 			goto err_detach;
 		break;
 	default:
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index 739e4b444cf4..8da1c7b91577 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -457,21 +457,29 @@ int ddb_fe_attach_mxl5xx(struct ddb_input *input)
 /******************************************************************************/
 /* MAX MCI related functions */
 
-int ddb_fe_attach_mci(struct ddb_input *input)
+int ddb_fe_attach_mci(struct ddb_input *input, u32 type)
 {
 	struct ddb *dev = input->port->dev;
 	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
 	struct ddb_port *port = input->port;
 	struct ddb_link *link = &dev->link[port->lnr];
 	int demod, tuner;
+	struct mci_cfg cfg;
 
 	demod = input->nr;
 	tuner = demod & 3;
-	if (fmode == 3)
-		tuner = 0;
-	dvb->fe = ddb_mci_attach(input, 0, demod, &dvb->set_input);
+	switch (type) {
+	case DDB_TUNER_MCI_SX8:
+		cfg = ddb_max_sx8_cfg;
+		if (fmode == 3)
+			tuner = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	dvb->fe = ddb_mci_attach(input, &cfg, demod, &dvb->set_input);
 	if (!dvb->fe) {
-		dev_err(dev->dev, "No MAXSX8 found!\n");
+		dev_err(dev->dev, "No MCI card found!\n");
 		return -ENODEV;
 	}
 	if (!dvb->set_input) {
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.h b/drivers/media/pci/ddbridge/ddbridge-max.h
index 82efc53baa94..9838c73973b6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -25,6 +25,6 @@
 
 int ddb_lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
 int ddb_fe_attach_mxl5xx(struct ddb_input *input);
-int ddb_fe_attach_mci(struct ddb_input *input);
+int ddb_fe_attach_mci(struct ddb_input *input, u32 type);
 
 #endif /* _DDBRIDGE_MAX_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index a29ff25d9029..97384ae9ad27 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -22,10 +22,6 @@
 
 static LIST_HEAD(mci_list);
 
-static const u32 MCLK = (1550000000 / 12);
-static const u32 MAX_DEMOD_LDPC_BITRATE = (1550000000 / 6);
-static const u32 MAX_LDPC_BITRATE = (720000000);
-
 static int mci_reset(struct mci *state)
 {
 	struct ddb_link *link = state->base->link;
@@ -99,7 +95,7 @@ int ddb_mci_cmd(struct mci *state,
 	mutex_lock(&state->base->mci_lock);
 	stat = _mci_cmd_unlocked(state,
 				 (u32 *)command, sizeof(*command) / sizeof(u32),
-				 (u32 *)result, sizeof(*result) / sizeof(u32));
+				 (u32 *)result,	sizeof(*result) / sizeof(u32));
 	mutex_unlock(&state->base->mci_lock);
 	return stat;
 }
@@ -111,389 +107,6 @@ static void mci_handler(void *priv)
 	complete(&base->completion);
 }
 
-static void release(struct dvb_frontend *fe)
-{
-	struct mci *state = fe->demodulator_priv;
-
-	state->base->count--;
-	if (state->base->count == 0) {
-		list_del(&state->base->mci_list);
-		kfree(state->base);
-	}
-	kfree(state);
-}
-
-static int get_info(struct dvb_frontend *fe)
-{
-	int stat;
-	struct mci *state = fe->demodulator_priv;
-	struct mci_command cmd;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.command = MCI_CMD_GETSIGNALINFO;
-	cmd.demod = state->demod;
-	stat = ddb_mci_cmd(state, &cmd, &state->signal_info);
-	return stat;
-}
-
-static int get_snr(struct dvb_frontend *fe)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-
-	p->cnr.len = 1;
-	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-	p->cnr.stat[0].svalue =
-		(s64)state->signal_info.dvbs2_signal_info.signal_to_noise
-		     * 10;
-	return 0;
-}
-
-static int get_strength(struct dvb_frontend *fe)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	s32 str;
-
-	str = 100000 -
-	      (state->signal_info.dvbs2_signal_info.channel_power
-	       * 10 + 108750);
-	p->strength.len = 1;
-	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
-	p->strength.stat[0].svalue = str;
-	return 0;
-}
-
-static int read_status(struct dvb_frontend *fe, enum fe_status *status)
-{
-	int stat;
-	struct mci *state = fe->demodulator_priv;
-	struct mci_command cmd;
-	struct mci_result res;
-
-	cmd.command = MCI_CMD_GETSTATUS;
-	cmd.demod = state->demod;
-	stat = ddb_mci_cmd(state, &cmd, &res);
-	if (stat)
-		return stat;
-	*status = 0x00;
-	get_info(fe);
-	get_strength(fe);
-	if (res.status == SX8_DEMOD_WAIT_MATYPE)
-		*status = 0x0f;
-	if (res.status == SX8_DEMOD_LOCKED) {
-		*status = 0x1f;
-		get_snr(fe);
-	}
-	return stat;
-}
-
-static int mci_set_tuner(struct dvb_frontend *fe, u32 tuner, u32 on)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct mci_command cmd;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tuner = state->tuner;
-	cmd.command = on ? SX8_CMD_INPUT_ENABLE : SX8_CMD_INPUT_DISABLE;
-	return ddb_mci_cmd(state, &cmd, NULL);
-}
-
-static int stop(struct dvb_frontend *fe)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct mci_command cmd;
-	u32 input = state->tuner;
-
-	memset(&cmd, 0, sizeof(cmd));
-	if (state->demod != DEMOD_UNUSED) {
-		cmd.command = MCI_CMD_STOP;
-		cmd.demod = state->demod;
-		ddb_mci_cmd(state, &cmd, NULL);
-		if (state->base->iq_mode) {
-			cmd.command = MCI_CMD_STOP;
-			cmd.demod = state->demod;
-			cmd.output = 0;
-			ddb_mci_cmd(state, &cmd, NULL);
-			ddb_mci_config(state, SX8_TSCONFIG_MODE_NORMAL);
-		}
-	}
-	mutex_lock(&state->base->tuner_lock);
-	state->base->tuner_use_count[input]--;
-	if (!state->base->tuner_use_count[input])
-		mci_set_tuner(fe, input, 0);
-	if (state->demod < MCI_DEMOD_MAX)
-		state->base->demod_in_use[state->demod] = 0;
-	state->base->used_ldpc_bitrate[state->nr] = 0;
-	state->demod = DEMOD_UNUSED;
-	state->base->assigned_demod[state->nr] = DEMOD_UNUSED;
-	state->base->iq_mode = 0;
-	mutex_unlock(&state->base->tuner_lock);
-	state->started = 0;
-	return 0;
-}
-
-static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 used_ldpc_bitrate = 0, free_ldpc_bitrate;
-	u32 used_demods = 0;
-	struct mci_command cmd;
-	u32 input = state->tuner;
-	u32 bits_per_symbol = 0;
-	int i, stat = 0;
-
-	if (p->symbol_rate >= (MCLK / 2))
-		flags &= ~1;
-	if ((flags & 3) == 0)
-		return -EINVAL;
-
-	if (flags & 2) {
-		u32 tmp = modmask;
-
-		bits_per_symbol = 1;
-		while (tmp & 1) {
-			tmp >>= 1;
-			bits_per_symbol++;
-		}
-	}
-
-	mutex_lock(&state->base->tuner_lock);
-	if (state->base->iq_mode) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	for (i = 0; i < MCI_DEMOD_MAX; i++) {
-		used_ldpc_bitrate += state->base->used_ldpc_bitrate[i];
-		if (state->base->demod_in_use[i])
-			used_demods++;
-	}
-	if (used_ldpc_bitrate >= MAX_LDPC_BITRATE ||
-	    ((ts_config & SX8_TSCONFIG_MODE_MASK) >
-	     SX8_TSCONFIG_MODE_NORMAL && used_demods > 0)) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	free_ldpc_bitrate = MAX_LDPC_BITRATE - used_ldpc_bitrate;
-	if (free_ldpc_bitrate > MAX_DEMOD_LDPC_BITRATE)
-		free_ldpc_bitrate = MAX_DEMOD_LDPC_BITRATE;
-
-	while (p->symbol_rate * bits_per_symbol > free_ldpc_bitrate)
-		bits_per_symbol--;
-
-	if (bits_per_symbol < 2) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	i = (p->symbol_rate > (MCLK / 2)) ? 3 : 7;
-	while (i >= 0 && state->base->demod_in_use[i])
-		i--;
-	if (i < 0) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	state->base->demod_in_use[i] = 1;
-	state->base->used_ldpc_bitrate[state->nr] = p->symbol_rate
-						    * bits_per_symbol;
-	state->demod = i;
-	state->base->assigned_demod[state->nr] = i;
-
-	if (!state->base->tuner_use_count[input])
-		mci_set_tuner(fe, input, 1);
-	state->base->tuner_use_count[input]++;
-	state->base->iq_mode = (ts_config > 1);
-unlock:
-	mutex_unlock(&state->base->tuner_lock);
-	if (stat)
-		return stat;
-	memset(&cmd, 0, sizeof(cmd));
-
-	if (state->base->iq_mode) {
-		cmd.command = SX8_CMD_ENABLE_IQOUTPUT;
-		cmd.demod = state->demod;
-		cmd.output = 0;
-		ddb_mci_cmd(state, &cmd, NULL);
-		ddb_mci_config(state, ts_config);
-	}
-	if (p->stream_id != NO_STREAM_ID_FILTER && p->stream_id != 0x80000000)
-		flags |= 0x80;
-	dev_dbg(state->base->dev, "MCI-%d: tuner=%d demod=%d\n",
-		state->nr, state->tuner, state->demod);
-	cmd.command = MCI_CMD_SEARCH_DVBS;
-	cmd.dvbs2_search.flags = flags;
-	cmd.dvbs2_search.s2_modulation_mask =
-		modmask & ((1 << (bits_per_symbol - 1)) - 1);
-	cmd.dvbs2_search.retry = 2;
-	cmd.dvbs2_search.frequency = p->frequency * 1000;
-	cmd.dvbs2_search.symbol_rate = p->symbol_rate;
-	cmd.dvbs2_search.scrambling_sequence_index =
-		p->scrambling_sequence_index;
-	cmd.dvbs2_search.input_stream_id =
-		(p->stream_id != NO_STREAM_ID_FILTER) ? p->stream_id : 0;
-	cmd.tuner = state->tuner;
-	cmd.demod = state->demod;
-	cmd.output = state->nr;
-	if (p->stream_id == 0x80000000)
-		cmd.output |= 0x80;
-	stat = ddb_mci_cmd(state, &cmd, NULL);
-	if (stat)
-		stop(fe);
-	return stat;
-}
-
-static int start_iq(struct dvb_frontend *fe, u32 ts_config)
-{
-	struct mci *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 used_demods = 0;
-	struct mci_command cmd;
-	u32 input = state->tuner;
-	int i, stat = 0;
-
-	mutex_lock(&state->base->tuner_lock);
-	if (state->base->iq_mode) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	for (i = 0; i < MCI_DEMOD_MAX; i++)
-		if (state->base->demod_in_use[i])
-			used_demods++;
-	if (used_demods > 0) {
-		stat = -EBUSY;
-		goto unlock;
-	}
-	state->demod = 0;
-	state->base->assigned_demod[state->nr] = 0;
-	if (!state->base->tuner_use_count[input])
-		mci_set_tuner(fe, input, 1);
-	state->base->tuner_use_count[input]++;
-	state->base->iq_mode = (ts_config > 1);
-unlock:
-	mutex_unlock(&state->base->tuner_lock);
-	if (stat)
-		return stat;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.command = SX8_CMD_START_IQ;
-	cmd.dvbs2_search.frequency = p->frequency * 1000;
-	cmd.dvbs2_search.symbol_rate = p->symbol_rate;
-	cmd.tuner = state->tuner;
-	cmd.demod = state->demod;
-	cmd.output = 7;
-	ddb_mci_config(state, ts_config);
-	stat = ddb_mci_cmd(state, &cmd, NULL);
-	if (stat)
-		stop(fe);
-	return stat;
-}
-
-static int set_parameters(struct dvb_frontend *fe)
-{
-	int stat = 0;
-	struct mci *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 ts_config, iq_mode = 0, isi;
-
-	if (state->started)
-		stop(fe);
-
-	isi = p->stream_id;
-	if (isi != NO_STREAM_ID_FILTER)
-		iq_mode = (isi & 0x30000000) >> 28;
-
-	switch (iq_mode) {
-	case 1:
-		ts_config = (SX8_TSCONFIG_TSHEADER | SX8_TSCONFIG_MODE_IQ);
-		break;
-	case 2:
-		ts_config = (SX8_TSCONFIG_TSHEADER | SX8_TSCONFIG_MODE_IQ);
-		break;
-	default:
-		ts_config = SX8_TSCONFIG_MODE_NORMAL;
-		break;
-	}
-
-	if (iq_mode != 2) {
-		u32 flags = 3;
-		u32 mask = 3;
-
-		if (p->modulation == APSK_16 ||
-		    p->modulation == APSK_32) {
-			flags = 2;
-			mask = 15;
-		}
-		stat = start(fe, flags, mask, ts_config);
-	} else {
-		stat = start_iq(fe, ts_config);
-	}
-
-	if (!stat) {
-		state->started = 1;
-		state->first_time_lock = 1;
-		state->signal_info.status = SX8_DEMOD_WAIT_SIGNAL;
-	}
-
-	return stat;
-}
-
-static int tune(struct dvb_frontend *fe, bool re_tune,
-		unsigned int mode_flags,
-		unsigned int *delay, enum fe_status *status)
-{
-	int r;
-
-	if (re_tune) {
-		r = set_parameters(fe);
-		if (r)
-			return r;
-	}
-	r = read_status(fe, status);
-	if (r)
-		return r;
-
-	if (*status & FE_HAS_LOCK)
-		return 0;
-	*delay = HZ / 10;
-	return 0;
-}
-
-static enum dvbfe_algo get_algo(struct dvb_frontend *fe)
-{
-	return DVBFE_ALGO_HW;
-}
-
-static int set_input(struct dvb_frontend *fe, int input)
-{
-	struct mci *state = fe->demodulator_priv;
-
-	state->tuner = input;
-	dev_dbg(state->base->dev, "MCI-%d: input=%d\n", state->nr, input);
-	return 0;
-}
-
-static struct dvb_frontend_ops mci_ops = {
-	.delsys = { SYS_DVBS, SYS_DVBS2 },
-	.info = {
-		.name			= "Digital Devices MaxSX8 MCI DVB-S/S2/S2X",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
-		.symbol_rate_min	= 100000,
-		.symbol_rate_max	= 100000000,
-		.caps			= FE_CAN_INVERSION_AUTO |
-					  FE_CAN_FEC_AUTO       |
-					  FE_CAN_QPSK           |
-					  FE_CAN_2G_MODULATION  |
-					  FE_CAN_MULTISTREAM,
-	},
-	.get_frontend_algo		= get_algo,
-	.tune				= tune,
-	.release			= release,
-	.read_status			= read_status,
-};
-
 static struct mci_base *match_base(void *key)
 {
 	struct mci_base *p;
@@ -511,8 +124,7 @@ static int probe(struct mci *state)
 }
 
 struct dvb_frontend
-*ddb_mci_attach(struct ddb_input *input,
-		int mci_type, int nr,
+*ddb_mci_attach(struct ddb_input *input, struct mci_cfg *cfg, int nr,
 		int (**fn_set_input)(struct dvb_frontend *fe, int input))
 {
 	struct ddb_port *port = input->port;
@@ -520,9 +132,9 @@ struct dvb_frontend
 	struct ddb_link *link = &dev->link[port->lnr];
 	struct mci_base *base;
 	struct mci *state;
-	void *key = mci_type ? (void *)port : (void *)link;
+	void *key = cfg->type ? (void *)port : (void *)link;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	state = kzalloc(cfg->state_size, GFP_KERNEL);
 	if (!state)
 		return NULL;
 
@@ -531,7 +143,7 @@ struct dvb_frontend
 		base->count++;
 		state->base = base;
 	} else {
-		base = kzalloc(sizeof(*base), GFP_KERNEL);
+		base = kzalloc(cfg->base_size, GFP_KERNEL);
 		if (!base)
 			goto fail;
 		base->key = key;
@@ -548,15 +160,17 @@ struct dvb_frontend
 			goto fail;
 		}
 		list_add(&base->mci_list, &mci_list);
+		if (cfg->base_init)
+			cfg->base_init(base);
 	}
-	state->fe.ops = mci_ops;
+	memcpy(&state->fe.ops, cfg->fe_ops, sizeof(struct dvb_frontend_ops));
 	state->fe.demodulator_priv = state;
 	state->nr = nr;
-	*fn_set_input = set_input;
-
+	*fn_set_input = cfg->set_input;
 	state->tuner = nr;
 	state->demod = nr;
-
+	if (cfg->init)
+		cfg->init(state);
 	return &state->fe;
 fail:
 	kfree(state);
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 14c8b1ee6358..f02bc76e3c98 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -211,18 +211,11 @@ struct mci_base {
 	void                *key;
 	struct ddb_link     *link;
 	struct completion    completion;
-
 	struct device       *dev;
 	struct mutex         tuner_lock; /* concurrent tuner access lock */
-	u8                   adr;
 	struct mutex         mci_lock; /* concurrent MCI access lock */
 	int                  count;
-
-	u8                   tuner_use_count[MCI_TUNER_MAX];
-	u8                   assigned_demod[MCI_DEMOD_MAX];
-	u32                  used_ldpc_bitrate[MCI_DEMOD_MAX];
-	u8                   demod_in_use[MCI_DEMOD_MAX];
-	u32                  iq_mode;
+	int                  type;
 };
 
 struct mci {
@@ -231,20 +224,27 @@ struct mci {
 	int                  nr;
 	int                  demod;
 	int                  tuner;
-	int                  first_time_lock;
-	int                  started;
-	struct mci_result    signal_info;
+};
 
-	u32                  bb_mode;
+struct mci_cfg {
+	int                  type;
+	struct dvb_frontend_ops *fe_ops;
+	u32                  base_size;
+	u32                  state_size;
+	int (*init)(struct mci *mci);
+	int (*base_init)(struct mci_base *mci_base);
+	int (*set_input)(struct dvb_frontend *fe, int input);
 };
 
+/* defined in ddbridge-sx8.c */
+extern const struct mci_cfg ddb_max_sx8_cfg;
+
 int ddb_mci_cmd(struct mci *state, struct mci_command *command,
 		struct mci_result *result);
 int ddb_mci_config(struct mci *state, u32 config);
 
 struct dvb_frontend
-*ddb_mci_attach(struct ddb_input *input,
-		int mci_type, int nr,
+*ddb_mci_attach(struct ddb_input *input, struct mci_cfg *cfg, int nr,
 		int (**fn_set_input)(struct dvb_frontend *fe, int input));
 
 #endif /* _DDBRIDGE_MCI_H_ */
diff --git a/drivers/media/pci/ddbridge/ddbridge-sx8.c b/drivers/media/pci/ddbridge/ddbridge-sx8.c
new file mode 100644
index 000000000000..1a12f2105490
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-sx8.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ddbridge-sx8.c: Digital Devices MAX SX8 driver
+ *
+ * Copyright (C) 2018 Digital Devices GmbH
+ *                    Marcus Metzler <mocm@metzlerbros.de>
+ *                    Ralph Metzler <rjkm@metzlerbros.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "ddbridge.h"
+#include "ddbridge-io.h"
+#include "ddbridge-mci.h"
+
+static const u32 MCLK = (1550000000 / 12);
+static const u32 MAX_LDPC_BITRATE = (720000000);
+static const u32 MAX_DEMOD_LDPC_BITRATE = (1550000000 / 6);
+
+#define SX8_TUNER_NUM 4
+#define SX8_DEMOD_NUM 8
+#define SX8_DEMOD_NONE 0xff
+
+struct sx8_base {
+	struct mci_base      mci_base;
+
+	u8                   tuner_use_count[SX8_TUNER_NUM];
+	u32                  gain_mode[SX8_TUNER_NUM];
+
+	u32                  used_ldpc_bitrate[SX8_DEMOD_NUM];
+	u8                   demod_in_use[SX8_DEMOD_NUM];
+	u32                  iq_mode;
+	u32                  burst_size;
+	u32                  direct_mode;
+};
+
+struct sx8 {
+	struct mci           mci;
+
+	int                  first_time_lock;
+	int                  started;
+	struct mci_result    signal_info;
+
+	u32                  bb_mode;
+	u32                  local_frequency;
+};
+
+static void release(struct dvb_frontend *fe)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+
+	mci_base->count--;
+	if (mci_base->count == 0) {
+		list_del(&mci_base->mci_list);
+		kfree(mci_base);
+	}
+	kfree(state);
+}
+
+static int get_info(struct dvb_frontend *fe)
+{
+	int stat;
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.command = MCI_CMD_GETSIGNALINFO;
+	cmd.demod = state->mci.demod;
+	stat = ddb_mci_cmd(&state->mci, &cmd, &state->signal_info);
+	return stat;
+}
+
+static int get_snr(struct dvb_frontend *fe)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].svalue =
+		(s64)state->signal_info.dvbs2_signal_info.signal_to_noise
+		     * 10;
+	return 0;
+}
+
+static int get_strength(struct dvb_frontend *fe)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	s32 str;
+
+	str = 100000 -
+	      (state->signal_info.dvbs2_signal_info.channel_power
+	       * 10 + 108750);
+	p->strength.len = 1;
+	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	p->strength.stat[0].svalue = str;
+	return 0;
+}
+
+static int read_status(struct dvb_frontend *fe, enum fe_status *status)
+{
+	int stat;
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_command cmd;
+	struct mci_result res;
+
+	cmd.command = MCI_CMD_GETSTATUS;
+	cmd.demod = state->mci.demod;
+	stat = ddb_mci_cmd(&state->mci, &cmd, &res);
+	if (stat)
+		return stat;
+	*status = 0x00;
+	get_info(fe);
+	get_strength(fe);
+	if (res.status == SX8_DEMOD_WAIT_MATYPE)
+		*status = 0x0f;
+	if (res.status == SX8_DEMOD_LOCKED) {
+		*status = 0x1f;
+		get_snr(fe);
+	}
+	return stat;
+}
+
+static int mci_set_tuner(struct dvb_frontend *fe, u32 tuner, u32 on)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+	struct sx8_base *sx8_base = (struct sx8_base *)mci_base;
+	struct mci_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tuner = state->mci.tuner;
+	cmd.command = on ? SX8_CMD_INPUT_ENABLE : SX8_CMD_INPUT_DISABLE;
+	cmd.sx8_input_enable.flags = sx8_base->gain_mode[state->mci.tuner];
+	return ddb_mci_cmd(&state->mci, &cmd, NULL);
+}
+
+static int stop(struct dvb_frontend *fe)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+	struct sx8_base *sx8_base = (struct sx8_base *)mci_base;
+	struct mci_command cmd;
+	u32 input = state->mci.tuner;
+
+	memset(&cmd, 0, sizeof(cmd));
+	if (state->mci.demod != SX8_DEMOD_NONE) {
+		cmd.command = MCI_CMD_STOP;
+		cmd.demod = state->mci.demod;
+		ddb_mci_cmd(&state->mci, &cmd, NULL);
+		if (sx8_base->iq_mode) {
+			cmd.command = SX8_CMD_DISABLE_IQOUTPUT;
+			cmd.demod = state->mci.demod;
+			cmd.output = 0;
+			ddb_mci_cmd(&state->mci, &cmd, NULL);
+			ddb_mci_config(&state->mci, SX8_TSCONFIG_MODE_NORMAL);
+		}
+	}
+	mutex_lock(&mci_base->tuner_lock);
+	sx8_base->tuner_use_count[input]--;
+	if (!sx8_base->tuner_use_count[input])
+		mci_set_tuner(fe, input, 0);
+	if (state->mci.demod < SX8_DEMOD_NUM) {
+		sx8_base->demod_in_use[state->mci.demod] = 0;
+		state->mci.demod = SX8_DEMOD_NONE;
+	}
+	sx8_base->used_ldpc_bitrate[state->mci.nr] = 0;
+	sx8_base->iq_mode = 0;
+	mutex_unlock(&mci_base->tuner_lock);
+	state->started = 0;
+	return 0;
+}
+
+static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+	struct sx8_base *sx8_base = (struct sx8_base *)mci_base;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 used_ldpc_bitrate = 0, free_ldpc_bitrate;
+	u32 used_demods = 0;
+	struct mci_command cmd;
+	u32 input = state->mci.tuner;
+	u32 bits_per_symbol = 0;
+	int i = -1, stat = 0;
+
+	if (p->symbol_rate >= (MCLK / 2))
+		flags &= ~1;
+	if ((flags & 3) == 0)
+		return -EINVAL;
+
+	if (flags & 2) {
+		u32 tmp = modmask;
+
+		bits_per_symbol = 1;
+		while (tmp & 1) {
+			tmp >>= 1;
+			bits_per_symbol++;
+		}
+	}
+
+	mutex_lock(&mci_base->tuner_lock);
+	if (sx8_base->iq_mode) {
+		stat = -EBUSY;
+		goto unlock;
+	}
+
+	if (sx8_base->direct_mode) {
+		if (p->symbol_rate >= MCLK / 2) {
+			if (state->mci.nr < 4)
+				i = state->mci.nr;
+		} else {
+			i = state->mci.nr;
+		}
+	} else {
+		for (i = 0; i < SX8_DEMOD_NUM; i++) {
+			used_ldpc_bitrate += sx8_base->used_ldpc_bitrate[i];
+			if (sx8_base->demod_in_use[i])
+				used_demods++;
+		}
+		if (used_ldpc_bitrate >= MAX_LDPC_BITRATE ||
+		    ((ts_config & SX8_TSCONFIG_MODE_MASK) >
+		     SX8_TSCONFIG_MODE_NORMAL && used_demods > 0)) {
+			stat = -EBUSY;
+			goto unlock;
+		}
+		free_ldpc_bitrate = MAX_LDPC_BITRATE - used_ldpc_bitrate;
+		if (free_ldpc_bitrate > MAX_DEMOD_LDPC_BITRATE)
+			free_ldpc_bitrate = MAX_DEMOD_LDPC_BITRATE;
+
+		while (p->symbol_rate * bits_per_symbol > free_ldpc_bitrate)
+			bits_per_symbol--;
+		if (bits_per_symbol < 2) {
+			stat = -EBUSY;
+			goto unlock;
+		}
+
+		modmask &= ((1 << (bits_per_symbol - 1)) - 1);
+		if (((flags & 0x02) != 0) && modmask == 0) {
+			stat = -EBUSY;
+			goto unlock;
+		}
+
+		i = (p->symbol_rate > (MCLK / 2)) ? 3 : 7;
+		while (i >= 0 && sx8_base->demod_in_use[i])
+			i--;
+	}
+
+	if (i < 0) {
+		stat = -EBUSY;
+		goto unlock;
+	}
+	sx8_base->demod_in_use[i] = 1;
+	sx8_base->used_ldpc_bitrate[state->mci.nr] = p->symbol_rate
+						     * bits_per_symbol;
+	state->mci.demod = i;
+
+	if (!sx8_base->tuner_use_count[input])
+		mci_set_tuner(fe, input, 1);
+	sx8_base->tuner_use_count[input]++;
+	sx8_base->iq_mode = (ts_config > 1);
+unlock:
+	mutex_unlock(&mci_base->tuner_lock);
+	if (stat)
+		return stat;
+	memset(&cmd, 0, sizeof(cmd));
+
+	if (sx8_base->iq_mode) {
+		cmd.command = SX8_CMD_ENABLE_IQOUTPUT;
+		cmd.demod = state->mci.demod;
+		cmd.output = 0;
+		ddb_mci_cmd(&state->mci, &cmd, NULL);
+		ddb_mci_config(&state->mci, ts_config);
+	}
+	if (p->stream_id != NO_STREAM_ID_FILTER && p->stream_id != 0x80000000)
+		flags |= 0x80;
+	dev_dbg(mci_base->dev, "MCI-%d: tuner=%d demod=%d\n",
+		state->mci.nr, state->mci.tuner, state->mci.demod);
+	cmd.command = MCI_CMD_SEARCH_DVBS;
+	cmd.dvbs2_search.flags = flags;
+	cmd.dvbs2_search.s2_modulation_mask = modmask;
+	cmd.dvbs2_search.retry = 2;
+	cmd.dvbs2_search.frequency = p->frequency * 1000;
+	cmd.dvbs2_search.symbol_rate = p->symbol_rate;
+	cmd.dvbs2_search.scrambling_sequence_index =
+		p->scrambling_sequence_index;
+	cmd.dvbs2_search.input_stream_id =
+		(p->stream_id != NO_STREAM_ID_FILTER) ? p->stream_id : 0;
+	cmd.tuner = state->mci.tuner;
+	cmd.demod = state->mci.demod;
+	cmd.output = state->mci.nr;
+	if (p->stream_id == 0x80000000)
+		cmd.output |= 0x80;
+	stat = ddb_mci_cmd(&state->mci, &cmd, NULL);
+	if (stat)
+		stop(fe);
+	return stat;
+}
+
+static int start_iq(struct dvb_frontend *fe, u32 flags, u32 roll_off,
+		    u32 ts_config)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+	struct sx8_base *sx8_base = (struct sx8_base *)mci_base;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 used_demods = 0;
+	struct mci_command cmd;
+	u32 input = state->mci.tuner;
+	int i, stat = 0;
+
+	mutex_lock(&mci_base->tuner_lock);
+	if (sx8_base->iq_mode) {
+		stat = -EBUSY;
+		goto unlock;
+	}
+	for (i = 0; i < SX8_DEMOD_NUM; i++)
+		if (sx8_base->demod_in_use[i])
+			used_demods++;
+	if (used_demods > 0) {
+		stat = -EBUSY;
+		goto unlock;
+	}
+	state->mci.demod = 0;
+	if (!sx8_base->tuner_use_count[input])
+		mci_set_tuner(fe, input, 1);
+	sx8_base->tuner_use_count[input]++;
+	sx8_base->iq_mode = (ts_config > 1);
+unlock:
+	mutex_unlock(&mci_base->tuner_lock);
+	if (stat)
+		return stat;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.command = SX8_CMD_START_IQ;
+	cmd.sx8_start_iq.flags = flags;
+	cmd.sx8_start_iq.roll_off = roll_off;
+	cmd.sx8_start_iq.frequency = p->frequency * 1000;
+	cmd.sx8_start_iq.symbol_rate = p->symbol_rate;
+	cmd.tuner = state->mci.tuner;
+	cmd.demod = state->mci.demod;
+	stat = ddb_mci_cmd(&state->mci, &cmd, NULL);
+	if (stat)
+		stop(fe);
+	ddb_mci_config(&state->mci, ts_config);
+	return stat;
+}
+
+static int set_parameters(struct dvb_frontend *fe)
+{
+	int stat = 0;
+	struct sx8 *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 ts_config = SX8_TSCONFIG_MODE_NORMAL, iq_mode = 0, isi;
+
+	if (state->started)
+		stop(fe);
+
+	isi = p->stream_id;
+	if (isi != NO_STREAM_ID_FILTER)
+		iq_mode = (isi & 0x30000000) >> 28;
+
+	if (iq_mode)
+		ts_config = (SX8_TSCONFIG_TSHEADER | SX8_TSCONFIG_MODE_IQ);
+	if (iq_mode < 3) {
+		u32 flags = 3;
+		u32 mask = 0x7f;
+
+		if (p->modulation == APSK_16 ||
+		    p->modulation == APSK_32) {
+			flags = 2;
+			mask = 0x0f;
+		}
+		stat = start(fe, flags, mask, ts_config);
+	} else {
+		u32 flags = (iq_mode == 2) ? 1 : 0;
+
+		stat = start_iq(fe, flags, 4, ts_config);
+	}
+	if (!stat) {
+		state->started = 1;
+		state->first_time_lock = 1;
+		state->signal_info.status = SX8_DEMOD_WAIT_SIGNAL;
+	}
+
+	return stat;
+}
+
+static int tune(struct dvb_frontend *fe, bool re_tune,
+		unsigned int mode_flags,
+		unsigned int *delay, enum fe_status *status)
+{
+	int r;
+
+	if (re_tune) {
+		r = set_parameters(fe);
+		if (r)
+			return r;
+	}
+	r = read_status(fe, status);
+	if (r)
+		return r;
+
+	if (*status & FE_HAS_LOCK)
+		return 0;
+	*delay = HZ / 10;
+	return 0;
+}
+
+static enum dvbfe_algo get_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static int set_input(struct dvb_frontend *fe, int input)
+{
+	struct sx8 *state = fe->demodulator_priv;
+	struct mci_base *mci_base = state->mci.base;
+
+	if (input >= SX8_TUNER_NUM)
+		return -EINVAL;
+
+	state->mci.tuner = input;
+	dev_dbg(mci_base->dev, "MCI-%d: input=%d\n", state->mci.nr, input);
+	return 0;
+}
+
+static struct dvb_frontend_ops sx8_ops = {
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
+	.info = {
+		.name			= "Digital Devices MaxSX8 MCI DVB-S/S2/S2X",
+		.frequency_min		= 950000,
+		.frequency_max		= 2150000,
+		.frequency_stepsize	= 0,
+		.frequency_tolerance	= 0,
+		.symbol_rate_min	= 100000,
+		.symbol_rate_max	= 100000000,
+		.caps			= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_FEC_AUTO       |
+					  FE_CAN_QPSK           |
+					  FE_CAN_2G_MODULATION  |
+					  FE_CAN_MULTISTREAM,
+	},
+	.get_frontend_algo		= get_algo,
+	.tune				= tune,
+	.release			= release,
+	.read_status			= read_status,
+};
+
+static int init(struct mci *mci)
+{
+	struct sx8 *state = (struct sx8 *)mci;
+
+	state->mci.demod = SX8_DEMOD_NONE;
+	return 0;
+}
+
+const struct mci_cfg ddb_max_sx8_cfg = {
+	.type = 0,
+	.fe_ops = &sx8_ops,
+	.base_size = sizeof(struct sx8_base),
+	.state_size = sizeof(struct sx8),
+	.init = init,
+	.set_input = set_input,
+};
-- 
2.16.4
