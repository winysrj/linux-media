Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3334 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2FXL3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/26] ivtv: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:53 +0200
Message-Id: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |   52 +++++++++++++++++++++++++------
 drivers/media/video/ivtv/ivtv-streams.c |    4 ---
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 9ff69b5..88bce90 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -505,14 +505,17 @@ ssize_t ivtv_v4l2_read(struct file * filp, char __user *buf, size_t count, loff_
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
-	int rc;
+	ssize_t rc;
 
 	IVTV_DEBUG_HI_FILE("read %zd bytes from %s\n", count, s->name);
 
+	if (mutex_lock_interruptible(&itv->serialize_lock))
+		return -ERESTARTSYS;
 	rc = ivtv_start_capture(id);
-	if (rc)
-		return rc;
-	return ivtv_read_pos(s, buf, count, pos, filp->f_flags & O_NONBLOCK);
+	if (!rc)
+		rc = ivtv_read_pos(s, buf, count, pos, filp->f_flags & O_NONBLOCK);
+	mutex_unlock(&itv->serialize_lock);
+	return rc;
 }
 
 int ivtv_start_decoding(struct ivtv_open_id *id, int speed)
@@ -540,7 +543,7 @@ int ivtv_start_decoding(struct ivtv_open_id *id, int speed)
 	return 0;
 }
 
-ssize_t ivtv_v4l2_write(struct file *filp, const char __user *user_buf, size_t count, loff_t *pos)
+static ssize_t ivtv_write(struct file *filp, const char __user *user_buf, size_t count, loff_t *pos)
 {
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
@@ -712,6 +715,19 @@ retry:
 	return bytes_written;
 }
 
+ssize_t ivtv_v4l2_write(struct file *filp, const char __user *user_buf, size_t count, loff_t *pos)
+{
+	struct ivtv_open_id *id = fh2id(filp->private_data);
+	struct ivtv *itv = id->itv;
+	ssize_t res;
+
+	if (mutex_lock_interruptible(&itv->serialize_lock))
+		return -ERESTARTSYS;
+	res = ivtv_write(filp, user_buf, count, pos);
+	mutex_unlock(&itv->serialize_lock);
+	return res;
+}
+
 unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 {
 	struct ivtv_open_id *id = fh2id(filp->private_data);
@@ -760,7 +776,9 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
 			(req_events & (POLLIN | POLLRDNORM))) {
 		int rc;
 
+		mutex_lock(&itv->serialize_lock);
 		rc = ivtv_start_capture(id);
+		mutex_unlock(&itv->serialize_lock);
 		if (rc) {
 			IVTV_DEBUG_INFO("Could not start capture for %s (%d)\n",
 					s->name, rc);
@@ -863,6 +881,8 @@ int ivtv_v4l2_close(struct file *filp)
 
 	IVTV_DEBUG_FILE("close %s\n", s->name);
 
+	mutex_lock(&itv->serialize_lock);
+
 	/* Stop radio */
 	if (id->type == IVTV_ENC_STREAM_TYPE_RAD &&
 			v4l2_fh_is_singular_file(filp)) {
@@ -892,10 +912,8 @@ int ivtv_v4l2_close(struct file *filp)
 	v4l2_fh_exit(fh);
 
 	/* Easy case first: this stream was never claimed by us */
-	if (s->fh != &id->fh) {
-		kfree(id);
-		return 0;
-	}
+	if (s->fh != &id->fh)
+		goto close_done;
 
 	/* 'Unclaim' this stream */
 
@@ -913,11 +931,13 @@ int ivtv_v4l2_close(struct file *filp)
 	} else {
 		ivtv_stop_capture(id, 0);
 	}
+close_done:
 	kfree(id);
+	mutex_unlock(&itv->serialize_lock);
 	return 0;
 }
 
-int ivtv_v4l2_open(struct file *filp)
+static int ivtv_open(struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
 	struct ivtv_stream *s = video_get_drvdata(vdev);
@@ -1020,6 +1040,18 @@ int ivtv_v4l2_open(struct file *filp)
 	return 0;
 }
 
+int ivtv_v4l2_open(struct file *filp)
+{
+	struct video_device *vdev = video_devdata(filp);
+	int res;
+
+	if (mutex_lock_interruptible(vdev->lock))
+		return -ERESTARTSYS;
+	res = ivtv_open(filp);
+	mutex_unlock(vdev->lock);
+	return res;
+}
+
 void ivtv_mute(struct ivtv *itv)
 {
 	if (atomic_read(&itv->capturing))
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 6738592..7ea5ca7 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -228,10 +228,6 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
 	s->vdev->lock = &itv->serialize_lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &s->vdev->flags);
 	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev->flags);
 	ivtv_set_funcs(s->vdev);
 	return 0;
-- 
1.7.10

