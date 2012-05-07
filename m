Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab2EGTUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 17/23] gspca: Call sd_stop0 on disconnect
Date: Mon,  7 May 2012 21:01:28 +0200
Message-Id: <1336417294-4566-18-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is necessary to ensure that worker-threads accessing the device
are stopped before our disconnect handler returns.

This causes a problem with stream_off calling sd_stop0 a second time
when the device handle is closed. This is fixed by setting
gscpa_dev->streaming to 0 on disconnect.

Note that now stream_off will never be called on a disconnected device,
and the present check can thus be removed from stream_off.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index dc62829..8c344c1 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -595,16 +595,12 @@ static int gspca_set_alt0(struct gspca_dev *gspca_dev)
 static void gspca_stream_off(struct gspca_dev *gspca_dev)
 {
 	gspca_dev->streaming = 0;
-	if (gspca_dev->present) {
-		if (gspca_dev->sd_desc->stopN)
-			gspca_dev->sd_desc->stopN(gspca_dev);
-		destroy_urbs(gspca_dev);
-		gspca_input_destroy_urb(gspca_dev);
-		gspca_set_alt0(gspca_dev);
-		gspca_input_create_urb(gspca_dev);
-	}
-
-	/* always call stop0 to free the subdriver's resources */
+	if (gspca_dev->sd_desc->stopN)
+		gspca_dev->sd_desc->stopN(gspca_dev);
+	destroy_urbs(gspca_dev);
+	gspca_input_destroy_urb(gspca_dev);
+	gspca_set_alt0(gspca_dev);
+	gspca_input_create_urb(gspca_dev);
 	if (gspca_dev->sd_desc->stop0)
 		gspca_dev->sd_desc->stop0(gspca_dev);
 	PDEBUG(D_STREAM, "stream off OK");
@@ -2370,7 +2366,6 @@ void gspca_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 	gspca_dev->dev = NULL;
 	gspca_dev->present = 0;
-	wake_up_interruptible(&gspca_dev->wq);
 	destroy_urbs(gspca_dev);
 
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
@@ -2381,6 +2376,11 @@ void gspca_disconnect(struct usb_interface *intf)
 		input_unregister_device(input_dev);
 	}
 #endif
+	/* Free subdriver's streaming resources / stop sd workqueue(s) */
+	if (gspca_dev->sd_desc->stop0 && gspca_dev->streaming)
+		gspca_dev->sd_desc->stop0(gspca_dev);
+	gspca_dev->streaming = 0;
+	wake_up_interruptible(&gspca_dev->wq);
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
 	video_unregister_device(&gspca_dev->vdev);
-- 
1.7.10

