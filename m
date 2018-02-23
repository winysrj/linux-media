Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:53451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbeBWNOJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 08:14:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Tim Harvey <tharvey@gateworks.com>, Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: TDA1997x: add CONFIG_SND dependency
Date: Fri, 23 Feb 2018 14:13:26 +0100
Message-Id: <20180223131356.979530-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_SND, we get a link error:

ERROR: "snd_soc_register_codec" [drivers/media/i2c/tda1997x.ko] undefined!
ERROR: "snd_soc_unregister_codec" [drivers/media/i2c/tda1997x.ko] undefined!
ERROR: "snd_pcm_hw_constraint_minmax" [drivers/media/i2c/tda1997x.ko] undefined!

This adds the same Kconfig dependency that we have in other
media drivers, using 'select SND_PCM' to ensure that we have
can call snd_pcm_hw_constraint_minmax, while depending on
CONFIG_SND_SOC for registering the codec.

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 94e32d75d632..a44e8c36f13c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -59,6 +59,8 @@ config VIDEO_TDA9840
 config VIDEO_TDA1997X
 	tristate "NXP TDA1997x HDMI receiver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on SND_SOC
+	select SND_PCM
 	---help---
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
-- 
2.9.0
