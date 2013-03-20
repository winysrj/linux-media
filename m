Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46211 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab3CTTYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:10 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so1365865eek.23
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:09 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 03/10] bttv: do not save the audio input in audio_mux()
Date: Wed, 20 Mar 2013 20:24:43 +0100
Message-Id: <1363807490-3906-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can't and do not save the mute setting in function audio_mux(), so we
should also not save the input in this function for consistency.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   10 +++++-----
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a082ab4..e01a8d8 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -999,8 +999,6 @@ audio_mux(struct bttv *btv, int input, int mute)
 		   bttv_tvcards[btv->c.type].gpiomask);
 	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
 
-	btv->audio = input;
-
 	/* automute */
 	mute_gpio = mute || (btv->opt_automute && (!signal || !btv->users)
 				&& !btv->has_radio_tuner);
@@ -1197,8 +1195,9 @@ set_input(struct bttv *btv, unsigned int input, unsigned int norm)
 	} else {
 		video_mux(btv,input);
 	}
-	audio_input(btv, (btv->tuner_type != TUNER_ABSENT && input == 0) ?
-			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN);
+	btv->audio = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
+			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
+	audio_input(btv, btv->audio);
 	set_tvnorm(btv, norm);
 }
 
@@ -1707,7 +1706,8 @@ static void radio_enable(struct bttv *btv)
 	if (!btv->has_radio_tuner) {
 		btv->has_radio_tuner = 1;
 		bttv_call_all(btv, tuner, s_radio);
-		audio_input(btv, TVAUDIO_INPUT_RADIO);
+		btv->audio = TVAUDIO_INPUT_RADIO;
+		audio_input(btv, btv->audio);
 	}
 }
 
-- 
1.7.10.4

