Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:37759 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJCD6y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 23:58:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: TDA1997x: select CONFIG_HDMI
Date: Tue,  2 Oct 2018 23:12:43 +0200
Message-Id: <20181002211324.2696685-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_HDMI, we get a link error for this driver:

drivers/media/i2c/tda1997x.o: In function `tda1997x_parse_infoframe':
tda1997x.c:(.text+0x2195): undefined reference to `hdmi_infoframe_unpack'
tda1997x.c:(.text+0x21b6): undefined reference to `hdmi_infoframe_log'
drivers/media/i2c/tda1997x.o: In function `tda1997x_log_infoframe':
tda1997x.c:(.text.unlikely+0x13d3): undefined reference to `hdmi_infoframe_unpack'
tda1997x.c:(.text.unlikely+0x1426): undefined reference to `hdmi_infoframe_log'

All other drivers in this directory that use HDMI select CONFIG_HDMI,
so do the same here:

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index bcf0686190e0..d958b7fd9e73 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -61,6 +61,7 @@ config VIDEO_TDA1997X
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on SND_SOC
 	select SND_PCM
+	select HDMI
 	---help---
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
-- 
2.18.0
