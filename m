Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49976 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CURui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:38 -0400
Received: by mail-ea0-f178.google.com with SMTP id g14so1037771eak.37
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:37 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/8] bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
Date: Thu, 21 Mar 2013 18:51:16 +0100
Message-Id: <1363888280-28724-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'audio_input' better describes the meaning of this field.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c  |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c |   12 ++++++------
 drivers/media/pci/bt8xx/bttvp.h       |    2 +-
 3 Dateien geändert, 8 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index fa0faaa..b7dc921 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3947,7 +3947,7 @@ static void avermedia_eeprom(struct bttv *btv)
 u32 bttv_tda9880_setnorm(struct bttv *btv, u32 gpiobits)
 {
 
-	if (btv->audio == TVAUDIO_INPUT_TUNER) {
+	if (btv->audio_input == TVAUDIO_INPUT_TUNER) {
 		if (bttv_tvnorms[btv->tvnorm].v4l2_id & V4L2_STD_MN)
 			gpiobits |= 0x10000;
 		else
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index e01a8d8..81ee70d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1093,7 +1093,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 static inline int
 audio_mute(struct bttv *btv, int mute)
 {
-	return audio_mux(btv, btv->audio, mute);
+	return audio_mux(btv, btv->audio_input, mute);
 }
 
 static inline int
@@ -1195,9 +1195,9 @@ set_input(struct bttv *btv, unsigned int input, unsigned int norm)
 	} else {
 		video_mux(btv,input);
 	}
-	btv->audio = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
-			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
-	audio_input(btv, btv->audio);
+	btv->audio_input = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
+				TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
+	audio_input(btv, btv->audio_input);
 	set_tvnorm(btv, norm);
 }
 
@@ -1706,8 +1706,8 @@ static void radio_enable(struct bttv *btv)
 	if (!btv->has_radio_tuner) {
 		btv->has_radio_tuner = 1;
 		bttv_call_all(btv, tuner, s_radio);
-		btv->audio = TVAUDIO_INPUT_RADIO;
-		audio_input(btv, btv->audio);
+		btv->audio_input = TVAUDIO_INPUT_RADIO;
+		audio_input(btv, btv->audio_input);
 	}
 }
 
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index e7910e0..9c1cc2c 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -423,7 +423,7 @@ struct bttv {
 
 	/* video state */
 	unsigned int input;
-	unsigned int audio;
+	unsigned int audio_input;
 	unsigned int mute;
 	unsigned long tv_freq;
 	unsigned int tvnorm;
-- 
1.7.10.4

