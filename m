Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33424 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965210AbcKLNNl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:41 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 05/32] media: rcar-vin: fix how pads are handled for v4l2 subdeivce operations
Date: Sat, 12 Nov 2016 14:11:49 +0100
Message-Id: <20161112131216.22635-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar-vin driver only uses one pad, pad number 0.

 All v4l2 operations which did not check that the requested operation
 was for pad 0 have been updated with a check to enforce this.

 All v4l2 operations that stored (and later restore) the requested pad
 before substituting it for the subdeivce pad number have been update
 not store the incoming pad and simply restore it to 0 after the
 subdevice operation is complete.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 7ca2759..610f59e 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -550,14 +550,16 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
+	int ret;
+
+	if (timings->pad)
+		return -EINVAL;
 
-	pad = timings->pad;
 	timings->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
 
-	timings->pad = pad;
+	timings->pad = 0;
 
 	return ret;
 }
@@ -600,14 +602,16 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
+	int ret;
+
+	if (cap->pad)
+		return -EINVAL;
 
-	pad = cap->pad;
 	cap->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
 
-	cap->pad = pad;
+	cap->pad = 0;
 
 	return ret;
 }
@@ -616,17 +620,16 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int input, ret;
+	int ret;
 
 	if (edid->pad)
 		return -EINVAL;
 
-	input = edid->pad;
 	edid->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
 
-	edid->pad = input;
+	edid->pad = 0;
 
 	return ret;
 }
@@ -635,17 +638,16 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int input, ret;
+	int ret;
 
 	if (edid->pad)
 		return -EINVAL;
 
-	input = edid->pad;
 	edid->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
 
-	edid->pad = input;
+	edid->pad = 0;
 
 	return ret;
 }
-- 
2.10.2

