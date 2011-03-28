Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62214 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1C1PU3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 11:20:29 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LIR008NIX9ZG0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Mar 2011 16:20:23 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LIR001S9X9YDR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Mar 2011 16:20:23 +0100 (BST)
Date: Mon, 28 Mar 2011 17:19:56 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] v4l: simulate old crop API using extcrop/compose
In-reply-to: <1301325596-18166-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1301325596-18166-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1301325596-18166-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch allows new drivers to work correctly with
applications that use old-style crop API.
The old crop ioctl is simulated by using extcrop/compose.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |   46 ++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 3f69218..a2b0b27 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1725,11 +1725,27 @@ static long __video_do_ioctl(struct file *file,
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
+			struct v4l2_selection s = { .type = p->type };
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
+			if (ret == 0)
+				p->c = s.r;
+		}
+
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
 		break;
@@ -1738,11 +1754,27 @@ static long __video_do_ioctl(struct file *file,
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
-- 
1.7.4.1
