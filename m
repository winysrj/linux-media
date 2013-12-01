Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:62645 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3LAVGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:21 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so8514642eaj.1
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/7] em28xx: reduce the polling interval for buttons
Date: Sun,  1 Dec 2013 22:06:54 +0100
Message-Id: <1385932017-2276-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For GPI-connected buttons without (hardware) debouncing, the polling interval 
needs to be reduced to detect button presses properly.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ebc5387..c8f7ecb 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -31,7 +31,7 @@
 #include "em28xx.h"
 
 #define EM28XX_SNAPSHOT_KEY KEY_CAMERA
-#define EM28XX_BUTTONS_QUERY_INTERVAL 500
+#define EM28XX_BUTTONS_QUERY_INTERVAL 100
 
 static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
-- 
1.7.10.4

