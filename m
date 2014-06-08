Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/8] au8522: be sure that the setup will happen at streamon time
Date: Sun,  8 Jun 2014 13:54:52 -0300
Message-Id: <1402246498-2532-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same demod is used on both analog and digital mode. We should
not let the commands for analog mode to happen while the device
is in digital mode. So, monitor it via streamon.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 80 +++++++++++++---------------
 drivers/media/dvb-frontends/au8522_priv.h    |  1 +
 2 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 21d204914524..b2b9f04a1340 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -536,52 +536,11 @@ static int au8522_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	struct au8522_state *state = to_state(sd);
-
-	if (enable) {
-		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
-				0x01);
-		msleep(1);
-		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
-				AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
-	} else {
-		/* This does not completely power down the device
-		   (it only reduces it from around 140ma to 80ma) */
-		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
-				1 << 5);
-	}
-	return 0;
-}
-
-static int __au8522_reset(struct au8522_state *state)
-{
-	state->operational_mode = AU8522_ANALOG_MODE;
-
-	/* Clear out any state associated with the digital side of the
-	   chip, so that when it gets powered back up it won't think
-	   that it is already tuned */
-	state->current_frequency = 0;
-
-	au8522_writereg(state, 0xa4, 1 << 5);
-
-	return 0;
-}
-
-static int au8522_reset(struct v4l2_subdev *sd, u32 val)
-{
-	struct au8522_state *state = to_state(sd);
-
-	return __au8522_reset(state);
-}
-
 static void au8522_video_set(struct au8522_state *state)
-
 {
 	u8 input_mode;
 
-	__au8522_reset(state);
+	au8522_writereg(state, 0xa4, 1 << 5);
 
 	switch (state->vid_input) {
 	case AU8522_COMPOSITE_CH1:
@@ -616,6 +575,37 @@ static void au8522_video_set(struct au8522_state *state)
 	}
 }
 
+static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct au8522_state *state = to_state(sd);
+
+	if (enable) {
+		state->operational_mode = AU8522_ANALOG_MODE;
+
+		/*
+		 * Clear out any state associated with the digital side of the
+		 * chip, so that when it gets powered back up it won't think
+		 * that it is already tuned
+		 */
+		state->current_frequency = 0;
+
+		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
+				0x01);
+		msleep(1);
+		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
+				AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
+
+		au8522_video_set(state);
+	} else {
+		/* This does not completely power down the device
+		   (it only reduces it from around 140ma to 80ma) */
+		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
+				1 << 5);
+		state->operational_mode = AU8522_SUSPEND_MODE;
+	}
+	return 0;
+}
+
 static int au8522_s_video_routing(struct v4l2_subdev *sd,
 					u32 input, u32 output, u32 config)
 {
@@ -631,7 +621,10 @@ static int au8522_s_video_routing(struct v4l2_subdev *sd,
 		printk(KERN_ERR "au8522 mode not currently supported\n");
 		return -EINVAL;
 	}
-	au8522_video_set(state);
+
+	if (state->operational_mode == AU8522_ANALOG_MODE)
+		au8522_video_set(state);
+
 	return 0;
 }
 
@@ -670,7 +663,6 @@ static int au8522_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 static const struct v4l2_subdev_core_ops au8522_core_ops = {
 	.log_status = v4l2_ctrl_subdev_log_status,
-	.reset = au8522_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = au8522_g_register,
 	.s_register = au8522_s_register,
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index aa0f16d6b610..a781489520fb 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -37,6 +37,7 @@
 
 #define AU8522_ANALOG_MODE 0
 #define AU8522_DIGITAL_MODE 1
+#define AU8522_SUSPEND_MODE 2
 
 struct au8522_state {
 	struct i2c_client *c;
-- 
1.9.3

