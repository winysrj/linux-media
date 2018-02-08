Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32816 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbeBHI00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 03:26:26 -0500
Received: by mail-wr0-f193.google.com with SMTP id s5so3765725wra.0
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 00:26:26 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] media: cx18: remove unused cx18-alsa-mixer
Date: Thu,  8 Feb 2018 08:26:14 +0000
Message-Id: <1518078374-4150-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx18-alsa-mixer functions are not used since commit 4cb565cc2700 ("V4L/DVB: cx18: make it so cx18-alsa-main.c compiles")
9 year later, lets just remove them.
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/media/pci/cx18/cx18-alsa-main.c  |   1 -
 drivers/media/pci/cx18/cx18-alsa-mixer.c | 170 -------------------------------
 drivers/media/pci/cx18/cx18-alsa-mixer.h |  18 ----
 3 files changed, 189 deletions(-)
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.c
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.h

diff --git a/drivers/media/pci/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
index 2531e4b81b60..93443d1457c5 100644
--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -32,7 +32,6 @@
 #include "cx18-driver.h"
 #include "cx18-version.h"
 #include "cx18-alsa.h"
-#include "cx18-alsa-mixer.h"
 #include "cx18-alsa-pcm.h"
 
 int cx18_alsa_debug;
diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
deleted file mode 100644
index cb04c3d820e2..000000000000
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- *  ALSA mixer controls for the
- *  ALSA interface to cx18 PCM capture streams
- *
- *  Copyright (C) 2009  Andy Walls <awalls@md.metrocast.net>
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
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/spinlock.h>
-#include <linux/videodev2.h>
-
-#include <media/v4l2-device.h>
-
-#include <sound/core.h>
-#include <sound/control.h>
-#include <sound/tlv.h>
-
-#include "cx18-alsa.h"
-#include "cx18-driver.h"
-
-/*
- * Note the cx18-av-core volume scale is funny, due to the alignment of the
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
-static inline int dB_to_cx18_av_vol(int dB)
-{
-	if (dB < -96)
-		dB = -96;
-	else if (dB > 8)
-		dB = 8;
-	return (dB + 119) << 9;
-}
-
-static inline int cx18_av_vol_to_dB(int v)
-{
-	if (v < (23 << 9))
-		v = (23 << 9);
-	else if (v > (127 << 9))
-		v = (127 << 9);
-	return (v >> 9) - 119;
-}
-
-static int snd_cx18_mixer_tv_vol_info(struct snd_kcontrol *kcontrol,
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
-static int snd_cx18_mixer_tv_vol_get(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-
-	snd_cx18_lock(cxsc);
-	ret = v4l2_g_ctrl(cx->sd_av->ctrl_handler, &vctrl);
-	snd_cx18_unlock(cxsc);
-
-	if (!ret)
-		uctl->value.integer.value[0] = cx18_av_vol_to_dB(vctrl.value);
-	return ret;
-}
-
-static int snd_cx18_mixer_tv_vol_put(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-
-	snd_cx18_lock(cxsc);
-
-	/* Fetch current state */
-	ret = v4l2_g_ctrl(cx->sd_av->ctrl_handler, &vctrl);
-
-	if (ret ||
-	    (cx18_av_vol_to_dB(vctrl.value) != uctl->value.integer.value[0])) {
-
-		/* Set, if needed */
-		vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-		ret = v4l2_s_ctrl(cx->sd_av->ctrl_handler, &vctrl);
-		if (!ret)
-			ret = 1; /* Indicate control was changed w/o error */
-	}
-	snd_cx18_unlock(cxsc);
-
-	return ret;
-}
-
-
-/* This is a bit of overkill, the slider is already in dB internally */
-static DECLARE_TLV_DB_SCALE(snd_cx18_mixer_tv_vol_db_scale, -9600, 100, 0);
-
-static struct snd_kcontrol_new snd_cx18_mixer_tv_vol __initdata = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Analog TV Capture Volume",
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
-		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.info = snd_cx18_mixer_tv_volume_info,
-	.get = snd_cx18_mixer_tv_volume_get,
-	.put = snd_cx18_mixer_tv_volume_put,
-	.tlv.p = snd_cx18_mixer_tv_vol_db_scale
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
-/* FIXME - add CS5345 I2S volume for HVR-1600 */
-
-int __init snd_cx18_mixer_create(struct snd_cx18_card *cxsc)
-{
-	struct v4l2_device *v4l2_dev = cxsc->v4l2_dev;
-	struct snd_card *sc = cxsc->sc;
-	int ret;
-
-	strlcpy(sc->mixername, "CX23418 Mixer", sizeof(sc->mixername));
-
-	ret = snd_ctl_add(sc, snd_ctl_new1(&snd_cx18_mixer_tv_vol, cxsc));
-	if (ret) {
-		CX18_ALSA_WARN("%s: failed to add %s control, err %d\n",
-				__func__, snd_cx18_mixer_tv_vol.name, ret);
-	}
-	return ret;
-}
diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.h b/drivers/media/pci/cx18/cx18-alsa-mixer.h
deleted file mode 100644
index 3aed123955dd..000000000000
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- *  ALSA mixer controls for the
- *  ALSA interface to cx18 PCM capture streams
- *
- *  Copyright (C) 2009  Andy Walls <awalls@md.metrocast.net>
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
-int __init snd_cx18_mixer_create(struct snd_cx18_card *cxsc);
-- 
2.13.6
