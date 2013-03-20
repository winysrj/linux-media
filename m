Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49207 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab3CTTYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:11 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so1375441eek.32
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:10 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 04/10] bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
Date: Wed, 20 Mar 2013 20:24:44 +0100
Message-Id: <1363807490-3906-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'audio_input' better describes the meaning of this field.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
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

