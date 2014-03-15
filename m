Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaCOJfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 05:35:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] Sensoray 2255 uses videobuf2
Date: Sat, 15 Mar 2014 10:35:39 +0100
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"sensoray-dev" <linux-dev@sensoray.com>,
	Dean Anderson <linux-dev@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403151035.39910.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 340a30c514 "s2255drv: upgrade to videobuf2" changed the API
used by the s2255 driver, but did not modify the Kconfig statement,
which can lead to build errors when no other driver already uses
VIDEOBUF2_VMALLOC. This patch does the necessary Kconfig change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/usb/s2255/Kconfig b/drivers/media/usb/s2255/Kconfig
index 7e8ee1f..8c3fcee 100644
--- a/drivers/media/usb/s2255/Kconfig
+++ b/drivers/media/usb/s2255/Kconfig
@@ -1,7 +1,7 @@
 config USB_S2255
 	tristate "USB Sensoray 2255 video capture device"
 	depends on VIDEO_V4L2
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	default n
 	help
 	  Say Y here if you want support for the Sensoray 2255 USB device.
