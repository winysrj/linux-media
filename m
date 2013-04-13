Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36063 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3DMJrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 05:47:43 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so1591901ead.0
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 02:47:41 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/3] em28xx: add register defines for em25xx/em276x/7x/8x GPIO registers
Date: Sat, 13 Apr 2013 11:48:40 +0200
Message-Id: <1365846521-3127-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em25xx/em276x/7x/8x provides 3 GPIO register sets,
each of them consisting of separate read and a write registers.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-reg.h |    8 ++++++++
 1 Datei geändert, 8 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 622871d..ebc5663 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -195,6 +195,14 @@
 #define EM2874_R5F_TS_ENABLE    0x5f
 #define EM2874_R80_GPIO         0x80
 
+/* em25xx, em276x/7x/8x GPIO registers */
+#define EM25XX_R80_GPIO_P0_W    0x80
+#define EM25XX_R81_GPIO_P1_W    0x81
+#define EM25XX_R83_GPIO_P3_W    0x83
+#define EM25XX_R84_GPIO_P0_R    0x84
+#define EM25XX_R85_GPIO_P1_R    0x85
+#define EM25XX_R87_GPIO_P3_R    0x87
+
 /* em2874 IR config register (0x50) */
 #define EM2874_IR_NEC           0x00
 #define EM2874_IR_NEC_NO_PARITY 0x01
-- 
1.7.10.4

