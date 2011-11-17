Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47221 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab1KQKML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:12:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUS00IRQV09CX40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 10:12:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUS00K4KV09TG@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 10:12:09 +0000 (GMT)
Date: Thu, 17 Nov 2011 11:12:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] m5mols: Fix set_fmt to return proper pixel format code
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1321524723-18487-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case pixel format is modified in set_fmt by the driver,
the changes are not propagated back to the caller. Fix this
by adjusting passed  data for TRY and ACTIVE format.

Also remove redundant pixel format code information from
struct m5mols_info, it's already available in 'ffmt' array.
Remove pad number validation in set/get_fmt, this is already
done in the core.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |    2 --
 drivers/media/video/m5mols/m5mols_core.c |   20 ++++++++------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 89d09a8..82c8817 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -162,7 +162,6 @@ struct m5mols_version {
  * @pad: media pad
  * @ffmt: current fmt according to resolution type
  * @res_type: current resolution type
- * @code: current code
  * @irq_waitq: waitqueue for the capture
  * @work_irq: workqueue for the IRQ
  * @flags: state variable for the interrupt handler
@@ -192,7 +191,6 @@ struct m5mols_info {
 	struct media_pad pad;
 	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
 	int res_type;
-	enum v4l2_mbus_pixelcode code;
 	wait_queue_head_t irq_waitq;
 	struct work_struct work_irq;
 	unsigned long flags;
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 5d21d05..68497f8 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -510,9 +510,6 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct m5mols_info *info = to_m5mols(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	if (fmt->pad != 0)
-		return -EINVAL;
-
 	format = __find_format(info, fh, fmt->which, info->res_type);
 	if (!format)
 		return -EINVAL;
@@ -531,9 +528,6 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	u32 resolution = 0;
 	int ret;
 
-	if (fmt->pad != 0)
-		return -EINVAL;
-
 	ret = __find_resolution(sd, format, &type, &resolution);
 	if (ret < 0)
 		return ret;
@@ -542,13 +536,14 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (!sfmt)
 		return 0;
 
-	*sfmt		= m5mols_default_ffmt[type];
-	sfmt->width	= format->width;
-	sfmt->height	= format->height;
+
+	format->code = m5mols_default_ffmt[type].code;
+	format->colorspace = V4L2_COLORSPACE_JPEG;
+	format->field = V4L2_FIELD_NONE;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		*sfmt = *format;
 		info->resolution = resolution;
-		info->code = format->code;
 		info->res_type = type;
 	}
 
@@ -625,13 +620,14 @@ static int m5mols_start_monitor(struct m5mols_info *info)
 static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct m5mols_info *info = to_m5mols(sd);
+	u32 code = info->ffmt[info->res_type].code;
 
 	if (enable) {
 		int ret = -EINVAL;
 
-		if (is_code(info->code, M5MOLS_RESTYPE_MONITOR))
+		if (is_code(code, M5MOLS_RESTYPE_MONITOR))
 			ret = m5mols_start_monitor(info);
-		if (is_code(info->code, M5MOLS_RESTYPE_CAPTURE))
+		if (is_code(code, M5MOLS_RESTYPE_CAPTURE))
 			ret = m5mols_start_capture(info);
 
 		return ret;
-- 
1.7.7.2

