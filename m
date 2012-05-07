Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2EGTUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 18/23] gspca: Set gspca_dev->usb_err to 0 at the begin of gspca_stream_off
Date: Mon,  7 May 2012 21:01:29 +0200
Message-Id: <1336417294-4566-19-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a small cleanup.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 8c344c1..142fd5f 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -595,6 +595,7 @@ static int gspca_set_alt0(struct gspca_dev *gspca_dev)
 static void gspca_stream_off(struct gspca_dev *gspca_dev)
 {
 	gspca_dev->streaming = 0;
+	gspca_dev->usb_err = 0;
 	if (gspca_dev->sd_desc->stopN)
 		gspca_dev->sd_desc->stopN(gspca_dev);
 	destroy_urbs(gspca_dev);
@@ -1331,10 +1332,8 @@ static int dev_close(struct file *file)
 
 	/* if the file did the capture, free the streaming resources */
 	if (gspca_dev->capt_file == file) {
-		if (gspca_dev->streaming) {
-			gspca_dev->usb_err = 0;
+		if (gspca_dev->streaming)
 			gspca_stream_off(gspca_dev);
-		}
 		frame_free(gspca_dev);
 	}
 	module_put(gspca_dev->module);
@@ -1569,7 +1568,6 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	/* stop streaming */
 	streaming = gspca_dev->streaming;
 	if (streaming) {
-		gspca_dev->usb_err = 0;
 		gspca_stream_off(gspca_dev);
 
 		/* Don't restart the stream when switching from read
@@ -1675,7 +1673,6 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	}
 
 	/* stop streaming */
-	gspca_dev->usb_err = 0;
 	gspca_stream_off(gspca_dev);
 	/* In case another thread is waiting in dqbuf */
 	wake_up_interruptible(&gspca_dev->wq);
-- 
1.7.10

