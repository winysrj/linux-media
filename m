Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59086 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbcLILmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:42:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s5k4ecgx: select CRC32 helper
Date: Fri,  9 Dec 2016 12:41:29 +0100
Message-Id: <20161209114225.3645960-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A rare randconfig build failure shows up in this driver when
the CRC32 helper is not there:

drivers/media/built-in.o: In function `s5k4ecgx_s_power':
s5k4ecgx.c:(.text+0x9eb4): undefined reference to `crc32_le'

This adds the 'select' that all other users of this function have.

Fixes: 8b99312b7214 ("[media] Add v4l2 subdev driver for S5K4ECGX sensor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b31fa6fae009..b979ea148251 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -655,6 +655,7 @@ config VIDEO_S5K6A3
 config VIDEO_S5K4ECGX
         tristate "Samsung S5K4ECGX sensor support"
         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select CRC32
         ---help---
           This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
           camera sensor with an embedded SoC image signal processor.
-- 
2.9.0

