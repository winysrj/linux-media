Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53737 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1HaMaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:30:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQS00DKHLDZ9H30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:30:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQS001VBLBZ5Z@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:28:48 +0100 (BST)
Date: Wed, 31 Aug 2011 14:28:22 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/4] v4l: emulate old crop API using extended crop/compose API
In-reply-to: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Message-id: <1314793703-32345-4-git-send-email-t.stanislaws@samsung.com>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows new video drivers to work correctly with applications that
use the old-style crop API.  The old crop ioctl is emulated by using selection
callbacks.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   86 ++++++++++++++++++++++++++++++++-----
 1 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 6e02b45..bb99c71 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1696,11 +1696,29 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_g_crop)
-			break;
-
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_g_crop(file, fh, p);
+
+		if (ops->vidioc_g_crop) {
+			ret = ops->vidioc_g_crop(file, fh, p);
+		} else if (ops->vidioc_g_selection) {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+			};
+
+			/* crop means compose for output devices */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_ACTIVE;
+			else
+				s.target = V4L2_SEL_CROP_ACTIVE;
+
+			ret = ops->vidioc_g_selection(file, fh, &s);
+
+			/* copying results to old structure on success */
+			if (!ret)
+				p->c = s.r;
+		}
+
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
 		break;
@@ -1709,11 +1727,26 @@ static long __video_do_ioctl(struct file *file,
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
+		} else if (ops->vidioc_s_selection) {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+				.r = p->c,
+			};
+
+			/* crop means compose for output devices */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_ACTIVE;
+			else
+				s.target = V4L2_SEL_CROP_ACTIVE;
+
+			ret = ops->vidioc_s_selection(file, fh, &s);
+		}
 		break;
 	}
 	case VIDIOC_G_SELECTION:
@@ -1746,12 +1779,41 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_cropcap *p = arg;
 
-		/*FIXME: Should also show v4l2_fract pixelaspect */
-		if (!ops->vidioc_cropcap)
-			break;
-
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_cropcap(file, fh, p);
+		if (ops->vidioc_cropcap) {
+			ret = ops->vidioc_cropcap(file, fh, p);
+		} else
+		if (ops->vidioc_g_selection) {
+			struct v4l2_selection s = { .type = p->type };
+
+			/* obtaining bounds */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_BOUNDS;
+			else
+				s.target = V4L2_SEL_CROP_BOUNDS;
+
+			ret = ops->vidioc_g_selection(file, fh, &s);
+			if (ret)
+				break;
+			p->bounds = s.r;
+
+			/* obtaining defrect */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				s.target = V4L2_SEL_COMPOSE_DEFAULT;
+			else
+				s.target = V4L2_SEL_CROP_DEFAULT;
+
+			ret = ops->vidioc_g_selection(file, fh, &s);
+			if (ret)
+				break;
+			p->defrect = s.r;
+
+			/* setting trivial pixelaspect */
+			p->pixelaspect.numerator = 1;
+			p->pixelaspect.denominator = 1;
+		}
+
+		/*FIXME: Should also show v4l2_fract pixelaspect */
 		if (!ret) {
 			dbgrect(vfd, "bounds ", &p->bounds);
 			dbgrect(vfd, "defrect ", &p->defrect);
-- 
1.7.6

