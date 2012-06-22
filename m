Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1729 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab2FVMVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 22/34] cx18: don't mess with vfd->debug.
Date: Fri, 22 Jun 2012 14:21:16 +0200
Message-Id: <3b0a36e7fcc2b58e9ca0b0e09eb484b6a2eac30f.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is now controlled by sysfs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx18/cx18-ioctl.c   |   18 ------------------
 drivers/media/video/cx18/cx18-ioctl.h   |    2 --
 drivers/media/video/cx18/cx18-streams.c |    4 ++--
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 35fde4e..e9912db 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -1142,24 +1142,6 @@ static long cx18_default(struct file *file, void *fh, bool valid_prio,
 	return 0;
 }
 
-long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd,
-		    unsigned long arg)
-{
-	struct video_device *vfd = video_devdata(filp);
-	struct cx18_open_id *id = file2id(filp);
-	struct cx18 *cx = id->cx;
-	long res;
-
-	mutex_lock(&cx->serialize_lock);
-
-	if (cx18_debug & CX18_DBGFLG_IOCTL)
-		vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
-	res = video_ioctl2(filp, cmd, arg);
-	vfd->debug = 0;
-	mutex_unlock(&cx->serialize_lock);
-	return res;
-}
-
 static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_querycap                = cx18_querycap,
 	.vidioc_s_audio                 = cx18_s_audio,
diff --git a/drivers/media/video/cx18/cx18-ioctl.h b/drivers/media/video/cx18/cx18-ioctl.h
index dcb2559..2f9dd59 100644
--- a/drivers/media/video/cx18/cx18-ioctl.h
+++ b/drivers/media/video/cx18/cx18-ioctl.h
@@ -29,5 +29,3 @@ void cx18_set_funcs(struct video_device *vdev);
 int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std);
 int cx18_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf);
 int cx18_s_input(struct file *file, void *fh, unsigned int inp);
-long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd,
-		    unsigned long arg);
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 4185bcb..9d598ab 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -40,8 +40,7 @@ static struct v4l2_file_operations cx18_v4l2_enc_fops = {
 	.owner = THIS_MODULE,
 	.read = cx18_v4l2_read,
 	.open = cx18_v4l2_open,
-	/* FIXME change to video_ioctl2 if serialization lock can be removed */
-	.unlocked_ioctl = cx18_v4l2_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 	.release = cx18_v4l2_close,
 	.poll = cx18_v4l2_enc_poll,
 	.mmap = cx18_v4l2_mmap,
@@ -376,6 +375,7 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
 	s->video_dev->fops = &cx18_v4l2_enc_fops;
 	s->video_dev->release = video_device_release;
 	s->video_dev->tvnorms = V4L2_STD_ALL;
+	s->video_dev->lock = &cx->serialize_lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &s->video_dev->flags);
 	cx18_set_funcs(s->video_dev);
 	return 0;
-- 
1.7.10

