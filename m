Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46409 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbCHOlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:17 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 11/17] media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
Date: Sun,  8 Mar 2015 14:40:47 +0000
Message-Id: <1425825653-14768-12-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to return -ENODATA for *dv_timings calls
if the current output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index f97d94d..2dead84 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -487,6 +487,11 @@ static int bcap_enum_dv_timings(struct file *file, void *priv,
 				struct v4l2_enum_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	timings->pad = 0;
 
@@ -498,6 +503,11 @@ static int bcap_query_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	return v4l2_subdev_call(bcap_dev->sd, video,
 				query_dv_timings, timings);
@@ -507,6 +517,11 @@ static int bcap_g_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
 
 	*timings = bcap_dev->dv_timings;
 	return 0;
@@ -516,7 +531,13 @@ static int bcap_s_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
 	int ret;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_DV_TIMINGS))
+		return -ENODATA;
+
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
-- 
2.1.0

