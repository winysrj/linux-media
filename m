Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35970 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeBHIbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 03:31:14 -0500
Received: by mail-wr0-f193.google.com with SMTP id y3so3769284wrh.3
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 00:31:13 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] media: ivtv: remove ivtv-alsa-mixer
Date: Thu,  8 Feb 2018 08:31:07 +0000
Message-Id: <1518078667-4318-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ivtv-alsa-mixer functions was introduced in commit 269c11fbac4f ("[media] ivtv, ivtv-alsa: Add initial ivtv-alsa interface driver for ivtv")
But according to commit message, ivtv-alsa-mixer.c was already dead
code.
5 years after, we should remove it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c  |  10 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c | 165 -------------------------------
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h |  18 ----
 3 files changed, 1 insertion(+), 192 deletions(-)
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.c
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.h

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 029f52733f70..cb74aeb3035c 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -160,15 +160,7 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 	/* (4) Set the driver ID and name strings */
 	snd_ivtv_card_set_names(itvsc);
 
-	/* (5) Create other components: mixer, PCM, & proc files */
-#if 0
-	ret = snd_ivtv_mixer_create(itvsc);
-	if (ret) {
-		IVTV_ALSA_WARN("%s: snd_ivtv_mixer_create() failed with err %d: proceeding anyway\n",
-			       __func__, ret);
-	}
-#endif
-
+	/* (5) Create other components: PCM, & proc files */
 	ret = snd_ivtv_pcm_create(itvsc);
 	if (ret) {
 		IVTV_ALSA_ERR("%s: snd_ivtv_pcm_create() failed with err %d\n",
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
deleted file mode 100644
index aee453fcff37..000000000000
--- a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
+++ /dev/null
@@ -1,165 +0,0 @@
-/*
- *  ALSA mixer controls for the
- *  ALSA interface to ivtv PCM capture streams
- *
- *  Copyright (C) 2009,2012  Andy Walls <awalls@md.metrocast.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include "ivtv-alsa.h"
-#include "ivtv-alsa-mixer.h"
-#include "ivtv-driver.h"
-
-#include <linux/videodev2.h>
-
-#include <sound/core.h>
-#include <sound/control.h>
-#include <sound/tlv.h>
-
-/*
- * Note the cx25840-core volume scale is funny, due to the alignment of the
- * scale with another chip's range:
- *
- * v4l2_control value	/512	indicated dB	actual dB	reg 0x8d4
- * 0x0000 - 0x01ff	  0	-119		-96		228
- * 0x0200 - 0x02ff	  1	-118		-96		228
- * ...
- * 0x2c00 - 0x2dff	 22	 -97		-96		228
- * 0x2e00 - 0x2fff	 23	 -96		-96		228
- * 0x3000 - 0x31ff	 24	 -95		-95		226
- * ...
- * 0xee00 - 0xefff	119	   0		  0		 36
- * ...
- * 0xfe00 - 0xffff	127	  +8		 +8		 20
- */
-static inline int dB_to_cx25840_vol(int dB)
-{
-	if (dB < -96)
-		dB = -96;
-	else if (dB > 8)
-		dB = 8;
-	return (dB + 119) << 9;
-}
-
-static inline int cx25840_vol_to_dB(int v)
-{
-	if (v < (23 << 9))
-		v = (23 << 9);
-	else if (v > (127 << 9))
-		v = (127 << 9);
-	return (v >> 9) - 119;
-}
-
-static int snd_ivtv_mixer_tv_vol_info(struct snd_kcontrol *kcontrol,
-				      struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	/* We're already translating values, just keep this control in dB */
-	uinfo->value.integer.min  = -96;
-	uinfo->value.integer.max  =   8;
-	uinfo->value.integer.step =   1;
-	return 0;
-}
-
-static int snd_ivtv_mixer_tv_vol_get(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_ivtv_card *itvsc = snd_kcontrol_chip(kctl);
-	struct ivtv *itv = to_ivtv(itvsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx25840_vol(uctl->value.integer.value[0]);
-
-	snd_ivtv_lock(itvsc);
-	ret = v4l2_g_ctrl(itv->sd_audio->ctrl_handler, &vctrl);
-	snd_ivtv_unlock(itvsc);
-
-	if (!ret)
-		uctl->value.integer.value[0] = cx25840_vol_to_dB(vctrl.value);
-	return ret;
-}
-
-static int snd_ivtv_mixer_tv_vol_put(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_ivtv_card *itvsc = snd_kcontrol_chip(kctl);
-	struct ivtv *itv = to_ivtv(itvsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx25840_vol(uctl->value.integer.value[0]);
-
-	snd_ivtv_lock(itvsc);
-
-	/* Fetch current state */
-	ret = v4l2_g_ctrl(itv->sd_audio->ctrl_handler, &vctrl);
-
-	if (ret ||
-	    (cx25840_vol_to_dB(vctrl.value) != uctl->value.integer.value[0])) {
-
-		/* Set, if needed */
-		vctrl.value = dB_to_cx25840_vol(uctl->value.integer.value[0]);
-		ret = v4l2_s_ctrl(itv->sd_audio->ctrl_handler, &vctrl);
-		if (!ret)
-			ret = 1; /* Indicate control was changed w/o error */
-	}
-	snd_ivtv_unlock(itvsc);
-
-	return ret;
-}
-
-
-/* This is a bit of overkill, the slider is already in dB internally */
-static DECLARE_TLV_DB_SCALE(snd_ivtv_mixer_tv_vol_db_scale, -9600, 100, 0);
-
-static struct snd_kcontrol_new snd_ivtv_mixer_tv_vol __initdata = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Analog TV Capture Volume",
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
-		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.info = snd_ivtv_mixer_tv_volume_info,
-	.get = snd_ivtv_mixer_tv_volume_get,
-	.put = snd_ivtv_mixer_tv_volume_put,
-	.tlv.p = snd_ivtv_mixer_tv_vol_db_scale
-};
-
-/* FIXME - add mute switch and balance, bass, treble sliders:
-	V4L2_CID_AUDIO_MUTE
-
-	V4L2_CID_AUDIO_BALANCE
-
-	V4L2_CID_AUDIO_BASS
-	V4L2_CID_AUDIO_TREBLE
-*/
-
-/* FIXME - add stereo, lang1, lang2, mono menu */
-/* FIXME - add I2S volume */
-
-int __init snd_ivtv_mixer_create(struct snd_ivtv_card *itvsc)
-{
-	struct v4l2_device *v4l2_dev = itvsc->v4l2_dev;
-	struct snd_card *sc = itvsc->sc;
-	int ret;
-
-	strlcpy(sc->mixername, "CX2341[56] Mixer", sizeof(sc->mixername));
-
-	ret = snd_ctl_add(sc, snd_ctl_new1(&snd_ivtv_mixer_tv_vol, itvsc));
-	if (ret) {
-		IVTV_ALSA_WARN("%s: failed to add %s control, err %d\n",
-			       __func__, snd_ivtv_mixer_tv_vol.name, ret);
-	}
-	return ret;
-}
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-mixer.h b/drivers/media/pci/ivtv/ivtv-alsa-mixer.h
deleted file mode 100644
index 382bc36bc529..000000000000
--- a/drivers/media/pci/ivtv/ivtv-alsa-mixer.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- *  ALSA mixer controls for the
- *  ALSA interface to ivtv PCM capture streams
- *
- *  Copyright (C) 2009,2012  Andy Walls <awalls@md.metrocast.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-int __init snd_ivtv_mixer_create(struct snd_ivtv_card *itvsc);
-- 
2.13.6
