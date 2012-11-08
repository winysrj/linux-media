Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:24 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:23 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 06/21] em28xx: remove obsolete #define EM28XX_URB_TIMEOUT
Date: Thu,  8 Nov 2012 20:11:38 +0200
Message-Id: <1352398313-3698-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
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
index 17310e6..6773ca8 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -187,10 +187,6 @@
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

