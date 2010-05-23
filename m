Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:51785 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924Ab0EWSbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:31:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/5] tm6000: bugfix select moduls
Date: Sun, 23 May 2010 20:29:24 +0200
Message-Id: <1274639366-2613-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/Kconfig b/drivers/staging/tm6000/Kconfig
index 5fe759c..3657e33 100644
--- a/drivers/staging/tm6000/Kconfig
+++ b/drivers/staging/tm6000/Kconfig
@@ -2,7 +2,8 @@ config VIDEO_TM6000
 	tristate "TV Master TM5600/6000/6010 driver"
 	depends on VIDEO_DEV && I2C && INPUT && USB && EXPERIMENTAL
 	select VIDEO_TUNER
-	select TUNER_XC2028
+	select MEDIA_TUNER_XC2028
+	select MEDIA_TUNER_XC5000
 	select VIDEOBUF_VMALLOC
 	help
 	  Support for TM5600/TM6000/TM6010 USB Device
-- 
1.7.0.3

