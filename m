Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa08-05.prod.phx3.secureserver.net ([173.201.193.106]:58068
	"EHLO p3plsmtpa08-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324Ab3CVK7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 06:59:10 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: leo@lumanate.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] hdpvr: vidioc_g_fmt_vid_cap should not fail
Date: Fri, 22 Mar 2013 03:59:05 -0700
Message-Id: <1363949945-18656-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed get_video_info() function that used to return NULL
if video source is not present, subsequently causing
vidioc_g_fmt_vid_cap to fail. Originally issue reported here:
http://www.spinics.net/lists/linux-media/msg54246.html

Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c |   29 +++++++++++++----------------
 drivers/media/usb/hdpvr/hdpvr-video.c   |    5 ++++-
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index ae8f229..ed12159 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -53,12 +53,6 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
 #endif
 	int ret;
 
-	vidinf = kzalloc(sizeof(struct hdpvr_video_info), GFP_KERNEL);
-	if (!vidinf) {
-		v4l2_err(&dev->v4l2_dev, "out of memory\n");
-		goto err;
-	}
-
 	mutex_lock(&dev->usbc_mutex);
 	ret = usb_control_msg(dev->udev,
 			      usb_rcvctrlpipe(dev->udev, 0),
@@ -66,12 +60,6 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
 			      0x1400, 0x0003,
 			      dev->usbc_buf, 5,
 			      1000);
-	if (ret == 5) {
-		vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
-		vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
-		vidinf->fps	= dev->usbc_buf[4];
-	}
-
 #ifdef HDPVR_DEBUG
 	if (hdpvr_debug & MSG_INFO) {
 		hex_dump_to_buffer(dev->usbc_buf, 5, 16, 1, print_buf,
@@ -82,11 +70,20 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
-	if (!vidinf->width || !vidinf->height || !vidinf->fps) {
-		kfree(vidinf);
-		vidinf = NULL;
+	if (ret == 5)
+	{
+		vidinf = kzalloc(sizeof(struct hdpvr_video_info), GFP_KERNEL);
+		if (vidinf)
+		{
+			vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
+			vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
+			vidinf->fps	= dev->usbc_buf[4];
+		}
+		else
+		{
+			v4l2_err(&dev->v4l2_dev, "out of memory\n");
+		}
 	}
-err:
 	return vidinf;
 }
 
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index da6b779..fb14012 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -268,7 +268,7 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 	vidinf = get_video_info(dev);
 
-	if (vidinf) {
+	if (vidinf && vidinf->width && vidinf->height && vidinf->fps) {
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			 "video signal: %dx%d@%dhz\n", vidinf->width,
 			 vidinf->height, vidinf->fps);
@@ -293,6 +293,9 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 		return 0;
 	}
+	
+	if (vidinf)
+		kfree(vidinf);
 	msleep(250);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
 		 "no video signal at input %d\n", dev->options.video_input);
-- 
1.7.10.4

