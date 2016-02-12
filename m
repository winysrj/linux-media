Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/11] [media] allow overriding the driver name
Date: Fri, 12 Feb 2016 07:44:59 -0200
Message-Id: <e41546d3a262281e9baf45982da6930e493dadf8.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On USB drivers, the dev struct is usually filled with the USB
device. That would mean that the name of the driver specified
by media_device.dev.driver.name would be "usb", instead of the
name of the actual driver that created the media entity.

Add an optional field at the internal struct to allow drivers
to override the driver name.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 6 +++++-
 include/media/media-device.h | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4d1c13de494b..5ebb3cd31345 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -55,7 +55,11 @@ static int media_device_get_info(struct media_device *dev,
 
 	memset(&info, 0, sizeof(info));
 
-	strlcpy(info.driver, dev->dev->driver->name, sizeof(info.driver));
+	if (dev->driver_name[0])
+		strlcpy(info.driver, dev->driver_name, sizeof(info.driver));
+	else
+		strlcpy(info.driver, dev->dev->driver->name, sizeof(info.driver));
+
 	strlcpy(info.model, dev->model, sizeof(info.model));
 	strlcpy(info.serial, dev->serial, sizeof(info.serial));
 	strlcpy(info.bus_info, dev->bus_info, sizeof(info.bus_info));
diff --git a/include/media/media-device.h b/include/media/media-device.h
index d3855898c3fc..165451bc3985 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -268,6 +268,10 @@ struct device;
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
+ * @driver_name: Optional device driver name. If not set, calls to
+ *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
+ *		This is needed for USB drivers for example, as otherwise
+ *		they'll all appear as if the driver name was "usb".
  * @model:	Device model name
  * @serial:	Device serial number (optional)
  * @bus_info:	Unique and stable device location identifier
@@ -303,6 +307,7 @@ struct media_device {
 	struct media_devnode devnode;
 
 	char model[32];
+	char driver_name[32];
 	char serial[40];
 	char bus_info[32];
 	u32 hw_revision;
-- 
2.5.0


