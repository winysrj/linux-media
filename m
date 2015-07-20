Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51022 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbbGTNA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] usbvision: return valid error in usbvision_register_video()
Date: Mon, 20 Jul 2015 14:59:30 +0200
Message-Id: <1437397178-5013-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't return -1, return a proper error code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index ea67c8c..82a65a4 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1304,6 +1304,8 @@ static void usbvision_unregister_video(struct usb_usbvision *usbvision)
 /* register video4linux devices */
 static int usbvision_register_video(struct usb_usbvision *usbvision)
 {
+	int res = -ENOMEM;
+
 	/* Video Device: */
 	usbvision_vdev_init(usbvision, &usbvision->vdev,
 			      &usbvision_video_template, "USBVision Video");
@@ -1330,7 +1332,7 @@ static int usbvision_register_video(struct usb_usbvision *usbvision)
 		"USBVision[%d]: video_register_device() failed\n",
 			usbvision->nr);
 	usbvision_unregister_video(usbvision);
-	return -1;
+	return res;
 }
 
 /*
-- 
2.1.4

