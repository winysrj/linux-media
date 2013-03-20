Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45614 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3CTTYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:16 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so1375529eek.32
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:15 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 06/10] bttv: untangle audio input and mute setting
Date: Wed, 20 Mar 2013 20:24:46 +0100
Message-Id: <1363807490-3906-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split function audio_mux():
move the mute setting part to function audio_mute() and the input setting part
to function audio_input().

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   51 ++++++++++++++++-----------------
 1 Datei geändert, 24 Zeilen hinzugefügt(+), 27 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index f1cb0db..0df4a16 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1022,18 +1022,37 @@ audio_mux_gpio(struct bttv *btv, int input, int mute)
 }
 
 static int
-audio_mux(struct bttv *btv, int input, int mute)
+audio_mute(struct bttv *btv, int mute)
 {
 	struct v4l2_ctrl *ctrl;
 
-	audio_mux_gpio(btv, input, mute);
+	audio_mux_gpio(btv, btv->audio_input, mute);
 
 	if (btv->sd_msp34xx) {
-		u32 in;
-
 		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
 		if (ctrl)
 			v4l2_ctrl_s_ctrl(ctrl, mute);
+	}
+	if (btv->sd_tvaudio) {
+		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+		if (ctrl)
+			v4l2_ctrl_s_ctrl(ctrl, mute);
+	}
+	if (btv->sd_tda7432) {
+		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+		if (ctrl)
+			v4l2_ctrl_s_ctrl(ctrl, mute);
+	}
+	return 0;
+}
+
+static int
+audio_input(struct bttv *btv, int input)
+{
+	audio_mux_gpio(btv, input, btv->mute);
+
+	if (btv->sd_msp34xx) {
+		u32 in;
 
 		/* Note: the inputs tuner/radio/extern/intern are translated
 		   to msp routings. This assumes common behavior for all msp3400
@@ -1079,34 +1098,12 @@ audio_mux(struct bttv *btv, int input, int mute)
 			       in, MSP_OUTPUT_DEFAULT, 0);
 	}
 	if (btv->sd_tvaudio) {
-		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
-
-		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, mute);
 		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
-				input, 0, 0);
-	}
-	if (btv->sd_tda7432) {
-		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
-
-		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, mute);
+				 input, 0, 0);
 	}
 	return 0;
 }
 
-static inline int
-audio_mute(struct bttv *btv, int mute)
-{
-	return audio_mux(btv, btv->audio_input, mute);
-}
-
-static inline int
-audio_input(struct bttv *btv, int input)
-{
-	return audio_mux(btv, input, btv->mute);
-}
-
 static void
 bttv_crop_calc_limits(struct bttv_crop *c)
 {
-- 
1.7.10.4

