Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2410 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3FBK4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/16] saa7134: add support for control events.
Date: Sun,  2 Jun 2013 12:56:04 +0200
Message-Id: <1370170567-7004-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c |   19 ++++++++++++----
 drivers/media/pci/saa7134/saa7134-video.c   |   32 +++++++++++++++++++--------
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66a7ddc..3d24408 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -23,13 +23,14 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 #include <media/saa6752hs.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 
+#include "saa7134-reg.h"
+#include "saa7134.h"
+
 /* ------------------------------------------------------------------ */
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -145,9 +146,16 @@ ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 ts_poll(struct file *file, struct poll_table_struct *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct saa7134_dev *dev = video_drvdata(file);
+	struct saa7134_fh *fh = file->private_data;
+	unsigned int rc = 0;
 
-	return videobuf_poll_stream(file, &dev->empress_tsq, wait);
+	if (v4l2_event_pending(&fh->fh))
+		rc = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->fh.wait, wait);
+	return rc | videobuf_poll_stream(file, &dev->empress_tsq, wait);
 }
 
 
@@ -272,6 +280,9 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_g_chip_ident 		= empress_g_chip_ident,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index a35e137..fa6cc17 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -27,11 +27,13 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/saa6588.h>
 
+#include "saa7134-reg.h"
+#include "saa7134.h"
+
 /* ------------------------------------------------------------------ */
 
 unsigned int video_debug;
@@ -1169,14 +1171,20 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 video_poll(struct file *file, struct poll_table_struct *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
+	if (v4l2_event_pending(&fh->fh))
+		rc = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->fh.wait, wait);
+
 	if (vdev->vfl_type == VFL_TYPE_VBI)
-		return videobuf_poll_stream(file, &dev->vbi, wait);
+		return rc | videobuf_poll_stream(file, &dev->vbi, wait);
 
 	if (res_check(fh, RESOURCE_VIDEO)) {
 		mutex_lock(&dev->cap.vb_lock);
@@ -1201,15 +1209,14 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 		goto err;
 
 	poll_wait(file, &buf->done, wait);
-	if (buf->state == VIDEOBUF_DONE ||
-	    buf->state == VIDEOBUF_ERROR)
-		rc = POLLIN|POLLRDNORM;
+	if (buf->state == VIDEOBUF_DONE || buf->state == VIDEOBUF_ERROR)
+		rc |= POLLIN | POLLRDNORM;
 	mutex_unlock(&dev->cap.vb_lock);
 	return rc;
 
 err:
 	mutex_unlock(&dev->cap.vb_lock);
-	return POLLERR;
+	return rc | POLLERR;
 }
 
 static int video_release(struct file *file)
@@ -1290,13 +1297,14 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa6588_command cmd;
+	unsigned int rc = v4l2_ctrl_poll(file, wait);
 
 	cmd.instance = file;
 	cmd.event_list = wait;
-	cmd.result = -ENODEV;
+	cmd.result = 0;
 	saa_call_all(dev, core, ioctl, SAA6588_CMD_POLL, &cmd);
 
-	return cmd.result;
+	return rc | cmd.result;
 }
 
 /* ------------------------------------------------------------------ */
@@ -2100,6 +2108,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_register              = vidioc_g_register,
 	.vidioc_s_register              = vidioc_s_register,
 #endif
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -2117,6 +2128,9 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
+	.vidioc_log_status	= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /* ----------------------------------------------------------- */
-- 
1.7.10.4

