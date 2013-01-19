Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:44555 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3ASQeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:03 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hverkuil@xs4all.nl
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 05/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:08 -0200
Message-Id: <1358613206-4274-5-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_USB_SI470X) || \
     defined(CONFIG_USB_SI470X_MODULE)
with:
 #if IS_ENABLED(CONFIG_USB_SI470X)

This change was made for: CONFIG_USB_SI470X,
CONFIG_I2C_SI470X

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 2f089b4..467e955 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -163,7 +163,7 @@ struct si470x_device {
 	struct completion completion;
 	bool status_rssi_auto_update;	/* Does RSSI get updated automatic? */
 
-#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
+#if IS_ENABLED(CONFIG_USB_SI470X)
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
 	struct usb_interface *intf;
@@ -179,7 +179,7 @@ struct si470x_device {
 	unsigned char hardware_version;
 #endif
 
-#if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
+#if IS_ENABLED(CONFIG_I2C_SI470X)
 	struct i2c_client *client;
 #endif
 };
-- 
1.7.11.7

