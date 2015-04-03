Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35117 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbDCM6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:58:31 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] [media] uvcvideo: Set input_dev.stay_runtime_suspended flag
Date: Fri,  3 Apr 2015 14:57:52 +0200
Message-Id: <1428065887-16017-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So that the UVC device can remain runtime suspended when the system goes
into a sleep state, let the input device do the same.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/usb/uvc/uvc_status.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index f552ab9..78647c0 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -39,6 +39,7 @@ static int uvc_input_init(struct uvc_device *dev)
 	input->phys = dev->input_phys;
 	usb_to_input_id(dev->udev, &input->id);
 	input->dev.parent = &dev->intf->dev;
+	input->stay_runtime_suspended = true;
 
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(KEY_CAMERA, input->keybit);
-- 
2.3.4

