Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739AbbCIQfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 09/19] cx18: embed video_device
Date: Mon,  9 Mar 2015 17:34:03 +0100
Message-Id: <1425918853-12371-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-alsa-main.c |  2 +-
 drivers/media/pci/cx18/cx18-driver.h    |  2 +-
 drivers/media/pci/cx18/cx18-fileops.c   |  2 +-
 drivers/media/pci/cx18/cx18-ioctl.c     |  2 +-
 drivers/media/pci/cx18/cx18-streams.c   | 62 ++++++++++++---------------------
 drivers/media/pci/cx18/cx18-streams.h   |  2 +-
 6 files changed, 28 insertions(+), 44 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
index ea272bc..0b0e801 100644
--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -216,7 +216,7 @@ static int cx18_alsa_load(struct cx18 *cx)
 	}
 
 	s = &cx->streams[CX18_ENC_STREAM_TYPE_PCM];
-	if (s->video_dev == NULL) {
+	if (s->video_dev.v4l2_dev == NULL) {
 		CX18_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - "
 				     "skipping\n", __func__);
 		return 0;
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index ec40f2d..b15beed 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -373,7 +373,7 @@ struct cx18_in_work_order {
 struct cx18_stream {
 	/* These first five fields are always set, even if the stream
 	   is not actually created. */
-	struct video_device *video_dev;	/* NULL when stream not created */
+	struct video_device video_dev;	/* v4l2_dev is NULL when stream not created */
 	struct cx18_dvb *dvb;		/* DVB / Digital Transport */
 	struct cx18 *cx; 		/* for ease of use */
 	const char *name;		/* name of the stream */
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index 76a3b4a..d245445 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -797,7 +797,7 @@ static int cx18_serialized_open(struct cx18_stream *s, struct file *filp)
 		CX18_DEBUG_WARN("nomem on v4l2 open\n");
 		return -ENOMEM;
 	}
-	v4l2_fh_init(&item->fh, s->video_dev);
+	v4l2_fh_init(&item->fh, &s->video_dev);
 
 	item->cx = cx;
 	item->type = s->type;
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index c2e0093..0230b0f 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -1039,7 +1039,7 @@ static int cx18_log_status(struct file *file, void *fh)
 	for (i = 0; i < CX18_MAX_STREAMS; i++) {
 		struct cx18_stream *s = &cx->streams[i];
 
-		if (s->video_dev == NULL || s->buffers == 0)
+		if (s->video_dev.v4l2_dev == NULL || s->buffers == 0)
 			continue;
 		CX18_INFO("Stream %s: status 0x%04lx, %d%% of %d KiB (%d buffers) in use\n",
 			  s->name, s->s_flags,
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 369445f..cf7ddaf 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -254,11 +254,8 @@ static struct videobuf_queue_ops cx18_videobuf_qops = {
 static void cx18_stream_init(struct cx18 *cx, int type)
 {
 	struct cx18_stream *s = &cx->streams[type];
-	struct video_device *video_dev = s->video_dev;
 
-	/* we need to keep video_dev, so restore it afterwards */
 	memset(s, 0, sizeof(*s));
-	s->video_dev = video_dev;
 
 	/* initialize cx18_stream fields */
 	s->dvb = NULL;
@@ -319,12 +316,12 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
 
 	/*
 	 * These five fields are always initialized.
-	 * For analog capture related streams, if video_dev == NULL then the
+	 * For analog capture related streams, if video_dev.v4l2_dev == NULL then the
 	 * stream is not in use.
 	 * For the TS stream, if dvb == NULL then the stream is not in use.
 	 * In those cases no other fields but these four can be used.
 	 */
-	s->video_dev = NULL;
+	s->video_dev.v4l2_dev = NULL;
 	s->dvb = NULL;
 	s->cx = cx;
 	s->type = type;
@@ -367,24 +364,17 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
 	if (num_offset == -1)
 		return 0;
 
-	/* allocate and initialize the v4l2 video device structure */
-	s->video_dev = video_device_alloc();
-	if (s->video_dev == NULL) {
-		CX18_ERR("Couldn't allocate v4l2 video_device for %s\n",
-				s->name);
-		return -ENOMEM;
-	}
-
-	snprintf(s->video_dev->name, sizeof(s->video_dev->name), "%s %s",
+	/* initialize the v4l2 video device structure */
+	snprintf(s->video_dev.name, sizeof(s->video_dev.name), "%s %s",
 		 cx->v4l2_dev.name, s->name);
 
-	s->video_dev->num = num;
-	s->video_dev->v4l2_dev = &cx->v4l2_dev;
-	s->video_dev->fops = &cx18_v4l2_enc_fops;
-	s->video_dev->release = video_device_release;
-	s->video_dev->tvnorms = V4L2_STD_ALL;
-	s->video_dev->lock = &cx->serialize_lock;
-	cx18_set_funcs(s->video_dev);
+	s->video_dev.num = num;
+	s->video_dev.v4l2_dev = &cx->v4l2_dev;
+	s->video_dev.fops = &cx18_v4l2_enc_fops;
+	s->video_dev.release = video_device_release_empty;
+	s->video_dev.tvnorms = V4L2_STD_ALL;
+	s->video_dev.lock = &cx->serialize_lock;
+	cx18_set_funcs(&s->video_dev);
 	return 0;
 }
 
@@ -428,31 +418,30 @@ static int cx18_reg_dev(struct cx18 *cx, int type)
 		}
 	}
 
-	if (s->video_dev == NULL)
+	if (s->video_dev.v4l2_dev == NULL)
 		return 0;
 
-	num = s->video_dev->num;
+	num = s->video_dev.num;
 	/* card number + user defined offset + device offset */
 	if (type != CX18_ENC_STREAM_TYPE_MPG) {
 		struct cx18_stream *s_mpg = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
 
-		if (s_mpg->video_dev)
-			num = s_mpg->video_dev->num
+		if (s_mpg->video_dev.v4l2_dev)
+			num = s_mpg->video_dev.num
 			    + cx18_stream_info[type].num_offset;
 	}
-	video_set_drvdata(s->video_dev, s);
+	video_set_drvdata(&s->video_dev, s);
 
 	/* Register device. First try the desired minor, then any free one. */
-	ret = video_register_device_no_warn(s->video_dev, vfl_type, num);
+	ret = video_register_device_no_warn(&s->video_dev, vfl_type, num);
 	if (ret < 0) {
 		CX18_ERR("Couldn't register v4l2 device for %s (device node number %d)\n",
 			s->name, num);
-		video_device_release(s->video_dev);
-		s->video_dev = NULL;
+		s->video_dev.v4l2_dev = NULL;
 		return ret;
 	}
 
-	name = video_device_node_name(s->video_dev);
+	name = video_device_node_name(&s->video_dev);
 
 	switch (vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -542,10 +531,9 @@ void cx18_streams_cleanup(struct cx18 *cx, int unregister)
 		}
 
 		/* If struct video_device exists, can have buffers allocated */
-		vdev = cx->streams[type].video_dev;
+		vdev = &cx->streams[type].video_dev;
 
-		cx->streams[type].video_dev = NULL;
-		if (vdev == NULL)
+		if (vdev->v4l2_dev == NULL)
 			continue;
 
 		if (type == CX18_ENC_STREAM_TYPE_YUV)
@@ -553,11 +541,7 @@ void cx18_streams_cleanup(struct cx18 *cx, int unregister)
 
 		cx18_stream_free(&cx->streams[type]);
 
-		/* Unregister or release device */
-		if (unregister)
-			video_unregister_device(vdev);
-		else
-			video_device_release(vdev);
+		video_unregister_device(vdev);
 	}
 }
 
@@ -1042,7 +1026,7 @@ u32 cx18_find_handle(struct cx18 *cx)
 	for (i = 0; i < CX18_MAX_STREAMS; i++) {
 		struct cx18_stream *s = &cx->streams[i];
 
-		if (s->video_dev && (s->handle != CX18_INVALID_TASK_HANDLE))
+		if (s->video_dev.v4l2_dev && (s->handle != CX18_INVALID_TASK_HANDLE))
 			return s->handle;
 	}
 	return CX18_INVALID_TASK_HANDLE;
diff --git a/drivers/media/pci/cx18/cx18-streams.h b/drivers/media/pci/cx18/cx18-streams.h
index 713b0e6..27f8af9 100644
--- a/drivers/media/pci/cx18/cx18-streams.h
+++ b/drivers/media/pci/cx18/cx18-streams.h
@@ -33,7 +33,7 @@ void cx18_stream_rotate_idx_mdls(struct cx18 *cx);
 
 static inline bool cx18_stream_enabled(struct cx18_stream *s)
 {
-	return s->video_dev ||
+	return s->video_dev.v4l2_dev ||
 	       (s->dvb && s->dvb->enabled) ||
 	       (s->type == CX18_ENC_STREAM_TYPE_IDX &&
 		s->cx->stream_buffers[CX18_ENC_STREAM_TYPE_IDX] != 0);
-- 
2.1.4

