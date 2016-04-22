Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40067 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbcDVND4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH 3/6] rcar-vin: support the source change event and fix s_std
Date: Fri, 22 Apr 2016 15:03:39 +0200
Message-Id: <1461330222-34096-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The patch adds support for the source change event and it fixes
the s_std support: changing the standard will also change the
resolution, and that was never updated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 +++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 8ac6149..49058ea 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -421,8 +421,25 @@ static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_sd(vin);
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	int ret = v4l2_subdev_call(sd, video, s_std, a);
+
+	if (ret < 0)
+		return ret;
 
-	return v4l2_subdev_call(sd, video, s_std, a);
+	/* Changing the standard will change the width/height */
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	if (ret) {
+		vin_err(vin, "Failed to get initial format\n");
+		return ret;
+	}
+
+	vin->format.width = mf->width;
+	vin->format.height = mf->height;
+	return 0;
 }
 
 static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
@@ -433,6 +450,16 @@ static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
 	return v4l2_subdev_call(sd, video, g_std, a);
 }
 
+static int rvin_subscribe_event(struct v4l2_fh *fh,
+				const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_event_subscribe(fh, sub, 4, NULL);
+	}
+	return v4l2_ctrl_subscribe_event(fh, sub);
+}
+
 static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_querycap		= rvin_querycap,
 	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
@@ -464,7 +491,7 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= rvin_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
@@ -623,6 +650,21 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
 	video_unregister_device(&vin->vdev);
 }
 
+static void rvin_notify(struct v4l2_subdev *sd,
+			unsigned int notification, void *arg)
+{
+	struct rvin_dev *vin =
+		container_of(sd->v4l2_dev, struct rvin_dev, v4l2_dev);
+
+	switch (notification) {
+	case V4L2_DEVICE_NOTIFY_EVENT:
+		v4l2_event_queue(&vin->vdev, arg);
+		break;
+	default:
+		break;
+	}
+}
+
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct v4l2_subdev_format fmt = {
@@ -635,6 +677,8 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 
 	v4l2_set_subdev_hostdata(sd, vin);
 
+	vin->v4l2_dev.notify = rvin_notify;
+
 	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
-- 
2.8.0.rc3

