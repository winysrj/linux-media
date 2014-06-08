Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/8] au8522: cleanup s-video settings at setup_decoder_defaults()
Date: Sun,  8 Jun 2014 13:54:54 -0300
Message-Id: <1402246498-2532-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

setup_decoder_defaults() doesn't really care about the input
port. All it needs to know is if the input port is s-video or
not.

As the caller function already knows that, just pass a boolean
instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 53f6dea6b3cb..569922232eb8 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -220,7 +220,7 @@ static void setup_vbi(struct au8522_state *state, int aud_input)
 
 }
 
-static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
+static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
 {
 	int i;
 	int filter_coef_type;
@@ -237,13 +237,10 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 	/* Other decoder registers */
 	au8522_writereg(state, AU8522_TVDEC_INT_MASK_REG010H, 0x00);
 
-	if (input_mode == 0x23) {
-		/* S-Video input mapping */
+	if (is_svideo)
 		au8522_writereg(state, AU8522_VIDEO_MODE_REG011H, 0x04);
-	} else {
-		/* All other modes (CVBS/ATVRF etc.) */
+	else
 		au8522_writereg(state, AU8522_VIDEO_MODE_REG011H, 0x00);
-	}
 
 	au8522_writereg(state, AU8522_TVDEC_PGA_REG012H,
 			AU8522_TVDEC_PGA_REG012H_CVBS);
@@ -275,8 +272,7 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 			AU8522_TVDEC_COMB_HDIF_THR2_REG06AH_CVBS);
 	au8522_writereg(state, AU8522_TVDEC_COMB_HDIF_THR3_REG06BH,
 			AU8522_TVDEC_COMB_HDIF_THR3_REG06BH_CVBS);
-	if (input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13 ||
-	    input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24) {
+	if (is_svideo) {
 		au8522_writereg(state, AU8522_TVDEC_COMB_DCDIF_THR1_REG06CH,
 				AU8522_TVDEC_COMB_DCDIF_THR1_REG06CH_SVIDEO);
 		au8522_writereg(state, AU8522_TVDEC_COMB_DCDIF_THR2_REG06DH,
@@ -317,8 +313,7 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 
 	setup_vbi(state, 0);
 
-	if (input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13 ||
-	    input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24) {
+	if (is_svideo) {
 		/* Despite what the table says, for the HVR-950q we still need
 		   to be in CVBS mode for the S-Video input (reason unknown). */
 		/* filter_coef_type = 3; */
@@ -360,7 +355,7 @@ static void au8522_setup_cvbs_mode(struct au8522_state *state, u8 input_mode)
 
 	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H, input_mode);
 
-	setup_decoder_defaults(state, input_mode);
+	setup_decoder_defaults(state, false);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
@@ -386,7 +381,7 @@ static void au8522_setup_cvbs_tuner_mode(struct au8522_state *state,
 	/* Set input mode to CVBS on channel 4 with SIF audio input enabled */
 	au8522_writereg(state, AU8522_INPUT_CONTROL_REG081H, input_mode);
 
-	setup_decoder_defaults(state, input_mode);
+	setup_decoder_defaults(state, false);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
@@ -407,7 +402,7 @@ static void au8522_setup_svideo_mode(struct au8522_state *state,
 	/* Enable clamping control */
 	au8522_writereg(state, AU8522_CLAMPING_CONTROL_REG083H, 0x00);
 
-	setup_decoder_defaults(state, input_mode);
+	setup_decoder_defaults(state, true);
 
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
-- 
1.9.3

