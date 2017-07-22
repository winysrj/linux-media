Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42510 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755237AbdGVLbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 5/6] media-device: remove driver_version
Date: Sat, 22 Jul 2017 13:30:56 +0200
Message-Id: <20170722113057.45202-6-hverkuil@xs4all.nl>
In-Reply-To: <20170722113057.45202-1-hverkuil@xs4all.nl>
References: <20170722113057.45202-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since the driver_version field in struct media_device is no longer
used, just remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 3 ---
 include/media/media-device.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7ff8e2d5bb07..979e4307d248 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -833,8 +833,6 @@ void media_device_pci_init(struct media_device *mdev,
 	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
 			    | pci_dev->subsystem_device;
 
-	mdev->driver_version = LINUX_VERSION_CODE;
-
 	media_device_init(mdev);
 }
 EXPORT_SYMBOL_GPL(media_device_pci_init);
@@ -862,7 +860,6 @@ void __media_device_usb_init(struct media_device *mdev,
 		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
 	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
 
 	media_device_init(mdev);
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 7ae200d89a9f..bcc6ec434f1f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -68,7 +68,6 @@ struct media_device_ops {
  * @serial:	Device serial number (optional)
  * @bus_info:	Unique and stable device location identifier
  * @hw_revision: Hardware device revision
- * @driver_version: Device driver version
  * @topology_version: Monotonic counter for storing the version of the graph
  *		topology. Should be incremented each time the topology changes.
  * @id:		Unique ID used on the last registered graph object
@@ -134,7 +133,6 @@ struct media_device {
 	char serial[40];
 	char bus_info[32];
 	u32 hw_revision;
-	u32 driver_version;
 
 	u64 topology_version;
 
-- 
2.13.2
