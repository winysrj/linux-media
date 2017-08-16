Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34787 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHPPiO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 11:38:14 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, awalls@md.metrocast.net, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] ivtv: Fix incompatible type for argument error
Date: Wed, 16 Aug 2017 21:07:42 +0530
Message-Id: <1502897862-15353-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first argument of function snd_ctl_new1 is of type const struct
snd_kcontrol_new * but in this file the variable is passed by value
to this function. This generated ""incompatible type for argument"
error. So, pass the variable by reference.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
I was not able to compile this file and I could not find any reference to
this file in any Makefile. Also, I could not find any reference to
anything defined in this file. That means the code is not used anywhere.
So, should I send a patch for removing the file?

 drivers/media/pci/ivtv/ivtv-alsa-mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
index ba372a2..aee453f 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
@@ -156,7 +156,7 @@ int __init snd_ivtv_mixer_create(struct snd_ivtv_card *itvsc)
 
 	strlcpy(sc->mixername, "CX2341[56] Mixer", sizeof(sc->mixername));
 
-	ret = snd_ctl_add(sc, snd_ctl_new1(snd_ivtv_mixer_tv_vol, itvsc));
+	ret = snd_ctl_add(sc, snd_ctl_new1(&snd_ivtv_mixer_tv_vol, itvsc));
 	if (ret) {
 		IVTV_ALSA_WARN("%s: failed to add %s control, err %d\n",
 			       __func__, snd_ivtv_mixer_tv_vol.name, ret);
-- 
1.9.1
