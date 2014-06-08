Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50491 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/8] au8522: Fix demod analog mode setting
Date: Sun,  8 Jun 2014 13:54:55 -0300
Message-Id: <1402246498-2532-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several issues on the current code:
	1) msleep(1) is actually equivalent to msleep(10);
	2) au8522_video_set() will set reg 0xa4 to the
	   proper value for SIF, CVBS or S-Video. No need
	   to force it to CVBS;
	3) Let's not hardcode 0x9d for CBS on audio_set.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 569922232eb8..b971c20624bf 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -458,8 +458,9 @@ static void set_audio_input(struct au8522_state *state)
 	au8522_writereg(state, AU8522_I2C_CONTROL_REG0_REG090H, 0x84);
 	msleep(150);
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H, 0x00);
-	msleep(1);
-	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H, 0x9d);
+	msleep(10);
+	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
+			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
 	msleep(50);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_L_REG0F2H, 0x7F);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_R_REG0F3H, 0x7F);
@@ -585,12 +586,9 @@ static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
 
 		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
 				0x01);
-		msleep(1);
-		au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
-				AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
+		msleep(10);
 
 		au8522_video_set(state);
-
 		set_audio_input(state);
 
 		state->operational_mode = AU8522_ANALOG_MODE;
-- 
1.9.3

