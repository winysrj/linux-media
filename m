Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36645 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbcGVJJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 05:09:43 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v6 4/4] rcar-vin: implement EDID control ioctls
Date: Fri, 22 Jul 2016 11:09:14 +0200
Message-Id: <1469178554-20719-5-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds G_EDID and S_EDID.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 33 +++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 396eabc..57e040c 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -661,6 +661,36 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 	return ret;
 }
 
+static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int input, ret;
+
+	input = edid->pad;
+	edid->pad = vin->inputs[input].sink_idx;
+
+	ret = rvin_subdev_call(vin, pad, get_edid, edid);
+
+	edid->pad = input;
+
+	return ret;
+}
+
+static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int input, ret;
+
+	input = edid->pad;
+	edid->pad = vin->inputs[input].sink_idx;
+
+	ret = rvin_subdev_call(vin, pad, set_edid, edid);
+
+	edid->pad = input;
+
+	return ret;
+}
+
 static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_querycap		= rvin_querycap,
 	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
@@ -683,6 +713,9 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_s_dv_timings		= rvin_s_dv_timings,
 	.vidioc_query_dv_timings	= rvin_query_dv_timings,
 
+	.vidioc_g_edid			= rvin_g_edid,
+	.vidioc_s_edid			= rvin_s_edid,
+
 	.vidioc_querystd		= rvin_querystd,
 	.vidioc_g_std			= rvin_g_std,
 	.vidioc_s_std			= rvin_s_std,
-- 
2.7.4

