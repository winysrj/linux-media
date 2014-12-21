Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54989 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbaLUBIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 20:08:02 -0500
In-Reply-To: <1419114917-12029-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419114917-12029-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] media: pci: cx18: cx18-alsa-mixer.c:  Remove some unused functions
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 20 Dec 2014 19:06:26 -0500
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <104C68D6-95CC-4268-B08D-2C48474EC09C@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On December 20, 2014 5:35:17 PM EST, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>Removes some functions that are not used anywhere:
>snd_cx18_mixer_tv_vol_get() snd_cx18_mixer_tv_vol_info()
>snd_cx18_mixer_tv_vol_put()
>
>This was partially found by using a static code analysis program called
>cppcheck.
>
>Signed-off-by: Rickard Strandqvist
><rickard_strandqvist@spectrumdigital.se>
>---
>drivers/media/pci/cx18/cx18-alsa-mixer.c |   62
>------------------------------
> 1 file changed, 62 deletions(-)
>
>diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c
>b/drivers/media/pci/cx18/cx18-alsa-mixer.c
>index 341bddc..e7b0a1f 100644
>--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
>+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
>@@ -69,68 +69,6 @@ static inline int cx18_av_vol_to_dB(int v)
> 	return (v >> 9) - 119;
> }
> 
>-static int snd_cx18_mixer_tv_vol_info(struct snd_kcontrol *kcontrol,
>-				      struct snd_ctl_elem_info *uinfo)
>-{
>-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
>-	uinfo->count = 1;
>-	/* We're already translating values, just keep this control in dB */
>-	uinfo->value.integer.min  = -96;
>-	uinfo->value.integer.max  =   8;
>-	uinfo->value.integer.step =   1;
>-	return 0;
>-}
>-
>-static int snd_cx18_mixer_tv_vol_get(struct snd_kcontrol *kctl,
>-				     struct snd_ctl_elem_value *uctl)
>-{
>-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
>-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
>-	struct v4l2_control vctrl;
>-	int ret;
>-
>-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
>-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>-
>-	snd_cx18_lock(cxsc);
>-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
>-	snd_cx18_unlock(cxsc);
>-
>-	if (!ret)
>-		uctl->value.integer.value[0] = cx18_av_vol_to_dB(vctrl.value);
>-	return ret;
>-}
>-
>-static int snd_cx18_mixer_tv_vol_put(struct snd_kcontrol *kctl,
>-				     struct snd_ctl_elem_value *uctl)
>-{
>-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
>-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
>-	struct v4l2_control vctrl;
>-	int ret;
>-
>-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
>-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>-
>-	snd_cx18_lock(cxsc);
>-
>-	/* Fetch current state */
>-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
>-
>-	if (ret ||
>-	    (cx18_av_vol_to_dB(vctrl.value) != uctl->value.integer.value[0]))
>{
>-
>-		/* Set, if needed */
>-		vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>-		ret = v4l2_subdev_call(cx->sd_av, core, s_ctrl, &vctrl);
>-		if (!ret)
>-			ret = 1; /* Indicate control was changed w/o error */
>-	}
>-	snd_cx18_unlock(cxsc);
>-
>-	return ret;
>-}
>-
> 
>/* This is a bit of overkill, the slider is already in dB internally */
>static DECLARE_TLV_DB_SCALE(snd_cx18_mixer_tv_vol_db_scale, -9600, 100,
>0);

Really?  Did you try to compile the file after this patch?

http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/pci/cx18/cx18-alsa-mixer.c#n143

They are referenced later in the same file.

This is only half a fix.

 You can either remove the cx18-alsa-mixer.* files and from the build system, or even better,you can hook-up and initialize these callbacks with alsa so alsa mixer controls show up for cx18.  :)

-Andy
