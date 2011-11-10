Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17600 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1KJLxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 06:53:45 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUG007LK11JNO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUG00AO511IX3@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Date: Thu, 10 Nov 2011 12:53:34 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/5] v4l: emulate old crop API using extended crop/compose API
In-reply-to: <1320926015-5841-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	mchehab@redhat.com
Message-id: <1320926015-5841-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320926015-5841-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows new video drivers to work correctly with applications that
use the old-style crop API.  The old crop ioctl is emulated by using selection
callbacks.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   82 +++++++++++++++++++++++++++++++++++---
 1 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index f3b0faf..d9cef24 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1549,11 +1549,32 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_g_crop)
+		if (!ops->vidioc_g_crop && !ops->vidioc_g_selection)
 			break;
 
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_g_crop(file, fh, p);
+
+		if (ops->vidioc_g_crop) {
+			ret = ops->vidioc_g_crop(file, fh, p);
+		} else {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+			};
+
+			/* crop means compose for output devices */
+			if (V4L2_TYPE_IS_OUTPUT(p->type))
+				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+			else
+				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
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
@@ -1562,15 +1583,33 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_s_crop)
+		if (!ops->vidioc_s_crop && !ops->vidioc_s_selection)
 			break;
+
 		if (ret_prio) {
 			ret = ret_prio;
 			break;
 		}
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
-		ret = ops->vidioc_s_crop(file, fh, p);
+
+		if (ops->vidioc_s_crop) {
+			ret = ops->vidioc_s_crop(file, fh, p);
+		} else {
+			/* simulate capture crop using selection api */
+			struct v4l2_selection s = {
+				.type = p->type,
+				.r = p->c,
+			};
+
+			/* crop means compose for output devices */
+			if (V4L2_TYPE_IS_OUTPUT(p->type))
+				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+			else
+				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+
+			ret = ops->vidioc_s_selection(file, fh, &s);
+		}
 		break;
 	}
 	case VIDIOC_G_SELECTION:
@@ -1610,11 +1649,42 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_cropcap *p = arg;
 
 		/*FIXME: Should also show v4l2_fract pixelaspect */
-		if (!ops->vidioc_cropcap)
+		if (!ops->vidioc_cropcap && !ops->vidioc_g_selection)
 			break;
 
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_cropcap(file, fh, p);
+		if (ops->vidioc_cropcap) {
+			ret = ops->vidioc_cropcap(file, fh, p);
+		} else {
+			struct v4l2_selection s = { .type = p->type };
+
+			/* obtaining bounds */
+			if (V4L2_TYPE_IS_OUTPUT(p->type))
+				s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
+			else
+				s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+
+			ret = ops->vidioc_g_selection(file, fh, &s);
+			if (ret)
+				break;
+			p->bounds = s.r;
+
+			/* obtaining defrect */
+			if (V4L2_TYPE_IS_OUTPUT(p->type))
+				s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
+			else
+				s.target = V4L2_SEL_TGT_CROP_DEFAULT;
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
 		if (!ret) {
 			dbgrect(vfd, "bounds ", &p->bounds);
 			dbgrect(vfd, "defrect ", &p->defrect);
-- 
1.7.5.4

