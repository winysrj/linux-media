Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:62932 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbcAZOMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:12:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] [media] em28xx: only use mt9v011 if camera support is enabled
Date: Tue, 26 Jan 2016 15:09:59 +0100
Message-Id: <1453817424-3080054-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In randconfig builds that select VIDEO_EM28XX_V4L2 and
MEDIA_SUBDRV_AUTOSELECT, but not MEDIA_CAMERA_SUPPORT, we get
a Kconfig warning:

 warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT)

This avoids the warning by making that 'select' conditional on
MEDIA_CAMERA_SUPPORT. Alternatively we could mark EM28XX as
'depends on MEDIA_CAMERA_SUPPORT', but it does not seem to
have any real dependency on that itself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/em28xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index e382210c4ada..75323f5efd0f 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -11,7 +11,7 @@ config VIDEO_EM28XX_V4L2
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
-	select VIDEO_MT9V011 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_MT9V011 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
 
 	---help---
 	  This is a video4linux driver for Empia 28xx based TV cards.
-- 
2.7.0

