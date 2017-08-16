Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35863 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdHPOyS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 10:54:18 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, awalls@md.metrocast.net, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] cx18: Fix incompatible type for argument error
Date: Wed, 16 Aug 2017 20:24:00 +0530
Message-Id: <1502895240-17569-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first argument of function snd_ctl_new1 is of type const struct
snd_kcontrol_new * but in this file the variable is passed by value to
this function.
This generated ""incompatible type for argument" error. So, pass the
variable by reference.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
I was not able to compile this file and I could not find any reference to
this file in any Makefile. Also, I could not find any reference to 
anything defined in this file. That means the code is not used anywhere.
So, should I send a patch for removing the file?

 drivers/media/pci/cx18/cx18-alsa-mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
index 06b066b..cb04c3d 100644
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
@@ -161,7 +161,7 @@ int __init snd_cx18_mixer_create(struct snd_cx18_card *cxsc)
 
 	strlcpy(sc->mixername, "CX23418 Mixer", sizeof(sc->mixername));
 
-	ret = snd_ctl_add(sc, snd_ctl_new1(snd_cx18_mixer_tv_vol, cxsc));
+	ret = snd_ctl_add(sc, snd_ctl_new1(&snd_cx18_mixer_tv_vol, cxsc));
 	if (ret) {
 		CX18_ALSA_WARN("%s: failed to add %s control, err %d\n",
 				__func__, snd_cx18_mixer_tv_vol.name, ret);
-- 
1.9.1
