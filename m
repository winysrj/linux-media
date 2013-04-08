Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2423 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934627Ab3DHK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 12/12] hdpvr: allow g/s_std when in legacy mode.
Date: Mon,  8 Apr 2013 12:58:41 +0200
Message-Id: <1365418721-23859-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Otherwise gstreamer will no longer work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 4376309..f6a705e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -571,13 +571,14 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_s_std(struct file *file, void *private_data,
+static int vidioc_s_std(struct file *file, void *_fh,
 			v4l2_std_id std)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
 	u8 std_type = 1;
 
-	if (dev->options.video_input == HDPVR_COMPONENT)
+	if (!fh->legacy_mode && dev->options.video_input == HDPVR_COMPONENT)
 		return -ENODATA;
 	if (dev->status != STATUS_IDLE)
 		return -EBUSY;
@@ -590,12 +591,13 @@ static int vidioc_s_std(struct file *file, void *private_data,
 	return hdpvr_config_call(dev, CTRL_VIDEO_STD_TYPE, std_type);
 }
 
-static int vidioc_g_std(struct file *file, void *private_data,
+static int vidioc_g_std(struct file *file, void *_fh,
 			v4l2_std_id *std)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
 
-	if (dev->options.video_input == HDPVR_COMPONENT)
+	if (!fh->legacy_mode && dev->options.video_input == HDPVR_COMPONENT)
 		return -ENODATA;
 	*std = dev->cur_std;
 	return 0;
@@ -764,10 +766,11 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *private_data,
+static int vidioc_s_input(struct file *file, void *_fh,
 			  unsigned int index)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
 	int retval;
 
 	if (index >= HDPVR_VIDEO_INPUTS)
@@ -780,7 +783,8 @@ static int vidioc_s_input(struct file *file, void *private_data,
 	if (!retval) {
 		dev->options.video_input = index;
 		dev->video_dev->tvnorms =
-			index != HDPVR_COMPONENT ? V4L2_STD_ALL : 0;
+			(fh->legacy_mode || index != HDPVR_COMPONENT) ?
+				V4L2_STD_ALL : 0;
 	}
 
 	return retval;
-- 
1.7.10.4

