Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbZCYA3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: [PATCH 17/61] v4l: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:21 -0700
Message-Id: <1237940825-22904-17-git-send-email-gregkh@suse.de>
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/media/radio/radio-tea5764.c |    3 ++-
 drivers/media/video/v4l2-device.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 4d35308..3936238 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -298,7 +298,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	strlcpy(v->driver, dev->dev.driver->name, sizeof(v->driver));
 	strlcpy(v->card, dev->name, sizeof(v->card));
-	snprintf(v->bus_info, sizeof(v->bus_info), "I2C:%s", dev->dev.bus_id);
+	snprintf(v->bus_info, sizeof(v->bus_info),
+		 "I2C:%s", dev_name(&dev->dev));
 	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index cf9d4c7..8a4b74f 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -34,7 +34,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 	spin_lock_init(&v4l2_dev->lock);
 	v4l2_dev->dev = dev;
 	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %s",
-			dev->driver->name, dev->bus_id);
+			dev->driver->name, dev_name(dev));
 	dev_set_drvdata(dev, v4l2_dev);
 	return 0;
 }
-- 
1.6.2

