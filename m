Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:55229 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdGQOai (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 10:30:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] [media] usbvision-i2c: fix format overflow warning
Date: Mon, 17 Jul 2017 16:29:58 +0200
Message-Id: <20170717143024.862161-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7 notices that we copy a fixed length string into another
string of the same size, with additional characters:

drivers/media/usb/usbvision/usbvision-i2c.c: In function 'usbvision_i2c_register':
drivers/media/usb/usbvision/usbvision-i2c.c:190:36: error: '%d' directive writing between 1 and 11 bytes into a region of size between 0 and 47 [-Werror=format-overflow=]
  sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
                                    ^~~~~~~~~~
drivers/media/usb/usbvision/usbvision-i2c.c:190:2: note: 'sprintf' output between 4 and 76 bytes into a destination of size 48

Using snprintf() makes the code more robust in general, but will still
trigger a possible warning about truncation in the string.
We know this won't happen as the template name is always "usbvision", so
we can easily avoid the warning as well by using this as the format string
directly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use snprintf()
---
 drivers/media/usb/usbvision/usbvision-i2c.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
index fdf6b6e285da..38749331e7df 100644
--- a/drivers/media/usb/usbvision/usbvision-i2c.c
+++ b/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -187,8 +187,9 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
 
 	usbvision->i2c_adap = i2c_adap_template;
 
-	sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
-		usbvision->dev->bus->busnum, usbvision->dev->devpath);
+	snprintf(usbvision->i2c_adap.name, sizeof(usbvision->i2c_adap.name),
+		 "usbvision-%d-%s",
+		 usbvision->dev->bus->busnum, usbvision->dev->devpath);
 	PDEBUG(DBG_I2C, "Adaptername: %s", usbvision->i2c_adap.name);
 	usbvision->i2c_adap.dev.parent = &usbvision->dev->dev;
 
-- 
2.9.0
