Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1648 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2F1Gsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 17/33] v4l2-ioctl.c: finalize table conversion.
Date: Thu, 28 Jun 2012 08:48:11 +0200
Message-Id: <f4edbe5fc5ca336038f741e507c55847f922984f.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement the default case which finalizes the table conversion and allows
us to remove the last part of the switch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 74fe6a2..9ded54b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -855,6 +855,11 @@ static void v4l_print_newline(const void *arg, bool write_only)
 	pr_cont("\n");
 }
 
+static void v4l_print_default(const void *arg, bool write_only)
+{
+	pr_cont("driver-specific ioctl\n");
+}
+
 static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 {
 	__u32 i;
@@ -1839,12 +1844,6 @@ struct v4l2_ioctl_info {
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
@@ -2028,12 +2027,12 @@ static long __video_do_ioctl(struct file *file,
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
 		info->debug(arg, write_only);
@@ -2044,22 +2043,16 @@ static long __video_do_ioctl(struct file *file,
 		const vidioc_op *vidioc = p + info->offset;
 
 		ret = (*vidioc)(file, fh, arg);
-		goto done;
 	} else if (info->flags & INFO_FL_FUNC) {
 		ret = info->func(ops, file, fh, arg);
-		goto done;
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
 done:
 	if (vfd->debug) {
 		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
@@ -2073,8 +2066,6 @@ done:
 			pr_cont(": error %ld\n", ret);
 		else if (vfd->debug == V4L2_DEBUG_IOCTL)
 			pr_cont("\n");
-		else if (!info->debug)
-			return ret;
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg, write_only);
 		else {
-- 
1.7.10

