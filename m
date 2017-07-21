Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39909 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753727AbdGUJCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 05:02:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] uvc: don't set driver_version anymore
Date: Fri, 21 Jul 2017 11:02:33 +0200
Message-Id: <20170721090234.6501-4-hverkuil@xs4all.nl>
In-Reply-To: <20170721090234.6501-1-hverkuil@xs4all.nl>
References: <20170721090234.6501-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is now set by media_device_init.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 70842c5af05b..4f463bf2b877 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2096,7 +2096,6 @@ static int uvc_probe(struct usb_interface *intf,
 			sizeof(dev->mdev.serial));
 	strcpy(dev->mdev.bus_info, udev->devpath);
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	dev->mdev.driver_version = LINUX_VERSION_CODE;
 	media_device_init(&dev->mdev);
 
 	dev->vdev.mdev = &dev->mdev;
-- 
2.13.2
