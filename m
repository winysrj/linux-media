Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36603 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbCYFhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 01:37:52 -0400
From: Jaedon Shin <jaedon.shin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH RESEND] media: dmxdev: fix possible race condition
Date: Wed, 25 Mar 2015 14:37:06 +0900
Message-Id: <1427261826-20208-1-git-send-email-jaedon.shin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes race condition between dvb_dmxdev_buffer_read and
dvb_demux_io_ioctl.

There are race conditions executing DMX_ADD_PID or DMX_REMOVE_PID in the
dvb_demux_ioctl when dvb_demux_read is waiting for the data by
wait_event_interruptible. So, this fixes to sleep with acquired mutex
and splits dvb_dmxdev_buffer_read into dvb_dvr_read.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
---
 drivers/media/dvb-core/dmxdev.c | 94 ++++++++++++++++++++++++++++++++---------
 1 file changed, 75 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index abff803ad69a..c2564b0e389b 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -57,10 +57,11 @@ static int dvb_dmxdev_buffer_write(struct dvb_ringbuffer *buf,
 	return dvb_ringbuffer_write(buf, src, len);
 }
 
-static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
+static ssize_t dvb_dmxdev_buffer_read(struct dmxdev_filter *dmxdevfilter,
 				      int non_blocking, char __user *buf,
 				      size_t count, loff_t *ppos)
 {
+	struct dvb_ringbuffer *src = &dmxdevfilter->buffer;
 	size_t todo;
 	ssize_t avail;
 	ssize_t ret = 0;
@@ -75,16 +76,21 @@ static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
 	}
 
 	for (todo = count; todo > 0; todo -= ret) {
-		if (non_blocking && dvb_ringbuffer_empty(src)) {
-			ret = -EWOULDBLOCK;
-			break;
-		}
+		if (dvb_ringbuffer_empty(src)) {
+			mutex_unlock(&dmxdevfilter->mutex);
 
-		ret = wait_event_interruptible(src->queue,
-					       !dvb_ringbuffer_empty(src) ||
-					       (src->error != 0));
-		if (ret < 0)
-			break;
+			if (non_blocking)
+				return -EWOULDBLOCK;
+
+			ret = wait_event_interruptible(src->queue,
+					!dvb_ringbuffer_empty(src) ||
+					(src->error != 0));
+			if (ret < 0)
+				return ret;
+
+			if (mutex_lock_interruptible(&dmxdevfilter->mutex))
+				return -ERESTARTSYS;
+		}
 
 		if (src->error) {
 			ret = src->error;
@@ -242,13 +248,63 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
+	struct dvb_ringbuffer *src = &dmxdev->dvr_buffer;
+	size_t todo;
+	ssize_t avail;
+	ssize_t ret = 0;
 
-	if (dmxdev->exit)
+	if (mutex_lock_interruptible(&dmxdev->mutex))
+		return -ERESTARTSYS;
+
+	if (dmxdev->exit) {
+		mutex_unlock(&dmxdev->mutex);
 		return -ENODEV;
+	}
+
+	if (src->error) {
+		ret = src->error;
+		dvb_ringbuffer_flush(src);
+		mutex_unlock(&dmxdev->mutex);
+		return ret;
+	}
+
+	for (todo = count; todo > 0; todo -= ret) {
+		if (dvb_ringbuffer_empty(src)) {
+			mutex_unlock(&dmxdev->mutex);
 
-	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
-				      file->f_flags & O_NONBLOCK,
-				      buf, count, ppos);
+			if (file->f_flags & O_NONBLOCK)
+				return -EWOULDBLOCK;
+
+			ret = wait_event_interruptible(src->queue,
+					!dvb_ringbuffer_empty(src) ||
+					(src->error != 0));
+			if (ret < 0)
+				return ret;
+
+			if (mutex_lock_interruptible(&dmxdev->mutex))
+				return -ERESTARTSYS;
+		}
+
+		if (src->error) {
+			ret = src->error;
+			dvb_ringbuffer_flush(src);
+			break;
+		}
+
+		avail = dvb_ringbuffer_avail(src);
+		if (avail > todo)
+			avail = todo;
+
+		ret = dvb_ringbuffer_read_user(src, buf, avail);
+		if (ret < 0)
+			break;
+
+		buf += ret;
+	}
+
+	mutex_unlock(&dmxdev->mutex);
+
+	return (count - todo) ? (count - todo) : ret;
 }
 
 static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
@@ -283,7 +339,6 @@ static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
 
 	return 0;
 }
-
 static inline void dvb_dmxdev_filter_state_set(struct dmxdev_filter
 					       *dmxdevfilter, int state)
 {
@@ -904,7 +959,7 @@ static ssize_t dvb_dmxdev_read_sec(struct dmxdev_filter *dfil,
 		hcount = 3 + dfil->todo;
 		if (hcount > count)
 			hcount = count;
-		result = dvb_dmxdev_buffer_read(&dfil->buffer,
+		result = dvb_dmxdev_buffer_read(dfil,
 						file->f_flags & O_NONBLOCK,
 						buf, hcount, ppos);
 		if (result < 0) {
@@ -925,7 +980,7 @@ static ssize_t dvb_dmxdev_read_sec(struct dmxdev_filter *dfil,
 	}
 	if (count > dfil->todo)
 		count = dfil->todo;
-	result = dvb_dmxdev_buffer_read(&dfil->buffer,
+	result = dvb_dmxdev_buffer_read(dfil,
 					file->f_flags & O_NONBLOCK,
 					buf, count, ppos);
 	if (result < 0)
@@ -947,11 +1002,12 @@ dvb_demux_read(struct file *file, char __user *buf, size_t count,
 	if (dmxdevfilter->type == DMXDEV_TYPE_SEC)
 		ret = dvb_dmxdev_read_sec(dmxdevfilter, file, buf, count, ppos);
 	else
-		ret = dvb_dmxdev_buffer_read(&dmxdevfilter->buffer,
+		ret = dvb_dmxdev_buffer_read(dmxdevfilter,
 					     file->f_flags & O_NONBLOCK,
 					     buf, count, ppos);
 
-	mutex_unlock(&dmxdevfilter->mutex);
+	if (mutex_is_locked(&dmxdevfilter->mutex))
+		mutex_unlock(&dmxdevfilter->mutex);
 	return ret;
 }
 
-- 
2.3.4

