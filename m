Return-path: <linux-media-owner@vger.kernel.org>
Received: from m1plsmtpa01-08.prod.mesa1.secureserver.net ([64.202.165.187]:41657
	"EHLO m1plsmtpa01-08.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab3EMLS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 07:18:28 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] hdpvr: Cleaned up error handling
Date: Mon, 13 May 2013 04:10:44 -0700
Message-Id: <1368443444-12492-4-git-send-email-leo@lumanate.com>
In-Reply-To: <1368443444-12492-1-git-send-email-leo@lumanate.com>
References: <1368443444-12492-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c |    5 +----
 drivers/media/usb/hdpvr/hdpvr-video.c   |   10 +++++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index 7d1bfb3..583be15 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -73,10 +73,7 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
-	if ((ret>0 && ret!=5) ||/* fail if unexpected byte count returned */
-	    !vidinf->width ||	/* preserve original behavior -  */
-	    !vidinf->height ||	/* fail if no signal is detected */
-	    !vidinf->fps) {
+	if (ret>0 && ret!=5) {	/* fail if unexpected byte count returned */
 		ret = -EFAULT;
 	}
 
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 2d02b49..5e8d6c2 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -285,8 +285,10 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 		return -EAGAIN;
 
 	ret = get_video_info(dev, &vidinf);
+	if (ret)		/* device is dead */
+		return ret;	/* let the caller know */
 
-	if (!ret) {
+	if (vidinf.width && vidinf.height) {
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			 "video signal: %dx%d@%dhz\n", vidinf.width,
 			 vidinf.height, vidinf.fps);
@@ -618,7 +620,7 @@ static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
 		return fh->legacy_mode ? 0 : -ENODATA;
 	ret = get_video_info(dev, &vid_info);
 	if (ret)
-		return 0;
+		return ret;
 	if (vid_info.width == 720 &&
 	    (vid_info.height == 480 || vid_info.height == 576)) {
 		*a = (vid_info.height == 480) ?
@@ -679,6 +681,8 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 		return -ENODATA;
 	ret = get_video_info(dev, &vid_info);
 	if (ret)
+		return ret;
+	if (vid_info.fps == 0)
 		return -ENOLCK;
 	interlaced = vid_info.fps <= 30;
 	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++) {
@@ -1009,7 +1013,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 
 		ret = get_video_info(dev, &vid_info);
 		if (ret)
-			return -EFAULT;
+			return ret;
 		f->fmt.pix.width = vid_info.width;
 		f->fmt.pix.height = vid_info.height;
 	} else {
-- 
1.7.9.5

