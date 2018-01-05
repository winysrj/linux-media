Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57450 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbeAEJoW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 04:44:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: cobalt: select CONFIG_SND_PCM
Date: Fri,  5 Jan 2018 10:44:04 +0100
Message-Id: <20180105094415.2839559-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cobalt sound driver has a dependency on ALSA, but not
on the PCM helper code, so this can lead to an extremely
rare link error in randconfig builds:

ERROR: "snd_pcm_period_elapsed" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "_snd_pcm_stream_lock_irqsave" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_stream_unlock_irqrestore" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_new" [drivers/media/pci/cobalt/cobalt.ko] undefined!

The other audio drivers select 'SND_PCM' for this, so let's
do the same.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/cobalt/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index 70343829a125..aa35cbc0a904 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_COBALT
 	depends on SND
 	depends on MTD
 	select I2C_ALGOBIT
+	select SND_PCM
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
 	select VIDEO_ADV7842
-- 
2.9.0
