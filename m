Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60839 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932965AbcIPK51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/8] cobalt: add cropcap support
Date: Fri, 16 Sep 2016 12:57:09 +0200
Message-Id: <1474023431-32533-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
References: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the timings contain picture aspect ratio information, we can support
cropcap to return the pixel aspect ratio.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 5c76637..3fea246 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1084,12 +1084,33 @@ static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	return 0;
 }
 
+static int cobalt_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cc)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_dv_timings timings;
+	int err = 0;
+
+	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (s->input == 1)
+		timings = cea1080p60;
+	else
+		err = v4l2_subdev_call(s->sd, video, g_dv_timings, &timings);
+	if (!err) {
+		cc->bounds.width = cc->defrect.width = timings.bt.width;
+		cc->bounds.height = cc->defrect.height = timings.bt.height;
+		cc->pixelaspect = v4l2_dv_timings_aspect_ratio(&timings);
+	}
+	return err;
+}
+
 static const struct v4l2_ioctl_ops cobalt_ioctl_ops = {
 	.vidioc_querycap		= cobalt_querycap,
 	.vidioc_g_parm			= cobalt_g_parm,
 	.vidioc_log_status		= cobalt_log_status,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
+	.vidioc_cropcap			= cobalt_cropcap,
 	.vidioc_enum_input		= cobalt_enum_input,
 	.vidioc_g_input			= cobalt_g_input,
 	.vidioc_s_input			= cobalt_s_input,
-- 
2.8.1

