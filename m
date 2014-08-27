Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42643 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbaH0PRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 11:17:47 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] usb: gadget: f_uvc fix transition to video_ioctl2
Date: Wed, 27 Aug 2014 17:16:38 +0200
Message-id: <1409152598-21046-1-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC video node is a TX device from the point of view of the gadget,
so we cannot rely on the video struct being filled with zeros, because
VFL_DIR_TX is actually 1.

Suggested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/usb/gadget/function/f_uvc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 5209105..95dc1c6 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -411,6 +411,7 @@ uvc_register_video(struct uvc_device *uvc)
 	video->fops = &uvc_v4l2_fops;
 	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
 	video->release = video_device_release;
+	video->vfl_dir = VFL_DIR_TX;
 	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
 
 	uvc->vdev = video;
-- 
1.9.1

