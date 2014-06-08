Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaFHQ40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:56:26 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/8] au8522: be sure that we'll setup audio routing at the right time
Date: Sun,  8 Jun 2014 13:54:53 -0300
Message-Id: <1402246498-2532-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's set the the audio routing also at stream start. With this change,
we don't risk enabling the analog demux while not streaming, reducing
the risk of interfering with a DVB demux that might be happening.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index b2b9f04a1340..53f6dea6b3cb 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -429,8 +429,9 @@ static void disable_audio_input(struct au8522_state *state)
 }
 
 /* 0=disable, 1=SIF */
-static void set_audio_input(struct au8522_state *state, int aud_input)
+static void set_audio_input(struct au8522_state *state)
 {
+	int aud_input = state->aud_input;
 	int i;
 
 	/* Note that this function needs to be used in conjunction with setting
@@ -580,8 +581,6 @@ static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
 	struct au8522_state *state = to_state(sd);
 
 	if (enable) {
-		state->operational_mode = AU8522_ANALOG_MODE;
-
 		/*
 		 * Clear out any state associated with the digital side of the
 		 * chip, so that when it gets powered back up it won't think
@@ -596,6 +595,10 @@ static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
 				AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
 
 		au8522_video_set(state);
+
+		set_audio_input(state);
+
+		state->operational_mode = AU8522_ANALOG_MODE;
 	} else {
 		/* This does not completely power down the device
 		   (it only reduces it from around 140ma to 80ma) */
@@ -632,7 +635,12 @@ static int au8522_s_audio_routing(struct v4l2_subdev *sd,
 					u32 input, u32 output, u32 config)
 {
 	struct au8522_state *state = to_state(sd);
-	set_audio_input(state, input);
+
+	state->aud_input = input;
+
+	if (state->operational_mode == AU8522_ANALOG_MODE)
+		set_audio_input(state);
+
 	return 0;
 }
 
-- 
1.9.3

