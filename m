Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35389 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLTWcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 17:32:31 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so3974287wgh.26
        for <linux-media@vger.kernel.org>; Sat, 20 Dec 2014 14:32:30 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: cx18: cx18-alsa-mixer.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 23:35:17 +0100
Message-Id: <1419114917-12029-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removes some functions that are not used anywhere:
snd_cx18_mixer_tv_vol_get() snd_cx18_mixer_tv_vol_info() snd_cx18_mixer_tv_vol_put()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/cx18/cx18-alsa-mixer.c |   62 ------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
index 341bddc..e7b0a1f 100644
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
@@ -69,68 +69,6 @@ static inline int cx18_av_vol_to_dB(int v)
 	return (v >> 9) - 119;
 }
 
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
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
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
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
-
-	if (ret ||
-	    (cx18_av_vol_to_dB(vctrl.value) != uctl->value.integer.value[0])) {
-
-		/* Set, if needed */
-		vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-		ret = v4l2_subdev_call(cx->sd_av, core, s_ctrl, &vctrl);
-		if (!ret)
-			ret = 1; /* Indicate control was changed w/o error */
-	}
-	snd_cx18_unlock(cxsc);
-
-	return ret;
-}
-
 
 /* This is a bit of overkill, the slider is already in dB internally */
 static DECLARE_TLV_DB_SCALE(snd_cx18_mixer_tv_vol_db_scale, -9600, 100, 0);
-- 
1.7.10.4

