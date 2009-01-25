Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f26.google.com ([209.85.220.26]:59220 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAYXRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 18:17:10 -0500
Received: by fxm7 with SMTP id 7so2278456fxm.13
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2009 15:17:08 -0800 (PST)
Subject: v4l: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, gregkh <gregkh@suse.de>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 00:00:16 +0100
Message-Id: <1232924416.2924.26.camel@nga>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: v4l: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/media/radio/radio-tea5764.c |    3 ++-
 drivers/media/video/v4l2-device.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -298,7 +298,8 @@ static int vidioc_querycap(struct file *
 
 	strlcpy(v->driver, dev->dev.driver->name, sizeof(v->driver));
 	strlcpy(v->card, dev->name, sizeof(v->card));
-	snprintf(v->bus_info, sizeof(v->bus_info), "I2C:%s", dev->dev.bus_id);
+	snprintf(v->bus_info, sizeof(v->bus_info),
+		 "I2C:%s", dev_name(&dev->dev));
 	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -34,7 +34,7 @@ int v4l2_device_register(struct device *
 	spin_lock_init(&v4l2_dev->lock);
 	v4l2_dev->dev = dev;
 	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %s",
-			dev->driver->name, dev->bus_id);
+			dev->driver->name, dev_name(dev));
 	dev_set_drvdata(dev, v4l2_dev);
 	return 0;
 }

