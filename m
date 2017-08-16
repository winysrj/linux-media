Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38346 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbdHPJSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 05:18:01 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, andrey.utkin@corp.bluecherry.net,
        ismael@iodev.co.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] [media] cx88: make snd_kcontrol_new const
Date: Wed, 16 Aug 2017 14:47:04 +0530
Message-Id: <1502875025-3224-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
References: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it only passed as the 1st argument to the function
snd_ctl_new1, which is of type const.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx88/cx88-alsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index c81fe46..9740326 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -799,7 +799,7 @@ static int snd_cx88_alc_put(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static struct snd_kcontrol_new snd_cx88_alc_switch = {
+static const struct snd_kcontrol_new snd_cx88_alc_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Line-In ALC Switch",
 	.info = snd_ctl_boolean_mono_info,
-- 
1.9.1
