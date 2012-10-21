Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57147 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2JURx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:26 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1632849wgb.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:25 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 06/23] em28xx: remove obsolete #define EM28XX_URB_TIMEOUT
Date: Sun, 21 Oct 2012 19:52:11 +0300
Message-Id: <1350838349-14763-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It isn't used anymore and uses constants which no longer exist.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h |    4 ----
 1 Datei geändert, 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 5ef0a7a..c28e47f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -186,10 +186,6 @@
 			Interval: 125us
 */
 
-/* time to wait when stopping the isoc transfer */
-#define EM28XX_URB_TIMEOUT \
-			msecs_to_jiffies(EM28XX_NUM_BUFS * EM28XX_NUM_PACKETS)
-
 /* time in msecs to wait for i2c writes to finish */
 #define EM2800_I2C_WRITE_TIMEOUT 20
 
-- 
1.7.10.4

