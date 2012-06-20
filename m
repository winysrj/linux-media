Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60879 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2FTONK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 10:13:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: Default to the selection API to implement capture crop
Date: Wed, 20 Jun 2012 16:13:20 +0200
Message-Id: <1340201600-20814-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the selection API is implemented by the driver, simulate the
capture crop API using selection rectangles. Fall back to the capture
crop API when the selection operation isn't provided (NULL pointer) or
not supported (returns -ENOTTY).

Whether the selection API is supported depends on the host driver but
also on the subdevs. If a host driver needs to use both selection-aware
and crop-only subdevs, it will need to provide both selection and crop
operation handlers. Falling back to the crop API when the selection
operation return -ENOTTY is then needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-ioctl.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 31fc2ad..46b4be7 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1477,10 +1477,10 @@ static long __video_do_ioctl(struct file *file,
 
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 
-		if (ops->vidioc_g_crop) {
-			ret = ops->vidioc_g_crop(file, fh, p);
-		} else {
-			/* simulate capture crop using selection api */
+		if (ops->vidioc_g_selection) {
+			/* Simulate capture crop using selection API when
+			 * available.
+			 */
 			struct v4l2_selection s = {
 				.type = p->type,
 			};
@@ -1498,6 +1498,12 @@ static long __video_do_ioctl(struct file *file,
 				p->c = s.r;
 		}
 
+		if (ret == -ENOTTY && ops->vidioc_g_crop)
+			/* If vidioc_g_selection isn't provided or is not
+			 * supported, fall back to vidioc_g_crop.
+			 */
+			ret = ops->vidioc_g_crop(file, fh, p);
+
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
 		break;
@@ -1509,10 +1515,10 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
 
-		if (ops->vidioc_s_crop) {
-			ret = ops->vidioc_s_crop(file, fh, p);
-		} else {
-			/* simulate capture crop using selection api */
+		if (ops->vidioc_s_selection) {
+			/* Simulate capture crop using selection API when
+			 * available.
+			 */
 			struct v4l2_selection s = {
 				.type = p->type,
 				.r = p->c,
@@ -1526,6 +1532,12 @@ static long __video_do_ioctl(struct file *file,
 
 			ret = ops->vidioc_s_selection(file, fh, &s);
 		}
+
+		if (ret == -ENOTTY && ops->vidioc_s_crop)
+			/* If vidioc_s_selection isn't provided or is not
+			 * supported, fall back to vidioc_s_crop.
+			 */
+			ret = ops->vidioc_s_crop(file, fh, p);
 		break;
 	}
 	case VIDIOC_G_SELECTION:
-- 
Regards,

Laurent Pinchart

