Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3082 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0L2Vn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:26 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhOdN072150
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:24 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <92f941c68aa1125ed58dc741e2e3aad19a77bfc9.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:24 +0100
Subject: [PATCH 07/10] [RFC] ivtv: use core-assisted locking.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ivtv/ivtv-fileops.c |   15 +--------------
 drivers/media/video/ivtv/ivtv-ioctl.c   |   18 +-----------------
 drivers/media/video/ivtv/ivtv-streams.c |    1 +
 3 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 4463bf4..ae6e266 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -507,9 +507,7 @@ ssize_t ivtv_v4l2_read(struct file * filp, char __user *buf, size_t count, loff_
 
 	IVTV_DEBUG_HI_FILE("read %zd bytes from %s\n", count, s->name);
 
-	mutex_lock(&itv->serialize_lock);
 	rc = ivtv_start_capture(id);
-	mutex_unlock(&itv->serialize_lock);
 	if (rc)
 		return rc;
 	return ivtv_read_pos(s, buf, count, pos, filp->f_flags & O_NONBLOCK);
@@ -584,9 +582,7 @@ ssize_t ivtv_v4l2_write(struct file *filp, const char __user *user_buf, size_t c
 	set_bit(IVTV_F_S_APPL_IO, &s->s_flags);
 
 	/* Start decoder (returns 0 if already started) */
-	mutex_lock(&itv->serialize_lock);
 	rc = ivtv_start_decoding(id, itv->speed);
-	mutex_unlock(&itv->serialize_lock);
 	if (rc) {
 		IVTV_DEBUG_WARN("Failed start decode stream %s\n", s->name);
 
@@ -755,9 +751,7 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
 		int rc;
 
-		mutex_lock(&itv->serialize_lock);
 		rc = ivtv_start_capture(id);
-		mutex_unlock(&itv->serialize_lock);
 		if (rc) {
 			IVTV_DEBUG_INFO("Could not start capture for %s (%d)\n",
 					s->name, rc);
@@ -868,7 +862,6 @@ int ivtv_v4l2_close(struct file *filp)
 	/* 'Unclaim' this stream */
 
 	/* Stop radio */
-	mutex_lock(&itv->serialize_lock);
 	if (id->type == IVTV_ENC_STREAM_TYPE_RAD) {
 		/* Closing radio device, return to TV mode */
 		ivtv_mute(itv);
@@ -906,7 +899,6 @@ int ivtv_v4l2_close(struct file *filp)
 		ivtv_stop_capture(id, 0);
 	}
 	kfree(id);
-	mutex_unlock(&itv->serialize_lock);
 	return 0;
 }
 
@@ -1026,7 +1018,6 @@ static int ivtv_serialized_open(struct ivtv_stream *s, struct file *filp)
 
 int ivtv_v4l2_open(struct file *filp)
 {
-	int res;
 	struct ivtv *itv = NULL;
 	struct ivtv_stream *s = NULL;
 	struct video_device *vdev = video_devdata(filp);
@@ -1034,16 +1025,12 @@ int ivtv_v4l2_open(struct file *filp)
 	s = video_get_drvdata(vdev);
 	itv = s->itv;
 
-	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
 		IVTV_ERR("Failed to initialize on device %s\n",
 			 video_device_node_name(vdev));
-		mutex_unlock(&itv->serialize_lock);
 		return -ENXIO;
 	}
-	res = ivtv_serialized_open(s, filp);
-	mutex_unlock(&itv->serialize_lock);
-	return res;
+	return ivtv_serialized_open(s, filp);
 }
 
 void ivtv_mute(struct ivtv *itv)
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 6fb1837..d65c4ed 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1831,8 +1831,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	return 0;
 }
 
-static long ivtv_serialized_ioctl(struct ivtv *itv, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vfd = video_devdata(filp);
 	long ret;
@@ -1844,21 +1843,6 @@ static long ivtv_serialized_ioctl(struct ivtv *itv, struct file *filp,
 	return ret;
 }
 
-long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	struct ivtv_open_id *id = fh2id(filp->private_data);
-	struct ivtv *itv = id->itv;
-	long res;
-
-	/* DQEVENT can block, so this should not run with the serialize lock */
-	if (cmd == VIDIOC_DQEVENT)
-		return ivtv_serialized_ioctl(itv, filp, cmd, arg);
-	mutex_lock(&itv->serialize_lock);
-	res = ivtv_serialized_ioctl(itv, filp, cmd, arg);
-	mutex_unlock(&itv->serialize_lock);
-	return res;
-}
-
 static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_querycap    		    = ivtv_querycap,
 	.vidioc_s_audio     		    = ivtv_s_audio,
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 512607e..b588ffc 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -214,6 +214,7 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 	s->vdev->fops = ivtv_stream_info[type].fops;
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
+	s->vdev->lock = &itv->serialize_lock;
 	ivtv_set_funcs(s->vdev);
 	return 0;
 }
-- 
1.6.4.2

