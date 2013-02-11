Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59892 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab3BKSHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 13:07:15 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so2848622eaa.23
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 10:07:14 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: bump driver version to 0.2.0
Date: Mon, 11 Feb 2013 19:07:55 +0100
Message-Id: <1360606075-3403-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver has changed much, especially since kernel 3.8.
So it's time to bump the driver version.

Changes since kernel 3.8:
- converted the driver to videobuf2
- converted the driver to the v4l2-ctrl framework
- added USB bulk transfer support
- use USB bulk transfers by default for webcams (allows streaming from multiple devices at the same time)
- added image quality bridge controls: contrast, brightness, saturation, blue balance, red balance, sharpness
- removed dependency from module ir-kbd-i2c
- cleaned up the frame data processing code
- removed some unused/obsolete code
- made remote controls of devices with external (i2c) receiver/decoder work again
- fixed audio over USB for device "Terratec Cinergy 250"
- several v4l2 compliance fixes and improvements (including fixes for ioctls enabling/disabling)
- lots of further bug fixes and code improvements

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 48b937d..93fc620 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -52,7 +52,7 @@
 
 #define DRIVER_DESC         "Empia em28xx based USB video device driver"
 
-#define EM28XX_VERSION "0.1.3"
+#define EM28XX_VERSION "0.2.0"
 
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
-- 
1.7.10.4

