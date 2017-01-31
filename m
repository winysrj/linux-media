Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44326 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdAaPuD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:50:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 03/11] media: rcar-vin: fix how pads are handled for v4l2 subdeivce operations
Date: Tue, 31 Jan 2017 16:40:08 +0100
Message-Id: <20170131154016.15526-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
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
index 7ca27599b9982ffc..610f59e2a9142622 100644
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
2.11.0

