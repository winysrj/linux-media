Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39040 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaEKU27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 16:28:59 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so4069205eek.8
        for <linux-media@vger.kernel.org>; Sun, 11 May 2014 13:28:58 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: remove the i2c_set_adapdata() call in em28xx_i2c_register()
Date: Sun, 11 May 2014 22:29:07 +0200
Message-Id: <1399840147-2704-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is no longer needed since nobody is calling i2c_get_adapdata() anymore.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index ba6433c..04e8577 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -939,7 +939,6 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	dev->i2c_bus[bus].algo_type = algo_type;
 	dev->i2c_bus[bus].dev = dev;
 	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
-	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
 
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
-- 
1.8.4.5

