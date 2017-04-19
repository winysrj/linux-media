Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33920 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXO1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:27 -0400
Received: by mail-qt0-f179.google.com with SMTP id c45so32511624qtb.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:27 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 03/12] au8522: rework setup of audio routing
Date: Wed, 19 Apr 2017 19:13:46 -0400
Message-Id: <1492643635-30823-4-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original code was based on my reverse engineering of an I2C trace
of the Windows driver.  Now that I know what the registers actually do,
restructure the code a bit, removing some unneeded register programming
and fixing the sequencing of operations.

This reduces the time it takes to change inputs from 1300ms down to
600ms (as measured by "time v4l2-ctl -i 0")

Note this does not address outstanding issues related to the management
of the module clocks and power control for the various blocks, which
will be done in a separate patch.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 29 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 7811717..281b5ac 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -418,28 +418,29 @@ static void set_audio_input(struct au8522_state *state)
 				lpfilter_coef[i].reg_val[0]);
 	}
 
-	/* Setup audio */
-	au8522_writereg(state, AU8522_AUDIO_VOLUME_L_REG0F2H, 0x00);
-	au8522_writereg(state, AU8522_AUDIO_VOLUME_R_REG0F3H, 0x00);
-	au8522_writereg(state, AU8522_AUDIO_VOLUME_REG0F4H, 0x00);
-	msleep(150);
-	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H, 0x00);
-	msleep(10);
-	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H,
-			AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H_CVBS);
-	msleep(50);
+	/* Set the volume */
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_L_REG0F2H, 0x7F);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_R_REG0F3H, 0x7F);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_REG0F4H, 0xff);
-	msleep(80);
-	au8522_writereg(state, AU8522_AUDIO_VOLUME_L_REG0F2H, 0x7F);
-	au8522_writereg(state, AU8522_AUDIO_VOLUME_R_REG0F3H, 0x7F);
+
+	/* Not sure what this does */
 	au8522_writereg(state, AU8522_REG0F9H, AU8522_REG0F9H_AUDIO);
+
+	/* Setup the audio mode to stereo DBX */
 	au8522_writereg(state, AU8522_AUDIO_MODE_REG0F1H, 0x82);
 	msleep(70);
-	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_1_REG0A5H, 0x09);
+
+	/* Start the audio processing module */
+	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H, 0x9d);
+
+	/* Set the audio frequency to 48 KHz */
 	au8522_writereg(state, AU8522_AUDIOFREQ_REG606H, 0x03);
+
+	/* Set the I2S parameters (WS, LSB, mode, sample rate */
 	au8522_writereg(state, AU8522_I2S_CTRL_2_REG112H, 0xc2);
+
+	/* Enable the I2S output */
+	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_1_REG0A5H, 0x09);
 }
 
 /* ----------------------------------------------------------------------- */
-- 
1.9.1
