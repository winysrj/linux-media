Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4218 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2FJK0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 01/32] Regression fixes.
Date: Sun, 10 Jun 2012 12:25:23 +0200
Message-Id: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c |    2 ++
 drivers/media/video/vivi.c     |    6 +++++-
 include/linux/videodev2.h      |    6 +++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5ccbd46..1500208 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -679,6 +679,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
 	SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
 	SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
+	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
+	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
 	/* yes, really vidioc_subscribe_event */
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 0960d7f..08c1024 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1149,10 +1149,14 @@ static ssize_t
 vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct vivi_dev *dev = video_drvdata(file);
+	int err;
 
 	dprintk(dev, 1, "read called\n");
-	return vb2_read(&dev->vb_vidq, data, count, ppos,
+	mutex_lock(&dev->mutex);
+	err = vb2_read(&dev->vb_vidq, data, count, ppos,
 		       file->f_flags & O_NONBLOCK);
+	mutex_unlock(&dev->mutex);
+	return err;
 }
 
 static unsigned int
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 370d111..2039c5d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2640,9 +2640,9 @@ struct v4l2_create_buffers {
 
 /* Experimental, these three ioctls may change over the next couple of kernel
    versions. */
-#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 96, struct v4l2_enum_dv_timings)
-#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 97, struct v4l2_dv_timings)
-#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 98, struct v4l2_dv_timings_cap)
+#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 98, struct v4l2_enum_dv_timings)
+#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
+#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
-- 
1.7.10

