Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46823 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbbGTNBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:01:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/12] usbvision: move init code to probe()
Date: Mon, 20 Jul 2015 14:59:38 +0200
Message-Id: <1437397178-5013-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These things are only initialized if you start streaming video, but
they are also used in the disconnect function. So just init them
always during probe time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-core.c  | 4 ----
 drivers/media/usb/usbvision/usbvision-video.c | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 9f4e630..dc3b4d5 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1791,10 +1791,6 @@ int usbvision_frames_alloc(struct usb_usbvision *usbvision, int number_of_frames
 		usbvision->num_frames--;
 	}
 
-	spin_lock_init(&usbvision->queue_lock);
-	init_waitqueue_head(&usbvision->wait_frame);
-	init_waitqueue_head(&usbvision->wait_stream);
-
 	/* Allocate all buffers */
 	for (i = 0; i < usbvision->num_frames; i++) {
 		usbvision->frame[i].index = i;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 6ad3d56..b693206 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1520,6 +1520,10 @@ static int usbvision_probe(struct usb_interface *intf,
 
 	usbvision->nr = usbvision_nr++;
 
+	spin_lock_init(&usbvision->queue_lock);
+	init_waitqueue_head(&usbvision->wait_frame);
+	init_waitqueue_head(&usbvision->wait_stream);
+
 	usbvision->have_tuner = usbvision_device_data[model].tuner;
 	if (usbvision->have_tuner)
 		usbvision->tuner_type = usbvision_device_data[model].tuner_type;
-- 
2.1.4

