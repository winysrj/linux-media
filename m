Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1936 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2FJK0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:12 -0400
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
Subject: [RFCv1 PATCH 18/32] v4l2-ioctl.c: finalize table conversion.
Date: Sun, 10 Jun 2012 12:25:40 +0200
Message-Id: <a6aa2dd1a2275addc83150d41f131a74c7f9b977.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 0de31c4..6c91674 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -870,6 +870,11 @@ static void v4l_print_newline(const void *arg)
 	pr_cont("\n");
 }
 
+static void v4l_print_default(const void *arg)
+{
+	pr_cont("non-standard ioctl\n");
+}
+
 static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 {
 	__u32 i;
@@ -1853,12 +1858,6 @@ struct v4l2_ioctl_info {
 	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
 #define INFO_FL_CLEAR_MASK (_IOC_SIZEMASK << 16)
 
-#define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
-	.ioctl = _ioctl,					\
-	.flags = _flags,					\
-	.name = #_ioctl,					\
-}
-
 #define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
 	[_IOC_NR(_ioctl)] = {						\
 		.ioctl = _ioctl,					\
@@ -2042,12 +2041,12 @@ static long __video_do_ioctl(struct file *file,
 	} else {
 		default_info.ioctl = cmd;
 		default_info.flags = 0;
-		default_info.debug = NULL;
+		default_info.debug = v4l_print_default;
 		info = &default_info;
 	}
 
 	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
-	if (info->debug && write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
+	if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
 		v4l_print_ioctl(vfd->name, cmd);
 		pr_cont(": ");
 		info->debug(arg);
@@ -2058,22 +2057,16 @@ static long __video_do_ioctl(struct file *file,
 		const vidioc_op *vidioc = p + info->offset;
 
 		ret = (*vidioc)(file, fh, arg);
-		goto error;
 	} else if (info->flags & INFO_FL_FUNC) {
 		ret = info->func(ops, file, fh, arg);
-		goto error;
+	} else if (!ops->vidioc_default) {
+		ret = -ENOTTY;
+	} else {
+		ret = ops->vidioc_default(file, fh,
+			use_fh_prio ? v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
+			cmd, arg);
 	}
 
-	switch (cmd) {
-	default:
-		if (!ops->vidioc_default)
-			break;
-		ret = ops->vidioc_default(file, fh, use_fh_prio ?
-				v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
-				cmd, arg);
-		break;
-	} /* switch */
-
 error:
 	if (vfd->debug) {
 		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
@@ -2087,8 +2080,6 @@ error:
 			pr_cont(": error %ld\n", ret);
 		else if (vfd->debug == V4L2_DEBUG_IOCTL)
 			pr_cont("\n");
-		else if (!info->debug)
-			return ret;
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg);
 		else {
-- 
1.7.10

