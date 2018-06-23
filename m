Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38015 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbeFWPgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:32 -0400
Received: by mail-wr0-f195.google.com with SMTP id e18-v6so9427934wrs.5
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:31 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 14/19] [media] ddbridge/mci: make ddb_mci_cmd() and ddb_mci_config() public
Date: Sat, 23 Jun 2018 17:36:10 +0200
Message-Id: <20180623153615.27630-15-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In preparation for splitting all MaxSX8 related code parts from the common
MCI code, prefix both mci_cmd() and mci_config() functions with ddb_,
remove the static marking and add matching function prototypes to
ddbridge-mci.h so these functions can be reused from other files within
the ddbridge driver. As this requires the mci-related structs to be
defined in ddbridge-mci.h, move struct mci and struct mci_base there and
clean them up.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 62 ++++++++-----------------------
 drivers/media/pci/ddbridge/ddbridge-mci.h | 36 ++++++++++++++++++
 2 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index fa0d7d0cc6f6..a29ff25d9029 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -26,38 +26,6 @@ static const u32 MCLK = (1550000000 / 12);
 static const u32 MAX_DEMOD_LDPC_BITRATE = (1550000000 / 6);
 static const u32 MAX_LDPC_BITRATE = (720000000);
 
-struct mci_base {
-	struct list_head     mci_list;
-	void                *key;
-	struct ddb_link     *link;
-	struct completion    completion;
-
-	struct device       *dev;
-	struct mutex         tuner_lock; /* concurrent tuner access lock */
-	u8                   adr;
-	struct mutex         mci_lock; /* concurrent MCI access lock */
-	int                  count;
-
-	u8                   tuner_use_count[MCI_TUNER_MAX];
-	u8                   assigned_demod[MCI_DEMOD_MAX];
-	u32                  used_ldpc_bitrate[MCI_DEMOD_MAX];
-	u8                   demod_in_use[MCI_DEMOD_MAX];
-	u32                  iq_mode;
-};
-
-struct mci {
-	struct mci_base     *base;
-	struct dvb_frontend  fe;
-	int                  nr;
-	int                  demod;
-	int                  tuner;
-	int                  first_time_lock;
-	int                  started;
-	struct mci_result    signal_info;
-
-	u32                  bb_mode;
-};
-
 static int mci_reset(struct mci *state)
 {
 	struct ddb_link *link = state->base->link;
@@ -84,7 +52,7 @@ static int mci_reset(struct mci *state)
 	return 0;
 }
 
-static int mci_config(struct mci *state, u32 config)
+int ddb_mci_config(struct mci *state, u32 config)
 {
 	struct ddb_link *link = state->base->link;
 
@@ -122,9 +90,9 @@ static int _mci_cmd_unlocked(struct mci *state,
 	return 0;
 }
 
-static int mci_cmd(struct mci *state,
-		   struct mci_command *command,
-		   struct mci_result *result)
+int ddb_mci_cmd(struct mci *state,
+		struct mci_command *command,
+		struct mci_result *result)
 {
 	int stat;
 
@@ -164,7 +132,7 @@ static int get_info(struct dvb_frontend *fe)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.command = MCI_CMD_GETSIGNALINFO;
 	cmd.demod = state->demod;
-	stat = mci_cmd(state, &cmd, &state->signal_info);
+	stat = ddb_mci_cmd(state, &cmd, &state->signal_info);
 	return stat;
 }
 
@@ -205,7 +173,7 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	cmd.command = MCI_CMD_GETSTATUS;
 	cmd.demod = state->demod;
-	stat = mci_cmd(state, &cmd, &res);
+	stat = ddb_mci_cmd(state, &cmd, &res);
 	if (stat)
 		return stat;
 	*status = 0x00;
@@ -228,7 +196,7 @@ static int mci_set_tuner(struct dvb_frontend *fe, u32 tuner, u32 on)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tuner = state->tuner;
 	cmd.command = on ? SX8_CMD_INPUT_ENABLE : SX8_CMD_INPUT_DISABLE;
-	return mci_cmd(state, &cmd, NULL);
+	return ddb_mci_cmd(state, &cmd, NULL);
 }
 
 static int stop(struct dvb_frontend *fe)
