Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57260 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3AMOOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:14:44 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so1539147eek.18
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:14:42 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/3] em28xx: add missing IR RC slave address to the list of known i2c devices
Date: Sun, 13 Jan 2013 15:15:08 +0100
Message-Id: <1358086508-6902-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9ae8f60..8532c1d 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -534,6 +534,7 @@ static struct i2c_client em28xx_client_template = {
  * incomplete list of known devices
  */
 static char *i2c_devs[128] = {
+	[0x3e >> 1] = "remote IR sensor",
 	[0x4a >> 1] = "saa7113h",
 	[0x52 >> 1] = "drxk",
 	[0x60 >> 1] = "remote IR sensor",
-- 
1.7.10.4

