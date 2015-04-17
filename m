Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36170 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbbDQPZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 11:25:51 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] [media] uvcvideo: Remain runtime-suspended at sleeps
Date: Fri, 17 Apr 2015 17:24:50 +0200
Message-Id: <1429284290-25153-3-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1429284290-25153-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1429284290-25153-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the system goes to sleep and afterwards resumes, a significant
amount of time is spent suspending and resuming devices that were
already runtime-suspended.

By setting the power.force_direct_complete flag, the PM core will ignore
the state of descendant devices and the device will be let in
runtime-suspend.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5970dd6..ae75a70 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1945,6 +1945,8 @@ static int uvc_probe(struct usb_interface *intf,
 			"supported.\n", ret);
 	}
 
+	intf->dev.parent->power.force_direct_complete = true;
+
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
 	return 0;
-- 
2.3.5