@@ -241,13 +209,13 @@ static int stop(struct dvb_frontend *fe)
 	if (state->demod != DEMOD_UNUSED) {
 		cmd.command = MCI_CMD_STOP;
 		cmd.demod = state->demod;
-		mci_cmd(state, &cmd, NULL);
+		ddb_mci_cmd(state, &cmd, NULL);
 		if (state->base->iq_mode) {
 			cmd.command = MCI_CMD_STOP;
 			cmd.demod = state->demod;
 			cmd.output = 0;
-			mci_cmd(state, &cmd, NULL);
-			mci_config(state, SX8_TSCONFIG_MODE_NORMAL);
+			ddb_mci_cmd(state, &cmd, NULL);
+			ddb_mci_config(state, SX8_TSCONFIG_MODE_NORMAL);
 		}
 	}
 	mutex_lock(&state->base->tuner_lock);
@@ -345,8 +313,8 @@ static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
 		cmd.command = SX8_CMD_ENABLE_IQOUTPUT;
 		cmd.demod = state->demod;
 		cmd.output = 0;
-		mci_cmd(state, &cmd, NULL);
-		mci_config(state, ts_config);
+		ddb_mci_cmd(state, &cmd, NULL);
+		ddb_mci_config(state, ts_config);
 	}
 	if (p->stream_id != NO_STREAM_ID_FILTER && p->stream_id != 0x80000000)
 		flags |= 0x80;
@@ -368,7 +336,7 @@ static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
 	cmd.output = state->nr;
 	if (p->stream_id == 0x80000000)
 		cmd.output |= 0x80;
-	stat = mci_cmd(state, &cmd, NULL);
+	stat = ddb_mci_cmd(state, &cmd, NULL);
 	if (stat)
 		stop(fe);
 	return stat;
@@ -413,8 +381,8 @@ static int start_iq(struct dvb_frontend *fe, u32 ts_config)
 	cmd.tuner = state->tuner;
 	cmd.demod = state->demod;
 	cmd.output = 7;
-	mci_config(state, ts_config);
-	stat = mci_cmd(state, &cmd, NULL);
+	ddb_mci_config(state, ts_config);
+	stat = ddb_mci_cmd(state, &cmd, NULL);
 	if (stat)
 		stop(fe);
 	return stat;
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 5e0c9e88b6fc..14c8b1ee6358 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -206,6 +206,42 @@ struct mci_result {
 	u32 version[4];
 };
 
+struct mci_base {
+	struct list_head     mci_list;
+	void                *key;
+	struct ddb_link     *link;
+	struct completion    completion;
+
+	struct device       *dev;
+	struct mutex         tuner_lock; /* concurrent tuner access lock */
+	u8                   adr;
+	struct mutex         mci_lock; /* concurrent MCI access lock */
+	int                  count;
+
+	u8                   tuner_use_count[MCI_TUNER_MAX];
+	u8                   assigned_demod[MCI_DEMOD_MAX];
+	u32                  used_ldpc_bitrate[MCI_DEMOD_MAX];
+	u8                   demod_in_use[MCI_DEMOD_MAX];
+	u32                  iq_mode;
+};
+
+struct mci {
+	struct mci_base     *base;
+	struct dvb_frontend  fe;
+	int                  nr;
+	int                  demod;
+	int                  tuner;
+	int                  first_time_lock;
+	int                  started;
+	struct mci_result    signal_info;
+
+	u32                  bb_mode;
+};
+
+int ddb_mci_cmd(struct mci *state, struct mci_command *command,
+		struct mci_result *result);
+int ddb_mci_config(struct mci *state, u32 config);
+
 struct dvb_frontend
 *ddb_mci_attach(struct ddb_input *input,
 		int mci_type, int nr,
-- 
2.16.4
