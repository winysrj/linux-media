Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33702 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbbDCM6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:58:33 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] [media] uvcvideo: Enable runtime PM of descendant devices
Date: Fri,  3 Apr 2015 14:57:53 +0200
Message-Id: <1428065887-16017-5-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So UVC devices can remain runtime-suspended when the system goes into a
sleep state, they and all of their descendant devices need to have
runtime PM enable.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cf27006..687e5fb 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1855,6 +1855,15 @@ static int uvc_register_chains(struct uvc_device *dev)
 	return 0;
 }
 
+static int uvc_pm_runtime_enable(struct device *dev, void *data)
+{
+	pm_runtime_enable(dev);
+
+	device_for_each_child(dev, NULL, uvc_pm_runtime_enable);
+
+	return 0;
+}
+
 /* ------------------------------------------------------------------------
  * USB probe, disconnect, suspend and resume
  */
@@ -1959,6 +1968,8 @@ static int uvc_probe(struct usb_interface *intf,
 			"supported.\n", ret);
 	}
 
+	device_for_each_child(&dev->intf->dev, NULL, uvc_pm_runtime_enable);
+
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
 	return 0;
-- 
2.3.4

