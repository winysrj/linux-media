Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/8] au8522: move input_mode out one level
Date: Sun,  8 Jun 2014 13:54:51 -0300
Message-Id: <1402246498-2532-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input mode is used not only inside the setup_decoder_defaults()
but also at au8522_*_mode routines.

So, move it one level up. As an advantage, we can now group the
function that sets the input into just one.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 93 ++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 23a0d05ba426..21d204914524 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -346,7 +346,7 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 	au8522_writereg(state, AU8522_REG436H, 0x3c);
 }
 
-static void au8522_setup_cvbs_mode(struct au8522_state *state)
+static void au8522_setup_cvbs_mode(struct au8522_state *state, u8 input_mode)
 {
 	/* here we're going to try the pre-programmed route */
 	au8522_writereg(state, AU8522_MODULE_CLOCK_CONTROL_REG0A3H,
@@ -358,16 +358,16 @@ static void au8522_setup_cvbs_mode(struct au8522_state *state)
 	/* Enable clamping control */
 	au8522_writereg(state, AU8522_CLAMPING_CONTROL_REG083H, 0x00);
 
-	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H,
-			AU8522_INPUT_CONTROL_REG081H_CVBS_CH1);
+	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H, input_mode);
 
-	setup_decoder_defaults(state, AU8522_INPUT_CONTROL_REG081H_CVBS_CH1);
+	setup_decoder_defaults(state, input_mode);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
 }
 
-static void au8522_setup_cvbs_tuner_mode(struct au8522_state *state)
+static void au8522_setup_cvbs_tuner_mode(struct au8522_state *state,
+					 u8 input_mode)
 {
 	/* here we're going to try the pre-programmed route */
 	au8522_writereg(state, AU8522_MODULE_CLOCK_CONTROL_REG0A3H,
@@ -384,24 +384,22 @@ static void au8522_setup_cvbs_tuner_mode(struct au8522_state *state)
 	au8522_writereg(state, AU8522_PGA_CONTROL_REG082H, 0x10);
 
 	/* Set input mode to CVBS on channel 4 with SIF audio input enabled */
-	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H,
-			AU8522_INPUT_CONTROL_REG081H_CVBS_CH4_SIF);
+	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H, input_mode);
 
-	setup_decoder_defaults(state,
-			       AU8522_INPUT_CONTROL_REG081H_CVBS_CH4_SIF);
+	setup_decoder_defaults(state, input_mode);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
 }
 
-static void au8522_setup_svideo_mode(struct au8522_state *state)
+static void au8522_setup_svideo_mode(struct au8522_state *state,
+				     u8 input_mode)
 {
 	au8522_writereg(state, AU8522_MODULE_CLOCK_CONTROL_REG0A3H,
 			AU8522_MODULE_CLOCK_CONTROL_REG0A3H_SVIDEO);
 
 	/* Set input to Y on Channe1, C on Channel 3 */
-	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H,
-			AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13);
+	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H, input_mode);
 
 	/* PGA in automatic mode */
 	au8522_writereg(state, AU8522_PGA_CONTROL_REG082H, 0x00);
@@ -409,8 +407,7 @@ static void au8522_setup_svideo_mode(struct au8522_state *state)
 	/* Enable clamping control */
 	au8522_writereg(state, AU8522_CLAMPING_CONTROL_REG083H, 0x00);
 
-	setup_decoder_defaults(state,
-			       AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13);
+	setup_decoder_defaults(state, input_mode);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
@@ -558,10 +555,8 @@ static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int au8522_reset(struct v4l2_subdev *sd, u32 val)
+static int __au8522_reset(struct au8522_state *state)
 {
-	struct au8522_state *state = to_state(sd);
-
 	state->operational_mode = AU8522_ANALOG_MODE;
 
 	/* Clear out any state associated with the digital side of the
@@ -574,23 +569,69 @@ static int au8522_reset(struct v4l2_subdev *sd, u32 val)
 	return 0;
 }
 
+static int au8522_reset(struct v4l2_subdev *sd, u32 val)
+{
+	struct au8522_state *state = to_state(sd);
+
+	return __au8522_reset(state);
+}
+
+static void au8522_video_set(struct au8522_state *state)
+
+{
+	u8 input_mode;
+
+	__au8522_reset(state);
+
+	switch (state->vid_input) {
+	case AU8522_COMPOSITE_CH1:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_CVBS_CH1;
+		au8522_setup_cvbs_mode(state, input_mode);
+		break;
+	case AU8522_COMPOSITE_CH2:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_CVBS_CH2;
+		au8522_setup_cvbs_mode(state, input_mode);
+		break;
+	case AU8522_COMPOSITE_CH3:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_CVBS_CH3;
+		au8522_setup_cvbs_mode(state, input_mode);
+		break;
+	case AU8522_COMPOSITE_CH4:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_CVBS_CH4;
+		au8522_setup_cvbs_mode(state, input_mode);
+		break;
+	case AU8522_SVIDEO_CH13:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13;
+		au8522_setup_svideo_mode(state, input_mode);
+		break;
+	case AU8522_SVIDEO_CH24:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24;
+		au8522_setup_svideo_mode(state, input_mode);
+		break;
+	default:
+	case AU8522_COMPOSITE_CH4_SIF:
+		input_mode = AU8522_INPUT_CONTROL_REG081H_CVBS_CH4_SIF;
+		au8522_setup_cvbs_tuner_mode(state, input_mode);
+		break;
+	}
+}
+
 static int au8522_s_video_routing(struct v4l2_subdev *sd,
 					u32 input, u32 output, u32 config)
 {
 	struct au8522_state *state = to_state(sd);
 
-	au8522_reset(sd, 0);
-
-	if (input == AU8522_COMPOSITE_CH1) {
-		au8522_setup_cvbs_mode(state);
-	} else if (input == AU8522_SVIDEO_CH13) {
-		au8522_setup_svideo_mode(state);
-	} else if (input == AU8522_COMPOSITE_CH4_SIF) {
-		au8522_setup_cvbs_tuner_mode(state);
-	} else {
+	switch(input) {
+	case AU8522_COMPOSITE_CH1:
+	case AU8522_SVIDEO_CH13:
+	case AU8522_COMPOSITE_CH4_SIF:
+		state->vid_input = input;
+		break;
+	default:
 		printk(KERN_ERR "au8522 mode not currently supported\n");
 		return -EINVAL;
 	}
+	au8522_video_set(state);
 	return 0;
 }
 
-- 
1.9.3

