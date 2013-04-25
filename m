Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62555 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3DYOrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 10:47:14 -0400
Received: by mail-bk0-f45.google.com with SMTP id j4so1289205bkw.32
        for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 07:47:13 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] s5c73m3: fix indentation of the help section in Kconfig
Date: Thu, 25 Apr 2013 16:46:38 +0200
Message-Id: <1366901198-32030-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'help' section of the Kconfig entry for this driver is missing a couple of
extra spaces.
The effect is an error running 'make xconfig' (seen on the old 2.6.32 kernel
from Ubuntu 10.04 when compiling the latest media-build tree):

/lib/modules/2.6.32-46-generic-pae/build/scripts/kconfig/qconf ./Kconfig
./Kconfig:4985: unknown option "This"
./Kconfig:4986: unknown option "8"
make[1]: *** [xconfig] Errore 1

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/i2c/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 9e7ce8b..f981d50 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -559,8 +559,8 @@ config VIDEO_S5C73M3
 	tristate "Samsung S5C73M3 sensor support"
 	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
-	This is a V4L2 sensor-level driver for Samsung S5C73M3
-	8 Mpixel camera.
+	  This is a V4L2 sensor-level driver for Samsung S5C73M3
+	  8 Mpixel camera.
 
 comment "Flash devices"
 
-- 
1.8.2.1

