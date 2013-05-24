Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63508 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3EXQcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 12:32:39 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so2729924eei.20
        for <linux-media@vger.kernel.org>; Fri, 24 May 2013 09:32:38 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/2] em28xx: add register defines for em25xx/em276x/7x/8x GPIO registers
Date: Fri, 24 May 2013 18:34:07 +0200
Message-Id: <1369413248-7028-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em25xx/em276x/7x/8x provides 3 GPIO register sets,
each of them consisting of separate read and a write registers.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-reg.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 622871d..17bdb78 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -210,6 +210,14 @@
 #define EM2874_TS2_FILTER_ENABLE  (1 << 5)
 #define EM2874_TS2_NULL_DISCARD   (1 << 6)
 
+/* em25xx, em276x/7x/8x GPIO registers */
+#define EM25XX_R80_GPIO_P0_W    0x80
+#define EM25XX_R81_GPIO_P1_W    0x81
+#define EM25XX_R83_GPIO_P3_W    0x83
+#define EM25XX_R84_GPIO_P0_R    0x84
+#define EM25XX_R85_GPIO_P1_R    0x85
+#define EM25XX_R87_GPIO_P3_R    0x87
+
 /* register settings */
 #define EM2800_AUDIO_SRC_TUNER  0x0d
 #define EM2800_AUDIO_SRC_LINE   0x0c
-- 
1.8.1.2

