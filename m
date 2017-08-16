Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33916 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdHPJSI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 05:18:08 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, andrey.utkin@corp.bluecherry.net,
        ismael@iodev.co.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/2] [media] solo6x10: make snd_kcontrol_new const
Date: Wed, 16 Aug 2017 14:47:05 +0530
Message-Id: <1502875025-3224-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
References: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used during a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 3ca9470..81be1b8 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -319,7 +319,7 @@ static int snd_solo_capture_volume_put(struct snd_kcontrol *kcontrol,
 	return 1;
 }
 
-static struct snd_kcontrol_new snd_solo_capture_volume = {
+static const struct snd_kcontrol_new snd_solo_capture_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Capture Volume",
 	.info = snd_solo_capture_volume_info,
-- 
1.9.1
