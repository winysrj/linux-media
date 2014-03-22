Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37070 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaCVNAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 09:00:34 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so2718779eek.24
        for <linux-media@vger.kernel.org>; Sat, 22 Mar 2014 06:00:33 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/5] em28xx: fix i2c_set_adapdata() call in em28xx_i2c_register()
Date: Sat, 22 Mar 2014 14:01:00 +0100
Message-Id: <1395493263-2158-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index ba6433c..04e8577 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -939,7 +939,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	dev->i2c_bus[bus].algo_type = algo_type;
 	dev->i2c_bus[bus].dev = dev;
 	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
-	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
+	i2c_set_adapdata(&dev->i2c_adap[bus], dev);
 
 	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
-- 
1.8.4.5

