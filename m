Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34757 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdHHRVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 13:21:25 -0400
Received: by mail-wm0-f68.google.com with SMTP id x64so4217240wmg.1
        for <linux-media@vger.kernel.org>; Tue, 08 Aug 2017 10:21:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@kernel.org, jasmin@anw.at
Subject: [PATCH] [media_build] Fixup api_version.patch after version field removals
Date: Tue,  8 Aug 2017 19:21:21 +0200
Message-Id: <20170808172121.10932-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes prepatching wrt

  commit 2bd8682375f3 ("media: media-device: remove driver_version"

and

  commit 71269bf607bc ("media: uvc: don't set driver_version")

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 backports/api_version.patch | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/backports/api_version.patch b/backports/api_version.patch
index 892bcbb..7bf3723 100644
--- a/backports/api_version.patch
+++ b/backports/api_version.patch
@@ -11,41 +11,6 @@ index 0860fb458757..60fd48214142 100644
  	if (copy_to_user(parg, &caps, sizeof(caps)))
  		return -EFAULT;
  	return 0;
-diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
-index 760e3e424e23..b1887870172d 100644
---- a/drivers/media/media-device.c
-+++ b/drivers/media/media-device.c
-@@ -834,7 +834,7 @@ void media_device_pci_init(struct media_device *mdev,
- 	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
- 			    | pci_dev->subsystem_device;
- 
--	mdev->driver_version = LINUX_VERSION_CODE;
-+	mdev->driver_version = V4L2_VERSION;
- 
- 	media_device_init(mdev);
- }
-@@ -863,7 +863,7 @@ void __media_device_usb_init(struct media_device *mdev,
- 		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
- 	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
- 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
--	mdev->driver_version = LINUX_VERSION_CODE;
-+	mdev->driver_version = V4L2_VERSION;
- 
- 	media_device_init(mdev);
- }
-diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
-index 70842c5af05b..2b719f80de15 100644
---- a/drivers/media/usb/uvc/uvc_driver.c
-+++ b/drivers/media/usb/uvc/uvc_driver.c
-@@ -2096,7 +2096,7 @@ static int uvc_probe(struct usb_interface *intf,
- 			sizeof(dev->mdev.serial));
- 	strcpy(dev->mdev.bus_info, udev->devpath);
- 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
--	dev->mdev.driver_version = LINUX_VERSION_CODE;
-+	dev->mdev.driver_version = V4L2_VERSION;
- 	media_device_init(&dev->mdev);
- 
- 	dev->vdev.mdev = &dev->mdev;
 diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
 index 4f27cfa134a1..e0fb14c851d5 100644
 --- a/drivers/media/v4l2-core/v4l2-ioctl.c
-- 
2.13.0
