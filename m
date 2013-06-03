Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48027 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3FCSKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 14:10:36 -0400
Received: by mail-ea0-f169.google.com with SMTP id h15so1539277eak.14
        for <linux-media@vger.kernel.org>; Mon, 03 Jun 2013 11:10:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] em28xx: move snapshot button bit definition for reg 0x0C from em28xx-input.c to em28xx.h
Date: Mon,  3 Jun 2013 20:12:04 +0200
Message-Id: <1370283125-2231-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |    1 -
 drivers/media/usb/em28xx/em28xx-reg.h   |    3 ++-
 2 Dateien geändert, 2 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 466b19d..ea181e4 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -32,7 +32,6 @@
 
 #define EM28XX_SNAPSHOT_KEY KEY_CAMERA
 #define EM28XX_SBUTTON_QUERY_INTERVAL 500
-#define EM28XX_R0C_USBSUSP_SNAPSHOT 0x20
 
 static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index af39ddb..a88906c 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -68,7 +68,8 @@
 
 
 #define EM28XX_R0A_CHIPID	0x0a
-#define EM28XX_R0C_USBSUSP	0x0c	/* */
+#define EM28XX_R0C_USBSUSP	0x0c
+#define   EM28XX_R0C_USBSUSP_SNAPSHOT	0x20 /* 1=button pressed, needs reset */
 
 #define EM28XX_R0E_AUDIOSRC	0x0e
 #define EM28XX_R0F_XCLK	0x0f
-- 
1.7.10.4

