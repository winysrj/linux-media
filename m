Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2919 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1AHNhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:04 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk5015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 08/16] ivtv: use core-assisted locking.
Date: Sat,  8 Jan 2011 14:36:33 +0100
Message-Id: <23127859088535ce5b6afeea3f0d3e6067c92dba.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
1.7.0.4

