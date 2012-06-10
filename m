Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2937 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2FJK0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:22 -0400
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
Subject: [RFCv1 PATCH 09/32] v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
Date: Sun, 10 Jun 2012 12:25:31 +0200
Message-Id: <b66c72eded7f26bab3409bba9f83dbaba1db10be.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   47 ++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 48852ca..7d093ca 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -367,6 +367,11 @@ static void v4l_print_framebuffer(const void *arg)
 			p->fmt.colorspace);
 }
 
+static void v4l_print_buftype(const void *arg)
+{
+	pr_cont("type=%s\n", prt_names(*(u32 *)arg, v4l2_type_names));
+}
+
 static void v4l_print_u32(const void *arg)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -852,6 +857,18 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	return -EINVAL;
 }
 
+static int v4l_streamon(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_streamon(file, fh, *(unsigned int *)arg);
+}
+
+static int v4l_streamoff(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_streamoff(file, fh, *(unsigned int *)arg);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -911,11 +928,11 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_QUERYBUF, INFO_FL_CLEAR(v4l2_buffer, length)),
 	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QBUF, 0),
 	IOCTL_INFO(VIDIOC_DQBUF, 0),
-	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_PARM, INFO_FL_CLEAR(v4l2_streamparm, type)),
 	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_STD, 0),
@@ -1151,30 +1168,6 @@ static long __video_do_ioctl(struct file *file,
 			dbgbuf(cmd, vfd, p);
 		break;
 	}
-	case VIDIOC_OVERLAY:
-	{
-		int *i = arg;
-
-		dbgarg(cmd, "value=%d\n", *i);
-		ret = ops->vidioc_overlay(file, fh, *i);
-		break;
-	}
-	case VIDIOC_STREAMON:
-	{
-		enum v4l2_buf_type i = *(int *)arg;
-
-		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
-		ret = ops->vidioc_streamon(file, fh, i);
-		break;
-	}
-	case VIDIOC_STREAMOFF:
-	{
-		enum v4l2_buf_type i = *(int *)arg;
-
-		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
-		ret = ops->vidioc_streamoff(file, fh, i);
-		break;
-	}
 	/* ---------- tv norms ---------- */
 	case VIDIOC_ENUMSTD:
 	{
-- 
1.7.10

