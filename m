Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26946 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab1DFIqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 04:46:02 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJ800JHB2Y6RB@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJ80042N2Y4J4@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:29 +0100 (BST)
Date: Wed, 06 Apr 2011 10:44:19 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] v4l: simulate old crop API using extcrop/compose
In-reply-to: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com
Message-id: <1302079459-4018-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch allows new drivers to work correctly with
applications that use old-style crop API.
The old crop ioctl is simulated by using extcrop/compose.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   94 +++++++++++++++++++++++++++++++++-----
 1 files changed, 82 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 3f69218..1e7d18d 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1725,11 +1725,30 @@ static long __video_do_ioctl(struct file *file,
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
+		} else {
+			struct v4l2_selection s = {
+				.type = p->type,
+				.target = V4L2_SEL_TARGET_ACTIVE,
+			};
+			/* simulate capture crop using extcrop */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE
+				&& ops->vidioc_g_extcrop) {
+				ret = ops->vidioc_g_extcrop(file, fh, &s);
+			}
+			/* simulate output crop using compose */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
+				&& ops->vidioc_g_compose) {
+				ret = ops->vidioc_g_compose(file, fh, &s);
+			}
+			/* copying results to old structure */
+			if (!ret)
+				p->c = s.r;
+		}
+
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
 		break;
@@ -1738,11 +1757,28 @@ static long __video_do_ioctl(struct file *file,
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
+			struct v4l2_selection s = {
+				.type = p->type,
+				.target = V4L2_SEL_TARGET_ACTIVE,
+				.r = p->c,
+			};
+			/* simulate capture crop using extcrop */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE
+				&& ops->vidioc_s_extcrop) {
+				ret = ops->vidioc_s_extcrop(file, fh, &s);
+			}
+			/* simulate output crop using compose */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
+				&& ops->vidioc_s_compose) {
+				ret = ops->vidioc_s_compose(file, fh, &s);
+			}
+		}
 		break;
 	}
 	case VIDIOC_G_EXTCROP:
@@ -1801,12 +1837,46 @@ static long __video_do_ioctl(struct file *file,
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
+		} else {
+			struct v4l2_selection s = { .type = p->type };
+			int (*func)(struct file *file, void *fh,
+				struct v4l2_selection *a) = NULL;
+			struct v4l2_rect bounds;
+
+			/* simulate capture crop using extcrop */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+				func = ops->vidioc_g_extcrop;
+			/* simulate output crop using compose */
+			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				func = ops->vidioc_g_compose;
+			/* leave if cropcap can not be simulated */
+			if (func == NULL)
+				break;
+
+			/* obtaining bounds */
+			s.target = V4L2_SEL_TARGET_BOUNDS;
+			ret = func(file, fh, &s);
+			if (ret)
+				break;
+			bounds = s.r;
+
+			/* obtaining defrect */
+			s.target = V4L2_SEL_TARGET_DEFAULT;
+			ret = func(file, fh, &s);
+			if (ret)
+				break;
+
+			/* storing results */
+			p->bounds = bounds;
+			p->defrect = s.r;
+			p->pixelaspect.numerator = 1;
+			p->pixelaspect.denominator = 1;
+		}
+
+		/*FIXME: Should also show v4l2_fract pixelaspect */
 		if (!ret) {
 			dbgrect(vfd, "bounds ", &p->bounds);
 			dbgrect(vfd, "defrect ", &p->defrect);
-- 
1.7.4.2
