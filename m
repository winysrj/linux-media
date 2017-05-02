Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47252
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751488AbdEBTQy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 15:16:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 1/2] em28xx: Ignore errors while reading from eeprom
Date: Tue,  2 May 2017 16:16:48 -0300
Message-Id: <383deb4911c305a20bfab4c9ea24aa2fb4368599.1493752606.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some newer devices (newer Terratec H6 rev. 2), reading
from eeprom fails.

Ignore such errors, as we don't really need it to succeed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8c472d5adb50..60b195c157b8 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -982,8 +982,6 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 			dev_err(&dev->intf->dev,
 				"%s: em28xx_i2_eeprom failed! retval [%d]\n",
 				__func__, retval);
-
-			return retval;
 		}
 	}
 
-- 
2.9.3
