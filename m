Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3715 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2F1Gsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 08/33] v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
Date: Thu, 28 Jun 2012 08:48:02 +0200
Message-Id: <f8f8f3836822ce90eef5088c779e38d5fa89659b.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   47 ++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 25c0a8a..78ff09f 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -359,6 +359,11 @@ static void v4l_print_framebuffer(const void *arg, bool write_only)
 			p->fmt.colorspace);
 }
 
+static void v4l_print_buftype(const void *arg, bool write_only)
+{
+	pr_cont("type=%s\n", prt_names(*(u32 *)arg, v4l2_type_names));
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -844,6 +849,18 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -903,11 +920,11 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
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
@@ -1143,30 +1160,6 @@ static long __video_do_ioctl(struct file *file,
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

