Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35346 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbbEVU3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 16:29:04 -0400
Received: by wicmx19 with SMTP id mx19so58095447wic.0
        for <linux-media@vger.kernel.org>; Fri, 22 May 2015 13:29:03 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH 3/4] cx24120: Take control of b2c2 receive stream
Date: Fri, 22 May 2015 21:28:27 +0100
Message-Id: <1432326508-6825-4-git-send-email-jdenson@gmail.com>
In-Reply-To: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that b2c2 has an option to allow us to do so, turn off the
flexcop receive stream when we turn off mpeg output whilst tuning.

This "turning off whilst tuning" feature is a bit unusual, and can
now also be easily disabled by leaving stream_control unset in the
config struct.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c | 10 ++++++++++
 drivers/media/dvb-frontends/cx24120.c        | 29 +++++++++++++++++++---------
 drivers/media/dvb-frontends/cx24120.h        |  1 +
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index 31ebf1e..fdd3a18 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -625,11 +625,20 @@ fail:
 
 /* SkyStar S2 PCI DVB-S/S2 card based on Conexant cx24120/cx24118 */
 #if FE_SUPPORTED(CX24120) && FE_SUPPORTED(ISL6421)
+static int skystarS2_stream_control(struct dvb_frontend *fe, int onoff)
+{
+	struct flexcop_device *fc = fe->dvb->priv;
+
+	flexcop_rcv_data_ctrl(fc, onoff);
+	return 0;
+}
+
 static const struct cx24120_config skystar2_rev3_3_cx24120_config = {
 	.i2c_addr = 0x55,
 	.xtal_khz = 10111,
 	.initial_mpeg_config = { 0xa1, 0x76, 0x07 },
 	.request_firmware = flexcop_fe_request_firmware,
+	.stream_control = skystarS2_stream_control,
 	.i2c_wr_max = 4,
 };
 
@@ -651,6 +660,7 @@ static int skystarS2_rev33_attach(struct flexcop_device *fc,
 	}
 	info("ISL6421 successfully attached.");
 
+	fc->external_stream_control = 1;
 	if (fc->has_32_hw_pid_filter)
 		fc->skip_6_hw_pid_filter = 1;
 
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index a14d0f1..d625c1c 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -371,6 +371,8 @@ static void cx24120_check_cmd(struct cx24120_state *state, u8 id)
 	case CMD_DISEQC_BURST:
 		cx24120_msg_mpeg_output_global_config(state, 0);
 		/* Old driver would do a msleep(100) here */
+		state->config->stream_control(&state->frontend, 0);
+		state->mpeg_enabled = 0;
 	default:
 		return;
 	}
@@ -382,10 +384,9 @@ static int cx24120_message_send(struct cx24120_state *state,
 {
 	int ficus;
 
-	if (state->mpeg_enabled) {
-		/* Disable mpeg out on certain commands */
+	/* If controlling stream, turn if off whilst tuning */
+	if (state->config->stream_control && state->mpeg_enabled)
 		cx24120_check_cmd(state, cmd->id);
-	}
 
 	cx24120_writereg(state, CX24120_REG_CMD_START, cmd->id);
 	cx24120_writeregs(state, CX24120_REG_CMD_ARGS, &cmd->arg[0],
@@ -464,7 +465,6 @@ static int cx24120_msg_mpeg_output_global_config(struct cx24120_state *state,
 		return ret;
 	}
 
-	state->mpeg_enabled = enable;
 	dev_dbg(&state->i2c->dev, "MPEG output %s\n",
 		enable ? "enabled" : "disabled");
 
@@ -743,11 +743,13 @@ static int cx24120_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		/* Set clock ratios */
 		cx24120_set_clock_ratios(fe);
 
-		/* Old driver would do a msleep(200) here */
-
 		/* Renable mpeg output */
-		if (!state->mpeg_enabled)
+		if (state->config->stream_control && !state->mpeg_enabled) {
+			/* Old driver would do a msleep(200) here */
 			cx24120_msg_mpeg_output_global_config(state, 1);
+			state->config->stream_control(fe, 1);
+			state->mpeg_enabled = 1;
+		}
 
 		state->need_clock_set = 0;
 	}
@@ -1418,8 +1420,17 @@ static int cx24120_init(struct dvb_frontend *fe)
 
 	/* Initialise mpeg outputs */
 	cx24120_writereg(state, 0xeb, 0x0a);
-	if (cx24120_msg_mpeg_output_global_config(state, 0) ||
-	    cx24120_msg_mpeg_output_config(state, 0) ||
+
+	/* Enable global output now if we're not doing stream control */
+	if (!state->config->stream_control)
+		ret = cx24120_msg_mpeg_output_global_config(state, 1);
+	else
+		ret = cx24120_msg_mpeg_output_global_config(state, 0);
+
+	if (ret != 0)
+		return ret;
+
+	if (cx24120_msg_mpeg_output_config(state, 0) ||
 	    cx24120_msg_mpeg_output_config(state, 1) ||
 	    cx24120_msg_mpeg_output_config(state, 2)) {
 		err("Error initialising mpeg output. :(\n");
diff --git a/drivers/media/dvb-frontends/cx24120.h b/drivers/media/dvb-frontends/cx24120.h
index f097042..313518c 100644
--- a/drivers/media/dvb-frontends/cx24120.h
+++ b/drivers/media/dvb-frontends/cx24120.h
@@ -37,6 +37,7 @@ struct cx24120_config {
 
 	int (*request_firmware)(struct dvb_frontend *fe,
 				const struct firmware **fw, char *name);
+	int (*stream_control)(struct dvb_frontend *fe, int onoff);
 
 	/* max bytes I2C provider can write at once */
 	u16 i2c_wr_max;
-- 
2.1.0

