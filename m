Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11769 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1HZNGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 09:06:22 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQJ000KXDQI5K@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Aug 2011 14:06:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQJ00KNZDQHKJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Aug 2011 14:06:18 +0100 (BST)
Date: Fri, 26 Aug 2011 15:06:05 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/5] [media] v4l: simulate old crop API using extended
 crop/compose API
In-reply-to: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1314363967-6448-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows new video drivers to work correctly with applications that
use the old-style crop API.  The old crop ioctl is simulated by using selection
callbacks.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   86 +++++++++++++++++++++++++++++++++----
 1 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 6e02b45..543405b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1696,11 +1696,31 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_g_crop)
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		if (ops->vidioc_g_crop) {
+			ret = ops->vidioc_g_crop(file, fh, p);
+		} else
+		if (ops->vidioc_g_selection) {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+				.target = V4L2_SEL_CROP_ACTIVE,
+			};
+
+			/* crop means compose for output devices */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_ACTIVE;
+
+			ret = ops->vidioc_g_selection(file, fh, &s);
+
+			/* copying results to old structure on success */
+			if (!ret)
+				p->c = s.r;
+		} else {
 			break;
+		}
 
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_g_crop(file, fh, p);
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
 		break;
@@ -1709,11 +1729,26 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_s_crop)
-			break;
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
-		ret = ops->vidioc_s_crop(file, fh, p);
+
+		if (ops->vidioc_s_crop) {
+			ret = ops->vidioc_s_crop(file, fh, p);
+		} else
+		if (ops->vidioc_s_selection) {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+				.target = V4L2_SEL_CROP_ACTIVE,
+				.r = p->c,
+			};
+
+			/* crop means compose for output devices */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_ACTIVE;
+
+			ret = ops->vidioc_s_selection(file, fh, &s);
+		}
 		break;
 	}
 	case VIDIOC_G_SELECTION:
@@ -1746,12 +1781,43 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_cropcap *p = arg;
 
-		/*FIXME: Should also show v4l2_fract pixelaspect */
-		if (!ops->vidioc_cropcap)
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+		if (ops->vidioc_cropcap) {
+			ret = ops->vidioc_cropcap(file, fh, p);
+		} else
+		if (ops->vidioc_g_selection) {
+			struct v4l2_selection s = { .type = p->type };
+			struct v4l2_rect bounds;
+
+			/* obtaining bounds */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_BOUNDS;
+			else
+				s.target = V4L2_SEL_CROP_BOUNDS;
+			ret = ops->vidioc_g_selection(file, fh, &s);
+			if (ret)
+				break;
+			bounds = s.r;
+
+			/* obtaining defrect */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_DEFAULT;
+			else
+				s.target = V4L2_SEL_CROP_DEFAULT;
+			ret = ops->vidioc_g_selection(file, fh, &s);
+			if (ret)
+				break;
+
+			/* storing results */
+			p->bounds = bounds;
+			p->defrect = s.r;
+			p->pixelaspect.numerator = 1;
+			p->pixelaspect.denominator = 1;
+		} else {
 			break;
+		}
 
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_cropcap(file, fh, p);
+		/*FIXME: Should also show v4l2_fract pixelaspect */
 		if (!ret) {
 			dbgrect(vfd, "bounds ", &p->bounds);
 			dbgrect(vfd, "defrect ", &p->defrect);
-- 
1.7.6

