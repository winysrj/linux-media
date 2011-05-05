Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28488 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1EEJkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 05:40:14 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LKP00DBKUV05D@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 May 2011 10:40:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LKP00A9OUUZ2B@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 May 2011 10:40:11 +0100 (BST)
Date: Thu, 05 May 2011 11:39:56 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] v4l: simulate old crop API using extended crop/compose API
In-reply-to: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1304588396-7557-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch allows new drivers to work correctly with
applications that use old-style crop API.
The old crop ioctl is simulated by using selection ioctls.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   85 +++++++++++++++++++++++++++++++++----
 1 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index aeef966..d0a4073 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1723,11 +1723,31 @@ static long __video_do_ioctl(struct file *file,
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
@@ -1736,11 +1756,25 @@ static long __video_do_ioctl(struct file *file,
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
+		} else {
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
+			ret = ops->vidioc_g_selection(file, fh, &s);
+		}
 		break;
 	}
 	case VIDIOC_G_SELECTION:
@@ -1773,12 +1807,43 @@ static long __video_do_ioctl(struct file *file,
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
1.7.5
