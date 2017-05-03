Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48393
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754931AbdECCM2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 22:12:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 1/2] em28xx: Ignore errors while reading from eeprom
Date: Tue,  2 May 2017 23:12:22 -0300
Message-Id: <15f3ba8371344a8dac830797216c06e9c5524a81.1493776983.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1493776983.git.mchehab@s-opensource.com>
References: <cover.1493776983.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1493776983.git.mchehab@s-opensource.com>
References: <cover.1493776983.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing support for Terratec H6 rev. 2, it was noticed
that reading from eeprom there causes a timeout error.

Apparently, this is due to the need of properly setting GPIOs.

In any case, the driver doesn't really require eeprom reading
to succeed, as this is currently used only for debug.

So, Ignore such errors.

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
