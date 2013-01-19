Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34100 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3ASQe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:56 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: jarod@redhat.com, tralph@mythtv.org, peter.senna@gmail.com,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 22/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:24 -0200
Message-Id: <1358613206-4274-21-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_I2C) || \
     defined(CONFIG_I2C_MODULE)
with:
 #if IS_ENABLED(CONFIG_I2C)

This change was made for: CONFIG_I2C

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 84dc26f..5c61935 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -391,7 +391,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if IS_ENABLED(CONFIG_I2C)
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
@@ -419,7 +419,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	return 0;
 
 reg_fail:
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if IS_ENABLED(CONFIG_I2C)
 	i2c_del_adapter(&dev->i2c_adapter);
 #endif
 error:
@@ -451,7 +451,7 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 	mutex_lock(&dev->io_mutex);
 	hdpvr_cancel_queue(dev);
 	mutex_unlock(&dev->io_mutex);
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if IS_ENABLED(CONFIG_I2C)
 	i2c_del_adapter(&dev->i2c_adapter);
 #endif
 	video_unregister_device(dev->video_dev);
-- 
1.7.11.7

