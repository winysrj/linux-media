Return-path: <linux-media-owner@vger.kernel.org>
Received: from m1plsmtpa01-08.prod.mesa1.secureserver.net ([64.202.165.187]:41658
	"EHLO m1plsmtpa01-08.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab3EMLS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 07:18:28 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] hdpvr: Removed unnecessary use of kzalloc() in get_video_info()
Date: Mon, 13 May 2013 04:10:42 -0700
Message-Id: <1368443444-12492-2-git-send-email-leo@lumanate.com>
In-Reply-To: <1368443444-12492-1-git-send-email-leo@lumanate.com>
References: <1368443444-12492-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c |   25 ++++++--------
 drivers/media/usb/hdpvr/hdpvr-video.c   |   54 +++++++++++++++----------------
 drivers/media/usb/hdpvr/hdpvr.h         |    2 +-
 3 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index ae8f229..7d1bfb3 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -45,20 +45,10 @@ int hdpvr_config_call(struct hdpvr_device *dev, uint value, u8 valbuf)
 	return ret < 0 ? ret : 0;
 }
 
-struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
+int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 {
-	struct hdpvr_video_info *vidinf = NULL;
-#ifdef HDPVR_DEBUG
-	char print_buf[15];
-#endif
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
@@ -74,6 +64,7 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
 
 #ifdef HDPVR_DEBUG
 	if (hdpvr_debug & MSG_INFO) {
+		char print_buf[15];
 		hex_dump_to_buffer(dev->usbc_buf, 5, 16, 1, print_buf,
 				   sizeof(print_buf), 0);
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
@@ -82,12 +73,14 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
-	if (!vidinf->width || !vidinf->height || !vidinf->fps) {
-		kfree(vidinf);
-		vidinf = NULL;
+	if ((ret>0 && ret!=5) ||/* fail if unexpected byte count returned */
+	    !vidinf->width ||	/* preserve original behavior -  */
+	    !vidinf->height ||	/* fail if no signal is detected */
+	    !vidinf->fps) {
+		ret = -EFAULT;
 	}
-err:
-	return vidinf;
+
+	return ret < 0 ? ret : 0;
 }
 
 int get_input_lines_info(struct hdpvr_device *dev)
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 774ba0e..d9eb8e1 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -277,20 +277,19 @@ error:
 static int hdpvr_start_streaming(struct hdpvr_device *dev)
 {
 	int ret;
-	struct hdpvr_video_info *vidinf;
+	struct hdpvr_video_info vidinf;
 
 	if (dev->status == STATUS_STREAMING)
 		return 0;
 	else if (dev->status != STATUS_IDLE)
 		return -EAGAIN;
 
-	vidinf = get_video_info(dev);
+	ret = get_video_info(dev, &vidinf);
 
-	if (vidinf) {
+	if (!ret) {
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
-			 "video signal: %dx%d@%dhz\n", vidinf->width,
-			 vidinf->height, vidinf->fps);
-		kfree(vidinf);
+			 "video signal: %dx%d@%dhz\n", vidinf.width,
+			 vidinf.height, vidinf.fps);
 
 		/* start streaming 2 request */
 		ret = usb_control_msg(dev->udev,
@@ -606,21 +605,22 @@ static int vidioc_g_std(struct file *file, void *_fh,
 static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
-	struct hdpvr_video_info *vid_info;
+	struct hdpvr_video_info vid_info;
 	struct hdpvr_fh *fh = _fh;
+	int ret;
 
 	*a = V4L2_STD_ALL;
 	if (dev->options.video_input == HDPVR_COMPONENT)
 		return fh->legacy_mode ? 0 : -ENODATA;
-	vid_info = get_video_info(dev);
-	if (vid_info == NULL)
+	ret = get_video_info(dev, &vid_info);
+	if (ret)
 		return 0;
-	if (vid_info->width == 720 &&
-	    (vid_info->height == 480 || vid_info->height == 576)) {
-		*a = (vid_info->height == 480) ?
+	if (vid_info.width == 720 &&
+	    (vid_info.height == 480 || vid_info.height == 576)) {
+		*a = (vid_info.height == 480) ?
 			V4L2_STD_525_60 : V4L2_STD_625_50;
 	}
-	kfree(vid_info);
+
 	return 0;
 }
 
@@ -665,7 +665,7 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 {
 	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_fh *fh = _fh;
-	struct hdpvr_video_info *vid_info;
+	struct hdpvr_video_info vid_info;
 	bool interlaced;
 	int ret = 0;
 	int i;
@@ -673,10 +673,10 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 	fh->legacy_mode = false;
 	if (dev->options.video_input)
 		return -ENODATA;
-	vid_info = get_video_info(dev);
-	if (vid_info == NULL)
+	ret = get_video_info(dev, &vid_info);
+	if (ret)
 		return -ENOLCK;
-	interlaced = vid_info->fps <= 30;
+	interlaced = vid_info.fps <= 30;
 	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++) {
 		const struct v4l2_bt_timings *bt = &hdpvr_dv_timings[i].bt;
 		unsigned hsize;
@@ -688,17 +688,17 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 			bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch +
 			bt->height;
 		fps = (unsigned)bt->pixelclock / (hsize * vsize);
-		if (bt->width != vid_info->width ||
-		    bt->height != vid_info->height ||
+		if (bt->width != vid_info.width ||
+		    bt->height != vid_info.height ||
 		    bt->interlaced != interlaced ||
-		    (fps != vid_info->fps && fps + 1 != vid_info->fps))
+		    (fps != vid_info.fps && fps + 1 != vid_info.fps))
 			continue;
 		*timings = hdpvr_dv_timings[i];
 		break;
 	}
 	if (i == ARRAY_SIZE(hdpvr_dv_timings))
 		ret = -ERANGE;
-	kfree(vid_info);
+
 	return ret;
 }
 
@@ -988,6 +988,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 {
 	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_fh *fh = _fh;
+	int ret;
 
 	/*
 	 * The original driver would always returns the current detected
@@ -1000,14 +1001,13 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 	 * last set format.
 	 */
 	if (fh->legacy_mode) {
-		struct hdpvr_video_info *vid_info;
+		struct hdpvr_video_info vid_info;
 
-		vid_info = get_video_info(dev);
-		if (!vid_info)
+		ret = get_video_info(dev, &vid_info);
+		if (ret)
 			return -EFAULT;
-		f->fmt.pix.width = vid_info->width;
-		f->fmt.pix.height = vid_info->height;
-		kfree(vid_info);
+		f->fmt.pix.width = vid_info.width;
+		f->fmt.pix.height = vid_info.height;
 	} else {
 		f->fmt.pix.width = dev->width;
 		f->fmt.pix.height = dev->height;
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 1478f3d..808ea7a 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -303,7 +303,7 @@ int hdpvr_set_audio(struct hdpvr_device *dev, u8 input,
 int hdpvr_config_call(struct hdpvr_device *dev, uint value,
 		      unsigned char valbuf);
 
-struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev);
+int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vid_info);
 
 /* :0 s b8 81 1800 0003 0003 3 < */
 /* :0 0 3 = 0301ff */
-- 
1.7.9.5

