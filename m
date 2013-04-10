Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2483 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765136Ab3DJQ15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 12:27:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org, leo@lumanate.com
Subject: [REVIEWv2 PATCH 12/12] hdpvr: allow g/s_std when in legacy mode.
Date: Wed, 10 Apr 2013 18:27:43 +0200
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl> <1365418721-23859-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-13-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304101827.43541.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Leo, can you verify that this works for you as well? I tested it without
problems with MythTV and gstreamer.

Thanks!

	Hans

Both MythTV and gstreamer expect that they can set/get/query/enumerate the
standards, even if the input is the component input for which standards
really do not apply.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |   40 ++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 4376309..38724d7 100644
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
@@ -590,25 +591,27 @@ static int vidioc_s_std(struct file *file, void *private_data,
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
 }
 
-static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *a)
+static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_video_info *vid_info;
+	struct hdpvr_fh *fh = _fh;
 
-	if (dev->options.video_input == HDPVR_COMPONENT)
-		return -ENODATA;
 	*a = V4L2_STD_ALL;
+	if (dev->options.video_input == HDPVR_COMPONENT)
+		return fh->legacy_mode ? 0 : -ENODATA;
 	vid_info = get_video_info(dev);
 	if (vid_info == NULL)
 		return 0;
@@ -742,9 +745,9 @@ static const char *iname[] = {
 	[HDPVR_COMPOSITE] = "Composite",
 };
 
-static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
+static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
 {
+	struct hdpvr_fh *fh = _fh;
 	unsigned int n;
 
 	n = i->index;
@@ -758,13 +761,15 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	i->audioset = 1<<HDPVR_RCA_FRONT | 1<<HDPVR_RCA_BACK | 1<<HDPVR_SPDIF;
 
+	if (fh->legacy_mode)
+		n = 1;
 	i->capabilities = n ? V4L2_IN_CAP_STD : V4L2_IN_CAP_DV_TIMINGS;
 	i->std = n ? V4L2_STD_ALL : 0;
 
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *private_data,
+static int vidioc_s_input(struct file *file, void *_fh,
 			  unsigned int index)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
@@ -779,8 +784,20 @@ static int vidioc_s_input(struct file *file, void *private_data,
 	retval = hdpvr_config_call(dev, CTRL_VIDEO_INPUT_VALUE, index+1);
 	if (!retval) {
 		dev->options.video_input = index;
+		/*
+		 * Unfortunately gstreamer calls ENUMSTD and bails out if it
+		 * won't find any formats, even though component input is
+		 * selected. This means that we have to leave tvnorms at
+		 * V4L2_STD_ALL. We cannot use the 'legacy' trick since
+		 * tvnorms is set at the device node level and not at the
+		 * filehandle level.
+		 *
+		 * Comment this out for now, but if the legacy mode can be
+		 * removed in the future, then this code should be enabled
+		 * again.
 		dev->video_dev->tvnorms =
-			index != HDPVR_COMPONENT ? V4L2_STD_ALL : 0;
+			(index != HDPVR_COMPONENT) ? V4L2_STD_ALL : 0;
+		 */
 	}
 
 	return retval;
@@ -1126,6 +1143,7 @@ static const struct video_device hdpvr_video_template = {
 	.fops			= &hdpvr_fops,
 	.release		= hdpvr_device_release,
 	.ioctl_ops 		= &hdpvr_ioctl_ops,
+	.tvnorms		= V4L2_STD_ALL,
 };
 
 static const struct v4l2_ctrl_ops hdpvr_ctrl_ops = {
-- 
1.7.10.4

