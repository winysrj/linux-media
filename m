Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab2ETL2M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 07:28:12 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: hverkuil@xs4all.nl
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] bttv: Use btv->has_radio rather then the card info when registering the tuner
Date: Sun, 20 May 2012 13:28:12 +0200
Message-Id: <1337513292-3321-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337513292-3321-1-git-send-email-hdegoede@redhat.com>
References: <1337513292-3321-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bttv_init_card2() sets btv->has_audio to a *default* value from the tvcards
array and then may update it by reading a card specific eeprom or gpio
detection.

After bttv_init_card2(), bttv_init_tuner(), and it should clearly use
the updated, dynamic has_radio value from btv->has_radio, rather then
the const value in the tvcards array.

This fixes the radio not working on my Hauppauge WinTV.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/bt8xx/bttv-cards.c  |    4 ++--
 drivers/media/video/bt8xx/bttv-driver.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index ff2933a..1c030fe 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3649,7 +3649,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 		struct tuner_setup tun_setup;
 
 		/* Load tuner module before issuing tuner config call! */
-		if (bttv_tvcards[btv->c.type].has_radio)
+		if (btv->has_radio)
 			v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
 				&btv->c.i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
@@ -3664,7 +3664,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 		tun_setup.type = btv->tuner_type;
 		tun_setup.addr = addr;
 
-		if (bttv_tvcards[btv->c.type].has_radio)
+		if (btv->has_radio)
 			tun_setup.mode_mask |= T_RADIO;
 
 		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a9cfb0f..7ce3aac 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1181,6 +1181,8 @@ audio_mux(struct bttv *btv, int input, int mute)
 
 	btv->mute = mute;
 	btv->audio = input;
+	
+	printk("input: %d, mute: %d\n", input, mute);
 
 	/* automute */
 	mute = mute || (btv->opt_automute && !signal && !btv->radio_user);
@@ -1220,6 +1222,9 @@ audio_mux(struct bttv *btv, int input, int mute)
 		case TVAUDIO_INPUT_RADIO:
 			in = MSP_INPUT(MSP_IN_SCART2, MSP_IN_TUNER1,
 				    MSP_DSP_IN_SCART, MSP_DSP_IN_SCART);
+				in = MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER2, \
+					MSP_DSP_IN_TUNER, MSP_DSP_IN_TUNER);
+				in = MSP_INPUT_DEFAULT;
 			break;
 		case TVAUDIO_INPUT_EXTERN:
 			in = MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1,
-- 
1.7.10

